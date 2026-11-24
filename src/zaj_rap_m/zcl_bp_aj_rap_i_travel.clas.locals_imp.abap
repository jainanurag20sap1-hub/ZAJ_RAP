CLASS lhc_ZAJ_RAP_I_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zaj_rap_i_travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zaj_rap_i_travel RESULT result.

    METHODS earlynumbering_cba_booking FOR NUMBERING
       entities FOR CREATE zaj_rap_i_travel\_booking.

    METHODS earlynumbering_create FOR NUMBERING
       entities FOR CREATE zaj_rap_i_travel.

ENDCLASS.

CLASS lhc_ZAJ_RAP_I_TRAVEL IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    TRY.

        DATA(lt_entities) = entities.
        DELETE lt_entities WHERE TravelId IS NOT INITIAL.

        "Get next number from number range object
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
          IMPORTING
            returned_quantity = DATA(lv_quantity)
            number            = DATA(lv_number)
            returncode        = DATA(lv_return_code)
          EXCEPTIONS
            OTHERS            = 1
        ).


        LOOP AT lt_entities INTO DATA(ls_entities).

          APPEND INITIAL LINE TO mapped-zaj_rap_i_travel ASSIGNING FIELD-SYMBOL(<ls_entitiesmapped>).
          <ls_entitiesmapped>-%cid = ls_entities-%cid.
          <ls_entitiesmapped>-TravelId =  lv_number - lv_quantity + sy-tabix.

        ENDLOOP.

      CATCH cx_root INTO DATA(lx_rooterror).
        "Handle exception
        LOOP AT lt_entities INTO ls_entities.

          APPEND INITIAL LINE TO failed-zaj_rap_i_travel ASSIGNING FIELD-SYMBOL(<ls_entitiesfailed>).
          <ls_entitiesfailed>-%cid = ls_entities-%cid.
          <ls_entitiesfailed>-%key =  ls_entities-%key.

          APPEND INITIAL LINE TO reported-zaj_rap_i_travel ASSIGNING FIELD-SYMBOL(<ls_entitiesreported>).
          <ls_entitiesreported>-%cid = ls_entities-%cid.
          <ls_entitiesreported>-%key =  ls_entities-%key.
          <ls_entitiesreported>-%msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lx_rooterror->get_text( ) ).

        ENDLOOP.

    ENDTRY.

  ENDMETHOD.


  METHOD earlynumbering_cba_Booking.

    TRY.

        "Read the corresponding link entities from database [Source - Travel, Target - Booking]
        READ ENTITIES OF zaj_rap_i_travel IN LOCAL MODE
        ENTITY zaj_rap_i_travel BY \_Booking
        ALL FIELDS WITH CORRESPONDING #( entities )
        LINK DATA(lt_travel_booking_link).

        LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>)
                GROUP BY ( travelid = <ls_entities>-TravelId ).

          DATA(lv_max_db_booking) = CONV /dmo/booking_id( 0 ).

          "Get the maximum booking id from the database for the current travel id
          lv_max_db_booking = REDUCE /dmo/booking_id(
									INIT lv_max_db_booking_temp = CONV /dmo/booking_id( 0 )
									FOR <ls_entities_booking_link> IN lt_travel_booking_link USING KEY entity
									     WHERE ( source-TravelId = <ls_entities>-TravelId )
									NEXT lv_max_db_booking_temp = COND /dmo/booking_id(
																		  WHEN lv_max_db_booking_temp > <ls_entities_booking_link>-target-BookingId
																		  THEN lv_max_db_booking_temp
																		  ELSE <ls_entities_booking_link>-target-BookingId
																		  )
													   ).
          "Get the maximum booking id (Draft mode) from the current travel id for the current travel id
          DATA(lv_max_current_bookings) = REDUCE /dmo/booking_id(
          									INIT lv_max_current_bookings_temp = lv_max_db_booking
          									FOR ls_entities_draft_bookings IN entities USING KEY entity
          									   WHERE ( TravelId = <ls_entities>-TravelId )
          									   FOR ls_entities_curr_booking IN ls_entities_draft_bookings-%target USING KEY entity
          									   NEXT lv_max_current_bookings_temp = COND /dmo/booking_id(
            		  																  WHEN lv_max_current_bookings_temp > ls_entities_curr_booking-BookingId
            		  																  THEN lv_max_current_bookings_temp
            		  																  ELSE ls_entities_curr_booking-BookingId
		  																		  )
		  															   ).


          LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_entities_new_booking>)
              WHERE BookingId IS INITIAL.

            lv_max_current_bookings += 10.
            "Assign the booking id to the current booking entity where booking id is initial
            APPEND CORRESPONDING #( <ls_entities_new_booking> ) TO mapped-zaj_rap_i_booking ASSIGNING FIELD-SYMBOL(<lfs_new_mapped_booking>).
            <lfs_new_mapped_booking>-BookingId = lv_max_current_bookings.

          ENDLOOP.

        ENDLOOP.

      CATCH cx_root INTO DATA(lx_rooterror).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.

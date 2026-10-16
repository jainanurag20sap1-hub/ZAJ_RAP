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
          nr_range_nr = '01'
            object = '/DMO/TRV_M'
          IMPORTING
            returned_quantity = DATA(lv_quantity)
            number = DATA(lv_number)
            returncode = DATA(lv_return_code)
          EXCEPTIONS
            OTHERS = 1
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
                                                              text = lx_rooterror->get_text( ) ).

        ENDLOOP.

    ENDTRY.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
  ENDMETHOD.

ENDCLASS.

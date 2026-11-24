CLASS zcl_aj_rap_entity_reader DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_aj_rap_entity_reader IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


* Read entities using READ ENTITIES OF
    READ ENTITIES OF zaj_rap_i_travel

    ENTITY zaj_rap_i_travel
    FIELDS ( AgencyId BeginDate CreatedAt )
    WITH VALUE #(
      ( TravelId = '00000009' )
    )
    RESULT DATA(lt_travel_entity_result)

    ENTITY zaj_rap_i_travel BY \_Booking
    FIELDS ( BookingDate BookingId BookingStatus CarrierId )
    WITH VALUE #(
      ( TravelId = '00000009' )
    )
    RESULT DATA(lt_booking_entity_result).

*    IF lt_travel_entity_result IS NOT INITIAL.
*      out->write( lt_travel_entity_result ).
*    ENDIF.

*    IF lt_booking_entity_result IS NOT INITIAL.
*      out->write( lt_booking_entity_result ).
*    ENDIF.


* Read entities using READ ENTITIES OPERATIONS
    DATA: lt_operations                  TYPE abp_behv_retrievals_tab,
          lt_travel_entity_read_oper     TYPE TABLE FOR READ IMPORT zaj_rap_i_travel,
          lt_travel_entity_res_oper      TYPE TABLE FOR READ RESULT zaj_rap_i_travel,

          lt_booking_entity_read_oper    TYPE TABLE FOR READ IMPORT zaj_rap_i_travel\_Booking,
          lt_booking_entity_res_oper     TYPE TABLE FOR READ RESULT zaj_rap_i_travel\_Booking,

          lt_bookingsup_entity_read_oper TYPE TABLE FOR READ IMPORT zaj_rap_i_booking\_BookingSuppl,
          lt_bookingsup_entity_res_oper  TYPE TABLE FOR READ RESULT zaj_rap_i_booking\_BookingSuppl.


    lt_travel_entity_read_oper = VALUE #( ( %key-TravelId = '00000011'
                                            %control      = VALUE #( travelId  = if_abap_behv=>mk-on
                                                                     AgencyId  = if_abap_behv=>mk-on
                                                                     BeginDate = if_abap_behv=>mk-on
                                                                     CreatedAt = if_abap_behv=>mk-on
                                                              )
                                          ) ).

    lt_booking_entity_read_oper = VALUE #( ( %key-TravelId = '00000011'
                                             %control      = VALUE #( BookingDate = if_abap_behv=>mk-on
                                                                      BookingId   = if_abap_behv=>mk-on
                                                                      travelId    = if_abap_behv=>mk-on
                                                               )
                                           ) ).

    lt_bookingsup_entity_read_oper = VALUE #( ( %key-TravelId = '00000097' %key-BookingId = '0001'
                                                %control      = VALUE #( BookingId           = if_abap_behv=>mk-on
                                                                         BookingSupplementId = if_abap_behv=>mk-on
                                                                         SupplementId        = if_abap_behv=>mk-on
                                                                  )
                                              ) ).


    APPEND VALUE #( op          = if_abap_behv=>op-r-read
                    entity_name = 'ZAJ_RAP_I_TRAVEL'
                    instances   = REF #( lt_travel_entity_read_oper )
                    results     = REF #( lt_travel_entity_res_oper )
                  ) TO lt_operations.

    APPEND VALUE #( op          = if_abap_behv=>op-r-read_ba
                    entity_name = 'ZAJ_RAP_I_TRAVEL'
                    sub_name    = '_BOOKING'
                    instances   = REF #( lt_booking_entity_read_oper )
                    full        = abap_true
                    results     = REF #( lt_booking_entity_res_oper )
                  ) TO lt_operations.

    APPEND VALUE #( op          = if_abap_behv=>op-r-read_ba
                    entity_name = 'ZAJ_RAP_I_BOOKING'
                    sub_name    = '_BOOKINGSUPPL'
                    instances   = REF #( lt_bookingsup_entity_read_oper )
                    full        = abap_true
                    results     = REF #( lt_bookingsup_entity_res_oper )
                  ) TO lt_operations.

    READ ENTITIES OPERATIONS lt_operations
        FAILED DATA(lt_entity_read_oper_failed).

    "Read entities using READ ENTITIES OPERATIONS FAILED
    IF lt_entity_read_oper_failed IS NOT INITIAL.
      out->write( 'Dynamic read failed' ).
    ELSE.
      "Travel Entity results
      IF NOT lt_travel_entity_res_oper IS INITIAL.
        out->write( 'Travel data successfully retrieved' ).
        out->write( lt_travel_entity_res_oper ).
      ENDIF.
      "Booking Entity results
      IF NOT lt_booking_entity_res_oper IS INITIAL.
        out->write( 'Booking data successfully retrieved' ).
        out->write( lt_booking_entity_res_oper ).
      ENDIF.
      "Booking Supplement Entity results
      IF NOT lt_bookingsup_entity_res_oper IS INITIAL.
        out->write( 'Booking Supplement data successfully retrieved' ).
        out->write( lt_bookingsup_entity_res_oper ).
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.

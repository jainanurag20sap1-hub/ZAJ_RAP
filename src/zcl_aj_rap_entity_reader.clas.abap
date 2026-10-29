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
    DATA: lt_operations             TYPE abp_behv_retrievals_tab,
          lt_travel_entity_read2    TYPE TABLE FOR READ IMPORT zaj_rap_i_travel,
          lt_travel_entity_result2  TYPE TABLE FOR READ RESULT zaj_rap_i_travel,
          lt_booking_entity_read2   TYPE TABLE FOR READ IMPORT zaj_rap_i_travel\\zaj_rap_i_booking,
          lt_booking_entity_result2 TYPE TABLE FOR READ RESULT zaj_rap_i_travel\\zaj_rap_i_booking.


    lt_travel_entity_read2 = VALUE #( ( %key-TravelId = '00000011' ) ).
    lt_booking_entity_read2 = VALUE #( ( %key-TravelId = '00000011'
                                         %key-BookingId = '0001'
                                        ) ).


    APPEND VALUE #( op = if_abap_behv=>op-r-read
                    entity_name = 'ZAJ_RAP_I_TRAVEL'
                    instances = REF #( lt_travel_entity_read2 )
                    results = REF #( lt_travel_entity_result2 )
                  ) TO lt_operations.

*    APPEND VALUE #( op = if_abap_behv=>op-r-read_ba
*                        entity_name = 'ZAJ_RAP_I_TRAVEL'
*                        sub_name = 'ZAJ_RAP_I_BOOKING'
*                        instances = REF #( lt_travel_entity_read2 )
*                        full = abap_true
*                        results = REF #( lt_booking_entity_result2 )
*                      ) TO lt_operations.

    READ ENTITIES OPERATIONS lt_operations
      FAILED  DATA(lt_failed).
*      MAPPED data(lt_mapped)
*      REPORTED data(lt_reported).

    IF lt_failed IS NOT INITIAL.
      out->write( lt_failed ).
    ENDIF.

*    IF lt_reported IS NOT INITIAL.
*      out->write( lt_reported ).
*    ENDIF.

  ENDMETHOD.
ENDCLASS.

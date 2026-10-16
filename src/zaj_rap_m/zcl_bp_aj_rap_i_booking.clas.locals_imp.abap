CLASS lhc_zaj_rap_i_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
       entities FOR CREATE zaj_rap_i_booking\_Bookingsuppl.

ENDCLASS.

CLASS lhc_zaj_rap_i_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.

    DATA(lt_booking_entities) = entities.
    DELETE lt_booking_entities WHERE BookingId IS NOT INITIAL.

*        cl_numberrange_runtime


  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


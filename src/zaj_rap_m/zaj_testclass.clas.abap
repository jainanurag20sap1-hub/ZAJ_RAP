CLASS zaj_testclass DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    METHODS get_data
      RETURNING
        VALUE(lw_data) TYPE cl_abap_context_info=>ty_system_date.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS lw_welcome TYPE string VALUE 'Hello World' ##NO_TEXT.

ENDCLASS.



CLASS zaj_testclass IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    out->write( lw_welcome ).
  ENDMETHOD.

  METHOD get_data.
    lw_data = cl_abap_context_info=>get_system_date( ).
  ENDMETHOD.

ENDCLASS.

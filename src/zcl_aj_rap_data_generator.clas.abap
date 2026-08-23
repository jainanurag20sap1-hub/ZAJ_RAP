CLASS zcl_aj_rap_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.



CLASS ZCL_AJ_RAP_DATA_GENERATOR IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_travel TYPE STANDARD TABLE OF zaj_rap_travel_m WITH EMPTY KEY.
    DATA lt_book   TYPE STANDARD TABLE OF zaj_rap_bookin_m   WITH EMPTY KEY.
    DATA lt_suppl  TYPE STANDARD TABLE OF zaj_rap_bsuppl_m  WITH EMPTY KEY.

    DATA lv_travel_read    TYPE i.
    DATA lv_book_read      TYPE i.
    DATA lv_suppl_read     TYPE i.
    DATA lv_travel_deleted TYPE i.
    DATA lv_book_deleted   TYPE i.
    DATA lv_suppl_deleted  TYPE i.
    DATA lv_travel_insert  TYPE i.
    DATA lv_book_insert    TYPE i.
    DATA lv_suppl_insert   TYPE i.

    TRY.

        "------------------------------------------------------------
        " 1. Read data from standard demo tables
        "------------------------------------------------------------
        SELECT *
          FROM /dmo/travel_m
          INTO CORRESPONDING FIELDS OF TABLE @lt_travel.

        lv_travel_read = lines( lt_travel ).

        SELECT *
          FROM /dmo/booking_m
          INTO CORRESPONDING FIELDS OF TABLE @lt_book.

        lv_book_read = lines( lt_book ).

        SELECT *
          FROM /dmo/booksuppl_m
          INTO CORRESPONDING FIELDS OF TABLE @lt_suppl.

        lv_suppl_read = lines( lt_suppl ).


        "------------------------------------------------------------
        " 2. Delete existing data from custom tables
        "    Delete child tables first to avoid foreign key issues
        "------------------------------------------------------------
        DELETE FROM zaj_rap_bsuppl_m.
        lv_suppl_deleted = sy-dbcnt.

        DELETE FROM  zaj_rap_bookin_m.
        lv_book_deleted = sy-dbcnt.

        DELETE FROM zaj_rap_travel_m.
        lv_travel_deleted = sy-dbcnt.


        "------------------------------------------------------------
        " 3. Insert data into custom tables
        "    Insert parent first, then child tables
        "------------------------------------------------------------
        IF lt_travel IS NOT INITIAL.
          INSERT zaj_rap_travel_m FROM TABLE @lt_travel.
          lv_travel_insert = sy-dbcnt.
        ENDIF.

        IF lt_book IS NOT INITIAL.
          INSERT zaj_rap_bookin_m FROM TABLE @lt_book.
          lv_book_insert = sy-dbcnt.
        ENDIF.

        IF lt_suppl IS NOT INITIAL.
          INSERT zaj_rap_bsuppl_m FROM TABLE @lt_suppl.
          lv_suppl_insert = sy-dbcnt.
        ENDIF.


        "------------------------------------------------------------
        " 4. Save changes
        "------------------------------------------------------------
        COMMIT WORK.


        "------------------------------------------------------------
        " 5. Output result in ADT console
        "------------------------------------------------------------
        out->write( |Data generation completed successfully.| ).
        out->write( | | ).

        out->write( |Standard data read:| ).
        out->write( |/DMO/TRAVEL_M     : { lv_travel_read } records| ).
        out->write( |/DMO/BOOKING_M    : { lv_book_read } records| ).
        out->write( |/DMO/BOOKSUPPL_M  : { lv_suppl_read } records| ).
        out->write( | | ).

        out->write( |Custom data deleted:| ).
        out->write( |TRAVEL  : { lv_travel_deleted } records| ).
        out->write( |BOOKING    : { lv_book_deleted } records| ).
        out->write( |BOOKING SUPPL   : { lv_suppl_deleted } records| ).
        out->write( | | ).

        out->write( |Custom data inserted:| ).
        out->write( |TRAVEL  : { lv_travel_insert } records| ).
        out->write( |BOOKING    : { lv_book_insert } records| ).
        out->write( |BOOKING SUPPL   : { lv_suppl_insert } records| ).


      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).

        ROLLBACK WORK.

        out->write( |Data generation failed.| ).
        out->write( |Database error: { lx_sql->get_text( ) }| ).

      CATCH cx_root INTO DATA(lx_root).

        ROLLBACK WORK.

        out->write( |Data generation failed.| ).
        out->write( |Error: { lx_root->get_text( ) }| ).

    ENDTRY.

  ENDMETHOD.
ENDCLASS.

CLASS lhc_ZAJ_RAP_I_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zaj_rap_i_travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zaj_rap_i_travel RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      entities FOR CREATE zaj_rap_i_travel.

ENDCLASS.

CLASS lhc_ZAJ_RAP_I_TRAVEL IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
  ENDMETHOD.

ENDCLASS.

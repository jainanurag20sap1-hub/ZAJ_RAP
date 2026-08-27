@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP projection view for Booking Suppl'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity Zaj_RAP_C_BSUPPL_M
  as projection on Zaj_RAP_I_BSUPPL_M
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Booking : redirected to parent Zaj_RAP_C_Booking,
      _Supplement,
      _SupplementText,
      _Travel  : redirected to ZAJ_RAP_C_TRAVEL
}

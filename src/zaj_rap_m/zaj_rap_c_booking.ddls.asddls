@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP projection view for Booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity Zaj_RAP_C_Booking
  as projection on ZAJ_RAP_I_BOOKING
{
  key TravelId,
  key BookingId,
      BookingDate,
      CustomerId,
      CarrierId,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      BookingStatus,
      LastChangedAt,
      /* Associations */
      _BookingStatus,
      _BookingSuppl : redirected to composition child Zaj_RAP_C_BSUPPL_M,
      _Carrier,
      _Connection,
      _Customer,
      _Travel       : redirected to parent ZAJ_RAP_C_TRAVEL
}

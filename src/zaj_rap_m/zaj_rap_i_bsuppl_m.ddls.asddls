@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP interface view for Booking Suppl'
@Metadata.ignorePropagatedAnnotations: true
define view entity Zaj_RAP_I_BSUPPL_M
  as select from zaj_rap_bsuppl_m
  association        to parent ZAJ_RAP_I_BOOKING as _Booking        on  $projection.BookingId = _Booking.BookingId
                                                                    and $projection.TravelId  = _Booking.TravelId
  association [1..1] to /DMO/I_Supplement        as _Supplement     on  $projection.SupplementId = _Supplement.SupplementID
  association [1..1] to /DMO/I_SupplementText    as _SupplementText on  $projection.SupplementId = _SupplementText.SupplementID
  association [1..1] to ZAJ_RAP_I_TRAVEL         as _Travel         on  $projection.TravelId = _Travel.TravelId
{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at       as LastChangedAt,
      _Supplement,
      _SupplementText,
      _Booking,
      _Travel
}

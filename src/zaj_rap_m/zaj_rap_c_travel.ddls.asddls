@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP Projection Travel view'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZAJ_RAP_C_TRAVEL
  provider contract transactional_query
  as projection on ZAJ_RAP_I_TRAVEL
{
  key TravelId,
      AgencyId,
      CustomerId,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      Description,
      OverallStatus,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child Zaj_RAP_C_Booking,
      _Currency,
      _Customer,
      _OverallStatus
}

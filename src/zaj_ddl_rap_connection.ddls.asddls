@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for learning RAP'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@UI.headerInfo: {
    typeName: 'Connection',
    typeNamePlural: 'Connections',
    title: { type: #STANDARD }
}

define view entity ZAJ_DDL_RAP_CONNECTION
  as select from /dmo/connection
  association [1..*] to ZAJ_DDL_RAP_FLIGHT  as _Flight  on  $projection.CarrierId    = _Flight.CarrierId
                                                        and $projection.ConnectionId = _Flight.ConnectionId
  association [1]    to ZAJ_DDL_RAP_CARRIER as _Carrier on  $projection.CarrierId = _Carrier.CarrierId
{
      @UI.facet: [
      { purpose: #STANDARD,
        id: 'Connection',
        type: #IDENTIFICATION_REFERENCE,
        position: 10,
        label: 'SPECIFIC CONNECTION DETAILS' },
      { purpose: #STANDARD,
        type: #LINEITEM_REFERENCE,
        id:'FlightDetails',
        position: 20,
        label: 'SPECIFIC FLIGHT DETAILS',
        targetElement: '_Flight'
       }
      ]

      @UI.lineItem: [{ position: 10, label: 'Airline' }]
      @UI.selectionField: [{ position: 10}]
      @UI.identification: [{ position: 10, label: 'AIRLINE' }]
      @ObjectModel.text.association: '_Carrier'
      @Search.defaultSearchElement: true
  key carrier_id      as CarrierId,
      @UI.lineItem: [{ position: 20, label: 'Connection' }]
      @UI.identification: [{ position: 20, label: 'CONNECTION' }]
  key connection_id   as ConnectionId,
      @UI.lineItem: [{ position: 30, label: 'From' }]
      @UI.identification: [{ position: 30, label: 'FROM' }]
      //@Search.defaultSearchElement: true
      airport_from_id as AirportFromId,
      @UI.lineItem: [{ position: 30, label: 'To' }]
      @UI.selectionField: [{ position: 20 }]
      @UI.identification: [{ position: 40, label: 'TO' }]
      airport_to_id   as AirportToId,
      @UI.lineItem: [{ position: 30, label: 'Depart Time' }]
      @UI.identification: [{ position: 50, label: 'DEPARTURE TIME' }]
      departure_time  as DepartureTime,
      @UI.lineItem: [{ position: 30, label: 'Arrv Time' }]
      @UI.identification: [{ position: 60, label: 'ARRIVAL TIME' }]
      arrival_time    as ArrivalTime,
      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      @UI.identification: [{ position: 70, label: 'DISTANCE' }]
      distance        as Distance,
      @UI.identification: [{ position: 80, label: 'DISTANCE UNIT' }]
      distance_unit   as DistanceUnit,
      _Flight,
      _Carrier
}

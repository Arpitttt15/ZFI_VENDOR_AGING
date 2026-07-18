@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Aging : Fiori Cube'
@Analytics.dataCategory: #CUBE
@VDM.viewType: #COMPOSITE

define view entity ZI_VEN_AGE_CUBE
  with parameters
    P_KeyDate         : abap.dats,
    P_Interval1InDays : abap.numc( 10 ),
    P_Interval2InDays : abap.numc( 10 ),
    P_Interval3InDays : abap.numc( 10 ),
    P_Interval4InDays : abap.numc( 10 ),
    P_Interval5InDays : abap.numc( 10 ),
    PT_Interval1InDays : abap.numc( 10 ),
    PT_Interval2InDays : abap.numc( 10 ),
    PT_Interval3InDays : abap.numc( 10 ),
    PT_Interval4InDays : abap.numc( 10 ),
    PT_Interval5InDays : abap.numc( 10 )
  as select from ZI_VEN_AGE_I02(
    P_KeyDate: $parameters.P_KeyDate,
    P_Interval1InDays: $parameters.P_Interval1InDays,
    P_Interval2InDays: $parameters.P_Interval2InDays,
    P_Interval3InDays: $parameters.P_Interval3InDays,
    P_Interval4InDays: $parameters.P_Interval4InDays,
    P_Interval5InDays: $parameters.P_Interval5InDays,
    PT_Interval1InDays : $parameters.PT_Interval1InDays,
    PT_Interval2InDays : $parameters.PT_Interval2InDays,
    PT_Interval3InDays : $parameters.PT_Interval3InDays,
    PT_Interval4InDays : $parameters.PT_Interval4InDays,
    PT_Interval5InDays : $parameters.PT_Interval5InDays
  )
{
  key CompanyCode,
  key AccountingDocument,
  key AccountingDocumentItem,
  key FiscalYear,
  key Vendor,
      SupplierName,
      VendorCountry,
      VendorRegion,
      City,
      VendorGroup,
      Customer,
      DebitCreditCode,
      AccountingDocumentType,
      PostingDate,
      DocumentDate,
      ClearingDate,
      NetDueDate,
      BaselineDate,
      GLAccount,
      SpecialGLCode,
      SpecialGLCodeName,
      CompanyCodeCurrency,
      TransactionCurrency,
      Assignment,
      VendorType,
      ReferenceDocument,
      ProfitCenter,
      Segment,
      BusinessArea,
      PaymentTerms,
      CashDiscount1Days,
      CashDiscount2Days,
      NetPaymentDays,
      DocumentItemText,
      BusinessPlace,
      PurchaseOrder,
      PurchaseOrderItem,
      SupplierInvoice,
      Plant,
      Material,
      ProductGroup,
      ProductGroupName,
      DaysOutstandingPT,

case
    when dats_days_between(
             DocumentDate,
             $parameters.P_KeyDate
         ) < 0
    then 0

    else dats_days_between(
             DocumentDate,
             $parameters.P_KeyDate
         )
end as DaysOutstanding,

      cast( $parameters.P_KeyDate as abap.int4 ) 
 - cast( NetDueDate as abap.int4 )   as AgingDays,
      cast( $parameters.P_KeyDate as abap.int4 ) 
 - cast( PostingDate as abap.int4 )  as AgingDaysPostingDate,
case
    when dats_days_between(
             DocumentDate,
             $parameters.P_KeyDate
         ) < 0
    then 0

    else dats_days_between(
             DocumentDate,
             $parameters.P_KeyDate
         )
end as AgingDaysDocDate,
      OverdueMonthDays,
      
      

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      AmountInCompanyCodeCurrency as GrossOutstanding,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @DefaultAggregation: #SUM
      AmountInTransactionCurrency as AmountInFC,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(NotDueAmount as abap.curr(23,2)) as NotDueAmount,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(NetOverdueAmount as abap.curr(23,2)) as NetOverdueAmount,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(UnadjustedAmount as abap.curr(23,2)) as UnadjustedAmount,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(AdvanceAmount as abap.curr(23,2)) as AdvanceAmount,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(Interval1 as abap.curr(23,2)) as Interval1,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(Interval2 as abap.curr(23,2)) as Interval2,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(Interval3 as abap.curr(23,2)) as Interval3,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(Interval4 as abap.curr(23,2)) as Interval4,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(Interval5 as abap.curr(23,2)) as Interval5,
      
 
      /* PT INTERVAL 1 */
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast( PTInterval1 as abap.curr(23,2) ) as PTInterval1,


      /* PT INTERVAL 2 */
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast( PTInterval2 as abap.curr(23,2) ) as PTInterval2,


      /* PT INTERVAL 3 */
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast( PTInterval3 as abap.curr(23,2) ) as PTInterval3,


      /* PT INTERVAL 4 */
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast( PTInterval4 as abap.curr(23,2) ) as PTInterval4,
      


      /* PT INTERVAL 5 */
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast( PTInterval5 as abap.curr(23,2) ) as PTInterval5
}

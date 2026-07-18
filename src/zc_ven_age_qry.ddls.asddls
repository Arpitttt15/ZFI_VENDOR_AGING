@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Aging : Analytical Query'
@Metadata.allowExtensions: true
@Analytics.query: true

define view entity ZC_VEN_AGE_QRY
  with parameters
    @EndUserText.label: 'Aging Key Date'
    P_KeyDate         : abap.dats,
    @EndUserText.label: 'Interval 1 (Days)'
    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '30' }
    P_Interval1InDays : abap.numc( 10 ),
    @EndUserText.label: 'Interval 2 (Days)'
    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '60' }
    P_Interval2InDays : abap.numc( 10 ),
    @EndUserText.label: 'Interval 3 (Days)'
    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '90' }
    P_Interval3InDays : abap.numc( 10 ),
    @EndUserText.label: 'Interval 4 (Days)'
    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '180' }
    P_Interval4InDays : abap.numc( 10 ),
    @EndUserText.label: 'Interval 5 (Days)'
    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '9999' }
    P_Interval5InDays : abap.numc( 10 ),
    @EndUserText.label: 'PTInterval 1 (Days)'
    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '30' }
    PT_Interval1InDays : abap.numc( 10 ),
    @EndUserText.label: 'PTInterval 2 (Days)'
    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '60' }
    PT_Interval2InDays : abap.numc( 10 ),
    @EndUserText.label: 'PTInterval 3 (Days)'
    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '90' }
    PT_Interval3InDays : abap.numc( 10 ),
    @EndUserText.label: 'PTInterval 4 (Days)'
    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '180' }
    PT_Interval4InDays : abap.numc( 10 ),
    @EndUserText.label: 'PTInterval 5 (Days)'
    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '9999' }
    PT_Interval5InDays : abap.numc( 10 )
    

as select from ZI_VEN_AGE_CUBE(
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
  @Consumption.filter : { selectionType : #INTERVAL, multipleSelections : true, mandatory : false }
  key CompanyCode,
  key AccountingDocument,
  key AccountingDocumentItem, 
  key FiscalYear,
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SupplierCompanyVH', element : 'Supplier' } }]
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
      @Consumption.filter : { selectionType : #SINGLE, multipleSelections : true, mandatory : false }
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
      AgingDays,
      OverdueMonthDays,
      AgingDaysPostingDate,
      AgingDaysDocDate,
      DaysOutstanding,
      DaysOutstandingPT,
      

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      GrossOutstanding,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInFC,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      NotDueAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      NetOverdueAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      UnadjustedAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AdvanceAmount,

      @Consumption.dynamicLabel:{ label: '0 - &1 Days', binding: [{ index: 1, parameter: 'P_Interval1InDays' }] }
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
            @DefaultAggregation: #SUM
      Interval1,

      @Consumption.dynamicLabel:{ label: '&1 - &2 Days', binding: [{ index: 1, parameter: 'P_Interval1InDays' }, { index: 2, parameter: 'P_Interval2InDays' }] }
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
            @DefaultAggregation: #SUM
      Interval2,

      @Consumption.dynamicLabel:{ label: '&1 - &2 Days', binding: [{ index: 1, parameter: 'P_Interval2InDays' }, { index: 2, parameter: 'P_Interval3InDays' }] }
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      Interval3,

      @Consumption.dynamicLabel:{ label: '&1 - &2 Days', binding: [{ index: 1, parameter: 'P_Interval3InDays' }, { index: 2, parameter: 'P_Interval4InDays' }] }
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      Interval4,

      @Consumption.dynamicLabel:{ label: '&1 - &2 Days', binding: [{ index: 1, parameter: 'P_Interval4InDays' }, { index: 2, parameter: 'P_Interval5InDays' }] }
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      Interval5,
      
      
         @Consumption.dynamicLabel:{
        label: 'PT 0 - &1 Days',
        binding: [{ index: 1, parameter: 'PT_Interval1InDays' }]
      }
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      PTInterval1,


      @Consumption.dynamicLabel:{
        label: 'PT &1 - &2 Days',
        binding: [
          { index: 1, parameter: 'PT_Interval1InDays' },
          { index: 2, parameter: 'PT_Interval2InDays' }
        ]
      }
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      PTInterval2,


      @Consumption.dynamicLabel:{
        label: 'PT &1 - &2 Days',
        binding: [
          { index: 1, parameter: 'PT_Interval2InDays' },
          { index: 2, parameter: 'PT_Interval3InDays' }
        ]
      }
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      PTInterval3,
      


      @Consumption.dynamicLabel:{
        label: 'PT &1 - &2 Days',
        binding: [
          { index: 1, parameter: 'PT_Interval3InDays' },
          { index: 2, parameter: 'PT_Interval4InDays' }
        ]
      }
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      PTInterval4,


      @Consumption.dynamicLabel:{
        label: 'PT &1 - &2 Days',
        binding: [
          { index: 1, parameter: 'PT_Interval4InDays' },
          { index: 2, parameter: 'PT_Interval5InDays' }
        ]
      }
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      PTInterval5
      
}

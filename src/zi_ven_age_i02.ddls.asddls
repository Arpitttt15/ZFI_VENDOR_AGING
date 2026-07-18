@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Aging : Interval Logic'

define view entity ZI_VEN_AGE_I02
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

  as select from ZI_VEN_AGE_I01( P_KeyDate : $parameters.P_KeyDate )

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
      VendorType,

      CompanyCodeCurrency,
      TransactionCurrency,

      Assignment,
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
      DaysOutstanding,
      DaysOutstandingP,
      DaysOutstandingPT,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency,

      AgingDays,
      AgingDaysPostingDate,
      AgingDaysDocDate,
      


      /* NOT DUE */
      case when AgingDaysDocDate < 0
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else 0
      end as NotDueAmount,

      /* NET OVERDUE */
      case when AgingDaysDocDate >= 0
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else 0
      end as NetOverdueAmount,

      /* UNADJUSTED - FIXED: Removed 'IN' operator */
      case when AccountingDocumentType = 'KZ'
              or AccountingDocumentType = 'KG'
              or AccountingDocumentType = 'AB'
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else 0
      end as UnadjustedAmount,

      /* ADVANCE */
      case when SpecialGLCode = 'A'
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else 0
      end as AdvanceAmount,

      /* OVERDUE MONTH */
      case when AgingDaysDocDate > 0
           then cast( AgingDaysDocDate / 30 as abap.int4 )
           else 0
      end as OverdueMonthDays,

      /* INTERVAL 1 */
      case when AgingDaysDocDate >= 0
             and AgingDaysDocDate <= cast( $parameters.P_Interval1InDays as abap.int4 )
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else 0
      end as Interval1,

      /* INTERVAL 2 */
      case when AgingDaysDocDate > cast( $parameters.P_Interval1InDays as abap.int4 )
             and AgingDaysDocDate <= cast( $parameters.P_Interval2InDays as abap.int4 )
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else 0
      end as Interval2,

      /* INTERVAL 3 */
      case when AgingDaysDocDate > cast( $parameters.P_Interval2InDays as abap.int4 )
             and AgingDaysDocDate <= cast( $parameters.P_Interval3InDays as abap.int4 )
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else 0
      end as Interval3,

      /* INTERVAL 4 */
      case when AgingDaysDocDate > cast( $parameters.P_Interval3InDays as abap.int4 )
             and AgingDaysDocDate <= cast( $parameters.P_Interval4InDays as abap.int4 )
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else 0
      end as Interval4,

      /* INTERVAL 5 */
      case when AgingDaysDocDate > cast( $parameters.P_Interval4InDays as abap.int4 )
             and AgingDaysDocDate <= cast( $parameters.P_Interval5InDays as abap.int4 )
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else 0
      end as Interval5,
      
      /* PT INTERVAL 1 */
      case when DaysOutstandingPT >= 0
             and DaysOutstandingPT <= cast( $parameters.PT_Interval1InDays as abap.int4 )
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else cast( 0 as abap.dec( 23, 2 ) )
      end as PTInterval1,


      /* PT INTERVAL 2 */
      case when DaysOutstandingPT > cast( $parameters.PT_Interval1InDays as abap.int4 )
             and DaysOutstandingPT <= cast( $parameters.PT_Interval2InDays as abap.int4 )
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else cast( 0 as abap.dec( 23, 2 ) )
      end as PTInterval2,


      /* PT INTERVAL 3 */
      case when DaysOutstandingPT > cast( $parameters.PT_Interval2InDays as abap.int4 )
             and DaysOutstandingPT <= cast( $parameters.PT_Interval3InDays as abap.int4 )
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else cast( 0 as abap.dec( 23, 2 ) )
      end as PTInterval3,


      /* PT INTERVAL 4 */
      case when DaysOutstandingPT > cast( $parameters.PT_Interval3InDays as abap.int4 )
             and DaysOutstandingPT <= cast( $parameters.PT_Interval4InDays as abap.int4 )
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else cast( 0 as abap.dec( 23, 2 ) )
      end as PTInterval4,


      /* PT INTERVAL 5 */
      case when DaysOutstandingPT > cast( $parameters.PT_Interval4InDays as abap.int4 )
             and DaysOutstandingPT <= cast( $parameters.PT_Interval5InDays as abap.int4 )
           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
           else cast( 0 as abap.dec( 23, 2 ) )
      end as PTInterval5

}

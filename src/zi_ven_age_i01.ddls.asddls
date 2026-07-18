@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Aging : Base View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{ serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_VEN_AGE_I01
  with parameters
    P_KeyDate : abap.dats
  as select from    I_JournalEntryItem        as a
    left outer join I_OperationalAcctgDocItem as b    on  a.CompanyCode            = b.CompanyCode
                                                      and a.FiscalYear             = b.FiscalYear
                                                      and a.AccountingDocument     = b.AccountingDocument
                                                      and a.AccountingDocumentItem = b.AccountingDocumentItem
    left outer join I_JournalEntry            as je   on  a.CompanyCode        = je.CompanyCode
                                                      and a.FiscalYear         = je.FiscalYear
                                                      and a.AccountingDocument = je.AccountingDocument
    left outer join ZI_SUPPLIER_PO_AGG        as po   on  a.ReferenceDocument = po.SupplierInvoice
                                                      and je.FiscalYear       = po.FiscalYear
    left outer join I_PurchaseOrderItemAPI01  as poi  on  po.PurchaseOrder     = poi.PurchaseOrder
                                                      and po.PurchaseOrderItem = poi.PurchaseOrderItem
    left outer join I_Product                 as pr   on poi.Material = pr.Product
    left outer join I_SupplierInvoiceAPI01    as si   on po.SupplierInvoice = si.SupplierInvoice
    left outer join I_ProductGroupText_2      as pg   on  pr.ProductGroup = pg.ProductGroup
                                                      and pg.Language     = $session.system_language
    left outer join I_PaymentTermsConditions  as pt   on b.PaymentTerms = pt.PaymentTerms
    left outer join ZI_MSME_VENDOR            as m    on a.Supplier     =  m.Supplier
{
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.AccountingDocumentItem,
  key a.FiscalYear,
  key a.Supplier                            as Vendor,
      a._Supplier.SupplierName,
      a._Supplier.Country                   as VendorCountry,
      a._Supplier.Region                    as VendorRegion,
      a._Supplier.CityName                  as City,
      a._Supplier.SupplierAccountGroup      as VendorGroup,
      a.Customer,
      a.DebitCreditCode,
      a.AccountingDocumentType,
      a.PostingDate,
      a.DocumentDate,
      a.ClearingDate,
      a.NetDueDate,
      b.DueCalculationBaseDate              as BaselineDate,
      a.GLAccount,
      a.SpecialGLCode,
      a._SpecialGLCode._Text[Language = $session.system_language].SpecialGLCodeName,
      a.CompanyCodeCurrency,
      a.TransactionCurrency,
      a.AssignmentReference                 as Assignment,
      je.DocumentReferenceID                as ReferenceDocument,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.AmountInTransactionCurrency,


      case
          when dats_days_between(
                   a.DocumentDate,
                   $parameters.P_KeyDate
               ) < 0
          then 0

          else dats_days_between(
                   a.DocumentDate,
                   $parameters.P_KeyDate
               )
      end                                   as DaysOutstanding,

      cast( $parameters.P_KeyDate as abap.int4 )
      - cast( a.DocumentDate as abap.int4 ) as DaysOutstandingP,

      case
        when dats_days_between(
                 a.DocumentDate,
                 $parameters.P_KeyDate
             ) <= cast( coalesce( pt.CashDiscount1Days, 0 ) as abap.int4 )
        then 0

        else
             dats_days_between(
                 a.DocumentDate,
                 $parameters.P_KeyDate
             )
             -
             cast( coalesce( pt.CashDiscount1Days, 0 ) as abap.int4 )

      end                                   as DaysOutstandingPT,


      cast( $parameters.P_KeyDate as abap.int4 )
      - cast( a.NetDueDate as abap.int4 )   as AgingDays,
      cast( $parameters.P_KeyDate as abap.int4 )
      - cast( a.PostingDate as abap.int4 )  as AgingDaysPostingDate,
      case
          when dats_days_between(
                   a.DocumentDate,
                   $parameters.P_KeyDate
               ) < 0
          then 0

          else dats_days_between(
                   a.DocumentDate,
                   $parameters.P_KeyDate
               )
      end                                   as AgingDaysDocDate,



      a.ProfitCenter,
      a.Segment,
      a.BusinessArea,
      b.PaymentTerms,
      b.DocumentItemText,
      m.VendorType,
      pt.CashDiscount1Days,
      pt.CashDiscount2Days,
      pt.NetPaymentDays,
      po.PurchaseOrder,
      po.PurchaseOrderItem,
      po.SupplierInvoice,
      si.BusinessPlace,
      poi.Material,
      poi.Plant,
      pr.ProductType,
      pr.BaseUnit,
      pr.ProductGroup,
      pg.ProductGroupName
}
where
       a.Ledger               =  '0L'
  and  a.SourceLedger         =  '0L'
  and  a.FinancialAccountType =  'K'
  and  a.NetDueDate           is not null
  and(
       a.ClearingDate         > $parameters.P_KeyDate
    or a.ClearingDate         =  '00000000'
  )
  and  a.PostingDate          <= $parameters.P_KeyDate
  and  a.SpecialGLCode        <> 'F'

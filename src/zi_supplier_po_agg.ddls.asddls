@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Ref Aggregated'

define view entity ZI_SUPPLIER_PO_AGG
  as select from I_SuplrInvcItemPurOrdRefAPI01
{
  key SupplierInvoice,
  key FiscalYear,

      min( PurchaseOrder )     as PurchaseOrder,
      min( PurchaseOrderItem ) as PurchaseOrderItem
}
group by
    SupplierInvoice,
    FiscalYear
    

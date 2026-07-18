@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MSME Vendors'

define view entity ZI_MSME_VENDOR
  as select from I_Supplier
{
  key Supplier,

      cast(
        'MSME'
        as abap.char(10)
      ) as VendorType
}
where (
           Supplier = '0000300895'
        or Supplier = '0000300896'
        or Supplier = '0000300894'
        or Supplier = '0000300476'
        or Supplier = '0000300907'
        or Supplier = '0000400319'
        or Supplier = '0000300888'
        or Supplier = 'OT062'
        or Supplier = '0000300881'
        or Supplier = '0000100854'
        or Supplier = '0000300901'
        or Supplier = 'OT446'
        or Supplier = 'OT428'
        or Supplier = 'OT450'
        or Supplier = '0000100038'
        or Supplier = '0000100144'
        or Supplier = 'OT454'
        or Supplier = 'OT447'
        or Supplier = '0000401163'
        or Supplier = 'OT453'
        or Supplier = '0000300908'
        or Supplier = 'OT449'
        or Supplier = '0000101138'
        or Supplier = '0000402552'
        or Supplier = '0000101294'
        or Supplier = '0000101003'
        or Supplier = '0000101062'
        or Supplier = '0000101307'
        or Supplier = 'OT366'
        or Supplier = '0000100900'
        or Supplier = '0000400622'
        or Supplier = '0000101215'
        or Supplier = '0000402442'
        or Supplier = '0000101234'
        or Supplier = '0000101230'
        or Supplier = '0000101119'
        or Supplier = '0000101312'
        or Supplier = '0000101297'
      );

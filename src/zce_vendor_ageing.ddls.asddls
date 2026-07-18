    @ObjectModel: { query: { implementedBy: 'ABAP:ZCL_VENDOR_AGEING' } }
@UI.headerInfo: {
  typeName: 'Vendor Ageing Report',
  typeNamePlural: 'Vendor Ageing Reports',
  title: { type: #STANDARD, value: 'Supplier' }
}
@EndUserText.label: 'Vendor Ageing Report'
define custom entity ZCE_VENDOR_AGEING
{    @UI.facet                   : [
        {
          id                      : 'SupplierMasterData',
          purpose                 : #STANDARD,
          type                    : #IDENTIFICATION_REFERENCE,
          label                   : 'Supplier Master Data',
          position                : 10
        },
        {
          id                      : 'DocumentInformation',
          purpose                 : #STANDARD,
          type                    : #IDENTIFICATION_REFERENCE,
          label                   : 'Document Information',
          position                : 20
        },
        {
          id                      : 'FinancialDetails',
          purpose                 : #STANDARD,
          type                    : #IDENTIFICATION_REFERENCE,
          label                   : 'Financial Details',
          position                : 30
        },
        {
          id                      : 'AgingAnalysis',
          purpose                 : #STANDARD,
          type                    : #FIELDGROUP_REFERENCE,
          label                   : 'Aging Analysis',
          targetQualifier         : 'AgingIntervals',
          position                : 40
        },
        {
          id                      : 'AdditionalInfo',
          purpose                 : #STANDARD,
          type                    : #IDENTIFICATION_REFERENCE,
          label                   : 'Additional Information',
          position                : 50
        }
      ]

      // ========================================================================
      // FACET DEFINITION FOR DETAIL SCREEN
      // ========================================================================
      
      // ========================================================================
      // INPUT PARAMETERS - SELECTION SCREEN
      // ========================================================================

      @UI.selectionField          : [{ position: 120 }]
      @UI.identification          : [{ position: 20, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'Supplier'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'i_supplier', element: 'Supplier' } }]
  key supplier                    : lifnr;

      @UI.selectionField          : [{ position: 150 }]
      @UI.lineItem                : [{ position: 40, importance: #HIGH }]
      @UI.identification          : [{ position: 20, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'Accounting Document'

  key AccountingDocument          : belnr_d;

      @UI.selectionField          : [{ position: 15 }]
      @UI.lineItem                : [{ position: 30, importance: #HIGH }]
      @UI.identification          : [{ position: 10, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'Fiscal Year'
  key FiscalYear                  : gjahr;



      @UI.lineItem                : [{ position: 45, importance: #HIGH }]
      @UI.selectionField          : [{ position: 155 }]
      @EndUserText.label          : 'accountingdocumenttype'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'i_accountingdocumenttype', element: 'AccountingDocumentType' } }]
  key AccountingDocumentType      : abap.char(10);


      @UI.selectionField          : [{ position: 10 }]
      @EndUserText.label          : 'Key Date (Aging As Of)'

      keydate                     : datum;


      @UI.selectionField          : [{ position: 20 }]
      @EndUserText.label          : 'Net Due Interval 1'
      @Consumption.filter.defaultValue: '30'
      interval1_from              : abap.int4;

      @UI.selectionField          : [{ position: 30 }]
      @EndUserText.label          : 'Net Due Interval 2'
      @Consumption.filter.defaultValue: '60'
      interval2_from              : abap.int4;

      @UI.selectionField          : [{ position: 40 }]
      @EndUserText.label          : 'Net Due Interval 3'
      @Consumption.filter.defaultValue: '90'
      interval3_from              : abap.int4;

      @UI.selectionField          : [{ position: 50 }]
      @EndUserText.label          : 'Net Due Interval 4'
      @Consumption.filter.defaultValue: '120'
      interval4_from              : abap.int4;

      @UI.selectionField          : [{ position: 60 }]
      @EndUserText.label          : 'Net Due Interval 5'
      @Consumption.filter.defaultValue: '150'
      interval5_from              : abap.int4;

      @UI.selectionField          : [{ position: 70 }]
      @EndUserText.label          : 'Net Due Interval 6'
      @Consumption.filter.defaultValue: '180'
      interval6_from              : abap.int4;

      @UI.selectionField          : [{ position: 80 }]
      @EndUserText.label          : 'Net Due Interval 7'
      @Consumption.filter.defaultValue: '210'
      interval7_from              : abap.int4;


      //@UI.selectionField          : [{ position: 90 }]
      //@EndUserText.label          : 'Display Currency'
      //lr_currency                 : waers;

      @UI.selectionField          : [{ position: 100 }]
      @EndUserText.label          : 'EXCHANGE RATE TYPE'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_EXCHANGERATETYPE', element: 'ExchangeRateType' } }]
      ExchangeRateType            : abap.char( 10 );


      @UI.lineItem                : [{ position: 10, importance: #HIGH }]
      @UI.identification          : [{ position: 10, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'Company Code'
      CompanyCode                 : bukrs;

      @UI.lineItem                : [{ position: 25, importance: #HIGH }]
      @UI.identification          : [{ position: 25, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'Supplier Name '
      SupplierName                : abap.char( 60 );
      
      @UI.lineItem                : [{ position: 25, importance: #HIGH }]
      @UI.identification          : [{ position: 25, qualifier: 'VendorType' }]
      @EndUserText.label          : 'VendorType '
      VendorType                : abap.char( 60 ); 

      //  @UI.selectionField: [{ position: 110 }]
      //   @UI.identification: [{ position: 20, qualifier: 'SupplierMasterData' }]
      //  @EndUserText.label: 'Supplier'
      //      supplier                  : lifnr;


      @UI.selectionField          : [{ position: 140 }]
      @UI.identification          : [{ position: 30, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'glaccount'
      lr_glaccount                : abap.char(20);

      //@UI.identification: [{ position: 30, qualifier: 'FinancialDetails' }]
      //@EndUserText.label: 'Special GL Code'
      //SpecialGLCode               : abap.char(1);

      // ========================================================================
      // OUTPUT FIELDS - KEY FIELDS
      // ========================================================================

      //      @UI.lineItem                : [{ position: 10, importance: #HIGH }]
      //      @UI.identification          : [{ position: 10, qualifier: 'SupplierMasterData' }]
      //      @EndUserText.label          : 'Company Code'
      //      CompanyCode                 : bukrs;

      // @UI.lineItem: [{ position: 20, importance: #HIGH }]
      // @UI.identification: [{ position: 20, qualifier: 'SupplierMasterData' }]
      // @EndUserText.label: 'Supplier'
      //    Supplier                    : lifnr;

      //  @UI.lineItem: [{ position: 30, importance: #HIGH }]
      //  @UI.identification: [{ position: 10, qualifier: 'DocumentInformation' }]
      //  @EndUserText.label: 'Fiscal Year'
      //      FiscalYear                  : fis_gjahr_no_conv;

      //  @UI.lineItem: [{ position: 40, importance: #HIGH }]
      //  @UI.identification: [{ position: 20, qualifier: 'DocumentInformation' }]
      //  @EndUserText.label: 'Accounting Document'
      //      AccountingDocument          : belnr_d;

      @UI.lineItem                : [{ position: 50, importance: #MEDIUM }]
      @UI.identification          : [{ position: 30, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'Document Item'
      AccountingDocumentItem      : buzei;

      // ========================================================================
      // FACET 1: SUPPLIER MASTER DATA
      // ========================================================================



      @UI.lineItem                : [{ position: 70, importance: #MEDIUM }]
      @UI.identification          : [{ position: 40, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'Supplier Account Group'
      @UI.selectionField          : [{ position: 170 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SupplierAccountGroupText', element: 'SupplierAccountGroup' } }]
      SupplierAccountGroup        : ktokk;

      @UI.identification          : [{ position: 50, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'Account Clerk'
      AccountingClerk             : busab;

      @UI.identification          : [{ position: 60, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'Country'
      Country                     : land1_gp;

      @UI.identification          : [{ position: 70, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'Region'
      Region                      : regio;

      @UI.identification          : [{ position: 80, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'Purchasing Group'
      PurchasingGroup             : ekgrp;

      @UI.identification          : [{ position: 90, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'Business Partner Grouping'
      BusinessPartnerGrouping     : abap.char(4);

      @UI.identification          : [{ position: 100, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'BP Identification Type'
      bpidentificationtype        : abap.char(6);

      @UI.identification          : [{ position: 110, qualifier: 'SupplierMasterData' }]
      @EndUserText.label          : 'BP Identification Number'
      BPIdentificationNumber      : abap.char(60);

      //@UI.lineItem: [{ position: 45, importance: #HIGH }]
      //@EndUserText.label: 'accountingdocumenttype'
      //accountingdocumenttype : abap.char(10);
      // ========================================================================
      // FACET 2: DOCUMENT INFORMATION
      // ========================================================================

      // @UI.lineItem                : [{ position: 80, importance: #HIGH }]
      //@UI.identification          : [{ position: 40, qualifier: 'DocumentInformation' }]
      //@EndUserText.label          : 'Baseline Date'
      // DueCalculationBaseDate      : datum;

      @UI.lineItem                : [{ position: 90, importance: #MEDIUM }]
      @UI.identification          : [{ position: 50, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'Posting Date'
      PostingDate                 : datum;

      @UI.identification          : [{ position: 60, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'Assignment Reference'
      AssignmentReference         : dzuonr;

      @UI.lineItem                : [{ position: 105, importance: #HIGH }]
      @UI.identification          : [{ position: 65, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : ' Document Date '
      documentdate                : datum;
      
      @UI.identification          : [{ position:75, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'baseline date'
      duecalculationbasedate                : datum;
     


      @UI.lineItem                : [{ position: 100, importance: #HIGH }]
      @UI.identification          : [{ position: 70, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'Net Due Date'
      NetDueDate                  : datum;

      @UI.identification          : [{ position: 80, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'Payment Terms'
      paymentTerms                : dzterm;

      @UI.lineItem                : [{ position: 110, importance: #HIGH }]
      @UI.identification          : [{ position: 90, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'Days Outstanding'
      daysoutstanding             : abap.int4;

      @UI.lineItem                : [{ position: 120, importance: #HIGH }]
      @UI.identification          : [{ position: 100, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'Days Overdue (Doc Date)'
      daysoverduedd                 : abap.int4;
      
            @UI.lineItem                : [{ position: 121, importance: #HIGH }]
      @UI.identification          : [{ position: 101, qualifier: 'DocumentInformation' }]
      @EndUserText.label          : 'Days Overdue (Post Date)'
      daysoverduepd                 : abap.int4;
      
                @UI.lineItem                : [{ position: 122, importance: #MEDIUM }]
      @UI.identification          : [{ position: 102, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Not Due Amount (Doc Date)'
       @Semantics.amount.currencyCode: 'companycodecurrency'
      notdueamtdd                 : wrbtr;
      
                      @UI.lineItem                : [{ position: 123, importance: #MEDIUM }]
      @UI.identification          : [{ position: 103, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Net OverDue Amount (Doc Date)'
       @Semantics.amount.currencyCode: 'companycodecurrency'
      netoverdueamtdd                 : wrbtr;
      
                      @UI.lineItem                : [{ position: 124, importance: #MEDIUM }]
      @UI.identification          : [{ position: 104, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Not Due Amount (Post Date)'
       @Semantics.amount.currencyCode: 'companycodecurrency'
      notdueamtpd                 : wrbtr;
      
                      @UI.lineItem                : [{ position: 125, importance: #MEDIUM }]
      @UI.identification          : [{ position: 105, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Net OverDue Amount (Post Date)'
       @Semantics.amount.currencyCode: 'companycodecurrency'
      netoverdueamtpd                 : wrbtr;

      
      

      //@EndUserText.label          : 'Criticality'
      //CriticalityCode             : abap.int1;

      // ========================================================================
      // FACET 3: FINANCIAL DETAILS
      // ========================================================================

      @UI.lineItem                : [{ position: 130, importance: #MEDIUM }]
      @UI.identification          : [{ position: 10, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Reconciliation Account'
      ReconciliationAccount       : akont;

      @UI.lineItem                : [{ position: 140, importance: #MEDIUM }]
      @UI.identification          : [{ position: 20, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'GL Account'
      GLAccount                   : hkont;



      @UI.lineItem                : [{ position: 150, importance: #MEDIUM }]
      @UI.identification          : [{ position: 40, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Company Code Currency'
      companycodecurrency         : waers;

      @UI.lineItem                : [{ position: 160, importance: #HIGH }]
      @UI.identification          : [{ position: 50, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Amount in CC Currency'
      @Semantics.amount.currencyCode: 'companycodecurrency'
      amountincompanycodecurrency : wrbtr;
      
    

      @UI.identification          : [{ position: 60, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Display Currency'           //Transaction Currency
        @Consumption.filter.hidden: true
      TransactionCurrency         : waers;

      @UI.identification          : [{ position: 70, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Amount in Transaction Currency'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency : wrbtr;

      @UI.identification          : [{ position: 80, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Profit Center'
      profitcenter                : prctr;

      @UI.identification          : [{ position: 90, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Segment'
      segment                     : fb_segment;

      @UI.identification          : [{ position: 95, qualifier: 'FinancialDetails' }]
      @EndUserText.label          : 'Exchange Rate'
      exchangerate                : abap.dec( 9, 5 );
      
      @UI.lineItem                : [{ position: 50, importance: #MEDIUM }]
      @UI.identification          : [{ position: 30, qualifier: 'Clearingjournalentry' }]
      @EndUserText.label          : 'Clearingjournalentry'
      Clearingjournalentry      : buzei;
      
     

      // ========================================================================
      // FACET 4: AGING ANALYSIS (DYNAMIC INTERVALS)
      // ========================================================================

      @UI.lineItem                : [{ position: 170, importance: #HIGH }]
      @UI.fieldGroup              : [{ qualifier: 'AgingIntervals', position: 10, label: 'Interval 1' }]
      @EndUserText.label          : 'Interval 1'
      @Semantics.amount.currencyCode: 'companycodecurrency'
      interval1_amount            : wrbtr;



      @UI.lineItem                : [{ position: 180, importance: #HIGH }]
      @UI.fieldGroup              : [{ qualifier: 'AgingIntervals', position: 20, label: 'Interval 2' }]
      @EndUserText.label          : 'Interval 2'
      @Semantics.amount.currencyCode: 'companycodecurrency'
      interval2_amount            : wrbtr;


      @UI.lineItem                : [{ position: 190, importance: #HIGH }]
      @UI.fieldGroup              : [{ qualifier: 'AgingIntervals', position: 30, label: 'Interval 3' }]
      @EndUserText.label          : 'Interval 3'
      @Semantics.amount.currencyCode: 'companycodecurrency'
      interval3_amount            : wrbtr;



      @UI.lineItem                : [{ position: 200, importance: #HIGH }]
      @UI.fieldGroup              : [{ qualifier: 'AgingIntervals', position: 40, label: 'Interval 4' }]
      @EndUserText.label          : 'Interval 4'
      @Semantics.amount.currencyCode: 'companycodecurrency'
      interval4_amount            : wrbtr;



      @UI.lineItem                : [{ position: 210, importance: #HIGH }]
      @UI.fieldGroup              : [{ qualifier: 'AgingIntervals', position: 50, label: 'Interval 5' }]
      @EndUserText.label          : 'Interval 5'
      @Semantics.amount.currencyCode: 'companycodecurrency'
      interval5_amount            : wrbtr;



      @UI.lineItem                : [{ position: 220, importance: #HIGH }]
      @UI.fieldGroup              : [{ qualifier: 'AgingIntervals', position: 60, label: 'Interval 6' }]
      @EndUserText.label          : 'Interval 6'
      @Semantics.amount.currencyCode: 'companycodecurrency'
      interval6_amount            : wrbtr;


      @UI.lineItem                : [{ position: 230, importance: #HIGH }]
      @UI.fieldGroup              : [{ qualifier: 'AgingIntervals', position: 70, label: 'Interval 7' }]
      @EndUserText.label          : 'Interval 7'
      @Semantics.amount.currencyCode: 'companycodecurrency'
      interval7_amount            : wrbtr;


      @UI.lineItem                : [{ position: 240, importance: #MEDIUM }]
      @UI.fieldGroup              : [{ qualifier: 'AgingIntervals', position: 80, label: 'Interval Category' }]
      @EndUserText.label          : 'Interval Category'
      intervalcategory            : abap.char(1);
      


      //@UI.lineItem                : [{ position: 250, importance: #HIGH }]
      //@UI.fieldGroup              : [{ qualifier: 'AgingIntervals', position: 90, label: 'Total Outstanding' }]
      //@EndUserText.label          : 'Total Outstanding'
      //@Semantics.amount.currencyCode: 'companycodecurrency'
      //TotalOutstandingAmount      : wrbtr;

      @EndUserText.label          : 'Number of Intervals (1-7)'
      intervalcount               : abap.int1;

      // ========================================================================
      // FACET 5: ADDITIONAL INFORMATION
      // ========================================================================

      ///ledger
      @UI.identification          : [{ position: 10, qualifier: 'AdditionalInfo' }]
      @EndUserText.label          : 'ledgergllineitem '
      ledgergllineitem            : abap.char(10);

      @UI.identification          : [{ position: 20, qualifier: 'AdditionalInfo' }]
      @EndUserText.label          : 'Minority Indicator'
      minoritygroup               : abap.char(1);

      
      //@UI.identification          : [{ position: 40, qualifier: 'AdditionalInfo' }]
      //@EndUserText.label          : 'billingdocument'
      //billingdocument             : abap.char(25);

      

}

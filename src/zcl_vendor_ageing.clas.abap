CLASS zcl_vendor_ageing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      calculate_aging_intervals
        IMPORTING
          iv_amount            TYPE wrbtr
          iv_days_overdue      TYPE i
          iv_interval_count    TYPE int1
        EXPORTING
          ev_interval1_amount  TYPE wrbtr
          ev_interval2_amount  TYPE wrbtr
          ev_interval3_amount  TYPE wrbtr
          ev_interval4_amount  TYPE wrbtr
          ev_interval5_amount  TYPE wrbtr
          ev_interval6_amount  TYPE wrbtr
          ev_interval7_amount  TYPE wrbtr
          ev_interval_category TYPE c.
ENDCLASS.



CLASS ZCL_VENDOR_AGEING IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_response TYPE TABLE OF zce_vendor_ageing,
          ls_response TYPE zce_vendor_ageing.


    " Filter and sort details
    DATA(lt_clause) = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_field) = io_request->get_requested_elements( ).
    DATA(lt_sort)   = io_request->get_sort_elements( ).

    " Pagination parameters from request
    DATA(lv_top)    = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)   = io_request->get_paging( )->get_offset( ).

    " Handle invalid pagination inputs
    IF lv_top < 0.
      lv_top = 1.
    ENDIF.

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      DATA(lv_text) = lx_no_sel_option->get_text( ).
    ENDTRY.

    " Extract filter ranges
    DATA(lr_supplier) = VALUE #( lt_filter_cond[ name = 'SUPPLIER' ]-range OPTIONAL ).
    DATA(lr_suppliername) = VALUE #( lt_filter_cond[ name = 'SUPPLIER NAME' ]-range OPTIONAL ).
    DATA(lr_fiscalyear) = VALUE #( lt_filter_cond[ name = 'FISCALYEAR' ]-range OPTIONAL ).
    DATA(lr_companycode) = VALUE #( lt_filter_cond[ name = 'COMPANYCODE' ]-range OPTIONAL ).
    DATA(lr_accountingdocument) = VALUE #( lt_filter_cond[ name = 'ACCOUNTINGDOCUMENT' ]-range OPTIONAL ).
    DATA(lr_accountingdocumenttype) = VALUE #( lt_filter_cond[ name = 'ACCOUNTINGDOCUMENTTYPE' ]-range OPTIONAL ).
    DATA(lr_glaccount) = VALUE #( lt_filter_cond[ name = 'GLCCOUNT' ]-range OPTIONAL ).
    DATA(lr_duecalculationbasedate) = VALUE #( lt_filter_cond[ name = 'Bline Data' ]-range OPTIONAL ).
    DATA(lr_postingdate) = VALUE #( lt_filter_cond[ name = 'POSTINGDATE' ]-range OPTIONAL ).
    DATA(lr_netduedate) = VALUE #( lt_filter_cond[ name = 'NETDUEDATE' ]-range OPTIONAL ).
    DATA(lr_exchange) = VALUE #( lt_filter_cond[ name = 'EXCHANGERATETYPE' ]-range OPTIONAL ).
    DATA(lr_suplaccgrp) = VALUE #( lt_filter_cond[ name = 'SUPPLIERACCOUNTGROUP' ]-range OPTIONAL ).

    " Key Date and Interval Count parameters
    DATA: lv_key_date       TYPE datum,
          lv_interval_count TYPE int1 VALUE 7.
     data: lv_Baseline_Date  tyPE datum.

    " Get Key Date from filter (default to system date)
    TRY.
        lv_key_date = VALUE #( lt_filter_cond[ name = 'KEYDATE' ]-range[ 1 ]-low OPTIONAL ).
        IF lv_key_date IS INITIAL.
          lv_key_date = sy-datum.
        ENDIF.
      CATCH cx_root.
        lv_key_date = sy-datum.
    ENDTRY.

    " Get Interval Count from filter (default to 7)
    TRY.
        lv_interval_count = VALUE #( lt_filter_cond[ name = 'INTERVALCOUNT' ]-range[ 1 ]-low OPTIONAL ).
        IF lv_interval_count IS INITIAL OR lv_interval_count < 1 OR lv_interval_count > 7.
          lv_interval_count = 7.
        ENDIF.
      CATCH cx_root.
        lv_interval_count = 7.
    ENDTRY.

    " ===============================
    "   MAIN DATA SELECTION SECTION
    " ===============================

    SELECT  supplier,
            suppliername,
            supplieraccountgroup,
            country,
            region
            FROM i_supplier
            WHERE supplier IN @lr_supplier
            AND SupplierAccountGroup IN @lr_suplaccgrp
            INTO TABLE  @DATA(it_supplier).

    IF it_supplier IS NOT INITIAL.

*      SORT it_supplier BY supplier.
*      DELETE ADJACENT DUPLICATES FROM it_supplier COMPARING supplier.

      SELECT  supplier,

              companycode,
              paymentterms,
              reconciliationaccount,
              accountingclerk,
              minoritygroup
              FROM i_suppliercompany
              FOR ALL ENTRIES IN @it_supplier
              WHERE supplier = @it_supplier-supplier
                AND companycode IN @lr_companycode
              INTO TABLE @DATA(it_suppliercompany).

*      SORT it_suppliercompany BY companycode.
*      DELETE ADJACENT DUPLICATES FROM it_suppliercompany COMPARING companycode.
    ENDIF.

    IF it_suppliercompany IS NOT INITIAL.
      SELECT
        businesspartner,
        businesspartnergrouping
        FROM i_businesspartner
        FOR ALL ENTRIES IN @it_suppliercompany
        WHERE businesspartner = @it_suppliercompany-supplier
        INTO TABLE @DATA(it_businesspartner).

      SELECT
        businesspartner,
        bpidentificationnumber,
        bpidentificationtype
        FROM i_bupaidentification
        FOR ALL ENTRIES IN @it_businesspartner
        WHERE  businesspartner = @it_businesspartner-businesspartner
        INTO TABLE @DATA(it_bupaidentification).

*      SORT it_bupaidentification BY businesspartner.
*      DELETE ADJACENT DUPLICATES FROM it_bupaidentification COMPARING businesspartner.

      SELECT
        assignmentreference,
        accountingdocument,
        companycode,
        netduedate,
        accountingdocumentitem,
        profitcenter,
        segment,
        fiscalyear,
        ledgergllineitem,
        transactioncurrency,
        companycodecurrency,
        specialglcode,
        supplier,
        glaccount,
        clearingjournalentry,


        amountincompanycodecurrency,
        amountintransactioncurrency

        FROM  i_journalentryitem
        FOR ALL ENTRIES IN @it_suppliercompany
        WHERE supplier = @it_suppliercompany-supplier
          AND companycode = @it_suppliercompany-companycode
          AND companycode IN @lr_companycode
          AND accountingdocument IN @lr_accountingdocument
          And  fiscalyear In @lr_fiscalyear
          AND accountingdocumenttype IN @lr_accountingdocumenttype
          AND netduedate IN @lr_netduedate
          AND Ledger = '0L'
          AND FinancialAccountType = 'K'
          AND ClearingJournalEntry IS INITIAL
          AND AccountingDocumentType <> 'KZ'
          AND AccountingDocumentType <> 'MP'
          AND AccountingDocumentType <> 'MR'
        INTO TABLE @DATA(it_journalitem).
    ENDIF.

    IF it_journalitem IS NOT INITIAL.

      SELECT
        companycode,
        accountingdocument,
        fiscalyear,
        accountingdocumenttype,
        documentdate,
        postingdate,
        exchangeratetype,
        absoluteexchangerate
        FROM i_journalentry
        FOR ALL ENTRIES IN @it_journalitem
        WHERE companycode = @it_journalitem-companycode
          AND accountingdocument = @it_journalitem-accountingdocument
          AND fiscalyear = @it_journalitem-fiscalyear
          AND accountingdocumenttype IN @lr_accountingdocumenttype
          AND postingdate IN @lr_postingdate


        INTO TABLE @DATA(it_journalentry).


    ENDIF.

    select cashdiscount1days,
    paymentterms
     from i_paymenttermsconditions

     FOR ALL ENTRIES IN @it_suppliercompany
     where PaymentTerms = @it_suppliercompany-PaymentTerms
     into table @data(it_payment).


           SELECT  supplier, duecalculationbasedate,accountingdocument
    FROM i_operationalacctgdocitem
    FOR ALL ENTRIES IN @it_journalitem
 WHERE companycode = @it_journalitem-companycode
 AND accountingdocument = @it_journalitem-accountingdocument
  AND fiscalyear = @it_journalitem-fiscalyear
  AND accountingdocumentitem = @it_journalitem-accountingdocumentitem
  INTO TABLE @DATA(it_basedate).


     select  supplier , PurchasingGroup
      froM I_SupplierPurchasingOrg fOR ALL ENTRIES IN @it_journalitem
      whERE supplier = @it_journalitem-Supplier
      into tABLE @data(it_purchasing).

       "ls_response-lv_Baseline_Date = it_journalentry-documentdate - it_journalitem-netduedate.



  " your remaining logic


    " ===============================
    "   BUILD RESPONSE DATA
    " ===============================

    LOOP AT it_journalitem ASSIGNING FIELD-SYMBOL(<item>).

      CLEAR ls_response.

      " ===== SUPPLIER MASTER DATA =====
      READ TABLE it_supplier ASSIGNING FIELD-SYMBOL(<supp>)
        WITH KEY supplier = <item>-supplier.
      IF sy-subrc = 0.
        ls_response-supplier = <supp>-supplier.
        ls_response-suppliername  = <supp>-suppliername .
        ls_response-supplieraccountgroup = <supp>-supplieraccountgroup.
        ls_response-country = <supp>-country.
        ls_response-region = <supp>-region.
      ENDIF.

      " ===== SUPPLIER COMPANY DATA =====
      READ TABLE it_suppliercompany ASSIGNING FIELD-SYMBOL(<suppcomp>)
        WITH KEY supplier = <item>-supplier
                 companycode = <item>-companycode.
      IF sy-subrc = 0.
        ls_response-paymentterms = <suppcomp>-paymentterms.
        ls_response-reconciliationaccount = <suppcomp>-reconciliationaccount.
        ls_response-accountingclerk = <suppcomp>-accountingclerk.
        ls_response-minoritygroup = <suppcomp>-minoritygroup.
      ENDIF.

      " ===== BUSINESS PARTNER DATA =====
      READ TABLE it_businesspartner ASSIGNING FIELD-SYMBOL(<bp>)
        WITH KEY businesspartner = <item>-supplier.
      IF sy-subrc = 0.
        ls_response-businesspartnergrouping = <bp>-businesspartnergrouping.
      ENDIF.

       READ TABLE it_basedate ASSIGNING FIELD-SYMBOL(<bas>)
        WITH KEY accountingdocument = <item>-accountingdocument.
      IF sy-subrc = 0.
        ls_response-duecalculationbasedate = <bas>-duecalculationbasedate.
      ENDIF.

      READ TABLE it_purchasing ASSIGNING FIELD-SYMBOL(<purchasing>)
           WITH KEY supplier = <item>-supplier.

       IF sy-subrc = 0.
        ls_response-PurchasingGroup = <purchasing>-PurchasingGroup.
      ENDIF.



      " ===== BUSINESS PARTNER IDENTIFICATION DATA =====
      READ TABLE it_bupaidentification ASSIGNING FIELD-SYMBOL(<bpid>)
        WITH KEY businesspartner = <item>-supplier.
      IF sy-subrc = 0.
        ls_response-bpidentificationnumber = <bpid>-bpidentificationnumber.
        ls_response-bpidentificationtype = <bpid>-bpidentificationtype.
      ENDIF.

      " ===== JOURNAL ENTRY HEADER DATA =====
      READ TABLE it_journalentry ASSIGNING FIELD-SYMBOL(<je>)
        WITH KEY companycode = <item>-companycode
                 accountingdocument = <item>-accountingdocument.
      IF sy-subrc = 0.
        ls_response-fiscalyear = <je>-fiscalyear.
        ls_response-accountingdocumenttype = <je>-accountingdocumenttype.
        ls_response-documentdate = <je>-documentdate.
        ls_response-postingdate = <je>-postingdate.
        ls_response-exchangerate = <je>-absoluteexchangerate.
      ENDIF.
       "IF <item>-netduedate IS NOT INITIAL AND <je>-documentdate IS NOT INITIAL.
        "ls_response-duecalculationbasedate = <item>-netduedate - <je>-documentdate.
       "ENDIF. """""""shubham


      " ===== OPERATIONAL ACCOUNTING DOCUMENT ITEM DATA =====
      ls_response-assignmentreference = <item>-assignmentreference.
      ls_response-accountingdocument = <item>-accountingdocument.
      ls_response-companycode = <item>-companycode.
      ls_response-netduedate = <item>-netduedate.
      ls_response-accountingdocumentitem = <item>-accountingdocumentitem.
      ls_response-profitcenter = <item>-profitcenter.
      ls_response-segment = <item>-segment.
      ls_response-ledgergllineitem = <item>-ledgergllineitem.
      ls_response-transactioncurrency = <item>-transactioncurrency.
      ls_response-companycodecurrency = <item>-companycodecurrency.
      ls_response-glaccount = <item>-glaccount.
      ls_response-supplier = <item>-supplier.
      ls_response-Clearingjournalentry = <item>-ClearingJournalEntry.
      ls_response-amountincompanycodecurrency = <item>-amountincompanycodecurrency.
      ls_response-amountintransactioncurrency = <item>-amountintransactioncurrency.



      " ===============================================
      " CALCULATE AGING
      " ===============================================

      " Calculate Days Outstanding (from Document Date)



      IF ls_response-documentdate IS NOT INITIAL.
 READ table it_payment into data(wa_pay)
      with key PaymentTerms = ls_response-paymentTerms.
        ls_response-daysoutstanding = lv_key_date - ls_response-documentdate.
        ls_response-daysoverduedd = ( lv_key_date - ls_response-documentdate ) - wa_pay-CashDiscount1Days .
      ENDIF.

       IF ls_response-PostingDate IS NOT INITIAL.
        ls_response-daysoverduepd = ( lv_key_date - ls_response-PostingDate ) - wa_pay-CashDiscount1Days.
      ENDIF.

        IF ls_response-daysoverduedd >= 0.
  ls_response-netoverdueamtdd = ls_response-amountincompanycodecurrency.
  CLEAR ls_response-notdueamtdd.
ELSE.
  ls_response-notdueamtdd = ls_response-amountincompanycodecurrency.
  CLEAR ls_response-netoverdueamtdd.
ENDIF.

IF ls_response-daysoverduepd >= 0.
  ls_response-netoverdueamtpd = ls_response-amountincompanycodecurrency.
  CLEAR ls_response-notdueamtdd.
ELSE.
  ls_response-notdueamtpd = ls_response-amountincompanycodecurrency.
  CLEAR ls_response-netoverdueamtdd.
ENDIF.



      " Calculate Days Overdue (from Net Due Date)
*      IF ls_response-netduedate IS NOT INITIAL.
*        ls_response-daysoverdue = lv_key_date - ls_response-netduedate.
*      ELSE.
        " If no due date, use document date
*        ls_response-daysoverdue = ls_response-daysoutstanding.
*      ENDIF.

      " Calculate Aging Intervals
      calculate_aging_intervals(
        EXPORTING
          iv_amount            = ls_response-amountincompanycodecurrency
          iv_days_overdue      = ls_response-daysoutstanding
          iv_interval_count    = lv_interval_count
        IMPORTING
          ev_interval1_amount  = ls_response-interval1_amount
          ev_interval2_amount  = ls_response-interval2_amount
          ev_interval3_amount  = ls_response-interval3_amount
          ev_interval4_amount  = ls_response-interval4_amount
          ev_interval5_amount  = ls_response-interval5_amount
          ev_interval6_amount  = ls_response-interval6_amount
          ev_interval7_amount  = ls_response-interval7_amount
          ev_interval_category = ls_response-intervalcategory
      ).

      " Store Key Date and Interval Count in response
      ls_response-keydate = lv_key_date.
      ls_response-intervalcount = lv_interval_count.

      APPEND ls_response TO lt_response.

    ENDLOOP.

    " ===============================
    "   PAGINATION LOGIC
    " ===============================
    DATA: lv_total_count TYPE int8.
    lv_total_count = lines( lt_response ).

    DATA lt_paged TYPE TABLE OF zce_vendor_ageing.
    DATA lv_index TYPE i VALUE 0.

    LOOP AT lt_response INTO DATA(ls_row).
      lv_index = lv_index + 1.
      IF lv_index > lv_skip AND lv_index <= lv_skip + lv_top.
        APPEND ls_row TO lt_paged.
      ENDIF.
    ENDLOOP.

    " Send data to UI - CRITICAL!
    io_response->set_total_number_of_records( lv_total_count ).
    io_response->set_data( lt_paged ).

  ENDMETHOD.


  METHOD calculate_aging_intervals.
    " ===============================================
    " Calculate aging intervals based on days overdue
    " ===============================================

    CLEAR: ev_interval1_amount,
           ev_interval2_amount,
           ev_interval3_amount,
           ev_interval4_amount,
           ev_interval5_amount,
           ev_interval6_amount,
           ev_interval7_amount,
           ev_interval_category.

    " Interval 1: 0-30 days
    IF iv_days_overdue <= 30.
      ev_interval1_amount = iv_amount.
      ev_interval_category = '1'.

      " Interval 2: 31-60 days
    ELSEIF iv_days_overdue > 30 AND iv_days_overdue <= 60.
      IF iv_interval_count >= 2.
        ev_interval2_amount = iv_amount.
        ev_interval_category = '2'.
      ELSE.
        ev_interval1_amount = iv_amount.
        ev_interval_category = '1'.
      ENDIF.

      " Interval 3: 61-90 days
    ELSEIF iv_days_overdue > 60 AND iv_days_overdue <= 90.
      IF iv_interval_count >= 3.
        ev_interval3_amount = iv_amount.
        ev_interval_category = '3'.
      ELSE.
        ev_interval2_amount = iv_amount.
        ev_interval_category = '2'.
      ENDIF.

      " Interval 4: 91-120 days
    ELSEIF iv_days_overdue > 90 AND iv_days_overdue <= 120.
      IF iv_interval_count >= 4.
        ev_interval4_amount = iv_amount.
        ev_interval_category = '4'.
      ELSE.
        ev_interval3_amount = iv_amount.
        ev_interval_category = '3'.
      ENDIF.

      " Interval 5: 121-150 days
    ELSEIF iv_days_overdue > 120 AND iv_days_overdue <= 150.
      IF iv_interval_count >= 5.
        ev_interval5_amount = iv_amount.
        ev_interval_category = '5'.
      ELSE.
        ev_interval4_amount = iv_amount.
        ev_interval_category = '4'.
      ENDIF.

      " Interval 6: 151-180 days
    ELSEIF iv_days_overdue > 150 AND iv_days_overdue <= 180.
      IF iv_interval_count >= 6.
        ev_interval6_amount = iv_amount.
        ev_interval_category = '6'.
      ELSE.
        ev_interval5_amount = iv_amount.
        ev_interval_category = '5'.
      ENDIF.

      " Interval 7: Over 180 days
    ELSEIF iv_days_overdue > 180.
      IF iv_interval_count >= 7.
        ev_interval7_amount = iv_amount.
        ev_interval_category = '7'.
      ELSE.
        ev_interval6_amount = iv_amount.
        ev_interval_category = '6'.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.

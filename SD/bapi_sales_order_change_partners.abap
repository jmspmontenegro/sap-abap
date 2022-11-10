*&---------------------------------------------------------------------*
*& Report ZSDQATEST_SALES_ORDER_CHANGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdqatest_sales_order_change.

DATA: lv_vbeln LIKE bapivbeln-vbeln.
DATA: ls_bapisdh1x LIKE bapisdh1x.
DATA: lt_bapiret2 TYPE TABLE OF bapiret2 WITH HEADER LINE.
DATA: lt_bapiparnrc TYPE TABLE OF bapiparnrc WITH HEADER LINE.

lv_vbeln = '0000385392'. " Número da ordem de venda
ls_bapisdh1x-updateflag = 'U'.
lt_bapiparnrc-document = lv_vbeln.
lt_bapiparnrc-itm_number = '000000'. "pegar o cabeçalho da venda
lt_bapiparnrc-updateflag = 'U'.
lt_bapiparnrc-partn_role = 'SP'. "tipo de parceiro (vbpa-parvw)
lt_bapiparnrc-p_numb_new = '2000000033'. "novo parceiro
APPEND lt_bapiparnrc.

CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
  EXPORTING
    salesdocument    = lv_vbeln
    order_header_inx = ls_bapisdh1x
  TABLES
    return           = lt_bapiret2
    partnerchanges   = lt_bapiparnrc.

LOOP AT lt_bapiret2.
  WRITE: / lt_bapiret2-message.
ENDLOOP.

CLEAR: lt_bapiret2.

CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
  EXPORTING
    wait   = 'X'
  IMPORTING
    return = lt_bapiret2.
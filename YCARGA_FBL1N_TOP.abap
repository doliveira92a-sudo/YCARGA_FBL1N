*&---------------------------------------------------------------------*
*&  Include           YCARGA_FBL1N_TOP
*&---------------------------------------------------------------------*

TABLES: bsik, bkpf.

TYPES: BEGIN OF ty_sql,

  belnr TYPE bsik-belnr,
  gjahr TYPE bsik-gjahr,
  bukrs TYPE bsik-bukrs,
  lifnr TYPE bsik-lifnr,
  umskz TYPE bsik-umskz,
  buzei TYPE bsik-buzei,

  name1 TYPE lfa1-name1,

  wrbtr TYPE bsik-wrbtr,
  dmbtr TYPE bsik-dmbtr,

  budat TYPE bsik-budat,
  bldat TYPE bkpf-bldat,

  sgtxt TYPE bsik-sgtxt,

  augbl TYPE bsik-augbl,
  augdt TYPE bsik-augdt,

  xblnr TYPE bkpf-xblnr,
  bktxt TYPE bkpf-bktxt,

  zuonr TYPE bsik-zuonr,
  shkzg TYPE bsik-shkzg,
  zfbdt TYPE bsik-zfbdt,
  zterm TYPE bsik-zterm,

  tipo_registro TYPE char15,

END OF ty_sql.

DATA: it_sql TYPE TABLE OF ty_sql,
      wa_sql TYPE ty_sql.
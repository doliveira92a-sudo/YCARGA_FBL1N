*&---------------------------------------------------------------------*
*&  Include           YCARGA_FBL1N_SRC
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

  PARAMETERS: p_bukrs TYPE bsik-bukrs OBLIGATORY.

  SELECT-OPTIONS: s_lifnr FOR bsik-lifnr,
                  s_budat FOR bsik-budat,
                  s_bldat FOR bkpf-bldat,
                  s_belnr FOR bsik-belnr,
                  s_gjahr FOR bsik-gjahr,
                  s_augdt FOR bsik-augdt,
                  s_augbl FOR bsik-augbl.

SELECTION-SCREEN END OF BLOCK b1.
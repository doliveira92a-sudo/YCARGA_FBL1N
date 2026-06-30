*&---------------------------------------------------------------------*
*&
*&                      Report  YCARGA_FBL1N
*&
*&---------------------------------------------------------------------*
*&
*&          PARTIDAS INDIVIDUAIS DOS FORNECEDORES - FBL1N
*&
*&---------------------------------------------------------------------*
REPORT ycarga_FBL1N.

INCLUDE ycarga_FBL1N_top.
INCLUDE ycarga_FBL1N_src.
INCLUDE ycarga_FBL1N_form.

START-OF-SELECTION.
  PERFORM: f_select_table,
           f_sql.

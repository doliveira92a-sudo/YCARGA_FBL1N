*&---------------------------------------------------------------------*
*&  Include           YCARGA_FBL1N_FORM
*&---------------------------------------------------------------------*

FORM f_select_table.

  SELECT bsik~belnr,
         bsik~gjahr,
         bsik~bukrs,
         bsik~lifnr,
         bsik~umskz,
         bsik~buzei,
         lfa1~name1,
         bsik~wrbtr,
         bsik~dmbtr,
         bsik~budat,
         bkpf~bldat,
         bsik~sgtxt,
         bsik~augbl,
         bsik~augdt,
         bkpf~xblnr,
         bkpf~bktxt,
         bsik~zuonr,
         bsik~shkzg,
         bsik~zfbdt,
         bsik~zterm,
        'ABERTO' AS tipo_registro

    FROM bsik
    INNER JOIN bkpf ON bkpf~bukrs = bsik~bukrs AND bkpf~belnr = bsik~belnr AND bkpf~gjahr = bsik~gjahr
    LEFT  JOIN lfa1 ON lfa1~lifnr = bsik~lifnr
    INTO CORRESPONDING FIELDS OF TABLE @it_sql
    WHERE bsik~bukrs EQ @p_bukrs
      AND bsik~lifnr IN @s_lifnr
      AND bsik~budat IN @s_budat
      AND bkpf~bldat IN @s_bldat
      AND bsik~belnr IN @s_belnr
      AND bsik~gjahr IN @s_gjahr.

*&---------------------------------------------------------------------*

  SELECT bsak~belnr,
         bsak~gjahr,
         bsak~bukrs,
         bsak~lifnr,
         bsak~umskz,
         bsak~buzei,
         lfa1~name1,
         bsak~wrbtr,
         bsak~dmbtr,
         bsak~budat,
         bkpf~bldat,
         bsak~sgtxt,
         bsak~augbl,
         bsak~augdt,
         bkpf~xblnr,
         bkpf~bktxt,
         bsak~zuonr,
         bsak~shkzg,
         bsak~zfbdt,
         bsak~zterm,
        'COMPENSADO' AS tipo_registro

    FROM bsak
    INNER JOIN bkpf ON bkpf~bukrs = bsak~bukrs AND bkpf~belnr = bsak~belnr AND bkpf~gjahr = bsak~gjahr
    LEFT  JOIN lfa1 ON lfa1~lifnr = bsak~lifnr
    APPENDING CORRESPONDING FIELDS OF TABLE @it_sql
    WHERE bsak~bukrs EQ @p_bukrs
      AND bsak~lifnr IN @s_lifnr
      AND bsak~budat IN @s_budat
      AND bkpf~bldat IN @s_bldat
      AND bsak~belnr IN @s_belnr
      AND bsak~gjahr IN @s_gjahr
      AND bsak~augdt IN @s_augdt
      AND bsak~augbl IN @s_augbl.

  IF it_sql[] IS INITIAL.
    MESSAGE 'Dados não encontrados' TYPE 'S' DISPLAY LIKE 'E'.
    STOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SQL
*&---------------------------------------------------------------------*


FORM f_sql.

*  TRY.
*      cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lr_alv)
*                              CHANGING t_table = it_sql[] ).
*    CATCH cx_root.
*      MESSAGE 'Erro não abribuição do ALV!!' TYPE 'S' DISPLAY LIKE 'E'.
*      STOP.
*  ENDTRY.
*
*  DATA(lr_display) = lr_alv->get_display_settings( ).
*  lr_display->set_striped_pattern( abap_true ).
*
*  DATA(lr_columns) = lr_alv->get_columns( ).
*  lr_columns->set_optimize( abap_true ).
*
*  DATA(lr_functions) = lr_alv->get_functions( ).
*  lr_functions->set_all( abap_true ).
*
*  lr_alv->display( ).

*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*

  DATA: lv_conexaosql TYPE dbcon-con_name VALUE 'PBI',
        lo_ref        TYPE REF TO cx_sy_native_sql_error,
        lv_text       TYPE string.

  DATA: lv_budat TYPE char23,
        lv_bldat TYPE char23,
        lv_augdt TYPE char23,
        lv_zfbdt TYPE char23.

*---------------------------------------------------------------------*

  TRY.
      EXEC SQL.
        CONNECT TO :lv_conexaosql
      ENDEXEC.

    CATCH cx_sy_native_sql_error INTO lo_ref.
      lv_text = lo_ref->get_text( ).
      WRITE / lv_text.
      EXIT.
  ENDTRY.

*---------------------------------------------------------------------*

  LOOP AT it_sql INTO wa_sql.

*---------------------------------------------------------------------*
* FORMATAR DATAS
*---------------------------------------------------------------------*

    PERFORM: f_writedate USING wa_sql-budat CHANGING lv_budat,
             f_writedate USING wa_sql-bldat CHANGING lv_bldat,
             f_writedate USING wa_sql-augdt CHANGING lv_augdt,
             f_writedate USING wa_sql-zfbdt CHANGING lv_zfbdt.

*---------------------------------------------------------------------*
* DELETE
*---------------------------------------------------------------------*

    TRY.

        EXEC SQL.
          DELETE FROM Partidas_Fornecedores
          WHERE SYSID = :sy-sysid
            AND BELNR = :wa_sql-belnr
            AND GJAHR = :wa_sql-gjahr
            AND BUKRS = :wa_sql-bukrs
            AND LIFNR = :wa_sql-lifnr
            AND BUZEI = :wa_sql-buzei
        ENDEXEC.

      CATCH cx_sy_native_sql_error INTO lo_ref.
        lv_text = lo_ref->get_text( ).
        WRITE / lv_text.
        CONTINUE.
    ENDTRY.

*---------------------------------------------------------------------*

    TRY.
        EXEC SQL.
          COMMIT
        ENDEXEC.
      CATCH cx_sy_native_sql_error INTO lo_ref.
        lv_text = lo_ref->get_text( ).
        WRITE / lv_text.
        CONTINUE.
    ENDTRY.

*---------------------------------------------------------------------*
* INSERT
*---------------------------------------------------------------------*

    TRY.

        EXEC SQL.

          INSERT INTO Partidas_Fornecedores
          (

            SYSID,
            BELNR,
            GJAHR,
            BUKRS,
            LIFNR,
            BUZEI,
            NAME1,
            WRBTR,
            DMBTR,
            BUDAT,
            BLDAT,
            SGTXT,
            AUGBL,
            AUGDT,
            XBLNR,
            BKTXT,
            ZUONR,
            SHKZG,
            ZFBDT,
            ZTERM,
            TIPO_REGISTRO,
            UMSKZ

          )

          VALUES
          (

            :sy-sysid,
            :wa_sql-belnr,
            :wa_sql-gjahr,
            :wa_sql-bukrs,
            :wa_sql-lifnr,
            :wa_sql-buzei,
            :wa_sql-name1,
            :wa_sql-wrbtr,
            :wa_sql-dmbtr,
            :lv_budat,
            :lv_bldat,
            :wa_sql-sgtxt,
            :wa_sql-augbl,
            :lv_augdt,
            :wa_sql-xblnr,
            :wa_sql-bktxt,
            :wa_sql-zuonr,
            :wa_sql-shkzg,
            :lv_zfbdt,
            :wa_sql-zterm,
            :wa_sql-tipo_registro,
            :wa_sql-umskz

          )

        ENDEXEC.

      CATCH cx_sy_native_sql_error INTO lo_ref.

        lv_text = lo_ref->get_text( ).
        WRITE / lv_text.
        CONTINUE.

    ENDTRY.

*---------------------------------------------------------------------*

    TRY.
        EXEC SQL.
          COMMIT
        ENDEXEC.
      CATCH cx_sy_native_sql_error INTO lo_ref.
        lv_text = lo_ref->get_text( ).
        WRITE / lv_text.
    ENDTRY.

  ENDLOOP.

*---------------------------------------------------------------------*

  TRY.
      EXEC SQL.
        DISCONNECT :lv_conexaosql
      ENDEXEC.
    CATCH cx_sy_native_sql_error INTO lo_ref.
      lv_text = lo_ref->get_text( ).
      WRITE / lv_text.
  ENDTRY.

  MESSAGE 'Carga realizada com sucesso' TYPE 'S'.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_WRITEDATE
*&---------------------------------------------------------------------*

FORM f_writedate  USING    iv_date
                  CHANGING cv_date.

  CLEAR cv_date.
  CHECK iv_date IS NOT INITIAL.

  cv_date = iv_date(4) && '-' && iv_date+4(2) && '-' && iv_date+6(2) && ' 00:00:00.000'.

ENDFORM.
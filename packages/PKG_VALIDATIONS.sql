--PKG_VALIDATIONS

CREATE OR REPLACE PACKAGE PKG_VALIDATIONS AS
  FUNCTION validar_cnpj(p_cnpj IN VARCHAR2) RETURN BOOLEAN;
  FUNCTION validar_telefone(p_ddd IN NUMBER, p_numero IN CHAR) RETURN BOOLEAN;
END PKG_VALIDATIONS;
/

CREATE OR REPLACE PACKAGE BODY PKG_VALIDATIONS AS

  FUNCTION validar_cnpj(p_cnpj IN VARCHAR2) RETURN BOOLEAN AS
    v_cnpj VARCHAR2(14);
    v_soma1 NUMBER := 0;
    v_soma2 NUMBER := 0;
    v_digito1 NUMBER;
    v_digito2 NUMBER;
  BEGIN
    v_cnpj := REGEXP_REPLACE(p_cnpj, '[^0-9]', '');
    
    IF LENGTH(v_cnpj) <> 14 THEN
      RETURN FALSE;
    END IF;
    

    RETURN TRUE;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END validar_cnpj;

  FUNCTION validar_telefone(p_ddd IN NUMBER, p_numero IN CHAR) RETURN BOOLEAN IS
    v_pattern VARCHAR2(30) := '^\d{9}$';
  BEGIN
    RETURN REGEXP_LIKE(p_numero, v_pattern);
  END validar_telefone;

END PKG_VALIDATIONS;
/

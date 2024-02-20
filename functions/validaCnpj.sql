CREATE OR REPLACE FUNCTION validar_cnpj(p_cnpj IN VARCHAR2) RETURN BOOLEAN AS
    v_cnpj VARCHAR2(14);
    v_soma NUMBER := 0;
    v_peso NUMBER := 5;
BEGIN
   
    v_cnpj := REGEXP_REPLACE(p_cnpj, '[^0-9]', '');

    IF LENGTH(v_cnpj) <> 14 THEN
        RETURN FALSE;
    END IF;

    IF LENGTH(TRIM(TRANSLATE(v_cnpj, '0123456789', '0000000000'))) = 0 THEN
        RETURN FALSE;
    END IF;

    FOR i IN 1..12 LOOP
        v_soma := v_soma + TO_NUMBER(SUBSTR(v_cnpj, i, 1)) * v_peso;
        v_peso := v_peso - 1;
        IF v_peso < 2 THEN
            v_peso := 9;
        END IF;
    END LOOP;

    IF MOD(v_soma, 11) <> TO_NUMBER(SUBSTR(v_cnpj, 13, 1)) THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END validar_cnpj;

DECLARE
    v_result BOOLEAN;
BEGIN
    v_result := validar_cnpj('12345678000199'); 
    IF v_result THEN
        DBMS_OUTPUT.PUT_LINE('CNPJ v�lido.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('CNPJ inv�lido.');
    END IF;
END;
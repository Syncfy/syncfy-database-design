CREATE OR REPLACE FUNCTION validar_telefone (
    p_ddd IN NUMBER,
    p_numero IN CHAR
) RETURN BOOLEAN
IS
    v_pattern VARCHAR2(30) := '^\d{9}$';
BEGIN
    IF REGEXP_LIKE(p_numero, v_pattern) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

-- Exemplo de teste
DECLARE
    v_ddd NUMBER := 11;  
    v_numero CHAR(9) := '123456789';  
    v_is_valid BOOLEAN;
BEGIN
    v_is_valid := validar_telefone(v_ddd, v_numero);

    IF v_is_valid THEN
        DBMS_OUTPUT.PUT_LINE('Numero de telefone valido.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Numero de telefone invalido.');
    END IF;
END;

CREATE OR REPLACE FUNCTION validar_cnpj(p_cnpj IN VARCHAR2) RETURN BOOLEAN AS
    v_cnpj VARCHAR2(14);
    v_soma1 NUMBER := 0;
    v_soma2 NUMBER := 0;
    v_digito1 NUMBER;
    v_digito2 NUMBER;
BEGIN
    -- Remove caracteres não numéricos
    v_cnpj := REGEXP_REPLACE(p_cnpj, '[^0-9]', '');
    
    -- Verifica se o CNPJ tem 14 dígitos
    IF LENGTH(v_cnpj) <> 14 THEN
        RETURN FALSE;
    END IF;
    
    -- Calcula o primeiro dígito verificador
    FOR i IN 1..12 LOOP
        IF i < 5 THEN
            v_soma1 := v_soma1 + TO_NUMBER(SUBSTR(v_cnpj, i, 1)) * (6 - i);
        ELSE
            v_soma1 := v_soma1 + TO_NUMBER(SUBSTR(v_cnpj, i, 1)) * (14 - i);
        END IF;
    END LOOP;
    
    v_digito1 := 11 - MOD(v_soma1, 11);
    IF v_digito1 >= 10 THEN
        v_digito1 := 0;
    END IF;
    
    -- Calcula o segundo dígito verificador
    FOR i IN 1..13 LOOP
        IF i < 6 THEN
            v_soma2 := v_soma2 + TO_NUMBER(SUBSTR(v_cnpj, i, 1)) * (7 - i);
        ELSE
            v_soma2 := v_soma2 + TO_NUMBER(SUBSTR(v_cnpj, i, 1)) * (15 - i);
        END IF;
    END LOOP;
    
    v_digito2 := 11 - MOD(v_soma2, 11);
    IF v_digito2 >= 10 THEN
        v_digito2 := 0;
    END IF;
    
    -- Verifica se os dígitos calculados correspondem aos do CNPJ
    IF v_digito1 <> TO_NUMBER(SUBSTR(v_cnpj, 13, 1)) OR v_digito2 <> TO_NUMBER(SUBSTR(v_cnpj, 14, 1)) THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END validar_cnpj;

-- Exemplo de teste
DECLARE
    v_result BOOLEAN;
BEGIN
    v_result := validar_cnpj('40800995000190'); 
    IF v_result THEN
        DBMS_OUTPUT.PUT_LINE('CNPJ valido.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('CNPJ invalido.');
    END IF;
END;
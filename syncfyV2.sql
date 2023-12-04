SET SERVEROUTPUT ON;

-- Funcao de Validacao de Telefone --
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
/

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
/

-- Funcao de Validacao de CNPJ --
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
/
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
/

-- Criar uma procedure que imprima um relat�rio com pelo menos uma regra de neg�cio, que contenha fun��es, inner Join, order by, sum ou count --

CREATE OR REPLACE PROCEDURE gerar_relatorio IS
  v_valor_minimo NUMBER := 1000;
BEGIN
  FOR categoria_rec IN (
    SELECT c."categoria", COUNT(p."cod_produto") AS num_produtos, SUM(p."valor_unitario") AS valor_total
    FROM categoria c
    INNER JOIN produto p ON c."cod_categoria" = p."categoria_cod_categoria"
    WHERE p."valor_unitario" > v_valor_minimo
    GROUP BY c."categoria"
    ORDER BY c."categoria"
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Categoria: ' || categoria_rec."categoria");
    DBMS_OUTPUT.PUT_LINE('Número de Produtos: ' || categoria_rec.num_produtos);
    DBMS_OUTPUT.PUT_LINE('Valor Total: ' || TO_CHAR(categoria_rec.valor_total, 'FM$999,999,999.99'));
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
  END LOOP;
END gerar_relatorio;
/

EXEC gerar_relatorio;


-- Bloco anonimo com cursor para pelo uma consulta no banco de dados com um Join. O cursor c_pedido faz uma consulta que seleciona o c�digo do pedido, a data de cria��o do pedido e o nome da pessoa vinculada a esse pedido --

DECLARE
   CURSOR c_pedido IS
      SELECT P.COD_PEDIDO, P.DATA_CRIACAO, PJ.CNPJ AS PESSOA_JURIDICA_CNPJ
      FROM PEDIDO P
      INNER JOIN PESSOA_JURIDICA PJ ON P.PESSOA_JURIDICA_CNPJ = PJ.CNPJ;

   v_cod_pedido NUMBER;
   v_data_criacao DATE;
   v_pessoa_juridica_cnpj CHAR(14);
BEGIN
   OPEN c_pedido;
   LOOP
      FETCH c_pedido INTO
         v_cod_pedido,
         v_data_criacao,
         v_pessoa_juridica_cnpj;

      EXIT WHEN c_pedido%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE('C�digo do Pedido: ' || v_cod_pedido);
      DBMS_OUTPUT.PUT_LINE('Data de Cria��o: ' || TO_CHAR(v_data_criacao, 'DD-MON-YYYY'));
      DBMS_OUTPUT.PUT_LINE('CNPJ Pessoa Jur�dica: ' || v_pessoa_juridica_cnpj);
   END LOOP;

   CLOSE c_pedido;
END;
/


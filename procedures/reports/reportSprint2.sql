SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE gerar_relatorio IS
    v_valor_minimo NUMBER := 200;
BEGIN
  FOR categoria_rec IN (
    SELECT c.categoria, COUNT(p.cod_produto) AS num_produtos, SUM(p.valor_unitario) AS valor_total
    FROM categoria c
    INNER JOIN produto p ON c.cod_categoria = p.categoria_cod_categoria
    WHERE p.valor_unitario > v_valor_minimo
    GROUP BY c.categoria
    ORDER BY c.categoria
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Categoria: ' || categoria_rec.categoria);
    DBMS_OUTPUT.PUT_LINE('N�mero de Produtos: ' || categoria_rec.num_produtos);
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
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');

   END LOOP;

   CLOSE c_pedido;

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
      CLOSE c_pedido; 
END;
/


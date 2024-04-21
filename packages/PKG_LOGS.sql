
--PKG_LOGS

CREATE OR REPLACE PACKAGE PKG_LOGS AS
  PROCEDURE relatorio_produtos_categoria(p_cod_categoria NUMBER);
  PROCEDURE gerar_relatorio;
END PKG_LOGS;
/

CREATE OR REPLACE PACKAGE BODY PKG_LOGS AS

  PROCEDURE relatorio_produtos_categoria(p_cod_categoria NUMBER) IS
    v_categoria_existente NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO v_categoria_existente
    FROM categoria
    WHERE cod_categoria = p_cod_categoria;

    IF v_categoria_existente = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Categoria n�o encontrada para o ID fornecido.');
    END IF;

    FOR r IN (SELECT nome FROM produto WHERE categoria_cod_categoria = p_cod_categoria) LOOP
      DBMS_OUTPUT.PUT_LINE(r.nome);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      INSERT INTO log_erros (codigo_erro, mensagem_erro, data_ocorrencia, usuario)
      VALUES ('ERRO GERAL', 'Erro inespec�fico capturado', SYSDATE, USER);
      COMMIT;
      
      RAISE;
  END relatorio_produtos_categoria;

  PROCEDURE gerar_relatorio IS
    v_valor_minimo NUMBER := 200;
  BEGIN
    FOR categoria_rec IN (
      SELECT c.categoria, COUNT(p.cod_produto) AS num_produtos, SUM(p.valor_unitario) AS valor_total
      FROM categoria c
      INNER JOIN produto p ON c.cod_categoria = p.categoria_cod_categoria
      WHERE p.valor_unitario > v_valor_minimo
      GROUP BY c.categoria
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Categoria: ' || categoria_rec.categoria);
      DBMS_OUTPUT.PUT_LINE('N�mero de Produtos: ' || categoria_rec.num_produtos);
      DBMS_OUTPUT.PUT_LINE('Valor Total: ' || TO_CHAR(categoria_rec.valor_total, 'FM$999,999,999.99'));
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;
  END gerar_relatorio;

END PKG_LOGS;
/


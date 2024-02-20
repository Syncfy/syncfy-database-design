CREATE OR REPLACE FUNCTION calcular_preco_total_pedido(p_cod_pedido NUMBER)
RETURN NUMBER IS
  v_preco_total NUMBER;
BEGIN
  SELECT preco_total + (SELECT custo FROM frete f WHERE f.cod_frete = p.frete_cod_frete)
  INTO v_preco_total
  FROM pedido p
  WHERE cod_pedido = p_cod_pedido;

  RETURN v_preco_total;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    INSERT INTO log_erros(codigo_erro, mensagem_erro, data_ocorrencia, usuario)
    VALUES ('NO_DATA_FOUND', 'Pedido não encontrado: ' || TO_CHAR(p_cod_pedido), SYSDATE, USER);
    COMMIT;
    RETURN NULL;
  WHEN OTHERS THEN
    INSERT INTO log_erros(codigo_erro, mensagem_erro, data_ocorrencia, usuario)
    VALUES ('ERRO GERAL', 'Erro inespecífico capturado', SYSDATE, USER);
    COMMIT;
    RAISE;
END;

-- Exemplo de teste:
DECLARE
  v_preco_total NUMBER;
BEGIN
  v_preco_total := calcular_preco_total_pedido(9999); -- Com erro
  IF v_preco_total IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Preço total não disponível.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Preço total do pedido: ' || TO_CHAR(v_preco_total));
  END IF;
END;
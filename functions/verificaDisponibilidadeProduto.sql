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
    RETURN NULL;
  WHEN OTHERS THEN
    -- Considerar adicionar o erro na tabela de log de erros aqui
    RAISE;
END;

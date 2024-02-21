CREATE OR REPLACE FUNCTION atualizar_preco_total_pedido(codPedido IN NUMBER)
RETURN NUMBER IS
  precoTotal NUMBER;
BEGIN
  precoTotal := calcular_preco_total_pedido(codPedido);
  
  UPDATE pedido
  SET preco_total = precoTotal
  WHERE cod_pedido = codPedido;
  COMMIT;
  
  RETURN precoTotal;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    INSERT INTO log_erros(codigo_erro, mensagem_erro, data_ocorrencia, usuario)
    VALUES ('NDF', 'Pedido não encontrado para atualização.', SYSDATE, 'sistema');
    COMMIT;
    RETURN NULL;
  WHEN OTHERS THEN
    INSERT INTO log_erros(codigo_erro, mensagem_erro, data_ocorrencia, usuario)
    VALUES ('ERRO GERAL', 'Erro inespecífico capturado', SYSDATE, 'sistema');
    COMMIT;
    RETURN NULL;
END;

-- Exemplo de teste
DECLARE
  resultado NUMBER;
BEGIN
  resultado := atualizar_preco_total_pedido(1);
  IF resultado IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Erro ao atualizar o pedido.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Pedido atualizado com sucesso. Preço Total: ' || TO_CHAR(resultado));
  END IF;
END;
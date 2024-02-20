CREATE OR REPLACE TRIGGER monitorar_atualizacao_pedido
AFTER UPDATE OF preco_total ON pedido
FOR EACH ROW
BEGIN
  INSERT INTO monitoramento_atualizacao_pedido(cod_pedido, data_atualizacao, usuario)
  VALUES (:NEW.cod_pedido, SYSDATE, USER);
END;

-- Exemplo de Teste
UPDATE pedido SET preco_total = 150, data_atualizacao = SYSDATE WHERE cod_pedido = 1;

SELECT * FROM monitoramento_atualizacao_pedido;

--PKG_TRANSACTIONS

CREATE OR REPLACE PACKAGE PKG_TRANSACTIONS AS
  PROCEDURE atualizar_email_pessoa(p_cod_pessoa NUMBER, p_novo_email VARCHAR2);
  FUNCTION atualizar_preco_total_pedido(codPedido IN NUMBER) RETURN NUMBER;
  FUNCTION calcular_preco_total_pedido(p_cod_pedido NUMBER) RETURN NUMBER;
END PKG_TRANSACTIONS;
/

CREATE OR REPLACE PACKAGE BODY PKG_TRANSACTIONS AS

  PROCEDURE atualizar_email_pessoa(p_cod_pessoa NUMBER, p_novo_email VARCHAR2) IS
  BEGIN
    IF p_novo_email IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Email n�o pode ser nulo.');
    END IF;
    
    UPDATE pessoa SET email = p_novo_email WHERE cod_pessoa = p_cod_pessoa;
    COMMIT;
  END atualizar_email_pessoa;

  FUNCTION atualizar_preco_total_pedido(codPedido IN NUMBER) RETURN NUMBER IS
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
      VALUES ('NDF', 'Pedido n�o encontrado para atualiza��o.', SYSDATE, 'sistema');
      COMMIT;
      RETURN NULL;
    WHEN OTHERS THEN
      INSERT INTO log_erros(codigo_erro, mensagem_erro, data_ocorrencia, usuario)
      VALUES ('ERRO GERAL', 'Erro inespec�fico capturado', SYSDATE, 'sistema');
      COMMIT;
      RAISE;
  END atualizar_preco_total_pedido;

FUNCTION calcular_preco_total_pedido(p_cod_pedido NUMBER)
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
    VALUES ('NO_DATA_FOUND', 'Pedido n�o encontrado: ' || TO_CHAR(p_cod_pedido), SYSDATE, USER);
    COMMIT;
    RETURN NULL;
  WHEN OTHERS THEN
    INSERT INTO log_erros(codigo_erro, mensagem_erro, data_ocorrencia, usuario)
    VALUES ('ERRO GERAL', 'Erro inespec�fico capturado', SYSDATE, USER);
    COMMIT;
    RAISE;
END;

END PKG_TRANSACTIONS;
/

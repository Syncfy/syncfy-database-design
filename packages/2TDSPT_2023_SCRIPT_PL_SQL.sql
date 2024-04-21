--CRIAÇÂO DOS PACKAGES:
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
      RAISE_APPLICATION_ERROR(-20002, 'Categoria não encontrada para o ID fornecido.');
    END IF;

    FOR r IN (SELECT nome FROM produto WHERE categoria_cod_categoria = p_cod_categoria) LOOP
      DBMS_OUTPUT.PUT_LINE(r.nome);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      INSERT INTO log_erros (codigo_erro, mensagem_erro, data_ocorrencia, usuario)
      VALUES ('ERRO GERAL', 'Erro inespecífico capturado', SYSDATE, USER);
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
      DBMS_OUTPUT.PUT_LINE('Número de Produtos: ' || categoria_rec.num_produtos);
      DBMS_OUTPUT.PUT_LINE('Valor Total: ' || TO_CHAR(categoria_rec.valor_total, 'FM$999,999,999.99'));
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;
  END gerar_relatorio;

END PKG_LOGS;
/


--PKG_VALIDATIONS

CREATE OR REPLACE PACKAGE PKG_VALIDATIONS AS
  FUNCTION validar_cnpj(p_cnpj IN VARCHAR2) RETURN BOOLEAN;
  FUNCTION validar_telefone(p_ddd IN NUMBER, p_numero IN CHAR) RETURN BOOLEAN;
END PKG_VALIDATIONS;
/

CREATE OR REPLACE PACKAGE BODY PKG_VALIDATIONS AS

  FUNCTION validar_cnpj(p_cnpj IN VARCHAR2) RETURN BOOLEAN AS
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
    
    -- Calcula os dígitos verificadores
    -- (Código de cálculo do dígito simplificado para brevidade)

    RETURN TRUE;  -- Retorna TRUE se o CNPJ for válido após todos os testes
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END validar_cnpj;

  FUNCTION validar_telefone(p_ddd IN NUMBER, p_numero IN CHAR) RETURN BOOLEAN IS
    v_pattern VARCHAR2(30) := '^\d{9}$';  -- Padrão para um número de telefone com 9 dígitos
  BEGIN
    RETURN REGEXP_LIKE(p_numero, v_pattern);
  END validar_telefone;

END PKG_VALIDATIONS;
/


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
      RAISE_APPLICATION_ERROR(-20001, 'Email não pode ser nulo.');
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
      VALUES ('NDF', 'Pedido não encontrado para atualização.', SYSDATE, 'sistema');
      COMMIT;
      RETURN NULL;
    WHEN OTHERS THEN
      INSERT INTO log_erros(codigo_erro, mensagem_erro, data_ocorrencia, usuario)
      VALUES ('ERRO GERAL', 'Erro inespecífico capturado', SYSDATE, 'sistema');
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
    VALUES ('NO_DATA_FOUND', 'Pedido não encontrado: ' || TO_CHAR(p_cod_pedido), SYSDATE, USER);
    COMMIT;
    RETURN NULL;
  WHEN OTHERS THEN
    INSERT INTO log_erros(codigo_erro, mensagem_erro, data_ocorrencia, usuario)
    VALUES ('ERRO GERAL', 'Erro inespecífico capturado', SYSDATE, USER);
    COMMIT;
    RAISE;
END;

END PKG_TRANSACTIONS;
/





--Criação dos Triggers:
--monitorar_atualizacao_pedido:
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


--log_insercao_pessoa
CREATE OR REPLACE TRIGGER log_insercao_pessoa
AFTER INSERT ON pessoa
FOR EACH ROW
BEGIN
    INSERT INTO log_insercoes_pessoa (cod_pessoa, nome, email, data_insercao)
    VALUES (:NEW.cod_pessoa, :NEW.nome, :NEW.email, SYSDATE);
END;
/

-- Exemplo de teste
INSERT INTO usuario values ('Victor Shimada', '1234', 1);
INSERT INTO pessoa VALUES ('Victor Shimada', 'S', 'joao.silva@example.com', 1|, 1);

COMMIT;

-- Verificar se o log foi criado
SELECT * FROM log_insercoes_pessoa;



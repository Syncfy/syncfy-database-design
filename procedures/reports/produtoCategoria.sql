CREATE OR REPLACE PROCEDURE relatorio_produtos_categoria(p_cod_categoria NUMBER) IS
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
END;

-- Exemplo de teste
BEGIN
  relatorio_produtos_categoria(1);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro ao gerar relatório: ' || SQLERRM);
END;
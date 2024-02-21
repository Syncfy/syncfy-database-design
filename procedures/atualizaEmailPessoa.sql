CREATE OR REPLACE PROCEDURE atualizar_email_pessoa(
  p_cod_pessoa  NUMBER, 
  p_novo_email  VARCHAR2
) IS
BEGIN
  IF p_novo_email IS NULL THEN
    RAISE_APPLICATION_ERROR(-20001, 'Email não pode ser nulo.');
  END IF;
  
  UPDATE pessoa SET email = p_novo_email WHERE cod_pessoa = p_cod_pessoa;
  
EXCEPTION
  WHEN OTHERS THEN
    INSERT INTO log_erros (codigo_erro, mensagem_erro, data_ocorrencia, usuario)
    VALUES ('ERRO GERAL', 'Erro inespecífico capturado', SYSDATE, USER);
    COMMIT;
    RAISE;
END;

-- Exemplo de teste
BEGIN
  atualizar_email_pessoa(1, 'emailAtualizado@mail.com'); 
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro de execução: ' || SQLERRM);
END;
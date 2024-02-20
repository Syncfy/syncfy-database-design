CREATE OR REPLACE PROCEDURE atualizar_email_pessoa(p_cod_pessoa NUMBER, p_novo_email VARCHAR2) IS
BEGIN
  UPDATE pessoa SET email = p_novo_email WHERE cod_pessoa = p_cod_pessoa;
  
  -- Simulando uma validação para exemplo de EXCEPTION
  IF p_novo_email IS NULL THEN
    RAISE_APPLICATION_ERROR(-20001, 'Email não pode ser nulo.');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    -- Considerar adicionar o erro na tabela de log de erros aqui
    RAISE;
END;

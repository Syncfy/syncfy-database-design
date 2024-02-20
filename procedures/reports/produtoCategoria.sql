CREATE OR REPLACE PROCEDURE relatorio_produtos_categoria(p_cod_categoria NUMBER) IS
BEGIN
  FOR r IN (SELECT nome FROM produto WHERE categoria_cod_categoria = p_cod_categoria) LOOP
    DBMS_OUTPUT.PUT_LINE(r.nome);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    -- Considerar adicionar o erro na tabela de log de erros aqui
    RAISE;
END;

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
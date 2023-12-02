drop table BAIRRO cascade constraint;
drop table CATEGORIA cascade constraint;
drop table CIDADE cascade constraint;
drop table ENDERECO cascade constraint;
drop table ESTADO cascade constraint;
drop table FRETE cascade constraint;
drop table PAIS cascade constraint;
drop table PEDIDO cascade constraint;
drop table PEDIDO_PRODUTO cascade constraint;
drop table PESSOA cascade constraint;
drop table PESSOA_FISICA cascade constraint;
drop table PESSOA_JURIDICA cascade constraint;
drop table PRODUTO cascade constraint;
drop table SEGMENTO cascade constraint;
drop table TELEFONE cascade constraint;
drop table USUARIO cascade constraint;
CREATE TABLE bairro (
    cod_bairro        NUMBER NOT NULL,
    nome              VARCHAR2(30),
    cidade_cod_cidade NUMBER NOT NULL
);

ALTER TABLE bairro ADD CONSTRAINT bairro_pk PRIMARY KEY ( cod_bairro );

CREATE TABLE categoria (
    cod_categoria NUMBER NOT NULL,
    categoria     VARCHAR2(30) 
);

ALTER TABLE categoria ADD CONSTRAINT categoria_pk PRIMARY KEY ( cod_categoria );

CREATE TABLE cidade (
    cod_cidade        NUMBER NOT NULL,
    nome              VARCHAR2(30),
    cod_ibge          NUMBER,
    estado_cod_estado NUMBER NOT NULL
);

ALTER TABLE cidade ADD CONSTRAINT cidade_pk PRIMARY KEY ( cod_cidade );

CREATE TABLE endereco (
    cod_endereco      NUMBER NOT NULL,
    cep               CHAR(8),
    logradouro        VARCHAR2(50),
    numero            CHAR(5),
    complemento       VARCHAR2(50),
    bairro_cod_bairro NUMBER NOT NULL,
    pessoa_cod_pessoa NUMBER NOT NULL
);

ALTER TABLE endereco ADD CONSTRAINT endereco_pk PRIMARY KEY ( cod_endereco );

CREATE TABLE estado (
    cod_estado    NUMBER NOT NULL,
    nome          CHAR(2) NOT NULL,
    pais_cod_pais NUMBER NOT NULL
);

ALTER TABLE estado ADD CONSTRAINT estado_pk PRIMARY KEY ( cod_estado );

CREATE TABLE frete (
    cod_frete NUMBER NOT NULL,
    custo     NUMBER
);

ALTER TABLE frete ADD CONSTRAINT frete_pk PRIMARY KEY ( cod_frete );

CREATE TABLE pais (
    cod_pais NUMBER NOT NULL,
    nome     VARCHAR2(30)
);

ALTER TABLE pais ADD CONSTRAINT pais_pk PRIMARY KEY ( cod_pais );

CREATE TABLE pedido (
    cod_pedido           NUMBER NOT NULL,
    data_criacao         DATE,
    data_atualizacao     DATE,
    preco_total          NUMBER,
    data_entrega         DATE,
    numero_pedido        NUMBER,
    descricao            VARCHAR2(250),
    frete_cod_frete      NUMBER NOT NULL,
    pessoa_juridica_cnpj CHAR(14) NOT NULL
);

CREATE UNIQUE INDEX pedido__idx ON
    pedido (
        frete_cod_frete
    ASC );

ALTER TABLE pedido ADD CONSTRAINT pedido_pk PRIMARY KEY ( cod_pedido );

CREATE TABLE pedido_produto (
    quantidade          NUMBER,
    cod_pedido_produto  NUMBER NOT NULL,
    produto_cod_produto NUMBER NOT NULL,
    pedido_cod_pedido   NUMBER NOT NULL
);

ALTER TABLE pedido_produto ADD CONSTRAINT pedido_produto_pk PRIMARY KEY ( cod_pedido_produto );

CREATE TABLE pessoa (
    nome             VARCHAR2(50),
    soft_delete      CHAR(1),
    email            VARCHAR2(150),
    cod_pessoa       NUMBER NOT NULL,
    usuario_cod_user NUMBER NOT NULL
);

CREATE UNIQUE INDEX pessoa__idx ON
    pessoa (
        usuario_cod_user
    ASC );

ALTER TABLE pessoa ADD CONSTRAINT pessoa_pk PRIMARY KEY ( cod_pessoa );

CREATE TABLE pessoa_juridica (
    cnpj                  CHAR(14) NOT NULL,
    pessoa_cod_pessoa     NUMBER NOT NULL,
    segmento_cod_segmento NUMBER NOT NULL,
    tipo                  CHAR(10) NOT NULL
);

CREATE UNIQUE INDEX pessoa_juridica__idx ON
    pessoa_juridica (
        pessoa_cod_pessoa
    ASC );

CREATE UNIQUE INDEX pessoa_juridica__idxv1 ON
    pessoa_juridica (
        segmento_cod_segmento
    ASC );

ALTER TABLE pessoa_juridica ADD CONSTRAINT pessoa_juridica_pk PRIMARY KEY ( cnpj );

CREATE TABLE produto (
    cod_produto             NUMBER NOT NULL,
    valor_unitario          NUMBER,
    nome                    VARCHAR2(20),
    descricao               VARCHAR2(250),
    sku                     CHAR(10) NOT NULL,
    categoria_cod_categoria NUMBER NOT NULL
);

CREATE UNIQUE INDEX produto__idx ON
    produto (
        categoria_cod_categoria
    ASC );

ALTER TABLE produto ADD CONSTRAINT produto_pk PRIMARY KEY ( cod_produto );

CREATE TABLE segmento (
    cod_segmento NUMBER NOT NULL,
    nome         VARCHAR2(20)
);

ALTER TABLE segmento ADD CONSTRAINT segmento_pk PRIMARY KEY ( cod_segmento );

CREATE TABLE telefone (
    cod_telefone      NUMBER NOT NULL,
    numero            CHAR(9),
    ddd               NUMBER,
    pessoa_cod_pessoa NUMBER NOT NULL
);

ALTER TABLE telefone ADD CONSTRAINT telefone_pk PRIMARY KEY ( cod_telefone );

CREATE TABLE usuario (
    nome     VARCHAR2(50),
    senha    VARCHAR2(30),
    cod_user NUMBER NOT NULL
);

ALTER TABLE usuario ADD CONSTRAINT usuario_pk PRIMARY KEY ( cod_user );

ALTER TABLE bairro
    ADD CONSTRAINT bairro_cidade_fk FOREIGN KEY ( cidade_cod_cidade )
        REFERENCES cidade ( cod_cidade );

ALTER TABLE cidade
    ADD CONSTRAINT cidade_estado_fk FOREIGN KEY ( estado_cod_estado )
        REFERENCES estado ( cod_estado );

ALTER TABLE endereco
    ADD CONSTRAINT endereco_bairro_fk FOREIGN KEY ( bairro_cod_bairro )
        REFERENCES bairro ( cod_bairro );

ALTER TABLE endereco
    ADD CONSTRAINT endereco_pessoa_fk FOREIGN KEY ( pessoa_cod_pessoa )
        REFERENCES pessoa ( cod_pessoa );

ALTER TABLE estado
    ADD CONSTRAINT estado_pais_fk FOREIGN KEY ( pais_cod_pais )
        REFERENCES pais ( cod_pais );

ALTER TABLE pedido
    ADD CONSTRAINT pedido_frete_fk FOREIGN KEY ( frete_cod_frete )
        REFERENCES frete ( cod_frete );

ALTER TABLE pedido
    ADD CONSTRAINT pedido_pessoa_juridica_fk FOREIGN KEY ( pessoa_juridica_cnpj )
        REFERENCES pessoa_juridica ( cnpj );

ALTER TABLE pedido_produto
    ADD CONSTRAINT pedido_produto_pedido_fk FOREIGN KEY ( pedido_cod_pedido )
        REFERENCES pedido ( cod_pedido );

ALTER TABLE pedido_produto
    ADD CONSTRAINT pedido_produto_produto_fk FOREIGN KEY ( produto_cod_produto )
        REFERENCES produto ( cod_produto );

ALTER TABLE pessoa_juridica
    ADD CONSTRAINT pessoa_juridica_pessoa_fk FOREIGN KEY ( pessoa_cod_pessoa )
        REFERENCES pessoa ( cod_pessoa );

ALTER TABLE pessoa_juridica
    ADD CONSTRAINT pessoa_juridica_segmento_fk FOREIGN KEY ( segmento_cod_segmento )
        REFERENCES segmento ( cod_segmento );

ALTER TABLE pessoa
    ADD CONSTRAINT pessoa_usuario_fk FOREIGN KEY ( usuario_cod_user )
        REFERENCES usuario ( cod_user );

ALTER TABLE produto
    ADD CONSTRAINT produto_categoria_fk FOREIGN KEY ( categoria_cod_categoria )
        REFERENCES categoria ( cod_categoria );

ALTER TABLE telefone
    ADD CONSTRAINT telefone_pessoa_fk FOREIGN KEY ( pessoa_cod_pessoa )
        REFERENCES pessoa ( cod_pessoa );

        
--------------Funcoes de Validacao Telefone FUNCIONADNO-------------------------
set serveroutput on;
CREATE OR REPLACE FUNCTION validar_telefone (
    p_ddd IN NUMBER,
    p_numero IN CHAR
) RETURN BOOLEAN
IS
    v_pattern VARCHAR2(30) := '^\d{9}$';
BEGIN
    IF REGEXP_LIKE(p_numero, v_pattern) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
/

DECLARE
    v_ddd NUMBER := 11;  
    v_numero CHAR(9) := '123456789';  
    v_is_valid BOOLEAN;
BEGIN
    v_is_valid := validar_telefone(v_ddd, v_numero);

    IF v_is_valid THEN
        DBMS_OUTPUT.PUT_LINE('Numero de telefone valido.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Numero de telefone invalido.');
    END IF;
END;
/

--------------Função de Validação  Cep funcionando-------------------------
CREATE OR REPLACE FUNCTION validar_cep(p_cep IN CHAR) RETURN BOOLEAN IS
BEGIN
    IF REGEXP_LIKE(p_cep, '^\d{8}$') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
/

DECLARE
    v_cep CHAR(8) := '12345678';  -- Substitua pelo CEP que deseja validar
    v_is_valid BOOLEAN;
BEGIN
    v_is_valid := validar_cep(v_cep);

    IF v_is_valid THEN
        DBMS_OUTPUT.PUT_LINE('CEP valido.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('CEP invalido.');
    END IF;
END;
/

--------------Bloco anonimo com cursor para pelo uma consulta no banco de dados com um Join-------------------------
--O cursor c_pedido faz uma consulta que seleciona o cï¿½digo do pedido, a data de criaï¿½ï¿½o do pedido e o 
--nome da pessoa vinculada a esse pedido. --
DECLARE
   CURSOR c_pedido IS
      SELECT P.COD_PEDIDO, P.DATA_CRIACAO, PJ.CNPJ AS PESSOA_JURIDICA_CNPJ
      FROM PEDIDO P
      INNER JOIN PESSOA_JURIDICA PJ ON P.PESSOA_JURIDICA_CNPJ = PJ.CNPJ;

   v_cod_pedido NUMBER;
   v_data_criacao DATE;
   v_pessoa_juridica_cnpj CHAR(14);
BEGIN
   OPEN c_pedido;
   LOOP
      FETCH c_pedido INTO
         v_cod_pedido,
         v_data_criacao,
         v_pessoa_juridica_cnpj;

      EXIT WHEN c_pedido%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE('Código do Pedido: ' || v_cod_pedido);
      DBMS_OUTPUT.PUT_LINE('Data de Criação: ' || TO_CHAR(v_data_criacao, 'DD-MON-YYYY'));
      DBMS_OUTPUT.PUT_LINE('CNPJ Pessoa Jurídica: ' || v_pessoa_juridica_cnpj);
   END LOOP;

   CLOSE c_pedido;
END;
/

--------------Criar uma procedure que imprima um relatorio com pelo menos um regra de negï¿½cio, que contenha funï¿½ï¿½es, inner Join, order by, sum ou count.-------------------------
CREATE OR REPLACE PROCEDURE relatorio_produtos_mais_vendidos AS
BEGIN
    FOR produto_rec IN (
        SELECT
            P.NOME AS PRODUTO,
            COUNT(PP.PEDIDO_COD_PEDIDO) AS NUM_VENDAS
        FROM
            PRODUTO P
            INNER JOIN PEDIDO_PRODUTO PP ON P.COD_PRODUTO = PP.PRODUTO_COD_PRODUTO
        GROUP BY
            P.NOME
        ORDER BY
            NUM_VENDAS DESC
    ) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Produto: ' || produto_rec.PRODUTO);
        DBMS_OUTPUT.PUT_LINE('Nï¿½mero de Vendas: ' || produto_rec.NUM_VENDAS);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;
/
set serveroutput on;
BEGIN
    relatorio_produtos_mais_vendidos;
END;
/

--------------Criação das Procedures-------------------------
----Procedures bairro---
CREATE OR REPLACE PROCEDURE gerenciar_bairro (
    p_cod_bairro IN NUMBER,
    p_nome IN VARCHAR2,
    p_cidade_cod_cidade IN NUMBER,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO bairro (cod_bairro, nome, cidade_cod_cidade)
        VALUES (p_cod_bairro, p_nome, p_cidade_cod_cidade);
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE bairro
        SET nome = p_nome, cidade_cod_cidade = p_cidade_cod_cidade
        WHERE cod_bairro = p_cod_bairro;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM bairro
        WHERE cod_bairro = p_cod_bairro;
    END IF;
END;
/
----Procedures categoria---
CREATE OR REPLACE PROCEDURE gerenciar_categoria (
    p_cod_categoria IN NUMBER,
    p_categoria IN VARCHAR2,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO categoria (cod_categoria, categoria)
        VALUES (p_cod_categoria, p_categoria);
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE categoria
        SET categoria = p_categoria
        WHERE cod_categoria = p_cod_categoria;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM categoria
        WHERE cod_categoria = p_cod_categoria;
    END IF;
END;
/
----Procedures cidade---
CREATE OR REPLACE PROCEDURE gerenciar_cidade (
    p_cod_cidade IN NUMBER,
    p_nome IN VARCHAR2,
    p_cod_ibge IN NUMBER,
    p_estado_cod_estado IN NUMBER,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO cidade (cod_cidade, nome, cod_ibge, estado_cod_estado)
        VALUES (p_cod_cidade, p_nome, p_cod_ibge, p_estado_cod_estado);
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE cidade
        SET nome = p_nome, cod_ibge = p_cod_ibge, estado_cod_estado = p_estado_cod_estado
        WHERE cod_cidade = p_cod_cidade;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM cidade
        WHERE cod_cidade = p_cod_cidade;
    END IF;
END;
/
----Procedures endereco---
CREATE OR REPLACE PROCEDURE gerenciar_endereco (
    p_cod_endereco IN NUMBER,
    p_cep IN CHAR,
    p_logradouro IN VARCHAR2,
    p_numero IN CHAR,
    p_complemento IN VARCHAR2,
    p_bairro_cod_bairro IN NUMBER,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO endereco (cod_endereco, cep, logradouro, numero, complemento, bairro_cod_bairro)
        VALUES (p_cod_endereco, p_cep, p_logradouro, p_numero, p_complemento, p_bairro_cod_bairro);
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE endereco
        SET cep = p_cep, logradouro = p_logradouro, numero = p_numero, complemento = p_complemento, bairro_cod_bairro = p_bairro_cod_bairro
        WHERE cod_endereco = p_cod_endereco;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM endereco
        WHERE cod_endereco = p_cod_endereco;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE gerenciar_estado (
    p_cod_estado IN NUMBER,
    p_nome IN CHAR, 
    p_pais_cod_pais IN NUMBER,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO estado (cod_estado, nome, pais_cod_pais)
        VALUES (p_cod_estado, p_nome, p_pais_cod_pais);
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE estado
        SET nome = p_nome, pais_cod_pais = p_pais_cod_pais
        WHERE cod_estado = p_cod_estado;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM estado
        WHERE cod_estado = p_cod_estado;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE gerenciar_frete (
    p_cod_frete IN NUMBER,
    p_custo IN NUMBER,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO frete (cod_frete, custo)
        VALUES (p_cod_frete, p_custo);
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE frete
        SET custo = p_custo
        WHERE cod_frete = p_cod_frete;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM frete
        WHERE cod_frete = p_cod_frete;
    END IF;
END;
/
CREATE OR REPLACE PROCEDURE gerenciar_pais (
    p_cod_pais IN NUMBER,
    p_nome IN VARCHAR2,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO pais (cod_pais, nome)
        VALUES (p_cod_pais, p_nome);
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE pais
        SET nome = p_nome
        WHERE cod_pais = p_cod_pais;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM pais
        WHERE cod_pais = p_cod_pais;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE gerenciar_pedido (
    p_cod_pedido IN NUMBER,
    p_data_criacao IN DATE,
    p_data_atualizacao IN DATE,
    p_preco_total IN NUMBER,
    p_data_entrega IN DATE,
    p_numero_pedido IN NUMBER,
    p_descricao IN VARCHAR2,
    p_frete_cod_frete IN NUMBER,
    p_pessoa_juridica_cnpj IN CHAR
) AS
BEGIN
    INSERT INTO pedido (
        cod_pedido,
        data_criacao,
        data_atualizacao,
        preco_total,
        data_entrega,
        numero_pedido,
        descricao,
        frete_cod_frete,
        pessoa_juridica_cnpj
    ) VALUES (
        p_cod_pedido,
        p_data_criacao,
        p_data_atualizacao,
        p_preco_total,
        p_data_entrega,
        p_numero_pedido,
        p_descricao,
        p_frete_cod_frete,
        p_pessoa_juridica_cnpj
    );

    COMMIT; 

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLCODE || ' - ' || SQLERRM);
        ROLLBACK; 
END;
/
CREATE OR REPLACE PROCEDURE gerenciar_produto (
    p_cod_produto IN NUMBER,
    p_valor_unitario IN NUMBER,
    p_nome IN VARCHAR2,
    p_descricao IN VARCHAR2,
    p_sku IN CHAR,
    p_categoria_cod_categoria IN NUMBER,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO produto (
            cod_produto,
            valor_unitario,
            nome,
            descricao,
            sku,
            categoria_cod_categoria
        ) VALUES (
            p_cod_produto,
            p_valor_unitario,
            p_nome,
            p_descricao,
            p_sku,
            p_categoria_cod_categoria
        );
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE produto
        SET
            valor_unitario = p_valor_unitario,
            nome = p_nome,
            descricao = p_descricao,
            sku = p_sku,
            categoria_cod_categoria = p_categoria_cod_categoria
        WHERE cod_produto = p_cod_produto;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM produto
        WHERE cod_produto = p_cod_produto;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE gerenciar_pessoa (
    p_nome IN VARCHAR2,
    p_soft_delete IN CHAR,
    p_email IN VARCHAR2,
    p_cod_pessoa IN NUMBER,
    p_usuario_cod_user IN NUMBER,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO pessoa (
            nome,
            soft_delete,
            email,
            cod_pessoa,
            usuario_cod_user
        ) VALUES (
            p_nome,
            p_soft_delete,
            p_email,
            p_cod_pessoa,
            p_usuario_cod_user
        );
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE pessoa
        SET
            nome = p_nome,
            soft_delete = p_soft_delete,
            email = p_email,
            cod_pessoa = p_cod_pessoa,
            usuario_cod_user = p_usuario_cod_user
        WHERE cod_pessoa = p_cod_pessoa;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM pessoa
        WHERE cod_pessoa = p_cod_pessoa;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE gerenciar_pessoa_juridica (
    p_cnpj IN CHAR,
    p_pessoa_cod_pessoa IN NUMBER,
    p_segmento_cod_segmento IN NUMBER,
    p_tipo IN CHAR,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO pessoa_juridica (
            cnpj,
            pessoa_cod_pessoa,
            segmento_cod_segmento,
            tipo
        ) VALUES (
            p_cnpj,
            p_pessoa_cod_pessoa,
            p_segmento_cod_segmento,
            p_tipo
        );
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE pessoa_juridica
        SET
            pessoa_cod_pessoa = p_pessoa_cod_pessoa,
            segmento_cod_segmento = p_segmento_cod_segmento,
            tipo = p_tipo
        WHERE cnpj = p_cnpj;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM pessoa_juridica
        WHERE cnpj = p_cnpj;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE gerenciar_segmento (
    p_cod_segmento IN NUMBER,
    p_nome IN VARCHAR2,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO segmento (
            cod_segmento,
            nome
        ) VALUES (
            p_cod_segmento,
            p_nome
        );
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE segmento
        SET
            nome = p_nome
        WHERE cod_segmento = p_cod_segmento;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM segmento
        WHERE cod_segmento = p_cod_segmento;
    END IF;
END;
/


CREATE OR REPLACE PROCEDURE gerenciar_telefone (
    p_cod_telefone IN NUMBER,
    p_numero IN CHAR,
    p_pessoa_cod_pessoa IN NUMBER,
    p_ddd IN NUMBER,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO telefone (cod_telefone, numero, pessoa_cod_pessoa, ddd)
        VALUES (p_cod_telefone, p_numero, p_pessoa_cod_pessoa, p_ddd);
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE telefone
        SET numero = p_numero, ddd = p_ddd
        WHERE cod_telefone = p_cod_telefone;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM telefone
        WHERE cod_telefone = p_cod_telefone;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE gerenciar_usuario (
    p_nome IN VARCHAR2,
    p_senha IN VARCHAR2,
    p_cod_user IN NUMBER,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
        INSERT INTO usuario (
            nome,
            senha,
            cod_user
        ) VALUES (
            p_nome,
            p_senha,
            p_cod_user
        );
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE usuario
        SET
            nome = p_nome,
            senha = p_senha
        WHERE cod_user = p_cod_user;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM usuario
        WHERE cod_user = p_cod_user;
    END IF;
END;
/


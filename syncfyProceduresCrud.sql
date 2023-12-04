--Procedures para Insert, Update e Delete--

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

EXEC gerenciar_pais(1,'Holanda','INSERT');

CREATE OR REPLACE PROCEDURE gerenciar_estado (
    p_cod_estado IN NUMBER,
    p_nome IN VARCHAR, 
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

EXEC gerenciar_estado(1,'Paraiba',1,'INSERT');


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

EXEC gerenciar_cidade(1,'Sao Paulo',1,1,'INSERT');

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

EXEC gerenciar_bairro(1,'Jardim Fran�a',1,'INSERT');

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

EXEC gerenciar_usuario('Gabriel','34345',1,'INSERT');

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

EXEC gerenciar_pessoa('Gabriel','S','gabriel@nicaris@gmail.com',1,1,'INSERT');

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

EXEC gerenciar_segmento(1,'Medico','INSERT');


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

EXEC gerenciar_pessoa_juridica (15948721569808,1,1,'empresasss','INSERT');


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
EXEC gerenciar_frete (1,100,'INSERT');

CREATE OR REPLACE PROCEDURE gerenciar_pedido (
    p_cod_pedido IN NUMBER,
    p_data_criacao IN DATE,
    p_data_atualizacao IN DATE,
    p_preco_total IN NUMBER,
    p_data_entrega IN DATE,
    p_numero_pedido IN NUMBER,
    p_descricao IN VARCHAR2,
    p_frete_cod_frete IN NUMBER,
    p_pessoa_juridica_cnpj IN CHAR,
    p_operacao IN VARCHAR2
) AS
BEGIN
    IF p_operacao = 'INSERT' THEN
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
    ELSIF p_operacao = 'UPDATE' THEN
        UPDATE pedido
        SET
            data_criacao = p_data_criacao,
            data_atualizacao = p_data_atualizacao,
            preco_total = p_preco_total,
            data_entrega = p_data_entrega,
            numero_pedido = p_numero_pedido,
            descricao = p_descricao,
            frete_cod_frete = p_frete_cod_frete,
            pessoa_juridica_cnpj = p_pessoa_juridica_cnpj
        WHERE cod_pedido = p_cod_pedido;
    ELSIF p_operacao = 'DELETE' THEN
        DELETE FROM pedido
        WHERE cod_pedido = p_cod_pedido;
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLCODE || ' - ' || SQLERRM);
        ROLLBACK; 
END;
/

EXEC gerenciar_pedido (1,'02/12/23','02/12/23',100,'02/12/23',1,'Quadro colorido',1,15948721569808,'INSERT');

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

EXEC gerenciar_categoria (1,'squi','INSERT');


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
EXEC gerenciar_produto (1,232,'Tablet','tecnologico','tecngicopp',1,'INSERT');



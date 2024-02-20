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
    nome          VARCHAR(30) NOT NULL,
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

CREATE TABLE log_erros (
  id_erro         NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  codigo_erro     VARCHAR2(100),
  mensagem_erro   VARCHAR2(4000),
  data_ocorrencia DATE,
  usuario         VARCHAR2(100)
);

CREATE TABLE monitoramento_atualizacao_pedido (
    cod_pedido NUMBER,
    data_atualizacao DATE,
    usuario VARCHAR2(100)
);
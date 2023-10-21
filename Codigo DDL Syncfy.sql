CREATE TABLE address (
    id NUMBER NOT NULL,
    street VARCHAR2(50),
    neighborhood VARCHAR2(50),
    "Number"     CHAR(5),
    complement   VARCHAR2(50),
    zip_code     CHAR(8),
    city         VARCHAR2(50),
    ibge_code    CHAR(7),
    uf           CHAR(2),
    country      VARCHAR2(50),
    company_user_id   NUMBER NOT NULL,
    company_user_cnpj CHAR(14) NOT NULL,
    vendor_id         NUMBER NOT NULL,
    vendor_cnpj       NUMBER NOT NULL, 
    cmp_usr_addr_cmp_usr_id   NUMBER NOT NULL, --company_user_address_company_user_id 
    cmp_usr_addr_cmp_usr_cnpj CHAR(14) NOT NULL, -- company_user_address_company_user_cnpj
    vendor_address_vendor_id  NUMBER NOT NULL,
    vendor_address_vendor_cnpj NUMBER NOT NULL,
    company_user_address_id    NUMBER NOT NULL,
    vendor_address_id          NUMBER NOT NULL
);

CREATE UNIQUE INDEX address__idx ON
    address (
        cmp_usr_addr_cmp_usr_id    --company_user_address_company_user_id
    ASC,
        cmp_usr_addr_cmp_usr_cnpj   -- company_user_address_company_user_cnpj
    ASC,
        company_user_address_id
    ASC );

CREATE UNIQUE INDEX address__idxv1 ON
    address (
        vendor_address_vendor_id
    ASC,
        vendor_address_vendor_cnpj
    ASC,
        vendor_address_id
    ASC );

ALTER TABLE address ADD CONSTRAINT address_pk PRIMARY KEY ( id );

CREATE TABLE category (
    id                    NUMBER NOT NULL,
    category              VARCHAR2(20),
    material_id           NUMBER NOT NULL,
    material_product_code CHAR(10) 
     NOT NULL
);

CREATE UNIQUE INDEX category__idx ON
    category (
        material_id
    ASC,
        material_product_code
    ASC );

ALTER TABLE category ADD CONSTRAINT category_pk PRIMARY KEY ( id );

CREATE TABLE city (
    id         NUMBER NOT NULL,
    city       VARCHAR2(20),
    address_id NUMBER NOT NULL
);

CREATE UNIQUE INDEX city__idx ON
    city (
        address_id
    ASC );

ALTER TABLE city ADD CONSTRAINT city_pk PRIMARY KEY ( id );

CREATE TABLE company_user (
    id          NUMBER NOT NULL,
    cnpj        CHAR(14) NOT NULL,
    name        VARCHAR2(50),
    soft_delete CHAR(1),
    email       VARCHAR2(150),
    password    VARCHAR2(30)
);

ALTER TABLE company_user ADD CONSTRAINT company_user_pk PRIMARY KEY ( id,
                                                                      cnpj );

CREATE TABLE company_user_address (
    company_user_id   NUMBER NOT NULL,
    company_user_cnpj CHAR(14) NOT NULL,
    id                NUMBER NOT NULL,
    shipping_cost_id  NUMBER NOT NULL
);

CREATE UNIQUE INDEX company_user_address__idx ON
    company_user_address (
        shipping_cost_id
    ASC );

ALTER TABLE company_user_address
    ADD CONSTRAINT company_user_address_pk PRIMARY KEY ( company_user_id,
                                                         company_user_cnpj,
                                                         id );

CREATE TABLE country (
    address_id NUMBER NOT NULL,
    id         NUMBER NOT NULL,
    country    VARCHAR2(20) 
);

CREATE UNIQUE INDEX country__idx ON
    country (
        address_id
    ASC );

ALTER TABLE country ADD CONSTRAINT country_pk PRIMARY KEY ( id );

CREATE TABLE ddd (
    phone_id NUMBER NOT NULL,
    id       NUMBER NOT NULL,
    ddd      NUMBER
);

CREATE UNIQUE INDEX ddd__idx ON
    ddd (
        phone_id
    ASC );

ALTER TABLE ddd ADD CONSTRAINT ddd_pk PRIMARY KEY ( id );

CREATE TABLE ibge_code (
    address_id NUMBER NOT NULL,
    id         NUMBER NOT NULL,
    ibge_code  NUMBER
);

CREATE UNIQUE INDEX ibge_code__idx ON
    ibge_code (
        address_id
    ASC );

ALTER TABLE ibge_code ADD CONSTRAINT ibge_code_pk PRIMARY KEY ( id );

CREATE TABLE material (
    id                             NUMBER NOT NULL,
    unit_amount                    NUMBER,
    name                           VARCHAR2(20),
    description                    VARCHAR2(250),
    product_code                   CHAR(10) NOT NULL,
    vendor_id                      NUMBER NOT NULL,
    vendor_cnpj                    NUMBER NOT NULL,
    materialorder_materialorder_id NUMBER NOT NULL
);

ALTER TABLE material ADD CONSTRAINT material_pk PRIMARY KEY ( id,
                                                              product_code );

CREATE TABLE materialorder (
    quantity         NUMBER,
    order_id         NUMBER NOT NULL,
    materialorder_id NUMBER NOT NULL
);

CREATE UNIQUE INDEX materialorder__idx ON
    materialorder (
        order_id
    ASC );

ALTER TABLE materialorder ADD CONSTRAINT materialorder_pk PRIMARY KEY ( materialorder_id );

CREATE TABLE neighborhood (
    address_id   NUMBER NOT NULL,
    id           NUMBER NOT NULL,
    neighborhood VARCHAR2(30) 
);

CREATE UNIQUE INDEX neighborhood__idx ON
    neighborhood (
        address_id
    ASC );

ALTER TABLE neighborhood ADD CONSTRAINT neighborhood_pk PRIMARY KEY ( id );

CREATE TABLE "Order" (
    id                NUMBER NOT NULL,
    created_at        VARCHAR2(20),
    updated_at        VARCHAR2(30),
    total_amount      NUMBER,
    delivery_date     VARCHAR2(20),
    order_number      NUMBER,
    description_order VARCHAR2(250), --description
    vendor_id         NUMBER NOT NULL,
    vendor_cnpj       NUMBER NOT NULL,
    company_user_id   NUMBER NOT NULL,
    company_user_cnpj CHAR(14) NOT NULL
);

ALTER TABLE "Order" ADD CONSTRAINT order_pk PRIMARY KEY ( id );

CREATE TABLE phone (
    id                NUMBER NOT NULL,
    ddd               CHAR(2),
    "Number"          CHAR(9),
    company_user_id   NUMBER NOT NULL,
    company_user_cnpj CHAR(14) NOT NULL,
    vendor_id         NUMBER NOT NULL,
    vendor_cnpj       NUMBER NOT NULL,
    ddd_id            NUMBER NOT NULL
);

ALTER TABLE phone ADD CONSTRAINT phone_pk PRIMARY KEY ( id );

CREATE TABLE segment (
    id                    NUMBER NOT NULL,
    segment               VARCHAR2(20),
    material_id           NUMBER NOT NULL,
    material_product_code CHAR(10) NOT NULL,
    vendor_id             NUMBER NOT NULL,
    vendor_cnpj           NUMBER NOT NULL
);

CREATE UNIQUE INDEX segment_type__idx ON
    segment (
        material_id
    ASC,
        material_product_code
    ASC );

ALTER TABLE segment ADD CONSTRAINT segment_type_pk PRIMARY KEY ( id );

CREATE TABLE shipping_cost (
    id                          NUMBER NOT NULL,
    "Source_Address(address)"   varchar2(30),
    "Delivery_Address(address)" varchar2(30),
    cost                        NUMBER,
    order_id                    NUMBER NOT NULL,
    vendor_id                   NUMBER NOT NULL,
    vendor_cnpj                 NUMBER NOT NULL
);

CREATE UNIQUE INDEX shipping_cost__idx ON
    shipping_cost (
        vendor_id
    ASC,
        vendor_cnpj
    ASC );

CREATE UNIQUE INDEX shipping_cost__idxv1 ON
    shipping_cost (
        order_id
    ASC );

ALTER TABLE shipping_cost ADD CONSTRAINT shipping_cost_pk PRIMARY KEY ( id );

CREATE TABLE uf (
    id         NUMBER NOT NULL,
    uf         CHAR(2) NOT NULL,
    address_id NUMBER NOT NULL
);

CREATE UNIQUE INDEX uf__idx ON
    uf (
        address_id
    ASC );

ALTER TABLE uf ADD CONSTRAINT uf_pk PRIMARY KEY ( id );

CREATE TABLE vendor (
    id    NUMBER NOT NULL,
    cnpj  NUMBER NOT NULL,
    name  VARCHAR2(50),
    email VARCHAR2(150)
);

ALTER TABLE vendor ADD CONSTRAINT vendor_pk PRIMARY KEY ( id,
                                                          cnpj );

CREATE TABLE vendor_address (
    vendor_id        NUMBER NOT NULL,
    vendor_cnpj      NUMBER NOT NULL,
    id               NUMBER NOT NULL,
    shipping_cost_id NUMBER NOT NULL
);

CREATE UNIQUE INDEX vendor_address__idx ON
    vendor_address (
        shipping_cost_id
    ASC );

ALTER TABLE vendor_address
    ADD CONSTRAINT vendor_address_pk PRIMARY KEY ( vendor_id,
                                                   vendor_cnpj,
                                                   id );

CREATE TABLE zip_code (
    id         NUMBER NOT NULL,
    address_id NUMBER NOT NULL,
    zip_code   NUMBER
);

CREATE UNIQUE INDEX zip_code__idx ON
    zip_code (
        address_id
    ASC );

ALTER TABLE zip_code ADD CONSTRAINT zip_code_pk PRIMARY KEY ( id );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE address --address_company_user_address_fk       
    ADD CONSTRAINT addr_cmpny_usr_addr_fk FOREIGN KEY ( cmp_usr_addr_cmp_usr_id    , --company_user_address_company_user_id
                                                                 cmp_usr_addr_cmp_usr_cnpj, ---- company_user_address_company_user_cnpj
                                                                 company_user_address_id )
        REFERENCES company_user_address ( company_user_id,
                                          company_user_cnpj,
                                          id );

ALTER TABLE address
    ADD CONSTRAINT address_company_user_fk FOREIGN KEY ( company_user_id,
                                                         company_user_cnpj )
        REFERENCES company_user ( id,
                                  cnpj );

ALTER TABLE address
    ADD CONSTRAINT address_vendor_address_fk FOREIGN KEY ( vendor_address_vendor_id,
                                                           vendor_address_vendor_cnpj,
                                                           vendor_address_id )
        REFERENCES vendor_address ( vendor_id,
                                    vendor_cnpj,
                                    id );

ALTER TABLE address
    ADD CONSTRAINT address_vendor_fk FOREIGN KEY ( vendor_id,
                                                   vendor_cnpj )
        REFERENCES vendor ( id,
                            cnpj );

ALTER TABLE category
    ADD CONSTRAINT category_material_fk FOREIGN KEY ( material_id,
                                                      material_product_code )
        REFERENCES material ( id,
                              product_code );

ALTER TABLE city
    ADD CONSTRAINT city_address_fk FOREIGN KEY ( address_id )
        REFERENCES address ( id );

ALTER TABLE company_user_address
    ADD CONSTRAINT cmp_usr_addr_cmpny_usr_fk FOREIGN KEY ( company_user_id,           --company_user_address_company_user_fk 
                                                        company_user_cnpj )
        REFERENCES company_user ( id,
                                  cnpj );


ALTER TABLE company_user_address
    ADD CONSTRAINT cmp_usr_addr_ship_cost_fk FOREIGN KEY ( shipping_cost_id ) --company_user_address_shipping_cost_fk
        REFERENCES shipping_cost ( id );

ALTER TABLE country
    ADD CONSTRAINT country_address_fk FOREIGN KEY ( address_id )
        REFERENCES address ( id );

ALTER TABLE ddd
    ADD CONSTRAINT ddd_phone_fk FOREIGN KEY ( phone_id )
        REFERENCES phone ( id );

ALTER TABLE ibge_code
    ADD CONSTRAINT ibge_code_address_fk FOREIGN KEY ( address_id )
        REFERENCES address ( id );

ALTER TABLE material
    ADD CONSTRAINT material_materialorder_fk FOREIGN KEY ( materialorder_materialorder_id )
        REFERENCES materialorder ( materialorder_id );

ALTER TABLE material
    ADD CONSTRAINT material_vendor_fk FOREIGN KEY ( vendor_id,
                                                    vendor_cnpj )
        REFERENCES vendor ( id,
                            cnpj );

ALTER TABLE materialorder
    ADD CONSTRAINT materialorder_order_fk FOREIGN KEY ( order_id )
        REFERENCES "Order" ( id );

ALTER TABLE neighborhood
    ADD CONSTRAINT neighborhood_address_fk FOREIGN KEY ( address_id )
        REFERENCES address ( id );

ALTER TABLE "Order"
    ADD CONSTRAINT order_company_user_fk FOREIGN KEY ( company_user_id,
                                                       company_user_cnpj )
        REFERENCES company_user ( id,
                                  cnpj );

ALTER TABLE "Order"
    ADD CONSTRAINT order_vendor_fk FOREIGN KEY ( vendor_id,
                                                 vendor_cnpj )
        REFERENCES vendor ( id,
                            cnpj );

ALTER TABLE phone
    ADD CONSTRAINT phone_company_user_fk FOREIGN KEY ( company_user_id,
                                                       company_user_cnpj )
        REFERENCES company_user ( id,
                                  cnpj );

ALTER TABLE phone
    ADD CONSTRAINT phone_ddd_fk FOREIGN KEY ( ddd_id )
        REFERENCES ddd ( id );

ALTER TABLE phone
    ADD CONSTRAINT phone_vendor_fk FOREIGN KEY ( vendor_id,
                                                 vendor_cnpj )
        REFERENCES vendor ( id,
                            cnpj );

ALTER TABLE segment
    ADD CONSTRAINT segment_type_material_fk FOREIGN KEY ( material_id,
                                                          material_product_code )
        REFERENCES material ( id,
                              product_code );

ALTER TABLE segment
    ADD CONSTRAINT segment_vendor_fk FOREIGN KEY ( vendor_id,
                                                   vendor_cnpj )
        REFERENCES vendor ( id,
                            cnpj );

ALTER TABLE shipping_cost
    ADD CONSTRAINT shipping_cost_order_fk FOREIGN KEY ( order_id )
        REFERENCES "Order" ( id );

ALTER TABLE shipping_cost
    ADD CONSTRAINT shipping_cost_vendor_fk FOREIGN KEY ( vendor_id,
                                                         vendor_cnpj )
        REFERENCES vendor ( id,
                            cnpj );

ALTER TABLE uf
    ADD CONSTRAINT uf_address_fk FOREIGN KEY ( address_id )
        REFERENCES address ( id );

ALTER TABLE vendor_address
    ADD CONSTRAINT vend_addr_ship_cost_fk FOREIGN KEY ( shipping_cost_id ) --vendor_address_shipping_cost_fk
        REFERENCES shipping_cost ( id );

ALTER TABLE vendor_address
    ADD CONSTRAINT vendor_address_vendor_fk FOREIGN KEY ( vendor_id,
                                                          vendor_cnpj )
        REFERENCES vendor ( id,
                            cnpj );

ALTER TABLE zip_code
    ADD CONSTRAINT zip_code_address_fk FOREIGN KEY ( address_id )
        REFERENCES address ( id );

CREATE SEQUENCE materialorder_materialorder_id START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER materialorder_materialorder_id BEFORE
    INSERT ON materialorder
    FOR EACH ROW
    WHEN ( new.materialorder_id IS NULL )
BEGIN
    :new.materialorder_id := materialorder_materialorder_id.nextval;
END;
/


-- Inserir na tabela company_user
INSERT INTO company_user (id, cnpj, name, soft_delete, email, password) VALUES (1, '12345678901234', 'Empresa A', 'N', 'empresaA@email.com', 'senhaA');
INSERT INTO company_user (id, cnpj, name, soft_delete, email, password) VALUES (2, '98765432109876', 'Empresa B', 'N', 'empresaB@email.com', 'senhaB');
INSERT INTO company_user (id, cnpj, name, soft_delete, email, password) VALUES (3, '11112222333344', 'Empresa C', 'N', 'empresaC@email.com', 'senhaC');
INSERT INTO company_user (id, cnpj, name, soft_delete, email, password) VALUES (4, '55556666777788', 'Empresa D', 'N', 'empresaD@email.com', 'senhaD');
INSERT INTO company_user (id, cnpj, name, soft_delete, email, password) VALUES (5, '99990000111122', 'Empresa E', 'N', 'empresaE@email.com', 'senhaE');

-- Inserir na tabela vendor
INSERT INTO vendor (id, cnpj, name, email) VALUES (1, '98765432100123', 'Fornecedor X', 'fornecedorX@email.com');
INSERT INTO vendor (id, cnpj, name, email) VALUES (2, '11112222333445', 'Fornecedor Y', 'fornecedorY@email.com');
INSERT INTO vendor (id, cnpj, name, email) VALUES (3, '55556666777889', 'Fornecedor Z', 'fornecedorZ@email.com');
INSERT INTO vendor (id, cnpj, name, email) VALUES (4, '99990000111223', 'Fornecedor W', 'fornecedorW@email.com');
INSERT INTO vendor (id, cnpj, name, email) VALUES (5, '88889999111234', 'Fornecedor V', 'fornecedorV@email.com');

-- Inserir na tabela VENDOR_ADDRESS
INSERT INTO VENDOR_ADDRESS (VENDOR_ID, VENDOR_CNPJ, ID, SHIPPING_COST_ID)
VALUES (1, '98765432100123', 1, 1);
INSERT INTO VENDOR_ADDRESS (VENDOR_ID, VENDOR_CNPJ, ID, SHIPPING_COST_ID)
VALUES (2, '11112222333445', 2, 6);
INSERT INTO VENDOR_ADDRESS (VENDOR_ID, VENDOR_CNPJ, ID, SHIPPING_COST_ID)
VALUES (3, '55556666777889', 3, 3);
INSERT INTO VENDOR_ADDRESS (VENDOR_ID, VENDOR_CNPJ, ID, SHIPPING_COST_ID)
VALUES (4, '99990000111223', 4, 4);
INSERT INTO VENDOR_ADDRESS (VENDOR_ID, VENDOR_CNPJ, ID, SHIPPING_COST_ID)
VALUES (5, '88889999111234', 5, 5);

-- Inserir na tabela "Order" 
INSERT INTO "Order" (id, created_at, updated_at, total_amount, delivery_date, order_number, description_order, vendor_id, vendor_cnpj, company_user_id, company_user_cnpj) VALUES (2, '2023-10-21', '2023-10-21', 150.0, '2023-10-28', 2, 'Pedido de Material B', 2, '11112222333445', 1, '12345678901234');
INSERT INTO "Order" (id, created_at, updated_at, total_amount, delivery_date, order_number, description_order, vendor_id, vendor_cnpj, company_user_id, company_user_cnpj) VALUES (3, '2023-10-22', '2023-10-22', 75.0, '2023-10-29', 3, 'Pedido de Material C', 3, '55556666777889', 1, '12345678901234');
INSERT INTO "Order" (id, created_at, updated_at, total_amount, delivery_date, order_number, description_order, vendor_id, vendor_cnpj, company_user_id, company_user_cnpj) VALUES (4, '2023-10-23', '2023-10-23', 200.0, '2023-10-30', 4, 'Pedido de Material D', 4, '99990000111223', 1, '12345678901234');
INSERT INTO "Order" (id, created_at, updated_at, total_amount, delivery_date, order_number, description_order, vendor_id, vendor_cnpj, company_user_id, company_user_cnpj) VALUES (5, '2023-10-24', '2023-10-24', 90.0, '2023-10-31', 5, 'Pedido de Material E', 5, '88889999111234', 1, '12345678901234');

-- Inserir na tabela shipping_cost
INSERT INTO shipping_cost (id, "Source_Address(address)", "Delivery_Address(address)", cost, order_id, vendor_id, vendor_cnpj) VALUES (1, 'Endere�o Origem', 'Endere�o Destino', 50.0, 1, 1, '98765432100123');
INSERT INTO shipping_cost (id, "Source_Address(address)", "Delivery_Address(address)", cost, order_id, vendor_id, vendor_cnpj) VALUES (3, 'Endere�o X','Endere�o Y', 45.0, 2,2,'11112222333445');
INSERT INTO shipping_cost (id, "Source_Address(address)", "Delivery_Address(address)", cost, order_id, vendor_id, vendor_cnpj) VALUES (4, 'Endere�o P','Endere�o Q', 75.0, 3 ,3, '55556666777889');
INSERT INTO shipping_cost (id, "Source_Address(address)", "Delivery_Address(address)", cost, order_id, vendor_id, vendor_cnpj) VALUES (5, 'Endere�o K', 'Endere�o L', 55.0, 4, 4, '99990000111223');
INSERT INTO shipping_cost (id, "Source_Address(address)", "Delivery_Address(address)", cost, order_id, vendor_id, vendor_cnpj) VALUES (6, 'Endere�o M','Endere�o N', 70.0, 5, 5, '88889999111234');

-- Inserir na tabela material
INSERT INTO material (id, unit_amount, name, description, product_code, vendor_id, vendor_cnpj, materialorder_materialorder_id)
VALUES (1, 10, 'Material A', 'Descri��o Material A', 'MATERIAL01', 1, '98765432100123', 1);
INSERT INTO material (id, unit_amount, name, description, product_code, vendor_id, vendor_cnpj, materialorder_materialorder_id)
VALUES (2, 15, 'Material B', 'Descri��o Material B', 'MATERIAL02', 2, '11112222333445', 2);
INSERT INTO material (id, unit_amount, name, description, product_code, vendor_id, vendor_cnpj, materialorder_materialorder_id)
VALUES (3, 12, 'Material C', 'Descri��o Material C', 'MATERIAL03', 3, '55556666777889', 3);
INSERT INTO material (id, unit_amount, name, description, product_code, vendor_id, vendor_cnpj, materialorder_materialorder_id)
VALUES (4, 8, 'Material D', 'Descri��o Material D', 'MATERIAL04', 4, '99990000111223', 4);
INSERT INTO material (id, unit_amount, name, description, product_code, vendor_id, vendor_cnpj, materialorder_materialorder_id)
VALUES (5, 20, 'Material E', 'Descri��o Material E', 'MATERIAL05', 5, '88889999111234', 5);

-- Inserir na tabela MATERIALORDER
INSERT INTO MATERIALORDER (QUANTITY, ORDER_ID, MATERIALORDER_ID) VALUES (10, 1, 1);
INSERT INTO MATERIALORDER (QUANTITY, ORDER_ID, MATERIALORDER_ID) VALUES (20, 2, 2);
INSERT INTO MATERIALORDER (QUANTITY, ORDER_ID, MATERIALORDER_ID) VALUES (15, 3, 3);
INSERT INTO MATERIALORDER (QUANTITY, ORDER_ID, MATERIALORDER_ID) VALUES (30, 4, 4);
INSERT INTO MATERIALORDER (QUANTITY, ORDER_ID, MATERIALORDER_ID) VALUES (25, 5, 5);

-- Inserir na tabela SEGMENT
INSERT INTO SEGMENT (ID, SEGMENT, MATERIAL_ID, MATERIAL_PRODUCT_CODE, VENDOR_ID, VENDOR_CNPJ)
VALUES (1, 'Segmento A', 1, 'MATERIAL01', 1, '98765432100123');
INSERT INTO SEGMENT (ID, SEGMENT, MATERIAL_ID, MATERIAL_PRODUCT_CODE, VENDOR_ID, VENDOR_CNPJ)
VALUES (2, 'Segmento B', 2, 'MATERIAL02', 2, '11112222333445');
INSERT INTO SEGMENT (ID, SEGMENT, MATERIAL_ID, MATERIAL_PRODUCT_CODE, VENDOR_ID, VENDOR_CNPJ)
VALUES (3, 'Segmento C', 3, 'MATERIAL03', 3, '55556666777889');
INSERT INTO SEGMENT (ID, SEGMENT, MATERIAL_ID, MATERIAL_PRODUCT_CODE, VENDOR_ID, VENDOR_CNPJ)
VALUES (4, 'Segmento D', 4, 'MATERIAL04', 4, '99990000111223');
INSERT INTO SEGMENT (ID, SEGMENT, MATERIAL_ID, MATERIAL_PRODUCT_CODE, VENDOR_ID, VENDOR_CNPJ)
VALUES (5, 'Segmento E', 5, 'MATERIAL05', 5, '88889999111234');

-- Inserir na tabela CATEGORY
INSERT INTO CATEGORY (ID, CATEGORY, MATERIAL_ID, MATERIAL_PRODUCT_CODE)
VALUES (1, 'Categoria A', 1, 'MATERIAL01');
INSERT INTO CATEGORY (ID, CATEGORY, MATERIAL_ID, MATERIAL_PRODUCT_CODE)
VALUES (2, 'Categoria B', 2, 'MATERIAL02');
INSERT INTO CATEGORY (ID, CATEGORY, MATERIAL_ID, MATERIAL_PRODUCT_CODE)
VALUES (3, 'Categoria C', 3, 'MATERIAL03');
INSERT INTO CATEGORY (ID, CATEGORY, MATERIAL_ID, MATERIAL_PRODUCT_CODE)
VALUES (4, 'Categoria D', 4, 'MATERIAL04');
INSERT INTO CATEGORY (ID, CATEGORY, MATERIAL_ID, MATERIAL_PRODUCT_CODE)
VALUES (5, 'Categoria E', 5, 'MATERIAL05');

-- Inserir na tabela COMPANY_USER_ADDRESS
INSERT INTO COMPANY_USER_ADDRESS (COMPANY_USER_ID, COMPANY_USER_CNPJ, ID, SHIPPING_COST_ID) VALUES (1, '12345678901234', 1, 1);
INSERT INTO COMPANY_USER_ADDRESS (COMPANY_USER_ID, COMPANY_USER_CNPJ, ID, SHIPPING_COST_ID) VALUES (2, '98765432109876', 2, 3);
INSERT INTO COMPANY_USER_ADDRESS (COMPANY_USER_ID, COMPANY_USER_CNPJ, ID, SHIPPING_COST_ID) VALUES (3, '11112222333344', 3, 4);
INSERT INTO COMPANY_USER_ADDRESS (COMPANY_USER_ID, COMPANY_USER_CNPJ, ID, SHIPPING_COST_ID) VALUES (4, '55556666777788', 4, 5);
INSERT INTO COMPANY_USER_ADDRESS (COMPANY_USER_ID, COMPANY_USER_CNPJ, ID, SHIPPING_COST_ID) VALUES (5, '99990000111122', 5, 6);

--Insert uf   NAO DEU CERTO
INSERT INTO uf (ID, UF, ADDRESS_ID) VALUES (1, 'SP', 101);
INSERT INTO uf (ID, UF, ADDRESS_ID) VALUES (2, 'RJ', 102);
INSERT INTO uf (ID, UF, ADDRESS_ID) VALUES (3, 'MG', 103);
INSERT INTO uf (ID, UF, ADDRESS_ID) VALUES (4, 'PR', 104);
INSERT INTO uf (ID, UF, ADDRESS_ID) VALUES (5, 'RS', 105);





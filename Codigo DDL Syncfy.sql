drop table ADDRESS cascade constraints;
drop table category cascade constraints;
drop table city cascade constraints;
drop table COMPANY_USER cascade constraints;
drop table COMPANY_USER_ADDRESS cascade constraints;
drop table COUNTRY cascade constraints;
drop table DDD cascade constraints;
drop table IBGE_CODE cascade constraints;
drop table MATERIAL cascade constraints;
drop table shipping_cost cascade constraints;
drop table UF cascade constraints;
drop table MATERIALORDER cascade constraints;
drop table NEIGHBORHOOD cascade constraints;
drop table "Order" cascade constraints;
drop table PHONE cascade constraints;
drop table VENDOR cascade constraints;
drop table VENDOR_ADDRESS cascade constraints;
drop table ZIP_CODE cascade constraints;
drop table SEGMENT cascade constraints;
DROP SEQUENCE materialorder_materialorder_id;


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

--ALTER TABLE phone
    --ADD CONSTRAINT phone_ddd_fk FOREIGN KEY ( ddd_id )
        --REFERENCES ddd ( id );
alter table phone 
add constraint ddd_id_fk foreign key (ddd_id) references ddd(id)        

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

INSERT INTO company_user (id, cnpj, name, soft_delete, email, password) VALUES (1, '12345678901234', 'Empresa A', 'N', 'empresaA@email.com', 'senhaA');
INSERT INTO company_user (id, cnpj, name, soft_delete, email, password) VALUES (2, '98765432109876', 'Empresa B', 'N', 'empresaB@email.com', 'senhaB');
INSERT INTO company_user (id, cnpj, name, soft_delete, email, password) VALUES (3, '11112222333344', 'Empresa C', 'N', 'empresaC@email.com', 'senhaC');
INSERT INTO company_user (id, cnpj, name, soft_delete, email, password) VALUES (4, '55556666777788', 'Empresa D', 'N', 'empresaD@email.com', 'senhaD');
INSERT INTO company_user (id, cnpj, name, soft_delete, email, password) VALUES (5, '99990000111122', 'Empresa E', 'N', 'empresaE@email.com', 'senhaE');

INSERT INTO vendor (id, cnpj, name, email) VALUES (1, '98765432100123', 'Fornecedor X', 'fornecedorX@email.com');
INSERT INTO vendor (id, cnpj, name, email) VALUES (2, '11112222333445', 'Fornecedor Y', 'fornecedorY@email.com');
INSERT INTO vendor (id, cnpj, name, email) VALUES (3, '55556666777889', 'Fornecedor Z', 'fornecedorZ@email.com');
INSERT INTO vendor (id, cnpj, name, email) VALUES (4, '99990000111223', 'Fornecedor W', 'fornecedorW@email.com');
INSERT INTO vendor (id, cnpj, name, email) VALUES (5, '88889999111234', 'Fornecedor V', 'fornecedorV@email.com');

INSERT INTO "Order" (id, created_at, updated_at, total_amount, delivery_date, order_number, description_order, vendor_id, vendor_cnpj, company_user_id, company_user_cnpj) VALUES (1, '2023-10-21', '2023-10-21', 170.0, '2023-10-28', 1, 'Pedido de Material B', 1, '98765432100123', 1, '12345678901234');
INSERT INTO "Order" (id, created_at, updated_at, total_amount, delivery_date, order_number, description_order, vendor_id, vendor_cnpj, company_user_id, company_user_cnpj) VALUES (2, '2023-10-21', '2023-10-21', 150.0, '2023-10-28', 2, 'Pedido de Material B', 2, '11112222333445', 1, '12345678901234');
INSERT INTO "Order" (id, created_at, updated_at, total_amount, delivery_date, order_number, description_order, vendor_id, vendor_cnpj, company_user_id, company_user_cnpj) VALUES (3, '2023-10-22', '2023-10-22', 75.0, '2023-10-29', 3, 'Pedido de Material C', 3, '55556666777889', 1, '12345678901234');
INSERT INTO "Order" (id, created_at, updated_at, total_amount, delivery_date, order_number, description_order, vendor_id, vendor_cnpj, company_user_id, company_user_cnpj) VALUES (4, '2023-10-23', '2023-10-23', 200.0, '2023-10-30', 4, 'Pedido de Material D', 4, '99990000111223', 1, '12345678901234');
INSERT INTO "Order" (id, created_at, updated_at, total_amount, delivery_date, order_number, description_order, vendor_id, vendor_cnpj, company_user_id, company_user_cnpj) VALUES (5, '2023-10-24', '2023-10-24', 90.0, '2023-10-31', 5, 'Pedido de Material E', 5, '88889999111234', 1, '12345678901234');

INSERT INTO shipping_cost (id, "Source_Address(address)", "Delivery_Address(address)", cost, order_id, vendor_id, vendor_cnpj) VALUES (1, 'Endereço Origem', 'Endereço Destino', 50.0, 1, 1, '98765432100123');
INSERT INTO shipping_cost (id, "Source_Address(address)", "Delivery_Address(address)", cost, order_id, vendor_id, vendor_cnpj) VALUES (3, 'Endereço X','Endereço Y', 45.0, 2,2,'11112222333445');
INSERT INTO shipping_cost (id, "Source_Address(address)", "Delivery_Address(address)", cost, order_id, vendor_id, vendor_cnpj) VALUES (4, 'Endereço P','Endereço Q', 75.0, 3 ,3, '55556666777889');
INSERT INTO shipping_cost (id, "Source_Address(address)", "Delivery_Address(address)", cost, order_id, vendor_id, vendor_cnpj) VALUES (5, 'Endereço K', 'Endereço L', 55.0, 4, 4, '99990000111223');
INSERT INTO shipping_cost (id, "Source_Address(address)", "Delivery_Address(address)", cost, order_id, vendor_id, vendor_cnpj) VALUES (6, 'Endereço M','Endereço N', 70.0, 5, 5, '88889999111234');

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

INSERT INTO MATERIALORDER (QUANTITY, ORDER_ID, MATERIALORDER_ID) VALUES (10, 1, 1);
INSERT INTO MATERIALORDER (QUANTITY, ORDER_ID, MATERIALORDER_ID) VALUES (20, 2, 2);
INSERT INTO MATERIALORDER (QUANTITY, ORDER_ID, MATERIALORDER_ID) VALUES (15, 3, 3);
INSERT INTO MATERIALORDER (QUANTITY, ORDER_ID, MATERIALORDER_ID) VALUES (30, 4, 4);
INSERT INTO MATERIALORDER (QUANTITY, ORDER_ID, MATERIALORDER_ID) VALUES (25, 5, 5);

INSERT INTO material (id, unit_amount, name, description, product_code, vendor_id, vendor_cnpj, materialorder_materialorder_id)
VALUES (1, 10, 'Material A', 'Descrição Material A', 'MATERIAL01', 1, '98765432100123', 1);
INSERT INTO material (id, unit_amount, name, description, product_code, vendor_id, vendor_cnpj, materialorder_materialorder_id)
VALUES (2, 15, 'Material B', 'Descrição Material B', 'MATERIAL02', 2, '11112222333445', 2);
INSERT INTO material (id, unit_amount, name, description, product_code, vendor_id, vendor_cnpj, materialorder_materialorder_id)
VALUES (3, 12, 'Material C', 'Descrição Material C', 'MATERIAL03', 3, '55556666777889', 3);
INSERT INTO material (id, unit_amount, name, description, product_code, vendor_id, vendor_cnpj, materialorder_materialorder_id)
VALUES (4, 8, 'Material D', 'Descrição Material D', 'MATERIAL04', 4, '99990000111223', 4);
INSERT INTO material (id, unit_amount, name, description, product_code, vendor_id, vendor_cnpj, materialorder_materialorder_id)
VALUES (5, 20, 'Material E', 'Descrição Material E', 'MATERIAL05', 5, '88889999111234', 5);

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

INSERT INTO COMPANY_USER_ADDRESS (COMPANY_USER_ID, COMPANY_USER_CNPJ, ID, SHIPPING_COST_ID) VALUES (1, '12345678901234', 1, 1);
INSERT INTO COMPANY_USER_ADDRESS (COMPANY_USER_ID, COMPANY_USER_CNPJ, ID, SHIPPING_COST_ID) VALUES (2, '98765432109876', 2, 3);
INSERT INTO COMPANY_USER_ADDRESS (COMPANY_USER_ID, COMPANY_USER_CNPJ, ID, SHIPPING_COST_ID) VALUES (3, '11112222333344', 3, 4);
INSERT INTO COMPANY_USER_ADDRESS (COMPANY_USER_ID, COMPANY_USER_CNPJ, ID, SHIPPING_COST_ID) VALUES (4, '55556666777788', 4, 5);
INSERT INTO COMPANY_USER_ADDRESS (COMPANY_USER_ID, COMPANY_USER_CNPJ, ID, SHIPPING_COST_ID) VALUES (5, '99990000111122', 5, 6);

INSERT INTO ADDRESS (ID, STREET, NEIGHBORHOOD, "Number", COMPLEMENT, ZIP_CODE, CITY, IBGE_CODE, UF, COUNTRY, COMPANY_USER_ID, COMPANY_USER_CNPJ, VENDOR_ID, VENDOR_CNPJ, CMP_USR_ADDR_CMP_USR_ID, CMP_USR_ADDR_CMP_USR_CNPJ, VENDOR_ADDRESS_VENDOR_ID, VENDOR_ADDRESS_VENDOR_CNPJ, COMPANY_USER_ADDRESS_ID, VENDOR_ADDRESS_ID)
VALUES (1, 'Nome da Rua', 'Nome do Bairro', '12345', 'Complemento', '12345678', 'Nome da Cidade', '1234567', 'UF', 'Nome do País', 1, '12345678901234', 1, '98765432100123', 1, '12345678901234', 1, '98765432100123', 1, 1);
INSERT INTO ADDRESS (ID, STREET, NEIGHBORHOOD, "Number", COMPLEMENT, ZIP_CODE, CITY, IBGE_CODE, UF, COUNTRY, COMPANY_USER_ID, COMPANY_USER_CNPJ, VENDOR_ID, VENDOR_CNPJ, CMP_USR_ADDR_CMP_USR_ID, CMP_USR_ADDR_CMP_USR_CNPJ, VENDOR_ADDRESS_VENDOR_ID, VENDOR_ADDRESS_VENDOR_CNPJ, COMPANY_USER_ADDRESS_ID, VENDOR_ADDRESS_ID)
VALUES (3, 'Third Avenue', 'Third District', '33333', 'Unit 3C', '33333333', 'Third Town', '3333333', 'TX', 'USA', 3, '11112222333344', 3, '55556666777889', 3, '11112222333344', 3, '55556666777889', 3, 3);
INSERT INTO ADDRESS (ID, STREET, NEIGHBORHOOD, "Number", COMPLEMENT, ZIP_CODE, CITY, IBGE_CODE, UF, COUNTRY, COMPANY_USER_ID, COMPANY_USER_CNPJ, VENDOR_ID, VENDOR_CNPJ, CMP_USR_ADDR_CMP_USR_ID, CMP_USR_ADDR_CMP_USR_CNPJ, VENDOR_ADDRESS_VENDOR_ID, VENDOR_ADDRESS_VENDOR_CNPJ, COMPANY_USER_ADDRESS_ID, VENDOR_ADDRESS_ID)
VALUES (4, 'Fourth Road', 'Fourth Suburb', '44444', 'Suite 4D', '44444444', 'Fourthville', '4444444', 'FL', 'USA', 4, '55556666777788', 4, '99990000111223', 4, '55556666777788', 4, '99990000111223', 4, 4);
INSERT INTO ADDRESS (ID, STREET, NEIGHBORHOOD, "Number", COMPLEMENT, ZIP_CODE, CITY, IBGE_CODE, UF, COUNTRY, COMPANY_USER_ID, COMPANY_USER_CNPJ, VENDOR_ID, VENDOR_CNPJ, CMP_USR_ADDR_CMP_USR_ID, CMP_USR_ADDR_CMP_USR_CNPJ, VENDOR_ADDRESS_VENDOR_ID, VENDOR_ADDRESS_VENDOR_CNPJ, COMPANY_USER_ADDRESS_ID, VENDOR_ADDRESS_ID)
VALUES (5, 'Fifth Lane', 'Fifth Area', '55555', 'Apt 5E', '55555555', 'Fifth City', '5555555', 'CA', 'USA', 5, '99990000111122', 5, '88889999111234', 5, '99990000111122', 5, '88889999111234', 5, 5);
INSERT INTO ADDRESS (ID, STREET, NEIGHBORHOOD, "Number", COMPLEMENT, ZIP_CODE, CITY, IBGE_CODE, UF, COUNTRY, COMPANY_USER_ID, COMPANY_USER_CNPJ, VENDOR_ID, VENDOR_CNPJ, CMP_USR_ADDR_CMP_USR_ID, CMP_USR_ADDR_CMP_USR_CNPJ, VENDOR_ADDRESS_VENDOR_ID, VENDOR_ADDRESS_VENDOR_CNPJ, COMPANY_USER_ADDRESS_ID, VENDOR_ADDRESS_ID)
VALUES (2, 'Second Street', 'Second Neighborhood', '54321', 'Apt 2B', '87654321', 'Second City', '7654321', 'SF', 'Another Country', 2, '98765432109876', 2, '11112222333445', 2, '98765432109876', 2, '11112222333445', 2, 2);

INSERT INTO uf (ID, UF, ADDRESS_ID) VALUES (1, 'RJ', 1);
INSERT INTO uf (ID, UF, ADDRESS_ID) VALUES (2, 'MG', 2);
INSERT INTO uf (ID, UF, ADDRESS_ID) VALUES (3, 'PR', 3);
INSERT INTO uf (ID, UF, ADDRESS_ID) VALUES (4, 'RS', 4);
INSERT INTO uf (ID, UF, ADDRESS_ID) VALUES (5, 'SC', 5);

INSERT INTO ibge_code (ADDRESS_ID, ID, IBGE_CODE) VALUES (1, 1, 1234567);
INSERT INTO ibge_code (ADDRESS_ID, ID, IBGE_CODE) VALUES (2, 2, 2345678);
INSERT INTO ibge_code (ADDRESS_ID, ID, IBGE_CODE) VALUES (3, 3, 3456789);
INSERT INTO ibge_code (ADDRESS_ID, ID, IBGE_CODE) VALUES (4, 4, 4567890);
INSERT INTO ibge_code (ADDRESS_ID, ID, IBGE_CODE) VALUES (5, 5, 5678901);

INSERT INTO zip_code (ID, ADDRESS_ID, ZIP_CODE) VALUES (1, 1, 12345);
INSERT INTO zip_code (ID, ADDRESS_ID, ZIP_CODE) VALUES (2, 2, 23456);
INSERT INTO zip_code (ID, ADDRESS_ID, ZIP_CODE) VALUES (3, 3, 34567);
INSERT INTO zip_code (ID, ADDRESS_ID, ZIP_CODE) VALUES (4, 4, 45678);
INSERT INTO zip_code (ID, ADDRESS_ID, ZIP_CODE) VALUES (5, 5, 56789);

INSERT INTO neighborhood (ADDRESS_ID, ID, NEIGHBORHOOD) VALUES (1, 1, 'Neighborhood A');
INSERT INTO neighborhood (ADDRESS_ID, ID, NEIGHBORHOOD) VALUES (2, 2, 'Neighborhood B');
INSERT INTO neighborhood (ADDRESS_ID, ID, NEIGHBORHOOD) VALUES (3, 3, 'Neighborhood C');
INSERT INTO neighborhood (ADDRESS_ID, ID, NEIGHBORHOOD) VALUES (4, 4, 'Neighborhood D');
INSERT INTO neighborhood (ADDRESS_ID, ID, NEIGHBORHOOD) VALUES (5, 5, 'Neighborhood E');

INSERT INTO city (ID, CITY, ADDRESS_ID) VALUES (1, 'City A', 1);
INSERT INTO city (ID, CITY, ADDRESS_ID) VALUES (2, 'City B', 2);
INSERT INTO city (ID, CITY, ADDRESS_ID) VALUES (3, 'City C', 3);
INSERT INTO city (ID, CITY, ADDRESS_ID) VALUES (4, 'City D', 4);
INSERT INTO city (ID, CITY, ADDRESS_ID) VALUES (5, 'City E', 5);

INSERT INTO phone (ID, DDD, "Number", COMPANY_USER_ID, COMPANY_USER_CNPJ, VENDOR_ID, VENDOR_CNPJ, DDD_ID) 
VALUES (1, '11', '123456789', 1, '12345678901234', 1, '98765432100123', 1);
INSERT INTO phone (ID, DDD, "Number", COMPANY_USER_ID, COMPANY_USER_CNPJ, VENDOR_ID, VENDOR_CNPJ, DDD_ID) 
VALUES (2, '22', '222222222', 2, '98765432109876', 2, '11112222333445', 2);
INSERT INTO phone (ID, DDD, "Number", COMPANY_USER_ID, COMPANY_USER_CNPJ, VENDOR_ID, VENDOR_CNPJ, DDD_ID) 
VALUES (3, '33', '333333333', 3, '11112222333344', 3, '55556666777889', 3);
INSERT INTO phone (ID, DDD, "Number", COMPANY_USER_ID, COMPANY_USER_CNPJ, VENDOR_ID, VENDOR_CNPJ, DDD_ID) 
VALUES (4, '44', '444444444', 4, '55556666777788', 4, '99990000111223', 4);
INSERT INTO phone (ID, DDD, "Number", COMPANY_USER_ID, COMPANY_USER_CNPJ, VENDOR_ID, VENDOR_CNPJ, DDD_ID) 
VALUES (5, '55', '555555555', 5, '99990000111122', 5, '88889999111234', 5);

INSERT INTO ddd (PHONE_ID, ID, DDD) VALUES (1, 1, 11);
INSERT INTO ddd (PHONE_ID, ID, DDD) VALUES (2, 2, 22);
INSERT INTO ddd (PHONE_ID, ID, DDD) VALUES (3, 3, 33);
INSERT INTO ddd (PHONE_ID, ID, DDD) VALUES (4, 4, 44);
INSERT INTO ddd (PHONE_ID, ID, DDD) VALUES (5, 5, 55);



-- JOIN 1  selecionando o nome do usuário da empresa, o nome do fornecedor, a descrição do pedido e o custo de envio. 
SELECT
    cu.name AS company_user_name,
    v.name AS vendor_name,
    o.description_order AS order_description,
    sc.cost AS shipping_cost
FROM "Order" o
JOIN company_user cu ON o.company_user_id = cu.id
JOIN vendor v ON o.vendor_id = v.id
JOIN shipping_cost sc ON o.id = sc.order_id;

--Join entre as tabelas "material", "category" e "vendor". Estamos selecionando o nome do material, a categoria do material e o nome do fornecedor. 
SELECT
    m.name AS material_name,
    c.category AS material_category,
    v.name AS vendor_name
FROM material m
JOIN category c ON m.id = c.material_id
JOIN vendor v ON m.vendor_id = v.id;

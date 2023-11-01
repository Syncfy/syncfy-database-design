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

desc uf;

CREATE TABLE address (
    id                                     NUMBER NOT NULL,
    street                                 VARCHAR2(50),
    "Number"                               CHAR(5),
    complement                             VARCHAR2(50),  
    cmp_usr_addr_cmp_usr_id                NUMBER NOT NULL,
    cmp_usr_addr_cmp_usr_cnpj              CHAR(14) NOT NULL, 
    vendor_address_vendor_id               NUMBER NOT NULL,
    vendor_address_vendor_cnpj             NUMBER NOT NULL,
    company_user_address_id                NUMBER NOT NULL,
    vendor_address_id                      NUMBER NOT NULL
);

CREATE UNIQUE INDEX address__idx ON
    address (
        cmp_usr_addr_cmp_usr_id
    ASC,
        cmp_usr_addr_cmp_usr_cnpj 
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
    material_product_code CHAR(10) NOT NULL
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
    id         NUMBER NOT NULL,
    country    VARCHAR2(20),
    address_id NUMBER NOT NULL
);

CREATE UNIQUE INDEX country__idx ON
    country (
        address_id
    ASC );

ALTER TABLE country ADD CONSTRAINT country_pk PRIMARY KEY ( id );

CREATE TABLE ddd (
    id  NUMBER NOT NULL,
    ddd NUMBER
);

ALTER TABLE ddd ADD CONSTRAINT ddd_pk PRIMARY KEY ( id );

CREATE TABLE ibge_code (
    id         NUMBER NOT NULL,
    ibge_code  NUMBER,
    address_id NUMBER NOT NULL
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
    id           NUMBER NOT NULL,
    neighborhood VARCHAR2(30),
    address_id   NUMBER NOT NULL
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
    description       VARCHAR2(250),
    vendor_id         NUMBER NOT NULL,
    vendor_cnpj       NUMBER NOT NULL,
    company_user_id   NUMBER NOT NULL,
    company_user_cnpj CHAR(14) NOT NULL
);

ALTER TABLE "Order" ADD CONSTRAINT order_pk PRIMARY KEY ( id );

CREATE TABLE phone (
    id                NUMBER NOT NULL,
    "Number"          CHAR(9),
    company_user_id   NUMBER NOT NULL,
    company_user_cnpj CHAR(14) NOT NULL,
    vendor_id         NUMBER NOT NULL,
    vendor_cnpj       NUMBER NOT NULL,
    ddd_id            NUMBER NOT NULL
);

ALTER TABLE phone ADD CONSTRAINT phone_pk PRIMARY KEY ( id );

CREATE TABLE segment (
    id          NUMBER NOT NULL,
    segment     VARCHAR2(20),
    vendor_id   NUMBER NOT NULL,
    vendor_cnpj NUMBER NOT NULL
);

ALTER TABLE segment ADD CONSTRAINT segment_pk PRIMARY KEY ( id );

CREATE TABLE shipping_cost (
    id       NUMBER NOT NULL,
    cost     NUMBER,
    order_id NUMBER NOT NULL
);

CREATE UNIQUE INDEX shipping_cost__idx ON
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
    zip_code   NUMBER,
    address_id NUMBER NOT NULL
);

CREATE UNIQUE INDEX zip_code__idx ON
    zip_code (
        address_id
    ASC );

ALTER TABLE zip_code ADD CONSTRAINT zip_code_pk PRIMARY KEY ( id );


ALTER TABLE address
    ADD CONSTRAINT addr_cmpny_usr_addr_fk FOREIGN KEY ( cmp_usr_addr_cmp_usr_id, 
                                                                 cmp_usr_addr_cmp_usr_cnpj,
                                                                 company_user_address_id )
        REFERENCES company_user_address ( company_user_id,
                                          company_user_cnpj,
                                          id );

ALTER TABLE address
    ADD CONSTRAINT address_vendor_address_fk FOREIGN KEY ( vendor_address_vendor_id,
                                                           vendor_address_vendor_cnpj,
                                                           vendor_address_id )
        REFERENCES vendor_address ( vendor_id,
                                    vendor_cnpj,
                                    id );

ALTER TABLE category
    ADD CONSTRAINT category_material_fk FOREIGN KEY ( material_id,
                                                      material_product_code )
        REFERENCES material ( id,
                              product_code );

ALTER TABLE city
    ADD CONSTRAINT city_address_fk FOREIGN KEY ( address_id )
        REFERENCES address ( id );


ALTER TABLE company_user_address
    ADD CONSTRAINT cmp_usr_addr_cmpny_usr_fk FOREIGN KEY ( company_user_id,
                                                                      company_user_cnpj )
        REFERENCES company_user ( id,
                                  cnpj );

ALTER TABLE company_user_address
    ADD CONSTRAINT cmp_usr_addr_ship_cost_fk FOREIGN KEY ( shipping_cost_id )
        REFERENCES shipping_cost ( id );

ALTER TABLE country
    ADD CONSTRAINT country_address_fk FOREIGN KEY ( address_id )
        REFERENCES address ( id );

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
    ADD CONSTRAINT segment_vendor_fk FOREIGN KEY ( vendor_id,
                                                   vendor_cnpj )
        REFERENCES vendor ( id,
                            cnpj );

ALTER TABLE shipping_cost
    ADD CONSTRAINT shipping_cost_order_fk FOREIGN KEY ( order_id )
        REFERENCES "Order" ( id );

ALTER TABLE uf
    ADD CONSTRAINT uf_address_fk FOREIGN KEY ( address_id )
        REFERENCES address ( id );


ALTER TABLE vendor_address
    ADD CONSTRAINT vend_addr_ship_cost_fk FOREIGN KEY ( shipping_cost_id )
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



CREATE OR REPLACE FUNCTION validate_cnpj(cnpj VARCHAR2) RETURN BOOLEAN IS
  v_cnpj VARCHAR2(14);
  v_soma NUMBER := 0;
  v_digito1 NUMBER;
  v_digito2 NUMBER;
BEGIN
  -- Remove caracteres não numéricos do CNPJ
  v_cnpj := REGEXP_REPLACE(cnpj, '[^0-9]', '');

  -- Verifica se o CNPJ possui 14 dígitos
  IF LENGTH(v_cnpj) <> 14 THEN
    RETURN FALSE;
  END IF;

  -- Calcula o primeiro dígito verificador
  FOR i IN 1..12 LOOP
    v_soma := v_soma + TO_NUMBER(SUBSTR(v_cnpj, i, 1)) * CASE WHEN i IN (1, 2, 3, 9, 10, 11) THEN 5 - i ELSE 13 - i END;
  END LOOP;
  v_digito1 := 11 - (v_soma MOD 11);
  IF v_digito1 IN (10, 11) THEN
    v_digito1 := 0;
  END IF;

  -- Calcula o segundo dígito verificador
  v_soma := 0;
  FOR i IN 1..13 LOOP
    v_soma := v_soma + TO_NUMBER(SUBSTR(v_cnpj, i, 1)) * CASE WHEN i IN (1, 2, 3, 9, 10, 11, 12) THEN 6 - i ELSE 14 - i END;
  END LOOP;
  v_digito2 := 11 - (v_soma MOD 11);
  IF v_digito2 IN (10, 11) THEN
    v_digito2 := 0;
  END IF;

  -- Verifica se os dígitos calculados são iguais aos dígitos originais
  IF SUBSTR(v_cnpj, 13, 1) = TO_CHAR(v_digito1) AND SUBSTR(v_cnpj, 14, 1) = TO_CHAR(v_digito2) THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;
/

CREATE OR REPLACE FUNCTION validate_cpf(p_cpf IN VARCHAR2) RETURN NUMBER IS
  v_cpf VARCHAR2(11);
  v_soma NUMBER := 0;
  v_digito1 NUMBER;
  v_digito2 NUMBER;
BEGIN
  -- Remove caracteres não numéricos do CPF
  v_cpf := REGEXP_REPLACE(p_cpf, '[^0-9]', '');

  -- Verifica se o CPF possui 11 dígitos
  IF LENGTH(v_cpf) <> 11 THEN
    RETURN 0;
  END IF;

  -- Calcula os dígitos verificadores
  FOR i IN 1..9 LOOP
    v_soma := v_soma + TO_NUMBER(SUBSTR(v_cpf, i, 1)) * (11 - i);
  END LOOP;

  v_digito1 := 11 - (v_soma MOD 11);
  IF v_digito1 IN (10, 11) THEN
    v_digito1 := 0;
  END IF;

  v_soma := 0;
  FOR i IN 1..10 LOOP
    v_soma := v_soma + TO_NUMBER(SUBSTR(v_cpf, i, 1)) * (12 - i);
  END LOOP;

  v_digito2 := 11 - (v_soma MOD 11);
  IF v_digito2 IN (10, 11) THEN
    v_digito2 := 0;
  END IF;

  IF SUBSTR(v_cpf, 10, 1) = TO_CHAR(v_digito1) AND SUBSTR(v_cpf, 11, 1) = TO_CHAR(v_digito2) THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END;
/


-- Procedure UF 
CREATE OR REPLACE PROCEDURE manipulate_uf (
   p_id NUMBER,
   p_uf CHAR,
   p_operation CHAR
)
AS
BEGIN
   IF p_operation = 'INSERT' THEN
      INSERT INTO uf (ID, UF)
      VALUES (p_id, p_uf);
      
   ELSIF p_operation = 'UPDATE' THEN
      UPDATE uf
      SET UF = p_uf
      WHERE ID = p_id;
      
   ELSIF p_operation = 'DELETE' THEN
      DELETE FROM uf
      WHERE ID = p_id;
   ELSE
      RAISE_APPLICATION_ERROR(-20001, 'Invalid operation. Use INSERT, UPDATE, or DELETE.');
   END IF;
END manipulate_uf;


-- Procedure DDD
CREATE OR REPLACE PROCEDURE GerenciarRegistro (
    p_Action IN VARCHAR2,
    p_ID IN NUMBER,
    p_DDD IN NUMBER
) AS
BEGIN
    IF p_Action = 'INSERT' THEN
        INSERT INTO ddd (ID, DDD)
        VALUES (p_ID, p_DDD);
    ELSIF p_Action = 'UPDATE' THEN
        UPDATE ddd
        SET DDD = p_DDD
        WHERE ID = p_ID;
    ELSIF p_Action = 'DELETE' THEN
        DELETE FROM ddd
        WHERE ID = p_ID;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Ação inválida. Use "INSERT", "UPDATE" ou "DELETE".');
    END IF;

    COMMIT;
END GerenciarRegistro;


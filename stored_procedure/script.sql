-- Active: 1715278793065@@127.0.0.1@5432@2024_pbdi_repeticoes@public
CREATE  OR REPLACE PROCEDURE sp_ola_procedures() 
LANGUAGE plpgsql
as $$
BEGIN
    RAISE NOTICE 'Olá, Stored Procedures';
END;
$$;

-- Procedures com  parâmetros
CREATE OR REPLACE PROCEDURE sp_ola_usuario(p_nome VARCHAR(200))
LANGUAGE plpgsql
AS $$
BEGIN 
    RAISE NOTICE 'Olá (pelo nome), %', p_nome;
    RAISE NOTICE 'Olá (pelo número), %', $1;
END;
$$

CALL sp_ola_usuario('Pedro');
---------------------------------------------------------
-- IN
---------------------------------------------------------
--criando
--ambos são IN, pois IN é o padrão
CREATE OR REPLACE PROCEDURE sp_acha_maior (
    IN valor1 INT, 
    IN valor2 INT
) LANGUAGE plpgsql
AS $$
BEGIN
    IF valor1 > valor2 THEN
        RAISE NOTICE '% é o maior', $1;
    ELSE
        RAISE NOTICE '% é o maior', $2;
    END IF;
END;
$$
-- colocando em execução
CALL sp_acha_maior (2, 3);
---------------------------------------------------------
-- OUT
---------------------------------------------------------
-- aqui estamos removendo o proc de nome sp_acha_maior para poder reutilizar o nome
DROP PROCEDURE IF EXISTS sp_acha_maior;
CREATE OR REPLACE PROCEDURE sp_acha_maior (
    OUT resultado INT, 
     IN valor1 INT, 
     IN valor2 INT
) LANGUAGE plpgsql
AS $$
BEGIN
    -- escreva o maior na variavel resultado
    CASE
        WHEN valor1 > valor2 THEN
            $1 := valor1;   -- ou resultado := valor1 
        ELSE
            resultado := valor2;
    END CASE;
END;
$$
--colocando em execução
DO $$
DECLARE
    resultado INT;
BEGIN
    CALL sp_acha_maior (resultado, 2, 3);
    RAISE NOTICE '% é o maior', resultado;
END;
$$
---------------------------------------------------------
-- INOUT
---------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_acha_maior;
-- criando
CREATE OR REPLACE PROCEDURE sp_acha_maior (
    INOUT valor1 INT, 
    IN valor2 INT
) LANGUAGE plpgsql
AS $$
BEGIN
    -- não preciso testar se valor1 é maior porque ele já está na INOUT 
    IF valor2 > valor1 THEN
            valor1 := valor2;
    END IF;
END;
$$
-- Bloco anônimo para colocar em execução 
-- Este é o código cliente.
DO
$$
DECLARE
    valor1 INT := 2;
    valor2 INT := 3;
BEGIN
    CALL sp_acha_maior(valor1, valor2);
    RAISE NOTICE '% é o maior', valor1;
END;
$$
-----------------------------------------------------------------------
-- Parâmetro VARIADIC - permite passar colecao de parametros
-----------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_calcula_media ( VARIADIC valores INT [])
LANGUAGE plpgsql
AS $$
DECLARE
    media NUMERIC(10, 2) := 0; 
    valor INT;
BEGIN
    FOREACH valor IN ARRAY valores LOOP
        media := media + valor;
    END LOOP;
     --array_length calcula o número de elementos no array. O segundo parâmetro é o
     --número de dimensões dele
    RAISE NOTICE 'A média é %', media / array_length(valores, 1); -- vetor e numero de dimensoes = 1
END;
$$
-- 1 parâmetro
CALL sp_calcula_media(1);
-- 2 parâmetros
CALL sp_calcula_media(1, 2);
-- 6 parâmetros
CALL sp_calcula_media(1, 2, 5, 6, 1, 8);
-- não funciona!!!!
CALL sp_calcula_media (ARRAY[1, 2]);

---------------------------------------------------------
-- Criacao tabelas
---------------------------------------------------------

-- Cliente
DROP TABLE tb_cliente;
CREATE TABLE tb_cliente (
    cod_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL
);
SELECT * FROM tb_pedido;
DROP TABLE tb_pedido;
CREATE TABLE IF NOT EXISTS tb_pedido(
    cod_pedido SERIAL PRIMARY KEY,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR DEFAULT 'aberto',
    cod_cliente INT NOT NULL,
    CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente) REFERENCES
    tb_cliente(cod_cliente)
);

-- Tipo Item
DROP TABLE tb_tipo_item;
CREATE TABLE tb_tipo_item(
    cod_tipo SERIAL PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL
);
INSERT INTO tb_tipo_item (descricao) VALUES ('Bebida'), ('Comida');
SELECT * FROM tb_tipo_item;


-- Item 
DROP TABLE tb_item;
CREATE TABLE IF NOT EXISTS tb_item(
    cod_item SERIAL PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    valor NUMERIC (10, 2) NOT NULL,
    cod_tipo INT NOT NULL,
    CONSTRAINT fk_tipo_item FOREIGN KEY (cod_tipo) REFERENCES
    tb_tipo_item(cod_tipo)
);
INSERT INTO tb_item (descricao, valor, cod_tipo) VALUES
('Refrigerante', 7, 1), ('Suco', 8, 1), ('Hamburguer', 12, 2), ('Batata frita', 9, 2);
SELECT * FROM tb_item;
DROP TABLE tb_item_pedido;
CREATE TABLE IF NOT EXISTS tb_item_pedido(
    --surrogate key, assim cod_item pode repetir = cod_item_pedido
    cod_item_pedido SERIAL PRIMARY KEY,
    cod_item INT,
    cod_pedido INT,
    CONSTRAINT fk_item FOREIGN KEY (cod_item) REFERENCES tb_item (cod_item),
    CONSTRAINT fk_pedido FOREIGN KEY (cod_pedido) REFERENCES tb_pedido
    (cod_pedido)
);


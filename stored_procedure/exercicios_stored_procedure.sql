------------------------------------
-- Apostila 11: Stored procedure  --
------------------------------------

-- 1.1 Adicione uma tabela de log ao sistema do restaurante. 
-- Ajuste cada procedimento para que ele registre:
-- * A data em que a operação aconteceu
-- * O nome do procedimento executado

SELECT * FROM tb_log;
DROP TABLE tb_log;
CREATE TABLE IF NOT EXISTS tb_log(
		data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP PRIMARY KEY,
		nome_procedimento VARCHAR(100)
);

SELECT COUNT(cod_pedido) as qtde_pedidos  
	FROM tb_pedido 
	WHERE cod_cliente = 1
	
	
-- 1.2 Adicione um procedimento ao sistema do restaurante. Ele deve
-- - receber um parâmetro de entrada (IN) que representa o código de um cliente
-- - exibir, com RAISE NOTICE, o total de pedidos que o cliente tem

SELECT * FROM tb_pedido;

DROP PROCEDURE sp_total_pedidos_cliente;

CREATE OR REPLACE PROCEDURE sp_total_pedidos_cliente (
	IN p_cod_cliente INT)  
LANGUAGE plpgsql
AS $$
DECLARE
	qtde_pedidos INT;
BEGIN
	SELECT COUNT(cod_pedido) 
	FROM tb_pedido 
	WHERE cod_cliente = $1
	INTO qtde_pedidos;
	RAISE NOTICE 'O cliente %: possui % pedidos', $1, qtde_pedidos;
END;
$$

DO $$
BEGIN
	CALL sp_total_pedidos_cliente(1);
END;
$$

-- 1.3 Reescreva o exercício 1.2 de modo que o total de pedidos seja armazenado em uma
-- variável de saída (OUT).
DROP PROCEDURE sp_total_pedidos_cliente;

CREATE OR REPLACE PROCEDURE sp_total_pedidos_cliente (
	IN p_cod_cliente INT,
    OUT qtde_pedidos INT)  
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT COUNT(cod_pedido) 
	FROM tb_pedido 
	WHERE cod_cliente = $1
	INTO $2;
END;
$$

DO $$
DECLARE
	qtde_pedidos INT;
BEGIN
	CALL sp_total_pedidos_cliente(1, qtde_pedidos);
	RAISE NOTICE 'O cliente %: possui % pedidos', 1, qtde_pedidos;
END;
$$


-- 1.4 Adicione um procedimento ao sp_total_pedidos_cliente sistema do restaurante. Ele deve
-- - Receber um parâmetro de entrada e saída (INOUT)
-- - Na entrada, o parâmetro possui o código de um cliente
-- - Na saída, o parâmetro deve possuir o número total de pedidos realizados pelo cliente

DROP PROCEDURE sp_total_pedidos_cliente;

CREATE OR REPLACE PROCEDURE sp_total_pedidos_cliente (
	INOUT p_parametro INT)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT COUNT(cod_pedido) 
	FROM tb_pedido 
	WHERE cod_cliente = $1
	INTO $1;
END;
$$

DO $$
DECLARE
	p_parametro INT;
BEGIN
    p_parametro = 1; 
	RAISE NOTICE 'O cliente: %', p_parametro;
	CALL sp_total_pedidos_cliente(p_parametro);
	RAISE NOTICE 'possui: % pedidos', p_parametro;
END;
$$

-- 1.5 Adicione um procedimento ao sistema do restaurante. Ele deve
-- - Receber um parâmetro VARIADIC contendo nomes de pessoas
-- - Fazer uma inserção na tabela de clientes para cada nome recebido
-- - Receber um parâmetro de saída que contém o seguinte texto:
-- “Os clientes: Pedro, Ana, João etc foram cadastrados”
-- Evidentemente, o resultado deve conter os nomes que de fato foram enviados por meio do
-- parâmetro VARIADIC.

SELECT * FROM tb_cliente;

DROP PROCEDURE sp_inclui_clientes;

CREATE OR REPLACE PROCEDURE sp_inclui_clientes (VARIADIC p_clientes VARCHAR(500)[])
LANGUAGE plpgsql
AS $$
DECLARE
	cliente   VARCHAR(100);
	resultado VARCHAR(500) := 'Os clientes: ';
BEGIN
	FOREACH cliente IN ARRAY p_clientes 
	LOOP
   		INSERT INTO tb_cliente (nome) VALUES (cliente); 
   		resultado := concat(resultado || cliente ||', ');
	END LOOP;
	RAISE NOTICE ' % foram cadastrados', resultado;
END;
$$

DO
$$
BEGIN
	CALL sp_inclui_clientes ('Ana Alves','Bia Bezerra, Caio Costa');
END;
$$

SELECT * FROM tb_cliente;

-- 1.6 Para cada procedimento criado, escreva um bloco anônimo que o coloca em execução.

-- vide abaixo de cada Stored Procedure criada...
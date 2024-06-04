---------------------------------------------------------------------------
-- Apostila 12: Functions --  28/05/2024 -- Aula Remota -- Reforma FATEC --
---------------------------------------------------------------------------

-- Bloco de Código 2.3.1
CREATE FUNCTION fn_hello ( ) RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN 'Hello, functions';
END;
$$

--chamado sem bloco anônimo
--resultado é uma tabela
SELECT fn_hello();

--chamando com bloco anônimo
DO $$
DECLARE
	resultado TEXT;
BEGIN
	--não pode, call somente para procs
	--CALL fn_hello();
	--executa descartando..
	PERFORM fn_hello();
	--assim pode
	--resultado := fn_hello();
	--RAISE NOTICE '%', resultado;
	--assim também
	SELECT fn_hello() INTO resultado;
	RAISE NOTICE '%', resultado;
END;
$$

-- Bloco de Código 2.4.1
CREATE OR REPLACE FUNCTION fn_valor_aleatorio_entre (lim_inferior INT, lim_superior INT) RETURNS INT AS
$$
BEGIN
	RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
END;
$$ LANGUAGE plpgsql;

SELECT fn_valor_aleatorio_entre (2, 10);

-- Bloco de Código 2.5.1
CREATE OR REPLACE FUNCTION fn_ehPar (IN n INT) RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN n % 2 = 0;
END;
$$

SELECT fn_ehPar(2);

--Bloco de Código 2.6.1
CREATE OR REPLACE FUNCTION fn_Executa(IN fn_nomeFuncaoAExecutar TEXT, IN n INT)RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	resultado BOOLEAN;
BEGIN
	--EXECUTE 'SELECT ' || fn_nomeFuncaoAExecutar || '(' || n || ')' INTO resultado;
	--também pode ser assim
	--%s: string, %l: identificador (nome de variável), %L: valor literal
	EXECUTE format('SELECT %s (%s)', fn_nomeFuncaoAExecutar, n) INTO resultado;
	RETURN resultado;
END;
$$

SELECT fn_Executa ('fn_ehPar', 4);

-- Bloco de Código 2.7.1
CREATE OR REPLACE FUNCTION fn_some(IN fn_funcao TEXT, VARIADIC elementos INT[])
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	elemento INT;
	resultado boolean;
BEGIN
	FOREACH elemento IN ARRAY elementos LOOP
		EXECUTE format ('SELECT %s (%s)', fn_funcao, elemento) INTO resultado;
		IF resultado = TRUE THEN
			RETURN TRUE;
		END IF;
	END LOOP;
	RETURN FALSE;
END;
$$

DO $$
DECLARE
	resultado BOOLEAN;
BEGIN
	SELECT fn_some ('fn_ehPar', 1, 2) INTO resultado;
	RAISE NOTICE '%', resultado;
	SELECT fn_some ('fn_ehPar', 1, 3, 5) INTO resultado;
	RAISE NOTICE '%', resultado;
END;
$$

-- Bloco de Código 2.7.2
CREATE OR REPLACE FUNCTION fn_all (IN fn_funcao TEXT, VARIADIC elementos INT [])
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	elemento INT;
	resultado BOOLEAN;
BEGIN
	FOREACH elemento IN ARRAY elementos LOOP
		EXECUTE format ('SELECT %s (%s)', fn_funcao, elemento) INTO resultado;
		IF NOT resultado THEN
			RETURN FALSE;
		END IF;
	END LOOP;
RETURN TRUE;
END;
$$

DO $$
DECLARE
	resultado BOOLEAN;
BEGIN
	SELECT fn_all ('fn_ehPar', 1, 2, 3, 4, 5, 6) INTO resultado;
	RAISE NOTICE '%', resultado;
	SELECT fn_all ('fn_ehPar', 2, 4, 6) INTO resultado;
	RAISE NOTICE '%', resultado;
END;
$$

-- Bloco de Código 2.8.1
CREATE TABLE tb_cliente(
	cod_cliente SERIAL PRIMARY KEY,
	nome VARCHAR(200) NOT NULL
);

INSERT INTO tb_cliente (nome) VALUES ('João Santos'), ('Maria Andrade');

SELECT * FROM tb_cliente;

CREATE TABLE tb_tipo_conta(
	cod_tipo_conta SERIAL PRIMARY KEY,
	descricao VARCHAR(200) NOT NULL
);

INSERT INTO tb_tipo_conta (descricao) VALUES ('Conta Corrente'), ('Conta Poupança');

SELECT * FROM tb_tipo_conta;

CREATE TABLE tb_conta (
	cod_conta 				SERIAL 			PRIMARY KEY,
	status 					VARCHAR(200) 	NOT NULL DEFAULT 'aberta',
	data_criacao			TIMESTAMP 		DEFAULT CURRENT_TIMESTAMP,
	data_ultima_transacao	TIMESTAMP 		DEFAULT CURRENT_TIMESTAMP,
	saldo 					NUMERIC(10, 2) 	NOT NULL DEFAULT 1000 CHECK (saldo >= 1000),
	cod_cliente 			INT 			NOT NULL,
	cod_tipo_conta 			INT 			NOT NULL,
	CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente) REFERENCES
	tb_cliente(cod_cliente),
	CONSTRAINT fk_tipo_conta FOREIGN KEY (cod_tipo_conta) REFERENCES
	tb_tipo_conta(cod_tipo_conta)
); 

SELECT * FROM tb_conta;

-- Bloco de Código 2.9.1
DROP FUNCTION IF EXISTS fn_abrir_conta;

CREATE OR REPLACE FUNCTION fn_abrir_conta (IN p_cod_cli INT, IN p_saldo NUMERIC(10, 2), IN p_cod_tipo_conta INT) 
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO tb_conta (cod_cliente, saldo, cod_tipo_conta) VALUES ($1, $2, $3);
	RETURN TRUE;
	EXCEPTION WHEN OTHERS THEN
	RETURN FALSE;
END;
$$

DO $$
DECLARE
	v_cod_cliente INT := 1;
	v_saldo NUMERIC (10, 2) := 500;
	v_cod_tipo_conta INT := 1;
	v_resultado BOOLEAN;
BEGIN
	SELECT fn_abrir_conta (v_cod_cliente, v_saldo, v_cod_tipo_conta) INTO v_resultado;
	RAISE NOTICE '%', format('Conta com saldo R$%s%s foi aberta', v_saldo, 
							CASE WHEN v_resultado THEN '' 
							ELSE ' não' END);
	v_saldo := 1000;
	SELECT fn_abrir_conta (v_cod_cliente, v_saldo, v_cod_tipo_conta) INTO v_resultado;
	RAISE NOTICE '%', format('Conta com saldo R$%s%s foi aberta', v_saldo, CASE
	WHEN v_resultado THEN '' ELSE ' não' END);
END;
$$


--Bloco de Código 2.10.1
--routine se aplica a funções e procedimentos
DROP ROUTINE IF EXISTS fn_depositar;

CREATE OR REPLACE FUNCTION fn_depositar (IN p_cod_cliente INT, IN p_cod_conta INT,
IN p_valor NUMERIC(10, 2)) RETURNS NUMERIC(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
	v_saldo_resultante NUMERIC(10, 2);
BEGIN
	UPDATE tb_conta SET saldo = saldo + p_valor 
	WHERE cod_cliente = p_cod_cliente
	  AND cod_conta = p_cod_conta;
	SELECT saldo 
	  FROM tb_conta c 
	 WHERE c.cod_cliente = p_cod_cliente AND
		   c.cod_conta = p_cod_conta INTO v_saldo_resultante;
	RETURN v_saldo_resultante;
END;
$$

DO $$
DECLARE
	v_cod_cliente INT := 1;
	v_cod_conta INT := 2;
	v_valor NUMERIC(10, 2) := 200;
	v_saldo_resultante NUMERIC (10, 2);
BEGIN
	SELECT fn_depositar (v_cod_cliente, v_cod_conta, v_valor) 
	INTO v_saldo_resultante;
	RAISE NOTICE '%', format('Após depositar R$%s, o saldo resultante é de R$%s', v_valor, v_saldo_resultante);
END;
$$
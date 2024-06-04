-- Exercicios Function

-- 1.1 Escreva a seguinte função
-- nome: fn_consultar_saldo
-- recebe: código de cliente, código de conta
-- devolve: o saldo da conta especificada

SELECT * FROM tb_conta;

DROP ROUTINE IF EXISTS fn_consultar_saldo;

CREATE OR REPLACE FUNCTION fn_consultar_saldo (IN p_cod_cliente INT, IN p_cod_conta INT) RETURNS NUMERIC(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
	v_saldo NUMERIC(10, 2);
BEGIN
	SELECT saldo 
	FROM tb_conta c 
	WHERE c.cod_cliente = p_cod_cliente 
	  AND c.cod_conta   = p_cod_conta 
	  INTO v_saldo;
	RETURN v_saldo;
END;
$$

DO $$
DECLARE
	v_cod_cliente INT := 1;
	v_cod_conta   INT := 2;
	v_saldo       NUMERIC (10, 2);
BEGIN
	SELECT fn_consultar_saldo (v_cod_cliente, v_cod_conta) 
	INTO v_saldo;
	RAISE NOTICE '%', format('O saldo é de R$%s', v_saldo);
END;
$$

--1.2 Escreva a seguinte função
-- nome: fn_transferir
-- recebe: código de cliente remetente, código de conta remetente, código de cliente
-- destinatário, código de conta destinatário, valor da transferência
-- devolve: um booleano que indica se a transferência ocorreu ou não. Uma transferência
-- somente pode acontecer se nenhuma conta envolvida ficar no negativo.

--DELETE FROM tb_conta WHERE cod_conta in (100,200);
--INSERT INTO tb_conta (cod_conta, cod_cliente, saldo, cod_tipo_conta) VALUES (100, 1, 10000.00, 1);
--INSERT INTO tb_conta (cod_conta, cod_cliente, saldo, cod_tipo_conta) VALUES (200, 2, 20000.00, 1);

SELECT * FROM tb_conta;

DROP ROUTINE IF EXISTS fn_transferir;

CREATE OR REPLACE FUNCTION fn_transferir (IN p_cod_cliente_rem  INT, 
										  IN p_cod_conta_rem    INT,
										  IN p_cod_cliente_dest INT, 
										  IN p_cod_conta_dest   INT,
										  IN p_valor_transf     NUMERIC(10, 2)) 
				   RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	v_saldo_resultante NUMERIC(10, 2) :=0.00;
BEGIN
--
--  Subtrai da conta remetente
--  Checa se há saldo
	SELECT saldo - p_valor_transf  
	  FROM tb_conta c 
	 WHERE c.cod_cliente = p_cod_cliente_rem 
	   AND c.cod_conta   = p_cod_conta_rem
	  INTO v_saldo_resultante;
	IF v_saldo_resultante < 0 THEN
	   RETURN FALSE;
	END IF;   
	UPDATE tb_conta 
	   SET saldo = saldo - p_valor_transf 
	 WHERE cod_cliente = p_cod_cliente_rem
	   AND cod_conta = p_cod_conta_rem;
--EXCEPTION WHEN OTHERS THEN
--RETURN FALSE;

--	
--  Soma na conta destinataria
--  Checa se há saldo
    v_saldo_resultante := 0.00;
	SELECT saldo + p_valor_transf  
	  FROM tb_conta c 
	 WHERE c.cod_cliente = p_cod_cliente_dest 
	   AND c.cod_conta   = p_cod_conta_dest
	  INTO v_saldo_resultante;
	IF v_saldo_resultante < 0 THEN
	   RETURN FALSE;
	END IF;   
	UPDATE tb_conta 
	   SET saldo = saldo + p_valor_transf 
	 WHERE cod_cliente = p_cod_cliente_dest
	   AND cod_conta = p_cod_conta_dest;
--       EXCEPTION WHEN OTHERS THEN
--       RETURN FALSE;
	   RETURN TRUE;	
END;
$$

DO $$
DECLARE
	v_cod_cliente_rem  INT := 1;
	v_cod_conta_rem    INT := 100;
	v_cod_cliente_dest INT := 2;
	v_cod_conta_dest   INT := 200;
    v_valor_transf     NUMERIC (10, 2) := 100.00;
	v_resposta         BOOLEAN;
BEGIN
SELECT fn_transferir (v_cod_cliente_rem, v_cod_conta_rem, v_cod_cliente_dest, v_cod_conta_dest, v_valor_transf) 
  INTO v_resposta;
  RAISE NOTICE '%', v_resposta;
END;
$$

SELECT * FROM tb_conta;
	  

-- 1.3 Escreva blocos anônimos para testar cada função.

-- vide em cada exercicio.
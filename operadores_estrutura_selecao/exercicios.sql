-- Alunos: ARTUR STEIN
--         CAIO DIAMANTINO
--		   CATIA URBONAS

----------------------------------------------------------------------
-- 1 Exercícios
----------------------------------------------------------------------
--Nota. Para cada exercício, produza duas soluções: uma que utilize apenas IF e suas
--variações e outra que use apenas CASE e suas variações.

--Nota. Para cada exercício, gere valores aleatórios conforme a necessidade. Use a função
--do Bloco de Código 1.1.

--Bloco de Código 1.1
-- CREATE OR REPLACE FUNCTION valor_aleatorio_entre (lim_inferior INT, lim_superior INT) RETURNS INT AS
-- $$
-- BEGIN
-- 	RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
-- END;
-- $$ LANGUAGE plpgsql;

----------------------------------------------------------------------
--1.1 Faça um programa que exibe se um número inteiro é múltiplo de 3.
----------------------------------------------------------------------

-- Solução 1 - Usando IF
DO $$
DECLARE
	valor INT := valor_aleatorio_entre(1, 100);
BEGIN
	RAISE NOTICE 'O valor gerado é: %', valor;
	IF valor % 3 = 0 THEN
		RAISE NOTICE '% é multiplo de 3', valor;
	ELSE
		RAISE NOTICE '% não é multiplo de 3', valor;
	END IF;
END;
$$

-- Solução 2 - Usando CASE
DO $$
DECLARE
	valor INT;
	mensagem VARCHAR(200);
BEGIN
	valor := valor_aleatorio_entre (1, 100);
	RAISE NOTICE 'O valor gerado é: %', valor;
	CASE valor % 3
		WHEN 0 THEN
			mensagem := 'é multiplo de 3';
		ELSE
			mensagem := 'não é multiplo de 3';
	END CASE;
	RAISE NOTICE '%', mensagem;
END;
$$

-----------------------------------------------------------------------------
1.2 Faça um programa que exibe se um número inteiro é múltiplo de 3 ou de 5.
-----------------------------------------------------------------------------

-- Solução 1 - Usando IF
DO $$
DECLARE
	valor INT := valor_aleatorio_entre(1, 100);
BEGIN
	RAISE NOTICE 'O valor gerado é: %', valor;
	IF (valor % 3 = 0) or (valor % 5 = 0) THEN
		RAISE NOTICE '% é multiplo de 3 ou de 5', valor;
	ELSE
		RAISE NOTICE '% não é multiplo de 3 ou de 5', valor;
	END IF;
END;
$$

-- Solução 2 - Usando CASE
DO $$
DECLARE
	valor    INT;
	mensagem VARCHAR(200);
BEGIN
	valor := valor_aleatorio_entre (1, 100);
	RAISE NOTICE 'O valor gerado é: %', valor;
	CASE 
		WHEN (valor % 3 = 0) OR (valor % 5 = 0) THEN
			mensagem := 'é multiplo de 3 ou de 5';
		ELSE
			mensagem := 'não é multiplo de 3 ou de 5';
	END CASE;

	RAISE NOTICE '%', mensagem;
END;
$$


-----------------------------------------------------------------------------
--1.3 Faça um programa que opera de acordo com o seguinte menu.
--Opções:
--1 - Soma
--2 - Subtração
--3 - Multiplicação
--4 - Divisão
--Cada operação envolve dois números inteiros. O resultado deve ser 
-- exibido no formato op1 op op2 = res
--Exemplo:
--2 + 3 = 5
-----------------------------------------------------------------------------

-- Solução 1 - Usando IF
DO $$
DECLARE
	op1   INT           := valor_aleatorio_entre(1, 100);
	op2   INT           := valor_aleatorio_entre(1, 100);
	op    INT           := valor_aleatorio_entre(1, 5); 
	res   INT           := 0;
	sinal VARCHAR       :=' ';
BEGIN
	IF op = 1 THEN   
		res = op1 + op2;
  		sinal = '+';
		RAISE NOTICE '% % % = %', op1, sinal, op2, res;			

		ELSIF op = 2 THEN  
			res = op1 - op2;
  			sinal = '-';
			RAISE NOTICE '% % % = %', op1, sinal, op2, res;			

			ELSIF op = 3 THEN  
				res = op1 * op2;
  				sinal = '*';
				RAISE NOTICE '% % % = %', op1, sinal, op2, res;			

				ELSIF op = 4 THEN  
					res = op1 / op2;
  					sinal = '/';
    				RAISE NOTICE '% % % = %', op1, sinal, op2, res;			
				ELSE
					   RAISE NOTICE 'Opção Inválida';
				END IF;
END;
$$


-- Solução 2 - Usando CASE
DO $$
DECLARE
	op1   INT      := valor_aleatorio_entre(1, 100);
	op2   INT      := valor_aleatorio_entre(1, 100);
	op    INT      := valor_aleatorio_entre(1, 5); 
	res   INT      := 0;
	sinal VARCHAR  :=' ';
BEGIN
	CASE
	WHEN op = 1 THEN   
		res = op1 + op2;
  		sinal = '+';
		RAISE NOTICE '% % % = %', op1, sinal, op2, res;	
	WHEN op = 2 THEN  
		res = op1 - op2;
  		sinal = '-';
		RAISE NOTICE '% % % = %', op1, sinal, op2, res;	
	WHEN op = 3 THEN  
		res = op1 * op2;
  		sinal = '*';
		RAISE NOTICE '% % % = %', op1, sinal, op2, res;	
	WHEN op = 4 THEN  
		res = op1 / op2;
  		sinal = '/';
		RAISE NOTICE '% % % = %', op1, sinal, op2, res;	
	ELSE
	   RAISE NOTICE 'Opção Invalida.';
	END CASE;
END;
$$

--1.4 Um comerciante comprou um produto e quer vendê-lo com um lucro de 45% se o valor
--da compra for menor que R$20. Caso contrário, ele deseja lucro de 30%. Faça um
--programa que, dado o valor do produto, calcula o valor de venda.

-- Solução 1 - Usando IF
DO $$
DECLARE
	valor_compra INT := valor_aleatorio_entre(1, 100);
	lucro        INT;
	valor_venda  INT;
BEGIN
	RAISE NOTICE 'O valor de compra é: %', valor_compra;

	IF valor_compra < 20 THEN
	    valor_venda = valor_compra + ((valor_compra * 45)/100);
		lucro = Valor_venda - valor_compra;
	ELSE
	    valor_venda = valor_compra + ((valor_compra * 30)/100);
		lucro = Valor_venda - valor_compra;
	END IF;

	RAISE NOTICE 'O valor da venda é: %', valor_venda;
	RAISE NOTICE 'O lucro foi de %', lucro;
END;
$$

-- Solução 2 - Usando CASE
DO $$
DECLARE
	valor_compra INT := valor_aleatorio_entre(1, 100);
	lucro        INT;
	valor_venda  INT;
BEGIN
	RAISE NOTICE 'O valor de compra é: %', valor_compra;
    CASE
	WHEN valor_compra < 20 THEN
	    valor_venda = valor_compra + ((valor_compra * 45)/100);
		lucro = Valor_venda - valor_compra;
	ELSE
	    valor_venda = valor_compra + ((valor_compra * 30)/100);
		lucro = Valor_venda - valor_compra;
	END CASE;

	RAISE NOTICE 'O valor da venda é: %', valor_venda;
	RAISE NOTICE 'O lucro foi de %', lucro;
END;
$$

-- 1.5 Resolva o problema disponível no link a seguir.
-- https://www.beecrowd.com.br/judge/en/problems/view/1048

-- The company ABC decided to give a salary increase to its employees, according to the following table:
--    Salary               Readjustment Rate
--       0 - 400.00                15%
--  400.01 - 800.00                12%
--  800.01 - 1200.00               10%
-- 1200.01 - 2000.00                7%
-- Above 2000.00                    4%

--Read the employee's salary, calculate and print the new employee's salary, as well the money earned 
--and the increase percentual obtained by the employee, with corresponding messages in Portuguese, as the below example.

--Input
--The input contains only a floating-point number, with 2 digits after the decimal point.

--Output
--Print 3 messages followed by the corresponding numbers (see example) informing the new salary, the among of money earned 
--(both must be shown with 2 decimal places) and the percentual obtained by the employee. 
--Note:
--Novo salario:  means "New Salary"
--Reajuste ganho: means "Money earned"
--Em percentual: means "In percentage"

-- Solução 1 - Usando IF
DO $$
	DECLARE
		salario              NUMERIC(10,2) := 800.01;
		valor_reajuste       NUMERIC(10,2);
		percentual_reajuste  INT;
        novo_salario         NUMERIC(10,2);
    -- Testar
	--  salario := 400.00;
	--	salario := 800.01
	--	salario := 2000.00

BEGIN
		IF   salario >= 0 AND salario <= 400.00 THEN
	         percentual_reajuste = 15; 
			 valor_reajuste = (salario * percentual_reajuste)/100;
			 novo_salario = salario + valor_reajuste; 	
		ELSIF salario >= 400.01 AND salario<= 800.00 THEN
			 percentual_reajuste = 12; 
			 valor_reajuste = (salario * percentual_reajuste)/100;
			 novo_salario = salario + valor_reajuste; 
			 ELSIF salario >= 800.01 AND salario <= 1200.00 THEN
			 	percentual_reajuste = 10; 
			 	valor_reajuste = (salario * percentual_reajuste)/100;
			 	novo_salario = salario + valor_reajuste; 	 
				ELSIF salario >= 1200.01 AND salario <= 2000.00 THEN
			 		percentual_reajuste = 7; 
			 		valor_reajuste = (salario * percentual_reajuste)/100;
			 		novo_salario = salario + valor_reajuste; 	 
				ELSE	 
					percentual_reajuste = 4; 
					valor_reajuste = (salario * percentual_reajuste)/100;
					novo_salario = salario + valor_reajuste;
		 END IF;
		RAISE NOTICE 'Novo salario: %'  , novo_salario; 
		RAISE NOTICE 'Reajuste ganho: %', valor_reajuste;
		RAISE NOTICE 'Em Percentual: % %' , percentual_reajuste,'%';
END;
$$

-- Solução 2 - Usando CASE
DO $$
	DECLARE
		salario              NUMERIC(10,2) := 2000.00;
		valor_reajuste       NUMERIC(10,2);
		percentual_reajuste  INT;
        novo_salario         NUMERIC(10,2);
    -- Testar
	--  salario := 400.00;
	--	salario := 800.01
	--	salario := 2000.00

BEGIN
		CASE
		WHEN salario BETWEEN 0 AND 400.00 THEN
	         percentual_reajuste = 15; 
			 valor_reajuste = (salario * percentual_reajuste)/100;
			 novo_salario = salario + valor_reajuste; 	
		WHEN salario BETWEEN 400.01 AND 800.00 THEN
			 percentual_reajuste = 12; 
			 valor_reajuste = (salario * percentual_reajuste)/100;
			 novo_salario = salario + valor_reajuste; 
		WHEN salario BETWEEN 800.01 AND 1200.00 THEN
			 percentual_reajuste = 10; 
			 valor_reajuste = (salario * percentual_reajuste)/100;
			 novo_salario = salario + valor_reajuste; 	 
		WHEN salario BETWEEN 1200.01 AND 2000.00 THEN
			 percentual_reajuste = 7; 
			 valor_reajuste = (salario * percentual_reajuste)/100;
			 novo_salario = salario + valor_reajuste; 	 
		ELSE	 
			percentual_reajuste = 4; 
			valor_reajuste = (salario * percentual_reajuste)/100;
			novo_salario = salario + valor_reajuste; 
		END CASE;
		RAISE NOTICE 'Novo salario: %'  , novo_salario; 
		RAISE NOTICE 'Reajuste ganho: %', valor_reajuste;
		RAISE NOTICE 'Em Percentual: % %' , percentual_reajuste,'%';
END;
$$


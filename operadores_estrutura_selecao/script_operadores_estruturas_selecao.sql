CREATE OR REPLACE FUNCTION valor_aleatorio_entre (lim_inferior INT, lim_superior
INT) RETURNS INT AS
$$
BEGIN
	RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
END;
$$ LANGUAGE plpgsql;

SELECT valor_aleatorio_entre (2, 10);

-- (IF: Exercício resolvido) Dado um número inteiro, exiba metade de seu valor caso seja
--  maior do que 20. Os blocos de código 2.4.3 e 2.4.4 mostram duas possíveis soluções.

-- Bloco de Código 2.4.3
DO $$
	DECLARE
		valor INT;
BEGIN
		valor := valor_aleatorio_entre(1, 100);
		RAISE NOTICE 'O valor gerado é: %', valor;
		IF valor <= 20 THEN
			RAISE NOTICE 'A metade do valor % é %', valor, valor / 2::FLOAT;
		END IF;
END;
$$

-- Bloco de Código 2.4.4
DO $$
	DECLARE
		valor INT;
BEGIN
		SELECT valor_aleatorio_entre(1, 100) INTO valor;
		RAISE NOTICE 'O valor gerado é: %', valor;
		IF valor BETWEEN 1 AND 20 THEN
			RAISE NOTICE 'A metade do valor % é %', valor, valor / 2.;
		END IF;
END;
$$

--(IF/ELSE: Exercício resolvido) Dado um número inteiro, exiba se ele é par ou ímpar. Veja
--uma solução no Bloco de Código 2.4.5.

-- Bloco de Código 2.4.5
DO $$
	DECLARE
		valor INT := valor_aleatorio_entre(1, 100);
BEGIN
		RAISE NOTICE 'O valor gerado é: %', valor;
		IF valor % 2 = 0 THEN
			RAISE NOTICE '% é par', valor;
		ELSE
			RAISE NOTICE '% é ímpar', valor;
		END IF;
END;
$$

--(IF/ELSIF/ELSE: Exercício resolvido) Dados valores a, b e c desempenhando o papel de
--coeficientes de uma potencial equação do segundo grau, calcule as potenciais raízes.
--Considere que qualquer um dos coeficientes pode ser igual a zero. O Bloco de Código 2.4.6
--mostra uma possível solução.

-- Bloco de Código 2.4.6
DO $$
DECLARE
	a INT := valor_aleatorio_entre(0, 20);
	b INT := valor_aleatorio_entre(0, 20);
	c INT := valor_aleatorio_entre(0, 20);
	delta NUMERIC(10,2);
	raizUm NUMERIC(10, 2);
	raizDois NUMERIC(10, 2);
BEGIN
	--U& precedendo uma string indica que podemos especificar símbolos unicode
	RAISE NOTICE 'Equação: %x% + %x + % = 0', a, U&'\00B2', b, c;
	IF a = 0 THEN
		RAISE NOTICE 'Não é uma equação do segundo grau';
	ELSE
		-- observe que podemos omitir * para multiplicação
		delta := b ^ 2 - 4 * a * c;
		RAISE NOTICE 'Valor de delta: %', delta;
		IF delta < 0 THEN
			RAISE NOTICE 'Nenhum raiz.';
		-- ELSIF pode ser ELSEIF também
		ELSIF delta = 0 THEN
			raizUm := (-b + |/delta) / (2 * a);
			RAISE NOTICE 'Uma raiz: %', raizUm;
		ELSE
			raizUm := (-b + |/delta) / (2 * a);
			raizDois := (-b - |/delta) / (2 * a);
			RAISE NOTICE 'Duas raizes: % e %', raizUm, raizDois;
		END IF;
	END IF;
END;
$$

--(CASE valor WHEN valor THEN ELSE: Exercício resolvido) Dado um valor entre 1 e 10,
--decidir se ele é par ou ímpar. Para tal, use a estrutura CASE valor WHEN valor THEN
--ELSE. O Bloco de Código 2.4.7 mostra uma solução. É claro que podemos fazer algoritmos
--bem mais inteligentes. Esta primeira versão tem como finalidade estruturas as
--características básicas do CASE.

-- Bloco de Código 2.4.7
DO $$
	DECLARE
		valor INT;
		mensagem VARCHAR(200);
BEGIN
		--vamos admitir alguns valores fora do intervalo para ver o que acontece quando não há case previsto
		valor := valor_aleatorio_entre (1, 12);
		RAISE NOTICE 'O valor gerado é: %', valor;
		CASE valor
		WHEN 1 THEN
			mensagem := 'Ímpar';
		WHEN 3 THEN
			mensagem := 'Ímpar';
		WHEN 5 THEN
			mensagem := 'Ímpar';
		WHEN 7 THEN
			mensagem := 'Ímpar';
		WHEN 9 THEN
			mensagem := 'Ímpar';
		WHEN 2 THEN
			mensagem := 'Par';
		WHEN 4 THEN
			mensagem := 'Par';
		WHEN 6 THEN
			mensagem := 'Par';
		WHEN 8 THEN
			mensagem := 'Par';
		WHEN 10 THEN
			mensagem := 'Par';
		--comente o ELSE e veja o resultado quando não houver case para o valor: Exceção CASE_NOT_FOUND
		ELSE
			mensagem := 'Valor fora do intervalo';
		END CASE;
		RAISE NOTICE '%', mensagem;
END;
$$

-- se comendado ELSE:
--NOTICE:  O valor gerado é: 11

--ERROR:  case não foi encontrado
--HINT:  comando CASE está faltando a parte ELSE.
--CONTEXT:  função PL/pgSQL inline_code_block linha 9 em CASE
--SQL state: 20000

-- O Bloco de Código 2.4.8 mostra outra possibilidade, em que agrupamos os valores que têm tratamento igual.
DO $$
	DECLARE
		valor INT := valor_aleatorio_entre(1, 12);
		mensagem VARCHAR(200);
BEGIN
		RAISE NOTICE 'O valor gerado é: %', valor;
		CASE valor
		WHEN 1, 3, 5, 7, 9 THEN
			mensagem := 'Ímpar';
		WHEN 2, 4, 6, 8, 10 THEN
			mensagem := 'Par';
		ELSE
			mensagem := 'Fora do intervalo';
		END CASE;
		RAISE NOTICE '%', mensagem;
END;
$$

--(CASE WHEN THEN ELSE: Exercício resolvido) Dado um valor entre 1 e 10, decidir se
--ele é par ou ímpar. Use CASE WHEN THEN ELSE. O Bloco de Código 2.4.9 mostra um
--exemplo. Observe que estamos usando um CASE aninhado.

--Bloco de Código 2.4.9
DO $$
	DECLARE
		valor INT := valor_aleatorio_entre (1, 12);
BEGIN
		RAISE NOTICE 'O valor gerado é: %', valor;
		CASE
		WHEN valor BETWEEN 1 AND 10 THEN
			CASE
			WHEN valor % 2 = 0 THEN
				RAISE NOTICE 'Par';
			ELSE
				RAISE NOTICE 'Ímpar';
			END CASE;
		ELSE
			RAISE NOTICE 'Fora do intervalo';
		END CASE;
END;
$$

--(Exercício resolvido) Dado valor no formato ddmmaaaa, verificar se ele representa uma
--data válida. O Bloco de Código 2.4.10 mostra uma solução.

-- Bloco de Código 2.4.10
DO $$
DECLARE
		--testar
		--22/10/2022: valida
		--29/02/2020: 2020 é bissexto, válida
		--29/02/2021: inválida
		--28/02/2021: válida
		--31/06/2021: inválida
		data INT := 31062021;
		dia INT;
		mes INT;
		ano INT;
		data_valida BOOL := TRUE;
BEGIN
		dia := data / 1000000;
		mes := data % 1000000 / 10000;
		ano := data % 10000;
		RAISE NOTICE 'A data é %/%/%', dia, mes, ano;
		RAISE NOTICE 'Vejamos se é ela é válida...';
		IF ano >= 1 THEN
			CASE
			WHEN mes > 12 OR mes < 1 OR dia < 1 OR dia > 31 THEN
				data_valida := FALSE;
			ELSE
				--abril, junho, setembro e novembro não podem ter mais de 30 dias
				IF ((mes = 4 OR mes = 6 OR mes = 9 OR mes = 11) AND dia > 30) THEN
					data_valida := FALSE;
				ELSE
					--fevereiro
					IF mes = 2 THEN
						CASE
						--se o ano for bissexto
						WHEN ((ano % 4 = 0 AND ano % 100 <> 0)
						OR ANO % 400 = 0) THEN
							IF dia > 29 THEN
								data_valida := FALSE;
							END IF;
						ELSE
							IF dia > 28 THEN
								data_valida := FALSE;
							END IF;
						END CASE;
					END IF;
				END IF;
			END CASE;
		ELSE
			data_valida := FALSE;
		END IF;
		CASE
		WHEN data_valida THEN
			RAISE NOTICE 'Data válida';
		ELSE
			RAISE NOTICE 'Data inválida';
		END CASE;
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



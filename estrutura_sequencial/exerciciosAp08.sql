---------------------------
--1 Exercícios - Apostila 8
---------------------------
 
--Para os exercícios que não especifiquem intervalos explicitamente, considere os seguintes
--intervalos.
--Números inteiros: [1, 100]
--Números reais: [1, 10]
 
-----------------------------------------------------------
--1.1 Faça um programa que gere um valor inteiro e o exiba.
-----------------------------------------------------------
DO $$
DECLARE
	limite_inferior INTEGER :=1;
	limite_superior INTEGER :=100;
	n1 INTEGER;
BEGIN
    n1 := limite_inferior + floor(random() * (limite_superior - limite_inferior + 1)); 
	RAISE NOTICE 'Valor Inteiro gerado no intervalo [%,%]: %', limite_inferior, limite_superior, n1;
END $$;


---------------------------------------------------------
--1.2 Faça um programa que gere um valor real e o exiba.
---------------------------------------------------------
DO $$
DECLARE
	limite_inferior INTEGER :=1;
	limite_superior INTEGER :=10;
	n1 NUMERIC;
BEGIN
    n1 := random() * (limite_superior - limite_inferior) + limite_inferior;  
	RAISE NOTICE 'Valor Real gerado no intervalo [%,%]: %', limite_inferior, limite_superior, n1;
END $$;
 
--------------------------------------------------------------------------------------
--1.3 Faça um programa que gere um valor real no intervalo [20, 30] que representa uma
--temperatura em graus Celsius. Faça a conversão para Fahrenheit e exiba.
--------------------------------------------------------------------------------------
DO $$ 
DECLARE
	limite_inferior INTEGER :=20;
	limite_superior INTEGER :=30;
	c NUMERIC (5,2);
	f NUMERIC (5,2);
BEGIN
    c := random() * (limite_superior - limite_inferior) + limite_inferior; 
	RAISE NOTICE 'Temperatura em Graus Celsius: %', c;
	-- °F = (°C x 1.8) + 32
	f := (c * 1.8) + 32; 
	RAISE NOTICE 'Temperatura em Fahrenheit: %', f;
END $$;

---------------------------------------------------------------------------------------
--1.4 Faça um programa que gere três valores reais a, b, e c e mostre o valor de delta:
--aquele que calculamos para chegar às potenciais raízes de uma equação do segundo grau.
-- delta = b ^ 2 - (4 * a * c)
----------------------------------------------------------------------------------------
DO $$
DECLARE
	limite_inferior INTEGER :=1;
	limite_superior INTEGER :=10;
	a NUMERIC(5,2);
	b NUMERIC(5,2);
	c NUMERIC(5,2);
	delta NUMERIC (7,2);
BEGIN
    a := random() * (limite_superior - limite_inferior) + limite_inferior;
	RAISE NOTICE 'a = %', a;
	b := random() * (limite_superior - limite_inferior) + limite_inferior;
	RAISE NOTICE 'b = %', b;
	c := random() * (limite_superior -limite_inferior) + limite_inferior;
	RAISE NOTICE 'c = %', c;
	-- delta = b ^ 2 - (4 * a * c)
	delta  = ((b ^ 2) - (4 * a * c));
	RAISE NOTICE 'delta = %', delta;
END $$;

------------------------------------------------------------------------------------------
--1.5 Faça um programa que gere um número inteiro e mostre a raiz cúbica de seu antecessor
-- e a raiz quadrada de seu sucessor.
------------------------------------------------------------------------------------------
DO $$
DECLARE
	limite_inferior INTEGER :=1;
	limite_superior INTEGER :=100;
	n1 INTEGER;
BEGIN
    n1 := limite_inferior + floor(random() * (limite_superior - limite_inferior + 1)); 
	RAISE NOTICE 'Número Inteiro Gerado: %', n1;
	RAISE NOTICE 'Seu Antecessor: %', n1-1;
	RAISE NOTICE 'Raiz Cúbica do Antecessor: %', ||/(n1-1);
END $$;
 
-------------------------------------------------------------------------------------- 
--1.6 Faça um programa que gere medidas reais de um terreno retangular. Gere também um
--valor real no intervalo [60, 70] que representa o preço por metro quadrado. 
--O programa deve exibir o valor total do terreno.
--------------------------------------------------------------------------------------
DO $$
DECLARE
	b                       NUMERIC(5,2);
	h                       NUMERIC(5,2);
	area                    NUMERIC(7,2);
	preco_metro_quadrado    NUMERIC(5,2);
	valor_total_terreno     NUMERIC(7,2); 
	limite_inferior_medidas INTEGER :=1;
	limite_superior_medidas INTEGER :=10;
    limite_inferior_preco   INTEGER :=60;
	limite_superior_preco   INTEGER :=70;
BEGIN
    b := random() * (limite_superior_medidas - limite_inferior_medidas) + limite_inferior_medidas;
	RAISE NOTICE 'Medida gerada para base do terreno = %', b;
	h := random() * (limite_superior_medidas - limite_inferior_medidas) + limite_inferior_medidas;
	RAISE NOTICE 'Medida gerada para altura do terreno = %', h;
    -- Area terreno = b * h
	area = b * h;
	RAISE NOTICE 'Área calculada = %', area;
	-- Gerar preço por metro quadrado
	preco_metro_quadrado = random() * (limite_superior_preco - limite_inferior_preco) + limite_inferior_preco; 
	RAISE NOTICE 'Preço gerado para metro quadrado = %', preco_metro_quadrado;
	-- valor total do terreno = area calculada * preço gerado por metro quadrado
	valor_total_terreno := area * preco_metro_quadrado;  
	RAISE NOTICE 'Valor total do terreno = %', valor_total_terreno;
END $$;
 
-------------------------------------------------------------------------------------------- 
--1.7 Escreva um programa que gere um inteiro que representa o ano de nascimento de uma
--pessoa no intervalo [1980, 2000] e gere um inteiro que representa o ano atual no intervalo
--[2010, 2020]. O programa deve exibir a idade da pessoa em anos. Desconsidere detalhes
--envolvendo dias, meses, anos bissextos etc.
---------------------------------------------------------------------------------------------
DO $$
DECLARE
	lim_inf_ano_nascto     INTEGER :=1980;
	lim_sup_ano_nascto     INTEGER :=2000;
	ano_nascto             INTEGER; 
	lim_inf_ano_atual      INTEGER :=2010;
	lim_sup_ano_atual      INTEGER :=2020;
	ano_atual              INTEGER;
	idade                  INTEGER;
BEGIN
    -- Gera ano nascimento
    ano_nascto := lim_inf_ano_nascto + floor(random() * (lim_sup_ano_nascto - lim_inf_ano_nascto + 1)); 
	RAISE NOTICE 'Ano Nascimento gerado = %', ano_nascto;
    -- Gera ano atual
    ano_atual := lim_inf_ano_atual + floor(random() * (lim_sup_ano_atual - lim_inf_ano_atual + 1));
	RAISE NOTICE 'Ano Atual gerado = %', ano_atual;
	-- Calcula Idade
    idade = ano_atual - ano_nascto;
	RAISE NOTICE 'Idade em anos = %', idade;
END $$;
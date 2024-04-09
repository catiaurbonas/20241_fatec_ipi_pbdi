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
    n1 := limite_inferior + floor(random() * (limite_superior - limite_inferior + 1 )); 
	RAISE NOTICE '%', n1;
END $$;

---------------------------------------------------------
--1.2. Faça um programa que gere um valor real e o exiba.
---------------------------------------------------------
DO $$
DECLARE
	limite_inferior NUMERIC(5,2) :=1;
	limite_superior NUMERIC(5,2) :=10;
	n1 DECIMAL(5,2);
BEGIN
    n1 := random() * (limite_superior - 1) + 1;  
	RAISE NOTICE '%', n1;
END $$;

--------------------------------------------------------------------------------------
--1.3 Faça um programa que gere um valor real no intervalo [20, 30] que representa uma
--temperatura em graus Celsius. Faça a conversão para Fahrenheit e exiba.
--------------------------------------------------------------------------------------
DO $$ 
DECLARE
	limite_inferior INTEGER :=20;
	limite_superior INTEGER :=30;
	n1 INTEGER;
	n2 NUMERIC(5,1);
BEGIN
    n1 := limite_inferior + floor(random() * (limite_superior - limite_inferior + 1 )); 
	RAISE NOTICE 'Temperatura em Graus Celsius: %', n1;
	-- °F = (°C x 1.8) + 32
	n2 := (n1 * 1.8) + 32; 
	RAISE NOTICE 'Temperatura em Fahrenheit: %', n2;

END $$;

--1.4 Faça um programa que gere três valores reais a, b, e c e mostre o valor de delta: aquele
--que calculamos para chegar às potenciais raízes de uma equação do segundo grau.
-- delta = b ^ 2 - (4 * a * c)
DO $$
DECLARE
	limite_inferior NUMERIC(5,2) :=1;
	limite_superior NUMERIC(5,2) :=10;
	a DECIMAL(5,2);
	b DECIMAL(5,2);
	c DECIMAL(5,2);
	delta DECIMAL (5,2);
BEGIN
    a := random() * (limite_superior - 1) + 1;
	RAISE NOTICE 'a = %', a;
	b := random() * (limite_superior - 1) + 1;
	RAISE NOTICE 'b = %', b;
	c := random() * (limite_superior - 1) + 1;
	RAISE NOTICE 'c = %', c;
	-- delta = b ^ 2 - (4 * a * c)
	delta  = ((b ^ 2) - (4 * a * c));
	RAISE NOTICE 'delta = %', delta;
	
END $$;

--1.5 Faça um programa que gere um número inteiro e mostre a raiz cúbica de seu antecessor
--e a raiz quadrada de seu sucessor.
DO $$
DECLARE
	limite_inferior INTEGER :=1;
	limite_superior INTEGER :=100;
	n1 INTEGER;
BEGIN
    n1 := limite_inferior + floor(random() * (limite_superior - limite_inferior + 1 )); 
	RAISE NOTICE 'Número Inteiro Gerado: %', n1;
	RAISE NOTICE 'Seu Antecessor %', n1-1;
	RAISE NOTICE 'Raiz Cubica do Antecessor %', ||/(n1-1);
END $$;


--1.6 Faça um programa que gere medidas reais de um terreno retangular. Gere também um
--valor real no intervalo [60, 70] que representa o preço por metro quadrado. O programa deve
--exibir o valor total do terreno.

DO $$
DECLARE
	base NUMERIC(5,2) :=1;
	altura NUMERIC(5,2) :=10;
    limite_inferior_preco NUMERIC(5,2) :=60;
	limite_superior_preco NUMERIC(5,2) :=70;
    area DECIMAL(5,2);
BEGIN
    preco := random() * (limite_superior_preco - 60) + 60;  
	
	RAISE NOTICE '%', n1;
END $$;



--1.7 Escreva um programa que gere um inteiro que representa o ano de nascimento de uma
--pessoa no intervalo [1980, 2000] e gere um inteiro que representa o ano atual no intervalo
--[2010, 2020]. O programa deve exibir a idade da pessoa em anos. Desconsidere detalhes
--envolvendo dias, meses, anos bissextos etc.

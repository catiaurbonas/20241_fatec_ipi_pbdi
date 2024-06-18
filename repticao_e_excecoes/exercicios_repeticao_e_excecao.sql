--Resolva cada exercício a seguir usando LOOP, WHILE, FOR e FOREACH. Quando o enunciado disser que é preciso “ler” algum valor, gere-o aleatoriamente. Em plpgsql:
-- 1.1 Write a program that prints all even numbers between 1 and 100, including them if it is the case.

DO $$
DECLARE
    num INTEGER;
BEGIN
    FOR num IN 1..100 LOOP
        IF num % 2 = 0 THEN
            RAISE NOTICE 'Número par: %', num;
        END IF;
    END LOOP;
END $$;

-- 1.2 Write a program that reads 6 numbers.
-- These numbers will only be positive or negative (disregard null values). 
-- Print the total number of positive numbers.
-- Gerar inteiros no intervalo de -50 a 50

DO $$
DECLARE
    num INTEGER;
    cont_positivo INTEGER := 0;
BEGIN
    FOR i IN 1..6 LOOP
        num := (CASE WHEN RANDOM() < 0.5 THEN -1 ELSE 1 END) * (FLOOR(RANDOM() * 101) - 50);
        IF num > 0 THEN
            cont_positivo := cont_positivo + 1;
        END IF;
        RAISE NOTICE 'Número: %', num;
    END LOOP;
    RAISE NOTICE 'Total de números positivos: %', cont_positivo;
END $$;

-- 1.3 Read two integer values X and Y. Print the sum of all odd values between them.
-- Gerar inteiros no intervalo de 20 a 50

DO $$
DECLARE
    num1 INTEGER := floor(random() * 31) + 20;
    num2 INTEGER := floor(random() * 31) + 20;
    temp INTEGER;
    soma_impares INTEGER := 0;
BEGIN
    RAISE NOTICE 'Número 1: %', num1;
    RAISE NOTICE 'Número 2: %', num2;
    IF num1 > num2 THEN
        temp := num1;
        num1 := num2;
        num2 := temp;
    END IF;
    FOR i IN num1+1..num2-1 LOOP
        IF i % 2 != 0 THEN
            soma_impares := soma_impares + i;
        END IF;
    END LOOP;
    RAISE NOTICE 'Soma dos ímpares entre % e %: %', num1, num2, soma_impares;
END $$;

-- 1.4 Read an undetermined number of pairs values M and N (stop when any of these values is less or equal to zero).
-- For each pair, print the sequence from the smallest to the biggest (including both) 
-- and the sum of consecutive integers between them (including both).
-- Gerar inteiros no intervalo de 0 a 100.

DO $$
DECLARE
    m INTEGER;
    n INTEGER;
    i INTEGER;
    soma INTEGER;
BEGIN
    LOOP
        m := floor(random() * 100);
        n := floor(random() * 100);
        EXIT WHEN m <= 0 OR n <= 0;
        RAISE NOTICE 'M e N são: % %', m, n;
        IF m > n THEN
            i := m;
            m := n;
            n := i;
        END IF;
        soma := 0;
        RAISE NOTICE 'Sequencia: ';
        FOR i IN m..n LOOP
            RAISE NOTICE '%', i;
            soma := soma + i;
        END LOOP;
        RAISE NOTICE 'Soma = %', soma;
    END LOOP;
END $$;

-- 2. Faça um programa que calcule o determinante de uma matriz quadrada de ordem 3
--utilizando a regra de Sarrus. Preencha a matriz com valores inteiros aleatórios no intervalo de 1 a 12.

DO $$
DECLARE
    matriz INTEGER[][];
    det INTEGER;
BEGIN
    matriz := ARRAY[
        [FLOOR(RANDOM() * 12 + 1), FLOOR(RANDOM() * 12 + 1), FLOOR(RANDOM() * 12 + 1)],
        [FLOOR(RANDOM() * 12 + 1), FLOOR(RANDOM() * 12 + 1), FLOOR(RANDOM() * 12 + 1)],
        [FLOOR(RANDOM() * 12 + 1), FLOOR(RANDOM() * 12 + 1), FLOOR(RANDOM() * 12 + 1)]
    ];
    RAISE NOTICE 'Matriz:';
    FOR i IN 1..3 LOOP
        RAISE NOTICE '% % %', matriz[i][1], matriz[i][2], matriz[i][3];
    END LOOP;
    det := matriz[1][1] * matriz[2][2] * matriz[3][3] +
           matriz[1][2] * matriz[2][3] * matriz[3][1] +
           matriz[1][3] * matriz[2][1] * matriz[3][2] -
           matriz[1][3] * matriz[2][2] * matriz[3][1] -
           matriz[1][2] * matriz[2][1] * matriz[3][3] -
           matriz[1][1] * matriz[2][3] * matriz[3][2];
    RAISE NOTICE 'Determinante: %', det;
END $$;
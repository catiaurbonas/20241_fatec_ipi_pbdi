-- CATIA REGINA MARQUES URBONAS

--1.1 Escreva um cursor que exiba as variáveis rank e youtuber de toda tupla que tiver
--video_count pelo menos igual a 1000 e cuja category seja igual a Sports ou Music.
DO $$
DECLARE
    --1. declaração do cursor
    --esse cursor é unbound por não ser associado a nenhuma query
    cur_nomes_youtubers REFCURSOR;
    --para armazenar o nome do youtuber a cada iteração
    v_youtuber VARCHAR(200);
BEGIN
    --2. abertura do cursor
    OPEN cur_nomes_youtubers FOR
    SELECT youtuber
    FROM
    tb_youtubers;
    LOOP
        --3. Recuperação dos dados de interesse
        FETCH cur_nomes_youtubers INTO v_youtuber;
        --FOUND é uma variável especial que indica
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%', v_youtuber;
    END LOOP;
    --4. Fechamento do cursos
    CLOSE cur_nomes_youtubers;
END;
$$


--1.2 Escreva um cursor que exibe todos os nomes dos youtubers em ordem reversa. Para tal
-- O SELECT deverá ordenar em ordem não reversa
-- O Cursor deverá ser movido para a última tupla
---Os dados deverão ser exibidos de baixo para cima

--1.3 Faça uma pesquisa sobre o anti-pattern chamado RBAR - Row By Agonizing Row.
--Explique com suas palavras do que se trata.
-- CATIA REGINA MARQUES URBONAS

--1.1 Escreva um cursor que exiba as variáveis rank e youtuber de toda tupla que tiver
--video_count pelo menos igual a 1000 e cuja category seja igual a Sports ou Music.
DO $$
	DECLARE
	cur_rank_nome REFCURSOR;
	tupla RECORD;
	v_nome_tabela VARCHAR(200) := 'tb_youtubers';
	v_category_1  CHAR(5) :='Sport';
	v_category_2  CHAR(5) :='Music';
	v_video_count  INT     := 1000; 
	
	BEGIN
		OPEN cur_rank_nome FOR EXECUTE
			format
			(
				'
				SELECT rank, youtuber
				FROM
				%s
				WHERE video_count >= $1
				AND (category = $2 or category = $3)
				'
				,
				v_nome_tabela
			) USING v_video_count, v_category_1, v_category_2;
		LOOP
			FETCH cur_rank_nome INTO tupla;
			EXIT WHEN NOT FOUND;
			RAISE NOTICE '%', tupla;
		END LOOP;
		CLOSE cur_rank_nome;
	END;
$$

--1.2 Escreva um cursor que exibe todos os nomes dos youtubers em ordem reversa. Para tal
-- O SELECT deverá ordenar em ordem não reversa
-- O Cursor deverá ser movido para a última tupla
---Os dados deverão ser exibidos de baixo para cima
DO $$
	DECLARE
		cur_leitura_reversa REFCURSOR;
		tupla RECORD;
	BEGIN
	-- scroll para poder voltar ao início
	OPEN cur_leitura_reversa SCROLL FOR
		SELECT
		*
		FROM
		tb_youtubers;
		-- mover o cursor para a última tupla
        FETCH LAST FROM cur_leitura_reversa INTO tupla;
		-- FETCH cur_leitura INTO tupla;
		LOOP
			FETCH BACKWARD FROM cur_leitura_reversa INTO tupla;
			EXIT WHEN NOT FOUND;
			RAISE NOTICE '%', tupla;
			END LOOP;
			CLOSE cur_leitura_reversa;
		END;
$$

--1.3 Faça uma pesquisa sobre o anti-pattern chamado RBAR - Row By Agonizing Row.
--Explique com suas palavras do que se trata.
--O anti-pattern RBAR (Row By Agonizing Row) acontece quando operações de banco de dados são realizadas 
--linha a linha de uma tabela, em vez de usar operações em toda a tabela de uma só vez. 
--Esse padrão é considerado um anti-pattern porque pode resultar em um desempenho ruim e em código mais complexo.
--O uso do RBAR pode ser justificado em situações específicas onde operações em cada linha são necessárias e 
--não podem ser realizadas de forma eficiente em conjunto. No entanto, na maioria dos casos, é preferível usar 
--operações de conjunto, como JOINs, UPDATEs e DELETEs, para manipular conjuntos de dados inteiros de uma só vez, 
--o que resulta em um desempenho melhor e em um código mais limpo e legível.

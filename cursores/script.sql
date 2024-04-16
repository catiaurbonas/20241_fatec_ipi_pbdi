-- Cursor não vinculado nao disse qual select esta vinculado
-- bloco anonimo
DO $$
DECLARE
	-- 1. declaracao cursor (não vinculado - a um select)
 	cur_nomes_youtubers REFCURSOR;
	v_youtuber VARCHAR(200);
BEGIN
    -- 2.abertura cursor
	OPEN cur_nomes_youtubers FOR
	    SELECT youtuber FROM tb_youtubers; 
		
	-- 3.recuperacao dados interesse
	LOOP 
		FETCH cur_nomes_youtubers INTO v_youtuber;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE '%', v_youtuber;
		
	END LOOP;
	-- Fechar cursor - evitar vazamento/disperdicio de recurso
	CLOSE cur_nomes_youtubers;
END;
$$

-- Cursor não vinculado (unbound) também mas com query dinamica
-- uma query representada como uma string
-- bloco anonimo
DO $$
DECLARE
	-- 1. declaracao cursor (não vinculado a um select)
 	cur_nomes_a_partir_de REFCURSOR;
	v_youtuber VARCHAR(200);
    v_ano      INT := 2008; 
	v_nome_tabela VARCHAR(200) := 'tb_youtubers';
BEGIN
    -- 2. abertura cursor
	OPEN cur_nomes_a_partir_de FOR EXECUTE 
	format(
		'
			SELECT youtuber
			FROM %s
			WHERE started >=$1
		', v_nome_tabela
	 ) USING v_ano;
	 
	-- 3. recuperacao dados interesse
	LOOP 
		FETCH cur_nomes_a_partir_de INTO v_youtuber;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE '%', v_youtuber;
	END LOOP;
	-- 4. Fechamento do cursor - evitar vazamento/disperdicio de recurso
	CLOSE cur_nomes_a_partir_de;
END;
$$

-- Cursor vinculado (bound) - nasce com select junto
-- a cada interação exibir os nome do canal concatenado a seu numero de inscritos
-- bloco anonimo
DO $$
	DECLARE
		--cursor vinculado (bound)
		--1.Declaração (ainda não está aberto)
		cur_nomes_e_inscritos CURSOR FOR 
		SELECT youtuber, subscribers FROM tb_youtubers;
		tupla RECORD;
		--record capaz de abrigar uma tupla(linha) inteira
		--tupla.youtuber nos dá o nome do youtuber
		--tupla.subscribers nos dá o número de inscritos
		resultado TEXT DEFAULT '';
	BEGIN
	    --2. Abertura do cursor
		OPEN cur_nomes_e_inscritos;
		-- vamos usar um loop WHILE
		-- 3. recuperacao de dados
		FETCH cur_nomes_e_inscritos INTO tupla;
		WHILE FOUND LOOP
		    -- concatenação - resultado é um concatenador, operador ||
			-- ao final concatena uma ',' para a próxima tupla(linha)
			resultado := resultado || tupla.youtuber || ':' || tupla.subscribers || ',';
			FETCH cur_nomes_e_inscritos INTO tupla;
		END LOOP;
		-- 4.Fechamento do cursor
		CLOSE cur_nomes_e_inscritos;
		RAISE NOTICE '%', resultado;
END;
$$

-- cursores com parametros nomeados e por ordem
-- exibir nomes dos youtubers que começarm a partir de 2010 
-- e tem pelo menos 60 milhoes de isncritos
DO $$
	DECLARE
		v_ano INT := 2010;
		v_inscritos INT := 60000000;
		-- 1.declaração cursor
		cur_ano_inscritos CURSOR (ano INT, inscritos INT) FOR 
		SELECT youtuber FROM
		tb_youtubers WHERE started >= ano AND subscribers >= inscritos;
		v_youtuber VARCHAR(200);
	BEGIN
	    -- 2. Abertura do Cursor
		--execute apenas um dos dois comandos OPEN a seguir
		-- passando argumentos pela ordem
		--OPEN cur_ano_inscritos (v_ano, v_inscritos);
		--passando argumentos por nome
		--OPEN cur_ano_inscritos (inscritos := v_inscritos, ano := v_ano);
		-- ou
		OPEN cur_ano_inscritos (ano := v_ano, inscritos := v_inscritos);
		LOOP
		    -- buscar o nome 
			-- 3.Recuperação dados 
			FETCH cur_ano_inscritos INTO v_youtuber;
			-- sair se for o caso
			EXIT WHEN NOT FOUND;
			--exibir se puder
			RAISE NOTICE '%', v_youtuber;
		END LOOP;
		--4.Fechamento 
		CLOSE cur_ano_inscritos;
	END;
$$

DO $$
	DECLARE
	cur_rank_nome REFCURSOR;
    v_videocount INT = 1000;
	v_nome_tabela VARCHAR(200) := 'tb_youtubers';
	v_youtuber VARCHAR(200);
	v_category_1 VARCHAR(200) := 'Sport';
	v_category_2 VARCHAR(200) := 'Music';
	BEGIN
		OPEN cur_rank_nome FOR EXECUTE
			format
			(
				'
				SELECT rank, youtuber
				FROM
				%s
				WHERE video_count >= $1
				AND category in ($2, $3)
				'
				,
				v_nome_tabela
			) USING v_videocount, v_category_1, v_category_2;
		LOOP
			FETCH cur_rank_nome INTO v_youtuber;
			EXIT WHEN NOT FOUND;
			RAISE NOTICE '%', v_youtuber;
		END LOOP;
		CLOSE cur_rank_nome;
	END;
$$






CREATE TABLE tb_youtubers(
	cod_top_youtubers SERIAL PRIMARY KEY,
	rank INT,
	youtuber VARCHAR(200),
	subscribers INT,
	video_views VARCHAR(200),
	video_count INT,
	category VARCHAR(200),
	started INT
);

-- alter 
ALTER TABLE tb_youtubers
ALTER COLUMN video_views 
TYPE BIGINT USING (video_views):: BIGINT;

SELECT * FROM tb_youtubers;




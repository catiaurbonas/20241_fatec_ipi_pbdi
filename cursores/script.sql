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
	-- Fechar cursor - evitar vazamento de recurso
	CLOSE cur_nomes_youtubers;
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


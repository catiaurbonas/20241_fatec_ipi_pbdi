DO $$
DECLARE
	n1 NUMERIC (5,2);
	n2 INTEGER;
	limite_inferior INTEGER := 5;
	limite_superior INTEGER := 17;
BEGIN

	-- simular o lançamento de uma moeda 0 ou 1
	RAISE NOTICE '%', floor(random() * 2);

	-- simular o lançamento de um dado
	RAISE NOTICE '%', 1 + floor(random() * 6);
	
	-- 17 <=n <=33 (inteiro)
	-- simular o lançamento de um dado
	RAISE NOTICE '%', 17 + floor(random() * 17);
	
	
	-- simular 
	RAISE NOTICE '%', limite_inferior + floor(random() * (limite_superior - limite_inferior + 1 ));

END;
$$

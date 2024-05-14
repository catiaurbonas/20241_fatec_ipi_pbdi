--FOREACH com SLICE
DO $$
DECLARE
	vetor INT[] :=ARRAY[1,2,3];
	matriz INT[] := ARRAY[
		[1, 2, 3],		
		[4, 5, 6],
		[7, 8, 9]
	];
	var_aux INT;
	vet_aux INT[];
BEGIN
   FOREACH vet_aux SLICE 1 IN ARRAY vetor LOOP
       RAISE NOTICE '%', vet_aux;
        --podemos percorrer vet_aux
       FOREACH var_aux IN ARRAY vet_aux LOOP
          RAISE NOTICE '%', var_aux;
       END LOOP;
   END LOOP;
   --exemplo com slice igual a 0, com matriz
   RAISE NOTICE 'SLICE %, matriz', 0;
   FOREACH var_aux IN ARRAY matriz LOOP
       RAISE NOTICE '%', var_aux;
   END LOOP;
   --exemplo com slice igual a 1, com matriz
   --com slice igual a 1, pegamos um vetor (linha) por vez
   RAISE NOTICE 'SLICE %, matriz', 1;
   FOREACH vet_aux SLICE 1 IN ARRAY matriz LOOP
      RAISE NOTICE '%', vet_aux;
   END LOOP;
   --exemplo com slice igual a 2, com matriz
   --com slice igual a 2, pegamos a matriz inteira numa única iteraçao
   RAISE NOTICE 'SLICE %, matriz', 2;
   FOREACH vet_aux SLICE 2 IN ARRAY matriz LOOP
       RAISE NOTICE '%', vet_aux;
   END LOOP;
END;
$$

--FOREACH
DO $$
DECLARE
	valores INT[] := ARRAY[1,10,5,4,3,2,16,5];
	valor INT;
	soma INT := 0;
BEGIN
	FOREACH valor IN ARRAY valores LOOP
	RAISE NOTICE 'Valor da vez: %', valor;
	soma:= soma + valor;
	END LOOP;
	RAISE NOTICE 'Soma: %', soma;
END;
$$


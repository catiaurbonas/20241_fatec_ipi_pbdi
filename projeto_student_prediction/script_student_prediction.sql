----------------------------------------------------
-- Apostila 13 - Base_de_dados_student_prediction -- 
----------------------------------------------------

--1.1 Estude e faça o download da base de dados disponível no Link 1.1.1.
--Link 1.1.1 https://www.kaggle.com/datasets/csafrit2/higher-education-students-performance-evaluation
-- OK

--1.2 Crie uma tabela apropriada para o armazenamento dos itens. Não se preocupe com a
--normalização. Uma tabela basta.
DROP TABLE tb_students;
CREATE TABLE tb_students     
		(id_student SERIAL PRIMARY KEY,
		AGE        SMALLINT,
		GENDER     SMALLINT,
		SALARY     SMALLINT,
		PREP_EXAM  SMALLINT,
		NOTES      SMALLINT,
		GRADE      SMALLINT);  

SELECT * FROM tb_students;		

--1.3 Copie os dados do arquivo .csv para a sua tabela. Veja como no Link 1.3.1. 
--Link 1.3.1 https://www.postgresql.org/docs/current/sql-copy.html
-- OK

--1.4 Escreva os seguintes stored procedures (incluindo um bloco anônimo de teste para cada um):

--1.4.1 Exibe o número de estudantes maiores de idade.
DROP PROCEDURE sp_estudantes_maiores_idade;
CREATE OR REPLACE PROCEDURE sp_estudantes_maiores_idade (OUT p_qtde_maiores_idade INT)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT COUNT(id_student) 
	FROM tb_students 
	WHERE age in (2,3)
	INTO $1;
END;
$$

DO $$
DECLARE
	p_qtde_maiores_idade INT;
BEGIN
	CALL sp_estudantes_maiores_idade(p_qtde_maiores_idade);
	RAISE NOTICE 'Quantidade de Alunos Maiores de idade: %', p_qtde_maiores_idade;
END;
$$

--1.4.2 Exibe o percentual de estudantes de cada sexo.
DROP PROCEDURE sp_percentual_genero;
CREATE OR REPLACE PROCEDURE sp_percentual_genero (OUT p_qtde_fem INT, OUT p_qtde_masc INT)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT COUNT(id_student) 
	FROM tb_students 
	WHERE gender = 1
	INTO $1;
	
	SELECT COUNT(id_student) 
	FROM tb_students 
	WHERE gender = 2
	INTO $2;
END;
$$

DO $$
DECLARE
	p_qtde_fem  INT;
	p_qtde_masc  INT;
BEGIN
    CALL sp_percentual_genero(p_qtde_fem, p_qtde_masc);
	RAISE NOTICE 'Percentual de Alunos do Sexo Feminino: %', (p_qtde_fem * 100)/ (p_qtde_fem + p_qtde_masc);
	RAISE NOTICE 'Percentual de Alunos do Sexo Masculino: %', (p_qtde_masc * 100)/ (p_qtde_fem + p_qtde_masc);
END;
$$

	SELECT grade,count(grade) 
	FROM tb_students 
	WHERE gender = 1
    GROUP BY grade
	ORDER by grade
	  
--1.4.3 Recebe um sexo como parâmetro em modo IN e utiliza oito parâmetros em modo OUT
--para dizer qual o percentual de cada nota (variável grade) obtida por estudantes daquele sexo.
DROP PROCEDURE sp_percentual_notas;
--
CREATE OR REPLACE PROCEDURE sp_percentual_notas 
(IN  p_sexo     INT, 
 OUT p_grade_1  INT,
 OUT p_grade_2  INT,
 OUT p_grade_3  INT,
 OUT p_grade_4  INT,
 OUT p_grade_5  INT,
 OUT p_grade_6  INT,
 OUT p_grade_7  INT,
 OUT p_grade_8  INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT count(grade) 
	FROM tb_students 
	WHERE gender = $1
      AND grade = 0
	INTO $2;
	--
	SELECT count(grade) 
	FROM tb_students 
	WHERE gender = $1
      AND grade = 1
	INTO $3; 
    -- 
	SELECT count(grade) 
	FROM tb_students 
	WHERE gender = $1
      AND grade = 2
	INTO $4;
	--
	SELECT count(grade) 
	FROM tb_students 
	WHERE gender = $1
      AND grade = 3
	INTO $5;
	--
	SELECT count(grade) 
	FROM tb_students 
	WHERE gender = $1
      AND grade = 4
	INTO $6;
	--
	SELECT count(grade) 
	FROM tb_students 
	WHERE gender = $1
      AND grade = 5
	INTO $7;
	--
	SELECT count(grade) 
	FROM tb_students 
	WHERE gender = $1
      AND grade = 6
	INTO $8;
	--
	SELECT count(grade) 
	FROM tb_students 
	WHERE gender = $1
      AND grade = 7
	INTO $9;
END;
$$

DO $$
DECLARE
	p_grade_1  INT;
 	p_grade_2  INT;
 	p_grade_3  INT;
 	p_grade_4  INT;
 	p_grade_5  INT;
 	p_grade_6  INT;
 	p_grade_7  INT;
 	p_grade_8  INT;
	v_total    INT;
BEGIN
    CALL sp_percentual_notas(2, p_grade_1, p_grade_2, p_grade_3, p_grade_4, p_grade_5, p_grade_6, p_grade_7, p_grade_8);
    v_total = p_grade_1 + p_grade_2 + p_grade_3 + p_grade_4 + p_grade_5 + p_grade_6 + p_grade_7 + p_grade_8;
	p_grade_1 = (p_grade_1 * 100) / v_total;
	p_grade_2 = (p_grade_2 * 100) / v_total;
	p_grade_3 = (p_grade_3 * 100) / v_total; 
	p_grade_4 = (p_grade_4 * 100) / v_total; 
	p_grade_5 = (p_grade_5 * 100) / v_total; 
	p_grade_6 = (p_grade_6 * 100) / v_total;
	p_grade_7 = (p_grade_7 * 100) / v_total;
	p_grade_8 = (p_grade_8 * 100) / v_total;
--
	RAISE NOTICE 'Percentual de Grade 0: %', p_grade_1;
	RAISE NOTICE 'Percentual de Grade 1: %', p_grade_2;
	RAISE NOTICE 'Percentual de Grade 2: %', p_grade_3;
	RAISE NOTICE 'Percentual de Grade 3: %', p_grade_4;
	RAISE NOTICE 'Percentual de Grade 4: %', p_grade_5;
	RAISE NOTICE 'Percentual de Grade 5: %', p_grade_6;
	RAISE NOTICE 'Percentual de Grade 6: %', p_grade_7;  
    RAISE NOTICE 'Percentual de Grade 7: %', p_grade_8;  
END;
$$


--1.5 Escreva as seguintes functions (incluindo um bloco anônimo de teste para cada uma):

--1.5.1 Responde (devolve boolean) se é verdade que todos os estudantes de renda acima de
--410 são aprovados (grade > 0).
--routine se aplica a funções e procedimentos
DROP ROUTINE IF EXISTS fn_aprovacao_vs_renda;
--
CREATE OR REPLACE FUNCTION fn_aprovacao_vs_renda() RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	v_qtde INT;
BEGIN 	
	SELECT count(salary) 
	  FROM tb_students
	WHERE salary < 5 
	  AND grade  < 0
	 INTO v_qtde;
	 IF v_qtde > 0 THEN
	 	RETURN FALSE;
	 END IF;
	 RETURN TRUE;
END;
$$

DO $$
DECLARE
	v_resposta BOOLEAN;
BEGIN
	SELECT fn_aprovacao_vs_renda() INTO v_resposta;
	RAISE NOTICE '%', v_resposta;	
END;
$$


--1.5.2 Responde (devolve boolean) se é verdade que, entre os estudantes que fazem
--anotações pelo menos algumas vezes durante as aulas, pelo menos 70% são aprovados
--(grade > 0).
DROP ROUTINE IF EXISTS fn_anotacao_vs_aprovacao;
--
CREATE OR REPLACE FUNCTION fn_anotacao_vs_aprovacao() RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	v_qtde_anotam INT;
	v_qtde_anotam_e_aprovados INT;
	v_percentual_anotam_e_aprovados INT;
BEGIN 	
	SELECT count(id_student)  
	  FROM tb_students
	WHERE notes in (2,3)
	 INTO v_qtde_anotam;
	 
	SELECT count(id_student)  
	  FROM tb_students
	WHERE notes in (2,3)
	  AND grade  > 0
	 INTO v_qtde_anotam_e_aprovados;
	 
	v_percentual_anotam_e_aprovados = (v_qtde_anotam_e_aprovados * 100)/ v_qtde_anotam; 
	 
	IF v_percentual_anotam_e_aprovados > 70 THEN
	 	RETURN TRUE;
	 END IF;
	 RETURN FALSE;
END;
$$

DO $$
DECLARE
	v_resposta BOOLEAN;
BEGIN
	SELECT fn_anotacao_vs_aprovacao() INTO v_resposta;
	RAISE NOTICE '%', v_resposta;	
END;
$$

--1.5.3 Devolve o percentual de alunos que se preparam pelo menos um pouco para os
--“midterm exams” e que são aprovados (grade > 0).
DROP ROUTINE IF EXISTS fn_preparacao_vs_aprovacao;
--
CREATE OR REPLACE FUNCTION fn_preparacao_vs_aprovacao() RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
	v_qtde_preparados INT;
	v_qtde_preparados_e_aprovados INT;
	v_percentual_preparados_e_aprovados INT;
BEGIN 	
	SELECT count(id_student)  
	  FROM tb_students
	WHERE prep_exam in (1,2)
	 INTO v_qtde_preparados;
	 
	SELECT count(id_student)  
	  FROM tb_students
	WHERE prep_exam in (1,2)
	  AND grade  > 0
	 INTO v_qtde_preparados_e_aprovados;
	 
	v_percentual_preparados_e_aprovados = (v_qtde_preparados_e_aprovados * 100)/ v_qtde_preparados; 
	 
 	RETURN v_percentual_preparados_e_aprovados;
END;
$$

DO $$
DECLARE
	v_resposta INT;
BEGIN
	SELECT fn_preparacao_vs_aprovacao() INTO v_resposta;
	RAISE NOTICE '%', v_resposta;	
END;
$$
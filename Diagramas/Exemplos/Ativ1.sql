CREATE TABLE IF NOT EXISTS tipoambiente(
    id SERIAL2 NOT NULL,
    nome VARCHAR(20) NOT NULL,

    CONSTRAINT pk_tipoambiente PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS sala(
    id SERIAL NOT NULL,
    nome VARCHAR(25) NOT NULL,
    bloco CHAR(1) NOT NULL,
    andar INT2 NOT NULL,
    idtipo INT2 NOT NULL,

    CONSTRAINT fk_tipo
    FOREIGN KEY (idtipo)
    REFERENCES tipoambiente(id),

    CONSTRAINT pk_sala PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS pessoa(
    id SERIAL NOT NULL,
    nome VARCHAR(60) NOT NULL,
    email VARCHAR(40) NOT NULL,
    telefone CHAR(14) NOT NULL,

    CONSTRAINT pk_pessoa PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS categoria(
    id SERIAL NOT NULL,
    nome VARCHAR(20) NOT NULL,

    CONSTRAINT pk_categoria PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS equipamento(
    id SERIAL NOT NULL,
    patrimonio INT NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    ativo BOOL NOT NULL DEFAULT True,
    idpessoa INT NOT NULL,
    idcategoria INT NOT NULL,

    CONSTRAINT fk_pessoa
    FOREIGN KEY (idpessoa)
    REFERENCES pessoa(id),

    CONSTRAINT fk_categoria
    FOREIGN KEY (idcategoria)
    REFERENCES categoria(id),

    CONSTRAINT pk_equipamento PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS manutencao(
    id SERIAL NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NULL,
    custo INT2 NOT NULL DEFAULT 0,
    desc_problema VARCHAR(30) NOT NULL,
    desc_servico VARCHAR(100) NOT NULL,
    idpessoa INT NOT NULL,
    idequipamento INT NOT NULL,

    CONSTRAINT fk_pessoa
    FOREIGN KEY (idpessoa)
    REFERENCES pessoa(id),

    CONSTRAINT fk_equipamento
    FOREIGN KEY (idequipamento)
    REFERENCES equipamento(id),

    CONSTRAINT pk_manutencao PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS lotacao(
    id SERIAL8 NOT NULL,
    data_entrada DATE NOT NULL,
    data_saida DATE NULL,
    idsala INT NOT NULL,
    idequipamento INT NOT NULL,
    idpessoa INT NOT NULL,

    CONSTRAINT fk_pessoa
    FOREIGN KEY (idpessoa)
    REFERENCES pessoa(id),

    CONSTRAINT fk_equipamento
    FOREIGN KEY (idequipamento)
    REFERENCES equipamento(id),

    CONSTRAINT fk_sala
    FOREIGN KEY (idsala)
    REFERENCES sala(id),

    CONSTRAINT pk_lotacao PRIMARY KEY(id)

);

--POPULAR TABELAS DO BANCO DE DADOS UTILIZANDO DML
INSERT INTO tipoambiente (nome) VALUES 
    ('Lab de informática'),
    ('Sala de aula'),
    ('Secretaria'),
    ('Depósito'),
    ('Sala discente');

INSERT INTO sala (nome, bloco, andar, idtipo) VALUES
    ('DCOM Lab 01', 'B', 0, 1),
    ('DCOM Lab 02', 'B', 0, 1),
    ('DCOM Lab 03', 'B', 0, 1),
    ('DCOM Sec', 'B', 0, 3),
    ('DOAÇÃO', 'A', 1, 4),
    ('A-01', 'A', 0, 2);

INSERT INTO categoria (nome) VALUES
    ('Computador'),
    ('Notebook'),
    ('Datashow'),
    ('Impressora'),
    ('Cadeira');

INSERT INTO pessoa (nome, email, telefone) VALUES
    ('João', 'João@gmail.com', '65 99876-5432'),
    ('Maria', 'Maria@gmail.com', '65 94739-8306'),
    ('José', 'José@gmail.com', '65 97305-6402'),
    ('Beatriz', 'Beatriz@gmail.com', '65 99123-9362');

INSERT INTO equipamento (patrimonio, descricao, ativo, idpessoa, idcategoria) VALUES
    (1002, 'Lenovo ThinkCentre', DEFAULT, 1, 1),
    (1234, 'Lenovo ThinkCentre', DEFAULT, 1, 1),
    (2793, 'Sony VPL-EX5', DEFAULT, 2, 3),
    (4878, 'HP DeskJet Ink Advantage 2975', DEFAULT, 4, 4),
    (4952, 'Dell 15', False, 4, 2);

INSERT INTO manutencao (data_inicio, data_fim, custo, desc_problema, desc_servico, idpessoa, idequipamento) VALUES
    ('2026-10-01', '2026-10-3', 30, 'Computador não liga', 'Foi soldado novo conector no cabo de energia', 3, 2),
    ('2025-05-31', '2026-6-1', DEFAULT, 'Cartucho de tinta preso', 'O cartucho de tinta foi colocado de forma errada, foi tirando usando ferramentas', 3, 4),
    ('2026-08-25', NULL, 150, 'Notebook não liga', 'Troca da bateria necessária', 3, 5);

INSERT INTO lotacao (data_entrada, data_saida, idsala, idequipamento, idpessoa) VALUES
    ('2026-07-14', '2026-07-18', 2, 3, 1),
    ('2026-03-25', NULL, 4, 4, 4);

/*UPDATES
ALTER TABLE equipamento ADD COLUMN preco int;
UPDATE equipamento SET preco=1400 WHERE id in (1,2);
UPDATE equipamento SET preco=900 WHERE id=3;
UPDATE equipamento SET preco=500 WHERE id=4;
UPDATE equipamento SET preco=4898 WHERE id=5;*/

--Ex 1) Faça consulta que exiba os equipamentos inativos cujo valor de compra seja menor do que 1000;
--SELECT id,descricao,ativo,preco FROM equipamento WHERE preco<1000 AND ativo=false ORDER BY preco;

/*--UPDATES
INSERT INTO categoria (nome) VALUES
    ('Instrumento');*/

INSERT INTO equipamento (patrimonio, descricao, ativo, idpessoa, idcategoria, preco) VALUES
    (0, 'Multimetro', DEFAULT, 1, 6, 90),
    (0, 'Alicate de corte', DEFAULT, 1, 6, 30);

INSERT INTO equipamento (patrimonio, descricao, ativo, idpessoa, idcategoria, preco) VALUES
    (0, 'Osciloscópio', false, 1, 6, 10000);

--EX 2) Faça uma consulta que exiba todos os equipamentos ativos que ainda não foram patrimoniados
SELECT id,patrimonio,descricao,ativo FROM equipamento WHERE patrimonio=0 AND ativo=true;

--EX 3) Faça uma consulta que busque equipamentos cuja a descrição tenha a palavra datashow (No meu caso Lenovo)
SELECT id,descricao FROM equipamento WHERE descricao LIKE '%Lenovo%';

--Faça uma consulta que lista os equipamentos da categoria notebook
SELECT * FROM equipamento WHERE idcategoria=(SELECT id FROM categoria WHERE UPPER(nome)='NOTEBOOK');

--Faça uma consulta que liste a lotação atual do equipamento de código 2 (No meu caso 4)
SELECT * FROM lotacao WHERE idequipamento=4 ORDER BY data_entrada DESC LIMIT 1;

SELECT * FROM sala WHERE id=(SELECT idsala FROM lotacao WHERE idequipamento=4 ORDER BY data_entrada DESC, id DESC LIMIT 1);

--Faça uma consulta que liste a identificação do ambiente e o nome do tipo de ambiente ordenado por tipo de ambiente
SELECT t.nome,s.nome,s.bloco,s.andar FROM tipoambiente t INNER JOIN sala s ON t.id = s.idtipo ORDER BY t.nome;

--Faça uma consulta que liste os equipamentos (nome, descricao, patrimomio) que se encontram em manutenção
SELECT e.descricao,e.patrimonio, m.data_inicio AS manutencao_desde, m.custo, m.desc_problema, m.desc_servico FROM equipamento e INNER JOIN manutencao m ON e.id = m.idequipamento WHERE m.data_fim IS NULL;

SELECT e.descricao,e.patrimonio, m.data_inicio AS manutencao_desde, CURRENT_DATE-m.data_inicio AS qtde_dias, m.custo, m.desc_problema, m.desc_servico FROM equipamento e INNER JOIN manutencao m ON e.id = m.idequipamento WHERE m.data_fim IS NULL;

--Faça uma consulta que liste a lotação atual do equipamento de código 2. No resultado deverá ser apresentado o nome do tipo de equipamento, a identificação do ambiente, bem como o tipo de ambiente e o nome do usuario que realizou a lotação.
SELECT c.nome AS categoria, s.nome AS sala, t.nome AS tipo_ambiente, p.nome AS cadastrante from 
equipamento e INNER JOIN lotacao l ON e.id = l.idequipamento 
INNER JOIN sala s ON s.id = l.idsala 
INNER JOIN tipoambiente t ON t.id = s.idtipo 
INNER JOIN pessoa p ON p.id = l.idpessoa
INNER JOIN categoria c ON c.id=e.idcategoria
WHERE e.id=4 ORDER BY data_entrada DESC LIMIT 1;

--Faça uma consulta que apresente o menor e o maior valor de equipamento já adquirido.
SELECT MIN(preco), MAX(preco) from equipamento; 

--Faça uma consulta que apresente o nome, a descrição e o tipo de equipamento de maior valor
SELECT e.descricao, c.nome, e.preco from
equipamento e INNER JOIN categoria c ON c.id = e.idcategoria ORDER BY preco DESC LIMIT 1;

SELECT e.descricao, c.nome, e.preco from
equipamento e INNER JOIN categoria c ON c.id = e.idcategoria WHERE e.preco=(SELECT MAX(preco) FROM equipamento);

--Faça uma consulta que apresente a área total do bloco A
SELECT SUM(area) FROM sala WHERE bloco='A';

--Faça uma consulta que apresente a qtde de ambientes do bloco A
SELECT COUNT(id) FROM sala WHERE bloco='A';

--Faça uma consulta que apresente uma média de dias que os equipamentos ficam em manutenção
SELECT AVG(data_fim-data_inicio) FROM manutencao WHERE data_fim IS NOT NULL;

/* UPDATES
ALTER TABLE sala ADD COLUMN area decimal(4,2) DEFAULT 0;

UPDATE sala SET area=20 WHERE id in(1,2,3);
UPDATE sala SET area=15 WHERE id in(4,5,6);*/

--Faça uma consulta que apresente a qtde de ambiente por bloco
SELECT bloco, COUNT(bloco) AS quantidade_ambiente FROM sala GROUP BY bloco ORDER BY bloco;

--Faça uma consulta que apresente a qtde de equipamento por tipo de equipamento
SELECT c.nome, COUNT(c.nome) FROM equipamento e INNER JOIN categoria c ON c.id=e.idcategoria GROUP BY c.nome;

SELECT c.nome, e.qtde FROM categoria c INNER JOIN (SELECT idcategoria, COUNT(idcategoria) AS qtde FROM equipamento GROUP BY idcategoria) e ON c.id=e.idcategoria;

--Faça uma consulta que apresente a qtde e manutenções mês a mês
SELECT EXTRACT(YEAR from data_inicio), EXTRACT(MONTH from data_inicio), COUNT(EXTRACT(MONTH from data_inicio)) FROM manutencao GROUP BY EXTRACT(MONTH from data_inicio),EXTRACT(YEAR from data_inicio) ORDER BY EXTRACT(MONTH from data_inicio);

--Faça uma consulta que apresente a qtde de equipamento por ambiente
SELECT s.nome, COUNT(s.nome) FROM lotacao l INNER JOIN sala s ON s.id=l.idsala WHERE l.data_saida IS NULL GROUP BY s.nome;

--UPDATES
/*INSERT INTO lotacao (data_entrada, data_saida, idsala, idequipamento, idpessoa) VALUES
    ('2026-09-14', NULL, 2, 1, 1),
    ('2026-07-15', NULL, 1, 5, 2);*/

--Faça uma consulta que apresente a qtde de operações (lotação e manutenção) de cada usuário em um determinado mês
SELECT o.ano, o.mes, p.nome, COUNT(p.nome)
FROM
    (SELECT idpessoa, EXTRACT(YEAR FROM data_entrada) AS ano, EXTRACT(MONTH FROM data_entrada) AS mes FROM lotacao 
    UNION ALL
    SELECT idpessoa, EXTRACT(YEAR FROM data_inicio), EXTRACT(MONTH FROM data_inicio) FROM manutencao) o
INNER JOIN pessoa p ON p.id = o.idpessoa
GROUP BY o.ano, o.mes, p.nome
HAVING o.ano=2026
ORDER BY o.ano, o.mes, p.nome;

--Aula de index
EXPLAIN ANALYZE SELECT * from equipamento WHERE descricao like '%lenovo%'

CREATE INDEX idx_equipamento_descricao ON equipamento(descricao);

CREATE VIEW equipamento_em_manutencao AS SELECT e.descricao,e.patrimonio, m.data_inicio AS manutencao_desde, m.custo, m.desc_problema, m.desc_servico FROM equipamento e INNER JOIN manutencao m ON e.id = m.idequipamento WHERE m.data_fim IS NULL;

CREATE VIEW equipamento_barato AS SELECT * FROM equipamento WHERE preco<1000;

CREATE MATERIALIZED VIEW equipamento_barato AS SELECT * FROM equipamento WHERE preco<1000;

INSERT INTO equipamento (patrimonio, descricao, ativo, idpessoa, idcategoria, preco) VALUES
    (8349, 'Alicate', DEFAULT, 1, 6, 35);

REFRESH MATERIALIZED VIEW equipamento_barato;

CREATE USER fran WITH PASSWORD 'fran';
GRANT SELECT ON equipamento_barato TO fran;
GRANT USAGE ON SCHEMA public TO fran;

--Crie um procedimento que retorna a lotação atual de um equipamento
CREATE OR REPLACE PROCEDURE lotacao_atual(
p_id_equipamento INT,
INOUT p_sala_lotacao TEXT
)
language plpgsql
AS $$
BEGIN
    SELECT s.nome INTO p_sala_lotacao from 
    equipamento e INNER JOIN lotacao l ON e.id = l.idequipamento 
    INNER JOIN sala s ON s.id = l.idsala 
    WHERE e.id=p_id_equipamento AND l.data_saida IS NULL;
END;
$$;

--Crie uma função que estime a capacidade de pessoas do ambiente baseado na área (1 pessoa a cada 2m²)
CREATE OR REPLACE FUNCTION qtde_pessoa(
    f_area DECIMAL
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_qtde_total NUMERIC;
BEGIN
    IF f_area <= 0 THEN
        Return 0;
    END IF;
v_qtde_total := f_area/2;

RETURN FLOOR(v_qtde_total); --OU ROUND
END;
$$;

--Crie um procedimento que realize a transferencia de um equipamento para outro ambiente ou sala
CREATE OR REPLACE PROCEDURE transferencia_equip(
    p_id_equipamento INT,
    p_id_sala INT,
    p_id_usuario INT
)
language plpgsql
AS $$
DECLARE
    v_insert NUMERIC;
BEGIN

    UPDATE lotacao SET data_saida=CURRENT_DATE WHERE idequipamento = p_id_equipamento AND data_saida IS NULL;

    INSERT INTO lotacao (data_entrada, data_saida, idsala, idequipamento, idpessoa) VALUES
    (CURRENT_DATE, NULL, p_id_sala, p_id_equipamento, p_id_usuario) returning id INTO v_insert;

    if v_insert > 0 THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END;
$$;
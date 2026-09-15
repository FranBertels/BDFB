CREATE TABLE categoria(
    id SERIAL2 NOT NULL,
    nome VARCHAR(30) NOT NULL,

    CONSTRAINT pk_categoria PRIMARY KEY(id)
);



CREATE TABLE produto(
    id SERIAL NOT NULL,
    nome VARCHAR(50) NOT NULL,
    descricao VARCHAR(50),
    valor_unitario MONEY DEFAULT 0,
    qtde INT DEFAULT 0,
    imagem VARCHAR(100),
    idcategoria INT2 NOT NULL,
    
    CONSTRAINT fk_categoria
    FOREIGN KEY (idcategoria)
    REFERENCES categoria(id),

    CONSTRAINT pk_produto PRIMARY KEY(id)
);

CREATE TABLE lote(
    id SERIAL8 NOT NULL,
    data_fabricacao DATE NOT NULL,
    data_validade DATE NOT NULL,
    qtde INT2 NOT NULL,
    custo MONEY NOT NULL DEFAULT 0,
    localizacao CHAR(1) NOT NULL DEFAULT 'E',
    idproduto INT NOT NULL,

    CONSTRAINT fk_produto
    FOREIGN KEY (idproduto)
    REFERENCES produto(id),

    CONSTRAINT pk_lote PRIMARY KEY(id)
);
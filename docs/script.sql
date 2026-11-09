CREATE TABLE cliente
(
 id_cliente INT PRIMARY KEY AUTO_INCREMENT,
 nome VARCHAR(150) NOT NULL,
 documento VARCHAR(20) NOT NULL,
 endereco VARCHAR(255),
 telefone VARCHAR(20),
 email VARCHAR(254) NOT NULL,
 UNIQUE (documento,email)
);

CREATE TABLE pedido
(
 id_pedido INT PRIMARY KEY AUTO_INCREMENT,
 id_cliente INT,
 valor_total DECIMAL(10, 2) NOT NULL,
 tipo_pagamento ENUM('pix', 'debito', 'credito', 'dinheiro') NOT NULL,
 endereco_entrega VARCHAR(255) DEFAULT 'retirada',
 status ENUM('em espera', 'entregue', 'em produção', 'validando', 'enviando') NOT NULL DEFAULT 'em espera',
 data_emissao DATETIME NOT NULL,
 data_prevista DATE NOT NULL,
 data_saida DATETIME,
 taxa_entrega DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
 data_cancelamento DATETIME
);

CREATE TABLE nota_fiscal
(
 id_nota INT PRIMARY KEY AUTO_INCREMENT,
 id_pedido INT NOT NULL,
 data_emissao DATETIME NOT NULL,
 status_nota BOOLEAN NOT NULL,
 UNIQUE (id_pedido)
);

CREATE TABLE produto
(
 id_produto INT PRIMARY KEY AUTO_INCREMENT,
 nome VARCHAR(150) NOT NULL,
 descricao  VARCHAR(500) NOT NULL,
 valor_unitario DECIMAL(10, 2),
 quantidade_minima INT NOT NULL DEFAULT 0
);

CREATE TABLE lote
(
 id_lote INT PRIMARY KEY AUTO_INCREMENT,
 id_produto INT NOT NULL,
 id_estoque INT NOT NULL,
 id_pedido INT NOT NULL,
 data_validade DATE,
 quantidade_produto INT NOT NULL,
 data_fabricacao DATETIME,
 valor_lote DECIMAL(10,2)
);

CREATE TABLE formula
(
 id_formula INT PRIMARY KEY AUTO_INCREMENT,
 id_produto INT NOT NULL,
 versao VARCHAR(20) NOT NULL,
 status INT NOT NULL,
 data_inicio DATE NOT NULL,
 data_fim DATE,
 UNIQUE (versao)
);

CREATE TABLE maquina
(
 id_maquina INT PRIMARY KEY AUTO_INCREMENT,
 status ENUM('ativa', 'em manutenção', 'inativa') NOT NULL DEFAULT 'ativa',
 tipo VARCHAR(50) NOT NULL,
 capacidade_max INT
);

CREATE TABLE materia_prima
(
 id_materia INT PRIMARY KEY AUTO_INCREMENT,
 nome VARCHAR(150) NOT NULL,
 descricao VARCHAR(500) NOT NULL,
 quantidade INT NOT NULL DEFAULT 1
);

CREATE TABLE fornecedor
(
 id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
 nome VARCHAR(150) NOT NULL,
 descricao VARCHAR(500),
 cnpj VARCHAR(18) NOT NULL,
 UNIQUE (cnpj)
);

CREATE TABLE estoque
(
 id_estoque INT PRIMARY KEY AUTO_INCREMENT,
 localizacao VARCHAR(150) NOT NULL,
 capacidade_max INT NOT NULL
);

CREATE TABLE entrega
(
 id_entrega INT PRIMARY KEY AUTO_INCREMENT,
 data_entrega DATETIME NOT NULL,
 codigo_rastreio VARCHAR(50) NOT NULL,
 id_pedido INT,
 id_veiculo INT,
 UNIQUE (codigo_rastreio)
);

CREATE TABLE veiculo
(
 id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
 placa VARCHAR(7) NOT NULL,
 modelo VARCHAR(100) NOT NULL,
 UNIQUE (placa)
);

CREATE TABLE producao
(
 id_producao INT PRIMARY KEY AUTO_INCREMENT,
 id_pedido INT,
 id_produto INT NOT NULL,
 quantidade INT NOT NULL
);

CREATE TABLE movimento_estoque
(
 id_movimento INT PRIMARY KEY AUTO_INCREMENT,
 id_estoque INT NOT NULL,
 quantidade INT NOT NULL,
 motivo VARCHAR(255) NOT NULL,
 data DATETIME NOT NULL,
 tipo VARCHAR(50)
);

CREATE TABLE comprar_materia
(
 id_comprar INT PRIMARY KEY AUTO_INCREMENT,
 id_materia INT NOT NULL,
 id_fornecedor INT NOT NULL,
 valor DECIMAL(10,2) NOT NULL,
 comprovante_link VARCHAR(2048) NOT NULL,
 UNIQUE (id_comprar)
);

CREATE TABLE formula_materia
(
 id_formula_materia INT PRIMARY KEY AUTO_INCREMENT,
 id_formula INT NOT NULL,
 id_materia INT NOT NULL,
 quantidade FLOAT NOT NULL,
 unidade_medida VARCHAR(20) NOT NULL,
 ordem INT NOT NULL
);

CREATE TABLE formula_maquina
(
 id_formula_maquina INT PRIMARY KEY,
 id_formula INT NOT NULL,
 id_maquina INT NOT NULL
);

CREATE TABLE parada_manutencao
(
 id_parada INT PRIMARY KEY AUTO_INCREMENT,
 id_maquina INT NOT NULL,
 data DATETIME NOT NULL,
 descricao VARCHAR(500) NOT NULL,
 status VARCHAR(30) NOT NULL
);

CREATE TABLE embalagem
(
 id_embalagem INT PRIMARY KEY AUTO_INCREMENT,
 id_produto INT NOT NULL,
 status VARCHAR(30) NOT NULL,
 tipo VARCHAR(50) NOT NULL,
 altura DECIMAL(8, 3) NOT NULL,
 largura DECIMAL(8, 3) NOT NULL,
 profundidade DECIMAL(8, 3) NOT NULL,
 unidade_medida VARCHAR(20) NOT NULL
);

ALTER TABLE pedido ADD FOREIGN KEY(id_cliente) REFERENCES cliente (id_cliente);
ALTER TABLE nota_fiscal ADD FOREIGN KEY(id_pedido) REFERENCES pedido (id_pedido);
ALTER TABLE lote ADD FOREIGN KEY(id_produto) REFERENCES produto (id_produto);
ALTER TABLE lote ADD FOREIGN KEY(id_estoque) REFERENCES estoque (id_estoque);
ALTER TABLE lote ADD FOREIGN KEY(id_pedido) REFERENCES pedido (id_pedido);
ALTER TABLE formula ADD FOREIGN KEY(id_produto) REFERENCES produto (id_produto);
ALTER TABLE entrega ADD FOREIGN KEY(id_pedido) REFERENCES pedido (id_pedido);
ALTER TABLE entrega ADD FOREIGN KEY(id_veiculo) REFERENCES veiculo (id_veiculo);
ALTER TABLE producao ADD FOREIGN KEY(id_pedido) REFERENCES pedido (id_pedido);
ALTER TABLE producao ADD FOREIGN KEY(id_produto) REFERENCES produto (id_produto);
ALTER TABLE movimento_estoque ADD FOREIGN KEY(id_estoque) REFERENCES estoque (id_estoque);
ALTER TABLE comprar_materia ADD FOREIGN KEY(id_materia) REFERENCES materia_prima (id_materia);
ALTER TABLE comprar_materia ADD FOREIGN KEY(id_fornecedor) REFERENCES fornecedor (id_fornecedor);
ALTER TABLE formula_materia ADD FOREIGN KEY(id_formula) REFERENCES formula (id_formula);
ALTER TABLE formula_materia ADD FOREIGN KEY(id_materia) REFERENCES materia_prima (id_materia);
ALTER TABLE formula_maquina ADD FOREIGN KEY(id_formula) REFERENCES formula (id_formula);
ALTER TABLE formula_maquina ADD FOREIGN KEY(id_maquina) REFERENCES maquina (id_maquina);
ALTER TABLE parada_manutencao ADD FOREIGN KEY(id_maquina) REFERENCES maquina (id_maquina);
ALTER TABLE embalagem ADD FOREIGN KEY(id_produto) REFERENCES produto (id_produto);

-- =====================================================================
-- Create data_base
-- =====================================================================
DROP DATABASE IF EXISTS jv_industria;

CREATE DATABASE jv_industria CHARACTER
SET
    utf8mb4 COLLATE utf8mb4_unicode_ci;

USE jv_industria;

SET
    NAMES utf8mb4;

CREATE TABLE
    cliente (
        id_cliente INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(150) NOT NULL,
        documento VARCHAR(20) NOT NULL,
        endereco VARCHAR(255),
        telefone VARCHAR(20),
        email VARCHAR(254) NOT NULL,
        UNIQUE (documento, email)
    );

CREATE TABLE
    pedido (
        id_pedido INT PRIMARY KEY AUTO_INCREMENT,
        id_cliente INT,
        valor_total DECIMAL(10, 2) NOT NULL,
        tipo_pagamento ENUM ('pix', 'debito', 'credito', 'dinheiro') NOT NULL,
        endereco_entrega VARCHAR(255) DEFAULT 'retirada',
        status ENUM (
            'em espera',
            'entregue',
            'em produção',
            'validando',
            'enviando'
        ) NOT NULL DEFAULT 'em espera',
        data_emissao DATETIME NOT NULL,
        data_prevista DATE NOT NULL,
        data_saida DATETIME,
        taxa_entrega DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
        data_cancelamento DATETIME
    );

CREATE TABLE
    nota_fiscal (
        id_nota INT PRIMARY KEY AUTO_INCREMENT,
        id_pedido INT NOT NULL,
        data_emissao DATETIME NOT NULL,
        status_nota BOOLEAN NOT NULL,
        UNIQUE (id_pedido)
    );

CREATE TABLE
    produto (
        id_produto INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(150) NOT NULL,
        descricao VARCHAR(500) NOT NULL,
        valor_unitario DECIMAL(10, 2),
        quantidade_minima INT NOT NULL DEFAULT 0
    );

CREATE TABLE
    lote (
        id_lote INT PRIMARY KEY AUTO_INCREMENT,
        id_produto INT NOT NULL,
        id_estoque INT NOT NULL,
        id_pedido INT NOT NULL,
        data_validade DATE,
        quantidade_produto INT NOT NULL,
        data_fabricacao DATETIME,
        valor_lote DECIMAL(10, 2)
    );

CREATE TABLE
    formula (
        id_formula INT PRIMARY KEY AUTO_INCREMENT,
        id_produto INT NOT NULL,
        versao VARCHAR(20) NOT NULL,
        status INT NOT NULL,
        data_inicio DATE NOT NULL,
        data_fim DATE,
        UNIQUE (versao)
    );

CREATE TABLE
    maquina (
        id_maquina INT PRIMARY KEY AUTO_INCREMENT,
        status ENUM ('ativa', 'em manutenção', 'inativa') NOT NULL DEFAULT 'ativa',
        tipo VARCHAR(50) NOT NULL,
        capacidade_max INT
    );

CREATE TABLE
    materia_prima (
        id_materia INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(150) NOT NULL,
        descricao VARCHAR(500) NOT NULL,
        quantidade INT NOT NULL DEFAULT 1
    );

CREATE TABLE
    fornecedor (
        id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
        nome VARCHAR(150) NOT NULL,
        descricao VARCHAR(500),
        cnpj VARCHAR(18) NOT NULL,
        UNIQUE (cnpj)
    );

CREATE TABLE
    estoque (
        id_estoque INT PRIMARY KEY AUTO_INCREMENT,
        localizacao VARCHAR(150) NOT NULL,
        capacidade_max INT NOT NULL
    );

CREATE TABLE
    entrega (
        id_entrega INT PRIMARY KEY AUTO_INCREMENT,
        data_entrega DATETIME NOT NULL,
        codigo_rastreio VARCHAR(50) NOT NULL,
        id_pedido INT,
        id_veiculo INT,
        UNIQUE (codigo_rastreio)
    );

CREATE TABLE
    veiculo (
        id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
        placa VARCHAR(7) NOT NULL,
        modelo VARCHAR(100) NOT NULL,
        UNIQUE (placa)
    );

CREATE TABLE
    producao (
        id_producao INT PRIMARY KEY AUTO_INCREMENT,
        id_pedido INT,
        id_produto INT NOT NULL,
        quantidade INT NOT NULL
    );

CREATE TABLE
    movimento_estoque (
        id_movimento INT PRIMARY KEY AUTO_INCREMENT,
        id_estoque INT NOT NULL,
        quantidade INT NOT NULL,
        motivo VARCHAR(255) NOT NULL,
        data DATETIME NOT NULL,
        tipo VARCHAR(50)
    );

CREATE TABLE
    comprar_materia (
        id_comprar INT PRIMARY KEY AUTO_INCREMENT,
        id_materia INT NOT NULL,
        id_fornecedor INT NOT NULL,
        valor DECIMAL(10, 2) NOT NULL,
        comprovante_link VARCHAR(2048) NOT NULL,
        UNIQUE (id_comprar)
    );

CREATE TABLE
    formula_materia (
        id_formula_materia INT PRIMARY KEY AUTO_INCREMENT,
        id_formula INT NOT NULL,
        id_materia INT NOT NULL,
        quantidade FLOAT NOT NULL,
        unidade_medida VARCHAR(20) NOT NULL,
        ordem INT NOT NULL
    );

CREATE TABLE
    formula_maquina (
        id_formula_maquina INT PRIMARY KEY,
        id_formula INT NOT NULL,
        id_maquina INT NOT NULL
    );

CREATE TABLE
    parada_manutencao (
        id_parada INT PRIMARY KEY AUTO_INCREMENT,
        id_maquina INT NOT NULL,
        data DATETIME NOT NULL,
        descricao VARCHAR(500) NOT NULL,
        status VARCHAR(30) NOT NULL
    );

CREATE TABLE
    embalagem (
        id_embalagem INT PRIMARY KEY AUTO_INCREMENT,
        id_produto INT NOT NULL,
        status VARCHAR(30) NOT NULL,
        tipo VARCHAR(50) NOT NULL,
        altura DECIMAL(8, 3) NOT NULL,
        largura DECIMAL(8, 3) NOT NULL,
        profundidade DECIMAL(8, 3) NOT NULL,
        unidade_medida VARCHAR(20) NOT NULL
    );

ALTER TABLE pedido ADD FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente);

ALTER TABLE nota_fiscal ADD FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido);

ALTER TABLE lote ADD FOREIGN KEY (id_produto) REFERENCES produto (id_produto);

ALTER TABLE lote ADD FOREIGN KEY (id_estoque) REFERENCES estoque (id_estoque);

ALTER TABLE lote ADD FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido);

ALTER TABLE formula ADD FOREIGN KEY (id_produto) REFERENCES produto (id_produto);

ALTER TABLE entrega ADD FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido);

ALTER TABLE entrega ADD FOREIGN KEY (id_veiculo) REFERENCES veiculo (id_veiculo);

ALTER TABLE producao ADD FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido);

ALTER TABLE producao ADD FOREIGN KEY (id_produto) REFERENCES produto (id_produto);

ALTER TABLE movimento_estoque ADD FOREIGN KEY (id_estoque) REFERENCES estoque (id_estoque);

ALTER TABLE comprar_materia ADD FOREIGN KEY (id_materia) REFERENCES materia_prima (id_materia);

ALTER TABLE comprar_materia ADD FOREIGN KEY (id_fornecedor) REFERENCES fornecedor (id_fornecedor);

ALTER TABLE formula_materia ADD FOREIGN KEY (id_formula) REFERENCES formula (id_formula);

ALTER TABLE formula_materia ADD FOREIGN KEY (id_materia) REFERENCES materia_prima (id_materia);

ALTER TABLE formula_maquina ADD FOREIGN KEY (id_formula) REFERENCES formula (id_formula);

ALTER TABLE formula_maquina ADD FOREIGN KEY (id_maquina) REFERENCES maquina (id_maquina);

ALTER TABLE parada_manutencao ADD FOREIGN KEY (id_maquina) REFERENCES maquina (id_maquina);

ALTER TABLE embalagem ADD FOREIGN KEY (id_produto) REFERENCES produto (id_produto);

-- =====================================================================
-- 5. SELECT com JOIN
-- =====================================================================
-- S01 — Itens dos 20 pedidos mais recentes, com cliente e produto
SELECT
    p.id_pedido,
    p.data_emissao,
    c.nome AS cliente,
    pr.nome AS produto,
    pd.quantidade,
    pr.valor_unitario AS preco_praticado,
    (pd.quantidade * pr.valor_unitario) AS subtotal
FROM
    pedido p
    JOIN cliente c ON c.id_cliente = p.id_cliente
    JOIN producao pd ON pd.id_pedido = p.id_pedido
    JOIN produto pr ON pr.id_produto = pd.id_produto
ORDER BY
    p.data_emissao DESC,
    p.id_pedido,
    pr.nome
LIMIT
    20;

-- S02 — Rastreio dos pedidos expedidos: nota fiscal, entrega e veículo
SELECT
    p.id_pedido,
    p.status,
    p.data_saida,
    nf.id_nota,
    nf.status_nota,
    e.codigo_rastreio,
    e.data_entrega,
    v.placa
FROM
    pedido p
    LEFT JOIN nota_fiscal nf ON nf.id_pedido = p.id_pedido
    LEFT JOIN entrega e ON e.id_pedido = p.id_pedido
    LEFT JOIN veiculo v ON v.id_veiculo = e.id_veiculo
WHERE
    p.status IN ('enviando', 'entregue')
ORDER BY
    p.data_saida DESC
LIMIT
    15;

-- S03 — Receita de cada produto: fórmula vigente e matérias-primas, em ordem de adição
SELECT
    pr.nome AS produto,
    f.versao,
    fm.ordem,
    mp.nome AS materia_prima,
    fm.quantidade,
    fm.unidade_medida
FROM
    formula f
    JOIN produto pr ON pr.id_produto = f.id_produto
    JOIN formula_materia fm ON fm.id_formula = f.id_formula
    JOIN materia_prima mp ON mp.id_materia = fm.id_materia
WHERE
    f.status = 1
ORDER BY
    pr.id_produto,
    fm.ordem;

-- S04 — Lotes de produto acabado e onde estão guardados
SELECT
    l.id_lote,
    pr.nome AS produto,
    es.localizacao,
    l.quantidade_produto,
    l.data_fabricacao,
    l.data_validade
FROM
    lote l
    JOIN produto pr ON pr.id_produto = l.id_produto
    JOIN estoque es ON es.id_estoque = l.id_estoque
ORDER BY
    pr.id_produto,
    l.data_fabricacao;

-- S05 — Compras de matéria-prima com fornecedor
-- (comprar_materia não possui data_compra nem quantidade; ordena pelo id)
SELECT
    cm.id_comprar,
    mp.nome AS materia_prima,
    fo.nome AS fornecedor,
    cm.valor,
    cm.comprovante_link
FROM
    comprar_materia cm
    JOIN materia_prima mp ON mp.id_materia = cm.id_materia
    JOIN fornecedor fo ON fo.id_fornecedor = cm.id_fornecedor
ORDER BY
    cm.id_comprar DESC
LIMIT
    15;

-- =====================================================================
-- 6. UPDATE e DELETE
-- =====================================================================
-- U01 — Reajuste de 5% no valor unitário da linha Rejuntei
-- (produto não possui coluna "linha"; identifica pelo nome)
UPDATE produto
SET
    valor_unitario = ROUND(valor_unitario * 1.05, 2)
WHERE
    nome LIKE 'Rejuntei%';

-- U02 — Manutenção da envasadora começou: parada em andamento e máquina em manutenção
UPDATE parada_manutencao
SET
    status = 'em andamento'
WHERE
    id_parada = 11;

UPDATE maquina
SET
    status = 'em manutenção'
WHERE
    id_maquina = 5;

-- U03 — Pedido em espera entra na fila de produção
UPDATE pedido
SET
    status = 'em produção'
WHERE
    id_pedido = 31
    AND status = 'em espera';

-- U04 — Chegada de dispersante: soma 100 ao saldo da matéria-prima
UPDATE materia_prima
SET
    quantidade = quantidade + 100
WHERE
    id_materia = 6;

-- D01 — Exclui o cadastro duplicado de cliente (só se não tiver nenhum pedido)
DELETE FROM cliente
WHERE
    id_cliente = 31
    AND NOT EXISTS (
        SELECT
            1
        FROM
            pedido
        WHERE
            pedido.id_cliente = cliente.id_cliente
    );

-- D02 — Remove do cadastro as embalagens descontinuadas
DELETE FROM embalagem
WHERE
    status = 'descontinuada';

-- =====================================================================
-- 7. CONSULTAS GERENCIAIS (G) E DE AUDITORIA (A)
-- =====================================================================
-- ---------------------------------------------------------------------
-- GERENCIAIS
-- ---------------------------------------------------------------------
-- G01 — Faturamento, número de pedidos e ticket médio por mês
SELECT
    DATE_FORMAT (p.data_emissao, '%Y-%m') AS mes,
    COUNT(*) AS qtd_pedidos,
    SUM(p.valor_total) AS faturamento,
    ROUND(AVG(p.valor_total), 2) AS ticket_medio
FROM
    pedido p
WHERE
    p.data_cancelamento IS NULL
GROUP BY
    DATE_FORMAT (p.data_emissao, '%Y-%m')
ORDER BY
    mes;

-- G02 — Os 5 clientes que mais compraram
SELECT
    c.id_cliente,
    c.nome,
    c.email,
    COUNT(p.id_pedido) AS qtd_pedidos,
    SUM(p.valor_total) AS receita
FROM
    cliente c
    JOIN pedido p ON p.id_cliente = c.id_cliente
WHERE
    p.data_cancelamento IS NULL
GROUP BY
    c.id_cliente,
    c.nome,
    c.email
ORDER BY
    receita DESC
LIMIT
    5;

-- G03 — Produtos abaixo do estoque mínimo (lotes vencidos não contam)
SELECT
    pr.id_produto,
    pr.nome,
    pr.quantidade_minima,
    COALESCE(SUM(l.quantidade_produto), 0) AS saldo_disponivel,
    pr.quantidade_minima - COALESCE(SUM(l.quantidade_produto), 0) AS falta
FROM
    produto pr
    LEFT JOIN lote l ON l.id_produto = pr.id_produto
    AND (
        l.data_validade IS NULL
        OR l.data_validade >= CURDATE ()
    )
GROUP BY
    pr.id_produto,
    pr.nome,
    pr.quantidade_minima
HAVING
    COALESCE(SUM(l.quantidade_produto), 0) < pr.quantidade_minima
ORDER BY
    falta DESC;

-- G04 — Matérias-primas com menor saldo e último fornecedor
-- (materia_prima não possui quantidade_minima; lista as 10 de menor saldo.
--  O "último" fornecedor é o de maior id_comprar, pois não há data_compra)
SELECT
    mp.id_materia,
    mp.nome,
    mp.quantidade,
    (
        SELECT
            fo.nome
        FROM
            comprar_materia cm
            JOIN fornecedor fo ON fo.id_fornecedor = cm.id_fornecedor
        WHERE
            cm.id_materia = mp.id_materia
        ORDER BY
            cm.id_comprar DESC
        LIMIT
            1
    ) AS ultimo_fornecedor
FROM
    materia_prima mp
ORDER BY
    mp.quantidade ASC
LIMIT
    10;

-- G05 — Dias médios entre a emissão do pedido e a saída da fábrica, por mês
SELECT
    DATE_FORMAT (p.data_emissao, '%Y-%m') AS mes,
    COUNT(*) AS pedidos_expedidos,
    ROUND(
        AVG(
            TIMESTAMPDIFF (HOUR, p.data_emissao, p.data_saida)
        ) / 24,
        1
    ) AS dias_medios_ate_saida
FROM
    pedido p
WHERE
    p.data_saida IS NOT NULL
GROUP BY
    DATE_FORMAT (p.data_emissao, '%Y-%m')
ORDER BY
    mes;

-- G06 — Percentual de pedidos entregues dentro do prazo, por mês
SELECT
    DATE_FORMAT (p.data_emissao, '%Y-%m') AS mes,
    COUNT(*) AS entregas,
    SUM(
        CASE
            WHEN DATE (e.data_entrega) <= p.data_prevista THEN 1
            ELSE 0
        END
    ) AS no_prazo,
    ROUND(
        100 * SUM(
            CASE
                WHEN DATE (e.data_entrega) <= p.data_prevista THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS pct_no_prazo
FROM
    pedido p
    JOIN entrega e ON e.id_pedido = p.id_pedido
WHERE
    p.status = 'entregue'
GROUP BY
    DATE_FORMAT (p.data_emissao, '%Y-%m')
ORDER BY
    mes;

-- G07 — Taxa de cancelamento de pedidos por mês
SELECT
    DATE_FORMAT (p.data_emissao, '%Y-%m') AS mes,
    COUNT(*) AS pedidos,
    SUM(
        CASE
            WHEN p.data_cancelamento IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS cancelados,
    ROUND(
        100 * SUM(
            CASE
                WHEN p.data_cancelamento IS NOT NULL THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS pct_cancelamento
FROM
    pedido p
GROUP BY
    DATE_FORMAT (p.data_emissao, '%Y-%m')
ORDER BY
    mes;

-- G08 — Quanto cada produto vendeu por tipo de pagamento
-- (não existem "linha" nem "canal"; usa produto e tipo_pagamento)
SELECT
    pr.nome AS produto,
    p.tipo_pagamento,
    SUM(pd.quantidade) AS unidades,
    SUM(pd.quantidade * pr.valor_unitario) AS receita_itens
FROM
    producao pd
    JOIN pedido p ON p.id_pedido = pd.id_pedido
    JOIN produto pr ON pr.id_produto = pd.id_produto
WHERE
    p.data_cancelamento IS NULL
GROUP BY
    pr.id_produto,
    pr.nome,
    p.tipo_pagamento
ORDER BY
    pr.nome,
    receita_itens DESC;

-- G09 — Quantidade de paradas por máquina
-- (parada_manutencao não possui data_fim; não é possível calcular horas)
SELECT
    m.id_maquina,
    m.tipo,
    m.status,
    COUNT(pm.id_parada) AS qtd_paradas,
    SUM(
        CASE
            WHEN pm.status = 'em andamento' THEN 1
            ELSE 0
        END
    ) AS paradas_em_andamento,
    MAX(pm.data) AS ultima_parada
FROM
    maquina m
    LEFT JOIN parada_manutencao pm ON pm.id_maquina = m.id_maquina
GROUP BY
    m.id_maquina,
    m.tipo,
    m.status
ORDER BY
    qtd_paradas DESC;

-- G10 — Produção por produto e máquinas homologadas para a fórmula vigente
-- (producao não registra a máquina usada; o vínculo é feito via formula_maquina)
SELECT
    pr.id_produto,
    pr.nome AS produto,
    COUNT(DISTINCT pd.id_producao) AS ordens,
    SUM(pd.quantidade) AS unidades,
    (
        SELECT
            GROUP_CONCAT (
                DISTINCT m.tipo
                ORDER BY
                    m.tipo SEPARATOR ', '
            )
        FROM
            formula f
            JOIN formula_maquina fm ON fm.id_formula = f.id_formula
            JOIN maquina m ON m.id_maquina = fm.id_maquina
        WHERE
            f.id_produto = pr.id_produto
            AND f.status = 1
    ) AS maquinas_homologadas
FROM
    producao pd
    JOIN produto pr ON pr.id_produto = pd.id_produto
GROUP BY
    pr.id_produto,
    pr.nome
ORDER BY
    unidades DESC;

-- G11 — Quanto foi gasto com cada fornecedor
SELECT
    fo.id_fornecedor,
    fo.nome,
    COUNT(cm.id_comprar) AS qtd_compras,
    COALESCE(SUM(cm.valor), 0) AS total_gasto
FROM
    fornecedor fo
    LEFT JOIN comprar_materia cm ON cm.id_fornecedor = fo.id_fornecedor
GROUP BY
    fo.id_fornecedor,
    fo.nome
ORDER BY
    total_gasto DESC;

-- G12 — Clientes cadastrados que nunca fizeram um pedido
SELECT
    c.id_cliente,
    c.nome,
    c.documento,
    c.email
FROM
    cliente c
    LEFT JOIN pedido p ON p.id_cliente = c.id_cliente
WHERE
    p.id_pedido IS NULL
ORDER BY
    c.nome;

-- G13 — Movimentação líquida de estoque por local de armazenamento
-- (movimento_estoque referencia id_estoque, não id_lote)
SELECT
    es.id_estoque,
    es.localizacao,
    SUM(
        CASE
            WHEN me.tipo = 'entrada' THEN me.quantidade
            ELSE 0
        END
    ) AS entradas,
    SUM(
        CASE
            WHEN me.tipo IN ('saida', 'ajuste') THEN me.quantidade
            ELSE 0
        END
    ) AS saidas_e_ajustes,
    SUM(
        CASE
            WHEN me.tipo = 'entrada' THEN me.quantidade
            ELSE - me.quantidade
        END
    ) AS saldo_liquido
FROM
    movimento_estoque me
    JOIN estoque es ON es.id_estoque = me.id_estoque
GROUP BY
    es.id_estoque,
    es.localizacao
ORDER BY
    saldo_liquido;

-- ---------------------------------------------------------------------
-- AUDITORIA (devolvem as linhas que violam as regras)
-- ---------------------------------------------------------------------
-- A01 — Pedido enviado ou entregue sem nota fiscal (RN06)
SELECT
    p.id_pedido,
    p.status,
    p.data_saida,
    p.valor_total
FROM
    pedido p
    LEFT JOIN nota_fiscal nf ON nf.id_pedido = p.id_pedido
WHERE
    p.status IN ('enviando', 'entregue')
    AND nf.id_nota IS NULL
ORDER BY
    p.id_pedido;

-- A02 — Pedido sem nenhum item (RN04)
SELECT
    p.id_pedido,
    p.status,
    p.data_emissao,
    p.valor_total
FROM
    pedido p
    LEFT JOIN producao pd ON pd.id_pedido = p.id_pedido
WHERE
    pd.id_producao IS NULL
ORDER BY
    p.id_pedido;

-- A03 — Pedido cujo valor total difere da soma dos itens mais a taxa de entrega (RN05)
SELECT
    p.id_pedido,
    p.valor_total,
    ROUND(
        SUM(pd.quantidade * pr.valor_unitario) + p.taxa_entrega,
        2
    ) AS valor_calculado,
    ROUND(
        p.valor_total - (
            SUM(pd.quantidade * pr.valor_unitario) + p.taxa_entrega
        ),
        2
    ) AS diferenca
FROM
    pedido p
    JOIN producao pd ON pd.id_pedido = p.id_pedido
    JOIN produto pr ON pr.id_produto = pd.id_produto
GROUP BY
    p.id_pedido,
    p.valor_total,
    p.taxa_entrega
HAVING
    ABS(
        p.valor_total - (
            SUM(pd.quantidade * pr.valor_unitario) + p.taxa_entrega
        )
    ) > 0.01
ORDER BY
    p.id_pedido;

-- A04 — Lote vencido ainda com saldo em estoque (RN07)
SELECT
    l.id_lote,
    pr.nome AS produto,
    es.localizacao,
    l.data_validade,
    l.quantidade_produto
FROM
    lote l
    JOIN produto pr ON pr.id_produto = l.id_produto
    JOIN estoque es ON es.id_estoque = l.id_estoque
WHERE
    l.data_validade < CURDATE ()
    AND l.quantidade_produto > 0
ORDER BY
    l.data_validade;

-- A05 — Produção de produto cuja fórmula vigente não tem máquina ativa homologada (RN08)
-- (producao não registra máquina nem fórmula; a verificação é feita pelo produto)
SELECT
    pd.id_producao,
    pr.nome AS produto,
    f.versao
FROM
    producao pd
    JOIN produto pr ON pr.id_produto = pd.id_produto
    LEFT JOIN formula f ON f.id_produto = pd.id_produto
    AND f.status = 1
    LEFT JOIN formula_maquina fm ON fm.id_formula = f.id_formula
    LEFT JOIN maquina m ON m.id_maquina = fm.id_maquina
    AND m.status = 'ativa'
GROUP BY
    pd.id_producao,
    pr.nome,
    f.versao
HAVING
    COUNT(m.id_maquina) = 0
ORDER BY
    pd.id_producao;

-- A06 — Produto sem fórmula vigente (RN09)
SELECT
    pr.id_produto,
    pr.nome
FROM
    produto pr
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            formula f
        WHERE
            f.id_produto = pr.id_produto
            AND f.status = 1
    )
ORDER BY
    pr.id_produto;

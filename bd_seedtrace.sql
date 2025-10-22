-- =============================================
-- BANCO DE DADOS: PLATAFORMA SEEDTRACE
-- =============================================

-- Criar banco de dados
DROP DATABASE IF EXISTS seedtrace_db;
CREATE DATABASE seedtrace_db;
USE seedtrace_db;

-- =============================================
-- TABELAS PRINCIPAIS
-- =============================================

-- Tabela FUNCIONARIO
CREATE TABLE FUNCIONARIO (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    senha VARCHAR(255) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Tabela AGRICULTOR
CREATE TABLE AGRICULTOR (
    id_agricultor INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    municipio VARCHAR(50) NOT NULL,
    endereco VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Tabela FORNECEDOR
CREATE TABLE FORNECEDOR (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    endereco VARCHAR(200),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela LOTE_SEMENTE
CREATE TABLE LOTE_SEMENTE (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT NOT NULL,
    tipo_semente VARCHAR(50) NOT NULL,
    variedade VARCHAR(50) NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    data_compra DATE NOT NULL,
    numero_nota VARCHAR(50) NOT NULL,
    validade DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_fornecedor) REFERENCES FORNECEDOR(id_fornecedor)
);

-- Tabela ARMAZEM
CREATE TABLE ARMAZEM (
    id_armazem INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    localizacao VARCHAR(100) NOT NULL,
    capacidade DECIMAL(10,2) NOT NULL,
    responsavel VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- =============================================
-- TABELAS DE RELACIONAMENTO E OPERAÇÕES
-- =============================================

-- Tabela ESTOQUE
CREATE TABLE ESTOQUE (
    id_estoque INT AUTO_INCREMENT PRIMARY KEY,
    id_lote INT NOT NULL,
    id_armazem INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_lote) REFERENCES LOTE_SEMENTE(id_lote),
    FOREIGN KEY (id_armazem) REFERENCES ARMAZEM(id_armazem)
);

-- Tabela ENTREGA
CREATE TABLE ENTREGA (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_agricultor INT NOT NULL,
    id_funcionario INT NOT NULL,
    id_lote INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    data_planejada DATE NOT NULL,
    data_entrega DATE,
    status ENUM('AGUARDANDO', 'A_CAMINHO', 'ENTREGUE', 'CANCELADA') DEFAULT 'AGUARDANDO',
    assinatura TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_agricultor) REFERENCES AGRICULTOR(id_agricultor),
    FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_funcionario),
    FOREIGN KEY (id_lote) REFERENCES LOTE_SEMENTE(id_lote)
);

-- Tabela RASTREIO_ENTREGA
CREATE TABLE RASTREIO_ENTREGA (
    id_rastreio INT AUTO_INCREMENT PRIMARY KEY,
    id_entrega INT NOT NULL,
    localizacao VARCHAR(100) NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL,
    observacao VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_entrega) REFERENCES ENTREGA(id_entrega)
);

-- Tabela MOVIMENTACAO
CREATE TABLE MOVIMENTACAO (
    id_movimentacao INT AUTO_INCREMENT PRIMARY KEY,
    id_estoque INT NOT NULL,
    tipo ENUM('ENTRADA', 'SAIDA', 'AJUSTE') NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    data_movimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_estoque) REFERENCES ESTOQUE(id_estoque)
);

-- =============================================
-- TABELAS DE AUDITORIA E RELATÓRIOS
-- =============================================

-- Tabela LOG_ACESSO
CREATE TABLE LOG_ACESSO (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo_usuario ENUM('FUNCIONARIO', 'AGRICULTOR') NOT NULL,
    data_acesso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip VARCHAR(45) NOT NULL,
    acao VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela RELATORIO
CREATE TABLE RELATORIO (
    id_relatorio INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    parametros JSON,
    arquivo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_funcionario INT NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_funcionario)
);

-- Tabela ALERTA_ESTOQUE
CREATE TABLE ALERTA_ESTOQUE (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    id_estoque INT NOT NULL,
    tipo ENUM('ESTOQUE_BAIXO', 'VALIDADE_PROXIMA', 'ESTOQUE_ZERADO') NOT NULL,
    nivel ENUM('BAIXO', 'MEDIO', 'ALTO') NOT NULL,
    mensagem VARCHAR(200) NOT NULL,
    data_alerta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_resolvido BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_estoque) REFERENCES ESTOQUE(id_estoque)
);

-- =============================================
-- ÍNDICES PARA MELHOR PERFORMANCE
-- =============================================

-- Índices para FUNCIONARIO
CREATE INDEX idx_funcionario_cpf ON FUNCIONARIO(cpf);
CREATE INDEX idx_funcionario_email ON FUNCIONARIO(email);

-- Índices para AGRICULTOR
CREATE INDEX idx_agricultor_cpf ON AGRICULTOR(cpf);
CREATE INDEX idx_agricultor_municipio ON AGRICULTOR(municipio);
CREATE INDEX idx_agricultor_data_nascimento ON AGRICULTOR(data_nascimento);

-- Índices para FORNECEDOR
CREATE INDEX idx_fornecedor_cnpj ON FORNECEDOR(cnpj);

-- Índices para LOTE_SEMENTE
CREATE INDEX idx_lote_tipo_semente ON LOTE_SEMENTE(tipo_semente);
CREATE INDEX idx_lote_validade ON LOTE_SEMENTE(validade);
CREATE INDEX idx_lote_fornecedor ON LOTE_SEMENTE(id_fornecedor);

-- Índices para ESTOQUE
CREATE INDEX idx_estoque_lote_armazem ON ESTOQUE(id_lote, id_armazem);
CREATE INDEX idx_estoque_quantidade ON ESTOQUE(quantidade);

-- Índices para ENTREGA
CREATE INDEX idx_entrega_status ON ENTREGA(status);
CREATE INDEX idx_entrega_data_planejada ON ENTREGA(data_planejada);
CREATE INDEX idx_entrega_agricultor ON ENTREGA(id_agricultor);
CREATE INDEX idx_entrega_funcionario ON ENTREGA(id_funcionario);

-- Índices para RASTREIO_ENTREGA
CREATE INDEX idx_rastreio_entrega_data ON RASTREIO_ENTREGA(id_entrega, data_hora);

-- Índices para MOVIMENTACAO
CREATE INDEX idx_movimentacao_tipo_data ON MOVIMENTACAO(tipo, data_movimento);

-- Índices para LOG_ACESSO
CREATE INDEX idx_log_usuario_data ON LOG_ACESSO(id_usuario, data_acesso);
CREATE INDEX idx_log_tipo_usuario ON LOG_ACESSO(tipo_usuario);

-- Índices para RELATORIO
CREATE INDEX idx_relatorio_tipo_data ON RELATORIO(tipo, data_inicio);

-- Índices para ALERTA_ESTOQUE
CREATE INDEX idx_alerta_tipo_resolvido ON ALERTA_ESTOQUE(tipo, is_resolvido);

-- =============================================
-- STORED PROCEDURES E TRIGGERS
-- =============================================

DELIMITER //

-- Procedure para verificar saldo não negativo
CREATE PROCEDURE VerificarSaldoEstoque(
    IN p_id_estoque INT,
    IN p_quantidade DECIMAL(10,2),
    OUT p_saldo_suficiente BOOLEAN
)
BEGIN
    DECLARE saldo_atual DECIMAL(10,2);
    
    SELECT quantidade INTO saldo_atual
    FROM ESTOQUE
    WHERE id_estoque = p_id_estoque;
    
    IF saldo_atual >= p_quantidade THEN
        SET p_saldo_suficiente = TRUE;
    ELSE
        SET p_saldo_suficiente = FALSE;
    END IF;
END //

-- Trigger para atualizar estoque após movimentação
CREATE TRIGGER AfterMovimentacaoInsert
AFTER INSERT ON MOVIMENTACAO
FOR EACH ROW
BEGIN
    IF NEW.tipo = 'SAIDA' THEN
        UPDATE ESTOQUE 
        SET quantidade = quantidade - NEW.quantidade,
            updated_at = CURRENT_TIMESTAMP
        WHERE id_estoque = NEW.id_estoque;
    ELSE
        UPDATE ESTOQUE 
        SET quantidade = quantidade + NEW.quantidade,
            updated_at = CURRENT_TIMESTAMP
        WHERE id_estoque = NEW.id_estoque;
    END IF;
END //

-- Trigger para validar data de entrega
CREATE TRIGGER BeforeEntregaUpdate
BEFORE UPDATE ON ENTREGA
FOR EACH ROW
BEGIN
    IF NEW.data_entrega IS NOT NULL AND NEW.data_entrega < OLD.data_planejada THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data de entrega não pode ser anterior à data planejada';
    END IF;
    
    IF NEW.status = 'ENTREGUE' AND NEW.data_entrega IS NULL THEN
        SET NEW.data_entrega = CURRENT_DATE;
    END IF;
END //

-- Trigger para criar alerta de estoque baixo
CREATE TRIGGER AfterEstoqueUpdate
AFTER UPDATE ON ESTOQUE
FOR EACH ROW
BEGIN
    DECLARE estoque_minimo DECIMAL(10,2) DEFAULT 10.00;
    
    IF NEW.quantidade < estoque_minimo AND NEW.quantidade > 0 THEN
        INSERT INTO ALERTA_ESTOQUE (id_estoque, tipo, nivel, mensagem)
        VALUES (NEW.id_estoque, 'ESTOQUE_BAIXO', 'MEDIO', 
                CONCAT('Estoque baixo: ', NEW.quantidade, ' unidades restantes'));
                
    ELSEIF NEW.quantidade = 0 THEN
        INSERT INTO ALERTA_ESTOQUE (id_estoque, tipo, nivel, mensagem)
        VALUES (NEW.id_estoque, 'ESTOQUE_ZERADO', 'ALTO', 
                'Estoque zerado para este lote');
    END IF;
END //

-- Procedure para gerar relatório de estoque
CREATE PROCEDURE GerarRelatorioEstoque(
    IN p_data_inicio DATE,
    IN p_data_fim DATE
)
BEGIN
    SELECT 
        a.nome as armazem,
        ls.tipo_semente,
        ls.variedade,
        e.quantidade,
        ls.validade,
        DATEDIFF(ls.validade, CURDATE()) as dias_para_vencer
    FROM ESTOQUE e
    JOIN ARMAZEM a ON e.id_armazem = a.id_armazem
    JOIN LOTE_SEMENTE ls ON e.id_lote = ls.id_lote
    WHERE e.updated_at BETWEEN p_data_inicio AND p_data_fim
    ORDER BY a.nome, ls.tipo_semente;
END //

DELIMITER ;

-- =============================================
-- INSERÇÃO DE DADOS DE EXEMPLO (OPCIONAL)
-- =============================================

-- Inserir funcionários exemplo
INSERT INTO FUNCIONARIO (cpf, nome, email, telefone, senha, cargo) VALUES
('12345678901', 'Maria Luiza Andrade', 'maria.andrade@ipa.br', '81999998888', '$2y$10$ExampleHash123', 'Técnica Agrícola'),
('98765432100', 'João Silva Santos', 'joao.santos@ipa.br', '81988887777', '$2y$10$ExampleHash456', 'Coordenador');

-- Inserir agricultores exemplo
INSERT INTO AGRICULTOR (cpf, nome, data_nascimento, telefone, municipio, endereco) VALUES
('11122233344', 'João Ribeiro', '1980-05-15', '81977776666', 'Vitória de Santo Antão', 'Sítio São José, Zona Rural'),
('55566677788', 'Ana Maria Oliveira', '1975-12-20', '81966665555', 'Gravatá', 'Rua Principal, 123');

-- Inserir fornecedores exemplo
INSERT INTO FORNECEDOR (nome, cnpj, telefone, endereco, email) VALUES
('Sementes Nordeste Ltda', '12345678000195', '81333334444', 'Av. das Sementes, 1000 - Recife/PE', 'contato@sementesnordeste.com.br'),
('AgroSul Sementes', '98765432000110', '81322223333', 'Rua do Comércio, 500 - Caruaru/PE', 'vendas@agrosul.com.br');

-- =============================================
-- MENSAGEM DE CONFIRMAÇÃO
-- =============================================

SELECT 'Banco de dados SeedTrace criado com sucesso!' as Status;

-- Mostrar todas as tabelas criadas
SHOW TABLES; 

-- DICIONÁRIO DE DADOS

-- TABELA: FUNCIONARIO
-- id_funcionario (INT, PK, AI): Identificador do funcionário.
-- cpf (VARCHAR(11)): CPF do funcionário (11 dígitos). UNIQUE.
-- nome (VARCHAR(100)): Nome completo.
-- email (VARCHAR(100)): E-mail institucional. UNIQUE.
-- telefone (VARCHAR(15)): Telefone de contato.
-- senha (VARCHAR(255)): Senha armazenada (hash).
-- cargo (VARCHAR(50)): Cargo ou função no sistema.
-- created_at (TIMESTAMP): Data de criação do registro.
-- is_active (TINYINT(1)): Indicador de atividade (1 = ativo, 0 = inativo).

-- TABELA: AGRICULTOR
-- id_agricultor (INT, PK, AI): Identificador do agricultor.
-- cpf (VARCHAR(11)): CPF do agricultor (11 dígitos). UNIQUE.
-- nome (VARCHAR(100)): Nome completo.
-- data_nascimento (DATE): Data de nascimento.
-- telefone (VARCHAR(15)): Telefone de contato.
-- municipio (VARCHAR(50)): Município de atuação.
-- endereco (VARCHAR(200)): Endereço completo.
-- created_at (TIMESTAMP): Registro criado em.
-- is_active (TINYINT(1)): Indicador de atividade.

-- TABELA: FORNECEDOR
-- id_fornecedor (INT, PK, AI): Identificador do fornecedor.
-- nome (VARCHAR(100)): Nome do fornecedor.
-- cnpj (VARCHAR(14)): CNPJ (14 dígitos). UNIQUE.
-- telefone, endereco, email, created_at.

-- TABELA: LOTE_SEMENTE
-- id_lote (INT, PK, AI): Identificador do lote.
-- id_fornecedor (INT, FK): Fornecedor responsável pelo lote.
-- tipo_semente (VARCHAR(50)): Tipo (e.g., Milho, Feijão).
-- variedade (VARCHAR(50)): Variedade específica.
-- quantidade (DECIMAL(10,2)): Quantidade inicial no lote.
-- data_compra (DATE): Data da compra.
-- numero_nota (VARCHAR(50)): Número da nota fiscal.
-- validade (DATE): Data de validade do lote.
-- created_at, is_active.

-- TABELA: ARMAZEM
-- id_armazem (INT, PK, AI): Identificador do armazém.
-- nome (VARCHAR(50)), localizacao (VARCHAR(100)), capacidade (DECIMAL), responsavel.
-- created_at, is_active.

-- TABELA: ESTOQUE
-- id_estoque (INT, PK, AI).
-- id_lote (INT, FK) -> LOTE_SEMENTE.
-- id_armazem (INT, FK) -> ARMAZEM.
-- quantidade (DECIMAL(10,2)): Quantidade atual disponível.
-- created_at, updated_at.

-- TABELA: ENTREGA
-- id_entrega (INT, PK, AI).
-- id_agricultor (INT, FK) -> AGRICULTOR.
-- id_funcionario (INT, FK) -> FUNCIONARIO.
-- id_lote (INT, FK) -> LOTE_SEMENTE.
-- quantidade (DECIMAL): Quantidade a ser entregue.
-- data_planejada (DATE), data_entrega (DATE).
-- status (ENUM): AGUARDANDO, A_CAMINHO, ENTREGUE, CANCELADA.
-- assinatura (TEXT): assinatura ou comprovante.
-- created_at (TIMESTAMP).

-- TABELA: RASTREIO_ENTREGA
-- id_rastreio (INT, PK, AI).
-- id_entrega (INT, FK) -> ENTREGA.
-- localizacao (VARCHAR), data_hora (TIMESTAMP), status (VARCHAR), observacao (VARCHAR).

-- TABELA: MOVIMENTACAO
-- id_movimentacao (INT, PK, AI).
-- id_estoque (INT, FK) -> ESTOQUE.
-- tipo (ENUM): ENTRADA, SAIDA, AJUSTE.
-- quantidade (DECIMAL), data_movimento (TIMESTAMP), motivo (VARCHAR).

-- TABELA: LOG_ACESSO
-- id_log (INT, PK, AI).
-- id_usuario (INT): id do usuário (pode ser funcionario/agricultor conforme tipo_usuario).
-- tipo_usuario (ENUM): FUNCIONARIO, AGRICULTOR.
-- data_acesso (TIMESTAMP), ip (VARCHAR), acao (VARCHAR).

-- TABELA: RELATORIO
-- id_relatorio (INT, PK, AI).
-- tipo (VARCHAR): tipo de relatório.
-- data_inicio, data_fim.
-- parametros (JSON): parâmetros usados para gerar o relatório.
-- arquivo (VARCHAR): caminho/nome do arquivo gerado.
-- id_funcionario (FK) -> FUNCIONARIO.

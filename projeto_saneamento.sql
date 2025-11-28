-- ####################################################################
-- # PROJETO FÍSICO: SANEAMENTO CIDADE INTELIGENTE (POSTGRESQL)
-- ####################################################################


-- 1. CRIAÇÃO DAS TABELAS (CREATE TABLE)


CREATE TABLE Setor (
    IdSetor SERIAL PRIMARY KEY, 
    nome VARCHAR(50) NOT NULL,
    areaKm2 NUMERIC(8, 2)
);


CREATE TABLE Equipe (
    IdEquipe SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    especialidade VARCHAR(50),
    telefone_contato VARCHAR(15)
);


CREATE TABLE Tubulacao (
    IdTubulacao SERIAL PRIMARY KEY,
    material VARCHAR(30),
    diametro NUMERIC(5, 2),
    tipo_rede VARCHAR(15) NOT NULL,
    
    -- Chave Estrangeira
    IdSetor_FK INTEGER NOT NULL,
    FOREIGN KEY (IdSetor_FK) REFERENCES Setor(IdSetor)
);


CREATE TABLE Ponto_Monitoramento (
    IdPonto SERIAL PRIMARY KEY,
    latitude NUMERIC(10, 6) NOT NULL,
    longitude NUMERIC(10, 6) NOT NULL,
    tipo_ponto VARCHAR(40) NOT NULL,
    
    -- Chave Estrangeira
    IdTubulacao_FK INTEGER NOT NULL,
    FOREIGN KEY (IdTubulacao_FK) REFERENCES Tubulacao(IdTubulacao)
);


CREATE TABLE Sensor (
    IdSensor SERIAL PRIMARY KEY,
    tipo VARCHAR(30) NOT NULL,
    status VARCHAR(15) NOT NULL,
    data_instalacao DATE NOT NULL,
    
    -- Chave Estrangeira
    IdPonto_FK INTEGER NOT NULL,
    FOREIGN KEY (IdPonto_FK) REFERENCES Ponto_Monitoramento(IdPonto)
);


CREATE TABLE Leitura (
    IdLeitura SERIAL PRIMARY KEY,
    valor_lido NUMERIC(10, 3) NOT NULL,
    unidade_medida VARCHAR(10) NOT NULL,
    "timestamp" TIMESTAMP NOT NULL, 
    
    -- Chave Estrangeira
    IdSensor_FK INTEGER NOT NULL,
    FOREIGN KEY (IdSensor_FK) REFERENCES Sensor(IdSensor)
);


CREATE TABLE Ocorrencia (
    IdOcorrencia SERIAL PRIMARY KEY,
    data_registro DATE NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    prioridade VARCHAR(10) NOT NULL,
    status VARCHAR(20) NOT NULL,
    
    -- Chave Estrangeira OBRIGATÓRIA
    IdPonto_FK INTEGER NOT NULL,
    FOREIGN KEY (IdPonto_FK) REFERENCES Ponto_Monitoramento(IdPonto),
    
    -- Chave Estrangeira OPCIONAL (pode ser NULL)
    IdEquipe_FK INTEGER, 
    FOREIGN KEY (IdEquipe_FK) REFERENCES Equipe(IdEquipe)
);


-- ####################################################################
-- 2. POPULAÇÃO DO BANCO (INSERT INTO)
-- ####################################################################


-- Inserir SETOR
INSERT INTO Setor (nome, areaKm2) VALUES
('Setor Central Alpha', 45.50),
('Setor Oeste Beta', 62.75);


-- Inserir EQUIPE
INSERT INTO Equipe (nome, especialidade, telefone_contato) VALUES
('Equipe Reparo Rápido', 'Reparo de Vazamentos', '98765-4321'),
('Equipe Monitoramento', 'Instalação de Sensores', '98123-4567');


-- Inserir TUBULACAO
INSERT INTO Tubulacao (material, diametro, tipo_rede, IdSetor_FK) VALUES
('PVC', 30.00, 'Água', 1),
('Ferro Fundido', 50.50, 'Esgoto', 2);


-- Inserir PONTO_MONITORAMENTO
INSERT INTO Ponto_Monitoramento (latitude, longitude, tipo_ponto, IdTubulacao_FK) VALUES
( -15.8267, -47.9218, 'Hidrômetro Digital', 1),
( -15.8300, -47.9250, 'Poço de Visita', 2);


-- Inserir SENSOR
INSERT INTO Sensor (tipo, status, data_instalacao, IdPonto_FK) VALUES
('Vazão Ultrassônica', 'Ativo', '2025-10-01', 1),
('Pressão Manométrica', 'Ativo', '2025-10-15', 2);


-- Inserir LEITURA
INSERT INTO Leitura (valor_lido, unidade_medida, "timestamp", IdSensor_FK) VALUES
(25.340, 'm3/h', '2025-11-12 09:00:00', 1),
(150.5, 'PSI', '2025-11-12 09:05:00', 2);


-- Inserir OCORRENCIA (Dados iniciais de amostra)
INSERT INTO Ocorrencia (data_registro, tipo, prioridade, status, IdPonto_FK, IdEquipe_FK) VALUES
('2025-11-11', 'Alto Consumo (Vazamento)', 'Alta', 'Aberta', 1, 1), -- Ocorrência 1 (Atribuída à Equipe 1)
('2025-11-12', 'Baixa Pressão', 'Média', 'Aberta', 2, NULL); -- Ocorrência 2 (Ainda sem equipe)


-- ####################################################################
-- 3. MANIPULAÇÃO DE DADOS (ADD, UPDATE, DELETE)
-- ####################################################################


-- 1. ADICIONAR UMA NOVA LINHA (INSERT INTO)
-- Adicionar uma nova ocorrência (Entupimento, sem equipe ainda)
INSERT INTO Ocorrencia (data_registro, tipo, prioridade, status, IdPonto_FK, IdEquipe_FK)
VALUES ('2025-11-12', 'Entupimento', 'Alta', 'Aberta', 1, NULL);


-- 2. ATUALIZAR (UPDATE)
-- Atualizar Ocorrência 2: Mudar o status para 'Em Atendimento' e designar a Equipe 2
UPDATE Ocorrencia
SET status = 'Em Atendimento', IdEquipe_FK = 2
WHERE IdOcorrencia = 2;


-- 3. EXCLUIR (DELETE)
-- Excluir a Ocorrência que acabamos de adicionar (IdOcorrencia=3, assumindo a ordem de inserção)
DELETE FROM Ocorrencia
WHERE IdOcorrencia = 3;
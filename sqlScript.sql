-- MySQL Workbench Forward Engineering

drop database mydb;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`tipo_acao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tipo_acao (
  id_tipoAcao INT NOT NULL,
  Inserir TINYINT NULL,
  Deletar TINYINT NULL,
  Atualizar TINYINT NULL,
  PRIMARY KEY (id_tipoAcao)
);


-- -----------------------------------------------------
-- Table `mydb`.`tipo_usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tipo_usuario (
  id_tipo_usuario INT NOT NULL,
  nome VARCHAR(45) NULL,
  fk_tipoAcao INT NULL,
  PRIMARY KEY (id_tipo_usuario),
  CONSTRAINT fk_tipoAcao FOREIGN KEY (fk_tipoAcao) REFERENCES tipo_acao (id_tipoAcao)
);


-- -----------------------------------------------------
-- Table `mydb`.`endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS endereco (
  id_endereco INT AUTO_INCREMENT PRIMARY KEY,
  estado CHAR(2) NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  CEP CHAR(9) NOT NULL,
  rua VARCHAR(100) NOT NULL,
  data_atualizacao DATETIME NULL
);


-- -----------------------------------------------------
-- Table `mydb`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuario` (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nome_usuario VARCHAR(100) NOT NULL,
  CPF CHAR(11) NOT NULL,
  senha VARCHAR(200) NOT NULL,
  primeiro_nome VARCHAR(100) NULL,
  sobrenome VARCHAR(100) NULL,
  email VARCHAR(45) NOT NULL,
  imagem_perfil BLOB NULL,
  data_criacao DATETIME NOT NULL,
  deletado TINYINT NOT NULL,
  data_deletado DATETIME NULL,
  data_atualizacao DATETIME NULL,
  autenticado TINYINT,
  fk_endereco INT NULL,
  fk_tipo_usuario INT not null,
  UNIQUE INDEX uk_nome_usuario (nome_usuario),
  UNIQUE INDEX uk_email (email),
  CONSTRAINT fk_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco (id_endereco),
  CONSTRAINT fk_tipo_usuario FOREIGN KEY (fk_tipo_usuario) REFERENCES tipo_usuario (id_tipo_usuario)
);


-- -----------------------------------------------------
-- Table `mydb`.`referencia_gerar_pontuacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS referencia_gerar_pontuacao (
  id_referencia_gerar_pontuacao INT NOT NULL AUTO_INCREMENT,
  nome_da_geracao VARCHAR(45) NULL,
  descricao_da_geracao VARCHAR(45) NULL,
  PRIMARY KEY (id_referencia_gerar_pontuacao)
);


-- -----------------------------------------------------
-- Table `mydb`.`categoria_curso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS categoria_curso (
  id_categoria_curso INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(45) NULL
  );

-- -----------------------------------------------------
-- Table `mydb`.`curso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS curso (
  id_curso INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(45) NULL,
  qtd_horas INT NULL,
  fk_categoria_curso INT NOT NULL,
    FOREIGN KEY (fk_categoria_curso)
    REFERENCES `mydb`.`categoria_curso` (`id_categoria_curso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`modulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS modulo (
  id_modulo INT NOT NULL,
  fk_curso INT NOT NULL,
  qtd_atividade_total INT NOT NULL,
  nome_modulo VARCHAR(45) NULL,
  PRIMARY KEY (id_modulo, fk_curso),
  FOREIGN KEY (fk_curso)
    REFERENCES curso (id_curso)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


ALTER TABLE `mydb`.`modulo`
ADD UNIQUE INDEX `idx_modulo_fk_curso` (`id_modulo`, `fk_curso`);

-- -----------------------------------------------------
-- Table `mydb`.`atividade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`atividade` (
  id_atividade INT PRIMARY KEY AUTO_INCREMENT,
  nota INT NULL,
  temp_duracao TIME NULL,
  data_entrega DATE NULL,
  fk_modulo INT NOT NULL,
  fk_curso INT NOT NULL,
    FOREIGN KEY (`fk_modulo` , `fk_curso`)
    REFERENCES `mydb`.`modulo` (`id_modulo` , `fk_curso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE `mydb`.`atividade`
ADD INDEX `idx_atividade_fk_modulo_fk_curso` (`id_atividade`, `fk_modulo`, `fk_curso`);

-- -----------------------------------------------------
-- Table `mydb`.`ponto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ponto` (
  id_ponto INT PRIMARY KEY AUTO_INCREMENT,
  qtd_ponto INT NOT NULL,
  data_pontuacao DATE NOT NULL,
  fk_referencia_gerar_pontuacao INT NOT NULL,
  fk_atividade INT NOT NULL,
  fk_modulo INT NOT NULL,
  fk_curso INT NOT NULL,
  fk_usuario INT NOT NULL,
    FOREIGN KEY (`fk_referencia_gerar_pontuacao`)
    REFERENCES `mydb`.`referencia_gerar_pontuacao` (`id_referencia_gerar_pontuacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`fk_atividade` , `fk_modulo` , `fk_curso`)
    REFERENCES `mydb`.`atividade` (`id_atividade` , `fk_modulo` , `fk_curso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `mydb`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`redefinicao_senha`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS redefinicao_senha (
  id_redefinicao_senha INT AUTO_INCREMENT PRIMARY KEY,
  codigo_redefinicao VARCHAR(8) NULL,
  data_criacao DATETIME NULL,
  data_expiracao DATETIME NOT NULL,
  valido TINYINT NOT NULL,
  email_redefinicao VARCHAR(45) NOT NULL, 
  fk_usuario INT NOT NULL,
  CONSTRAINT fk_usuario FOREIGN KEY (fk_usuario) REFERENCES usuario (id_usuario)
);


-- -----------------------------------------------------
-- Table `mydb`.`inscricao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`inscricao` (
  fk_usuario INT NOT NULL AUTO_INCREMENT,
  fk_curso INT NOT NULL,
  codigo_inscricao VARCHAR(100) NULL,
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `mydb`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`fk_curso`)
    REFERENCES `mydb`.`curso` (`id_curso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-----------------------------------------------------
-- Table `mydb`.`dados_empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dados_empresa` (
  `id_empresa` INT AUTO_INCREMENT PRIMARY KEY,
  `nome_empresa` VARCHAR(45) NULL,
  `setor_industria` VARCHAR(45) NULL,
  `cargo_usuario` VARCHAR(45) NULL,
   cnpj VARCHAR(14) not null,
   data_atualizacao DATETIME NULL,
  `e-mail_corporativo` VARCHAR(45) NULL,
  `telefone_contato_corporativo` CHAR(11) NULL,
  `fk_usuario` INT NOT NULL,
  INDEX `fk_dados_empresa_usuario1_idx` (`fk_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_dados_empresa_usuario1`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `mydb`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tempo_estudo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tempo_estudo` (
  `id_tempo_estudo` INT NOT NULL AUTO_INCREMENT,
  `nome_dia` VARCHAR(45) NULL,
  `qtd_tempo_estudo` VARCHAR(5) NULL,
  `ativado` TINYINT NULL,
  `meta_alcancada` TINYINT NULL,
  PRIMARY KEY (`id_tempo_estudo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tempo_sessao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tempo_sessao` (
  `id_tempo_sessao` INT NOT NULL AUTO_INCREMENT,
  `dia_sessao` VARCHAR(45) NULL,
  `qtd_tempo_sessao` VARCHAR(5) NULL,
  `fk_usuario` INT NOT NULL,
  PRIMARY KEY (`id_tempo_sessao`),
  INDEX `fk_tempo_sessao_usuario1_idx` (`fk_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_tempo_sessao_usuario1`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `mydb`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`meta_estudo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`meta_estudo` (
  `fk_tempo_estudo` INT NOT NULL AUTO_INCREMENT,
  `fk_tempo_sessao` INT NOT NULL,
  `tempo_ate_completar` VARCHAR(5) NULL,
  `tempo_total_estimado` VARCHAR(5) NULL,
  INDEX `fk_usuario_has_tempo_estudo_tempo_estudo1_idx` (`fk_tempo_estudo` ASC) VISIBLE,
  INDEX `fk_meta_estudo_tempo_sessao1_idx` (`fk_tempo_sessao` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_has_tempo_estudo_tempo_estudo1`
    FOREIGN KEY (`fk_tempo_estudo`)
    REFERENCES `mydb`.`tempo_estudo` (`id_tempo_estudo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_meta_estudo_tempo_sessao1`
    FOREIGN KEY (`fk_tempo_sessao`)
    REFERENCES `mydb`.`tempo_sessao` (`id_tempo_sessao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE `mydb`.`ponto` DROP FOREIGN KEY `ponto_ibfk_1`;
ALTER TABLE usuario DROP FOREIGN KEY fk_endereco;

ALTER TABLE usuario
ADD CONSTRAINT fk_endereco 
FOREIGN KEY (fk_endereco) REFERENCES endereco(id_endereco) 
ON DELETE CASCADE;

ALTER TABLE redefinicao_senha DROP FOREIGN KEY fk_usuario;

ALTER TABLE redefinicao_senha
ADD CONSTRAINT fk_usuario 
FOREIGN KEY (fk_usuario) REFERENCES usuario(id_usuario) 
ON DELETE CASCADE;

 -- Pontos por dia e por curso
  CREATE VIEW PontosPorDiaEporCursoPorUsuario AS
SELECT 
    c.nome AS nome_curso,
    p.data_pontuacao,
    SUM(p.qtd_ponto) AS pontos_por_dia,
    p.fk_usuario AS usuario
FROM 
    Ponto p 
JOIN 
    Curso c ON p.fk_curso = c.id_curso 
GROUP BY 
    p.fk_curso, p.data_pontuacao, p.fk_usuario 
ORDER BY 
    p.fk_usuario, p.fk_curso, p.data_pontuacao;

-- Populando a tabela tipo_acao
INSERT INTO tipo_acao (id_tipoAcao, Inserir, Deletar, Atualizar) VALUES 
(1, 1, 1, 1), 
(2, 1, 0, 1), 
(3, 0, 0, 1);

-- Populando a tabela tipo_usuario
INSERT INTO tipo_usuario (id_tipo_usuario, nome, fk_tipoAcao) VALUES 
(1, 'ADM', 1), 
(2, 'ALUNO', 2), 
(3, 'RH', 3);

-- Populando a tabela endereco
INSERT INTO endereco (estado, cidade, CEP, rua, data_atualizacao) VALUES 
('SP', 'São Paulo', '01000-000', 'Rua A', NOW()), 
('RJ', 'Rio de Janeiro', '20000-000', 'Rua B', NOW()), 
('MG', 'Belo Horizonte', '30000-000', 'Rua C', NOW());

-- Populando a tabela usuario
INSERT INTO usuario (nome_usuario, CPF, senha, primeiro_nome, sobrenome, email, data_criacao, deletado, autenticado, fk_endereco, fk_tipo_usuario) VALUES 
('usuario1', '12345678901', 'senha1', 'João', 'Silva', 'joao.silva@example.com', NOW(), 0, 1, 1, 2), 
('usuario2', '98765432100', 'senha2', 'Maria', 'Souza', 'maria.souza@example.com', NOW(), 0, 1, 2, 2), 
('usuario3', '11122233344', 'senha3', 'Carlos', 'Pereira', 'carlos.pereira@example.com', NOW(), 0, 1, 3, 3);

-- Populando a tabela referencia_gerar_pontuacao
INSERT INTO referencia_gerar_pontuacao (id_referencia_gerar_pontuacao, nome_da_geracao, descricao_da_geracao) VALUES
(1, 'Quiz', 'Pontuação por quiz concluído'),
(2, 'Projeto', 'Pontuação por projeto concluído'),
(3, 'Exercício', 'Pontuação por exercício concluído');


-- Populando a tabela dados_empresa
INSERT INTO dados_empresa (nome_empresa, setor_industria, cargo_usuario, cnpj, data_atualizacao, `e-mail_corporativo`, telefone_contato_corporativo, fk_usuario) VALUES 
('Empresa A', 'Tecnologia', 'Desenvolvedor', '12345678000100', NOW(), 'joao@empresaA.com', '11987654321', 1), 
('Empresa B', 'Gestão', 'Gerente', '98765432000111', NOW(), 'maria@empresaB.com', '21987654321', 2), 
('Empresa C', 'Educação', 'Professor', '11223344000155', NOW(), 'carlos@empresaC.com', '31987654321', 3);


INSERT INTO categoria_curso (id_categoria_curso, nome) VALUE
(1, 'Tecnologia'),
(2, 'Gestão'),
(3, 'Idiomas');

-- Populando a tabela curso
INSERT INTO curso (nome, qtd_horas, fk_categoria_curso) VALUES
('Programação', 40, 1),
('Liderança', 20, 2),
('Inglês', 60, 3),
('Excel', 40, 1),
('Marketing Digital', 30, 2),
('Web Design', 50, 1),
('Finanças Pessoais', 25, 2),
('Gestão de Projetos', 35, 2);

INSERT INTO inscricao (fk_usuario, fk_curso, codigo_inscricao) VALUES
(1, 1, 'ABC123'),
(1, 2, 'DEF456'),
(1, 3, 'GHI789'),
(1, 4, 'JKL012');

-- Inserir dados em `modulo` curso 1
INSERT INTO modulo (id_modulo, fk_curso, qtd_atividade_total, nome_modulo) VALUES
(1, 1, 9, 'Módulo 1: Introdução'),
(2, 1, 9, 'Módulo 2: Fundamentos'),
(3, 1, 9, 'Módulo 3: Básico');

-- Inserir dados em `modulo` curso 2
INSERT INTO modulo (id_modulo, fk_curso, qtd_atividade_total, nome_modulo) VALUES
(1, 2, 12, 'Módulo 1: Introdução'),
(2, 2, 20, 'Módulo 2: Fundamentos'),
(3, 2, 10, 'Módulo 3: Básico');

-- Inserir dados em `modulo` curso 3
INSERT INTO modulo (id_modulo, fk_curso, qtd_atividade_total, nome_modulo) VALUES
(1, 3, 9, 'Módulo 1: Introdução'),
(2, 3, 11, 'Módulo 2: Fundamentos'),
(3, 3, 7, 'Módulo 3: Básico');

-- Inserir dados em `modulo` curso 4
INSERT INTO modulo (id_modulo, fk_curso, qtd_atividade_total, nome_modulo) VALUES
(1, 4, 9, 'Módulo 1: Introdução'),
(2, 4, 10, 'Módulo 2: Fundamentos'),
(3, 4, 11, 'Módulo 3: Básico');

-- Atividades para o curso 1
INSERT INTO atividade (nota, temp_duracao, data_entrega, fk_modulo, fk_curso) VALUES
(10, '01:30:00', '2024-06-01', 1, 1),
(7, '02:00:00', '2024-06-02', 1, 1),
(5, '01:00:00', '2024-06-03', 1, 1),
(4, '01:30:00', '2024-06-01', 2, 1),
(8, '02:00:00', '2024-06-02', 2, 1),
(2, '01:00:00', '2024-06-03', 2, 1),
(10, '01:30:00', '2024-06-01', 3, 1),
(10, '02:00:00', '2024-06-02', 3, 1),
(10, '01:00:00', '2024-06-03', 3, 1);

-- Atividades para o curso 2
INSERT INTO atividade (nota, temp_duracao, data_entrega, fk_modulo, fk_curso) VALUES
(9, '01:20:00', '2024-06-01', 1, 2),
(6, '02:10:00', '2024-06-02', 1, 2),
(8, '01:30:00', '2024-06-03', 1, 2),
(7, '01:40:00', '2024-06-04', 2, 2),
(9, '02:20:00', '2024-06-05', 2, 2),
(5, '01:50:00', '2024-06-06', 2, 2),
(8, '01:45:00', '2024-06-07', 3, 2),
(7, '02:15:00', '2024-06-08', 3, 2),
(10, '01:35:00', '2024-06-09', 3, 2);

-- Atividades para o curso 3
INSERT INTO atividade (nota, temp_duracao, data_entrega, fk_modulo, fk_curso) VALUES
(9, '01:10:00', '2024-06-01', 1, 3),
(8, '02:00:00', '2024-06-02', 1, 3),
(7, '01:20:00', '2024-06-03', 1, 3),
(8, '01:25:00', '2024-06-04', 2, 3),
(7, '02:10:00', '2024-06-05', 2, 3),
(9, '01:45:00', '2024-06-06', 2, 3),
(7, '01:35:00', '2024-06-07', 3, 3),
(6, '02:05:00', '2024-06-08', 3, 3),
(10, '01:25:00', '2024-06-09', 3, 3);

-- Atividades para o curso 4
INSERT INTO atividade (nota, temp_duracao, data_entrega, fk_modulo, fk_curso) VALUES
(8, '01:20:00', '2024-06-01', 1, 4),
(7, '01:50:00', '2024-06-02', 1, 4),
(6, '01:30:00', '2024-06-03', 1, 4),
(7, '01:25:00', '2024-06-04', 2, 4),
(8, '02:00:00', '2024-06-05', 2, 4),
(9, '01:45:00', '2024-06-06', 2, 4),
(9, '01:40:00', '2024-06-07', 3, 4),
(6, '02:20:00', '2024-06-08', 3, 4),
(8, '01:35:00', '2024-06-09', 3, 4);

-- Pontos para as atividades do módulo 1 do curso 1
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(10, '2024-06-05', 1, 1, 1, 1, 1),
(14, '2024-06-06', 1, 2, 1, 1, 1),
(18, '2024-06-07', 1, 3, 1, 1, 1);

-- Pontos para as atividades do módulo 2 do curso 1
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(20, '2024-06-08', 1, 4, 2, 1, 1),
(26, '2024-06-09', 2, 5, 2, 1, 1),
(32, '2024-06-10', 3, 6, 2, 1, 1);

-- Pontos para as atividades do módulo 3 do curso 1
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(30, '2024-06-11', 1, 7, 3, 1, 1),
(36, '2024-06-12', 2, 8, 3, 1, 1),
(42, '2024-06-13', 3, 9, 3, 1, 1);

-- Pontos para as atividades do módulo 1 do curso 2
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(15, '2024-06-05', 1, 10, 1, 2, 1),
(10, '2024-06-06', 1, 11, 1, 2, 1),
(20, '2024-06-07', 1, 12, 1, 2, 1);

-- Pontos para as atividades do módulo 2 do curso 2
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(18, '2024-06-08', 1, 13, 2, 2, 1),
(25, '2024-06-09', 2, 14, 2, 2, 1),
(10, '2024-06-10', 3, 15, 2, 2, 1);

-- Pontos para as atividades do módulo 3 do curso 2
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(22, '2024-06-11', 1, 16, 3, 2, 1),
(19, '2024-06-12', 2, 17, 3, 2, 1),
(30, '2024-06-13', 3, 18, 3, 2, 1);

-- Pontos para as atividades do módulo 1 do curso 3
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(13, '2024-06-05', 1, 19, 1, 3, 1),
(18, '2024-06-06', 1, 20, 1, 3, 1),
(10, '2024-06-07', 1, 21, 1, 3, 1);

-- Pontos para as atividades do módulo 2 do curso 3
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(20, '2024-06-08', 1, 22, 2, 3, 1),
(15, '2024-06-09', 2, 23, 2, 3, 1),
(23, '2024-06-10', 3, 24, 2, 3, 1);

-- Pontos para as atividades do módulo 3 do curso 3
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(17, '2024-06-11', 1, 25, 3, 3, 1),
(12, '2024-06-12', 2, 26, 3, 3, 1),
(28, '2024-06-13', 3, 27, 3, 3, 1);

-- Pontos para as atividades do módulo 1 do curso 4
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(14, '2024-06-05', 1, 28, 1, 4, 1),
(19, '2024-06-06', 1, 29, 1, 4, 1),
(11, '2024-06-07', 1, 30, 1, 4, 1);

-- Pontos para as atividades do módulo 2 do curso 4
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(17, '2024-06-08', 1, 31, 2, 4, 1),
(22, '2024-06-09', 2, 32, 2, 4, 1),
(27, '2024-06-10', 3, 33, 2, 4, 1);

-- Pontos para as atividades do módulo 3 do curso 4
INSERT INTO ponto (qtd_ponto, data_pontuacao, fk_referencia_gerar_pontuacao, fk_atividade, fk_modulo, fk_curso, fk_usuario) VALUES
(20, '2024-06-11', 1, 34, 3, 4, 1),
(15, '2024-06-12', 2, 35, 3, 4, 1),
(18, '2024-06-13', 3, 36, 3, 4, 1);




SELECT
    fk_curso AS id_curso,
    SUM(qtd_atividade_total) AS total_qtd_atividades
FROM
    modulo
GROUP BY
    fk_curso;


SELECT
    fk_curso AS id_curso,
    SUM(qtd_atividade_total) AS total_qtd_atividades
FROM
    modulo
GROUP BY
    fk_curso;

SELECT
    modulo.fk_curso AS id_curso,
    curso.nome AS nome_curso,
    COUNT(DISTINCT atividade.id_atividade) AS total_atividades_usuario_1
FROM
    modulo
INNER JOIN curso ON modulo.fk_curso = curso.id_curso
LEFT JOIN atividade ON modulo.id_modulo = atividade.fk_modulo AND atividade.fk_curso = modulo.fk_curso
LEFT JOIN ponto ON atividade.id_atividade = ponto.fk_atividade AND ponto.fk_usuario = 1
WHERE
    modulo.fk_curso IN (SELECT fk_curso FROM inscricao WHERE fk_usuario = 1)
GROUP BY
    modulo.fk_curso;





-- pontos totais por curso
SELECT
    fk_curso,
    SUM(qtd_ponto) AS total_pontos
FROM
    ponto
WHERE
    fk_usuario = 1
GROUP BY
    fk_curso;
    
    
   


 SELECT
        *         
    FROM
        PontosPorDiaEporCursoPorUsuario         
    WHERE
        usuario = 1;     



-- Pontos na semana passada
SELECT
    'semana_passada' AS semana,
    SUM(qtd_ponto) AS total_pontos
FROM
    ponto
WHERE
    fk_usuario = 1
    AND data_pontuacao BETWEEN '2024-06-02' AND '2024-06-08'

UNION ALL

SELECT
    'semana_atual' AS semana,
    SUM(qtd_ponto) AS total_pontos
FROM
    ponto
WHERE
    fk_usuario = 1
    AND data_pontuacao BETWEEN '2024-06-09' AND '2024-06-13'

UNION ALL

SELECT
    'diferenca_semana_atual_passada' AS semana,
    (SELECT SUM(qtd_ponto) FROM ponto WHERE fk_usuario = 1 AND data_pontuacao BETWEEN '2024-06-09' AND '2024-06-13') -
    (SELECT SUM(qtd_ponto) FROM ponto WHERE fk_usuario = 1 AND data_pontuacao BETWEEN '2024-06-02' AND '2024-06-08') AS diferenca_pontos;





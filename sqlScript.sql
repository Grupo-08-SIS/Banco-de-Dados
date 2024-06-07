-- MySQL Workbench Forward Engineering


DROP database mydb;
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
  id_referencia_gerar_pontuacao INT NOT NULL,
  nome_da_geracao VARCHAR(45) NULL,
  descricao_da_geracao VARCHAR(45) NULL,
  PRIMARY KEY (id_referencia_gerar_pontuacao)
);


-- -----------------------------------------------------
-- Table `mydb`.`ponto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ponto (
  id_ponto INT NOT NULL,
  qtd_ponto INT NOT NULL,
  fk_referencia_gerar_pontuacao INT NOT NULL,
  PRIMARY KEY (id_ponto),
  CONSTRAINT fk_ponto_referencia_gerar_pontuacao1 FOREIGN KEY (fk_referencia_gerar_pontuacao) REFERENCES referencia_gerar_pontuacao (id_referencia_gerar_pontuacao)
);


-- -----------------------------------------------------
-- Table `mydb`.`pontuacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS pontuacao (
  id_pontuacao INT NOT NULL,
  fk_usuario INT NOT NULL,
  fk_ponto INT NOT NULL,
  total_pontos_usuario INT NULL,
  data_atualizacao DATETIME NULL,
  PRIMARY KEY (id_pontuacao),
  CONSTRAINT fk_pontuacao_pontos1 FOREIGN KEY (fk_ponto) REFERENCES ponto (id_ponto),
  CONSTRAINT fk_pontuacao_usuario1 FOREIGN KEY (fk_usuario) REFERENCES usuario (id_usuario)
);


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
-- Table `mydb`.`categoria_curso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS categoria_curso (
  id_categoria_curso INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL
);


-- -----------------------------------------------------
-- Table `mydb`.`curso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS curso (
  id_curso INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL,
  qtd_horas INT NOT NULL,
  fk_categoria_curso INT NOT NULL,
  CONSTRAINT fk_curso_categoria_curso1 FOREIGN KEY (fk_categoria_curso) REFERENCES categoria_curso (id_categoria_curso)
);



-- -----------------------------------------------------
-- Table `mydb`.`inscricao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`inscricao` (
  `fk_usuario` INT NOT NULL,
  `fk_curso` INT NOT NULL,
  `codigo_inscricao` VARCHAR(100) NULL,
  PRIMARY KEY (`fk_usuario`, `fk_curso`),
  INDEX `fk_usuario_has_curso_curso1_idx` (`fk_curso` ASC) VISIBLE,
  INDEX `fk_usuario_has_curso_usuario1_idx` (`fk_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_has_curso_usuario1`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `mydb`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_has_curso_curso1`
    FOREIGN KEY (`fk_curso`)
    REFERENCES `mydb`.`curso` (`id_curso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`atividade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade` (
  id_atividade INT AUTO_INCREMENT PRIMARY KEY,
  nota INT NOT NULL,
  temp_duracao TIME NOT NULL
);


-- -----------------------------------------------------
-- Table `mydb`.`modulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modulo` (
  id_modulo INT AUTO_INCREMENT PRIMARY KEY,
  fk_curso INT NOT NULL,
  fk_atividade INT NOT NULL,
  qtd_atividade_feita INT NOT NULL,
  qtd_atividade_total INT NOT NULL,
  nome_modulo VARCHAR(45),
  CONSTRAINT fk_modulo_curso FOREIGN KEY (fk_curso) REFERENCES curso (id_curso),
  CONSTRAINT fk_modulo_atividade FOREIGN KEY (fk_atividade) REFERENCES atividade (id_atividade)
);


-- -----------------------------------------------------
-- Table `mydb`.`classificacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`classificacao` (
  `id_classificacao` INT NOT NULL,
  `total_pontos` INT NULL,
  PRIMARY KEY (`id_classificacao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
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
  `id_tempo_estudo` INT NOT NULL,
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
  `id_tempo_sessao` INT NOT NULL,
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
  `fk_tempo_estudo` INT NOT NULL,
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

INSERT INTO tipo_acao (id_tipoAcao, Inserir, Deletar, Atualizar) VALUES 
(1, 1, 1, 1), 
(2, 1, 0, 1), 
(3, 0, 0, 1);

INSERT INTO tipo_usuario (id_tipo_usuario, nome, fk_tipoAcao) VALUES 
(1, 'ADM', 1), 
(2, 'ALUNO', 2), 
(3, 'RH', 3);

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




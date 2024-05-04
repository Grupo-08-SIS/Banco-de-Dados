
CREATE DATABASE IF NOT EXISTS Tech4All;
USE Tech4All ;

CREATE TABLE IF NOT EXISTS tipo_ponto (
  id_tipo_ponto INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_tipo_ponto)
  );

CREATE TABLE IF NOT EXISTS categoria_curso (
  id_categoria_curso INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_categoria_curso)
  );

CREATE TABLE IF NOT EXISTS curso (
  id_curso INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  qtd_horas INT NOT NULL,
  fk_categoria_curso INT NOT NULL,
  PRIMARY KEY (id_curso),
  INDEX fk_curso_categoria_curso1_idx (fk_categoria_curso ASC) VISIBLE,
  CONSTRAINT fk_curso_categoria_curso1
  FOREIGN KEY (fk_categoria_curso) REFERENCES categoria_curso (id_categoria_curso)
);

CREATE TABLE IF NOT EXISTS ponto (
  id_ponto INT NOT NULL AUTO_INCREMENT,
  qtd_ponto INT NOT NULL,
  fk_tipo_ponto INT NOT NULL,
  fk_curso INT NOT NULL,
  PRIMARY KEY (id_ponto, fk_tipo_ponto),
  INDEX fk_pontos_tipo_ponto1_idx (fk_tipo_ponto ASC) VISIBLE,
  INDEX fk_ponto_curso1_idx (fk_curso ASC) VISIBLE,
  CONSTRAINT fk_pontos_tipo_ponto1
  FOREIGN KEY (fk_tipo_ponto) REFERENCES tipo_ponto (id_tipo_ponto),
  CONSTRAINT fk_ponto_curso1
  FOREIGN KEY (fk_curso) REFERENCES curso (id_curso)
);

CREATE TABLE IF NOT EXISTS pontuacao (
  id_pontuacao INT AUTO_INCREMENT NOT NULL,
  fk_pontos INT NOT NULL,
  fk_tipo_ponto INT NOT NULL,
  total_pontos_usuario VARCHAR(60) NULL,
  data_criacao DATETIME NOT NULL,
  PRIMARY KEY (id_pontuacao),
  INDEX fk_pontuacao_pontos1_idx (fk_pontos ASC, fk_tipo_ponto ASC) VISIBLE,
  CONSTRAINT fk_pontuacao_pontos1
  FOREIGN KEY (fk_pontos , fk_tipo_ponto) REFERENCES ponto (id_ponto , fk_tipo_ponto)
);

/*
Permissionamento
*/
CREATE TABLE IF NOT EXISTS tipo_acao (
  id_tipo_acao INT NOT NULL AUTO_INCREMENT,
  Inserir TINYINT,
  Deletar TINYINT,
  Atualizar TINYINT,
  PRIMARY KEY (id_tipo_acao)
  );

CREATE TABLE IF NOT EXISTS tipo_usuario (
  id_tipo_usuario INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45),
  fk_tipo_acao INT NOT NULL,
  PRIMARY KEY (id_tipo_usuario),
  INDEX fk_tipo_usuario_tipo_acao1_idx (fk_tipo_acao ASC) VISIBLE,
  CONSTRAINT fk_tipo_usuario_tipo_acao1
  FOREIGN KEY (fk_tipo_acao) REFERENCES tipo_acao (id_tipo_acao)
);
/*
Permissionamento
*/

CREATE TABLE IF NOT EXISTS endereco (
  id_endereco INT AUTO_INCREMENT NOT NULL,
  estado CHAR(2) NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  CEP CHAR(8) NOT NULL,
  rua VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_endereco)
  );

CREATE TABLE IF NOT EXISTS usuario (
  id_usuario INT AUTO_INCREMENT NOT NULL,
  nome_usuario VARCHAR(100) NOT NULL,
  CPF CHAR(11),
  senha VARCHAR(200) NOT NULL COMMENT 'Armazenada de forma criptografada',
  primeiro_nome VARCHAR(100),
  sobrenome VARCHAR(100) ,
  email VARCHAR(100) NOT NULL,
  imagem_perfil VARCHAR(200),
  data_criacao DATETIME,
  deletado TINYINT NOT NULL,
  data_deletado DATETIME,
  data_atualizacao DATETIME,
  fk_pontuacao INT,
  fk_tipo_usuario INT NOT NULL,
  fk_endereco INT NOT NULL,
  PRIMARY KEY (id_usuario),
  UNIQUE INDEX uk_nome_usuario (nome_usuario ASC) INVISIBLE,
  UNIQUE INDEX uk_email (email ASC) VISIBLE,
  INDEX fk_usuario_pontuacao1_idx (fk_pontuacao ASC) VISIBLE,
  INDEX fk_usuario_tipo_usuario1_idx (fk_tipo_usuario ASC) VISIBLE,
  INDEX fk_usuario_endereco1_idx (fk_endereco ASC) VISIBLE,
  CONSTRAINT fk_usuario_pontuacao1
  FOREIGN KEY (fk_pontuacao) REFERENCES pontuacao (id_pontuacao),
  CONSTRAINT fk_usuario_tipo_usuario1
  FOREIGN KEY (fk_tipo_usuario) REFERENCES tipo_usuario (id_tipo_usuario),
  CONSTRAINT fk_usuario_endereco1
  FOREIGN KEY (fk_endereco) REFERENCES endereco (id_endereco)
);

CREATE TABLE IF NOT EXISTS redefinicao_senha (
  id_redefinicao_senha INT AUTO_INCREMENT NOT NULL,
  codigo_redefinicao VARCHAR(8) NOT NULL,
  data_criacao DATETIME NOT NULL,
  data_expiracao DATETIME NOT NULL,
  valido TINYINT NOT NULL,
  fk_usuario INT NOT NULL,
  PRIMARY KEY (id_redefinicao_senha),
  INDEX fk_redefinicao_senha_usuario1_idx (fk_usuario ASC) VISIBLE,
  CONSTRAINT fk_redefinicao_senha_usuario1
  FOREIGN KEY (fk_usuario) REFERENCES usuario (id_usuario)
);

CREATE TABLE IF NOT EXISTS categoria_produto (
  id_categoria_produto INT AUTO_INCREMENT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_categoria_produto)
  );


CREATE TABLE IF NOT EXISTS produto (
  id_produto INT AUTO_INCREMENT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  valor_pontos DOUBLE NOT NULL,
  descricao TINYTEXT NULL,
  quantidade INT NOT NULL,
  disponivel TINYINT NOT NULL,
  fk_categoria_produto INT NOT NULL,
  PRIMARY KEY (id_produto),
  INDEX fk_produto_tipo_produto1_idx (fk_categoria_produto ASC) VISIBLE,
  CONSTRAINT fk_produto_tipo_produto1
  FOREIGN KEY (fk_categoria_produto) REFERENCES categoria_produto (id_categoria_produto)
);

CREATE TABLE IF NOT EXISTS carrinho (
  id_carrinho INT AUTO_INCREMENT NOT NULL,
  fk_usuario INT NOT NULL,
  fk_produto INT NOT NULL,
  quantidade_produto INT NOT NULL,
  PRIMARY KEY (id_carrinho, fk_usuario, fk_produto),
  INDEX fk_usuario_has_produto_produto1_idx (fk_produto ASC) VISIBLE,
  INDEX fk_usuario_has_produto_usuario1_idx (fk_usuario ASC) VISIBLE,
  CONSTRAINT fk_usuario_has_produto_usuario1
  FOREIGN KEY (fk_usuario) REFERENCES usuario (id_usuario),
  CONSTRAINT fk_usuario_has_produto_produto1
  FOREIGN KEY (fk_produto) REFERENCES produto (id_produto)
);

CREATE TABLE IF NOT EXISTS inscricao (
  fk_usuario INT AUTO_INCREMENT NOT NULL,
  fk_curso INT NOT NULL,
  codigo_inscricao VARCHAR(100) NOT NULL,
  PRIMARY KEY (fk_usuario, fk_curso),
  INDEX fk_usuario_has_curso_curso1_idx (fk_curso ASC) VISIBLE,
  INDEX fk_usuario_has_curso_usuario1_idx (fk_usuario ASC) VISIBLE,
  CONSTRAINT fk_usuario_has_curso_usuario1
  FOREIGN KEY (fk_usuario) REFERENCES usuario (id_usuario),
  CONSTRAINT fk_usuario_has_curso_curso1
  FOREIGN KEY (fk_curso) REFERENCES curso (id_curso)
);

CREATE TABLE IF NOT EXISTS atividade (
  id_atividade INT AUTO_INCREMENT NOT NULL,
  nota INT NOT NULL,
  temp_duracao TIME NOT NULL,
  PRIMARY KEY (id_atividade)
  );

CREATE TABLE IF NOT EXISTS modulo (
  fk_curso INT AUTO_INCREMENT NOT NULL,
  fk_atividade INT NOT NULL,
  qtd_atividade_feita INT NOT NULL,
  qtd_atividade_total INT NOT NULL,
  nome_modulo VARCHAR(45),
  PRIMARY KEY (fk_curso, fk_atividade),
  INDEX fk_curso_has_atividade_atividade1_idx (fk_atividade ASC) VISIBLE,
  INDEX fk_curso_has_atividade_curso1_idx (fk_curso ASC) VISIBLE,
  CONSTRAINT fk_curso_has_atividade_curso1
  FOREIGN KEY (fk_curso) REFERENCES curso (id_curso),
  CONSTRAINT fk_curso_has_atividade_atividade1
  FOREIGN KEY (fk_atividade) REFERENCES atividade (id_atividade)
);

CREATE TABLE IF NOT EXISTS classificacao (
  id_classificacao INT AUTO_INCREMENT NOT NULL,
  fk_usuario INT NOT NULL,
  fk_pontuacao INT NOT NULL,
  PRIMARY KEY (id_classificacao),
  INDEX fk_classificacao_usuario1_idx (fk_usuario ASC) VISIBLE,
  CONSTRAINT fk_classificacao_usuario1
  FOREIGN KEY (fk_usuario) REFERENCES usuario (id_usuario),
  CONSTRAINT fk_classificacao_pontuacao1
  FOREIGN KEY (fk_pontuacao) REFERENCES pontuacao (id_pontuacao)
);

CREATE TABLE IF NOT EXISTS status_pedido (
id_status_pedido INT AUTO_INCREMENT NOT NULL,
nome_status VARCHAR(45),
descricao_status VARCHAR(100),
PRIMARY KEY (id_status_pedido)
);

CREATE TABLE IF NOT EXISTS pedido (
id_pedido INT AUTO_INCREMENT NOT NULL,
fk_usuario INT NOT NULL,
fk_carrinho INT NOT NULL,
descricao_pedido VARCHAR(100),
fk_status_pedido INT NOT NULL,
PRIMARY KEY (id_pedido),
CONSTRAINT fk_pedido_usuario
FOREIGN KEY (fk_usuario) REFERENCES usuario (id_usuario),
CONSTRAINT fk_pedido_carrinho 
FOREIGN KEY (fk_carrinho) REFERENCES carrinho (id_carrinho),
CONSTRAINT fk_pedido_status_pedido
FOREIGN KEY (fk_status_pedido) REFERENCES status_pedido (id_status_pedido)
);


/*
INSERTS
*/

INSERT INTO tipo_ponto (nome) VALUES 
('Presença'),
('Avaliação'),
('Participação');

INSERT INTO categoria_curso (nome) VALUES 
('Tecnologia da Informação'),
('Design Gráfico'),
('Marketing Digital');

INSERT INTO curso (nome, qtd_horas, fk_categoria_curso) VALUES 
('Desenvolvimento Web', 80, 1),
('Photoshop Avançado', 40, 2),
('Marketing de Conteúdo', 60, 3);

INSERT INTO ponto (qtd_ponto, fk_tipo_ponto, fk_curso) VALUES 
(10, 1, 1),
(20, 2, 2),
(15, 3, 3); 

INSERT INTO tipo_acao (Inserir, Deletar, Atualizar) VALUES 
(1, 1, 1),
(1,1,1); 

INSERT INTO endereco (estado, cidade, CEP, rua) VALUES 
('SP', 'São Paulo', '01000000', 'Avenida Paulista'),
( 'RJ', 'Rio de Janeiro', '20000000', 'Rua dos Andradas');

INSERT INTO tipo_usuario (nome, fk_tipo_acao) VALUES
('Administro', 1),
('Cliente', 2);

/*
 -- Melhor jogar isso para o Back-End
INSERT INTO pontuacao (fk_pontos, fk_tipo_ponto, total_pontos_usuario, data_criacao)
VALUES (
    (SELECT id_ponto FROM ponto WHERE usuario_id = 'ID_DO_USUARIO'), -- Subconsulta para obter o ID dos pontos do usuário
    1, -- Exemplo de fk_tipo_ponto
    (SELECT SUM(pontos) FROM ponto WHERE usuario_id = 'ID_DO_USUARIO'), -- Subconsulta para calcular a soma dos pontos do usuário
    NOW() -- Data de criação
);
*/

INSERT INTO pontuacao (fk_pontos, fk_tipo_ponto, total_pontos_usuario, data_criacao) 
VALUES (1, 1, '100', '2024-04-10 08:00:00');

INSERT INTO usuario (nome_usuario, CPF, senha, primeiro_nome, sobrenome, email, data_criacao, deletado, fk_pontuacao, fk_tipo_usuario, fk_endereco) VALUES 
('admin', '12345678901', 'senha_admin', 'Admin', 'Admin', 'admin@example.com', NOW(), 0, 1, 1, 1),
('usuario1', '98765432101', 'senha_usuario1', 'Usuário', 'Um', 'usuario1@example.com',NOW(), 0, 1, 1, 2);

INSERT INTO redefinicao_senha (codigo_redefinicao, data_criacao, data_expiracao, valido, fk_usuario) VALUES 
('ABCD1234', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY), 1, 1);

INSERT INTO categoria_produto (nome) VALUES 
('Eletrônicos'),
('Livros'),
('Roupas');

INSERT INTO produto (nome, valor_pontos, descricao, quantidade, disponivel, fk_categoria_produto) VALUES 
('Smartphone', 500.00, 'Modelo X', 10, 1, 1),
('A Guerra dos Tronos', 150.00, 'Livro da série', 20, 1, 2),
('Camiseta Preta', 80.00, 'Tamanho M', 30, 1, 3);

INSERT INTO carrinho (fk_usuario, fk_produto, quantidade_produto) VALUES 
(2, 1, 1), 
(2, 3, 2); 

INSERT INTO inscricao (fk_usuario, fk_curso, codigo_inscricao) VALUES 
(2, 1, 'ABCD1234'), 
(2, 3, 'EFGH5678'); 

INSERT INTO atividade (nota, temp_duracao) VALUES 
(80, '02:30:00'),
(90, '01:45:00'),
(75, '03:00:00');

INSERT INTO modulo (fk_curso, fk_atividade, qtd_atividade_feita, qtd_atividade_total, nome_modulo) VALUES 
(1, 1, 1, 2, 'Módulo 1'),
(1, 2, 0, 1, 'Módulo 2'),
(3, 3, 1, 1, 'Módulo 1');

INSERT INTO classificacao (fk_usuario, fk_pontuacao) VALUES 
(2, 1);


/*
SELECTS
*/

SELECT * FROM usuario;
SELECT * FROM classificacao;
SELECT * FROM pontuacao;
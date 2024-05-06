CREATE VIEW `classificacao` AS
SELECT
	id_pontuacao,
    fk_usuario,
    fk_ponto,
    ROW_NUMBER() OVER (PARTITION BY fk_usuario ORDER BY total_pontos_usuario DESC) AS classificacao, total_pontos_usuario
    FROM pontuacao;
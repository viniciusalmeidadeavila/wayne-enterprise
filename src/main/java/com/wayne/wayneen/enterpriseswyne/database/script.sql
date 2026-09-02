CREATE DATABASE IF NOT EXISTS wayne_db;
USE `wayne_db` ;

-- -----------------------------------------------------
-- Table `wayne_db`.`funcionarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `funcionarios` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome_completo` VARCHAR(100) NOT NULL,
  `cpf` VARCHAR(14) NOT NULL,
  `cargo` VARCHAR(50) NULL DEFAULT NULL,
  `departamento` VARCHAR(50) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `data_admissao` DATE NULL DEFAULT NULL,
  `data_nascimento` DATE NULL DEFAULT NULL,
  `caminho_curriculo` TEXT NULL DEFAULT NULL,
  `caminho_contrato` TEXT NULL DEFAULT NULL,
  `caminho_foto` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 17
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`avaliacoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `avaliacoes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `funcionario_id` INT(11) NOT NULL,
  `data_avaliacao` DATE NOT NULL,
  `pontualidade` INT(11) NULL DEFAULT NULL,
  `produtividade` INT(11) NULL DEFAULT NULL,
  `trabalho_em_equipe` INT(11) NULL DEFAULT NULL,
  `observacoes` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `funcionario_id` (`funcionario_id` ASC),
  CONSTRAINT `avaliacoes_ibfk_1`
    FOREIGN KEY (`funcionario_id`)
    REFERENCES `wayne_db`.`funcionarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`avisos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`avisos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(100) NULL DEFAULT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `data` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`candidatos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`candidatos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `cargo_pretendido` VARCHAR(100) NULL DEFAULT NULL,
  `link_curriculo` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`cargos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`cargos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome_cargo` VARCHAR(100) NOT NULL,
  `nivel` VARCHAR(50) NULL DEFAULT NULL,
  `salario_base` DECIMAL(10,2) NULL DEFAULT NULL,
  `criterios_promocao` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`chamados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`chamados` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(100) NULL DEFAULT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `status` VARCHAR(50) NULL DEFAULT NULL,
  `prioridade` VARCHAR(50) NULL DEFAULT NULL,
  `funcionario` VARCHAR(100) NULL DEFAULT NULL,
  `data_abertura` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`chat_conversation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`chat_conversation` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`usuarios` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome_completo` VARCHAR(255) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NOT NULL,
  `senha` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`chat_message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`chat_message` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `conversation_id` BIGINT(20) NOT NULL,
  `sender_id` INT(11) NOT NULL,
  `body` TEXT NOT NULL,
  `status` ENUM('SENT', 'DELIVERED', 'READ') NOT NULL DEFAULT 'SENT',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  INDEX `idx_conv_time` (`conversation_id` ASC, `created_at` ASC),
  INDEX `idx_sender_time` (`sender_id` ASC, `created_at` ASC),
  CONSTRAINT `fk_message_conversation`
    FOREIGN KEY (`conversation_id`)
    REFERENCES `wayne_db`.`chat_conversation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_message_sender`
    FOREIGN KEY (`sender_id`)
    REFERENCES `wayne_db`.`usuarios` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`chat_participant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`chat_participant` (
  `conversation_id` BIGINT(20) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `role` ENUM('MEMBER', 'ADMIN') NOT NULL DEFAULT 'MEMBER',
  `joined_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`conversation_id`, `user_id`),
  INDEX `fk_participant_user` (`user_id` ASC),
  CONSTRAINT `fk_participant_conversation`
    FOREIGN KEY (`conversation_id`)
    REFERENCES `wayne_db`.`chat_conversation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_participant_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `wayne_db`.`usuarios` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`chat_typing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`chat_typing` (
  `conversation_id` BIGINT(20) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `typing` TINYINT(1) NOT NULL DEFAULT 0,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  PRIMARY KEY (`conversation_id`, `user_id`),
  INDEX `fk_typing_user` (`user_id` ASC),
  CONSTRAINT `fk_typing_conversation`
    FOREIGN KEY (`conversation_id`)
    REFERENCES `wayne_db`.`chat_conversation` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_typing_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `wayne_db`.`usuarios` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`documentos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`documentos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(255) NULL DEFAULT NULL,
  `validade` DATE NULL DEFAULT NULL,
  `caminho_arquivo` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`empresa_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`empresa_info` (
  `id` INT(11) NOT NULL,
  `nome` VARCHAR(160) NOT NULL,
  `cnpj` VARCHAR(32) NULL DEFAULT NULL,
  `descricao_html` MEDIUMTEXT NULL DEFAULT NULL,
  `missao` TEXT NULL DEFAULT NULL,
  `visao` TEXT NULL DEFAULT NULL,
  `valores` TEXT NULL DEFAULT NULL,
  `endereco` VARCHAR(255) NULL DEFAULT NULL,
  `telefone` VARCHAR(64) NULL DEFAULT NULL,
  `email` VARCHAR(160) NULL DEFAULT NULL,
  `site` VARCHAR(200) NULL DEFAULT NULL,
  `redes` TEXT NULL DEFAULT NULL,
  `logo_path` VARCHAR(500) NULL DEFAULT NULL,
  `data_atualizacao` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`equipamentos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`equipamentos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(100) NULL DEFAULT NULL,
  `numero_serie` VARCHAR(100) NULL DEFAULT NULL,
  `funcionario_responsavel` VARCHAR(100) NULL DEFAULT NULL,
  `status` VARCHAR(50) NULL DEFAULT NULL,
  `data_aquisicao` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`eventos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`eventos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(100) NOT NULL,
  `descricao` TEXT NOT NULL,
  `data` DATE NOT NULL,
  `local` VARCHAR(100) NOT NULL,
  `tipo` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`eventos_corporativos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`eventos_corporativos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(100) NOT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `data_evento` DATE NULL DEFAULT NULL,
  `tipo_evento` VARCHAR(50) NULL DEFAULT NULL,
  `local` VARCHAR(100) NULL DEFAULT NULL,
  `responsavel` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`ferias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`ferias` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `funcionario_id` INT(11) NOT NULL,
  `data_inicio` DATE NOT NULL,
  `data_fim` DATE NOT NULL,
  `observacao` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `funcionario_id` (`funcionario_id` ASC),
  CONSTRAINT `ferias_ibfk_1`
    FOREIGN KEY (`funcionario_id`)
    REFERENCES `wayne_db`.`funcionarios` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`log_acoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`log_acoes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuario` VARCHAR(50) NULL DEFAULT NULL,
  `acao` TEXT NULL DEFAULT NULL,
  `momento` DATETIME NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 52
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`log_auditoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`log_auditoria` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `acao` VARCHAR(255) NULL DEFAULT NULL,
  `modulo` VARCHAR(100) NULL DEFAULT NULL,
  `data_hora` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`notificacao_tipo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`notificacao_tipo` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(20) NOT NULL,
  `nome` VARCHAR(60) NOT NULL,
  `cor_hex` VARCHAR(9) NULL DEFAULT NULL,
  `ordem` INT(11) NULL DEFAULT NULL,
  `ativo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `codigo` (`codigo` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`notificacoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`notificacoes` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `mensagem` TEXT NOT NULL,
  `data_hora` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `lida` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`treinamentos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`treinamentos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(200) NULL DEFAULT NULL,
  `tipo` VARCHAR(50) NULL DEFAULT NULL,
  `local` VARCHAR(100) NULL DEFAULT NULL,
  `data` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`participacoes_treinamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`participacoes_treinamento` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_funcionario` INT(11) NOT NULL,
  `id_treinamento` INT(11) NOT NULL,
  `data_participacao` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `id_funcionario` (`id_funcionario` ASC),
  INDEX `id_treinamento` (`id_treinamento` ASC),
  CONSTRAINT `participacoes_treinamento_ibfk_1`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `wayne_db`.`funcionarios` (`id`),
  CONSTRAINT `participacoes_treinamento_ibfk_2`
    FOREIGN KEY (`id_treinamento`)
    REFERENCES `wayne_db`.`treinamentos` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`permissoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`permissoes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `perfil` VARCHAR(50) NULL DEFAULT NULL,
  `modulo` VARCHAR(100) NULL DEFAULT NULL,
  `pode_visualizar` TINYINT(1) NULL DEFAULT NULL,
  `pode_editar` TINYINT(1) NULL DEFAULT NULL,
  `pode_excluir` TINYINT(1) NULL DEFAULT NULL,
  `pode_exportar` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `wayne_db`.`processos_seletivos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wayne_db`.`processos_seletivos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(255) NOT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `data_inicio` DATE NOT NULL,
  `data_fim` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `wayne_db`.`curriculos` (
	`id` INT(11) NOT NULL auto_increment,
    `nome` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `telefone` VARCHAR(255) NOT NULL,
    `cargoDesejado` VARCHAR(255) NOT NULL,
    `skills` VARCHAR(255) NOT NULL,
    `experiencia` VARCHAR(255) NOT NULL,
    `escolaridade` VARCHAR(255) NOT NULL,
    `linkedin` VARCHAR(255) NOT NULL,
    `statusProcesso` ENUM("NOVO", "EM_ANALISE", "ENTREVISTA", "APROVADO", "REPROVADO", "RESERVA") NOT NULL,
    `caminhoPdf` VARCHAR(255) NOT NULL,
    `dataCadastro` date NOT NULL,
    PRIMARY KEY (`id`))
    ENGINE = InnoDB
	DEFAULT CHARACTER SET = utf8mb4;
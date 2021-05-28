CREATE DATABASE IF NOT EXISTS db_tradeForYou;

USE
db_tradeForYou;


DROP TABLE IF EXISTS operatori;
CREATE TABLE operatori
(
    idOperatore   INT         NOT NULL PRIMARY KEY AUTO_INCREMENT,
    cognome       VARCHAR(50) NOT NULL,
    nome          VARCHAR(50) NOT NULL,
    dataNascita   DATE        NOT NULL,
    username      VARCHAR(20) NOT NULL UNIQUE,
    email         VARCHAR(70) NOT NULL UNIQUE,
    salt          VARCHAR(32) NOT NULL,
    password_hash VARCHAR(64) NOT NULL,
    CHECK (dataNascita < CURRENT_DATE)
);


DROP TABLE IF EXISTS clienti;
CREATE TABLE clienti
(
    idCliente     INT         NOT NULL PRIMARY KEY AUTO_INCREMENT,
    cognome       VARCHAR(50) NOT NULL,
    nome          VARCHAR(50) NOT NULL,
    dataNascita   DATE        NOT NULL,
    username      VARCHAR(20) NOT NULL UNIQUE,
    email         VARCHAR(70) NOT NULL UNIQUE,
    salt          VARCHAR(32) NOT NULL,
    password_hash VARCHAR(64) NOT NULL,
    CHECK (dataNascita < CURRENT_DATE)
);

DROP TABLE IF EXISTS campagne;
CREATE TABLE campagne
(
    idCampagna   INT           NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome         VARCHAR(50)   NOT NULL UNIQUE,
    dataScadenza DATE          NOT NULL,
    descrizione  VARCHAR(100)   NOT NULL,
    budget       DECIMAL(6, 2) NOT NULL,
    CHECK (budget > 0)
);

DROP TABLE IF EXISTS operazioni;
CREATE TABLE operazioni
(
    idOperazione   INT           NOT NULL PRIMARY KEY AUTO_INCREMENT,
    data           DATE          NOT NULL,
    ora            TIME          NOT NULL,
    importo        DECIMAL(6, 2) NOT NULL,
    descrizione    VARCHAR(100)   NOT NULL,
    fk_idOperatore INT           NOT NULL,
    fk_idCliente   INT           NOT NULL,
    FOREIGN KEY (fk_idOperatore) REFERENCES operatori (idOperatore),
    FOREIGN KEY (fk_idCliente) REFERENCES clienti (idCliente),
    CHECK (importo > 0)
);

DROP TABLE IF EXISTS invia;
CREATE TABLE invia
(
    idInvia       INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fk_idCampagna INT NOT NULL,
    fk_idCliente  INT NOT NULL,
    FOREIGN KEY (fk_idCampagna) REFERENCES campagne (idCampagna),
    FOREIGN KEY (fk_idCliente) REFERENCES clienti (idCliente)
);

/*-----------------------------------------------NEW OPERATOR-------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS newOperatore;
DELIMITER
//
CREATE PROCEDURE newOperatore(param_cognome VARCHAR (50),
                              param_nome VARCHAR (50),
                              param_dataNascita DATE,
                              param_username VARCHAR (20),
                              param_email VARCHAR (50),
                              param_password VARCHAR (20))
    DETERMINISTIC
BEGIN
 SET @s = MD5(RAND());
 SET @h = SHA2(CONCAT(@s, param_password), 256);
INSERT INTO operatori(cognome, nome, dataNascita, username, email, salt, password_hash)
VALUES (param_cognome, param_nome, param_dataNascita, param_username, param_email, @s, @h);
END
//
DELIMITER ;

/*-----------------------------------------------NEW CLIENT-------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS newCliente;
DELIMITER
//
CREATE PROCEDURE newCliente(param_cognome VARCHAR (50),
                            param_nome VARCHAR (50),
                            param_dataNascita DATE,
                            param_username VARCHAR (20),
                            param_email VARCHAR (50),
                            param_password VARCHAR (20))
    DETERMINISTIC
BEGIN
 SET @s = MD5(RAND());
 SET @h = SHA2(CONCAT(@s, param_password), 256);
INSERT INTO clienti(cognome, nome, dataNascita, username, email, salt, password_hash)
VALUES (param_cognome, param_nome, param_dataNascita, param_username, param_email, @s, @h);
END
//
DELIMITER ;

/*-----------------------------------------------NEW OPERATION-------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS newOperazione;
DELIMITER
//
CREATE PROCEDURE newOperazione(param_data DATE,
                               param_ora TIME,
                               param_importo DECIMAL (7,2),
                               param_descrizione VARCHAR (50),
                               param_fk_idOperatore INT,
                               param_fk_idCliente INT)
    DETERMINISTIC
BEGIN
INSERT INTO operazioni(data, ora, importo, descrizione, fk_idOperatore, fk_idCliente)
VALUES (param_data, param_ora, param_importo, param_descrizione, param_fk_idOperatore, param_fk_idCliente);
END
//
DELIMITER ;

/*-----------------------------------------------NEW CAMPAIGN-------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS newCampagna;
DELIMITER
//
CREATE PROCEDURE newCampagna(param_nome VARCHAR (50),
                             param_descrizione VARCHAR (50),
                             param_dataScadenza DATE,
                             param_budget DECIMAL (7, 2))
    DETERMINISTIC
BEGIN
INSERT INTO campagne(nome, dataScadenza, descrizione, budget)
VALUES (param_nome, param_dataScadenza, param_descrizione, param_budget);
END
//
DELIMITER ;


/*-----------------------------------------------NEW INVIA-------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS newInvia;
DELIMITER
//
CREATE PROCEDURE newInvia(param_fk_idCampagna INT,
                          param_fk_idCliente INT)
    DETERMINISTIC
BEGIN
INSERT INTO invia(fk_idCampagna, fk_idCliente)
VALUES (param_fk_idCampagna, param_fk_idCliente);
END
//
DELIMITER ;

/* Cognome, Nome, DataN, Username, Mail, Pass */
CALL newOperatore('Enrico', 'Ferraiolo', '2002-09-29', 'opEnrico', 'enrico.ferraiolo@gmail.com', 'pwEnrico');
CALL newOperatore('Bergantin', 'Andrea', '2001-03-15', 'opAndrea', 'andrea.bergantin@gmail.com', 'pwAndrea');

/* Cognome, Nome, DataN, Username, Mail, Pass */
CALL newCliente('Sana', 'Hamza', '2000-05-12', 'Sana01', 'sanahamzaali@gmail.com', 'pwSana');
CALL newCliente('Cantoni', 'Gioele', '2002-09-13', 'Cantoni01', 'sanahamzaali1@gmail.com', 'pwSana');



/*Data, Ora, Importo, Descrizione, fk_idOperatore, fk_idCliente*/
CALL newOperazione('2021-05-23', '15:13:46', 532.00, 'Prima operazione', 1, 1);
CALL newOperazione('2021-05-24', '09:49:23', 845.00, 'Seconda operazione', 2, 1);
CALL newOperazione('2021-05-25', '11:45:58', 200.00, 'Terza operazione', 1, 2);
CALL newOperazione('2021-05-26', '14:01:16', 725.00, 'Quarta operazione', 2, 2);
CALL newOperazione('2021-05-27', '12:44:37', 623.00, 'Quinta operazione', 1, 1);
CALL newOperazione('2021-05-27', '16:59:42', 150.00, 'Sesta operazione', 1, 2);

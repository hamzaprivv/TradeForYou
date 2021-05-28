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
    email         VARCHAR(50) NOT NULL UNIQUE,
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
    email         VARCHAR(50) NOT NULL UNIQUE,
    salt          VARCHAR(32) NOT NULL,
    password_hash VARCHAR(64) NOT NULL,
    CHECK (dataNascita < CURRENT_DATE)
);

DROP TABLE IF EXISTS campagne;
CREATE TABLE campagne
(
    idCampagna   INT           NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome         VARCHAR(50)   NOT NULL UNIQUE,
    descrizione  VARCHAR(50)   NOT NULL,
    dataScadenza DATE          NOT NULL,
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
    descrizione    VARCHAR(50)   NOT NULL,
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
INSERT INTO campagne(nome, descrizione, dataScadenza, budget)
VALUES (param_nome, param_descrizione, param_dataScadenza, param_budget);
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


CALL newOperatore('opRossi', 'Rossi', 'Mario', '1990-03-20', 'rossi.mario@gmail.com', 'pwRossi');
CALL newOperatore('opBianchi', 'Bianchi', 'Marco', '1980-06-18', 'bianchi.marco@gmail.com', 'pwBianchi');

CALL newCliente('userHu', 'Hu', 'Matteo', '2002-07-29', 'hu.matteo@gmail.com', 'pwHu');
CALL newCliente('userVerdi', 'Verdi', 'Giovanni', '2002-06-03', 'verdi.giovanni@gmail.com', 'pwVerdi');

CALL newOperazione('2021-05-11', '12:00:00', 900.00, 'Descrizione operazione 1', 1, 1);
CALL newOperazione('2021-05-12', '12:30:00', 800.00, 'Descrizione operazione 2', 2, 1);
CALL newOperazione('2021-05-13', '13:00:00', 700.00, 'Descrizione operazione 3', 1, 1);
CALL newOperazione('2021-05-14', '13:30:00', 600.00, 'Descrizione operazione 4', 2, 1);
CALL newOperazione('2021-05-15', '14:00:00', 500.00, 'Descrizione operazione 5', 1, 1);
CALL newOperazione('2021-05-16', '14:30:00', 400.00, 'Descrizione operazione 6', 1, 1);
CALL newOperazione('2021-05-17', '15:00:00', 300.00, 'Descrizione operazione 7', 1, 2);
CALL newOperazione('2021-05-18', '15:30:00', 200.00, 'Descrizione operazione 8', 2, 2);

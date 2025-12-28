use comptoirDB;
------la table Clients
CREATE TABLE Clients (
    Code_Client       VARCHAR(5)  NOT NULL,
    Societe           VARCHAR(40),
    Contact           VARCHAR(40),
    Fonction          VARCHAR(40),
    Adresse           VARCHAR(60),
    Ville             VARCHAR(40),
    Region            VARCHAR(40),
    Code_Postale      VARCHAR(40),
    Pays              VARCHAR(20),
    Telephone         VARCHAR(20),
    Fax               VARCHAR(20),

    CONSTRAINT PK_Clients PRIMARY KEY (Code_Client)
);

CREATE INDEX IX_Clients_CodePostale ON Clients(Code_Postale);
CREATE INDEX IX_Clients_Societe ON Clients(Societe);

-----la table Categories
CREATE TABLE Categories (
    Code_Categorie    VARCHAR(20) NOT NULL,
    Nom_Categorie     VARCHAR(100) NOT NULL,
    Description       NVARCHAR(MAX),

    CONSTRAINT PK_Categories PRIMARY KEY (Code_Categorie),
    CONSTRAINT UQ_Categories_Nom UNIQUE (Nom_Categorie)
);

------la table Produits
CREATE TABLE Produits (
    Ref_Produit        VARCHAR(20) NOT NULL,
    Nom_Produit        VARCHAR(40) NOT NULL,
    Code_Categorie     VARCHAR(20),
    Quantite_Unite     VARCHAR(30),
    Prix_Unitaire      DECIMAL(19,4),
    Unite_Stock        INT,
    Unites_Commandees  INT,
    Niveau_Reapro      INT,
    Indisponible       INT,

    CONSTRAINT PK_Produits PRIMARY KEY (Ref_Produit),
    CONSTRAINT FK_Produits_Categories
        FOREIGN KEY (Code_Categorie)
        REFERENCES Categories(Code_Categorie)
);

CREATE INDEX IX_Produits_CodeCategorie ON Produits(Code_Categorie);
CREATE INDEX IX_Produits_NomProduit ON Produits(Nom_Produit);

-----la table Commandes
CREATE TABLE Commandes (
    Num_Commande        VARCHAR(8) NOT NULL,
    Code_Client         VARCHAR(5) NOT NULL,
    Date_Commande       DATE,
    Date_Livraison      DATE,
    Date_Envoi          DATE,
    Port                DECIMAL(10,2),
    Destination         VARCHAR(40),
    Adresse_Livraison   VARCHAR(60),
    Ville_Livraison     VARCHAR(15),
    Region_Livraison    VARCHAR(15),
    Code_Postale_Livraison VARCHAR(10),
    Pays_Livraison      VARCHAR(15),

    CONSTRAINT PK_Commandes PRIMARY KEY (Num_Commande),
    CONSTRAINT FK_Commandes_Clients
        FOREIGN KEY (Code_Client)
        REFERENCES Clients(Code_Client)
);

CREATE INDEX IX_Commandes_CodePostaleLivraison 
    ON Commandes(Code_Postale_Livraison);

CREATE INDEX IX_Commandes_DateCommande 
    ON Commandes(Date_Commande);

CREATE INDEX IX_Commandes_DateEnvoi 
    ON Commandes(Date_Envoi);

    --------Details_Commande
CREATE TABLE Details_Commande (
    Num_Commande   VARCHAR(8) NOT NULL,
    Ref_Produit    VARCHAR(20) NOT NULL,
    Quantite       INT NOT NULL,
    Remise         FLOAT,

    CONSTRAINT PK_Details_Commande 
        PRIMARY KEY (Num_Commande, Ref_Produit),

    CONSTRAINT FK_Details_Commande_Commandes
        FOREIGN KEY (Num_Commande)
        REFERENCES Commandes(Num_Commande),

    CONSTRAINT FK_Details_Commande_Produits
        FOREIGN KEY (Ref_Produit)
        REFERENCES Produits(Ref_Produit)
);

CREATE INDEX IX_Details_Commande_NumCommande 
    ON Details_Commande(Num_Commande);

CREATE INDEX IX_Details_Commande_RefProduit 
    ON Details_Commande(Ref_Produit);


    INSERT INTO Clients VALUES
('C001', 'TechCorp', 'Alice Martin', 'Manager',
 '12 Rue de Paris', 'Paris', 'Ile-de-France', '75001', 'France',
 '0102030405', '0102030406'),

('C002', 'FoodPlus', 'Amine Hassnoui', 'Buyer',
 '40 Rue de Hassan 2', 'Agadir', 'Souss -massa', '80000', 'Maroc',
 '0671000000', '0571000001'),

('C003', 'FoodPlus', 'Ahmed karim', 'Buyer',
 '45 Avenue rabat', 'rabat', 'Rabat-Agdal', '80000', 'Maroc',
 '0672000000', '0572000001');

 INSERT INTO Categories VALUES
('CAT01', 'Beverages', 'Drinks, juices, sodas'),
('CAT02', 'Snacks', 'Chips, biscuits, sweets'),
('CAT03', 'Electronics', 'Electronic devices and accessories');

INSERT INTO Produits VALUES
('P001', 'Orange Juice', 'CAT01', '1L bottle', 2.50, 100, 20, 10, 0),
('P002', 'Cola Soda', 'CAT01', '500ml bottle', 1.80, 200, 30, 15, 0),
('P003', 'Potato Chips', 'CAT02', '200g bag', 1.20, 150, 40, 20, 0),
('P004', 'USB Keyboard', 'CAT03', 'Unit', 15.00, 50, 5, 10, 0);

INSERT INTO Commandes VALUES
('CMD0001', 'C001', '2025-01-10', '2025-01-15', '2025-01-12',
 25.00, 'Paris',
 '12 Rue de Paris', 'Paris', 'Ile-de-France', '75001', 'France'),

('CMD0002', 'C002', '2025-02-05', '2025-02-10', '2025-02-07',
 18.00, 'Lyon',
 '40 Rue de Hassan 2', 'Agadir', 'Souss -massa', '80000', 'Maroc'),

 ('CMD0003', 'C003', '2025-02-15', '2025-02-20', '2025-02-17',
 18.00, 'Lyon',
 '45 Avenue rabat', 'rabat', 'Rabat-Agdal', '80000', 'Maroc');

 -- 1. Insert Orders for 2023 and 2024
-- We use 'TOP 1' to grab any valid client existing in your DB

-- Order 2023-01 (Winter)
INSERT INTO COMMANDES (NUM_COMMANDE, CODE_CLIENT, DATE_COMMANDE, DATE_LIVRAISON, DATE_ENVOI, PORT, DESTINATION)
SELECT 'CMD2301', (SELECT TOP 1 CODE_CLIENT FROM Clients), '2023-01-15', '2023-01-20', '2023-01-18', 50, 'Paris';

INSERT INTO DETAILS_COMMANDE (NUM_COMMANDE, REF_PRODUIT, QUANTITE, REMISE)
SELECT 'CMD2301', (SELECT TOP 1 REF_PRODUIT FROM PRODUITS), 10, 0;

-- Order 2023-06 (Summer)
INSERT INTO COMMANDES (NUM_COMMANDE, CODE_CLIENT, DATE_COMMANDE, DATE_LIVRAISON, DATE_ENVOI, PORT, DESTINATION)
SELECT 'CMD2302', (SELECT TOP 1 CODE_CLIENT FROM CLIENTS), '2023-06-10', '2023-06-12', '2023-06-11', 25, 'Lyon';

INSERT INTO DETAILS_COMMANDE (NUM_COMMANDE, REF_PRODUIT, QUANTITE, REMISE)
SELECT 'CMD2302', (SELECT TOP 1 REF_PRODUIT FROM PRODUITS), 50, 0.1;

-- Order 2024-03 (Spring)
INSERT INTO COMMANDES (NUM_COMMANDE, CODE_CLIENT, DATE_COMMANDE, DATE_LIVRAISON, DATE_ENVOI, PORT, DESTINATION)
SELECT 'CMD2401', (SELECT TOP 1 CODE_CLIENT FROM CLIENTS), '2024-03-22', '2024-03-30', '2024-03-25', 10, 'Marseille';

INSERT INTO DETAILS_COMMANDE (NUM_COMMANDE, REF_PRODUIT, QUANTITE, REMISE)
SELECT 'CMD2401', (SELECT TOP 1 REF_PRODUIT FROM PRODUITS), 20, 0;

-- Order 2024-12 (Christmas)
INSERT INTO COMMANDES (NUM_COMMANDE, CODE_CLIENT, DATE_COMMANDE, DATE_LIVRAISON, DATE_ENVOI, PORT, DESTINATION)
SELECT 'CMD2402', (SELECT TOP 1 CODE_CLIENT FROM CLIENTS), '2024-12-05', '2024-12-10', '2024-12-06', 100, 'Lille';

INSERT INTO DETAILS_COMMANDE (NUM_COMMANDE, REF_PRODUIT, QUANTITE, REMISE)
SELECT 'CMD2402', (SELECT TOP 1 REF_PRODUIT FROM PRODUITS), 100, 0.2;

select * from COMMANDES;
select * from DETAILS_COMMANDE;

 INSERT INTO Details_Commande VALUES
('CMD0001', 'P001', 10, 0.05),
('CMD0001', 'P003', 5, 0.00),
('CMD0002', 'P002', 20, 0.10),
('CMD0002', 'P004', 2, 0.00);

INSERT INTO Details_Commande VALUES
-- CMD0001 (Client C001)
('CMD0001', 'P001', 10, 0.05),
('CMD0001', 'P003', 5,  0.00),

-- CMD0002 (Client C002)
('CMD0002', 'P002', 20, 0.10),
('CMD0002', 'P004', 2,  0.00),

-- CMD0003 (Client C003)
('CMD0003', 'P001', 15, 0.05),
('CMD0003', 'P002', 10, 0.00);


CREATE USER talend_user FOR LOGIN talend_user;
GRANT CREATE TABLE TO talend_user;
ALTER ROLE db_datareader ADD MEMBER talend_user;
ALTER ROLE db_datawriter ADD MEMBER talend_user;

-- 1. Make 'FoodPlus' orders very fast (Delivered same day or next day)
-- We find the client code for FoodPlus and update their orders
UPDATE COMMANDES
SET DATE_LIVRAISON = DATEADD(day, 1, DATE_COMMANDE)
WHERE CODE_CLIENT IN (SELECT CODE_CLIENT FROM CLIENTS WHERE SOCIETE = 'FoodPlus');

-- 2. Make 'TechCorp' orders very slow (Delivered 20 days later)
UPDATE COMMANDES
SET DATE_LIVRAISON = DATEADD(day, 20, DATE_COMMANDE)
WHERE CODE_CLIENT IN (SELECT CODE_CLIENT FROM CLIENTS WHERE SOCIETE = 'TechCorp');
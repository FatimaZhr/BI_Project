
-- 1. Create Dimension: Client
CREATE TABLE DimClient (
    ID_Client INT IDENTITY(1,1) PRIMARY KEY, 
    CODE_CLIENT VARCHAR(5),     -- Business Key from source
    SOCIETE VARCHAR(40),
    CONTACT VARCHAR(40),
    VILLE VARCHAR(40),
    REGION VARCHAR(40),
    PAYS VARCHAR(20),
    CODE_POSTAL VARCHAR(40)
);

-- Dimension: Product
CREATE TABLE Dim_Produit (
    ID_Produit INT IDENTITY(1,1) PRIMARY KEY, -- Auto-increment ON
    REF_PRODUIT VARCHAR(20),
    NOM_PRODUIT VARCHAR(40),
    CODE_CATEGORIE VARCHAR(20),
    NOM_CATEGORIE VARCHAR(100),
    DESCRIPTION_CATEGORIE VARCHAR(255),
    PRIX_UNITAIRE DECIMAL(10,2),
    QUANTITE_UNITE VARCHAR(30)
);

-- Dimension: Time
CREATE TABLE Dim_Temps (
    ID_Temps INT IDENTITY(1,1) PRIMARY KEY, -- Auto-increment ON
    Date_Complete DATE,
    Jour INT,
    Mois INT,
    Trimestre INT,
    Annee INT
);



-- 3. RECREATE FACT TABLE
CREATE TABLE FACT_VENTES (
    ID_TEMPS INT,
    ID_CLIENT INT,
    ID_PRODUIT INT,
    quantite INT,
    remise FLOAT,
    delaiLivraison INT,
    montant DECIMAL(10,2),
    
    -- Foreign Keys link to the new tables
    FOREIGN KEY (ID_TEMPS) REFERENCES Dim_Temps(ID_Temps),
    FOREIGN KEY (ID_CLIENT) REFERENCES DimClient(ID_Client), -- Ensure DimClient exists
    FOREIGN KEY (ID_PRODUIT) REFERENCES Dim_Produit(ID_Produit)
);
create database DW_Comptoir;
use DW_Comptoir ;
drop database DW_Comptoir;
use comptoirDB;

--CREATE USER talend_user FOR LOGIN talend_user;

-- Grant the permission to CREATE tables (required for 'Drop table if exists and create' action)
GRANT CREATE TABLE TO talend_user;

-- Grant permissions to read and write data (required for inserting the results)
ALTER ROLE db_datareader ADD MEMBER talend_user;
ALTER ROLE db_datawriter ADD MEMBER talend_user;


 
-- delete from DimClient where ID_Client = 12;

 -- 1. DROP TABLES (Order is important!)
-- First, drop the Fact table (to remove the Foreign Key links)
IF OBJECT_ID('dbo.FACT_VENTES', 'U') IS NOT NULL
    DROP TABLE dbo.FACT_VENTES;

-- Now you can safely drop the Dimensions
IF OBJECT_ID('dbo.Dim_Produit', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_Produit;

IF OBJECT_ID('dbo.Dim_Temps', 'U') IS NOT NULL
    DROP TABLE dbo.Dim_Temps;

-- Note: You don't need to drop DimClient if it's already correct, 
-- but if you want a fresh start, uncomment the next two lines:
-- IF OBJECT_ID('dbo.DimClient', 'U') IS NOT NULL
--    DROP TABLE dbo.DimClient;





SELECT * FROM FACT_VENTES;
select * from Dim_Produit;
select * from Dim_Temps;
select * from DimClient;
TRUNCATE TABLE FACT_VENTES;

CREATE VIEW VW_DataMining AS
SELECT
    C.SOCIETE,
    C.VILLE,
    P.NOM_PRODUIT,
    P.NOM_CATEGORIE,
    T.Annee,
    T.Mois,
    F.quantite,
    F.montant,
    F.delaiLivraison
FROM FACT_VENTES F
JOIN DimClient  C ON F.ID_CLIENT  = C.ID_Client
JOIN Dim_Produit P ON F.ID_PRODUIT = P.ID_Produit
JOIN Dim_Temps   T ON F.ID_TEMPS   = T.ID_Temps;


SELECT 
    SOCIETE,
    AVG(delaiLivraison) AS Moyenne_Delai
FROM VW_DataMining
GROUP BY SOCIETE;

SELECT 
    f.ID_TEMPS as OrderID, 
    p.NOM_PRODUIT as Product
FROM FACT_VENTES f
JOIN Dim_Produit p ON f.ID_PRODUIT = p.ID_Produit
ORDER BY f.ID_TEMPS;
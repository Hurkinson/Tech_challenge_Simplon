import pandas as pd
import sqlite3
import os

if 'custom' not in globals():
    from mage_ai.data_preparation.decorators import custom
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@custom
def transform_custom(*args, **kwargs):
    """
    Créé des vues dans SQLITE DB:

        - ventes_par_jour
        - ca_total
        - ventes_par_produit
        - ventes_par_ville

    """

    db_path = '/shared_data/database.db'
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

#----- ventes_par_jour ------------------------------------------------------

    cursor.execute('''
        DROP VIEW IF EXISTS ventes_par_jour;
    ''')

    cursor.execute('''
        CREATE VIEW ventes_par_jour AS
        SELECT 
            ventes.date, 
            SUM(ventes.quantite) AS total_article, 
            SUM(ventes.quantite*produits.prix) AS total_CA
        FROM ventes
        JOIN "produits" ON ventes.id_reference_produit = produits.id_reference_produit
        GROUP BY ventes.date;
    ''')

#------ ca_total -----------------------------------------------------

    cursor.execute('''
        DROP VIEW IF EXISTS ca_total;
    ''')

    cursor.execute('''
        CREATE VIEW ca_total AS
        SELECT 
            SUM(ventes.quantite*produits.prix) AS total_CA
        FROM ventes
        JOIN "produits" ON ventes.id_reference_produit = produits.id_reference_produit;
    ''')

#------- ventes_par_produit ----------------------------------------------------

    cursor.execute('''
        DROP VIEW IF EXISTS ventes_par_produit;
    ''')

    cursor.execute('''
        CREATE VIEW ventes_par_produit AS
        SELECT  
            produits.nom,
            SUM(ventes.quantite) AS total_article, 
            SUM(ventes.quantite*produits.prix) AS total_CA
        FROM ventes
        JOIN "produits" ON ventes.id_reference_produit = produits.id_reference_produit
        GROUP BY produits.nom;
    ''')

#-------- ventes_par_ville ---------------------------------------------------

    cursor.execute('''
        DROP VIEW IF EXISTS ventes_par_ville;
    ''')

    cursor.execute('''
        CREATE VIEW ventes_par_ville AS
        SELECT 
            magasins.ville, 
            SUM(ventes.quantite) AS total_article, 
            SUM(ventes.quantite*produits.prix) AS total_CA
        FROM ventes
        JOIN "produits" ON ventes.id_reference_produit = produits.id_reference_produit
        JOIN "magasins" ON ventes.id_magasin = magasins.id_magasin
        GROUP BY magasins.ville;
    ''')


    conn.commit()
    conn.close()
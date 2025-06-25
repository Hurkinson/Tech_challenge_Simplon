import pandas as pd
import sqlite3
import os

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data(data, *args, **kwargs):
    """
    Exports data to SQLITE DB.

    Args:
        data: The output from the upstream parent block
        args: The output from any additional upstream blocks (if applicable)

    Output (optional):
        Optionally return any object and it'll be logged and
        displayed when inspecting the block run.
    """

    db_path = '/shared_data/database.db'
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute('''
        DROP TABLE IF EXISTS magasins;
    ''')
    cursor.execute('''
        CREATE TABLE magasins (
            'id_magasin' INTEGER PRIMARY KEY NOT NULL,
            'ville' TEXT,
            'nombre_de_salaries' INT
        );
    ''')

    cursor.execute('''
        DROP TABLE IF EXISTS produits;
    ''')
    cursor.execute('''
        CREATE TABLE produits (
            'id_reference_produit' TEXT PRIMARY KEY NOT NULL,
            'nom' TEXT,
            'prix' REAL,
            'stock' INTEGER
        );
    ''')

    cursor.execute('''
        DROP TABLE IF EXISTS ventes;
    ''')
    cursor.execute('''
        CREATE TABLE ventes (
            'id_vente' INTEGER PRIMARY KEY NOT NULL,
            'date' DATETIME,
            'id_reference_produit' TEXT,
            'quantite' INTEGER,
            'id_magasin' INTEGER
        );
    ''')

    data['magasins'].to_sql('magasins', conn, if_exists='append', index=False)
    data['produits'].to_sql('produits', conn, if_exists='append', index=False)
    data['ventes'].to_sql('ventes', conn, if_exists='append', index=False)


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


    conn.commit()
    conn.close()


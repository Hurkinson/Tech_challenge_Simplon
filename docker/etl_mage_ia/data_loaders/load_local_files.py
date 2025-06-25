import pandas as pd
import os

from mage_ai.io.file import FileIO
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_file(*args, **kwargs):
    """
    Charge les 3 fichiers CSV dans le pipeline
    """
    data_dir = '/project_data'

    files = {
        'magasins': os.path.join(data_dir, 'magasins.csv'),
        'produits': os.path.join(data_dir, 'produits.csv'),
        'ventes': os.path.join(data_dir, 'ventes.csv'),
    }

    dfs = {}

    for table_name, filepath in files.items():
        df = pd.read_csv(filepath)
        
        dfs[table_name] = df

    

    return dfs


@test
def test_output(output, *args) -> None:
    """
    Vérifie que les 3 tables ont bien été chargées.
    """
    assert isinstance(output, dict), 'Le retour doit être un dictionnaire'
    for name in ['magasins', 'produits', 'ventes']:
        assert name in output, f"La table {name} est manquante"
        assert not output[name].empty, f"La table {name} est vide"


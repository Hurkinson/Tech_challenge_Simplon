if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    """
    Formate les données en entrée afin de correspondre à la modelisation déterminée:

        - création d'un clef primaire pour la tabele des ventes.
        - formate les noms de colonne en snake case pour une meilleur compatibilité entre les différents standards de bdd.

    Args:
        data: The output from the upstream parent block
        args: The output from any additional upstream blocks (if applicable)

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """

    # création d'un clef primaire pour la table des ventes
    data['ventes']['ID Vente'] = data['ventes'].index+1

    # standardisation des noms de colonnes en snake case
    data['produits'].rename(columns={
                        'Nom': 'nom',
                        'Prix': 'prix',
                        'ID Référence produit': 'id_reference_produit',
                        'Stock': 'stock',
                        }, inplace=True)

    data['magasins'].rename(columns={
                    'ID Magasin': 'id_magasin',
                    'Ville': 'ville',
                    'Nombre de salariés': 'nombre_de_salaries',
                    }, inplace=True)

    data['ventes'].rename(columns={
                    'ID Vente': 'id_vente',
                    'Date': 'date',
                    'ID Référence produit': 'id_reference_produit',
                    'Quantité': 'quantite',
                    'ID Magasin': 'id_magasin'
                    }, inplace=True)

    

    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'

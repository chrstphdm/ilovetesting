import pytest
from pathlib import Path
from filter_and_summarise import filter_by_threshold, summarise_by_group, process
from parse_records import load_records

DATA = Path("training/data")


def test_filtre_reduit_les_lignes():
    df = load_records(DATA / "records.tsv")
    result = filter_by_threshold(df, threshold=45)
    assert len(result) < len(df)          # quelque chose a été filtré... mais combien ?


def test_stats_ont_deux_groupes():
    df = load_records(DATA / "records.tsv")
    filtered = filter_by_threshold(df, threshold=45)
    result = summarise_by_group(filtered)
    assert len(result) == 2               # passe sur Series ET DataFrame — type non vérifié


def test_seuil_trop_haut_lève_erreur():
    with pytest.raises(ValueError):
        process(DATA / "records.tsv", threshold=999)


def test_fichier_inexistant():
    with pytest.raises(FileNotFoundError):
        process(DATA / "missing.tsv")


def test_happy_path():
    result = process(DATA / "records.tsv")
    assert result is not None             # le process tourne... mais que produit-il vraiment ?

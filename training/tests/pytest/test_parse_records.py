import pytest
import pandas as pd
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parents[2] / "pipelines" / "minimal" / "scripts"))
from parse_records import load_records, validate_records

DATA = Path(__file__).parents[2] / "data"


def test_load_valid_file():
    df = load_records(DATA / "records.tsv")
    assert isinstance(df, pd.DataFrame)
    assert df.shape == (20, 3)
    assert list(df.columns) == ["id", "group", "value"]


def test_load_missing_file():
    with pytest.raises(FileNotFoundError, match="not found"):
        load_records("/tmp/does_not_exist_xyz.tsv")


def test_load_empty_file():
    with pytest.raises(ValueError, match="no data rows"):
        load_records(DATA / "empty.tsv")


def test_validate_ok():
    df = load_records(DATA / "records.tsv")
    validate_records(df)


def test_validate_non_numeric_value():
    df = load_records(DATA / "invalid_records.tsv")
    with pytest.raises(ValueError, match="numeric"):
        validate_records(df)


def test_validate_duplicate_ids():
    df = load_records(DATA / "duplicated_records.tsv")
    with pytest.raises(ValueError, match="Duplicate"):
        validate_records(df)


def test_all_values_non_negative():
    df = load_records(DATA / "records.tsv")
    assert (df["value"] >= 0).all()

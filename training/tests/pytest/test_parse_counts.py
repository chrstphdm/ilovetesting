import pytest
import pandas as pd
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parents[2] / "pipelines" / "minimal" / "scripts"))
from parse_counts import load_counts, validate_counts

DATA = Path(__file__).parents[2] / "data"
SAMPLES = ["sample1", "sample2", "sample3", "sample4"]


def test_load_valid_file():
    df = load_counts(DATA / "counts.tsv")
    assert isinstance(df, pd.DataFrame)
    assert df.shape == (20, 4)
    assert list(df.columns) == SAMPLES


def test_load_missing_file():
    with pytest.raises(FileNotFoundError, match="not found"):
        load_counts("/tmp/does_not_exist_xyz.tsv")


def test_validate_ok():
    df = load_counts(DATA / "counts.tsv")
    validate_counts(df, SAMPLES)


def test_validate_missing_column():
    df = load_counts(DATA / "counts.tsv")
    with pytest.raises(ValueError, match="Missing columns"):
        validate_counts(df, SAMPLES + ["phantom_sample"])


def test_validate_negative_values():
    df = load_counts(DATA / "bad_counts.tsv")
    with pytest.raises(ValueError, match="Negative counts"):
        validate_counts(df, list(df.columns))


def test_all_values_non_negative_in_valid_file():
    df = load_counts(DATA / "counts.tsv")
    assert (df >= 0).all().all()

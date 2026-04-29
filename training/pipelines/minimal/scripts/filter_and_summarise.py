from pathlib import Path
import pandas as pd
from parse_records import load_records, validate_records


def filter_by_threshold(df: pd.DataFrame, threshold: int = 45) -> pd.DataFrame:
    return df[df["value"] > threshold]          # BUG 1 : devrait être >=


def summarise_by_group(df: pd.DataFrame) -> pd.Series:
    return df.groupby("group")["value"].mean()  # BUG 3 : retourne Series, pas DataFrame


def process(path: str, threshold: int = 45):
    df = load_records(path)
    validate_records(df)
    filtered = filter_by_threshold(df, threshold)
    if filtered.empty:
        raise ValueError(f"No records above threshold {threshold}")
    return summarise_by_group(df)               # BUG 2 : df au lieu de filtered

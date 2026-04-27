from pathlib import Path
import pandas as pd


def load_records(path: str) -> pd.DataFrame:
    p = Path(path)
    if not p.exists():
        raise FileNotFoundError(f"File not found: {path}")
    df = pd.read_csv(p, sep="\t")
    if df.empty:
        raise ValueError(f"File has no data rows: {path}")
    return df


def validate_records(df: pd.DataFrame) -> None:
    required = {"id", "group", "value"}
    missing = required - set(df.columns)
    if missing:
        raise ValueError(f"Missing columns: {missing}")
    if not pd.api.types.is_numeric_dtype(df["value"]):
        raise ValueError("Column 'value' must be numeric")
    if (df["value"] < 0).any():
        raise ValueError("Column 'value' contains negative values")
    duplicated = df[df["id"].duplicated(keep=False)]["id"].unique().tolist()
    if duplicated:
        raise ValueError(f"Duplicate ids: {duplicated}")

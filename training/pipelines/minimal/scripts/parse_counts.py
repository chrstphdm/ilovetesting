from pathlib import Path
import pandas as pd


def load_counts(path: str) -> pd.DataFrame:
    p = Path(path)
    if not p.exists():
        raise FileNotFoundError(f"File not found: {path}")
    return pd.read_csv(p, sep="\t", index_col=0)


def validate_counts(df: pd.DataFrame, required_cols: list) -> None:
    missing = [c for c in required_cols if c not in df.columns]
    if missing:
        raise ValueError(f"Missing columns: {missing}")
    if (df < 0).any().any():
        raise ValueError("Negative counts found")

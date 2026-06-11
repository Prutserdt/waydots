#!/usr/bin/env python3
import glob
import os
import sys
import time
from pathlib import Path

import numpy as np
import pandas as pd
import pyperclip

DOWNLOADS_DIR = Path.home() / "Downloads"
DEGIRO_FILE = DOWNLOADS_DIR / "Portfolio.csv"
RABO_GLOB = str(DOWNLOADS_DIR / "Portefeuille_*.csv")

OMSCHR_COL = "Omschrijving"
EUR_COL = "Euro"
AA_COL = "AA%"
AA_MIN_HUIS_COL = "AA*%"

OMSCHR_HUIS = "Overwaarde huis"
OMSCHR_CASH = "Cash (Rabo en Bunq)"


def prompt_int(label: str) -> int:
    while True:
        value = input(f"{label}: ").strip()
        try:
            return int(value)
        except ValueError:
            print("Please enter a valid integer.")


def latest_file(pattern: str) -> Path | None:
    matches = list(glob.iglob(pattern))
    return Path(max(matches, key=os.path.getctime)) if matches else None


def parse_euro_series(series: pd.Series) -> pd.Series:
    return (
        series.astype(str)
        .str.replace(".", "", regex=False)
        .str.replace(",", ".", regex=False)
        .pipe(pd.to_numeric, errors="coerce")
    )


def read_portfolio_csv(
    filename: Path,
    delimiter: str,
    column_name_map: dict[str, str],
) -> pd.DataFrame:
    try:
        raw = pd.read_csv(filename, sep=delimiter, usecols=list(column_name_map.values()))
        raw = raw.rename(columns={v: k for k, v in column_name_map.items()})

        df = raw[[OMSCHR_COL, EUR_COL]].copy()
        df[OMSCHR_COL] = df[OMSCHR_COL].astype(str)

        eur = parse_euro_series(df[EUR_COL])
        df = df.loc[eur.notna()].copy()
        df[EUR_COL] = eur.loc[df.index].astype(int)

        return df

    except FileNotFoundError:
        print(f"Error: file '{filename}' not found.")
    except pd.errors.EmptyDataError:
        print(f"Error: file '{filename}' is empty.")
    except Exception as e:
        print(f"Error while processing '{filename}': {e}")

    return pd.DataFrame(columns=[OMSCHR_COL, EUR_COL])


def format_name(name: str) -> str:
    return (
        str(name)
        .replace("Northern Trust", "NT")
        .replace("Eq I", "Eq I ")
        .strip()
    )[:20]


def border_line(df: pd.DataFrame) -> str:
    headers = list(df.columns)
    return "|-" + "-|-".join("-" * len(h) for h in headers) + "-|"


def build_org_table(df: pd.DataFrame, include_header: bool = True) -> str:
    headers = list(df.columns)
    lines = [border_line(df)]

    if include_header:
        lines.append("| " + " | ".join(headers) + " |")
        lines.append(border_line(df))

    for row in df.itertuples(index=False):
        values = ["" if pd.isna(v) else str(v) for v in row]
        lines.append("| " + " | ".join(values) + " |")

    lines.append(border_line(df))
    return "\n".join(lines)


def add_percentage_columns(
    df: pd.DataFrame,
    kapitaal: int,
    kapitaal_zonder_huis: int,
) -> pd.DataFrame:
    df = df.copy()

    df[AA_COL] = 0 if kapitaal <= 0 else np.ceil(df[EUR_COL] / kapitaal * 100).astype(int)

    if kapitaal_zonder_huis <= 0:
        df[AA_MIN_HUIS_COL] = ""
        return df

    aa_min = np.ceil(df[EUR_COL] / kapitaal_zonder_huis * 100)
    df[AA_MIN_HUIS_COL] = aa_min.astype(int).astype(str)
    df.loc[aa_min > 100, AA_MIN_HUIS_COL] = ""

    return df


def main() -> None:
    huis = prompt_int("Voer overwaarde huis in")
    rabo_cash = prompt_int("Voer Bunq en Rabo cash in")

    latest_rabo = latest_file(RABO_GLOB)
    if latest_rabo is None:
        print("Error: no Rabo portfolio CSV file found.")
        sys.exit(1)

    frames: list[pd.DataFrame] = []

    df_degiro = read_portfolio_csv(
        DEGIRO_FILE,
        ",",
        {OMSCHR_COL: "Product", EUR_COL: "Waarde in EUR"},
    )
    if not df_degiro.empty:
        frames.append(df_degiro)

    df_rabo = read_portfolio_csv(
        latest_rabo,
        ";",
        {OMSCHR_COL: "Naam", EUR_COL: "Huidig €"},
    )
    if not df_rabo.empty:
        frames.append(df_rabo)

    frames.append(
        pd.DataFrame(
            {
                OMSCHR_COL: [OMSCHR_HUIS, OMSCHR_CASH],
                EUR_COL: [huis, rabo_cash],
            }
        )
    )

    df = pd.concat(frames, ignore_index=True)
    df[OMSCHR_COL] = df[OMSCHR_COL].map(format_name)
    df = df.sort_values(EUR_COL, ascending=False).reset_index(drop=True)

    kapitaal = int(df[EUR_COL].sum())
    kapitaal_zonder_huis = kapitaal - huis

    df = add_percentage_columns(df, kapitaal, kapitaal_zonder_huis)
    df_main = df[[OMSCHR_COL, EUR_COL, AA_COL, AA_MIN_HUIS_COL]].copy().reset_index(drop=True)
    df_main.loc[df_main[OMSCHR_COL] == OMSCHR_HUIS, AA_MIN_HUIS_COL] = ""

    df_summary = pd.DataFrame(
        {
            OMSCHR_COL: ["Assets totaal", "Assets totaal - huis"],
            EUR_COL: [kapitaal, kapitaal_zonder_huis],
        }
    )

    tstamp = time.strftime("%Y-%m-%d", time.localtime(os.path.getctime(DEGIRO_FILE)))
    title = f"*** <{tstamp}> Assets(zonder huis): {kapitaal_zonder_huis} Euro.\n\n"
    org_name = f"#+NAME: tbl_{tstamp}\n"

    output = (
        title
        + org_name
        + build_org_table(df_main)
        + "\n\n"
        + build_org_table(df_summary, include_header=False)
        + "\n"
    )

    pyperclip.copy(output)
    print("\nCopied org table to clipboard and printed below:\n")
    print(output)


if __name__ == "__main__":
    main()

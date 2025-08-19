import json
import pprint
import pathlib
from typing import Any

WD = pathlib.Path(__file__)
DATA_DIR = WD.parents[1].joinpath("data")


def parse_summary_unstructured(infile: str) -> dict[str, Any]:
    with open(infile, "rt") as fh:
        data = {}
        current_categ = None
        for line in fh:
            line = line.strip()
            if not line:
                continue

            if line.endswith(":"):
                current_categ = line.strip(":")
                data[current_categ] = {}
            elif line.startswith("Structural error"):
                current_categ = "Structural error"
                _, number = line.split("\t")
                data[current_categ] = {"Total": int(number)}
            else:
                key, value = line.split("\t")
                if value.isdigit():
                    value = int(value)
                else:
                    value = float(value)
                data[current_categ][key] = value
        
        return data

def parse_summary_structured(infile: str) -> dict[str, Any]:
    with open(infile, "rt") as fh:
        return json.load(fh)

def main():
    summary_unstructured = parse_summary_unstructured(
        DATA_DIR.joinpath("summary_statistics")
    )
    summary_structured = parse_summary_structured(
        DATA_DIR.joinpath("summary_statistics.json")
    )
    pprint.pprint(summary_structured)
    pprint.pprint(summary_unstructured)
    assert summary_structured == summary_unstructured, "Parsed files are not equal."
    print("You can also access elements more easily. Try getting the N50 from the summary_structured variable.")
    breakpoint()

if __name__ == "__main__":
    raise SystemExit(main())
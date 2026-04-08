#!/usr/bin/env python3

import json
from pathlib import Path


CLIPSE_HISTORY_PATH = Path.home() / ".config" / "clipse" / "clipboard_history.json"
ICON_EMPTY = "󰅍"
ICON_HAS_HISTORY = ""


def load_history() -> list[dict]:
    try:
        with CLIPSE_HISTORY_PATH.open(encoding="utf-8") as history_file:
            payload = json.load(history_file)
    except (FileNotFoundError, json.JSONDecodeError, OSError):
        return []

    history = payload.get("clipboardHistory", [])
    if not isinstance(history, list):
        return []

    return [entry for entry in history if isinstance(entry, dict)]


def main() -> None:
    history = load_history()
    count = len(history)

    has_history = count > 0
    icon = ICON_HAS_HISTORY if has_history else ICON_EMPTY
    css_class = "has-history" if has_history else "empty"

    print(
        json.dumps(
            {
                "text": f"{icon} {count}",
                "tooltip": f"Clipboard history: {count} item(s)",
                "class": css_class,
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()

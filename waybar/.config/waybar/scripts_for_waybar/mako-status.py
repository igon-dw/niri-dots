#!/usr/bin/env python3

import json
import subprocess
import sys

ICON_EMPTY = "󰂚"
ICON_NOTIFY = "󰂞"
ICON_DND = "󰂛"


def makoctl_list() -> list:
    try:
        r = subprocess.run(
            ["makoctl", "list", "-j"], capture_output=True, text=True, check=True
        )
        data = json.loads(r.stdout)
        return data.get("data", []) if isinstance(data, dict) else data
    except Exception:
        return []


def makoctl_mode() -> list[str]:
    try:
        r = subprocess.run(
            ["makoctl", "mode"], capture_output=True, text=True, check=True
        )
        return r.stdout.strip().split()
    except Exception:
        return []


def count_notifications(data: list) -> int:
    total = 0
    for group in data:
        if isinstance(group, list):
            total += len(group)
        elif isinstance(group, dict):
            total += 1
    return total


def main() -> None:
    try:
        notifications = makoctl_list()
        modes = makoctl_mode()
        count = count_notifications(notifications)
        is_dnd = any(m.lower() == "dnd" for m in modes)

        if is_dnd:
            icon = ICON_DND
            css_class = "dnd"
            tooltip = f"DND ON | {count} notification(s)"
            text = f'<span alpha="40%">{icon}</span>'
        elif count > 0:
            icon = ICON_NOTIFY
            css_class = "has-notifications"
            tooltip = (
                f"{count} notification(s) — Click: dismiss all, Right-click: toggle DND"
            )
            text = icon
        else:
            icon = ICON_EMPTY
            css_class = "empty"
            tooltip = "No notifications — Right-click: toggle DND"
            text = icon

        print(
            json.dumps(
                {
                    "text": text,
                    "tooltip": tooltip,
                    "class": css_class,
                },
                ensure_ascii=False,
            )
        )
    except Exception as e:
        print(
            json.dumps(
                {
                    "text": ICON_EMPTY,
                    "tooltip": str(e),
                    "class": "mako-error",
                },
                ensure_ascii=False,
            )
        )


if __name__ == "__main__":
    main()

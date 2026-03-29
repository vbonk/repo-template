#!/usr/bin/env python3
"""Validate JSON/JSONC files. Strips single-line (//) and block (/* */) comments
before parsing, so devcontainer.json and .vscode/*.json with template comments
are accepted as valid."""

import json
import sys


def strip_jsonc_comments(text):
    """Strip JSONC comments from text, respecting string boundaries."""
    result = []
    i = 0
    in_string = False
    while i < len(text):
        c = text[i]
        if in_string:
            # Handle escape sequences inside strings
            if c == "\\" and i + 1 < len(text):
                result.append(c)
                result.append(text[i + 1])
                i += 2
                continue
            if c == '"':
                in_string = False
            result.append(c)
        else:
            if c == '"':
                in_string = True
                result.append(c)
            elif c == "/" and i + 1 < len(text) and text[i + 1] == "/":
                # Single-line comment: skip to end of line
                while i < len(text) and text[i] != "\n":
                    i += 1
                continue
            elif c == "/" and i + 1 < len(text) and text[i + 1] == "*":
                # Block comment: skip to */
                i += 2
                while i + 1 < len(text) and not (text[i] == "*" and text[i + 1] == "/"):
                    i += 1
                i += 2  # skip the closing */
                continue
            else:
                result.append(c)
        i += 1
    return "".join(result)


def main():
    if len(sys.argv) < 2:
        print("Usage: validate-jsonc.py <file.json> [file2.json ...]")
        sys.exit(1)

    errors = 0
    for path in sys.argv[1:]:
        try:
            with open(path, encoding="utf-8") as f:
                text = f.read()
            cleaned = strip_jsonc_comments(text)
            json.loads(cleaned)
            print(f"OK: {path}")
        except (json.JSONDecodeError, OSError) as e:
            print(f"FAIL: {path} — {e}")
            errors += 1

    if errors:
        sys.exit(1)


if __name__ == "__main__":
    main()

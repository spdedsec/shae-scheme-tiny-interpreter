#!/usr/bin/env bash
# scripts/install.sh — shae-scheme-tiny-interpreter
#
# Installs and runs the tiny Scheme interpreter.
#
# Requirements:
#   - A Scheme implementation (Guile is tested and recommended).
#
# Usage:
#   ./scripts/install.sh          # check requirements and start the REPL
#   guile src/interpreter.scm     # start the REPL directly
set -euo pipefail

PROG="guile"
SRC="src/interpreter.scm"

echo "==> shae-scheme-tiny-interpreter installer"
echo

if ! command -v "$PROG" >/dev/null 2>&1; then
  echo "error: '$PROG' is not installed."
  echo "       Install Guile (e.g. 'sudo apt install guile-3.0' or 'brew install guile')"
  echo "       then run:  guile $SRC"
  exit 1
fi

echo "ok: $PROG found ($(command -v "$PROG"))"
echo "ok: source present at $SRC"
echo
echo "==> Starting the REPL. Type expressions at the 'scheme> ' prompt."
echo "==> Press Ctrl-D (EOF) to quit."
echo
guile "$SRC"

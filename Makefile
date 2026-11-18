# Makefile — shae-scheme-tiny-interpreter
#
# Targets:
#   make build   — confirm the Scheme toolchain is available
#   make test    — run a smoke test through the interpreter
#   make release — reminder that releases are cut via GitHub Actions
#   make clean   — remove bytecode cache
#
# This interpreter is interpreted (Guile), so there is no compilation step.

SHELL := /usr/bin/env bash
GUILE ?= guile
SRC := src/interpreter.scm

.PHONY: build test release clean

build:
	@echo "==> Checking toolchain"
	@if command -v $(GUILE) >/dev/null 2>&1; then \
		echo "ok: $(GUILE) found at $$(command -v $(GUILE))"; \
		$(GUILE) --version | head -1; \
	else \
		echo "error: $(GUILE) is not installed"; \
		exit 1; \
	fi
	@echo "ok: no compilation step required (interpreted Scheme)"

test:
	@echo "==> Running interpreter smoke test"
	@out=$$(printf "(+ 1 2 3)\n(define sq (lambda (x) (* x x)))\n(sq 5)\n(let ((x 4)) (* x x))\n(cond ((= 1 0) 'zero) (else 'done))\n" | $(GUILE) --no-auto-compile $(SRC) 2>/dev/null); \
	echo "$$out"; \
	echo "$$out" | grep -q "=> 6" && \
	echo "$$out" | grep -q "=> 25" && \
	echo "$$out" | grep -q "=> 16" && \
	echo "$$out" | grep -q "=> done" && \
	echo "ok: smoke test passed" || { echo "fail: smoke test"; exit 1; }

release: test
	@echo "==> Release"
	@echo "This project is interpreted; there are no build artifacts to ship."
	@echo "Create the GitHub release v0.1.0 via .github/workflows/release.yml."

clean:
	@rm -rf ~/.cache/guile/ccache/* 2>/dev/null || true
	@echo "ok: cleaned guile bytecode cache"

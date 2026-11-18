# shae-scheme-tiny-interpreter (Deutsch)

Ein kleiner Scheme-Interpreter (R5RS/R7RS-Stil), geschrieben in Scheme, mit
einer Read-Eval-Print-Loop (REPL), die die Eingabeaufforderung `scheme> `
zeigt. Teil der SHAE Tier 3 Serie.

## Funktionen

- REPL mit `scheme> ` Aufforderung
- Arithmetik: `+ - * /`
- Vergleiche: `= < >`
- `cons`, `car`, `cdr`, `list`
- `quote`
- `eval`, `apply`
- `define`, `lambda`, `let`, `if`, `cond`
- Einfache Fehlerbehandlung (Laufzeitfehler werden abgefangen und gemeldet;
  der REPL bleibt bestehen)

## Voraussetzungen

- Eine Scheme-Implementierung. Guile wird empfohlen und getestet.

## Installation

```bash
./scripts/install.sh
```

Oder direkt ausführen:

```bash
guile src/interpreter.scm
```

## Verwendung

```
scheme> (+ 1 2 3)
=> 6
scheme> (define square (lambda (x) (* x x)))
=> 25
scheme> (square 5)
=> 25
scheme> (let ((x 10) (y 20)) (+ x y))
=> 30
scheme> (if (= 1 1) 'yes 'no)
=> yes
```

Beenden mit Strg-D (EOF).

## Lizenz

MIT. Siehe `LICENSE`.

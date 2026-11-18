# shae-scheme-tiny-interpreter

A tiny Scheme interpreter (R5RS/R7RS style) written in Scheme, with a
read-eval-print loop that shows a `scheme> ` prompt. Part of the SHAE Tier 3
series, built on the SHAE field manual design system.

## Features

- REPL with `scheme> ` prompt
- Arithmetic: `+ - * /`
- Comparison: `= < >`
- `cons`, `car`, `cdr`, `list`
- `quote`
- `eval`, `apply`
- `define`, `lambda`, `let`, `if`, `cond`
- Basic error handling (runtime errors are caught and reported; the REPL survives)

## Requirements

- A Scheme implementation. Guile is tested and recommended.

## Install

```bash
./scripts/install.sh
```

Or run the interpreter directly:

```bash
guile src/interpreter.scm
```

## Usage

Start the REPL and type expressions:

```
shae-scheme-tiny-interpreter tiny-0.1.0
Type expressions; press Ctrl-D (EOF) to quit.

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
scheme> (cond ((= 1 0) 'zero) ((< 2 1) 'neg) (else 'positive))
=> positive
scheme> (quote (a b c))
=> (a b c)
scheme> (cons 1 (cons 2 (cons 3 ())))
=> (1 2 3)
scheme> (apply + '(1 2 3 4))
=> 10
scheme> (define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))
=> 1
scheme> (fact 5)
=> 120
scheme> (/ 10 0)
error: divide
scheme>
```

Press Ctrl-D (EOF) to quit.

## Project structure

```
src/interpreter.scm   # the interpreter (Scheme)
scripts/install.sh    # install / run instructions
Makefile              # build / test / release targets
DESIGN.md             # design system applied
README.md             # this file
.github/workflows/release.yml
LICENSE               # MIT
docs/DE.md            # German
docs/ES.md            # Spanish
```

## Design

See `DESIGN.md` for how the SHAE field manual design system is applied to this
command-line tool (typography, spacing, restraint).

## License

MIT. See `LICENSE`.

# shae-scheme-tiny-interpreter (Español)

Un pequeño intérprete de Scheme (estilo R5RS/R7RS) escrito en Scheme, con un
bucle REPL que muestra el aviso `scheme> `. Parte de la serie SHAE Tier 3.

## Características

- REPL con aviso `scheme> `
- Aritmética: `+ - * /`
- Comparación: `= < >`
- `cons`, `car`, `cdr`, `list`
- `quote`
- `eval`, `apply`
- `define`, `lambda`, `let`, `if`, `cond`
- Manejo básico de errores (los errores de tiempo de ejecución se capturan e
  informan; el REPL continúa)

## Requisitos

- Una implementación de Scheme. Se recomienda y prueba Guile.

## Instalación

```bash
./scripts/install.sh
```

O ejecutar directamente:

```bash
guile src/interpreter.scm
```

## Uso

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

Salir con Ctrl-D (EOF).

## Licencia

MIT. Véase `LICENSE`.

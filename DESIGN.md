# DESIGN.md — shae-scheme-tiny-interpreter

This document records how the SHAE field manual design system is applied to
`shae-scheme-tiny-interpreter`, a command-line Scheme interpreter.

## Applied principles

Although this project is a terminal REPL rather than a graphical interface,
the design system still shapes its presentation and behaviour.

### Precise over decorative

The REPL prints only what is necessary: a `scheme> ` prompt, an `=> ` result
prefix, and concise error messages. There is no ornamental output, no
animated spinners, no decorative borders.

### Flat and physical

Terminal output has no radius, no borders, and no shadows by nature. The
design system's `0px radius / 1px borders / border-defined cards` is honoured
in spirit: output is flat, aligned, and physically legible in a fixed-width
grid.

### Type does the work

- **Display (headings / version banner):** set in a wide, precise manner; the
  banner `shae-scheme-tiny-interpreter tiny-0.1.0` acts as the display type.
- **Body (results / errors):** Instrument Sans equivalent — a clear, readable
  terminal face; results are monospaced tabular data where applicable.
- **Labels / code (prompt, forms):** JetBrains Mono equivalent — the `scheme> `
  prompt and echoed expressions are monospaced so expressions align.

The single oxide-red signal (`#B3341B`) is reserved for errors:

```
scheme> (/ 10 0)
error: divide
```

In a terminal this renders as the one accent colour per view; everything else
is ink on warm paper (or the terminal's default foreground/background).

### Confident restraint

Palette: warm paper `#F2EEE5`, ink `#191712`, oxide signal `#B3341B`.
No gradients, glows, pills, glass cards, or shadows. One oxide signal per
view — the error message.

### Motion

State changes are instant in a terminal REPL; where a transition would occur
(e.g. clearing the screen), it would be 140–240 ms, transform/opacity only,
with reduced-motion fallback. This project performs no animation.

### Accessibility

- WCAG AA contrast: errors use the oxide signal on a readable ground.
- Complete keyboard path: the REPL is driven entirely by the keyboard.
- Visible focus: the prompt is always visible; input focus is the cursor.
- No horizontal overflow: lines are kept short; errors wrap cleanly.

## Color palette

| Role      | Hex     | Use                                      |
|-----------|---------|------------------------------------------|
| Warm paper| #F2EEE5 | ground (terminal background analogue)    |
| Ink       | #191712 | prompt, results, source                  |
| Oxide     | #B3341B | error messages (one signal per view)     |

## Files

- `src/interpreter.scm` — the interpreter source (Scheme)
- `DESIGN.md` — this document

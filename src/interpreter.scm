;;; shae-scheme-tiny-interpreter
;;; A tiny Scheme interpreter (R5RS/R7RS style) written in Scheme.
;;;
;;; Features:
;;;   - read-eval-print loop with "scheme> " prompt
;;;   - arithmetic: + - * /, comparison: = < >
;;;   - cons / car / cdr, list, quote, eval, apply
;;;   - define, lambda, let, if, cond
;;;   - basic error handling (runtime errors are caught and reported)
;;;
;;; Usage:
;;;   guile src/interpreter.scm
;;;
;;; Examples:
;;;   scheme> (+ 1 2 3)
;;;   => 6
;;;   scheme> (define square (lambda (x) (* x x)))
;;;   => 25   (the defined value is echoed)
;;;   scheme> (square 5)
;;;   => 25
;;;   scheme> (let ((x 10) (y 20)) (+ x y))
;;;   => 30

(define (scheme-version) "tiny-0.1.0")

;; ============================================================
;; Environment
;; An environment is a list of frames. A frame is an association list
;; of (variable . value) pairs.
;; ============================================================

(define (extend-env vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (map cons vars vals) base-env)
      (error "extend-env: argument count mismatch")))

(define (lookup-variable-value var env)
  (define (scan-frame frame)
    (cond ((null? frame) #f)
          ((eq? var (caar frame)) (cdar frame))
          (else (scan-frame (cdr frame)))))
  (define (scan-env env)
    (cond ((null? env) (error "unbound variable: " var))
          (else (let ((found (scan-frame (car env))))
                  (if found
                      found
                      (scan-env (cdr env)))))))
  (scan-env env))

(define (define-variable! var val env)
  (set-car! env (cons (cons var val) (car env))))

(define (set-variable-value! var val env)
  (define (scan-frame frame)
    (cond ((null? frame) #f)
          ((eq? var (caar frame)) (begin (set-cdr! (car frame) val) #t))
          (else (scan-frame (cdr frame)))))
  (define (scan-env env)
    (cond ((null? env) (error "unbound variable in set!: " var))
          (else (or (scan-frame (car env))
                    (scan-env (cdr env))))))
  (scan-env env))

;; ============================================================
;; Primitive procedures
;; ============================================================

(define (primitive? proc)
  (and (pair? proc) (eq? (car proc) 'primitive)))

(define (primitive-implementation proc) (cdr proc))

(define (make-primitive proc) (cons 'primitive proc))

(define primitive-environment
  (let ((names '(+ - * / = < > equal? null? number? symbol? pair? list? not
                 cons car cdr list display newline))
        (impls (list + - * / = < > equal? null? number? symbol? pair? list? not
                     cons car cdr list display newline)))
    (map cons names (map make-primitive impls))))

(define the-global-environment
  (cons primitive-environment '()))

;; ============================================================
;; Syntactic form recognisers
;; ============================================================

(define (self-evaluating? exp)
  (cond ((null? exp) #t)
        ((number? exp) #t)
        ((string? exp) #t)
        ((boolean? exp) #t)
        ((char? exp) #t)
        (else #f)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp) (and (pair? exp) (eq? (car exp) 'quote)))
(define (text-of-quotation exp) (cadr exp))

(define (assignment? exp) (and (pair? exp) (eq? (car exp) 'set!)))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (definition? exp) (and (pair? exp) (eq? (car exp) 'define)))
(define (definition-variable exp) (cadr exp))
(define (definition-value exp) (caddr exp))

(define (lambda? exp) (and (pair? exp) (eq? (car exp) 'lambda)))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (let? exp) (and (pair? exp) (eq? (car exp) 'let)))
(define (let-parameters exp) (map car (cadr exp)))
(define (let-arguments exp) (map cadr (cadr exp)))
(define (let-body exp) (cddr exp))

(define (if? exp) (and (pair? exp) (eq? (car exp) 'if)))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (null? (cdddr exp)) #f (cadddr exp)))

(define (cond? exp) (and (pair? exp) (eq? (car exp) 'cond)))

(define (eval-form? exp) (and (pair? exp) (eq? (car exp) 'eval)))
(define (eval-form-expression exp) (cadr exp))
(define (eval-form-environment exp) (caddr exp))

(define (apply-form? exp) (and (pair? exp) (eq? (car exp) 'apply)))
(define (apply-form-procedure exp) (cadr exp))
(define (apply-form-args exp) (caddr exp))

(define (sequence? exp) (and (pair? exp) (eq? (car exp) 'begin)))
(define (sequence-exps exp) (cdr exp))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (true? x) (not (eq? x #f)))

;; ============================================================
;; Procedures
;; ============================================================

(define (make-procedure parameters body environment)
  (list 'procedure parameters body environment))

(define (compound? proc)
  (and (pair? proc) (eq? (car proc) 'procedure)))

(define (procedure-parameters proc) (cadr proc))
(define (procedure-body proc) (caddr proc))
(define (procedure-environment proc) (cadddr proc))

(define (procedure-apply proc args)
  (cond ((primitive? proc)
         (apply (primitive-implementation proc) args))
        ((compound? proc)
         (eval-sequence (procedure-body proc)
                        (extend-env (procedure-parameters proc)
                                    args
                                    (procedure-environment proc))))
        (else (error "not a procedure: " proc))))

;; ============================================================
;; Evaluator
;; ============================================================

(define (eval-sequence exps env)
  (cond ((null? exps) (error "empty sequence"))
        ((null? (cdr exps)) (eval (car exps) env))
        (else (eval (car exps) env)
              (eval-sequence (cdr exps) env))))

(define (list-of-values exps env)
  (if (null? exps)
      (list)
      (cons (eval (car exps) env)
            (list-of-values (cdr exps) env))))

(define (cond->if exp)
  (let expand ((clauses (cdr exp)))
    (cond ((null? clauses) #f)
          ((eq? (caar clauses) 'else)
           (if (null? (cdr clauses))
               (cons 'begin (cdar clauses))
               (error "cond: else clause not last")))
          (else (list 'if
                      (caar clauses)
                      (cons 'begin (cdar clauses))
                      (expand (cdr clauses)))))))

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp)
         (let ((val (eval (assignment-value exp) env)))
           (set-variable-value! (assignment-variable exp) val env)
           val))
        ((definition? exp)
         (let ((val (eval (definition-value exp) env)))
           (define-variable! (definition-variable exp) val env)
           val))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((let? exp)
         (eval (cons (cons 'lambda
                         (cons (let-parameters exp)
                               (let-body exp)))
                     (let-arguments exp))
               env))
        ((if? exp)
         (if (true? (eval (if-predicate exp) env))
             (eval (if-consequent exp) env)
             (eval (if-alternative exp) env)))
        ((cond? exp)
         (eval (cond->if exp) env))
        ((eval-form? exp)
         (eval (eval (eval-form-expression exp) env)
               (eval (eval-form-environment exp) env)))
        ((apply-form? exp)
         (let ((proc (eval (apply-form-procedure exp) env))
               (args (eval (apply-form-args exp) env)))
           (procedure-apply proc args)))
        ((sequence? exp)
         (eval-sequence (sequence-exps exp) env))
        ((pair? exp)
         (procedure-apply (eval (operator exp) env)
                          (list-of-values (operands exp) env)))
        (else (error "unknown expression type: " exp))))

;; ============================================================
;; Driver / REPL
;; ============================================================

(define (prompt) (display "scheme> "))

(define (driver-loop)
  (prompt)
  (let ((exp (read)))
    (cond ((eof-object? exp)
           (newline)
           (display "goodbye.\n"))
          (else
           (let ((result (catch #t
                             (lambda () (eval exp the-global-environment))
                             (lambda (key . rest)
                               (display "error: ")
                               (if (pair? rest)
                                   (display (car rest))
                                   (display "unknown error"))
                               (newline)
                               '(error)))))
             (if (and (pair? result) (eq? (car result) 'error))
                 (driver-loop)
                 (begin (display "=> ")
                        (write result)
                        (newline)
                        (driver-loop))))))))

(display "shae-scheme-tiny-interpreter ")(display (scheme-version))(newline)
(display "Type expressions; press Ctrl-D (EOF) to quit.")(newline)
(newline)
(driver-loop)

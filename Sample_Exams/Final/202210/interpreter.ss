;; I'd like you to add new syntax to your 304 interpreter.  I
;; reccommend you use your 17a interpreter, as set and define are
;; required for this feature.

;; This syntax is called unbind.  Here's an example:

;; (let ((+ *)) (unbind (+) (+ 3 3)))) ;; yields 6

;; unbind removes a variable binding, causing the variable to use the
;; global binding within the boundaries of the unbind.  Unbind unbinds
;; any number of bindings - i.e. it always maps the variable to global
;; binding, regardless of how many nested environment contain a
;; binding for the variable in the current env.

;; You can unbind several variables at once, but the "body" of the
;; unbind only allows one expression.

;; allowed:
;; (unbind (unbound1 unbound2) body)

;; not allowed:
;; (unbind (x) body1 body2)

;; If the unbound variable does not have a global mapping, the
;; unbinding is still legal but any access to that variable should
;; error as any ordinary unknown variable would in your scheme.  Note
;; that this feature is not tested by the test cases.  Example (not an
;; illegal use of unbind, but should error when we evaluate localvar
;; var-exp):
;;
;;(let ((localvar 7)) (unbind ((localvar)) localvar))

;; If an unbound variable is set!, it should set the global variable
;; and that new value should persist as a normal global set
;; would. Example:

;; (define myvar 7)
;; (let ((myvar 9)) (unbind (myvar) (set! myvar 100)))
;; myvar  <- yields 100 because the global was set

;; defines are still not allowed except at the top level, so no need
;; to worry about what defining a variable within the context of a
;; unbind should do.

;; Outside of the unbinding, the binding should be what it was
;; before.  Unbound variables can be bound by a let within the context
;; of the unbinding and then act bound again with that let.

;; for example:

;; (define val 7)
;; (let ((val 8))
;;   ;; here val is bound locally and equals 8
;;   (unbind (val) (begin
;;                   ;; here we use the global val 7
;;                   (let ((val 9))
;;                     ;; here we use the local val 9
;;                     (unbind (val) (begin
;;                                     ;; here we use the global val 7
;;                                     ))
;;                     ;; here we use the local val 9
;;                     )
;;                   ;; here we use the global val 7
;;                   ))
;;   ;; here we again use local binding 8
;;   )

;; One way you are not allowed to implement this feature is by using
;; an ordinary environment to bind the unbound variables to some
;; special scheme value (e.g. 'unbound) in such a way that programs in
;; your interpreter could run afoul of this feature accidentally.
;; (e.g. (let ((x 'unbound)) ..)  suddenly makes the variable unbound
;; rather than setting x to the symbol 'unbound).
;;
;; HINT: although this feature took a lot to explain it isn't too hard
;; to implement.  I suggest making a new kind of environment.

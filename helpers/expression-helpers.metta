;; helpers for Holman's boolean expression reduction functions

(= (isLiteral $atom)
    ; identifies literals like A B (NOT A)
    (if (== (get-metatype $atom) Symbol)
        True
        (let $head (car-atom $atom)
            (== $head NOT)
        )))
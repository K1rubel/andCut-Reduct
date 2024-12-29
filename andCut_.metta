;; Name:                    andCut (The Cut-Unnecessary-AND Transformation)
;; Point of application :   Any non-terminal AND node.
;; Preconditions :          The POA has an empty guard set, one child, and, for each child C of
;;                          the POA, the intersection of the guard sets of the children of C is empty.
;; Action :                 Add the POA’s grandchildren to the POA’s parent’s list of children.
;;                          Remove the POA from the POA’s parent’s list of children. Release the POA and
;;                          the POA’s child.
;; Parameters :             1. $expr, parent expression possibly containing a non-terminal AND node with empty guardset/one child
;;                          2. $poa, an AND node with empty guardset or one child
;; Examples :                   (andCut ()) 
;;  taken from Holman's book    (andCut (AND A (OR (AND (OR (AND B D) (AND (NOT E)))) (AND C)))) -> (AND A (OR (AND B D) (AND (NOT E)) (AND C)))
;;

! (register-module! ./helpers)
! (import! &self helpers:expression-helpers)

(= (andCut $expr $poa)
    (if (== $expr $poa)
        (collapse 
            (let* 
                (
                    ($child (subtraction (superpose $expr) AND))
                    ($gChildren (cdr-atom $child))
                )
                (superpose $gChildren)
            )        
        )
        (collapse 
            (let $el (superpose $expr)
                (if (isLiteral $el)
                    $el
                    (if (== $el $poa)
                        (let* 
                            (
                            ($child (subtraction (superpose $el) AND))
                            ($gChildren (cdr-atom $child))
                            )
                            (superpose $gChildren)
                        )
                    (andCut $el $poa)))))))
;; Tests

! (assertEqual 
      (andCut (AND A (AND (OR (AND B D) (AND (NOT E)))) (AND C)) (AND (OR (AND B D) (AND (NOT E)))))
              (AND A (AND B D) (AND (NOT E)) (AND C)))
;; TEST 02

! (assertEqual 
      (andCut (AND A (OR (AND (OR (AND B D) (AND (NOT E)))) (AND C))) (AND (OR (AND B D) (AND (NOT E))))) 
              (AND A (OR (AND B D) (AND (NOT E)) (AND C))))


! (assertEqual
    (andCut (AND (OR (AND B C) (AND E F))) (AND (OR (AND B C) (AND E F))))
    ((AND B C) (AND E F))
)


!(assertEqual
    (andCut (AND (OR (AND B C) (AND (NOT E) F))) (AND (OR (AND B C) (AND (NOT E) F))))
    ((AND B C) (AND (NOT E) F))
)
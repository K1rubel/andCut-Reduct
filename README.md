# andCut-Reduct
andCut boolean expression reduction transformation function as described and defined by Holman's ENF forms.


The target point of application is an AND node with no guard set (literals) or just one child (expression) in which case the AND being a binary operator, keeping the AND node is not neccessary. So the grand children are returned as child of the parent of the targetg AND node while the node itself is discarded.

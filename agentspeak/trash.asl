
/* Creencias iniciales */
adj(1,2).
adj(2,3).
adj(3,4).
located(robot,1).
located(paper,2).
located(trash,4).

/* Objetivo */
!goto(robot,4).


/* Planes */
+located(robot,X) :
    located(paper,X)
    <-
    .print("papel recogido de ", X);
    -located(paper,X);
    +busy.

+located(robot,X) :
    located(trash,X) & busy
    <-
    -busy;
    .print("papel depositado en ", X).

+!goto(robot,X) :
    located(robot,X)
    <-
    .print("robot en destino ", X).

+!goto(robot,X) :
    located(robot,Y) & not(X=Y) & adj(Y,Z)
    <-
    .print("mover de ", Y, " a ", Z);
    -+located(robot,Z);
    !goto(robot,X).
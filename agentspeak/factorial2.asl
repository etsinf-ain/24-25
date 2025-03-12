/* Objetivo inicial */
!print_fact(5).

/* Planes */
+!print_fact(N)
    <-
    !fact(N,F);
    .print("fact(5) == ", F).
    
+!fact(N,1) : N == 0.

+!fact(N,F) :
    N > 0 <-
    !fact(N-1, FF);
    F = FF * N.


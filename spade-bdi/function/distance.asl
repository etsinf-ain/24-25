// creencias iniciales
origen([15,15]).
destino([30,30]).

!start.

+!start : origen([X1,Y1]) & destino([X2,Y2])
    <-
    // .distance debe crearse como acción interna en un agente BDIAgent
    // en un fichero python separado.
    .distance(X1,Y1,X2,Y2,D);
    .print("Distance between ",X1,Y1," and ",X2,Y2," is ",D);
    .send("master@localhost", tell, dist(D)).

+halfdist(H)
    <-
    .print("Half distance is ", H).


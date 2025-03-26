// Creencias iniciales y reglas
//clear(table).
tower([b,d,e],[g,f],[c,a]).

clear(X) :- not(on(_,X)).
tower([X]) :- on(X,table).
tower([X|Y|T]) :- on(X,Y) & tower([Y|T]).


// Estado final que se quiere alcanzar
!state([[a,e,b],[f,d,c],[g]]).


// Construye torres una a una
+!state([])    <- 
  .print("Finished!").

+!state([H|T]) <- 
  .print("build a tower", H);
  !tower(H); 
  !state(T).

// Torre construida -> fin
+!tower(T) : tower(T). 

// Torre de un solo bloque
+!tower([T])  <- 
  !on(T,table). 

// Descomposición en torres más pequeñas
+!tower([X|Y|T]) <- 
  !tower([Y|T]); 
  !on(X,Y). 

// conseguido
+!on(X,Y) : on(X,Y). 

// plan: conseguir bloques X, Y libres y apilar
+!on(X,Y) <- 
  !clear(X); 
  !clear(Y); 
  .move(X,Y).

// conseguido
+!clear(X) : clear(X). 

// quitamos la cima de la torre y lo intentamos de nuevo
+!clear(X) :  
  tower([H|T]) & .member(X,T)
  <-
  .move(H,table);
  !clear(X). 
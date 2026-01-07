// creencias iniciales


+dist(D)[source(Ag)] 
    <-
    // .distance debe crearse como acción interna en un agente BDIAgent
    // en un fichero python separado.
    .print("Agent",Ag,"at distance ",D);
    H = D / 2;
    .send(Ag, tell, halfdist(H)).



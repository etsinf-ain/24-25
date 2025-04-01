 !get(beer).
    
+!get(beer) : true
    <- 
    .print("asking for a beer");
    .send("robot@localhost", achieve, has("owner", "beer")).

+has(owner,beer) : true
    <- 
    !drink(beer).

+!drink(beer) : has(owner,beer) 
    <- 
    .sip(beer);
    !drink(beer).

+!drink(beer) : not has(owner,beer).

-has(owner,beer) : true
    <- 
    !get(beer).

+msg(M)[source(Ag)] : true
    <- 
    .print("Message from ",Ag,": ",M);
    -msg(M).
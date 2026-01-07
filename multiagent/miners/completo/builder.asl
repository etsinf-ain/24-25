// Beliefs
resource_needed(1).
miners(["miner1@localhost",
        "miner2@localhost",
        "miner3@localhost"]).

// Plans

+resource_needed(R) : true
   <- ?miners(M);
      .send(M,achieve, search_for(R)).

// a miner .drop() in the builder cell 
+new_resource(R,ID) : resource_needed(R)
   <- .build_using(R,ID).

// a resource is not needed any more, get for the next one
+enough(R)
   <- -+resource_needed(R+1).
      //+resource_needed(R+1);

// just tell collectors that I finished the building
+building_finished
   <- 
   ?miners(M);
   .send(M,tell,building_finished).


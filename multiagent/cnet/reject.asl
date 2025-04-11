/* agent that refuses the cfp */

// the name of the agent playing initiator in the CNP
plays(initiator,"init@localhost").

// send a message to the initiator introducing myself 
// as a participant
+plays(Role,In)
   : .my_name(Me)
   <-    
   .concat(Me,"@localhost", Name);
   .print("introducing",Name,"to", In);
   .send(In,tell,participant(Name)). 

// reject the cfp
+cfp(CNPId,Task)[source(A)] 
   <- 
   .print("CFP received from", A);
   .send(A,tell,refuse(CNPId)).


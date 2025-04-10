/* agent that presents itself and never answer the cfp */

// the name of the agent playing initiator in the CNP
plays(initiator,"caller@localhost").

// send a message to the initiator introducing myself 
// as a participant
+plays(Role,In) 
   : .my_name(Me)
   <- 
   .concat(Me,"@localhost", Name);
   .print("introducing",Name,"to", In);
   .send(In,tell,introduction("participant",Name)). 
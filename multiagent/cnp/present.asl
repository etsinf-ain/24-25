// the name of the agent playing initiator in the CNP
plays(initiator,"caller@localhost").

// send a message to the initiator introducing myself 
// as a participant
+plays(Role,In) 
   : .my_name(Me)
   <- 
   .print("introducing myself to", In);
   .concat(Me,"@localhost", Name);
   .send(In,tell,introduction("participant",Name)). 
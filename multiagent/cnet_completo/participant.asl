/* agent that participates normally in a cfp */

// the name of the agent playing initiator in the CNP
plays(initiator,"caller@localhost"). 

// gets the price for the product,
// (a random value between 100 and 110).
price(Service,X) :- .random(R) & X = (10*R)+100.


/* Plans */

// send a message to the initiator introducing myself
// as a participant
+plays(Role,In) 
   : .my_name(Me)
   <- 
   .concat(Me,"@localhost", Name);
   .print("introducing",Name,"to", In);
   .send(In,tell,introduction("participant",Name)). 


// answer to Call For Proposal   
+cfp(CNPId,Task)[source(A)]
   :  plays(Role,Caller)
   <- 
      .print("CFP received from", A,"|",Caller);
      price(Task,Offer); // get the price for the task
      .print("I propose ",Offer," for ",Task);
      +proposal(CNPId,Task,Offer); // remember my proposal
      .send(A,tell,propose(CNPId,Offer)).

// proposal accepted -> do the task
+accept(CNPId)
   :  proposal(CNPId,Task,Offer)
   <- .print("My proposal '",Offer,"' won CNP ",CNPId,
             " for ",Task).
      // do the task and report to initiator
	       
// proposal refused -> do nothing and remove proposal
+reject(CNPId)
   <- .print("I lost CNP ",CNPId, ".");
      -proposal(CNPId,_,_). // clear memory
	  

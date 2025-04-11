/* Rules */

// Rule to check whenever all participants have answered
// counting the number of participants of each type
all_proposals_received(CNPId) :- 
  .count(participant(_),NP) &         // number of participants
  .count(propose(CNPId,_), NO) &      // number of proposes received
  .count(refuse(CNPId), NR) &         // number of refusals received
  NP == NO + NR.

/* Initial goals */
// id and task to be solved
!startCNP(1,"fix_computer").

/* Plans */

// start the CNP sending the cfp to all participants
+!startCNP(CNPId,Task) 
   <- 
      .print("Waiting for introductions");
      .wait(5000);  // wait participants introduction for 5 seconds
      //create a list with all the participants that have introduced themselves
      .findall(Name,participant(Name),LP);
      .print("Sending CFP to ",LP);
      // send the cfp to all the members of the list
      .send(LP,tell,cfp(CNPId,Task));
      .wait(5000); // wait 5 sec for participants to do proposals
      !contract(CNPId).


+!contract(CNPId)
   : all_proposals_received(CNPId) & propose(CNPId,Offer)
   <- 
      .findall(offer(O,A),propose(CNPId,O)[source(A)],L);
      .print("Offers are ",L);
      L \== []; // constraint the plan execution to at least one offer
      // sort offers, the first is the best
      .min(L,offer(WOf,WAg)); 
      .print("Winner is ",WAg," with ",WOf);
      // announce the result to all participants
      !announce_result(CNPId,L,WAg).

// not mandatory: none accept the task
+!contract(CNPId)
   <-
      .print("No offers received for CNP ",CNPId," [Cancel task]").


// announce the result of the CNP to all participants
//all announces sent (empty list)
+!announce_result(_,[],_).

// announce to the winner
+!announce_result(CNPId,[offer(O,WAg)|T],WAg) 
   <- .send(WAg,tell,accept(CNPId));
      !announce_result(CNPId,T,WAg).

// announce to others
+!announce_result(CNPId,[offer(O,LAg)|T],WAg) 
   <- .send(LAg,tell,reject(CNPId));
      !announce_result(CNPId,T,WAg).

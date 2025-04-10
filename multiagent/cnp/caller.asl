/* Rules */

// Rule to check whenever all participants have answered
// counting the number of participants of each type
all_proposals_received(CNPId) :- 
  .count(introduction(participant,_),NP) & // number of participants
  .count(propose(CNPId,_), NO) &      // number of proposes received
  .count(refuse(CNPId), NR) &         // number of refusals received
  NP = NO + NR.

/* Initial goals */
// id and task to be solved
!startCNP("1","fix_computer").

/* Plans */

// start the CNP sending the cfp to all participants
+!startCNP(Id,Task) 
   <- 
      .print("Waiting for introductions");
      .wait(10000);  // wait participants introduction
      +cnp_state(Id,propose);   // remember the state of the CNP
      .findall(Name,introduction(Role,Name),LP);
      .print("Sending CFP to ",LP);
      .send(LP,tell,cfp(Id,Task));
      .concat("+!contract('",Id,"')",Event);
      // the deadline of the CNP is now + 4 seconds, so
      // the event +!contract(Id) is generated at that time
      .at(15, Event).


// receive proposal 
// if all proposal have been received, don't wait for the deadline
+propose(CNPId,Offer)
   :  cnp_state(CNPId,propose) & all_proposals_received(CNPId)
   <- !contract(CNPId).

// receive refusals   
+refuse(CNPId) 
   :  cnp_state(CNPId,propose) & all_proposals_received(CNPId)
   <- !contract(CNPId).

// this plan needs to be atomic so as not to accept
// proposals or refusals while contracting
// added: at least one propose
//@lc1[atomic]
+!contract(CNPId)
   //:  cnp_state(CNPId,propose) &
   //   all_proposals_received(CNPId) & propose(CNPId,Offer)
   <- -+cnp_state(CNPId,contract);
      .findall(offer(O,A),propose(CNPId,O)[source(A)],L);
      .print("Offers are ",L);
      L \== []; // constraint the plan execution to at least one offer
      .min(L,offer(WOf,WAg)); // sort offers, the first is the best
      .print("Winner is ",WAg," with ",WOf);
      !announce_result(CNPId,L,WAg);
      -+cnp_state(CNPId,finished).

// nothing todo, the current phase is not 'propose'
+!contract(CNPId).

-!contract(CNPId) 
   <- .print("CNP ",CNPId," has failed!").

+!announce_result(_,[],_).
// announce to the winner
+!announce_result(CNPId,[offer(O,WAg)|T],WAg) 
   <- .send(WAg,tell,accept(CNPId));
      !announce_result(CNPId,T,WAg).
// announce to others
+!announce_result(CNPId,[offer(O,LAg)|T],WAg) 
   <- .send(LAg,tell,reject(CNPId));
      !announce_result(CNPId,T,WAg).

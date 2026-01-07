// AgentSpeak code for a Voter agent
+!start : true <- .print("Voter: Ready to vote.");
// Belief: candidate to vote for
candidate(alice).
// Goal: vote
+!vote : candidate(C) <- .send(voting_regulator, tell, vote(C)); .print("Voted for ", C).
+cfv : true <-
    .print("Voter: Received call for votes. Sending vote...");
    !vote
+cfp(voting_options(Options)) <-
    .print("Voter: Received voting options: ", Options);
    .random_permutation(Options, Shuffled);
    Preferred = Shuffled[1];
    .my_name(Me);
    .send(regulator, propose, vote(Me, Preferred));
    .print("Voter: Voted for ", Preferred, ". Preference order: ", Shuffled).

master("porter@localhost").


+door(State) :
    door(locked)
    <-
    ?master(M);
    .print("Door", State, " Asking for openning");
    .send(M, achieve, unlock).

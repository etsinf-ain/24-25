

+~door_locked
<-
    .print("Door open. Asking for closing");
    .send("porter@localhost", achieve, lock);
    -~door_locked.

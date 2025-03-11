
+door_locked[source(Sender)] 
    <-
    .print("Door closed. Asking for openning");
    .send("porter@localhost", achieve, ~lock);
    -door_locked.


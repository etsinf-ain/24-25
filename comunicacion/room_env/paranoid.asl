
// solo se dispara cuando se recibe como percepción (no desde mensaje) 
+door(State)[source(Sender)]  :
    Sender == percept & door(unlocked)
    <-
    .print("Door open stated by", Sender);
    .print("Asking for closing");
    .send("porter@localhost", achieve, lock).


locker("paranoid@localhost").
unlocker("claustrophobic@localhost").

+start <-
    ?locker(L);
    ?unlocker(U);
    .send(L,tell,door_locked);
    .send(U,tell,door_locked).
    // no sale el broadcast
    //.broadcast(tell,door_locked).



+!~lock :
    door_locked 
     <-
    //.unlock.
    .print("opening the door");
    -door_locked;
    +~door_locked;
    .send("paranoid@localhost",tell,~door_locked);
    .send("claustrophobic@localhost",tell,~door_locked).


+!lock:
    ~door_locked
     <-
    //.lock.
    .print("closing the door");
    -~door_locked;
    +door_locked;
    .send("paranoid@localhost",tell,door_locked);
    .send("claustrophobic@localhost",tell,door_locked).

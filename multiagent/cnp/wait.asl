!start.

+!start 
<-
    .print("waiting 5 secods");
    for(.member(S, [1, 2, 3, 4, 5])) {
        .print(S);
        .wait(1000);
    }
    .print("ready").
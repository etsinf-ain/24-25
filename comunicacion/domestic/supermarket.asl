/* Initial beliefs */
last_order_id(0).


/* Set of plans */

+!order(Product,Qtd)[source(Ag)]
    <-
    .print("order received from",Ag);
    ?last_order_id(N);
    OrderId = N + 1;
    -+last_order_id(OrderId);
    .deliver(Product,Qtd);
    .send("robot@localhost", tell, delivered(Product,Qtd,OrderId)).

+say(M)[source(Ag)]
    <-
    .print("Message from ",Ag,": ",M).
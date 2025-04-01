last_order_id(0).

+!order(Product,Qtd)[source(Ag)]
    <-
    .print("order received from",Ag);
    ?last_order_id(N);
    OrderId = N + 1;
    -+last_order_id(OrderId);
    .deliver(Product,Qtd);
    //.concat(Ag,"@localhost",AgAddr);
    .print("order received from", Ag);
    .send(Ag, tell, delivered(Product,Qtd,OrderId)).
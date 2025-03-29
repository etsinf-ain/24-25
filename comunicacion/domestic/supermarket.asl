last_order_id(0).

+!order(Product,Qtd)[source(Ag)] : true
    <-
    ?last_order_id(N);
    OrderId = N + 1;
    -+last_order_id(OrderId);
    .deliver(Product,Qtd);
    .send(Ag, tell, delivered(Product,Qtd,OrderId)).
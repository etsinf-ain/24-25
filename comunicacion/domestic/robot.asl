/* Initial beliefs and rules */
limit(beer,4).

too_much(beer) :-
       .date(YY,MM,DD) &
       // el subrayado indica que no me interesa
       // el valor de esa variable
       .count(consumed(YY,MM,DD,_,_,_,beer),QtdB) &
       limit(beer,Limit) &
       QtdB > Limit.

/* Plans */

+!has(O, B)[source(Ag)] :
   available(beer, fridge) //& not too_much(beer)
   <- 
      .print("I am getting a ",B," for ",O);
      !at(robot,fridge);
       .open(fridge);
       .get(B);
       .close(fridge);
       !at(robot,owner);
       .hand_in(B);
       // remember that another beer will be consumed
       .date(YY,MM,DD); .time(HH,NN,SS);
       +consumed(YY,MM,DD,HH,NN,SS,B).

+!has(O, B) :
not available(beer,fridge)
<- 
   .print(O,"has no beers, sending order");
   .send("market@localhost", tell, say("hello"));
   .send("market@localhost", achieve, order(beer,5));
   // go to fridge and wait there.
   !at(robot,fridge).

+!has(O, B) :
too_much(beer) //& limit(beer,L)
<- 
   ?limit(beer,L);
   .concat("The Department of Health does not allow me ",
          "to give you more than ", L,
          " beers a day! I am very sorry about that!",M);
    .send("owner@localhost",tell,msg(M)).


// manages stock and send an order to the supermarket
+stock(B,0) : available(beer,fridge)
   <- 
   .print("NO MORE BEERS O_o");
   -available(beer,fridge).

+stock(B,N) :
   N > 0 & not available(beer,fridge)
   <- 
   .print("there are",N,"beers");
   +available(beer,fridge).

+delivered(B,Qtd,OrderId)[source(supermarket)] 
<- +available(B,fridge);
   .print("order",OrderId,"received").
   !has(owner,B).

// movement between owner and fridge
+!at(R,P) : at(robot,P)
<-
   .print("already at", P," Stop moving").
+!at(R,P) : not at(robot,P) 
<- 
   .print(R,"go to", P, "position");
   .move_towards(P);
    !at(robot,P).
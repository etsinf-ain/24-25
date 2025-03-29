available(beer,fridge).
limit(beer,10).

too_much(B) :-
       .date(YY,MM,DD) &
       // el subrayado indica que no me interesa
       // el valor de esa variable
       .count(consumed(YY,MM,DD,_,_,_,B),QtdB) &
       limit(B,Limit) &
       QtdB > Limit.


+!has(owner,beer) :
   available(beer,fridge) & not too_much(beer)
   <- !at(robot,fridge);
       .open(fridge);
       .get(beer);
       .close(fridge);
       !at(robot,owner);
       .hand_in(beer);
       // remember that another beer will be consumed
       .date(YY,MM,DD); .time(HH,NN,SS);
       +consumed(YY,MM,DD,HH,NN,SS,beer).

+!has(owner,beer) :
not available(beer,fridge)
<- .send(supermarket, achieve, order(beer,5));
       // go to fridge and wait there.
    !at(robot,fridge).

+!has(owner,beer) :
too_much(beer) & limit(beer,L)
<- .concat("The Department of Health does not allow me ",
          "to give you more than ", L,
          " beers a day! I am very sorry about that!",M);
    .send(owner,tell,msg(M)).

+stock(beer,0) :
   available(beer,fridge)
   <- 
   -available(beer,fridge).

+stock(beer,N) :
   N > 0 & not available(beer,fridge)
   <- +available(beer,fridge).

+delivered(beer,Qtd,OrderId)[source(supermarket)] : true 
<- +available(beer,fridge);
   !has(owner,beer).

+!at(robot,P) : at(robot,P).

+!at(robot,P) : not at(robot,P) 
<-  .move_towards(P);
    !at(robot,P).
locker("paranoid@localhost").
unlocker("claustrophobic@localhost").

// solo aceptamos peticiones de unlocker()
+!unlock [source(Sender)] :
    //Sender solo contiene el nombre del agent (no el servidor)
    // se comprueba si está contenido en la cadena completa
    unlocker(U) & .substring(Sender,U,R)
    <-
    .print(Sender,"asks for opening the door");
    .unlock.

// se acepta cualquier peticion
+!lock 
    <-
    //con "?" recuperamos una creencia
    ?locker(Sender);
    .print(Sender, "asks for closing the door");
    .lock.

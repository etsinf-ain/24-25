/*
   1. Percepciones que le llegarán del entorno
   -------------------------------------------
   new_resource(resource,cantidad)
   Un minero ha dejado el recurso en la celda delbuilder (con la acción .drop)

   enough(recurso)
   Ya se tiene todo el recurso que se necesita -> pedir el siguiente

   -> habrá que crear planes que se disparen cuando se creen estas creencias


   2. Acciones disponibles 
   -----------------------

   .build_using(resource,cantidad)
   Construir usando la cantidad indicada del recurso

  -> habrá que implementarlas en SPADE (python)

   3. Mensajes que puede enviar
   -----------------------------
   locución: achieve, contenido: search_for(resource)
   Pide a los agentes que busquen el recurso indicado

   locución: tell, contenido: building_finished
   Informa a los agentes que han terminado de construir
   (para que vuelvan a la celda del builder)

   -> habrá que enviarlos desde el agente builder (.send) 
      y crear planes en los miners que se activen 
      por nueva intención (achieve) o nueva creencia (tell) 
*/

/*
   Beliefs
   
   Además de las percepciones, 
   añade las creencias que necesites para mantener la información del problema
*/

// lista con los agentes mineros (para enviarles mensajes)
// Alternativa: crearla desde el código python
/*
miners(["miner1@localhost",
        "miner2@localhost",
        "miner3@localhost"]).
*/
// Tipo de recurso que necesita para construir
// Empieza con el recurso 1 -> dispara la ejecución del agente
resource_needed(1).

/*
   Plans

   Crea un plan nuevo para cada percepción y para cada mensaje que le lleguen al agente
   (compruba si es sobre creencias o intenciones)
   Crea un plan para la intención inicial, para que comience la ejecución


*/

// Cuando se hay una necesidad de un recurso nuevo
// se envía un mensaje a todos los mineros
+resource_needed(R)
   <- 
      .print("Builder: I need resource ",R);
      ?miners(M);
      .print("Asking miners", M);
      //.send(M,achieve, search_for(R));
      .send("miner1@localhost",achieve, search_for(R));
      .send("miner2@localhost",achieve, search_for(R));
      .send("miner3@localhost",achieve, search_for(R)).


// Cuando se recibe un recurso y es el que es necesita,
// se utiliza para construir
+new_resource(R,Cant) : resource_needed(R)
   <- .build_using(R,Cant).

// Cuando hay cantidad suficiente del recurso, 
// a) se cambia al siguiente, o

+enough(R) : R < 3
   <- -+resource_needed(R+1).

// b) se termina la construcción si es el último
+enough(R) : R == 3
   <- 
   -resource_needed(R);
   building_finished.

// Cuando se completa la construcción se avisa a los mineros para que vuelvan
+building_finished
   <- 
   ?miners(M);
   .send(M,tell,building_finished).


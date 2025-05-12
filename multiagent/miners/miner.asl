/*
   1. Percepciones que le llegarán del entorno
   -------------------------------------------
   my_pos(X,Y)
   Posición actual del minero en el grid

   found(resource)
   Se ha encontrado el recurso en la celda actual

   -> habrá que crear planes que se disparen cuando se creen estas creencias


   2. Acciones disponibles 
   -----------------------

   .mine(resource)
   Extrae una unidad de recurso de la celda actual (tiene que haber una mina)

   .drop(resource)
   Deja caer el recurso en la celda actual (debe ser la del builder)
   
   .move_to(cell)
   Se mueve a la siguiente celda según el esquema de movimiento del minero
   Se puede implementar .move_to(next), .move_to(prev)
   
   .move_towards(X,Y)
   Se mueve hacia la posición indicada (X,Y)
  

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
// Posición del builder (puede crearse desde el código python para hacerlo más general)
// Se usa una única creencia para determina la posición de cualquier objeto
// pos (object,X,Y)
pos(builder,15,15).


/*
   Plans

   Crea un plan nuevo para cada percepción y para cada mensaje que le lleguen al agente
   (compruba si es sobre creencias o intenciones)
*/

// Cuando el builder pide un recurso, lo anota para detectar cuándo lo encuentra
// Eso debe disparar el plan de búsqueda del recurso
+!search_for(NewResource) 
   <- +resource_needed(NewResource).

// Cuando se recibe el mensaje de que se ha completado la construciçón
// el agente vuelve a la celda del builder (hay que crear un plan para eso)
+building_finished
   <- 
   .print("Building finished, returning to builder").
   // Por ejemplo, se pueden generar intenciones !go() para que el minero se mueva
   //!go(builder).


// El entorno actualiza la posición del minero
// Preparar planes para: 
// no hay nada -> continua
// hay una mina con el recurso -> lo extrae(.mine) y lo lleva al builder (.move_towards)
// hay otro recurso distinto: lo anota (+pos(R,X,Y)) y sigue buscando
// estoy en la celda del builder -> deja el recurso (.drop)
+my_pos(X,Y)
   <- .print("My position is: ",X,Y).

// El minero ha encontrado un recurso R
// TODO: separar los planes según el resurso es el que se está buscando o no
+found(R)
   <- 
   ?my_pos(X,Y);
   .print("Resource", R, "found at", X, Y).

// Añadir el resto de planes para implementar el comportamiento del minero
// Ejemplo:

// Búsqueda de un nuevo recurso (generado desde +!search_for(NewResource)
// pero... (borrar este plan, porque es mejor lo siguiente)
+resource_needed(R) : not building_finished
   <-
   .print("Searching for resource", R).

// ... es mejor usar una intención y usar esta creencia en las condiciones
// ej: +!look_for_resources
// ->  añadir !look_for_resources. al plan que dispara +!search_for(NewResource)
+!look_for_resources : resource_needed(R) & found(R)
   <- 
   .print("Resource", R).

+!look_for_resources : resource_needed(R) &  not found(R) 
   <- 
   .print("Searching for resource", R).



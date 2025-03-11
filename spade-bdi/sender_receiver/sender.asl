start.
receiver("bdireceive@localhost").


+start <-
    ?receiver(X);
    .print("compose mensaje for", X);
    .send(X, achieve, start);
    .print("message sent").
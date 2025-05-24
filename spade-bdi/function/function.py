import asyncio
import spade
import math
from spade_bdi.bdi import BDIAgent


# Creamos una clase para definir la acción interna
class DistAgent(BDIAgent):

    # Para crear acciones/funciones, hay que sobreescribir add_custom_actions
    def add_custom_actions(self, actions):
        # Definimos una acción interna llamada "distance" 
        # que toma cuatro parámetros de tipo float
        # La coma final (trailing comma) se considera una buena práctica en Python para evitar errores    
        # https://medium.com/pythoneers/improve-python-code-quality-with-trailing-commas-a-powerful-technique-757a26d05ca7
        @actions.add_function(".distance", (float,float,float,float,))
        def _distance(x1, y1, x2, y2):
            return math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)


async def main():
    # list of agents
    dist = DistAgent("dist@localhost", "1234", "distance.asl")
    await dist.start()
    await asyncio.sleep(1)
    await dist.stop()

if __name__ == "__main__":
    spade.run(main())
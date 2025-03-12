import asyncio
import spade
from spade_bdi.bdi import BDIAgent

       


# agente con una acción externa para manejar la puerta (lock/unlock)
class RobotAgent(BDIAgent):
    def set_stock(self, N):
        self.N = N

   # hay que sobreescribir este método para añadir todas las acciones externas 
    def add_custom_actions(self, actions):
        # abre la nevera y hace percibir el stock
        @actions.add(".open", 0)
        def _m_open(agent, term, intention):
            print("[robot] opening fridge")
            self.bdi.set_belief("stock", self.N)
            print("robot beliefs after open fridge")
            self.bdi.print_beliefs()
            yield #para la gestión del iterador 


async def main():
    robot = RobotAgent("robot@localhost", "1234", "robot.asl")
    
    # establece el stock inicial
    robot.set_stock(12)
    print("Start agents")
    await robot.start()
    await asyncio.sleep(1)

    print("Stop agents...")
    print("final robot beliefs ")
    robot.bdi.print_beliefs()
    await robot.stop()


if __name__ == "__main__":
    spade.run(main())
import asyncio
import spade
import random
import agentspeak
from spade_bdi.bdi import BDIAgent

       
class RobotAgent(BDIAgent):
    def set_stock(self, N):
        self.N = N
    
    def set_owner(self, owner):
        self.owner = owner

    def add_custom_actions(self, actions):
        # abre la nevera y hace percibir el stock
        @actions.add(".open", 1)
        def _m_open(agent, term, intention):
            print("[robot] opening fridge")
            self.bdi.set_belief("stock", self.N)
            yield
        
        @actions.add(".get", 1)
        def _m_get(agent, term, intention):
            print("[robot] get a beer")
            yield

        @actions.add(".close", 1)
        def _m_close(agent, term, intention):
            print("[robot] closing fridge")
            self.bdi.remove_belief("stock", self.N)
            yield

        @actions.add(".hand_in", 1)
        def _m_close(agent, term, intention):
            print("[robot] give the beer to owner")
            self.owner.bdi.add_belief("has", "owner", "beer")
            yield

        @actions.add(".move_towards", 1)
        def _m_close(agent, term, intention):
            args = agentspeak.grounded(term.args, intention.scope)
            print("[robot] moving towards", args[0])
            #remove current position belief
            currentpos = self.bdi.get_belief_belief_value("at")[1]
            self.bdi.remove_belief("at", "robot", currentpos)
            self.bdi_set_belief("at", "robot", args[0])
            yield


class OwnerAgent(BDIAgent):
    def add_custom_actions(self, actions):
         # abre la nevera y hace percibir el stock
        @actions.add(".sip", 1)
        def _m_sip(agent, term, intention):
            print("[owner] sipping")
            # un 10% de prob de acabar la cerveza en este trago
            if random.random() < 0.1:
                self.bdi.remove_belief("has","owner","beer")
            yield


class MarketAgent(BDIAgent):
    def add_custom_actions(self, actions):
         # abre la nevera y hace percibir el stock
        @actions.add(".deliver", 2)
        def _m_deliver(agent, term, intention):
            args = agentspeak.grounded(term.args, intention.scope)
            prod = args[0]
            qty = args[1]
            print("[market] delivering order",str(qty),prod)
            yield


async def main():
    robot = RobotAgent("robot@localhost", "1234", "robot.asl")
    owner = OwnerAgent("owner@localhost", "1234", "owner.asl")
    market = MarketAgent("market@localhost", "1234", "supermarket.asl")


    # establece el stock inicial and owner
    robot.set_stock(12)
    robot.set_owner(owner)
    print("Start agents")
    await robot.start()
    await owner.start()
    await market.start()
    print("done")
    await asyncio.sleep(1)


    print("Stop agents...")
    print("final robot beliefs ")
    robot.bdi.print_beliefs()
    print("final owner beliefs ")
    owner.bdi.print_beliefs()
    print("final market beliefs ")
    market.bdi.print_beliefs()
    await robot.stop()
    await owner.stop()
    await market.stop()
    print("Agents stopped")


if __name__ == "__main__":
    spade.run(main())
import asyncio
import spade
from spade_bdi.bdi import BDIAgent
import agentspeak


'''class BuilderAgent(BDIAgent):
    def add_custom_actions(self, actions):
        # acción para construir usando el recurso "resource"
        @actions.add(".build_using", 2)
        def _m_build_using(agent, term, intention):
            resource = agentspeak.grounded(term.args[0], intention.scope)
            cant = agentspeak.grounded(term.args[1], intention.scope)
            print("build using resource", resource,"- cant:", cant)
            yield 
        @actions.add(".move_toward", 2)
        def _m_move_toward(agent, term, intention):
            pass


class MinerAgent(BDIAgent):
    def add_custom_actions(self, actions):
        # acción para depositar el recurso en la celda actual
        @actions.add(".drop", 1)
        def _m_drop(agent, term, intention):
            resource = agentspeak.grounded(term.args[0], intention.scope)
            print("Resource", resource,"dropped")
            yield 
        @actions.add(".mine", 1)
        def _m_mine(agent, term, intention):
            pass 
        @actions.add(".move_to", 1)
        def _m_move_to(agent, term, intention):
            pass 
        @actions.add(".move_towards", 2)
        def _m_move_towards(agent, term, intention):
            pass 
'''


async def main():
    # list of agents
    agents = []
    agents.append(BDIAgent("bid1@localhost", "1234", "bidder.asl"))
    agents.append(BDIAgent("bid2@localhost", "1234", "bidder.asl"))
    agents.append(BDIAgent("bid3@localhost", "1234", "bidder.asl"))
    # debe ser el último en iniciar
    agents.append(BDIAgent("auct@localhost", "1234", "auctioneer.asl"))


    print("Start agents")
    for agent in agents:
        await agent.start()
    await asyncio.sleep(5)
    print("Finished. Stop agents")
    for agent in agents:
        print(f"** {agent.jid} beliefs")
        # add source=True to print the source of the beliefs
        # agent.bdi.print_beliefs(source=True)
        agent.bdi.print_beliefs()
        await agent.stop()
    print("Agents stopped")

if __name__ == "__main__":
    spade.run(main())
import asyncio
import spade
from spade_bdi.bdi import BDIAgent

class Terrain:
    def __init__(self):
        terrain = np.zeros((n, n), dtype=int)


class BuilderAgent(BDIAgent):
    def add_custom_actions(self, actions):
        # acción para construir usando el recurso "resource"
        @actions.add(".build_using", 2)
        def _m_build_using(agent, term, intention):
            resource = agentspeak.grounded(term.args[0], intention.scope)
            cant = agentspeak.grounded(term.args[1], intention.scope)
            print("build using resource", resource,"- cant:", cant)
            yield 
        @actions.add(".drop_all_desires", 0)
        def _m_drop_all_desires(agent, term, intention):
            pass
        @actions.add(".move_toward", 2)
        def _m_move_toward(agent, term, intention):
            pass


class MinerAgent(BDIAgent):
    def add_custom_actions(self, actions):
        # acción para construir usando el recurso "resource"
        @actions.add(".drop", 1)
        def _m_build_using(agent, term, intention):
            resource = agentspeak.grounded(term.args[0], intention.scope)
            print("Resource", resource,"dropped")
            yield 


async def main():
    # list of agents
    # 1 initiator, 3 participants, 1 rejecting proposal
    agents = []
    agents.append(BuilderAgent("builder@localhost", "1234", "builder.asl"))
    agents.append(MinerAgent("miner1@localhost", "1234", "miner.asl"))
    agents.append(MinerAgent("miner2@localhost", "1234", "miner.asl"))
    agents.append(MinerAgent("miner3@localhost", "1234", "miner.asl"))

    print("Start agents")
    for agent in agents:
        await agent.start()
    builder = agents[0]
    builder.bdi.set_belief("miner",agents[1:])

    await asyncio.sleep(1)
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
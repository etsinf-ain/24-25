import asyncio
import spade
import agentspeak
import datetime
from spade.behaviour import TimeoutBehaviour
from spade_bdi.bdi import BDIAgent
from spade.message import Message


class TimedAgent(BDIAgent):
    
    class TimeOut(TimeoutBehaviour):   
        def __init__(self, start_at, event):
            super().__init__(start_at)
            self.event = event
            self.add = True if event[0] == '+' else False
            event = event[1:]
            if event[0] == '!':
                self.is_intent = True
                event = event[1:]
            else:
                self.is_intent = False
            self.event = event       
        
        def ilf_type(self):
            if self.add:
                if self.is_intent:
                    return "achieve"
                else:
                    return "tell"
            else:
                if self.is_intent:
                    return "unachieve"
                else:
                    return "untell"
                
        async def run(self):
            ilf = self.ilf_type()
            mdata = {
                    "performative": "BDI",
                    "ilf_type": ilf,
            }
            msg = Message(to=str(self.agent.jid), 
                          body=str(self.event), 
                          metadata=mdata)
            self.agent.submit(self.send(msg))


    def add_custom_actions(self, actions):
        @actions.add(".at", 2)
        def _m_at(agent, term, intention):
            args = agentspeak.grounded(term.args, intention.scope)
            secs = args[0]
            intention = args[1] 
            start_at = datetime.datetime.now() + datetime.timedelta(seconds=secs)
            b = self.TimeOut(start_at=start_at, event=intention)
            self.add_behaviour(b)
            yield 


async def main():
    # list of agents
    # 1 caller, 3 participants, 1 rejecting proposal, 1 not answering
    present = BDIAgent("present@localhost", "1234", "present.asl")
    #part1 = BDIAgent("part1@localhost", "1234", "participant.asl")
    #part2 = BDIAgent("part2@localhost", "1234", "participant.asl")
    #part3 = BDIAgent("part3@localhost", "1234", "participant.asl")
    reject = BDIAgent("reject@localhost", "1234", "reject.asl")
    caller = TimedAgent("caller@localhost", "1234", "caller.asl")
    

    print("Start agents")
    #await part1.start()
    #await part2.start()
    #await part3.start()
    await caller.start()
    await present.start()   
    await reject.start()
        

    await asyncio.sleep(10)
    print("Finished. Stop agents")
    print("** caller beliefs")
    caller.bdi.print_beliefs()
    print("** present beliefs")
    present.bdi.print_beliefs()
    print("** reject beliefs")
    reject.bdi.print_beliefs()
    await caller.stop()
    #await part1.stop()
    #await part2.stop()
    #await part3.stop()
    await reject.stop()
    await present.stop()


if __name__ == "__main__":
    spade.run(main())
import asyncio
import spade
from spade_bdi.bdi import BDIAgent


async def main():
    # list of agents
    # 1 caller, 3 participants, 1 rejecting proposal, 1 not answering
    present = BDIAgent("present@localhost", "1234", "present.asl")
    #part1 = BDIAgent("part1@localhost", "1234", "participant.asl")
    #part2 = BDIAgent("part2@localhost", "1234", "participant.asl")
    #part3 = BDIAgent("part3@localhost", "1234", "participant.asl")
    reject = BDIAgent("reject@localhost", "1234", "reject.asl")
    caller = BDIAgent("caller@localhost", "1234", "caller.asl")
    

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
import asyncio
import spade
from spade_bdi.bdi import BDIAgent

async def main():
    # list of agents
    # 1 initiator, 3 participants, 1 rejecting proposal
    part1 = BDIAgent("part1@localhost", "1234", "participant.asl")
    part2 = BDIAgent("part2@localhost", "1234", "participant.asl")
    part3 = BDIAgent("part3@localhost", "1234", "participant.asl")
    reject = BDIAgent("reject@localhost", "1234", "reject.asl")
    init = BDIAgent("init@localhost", "1234", "initiator.asl")
    

    print("Start agents")
    await init.start()
    await reject.start()
    await part1.start()
    await part2.start()
    await part3.start()

    await asyncio.sleep(15)
    print("Finished. Stop agents")
    print("** init beliefs")
    init.bdi.print_beliefs()
    print("** reject beliefs")
    # source=True to show source of beliefs
    reject.bdi.print_beliefs(source=True)
    print("** participant 1 beliefs")
    part1.bdi.print_beliefs(source=True)
    print("** participant 2 beliefs")
    part2.bdi.print_beliefs()    
    print("** participant 3 beliefs")
    part3.bdi.print_beliefs()    
    await part1.stop()
    await part2.stop()
    await part3.stop()
    await reject.stop()
    await init.stop()
    print("Agents stopped")

if __name__ == "__main__":
    spade.run(main())
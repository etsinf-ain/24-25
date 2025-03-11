import asyncio
import spade
from spade_bdi.bdi import BDIAgent



async def main():
    paranoid = BDIAgent("paranoid@localhost", "1234", "paranoid.asl")
    claust = BDIAgent("claustrophobic@localhost", "1234", "claust.asl")
    porter = BDIAgent("porter@localhost", "1234", "porter.asl")

    print("Start agents")
    await porter.start()
    await paranoid.start()
    await claust.start()
    porter.bdi.set_belief("door_locked")
    porter.bdi.set_belief("start")


    await asyncio.sleep(3)
    print("porter")
    porter.bdi.print_beliefs()
    print("claust")
    claust.bdi.print_beliefs()
    print("paranoid")
    paranoid.bdi.print_beliefs()
    print("Stopping agents...")
    await porter.stop()
    await paranoid.stop()
    await claust.stop()


if __name__ == "__main__":
    spade.run(main())
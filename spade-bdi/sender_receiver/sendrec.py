import asyncio
import spade
from spade_bdi.bdi import BDIAgent

async def main():
    sender = BDIAgent("bdisend@localhost", "1234", "sender.asl")
    receiver = BDIAgent("bdireceive@localhost", "1234", "receiver.asl")

    print("Start receiver")
    await receiver.start()
    print("Start sender")
    await sender.start()
    
    await asyncio.sleep(1)
    print("Stopping agents...")
    await sender.stop()
    await receiver.stop() 


if __name__ == "__main__":
    spade.run(main())
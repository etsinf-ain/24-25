import asyncio
import spade
from spade_bdi.bdi import BDIAgent

async def main():
    a = BDIAgent("hello@127.0.0.1", "1234", "hello.asl")
    await a.start()
    #sleep the agent to let the rule to execute
    await asyncio.sleep(1)
    print("Agent ready")
    await a.stop() 

if __name__ == "__main__":
    spade.run(main())
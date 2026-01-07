"""
main.py - SPADE-BDI runner for Prisoner's Dilemma
"""
# Placeholder for SPADE-BDI integration
import asyncio
import spade
from spade_bdi.bdi import BDIAgent


async def main():
    print("Starting Prisoner's Dilemma simulation with SPADE-BDI...")
    # TODO: Initialize and start agents
    prisoner1= BDIAgent("prisoner1@localhost", "1234", "prisoner1.asl")
    prisoner2 = BDIAgent("prisoner2@localhost", "1234", "prisoner2.asl")
    arb = BDIAgent("arbitrer@localhost", "1234", "arbitrer.asl")
    await prisoner1.start()
    await prisoner2.start()
    await arb.start()
    print("Agents started. Waiting for simulation to complete...")  
    await asyncio.sleep(5)  # Simulate some processing time
    print("Simulation complete. Stopping agents...")
    await prisoner1.stop()
    await prisoner2.stop()
    await arb.stop()
    print("Agents stopped.")

if __name__ == "__main__":
    spade.run(main())

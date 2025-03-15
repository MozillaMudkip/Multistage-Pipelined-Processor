# Multistage-Pipelined-Processor
Verilog Microprocessor Design

This repository contains the base code for a simple multistage pipelined processor. This particular project was created in collaboration with a small group so Ive only uploaded the base level code to avoid posting any of my partners work.

This processor contains 5 stages; fetch, decode, execute, memory and writeback. All tied together with the proc function, the processor is able to take in a large number of different MIP instructions and is able to decode them into register and arithmetic operations. Depending on what the operations require, it will pass its contents to the execute stage, to work through arithmetic operations like ADD, SUB, MULT and DIV, the memory stage, to access data in memory for load instructions, and writeback to write data, usually newly calculated values, directly to memory. 

To pair fetch and decode, decode and execute, execute and memory and finally memory and writeback, there are a number of functions that will handle the pipelining of the processor's operations. In the event that an operation would not need a certain stage of the processor, the pipelines will allow the processor to optimize the execution of the currently input operations.  

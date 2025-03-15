/*
   CS/ECE 552 Fall 2024
   Filename: memory.v
   Description: This module will contain the memory stage of the processor
*/
module memory (err, clk, rst, XOut, WriteData, MemWrite, memoryOut, MemRead, createdump);
	output [15:0] memoryOut;
	output err;
	input [15:0] XOut;
	input [15:0] WriteData;
	input clk;				
	input rst;
    input createdump;	
	input MemWrite;
	input MemRead;
	
	//Determine any error in input
	assign err = (MemWrite === 1'bz) | (MemRead === 1'bz) | (createdump === 1'bz) | (^WriteData === 1'bz) | (^XOut === 1'bz) | 
				(MemWrite === 1'bx) | (MemRead === 1'bx) | (createdump === 1'bx) | (^WriteData === 1'bx) | (^XOut === 1'bx);
				
	//Store data or access data in currInstruct designated memory			
	memory2c instruction_mem(.data_out(memoryOut), .data_in(WriteData), .addr(XOut), .enable(MemWrite | MemRead), .wr(MemWrite), .createdump(createdump), .clk(clk), .rst(rst));
endmodule

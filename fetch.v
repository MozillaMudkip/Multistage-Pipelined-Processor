/*
	CS/ECE 552 Fall 2024
	Filename: fetch.v
	Description: This module will will contain the fetch stage of the processor
*/
module fetch(clk, rst, halt, jumpDTaken, jumpDDest, jumpImm, jumpImmDest, stall, err, currInstruct, plusTwoPC);
	output [15:0] currInstruct;
	output [15:0] plusTwoPC;
	output err;
	input [15:0] jumpDDest;
	input [15:0] jumpImmDest;
	input clk;				
	input rst;				
	input halt;				
	input jumpDTaken;
	input jumpImm;
	input stall;
	
	wire [15:0] PC;
	wire [15:0] pcNext;
	
	//Retrieve the value of the next currInstruction Program Counter
	assign pcNext = jumpDTaken ? jumpDDest : (jumpImm ? jumpImmDest : plusTwoPC);
	
	//Retrieve the value of the next curr currInstruct
	cla_16b adder(.sum(plusTwoPC), .c_out(), .a(PC), .b(16'h0002),	.c_in(1'b0));
	
	//Access and retrieve currInstruction from currInstruction memory
	memory2c instruction_mem(.data_out(currInstruct), .data_in(16'h0000),	.addr(PC), .enable(1'b1), .wr(1'b0), .createdump(1'b0),	.clk(clk), .rst(rst));
	
	//Access Program Counter
	register prog_count(.readData(PC), .err(err), .clk(clk), .rst(rst), .writeData(pcNext), .writeEn((~halt) & (~stall)));
endmodule

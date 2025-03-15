/*
	CS/ECE 552 Fall 2024
	Filename: MEM_WB.v
	Description: MEM_WB pipeline register
*/
module MEM_WB (clk, rst, inPlusTwoPC, inMemoryToRegister, inWriteRegister, inRegisterWrite, inMemoryOut, inXOut, inLink, inHalt, outMemoryOut, outPlusTwoPC, outMemoryToRegister, outWriteRegister, outRegisterWrite, outXout, outLink, outHalt);
	output [15:0] outMemoryOut;
	output [15:0] outPlusTwoPC;
	output [15:0] outXout;
	output [2:0] outWriteRegister;
	output outMemoryToRegister;
	output outRegisterWrite;
	output outLink;
	output outHalt;
	input [15:0] inMemoryOut;
	input [15:0] inPlusTwoPC;
	input [15:0] inXOut;
	input [2:0] inWriteRegister;
	input clk;
	input rst;
	input inRegisterWrite;
	input inLink;
	input inMemoryToRegister;
	input inHalt;

	//Pipe inputs and outputs
	//memory output
	dff memout[15:0](.q(outMemoryOut), .d(inMemoryOut), .clk(clk), .rst(rst));
	//next PC
	dff pc_plus_two[15:0](.q(outPlusTwoPC), .d(inPlusTwoPC), .clk(clk), .rst(rst));
	//X out
	dff xout[15:0](.q(outXout), .d(inXOut), .clk(clk), .rst(rst));
	//write to register
	dff writeregister[2:0](.q(outWriteRegister), .d(inWriteRegister), .clk(clk), .rst(rst));
	//memory to register
	dff memtoreg(.q(outMemoryToRegister), .d(inMemoryToRegister), .clk(clk), .rst(rst));
	//register write
	dff regwrite(.q(outRegisterWrite), .d(inRegisterWrite), .clk(clk), .rst(rst));
	//link
	dff link(.q(outLink), .d(inLink), .clk(clk), .rst(rst));
	//halt op
	dff halt(.q(outHalt), .d(inHalt), .clk(clk), .rst(rst));
endmodule

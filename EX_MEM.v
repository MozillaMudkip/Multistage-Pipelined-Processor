/*
	CS/ECE 552 Fall 2024
	Filename: EX_MEM.v
	Description: EX_MEM pipeline register
*/
module EX_MEM (clk, rst, inXOut, inRead2Data, inMemoryWrite, inMemoryRead, inHalt, inCreateDump, inLink, inPlusTwoPC, inMemoryToRegister, inWriteRegister, inRegisterWrite, outXout, outRead2Data, outMemoryWrite, outMemoryRead, outHalt, outCreateDump, outLink, outPlusTwoPC, outMemoryToRegister, outWriteRegister, outRegisterWrite);
	output [15:0] outXout;
	output [15:0] outPlusTwoPC;
	output [15:0] outRead2Data;
	output [2:0] outWriteRegister;
	output outMemoryWrite;
	output outMemoryRead;
	output outMemoryToRegister;
	output outRegisterWrite;
	output outHalt;
	output outCreateDump;
	output outLink;
	input [15:0] inXOut;
	input [15:0] inPlusTwoPC;
	input [15:0] inRead2Data;
	input [2:0] inWriteRegister;
	input clk;
	input rst;
	input inMemoryWrite;
	input inMemoryRead;
	input inMemoryToRegister;
	input inRegisterWrite;
	input inHalt;
	input inCreateDump;	
	input inLink;
	
	//Pipe inputs to outputs
	//X out
	dff xout[15:0](.q(outXout), .d(inXOut), .clk(clk), .rst(rst));
	//next PC
	dff pc_plus_two[15:0](.q(outPlusTwoPC), .d(inPlusTwoPC), .clk(clk), .rst(rst));
	//read 2
	dff read2Data[15:0](.q(outRead2Data), .d(inRead2Data), .clk(clk), .rst(rst));
	//write to register
	dff writeregister[2:0](.q(outWriteRegister), .d(inWriteRegister), .clk(clk), .rst(rst));
	//write to memory
	dff memwrite(.q(outMemoryWrite), .d(inMemoryWrite), .clk(clk), .rst(rst));
	//read memory
	dff memread(.q(outMemoryRead), .d(inMemoryRead), .clk(clk), .rst(rst));
	//memory to register
	dff memtoreg(.q(outMemoryToRegister), .d(inMemoryToRegister), .clk(clk), .rst(rst));
	//memory to register
	dff regwrite(.q(outRegisterWrite), .d(inRegisterWrite), .clk(clk), .rst(rst));
	//halt op
	dff halt(.q(outHalt), .d(inHalt), .clk(clk), .rst(rst));
	//dump
	dff createdump(.q(outCreateDump), .d(inCreateDump), .clk(clk), .rst(rst));
	//link
	dff link(.q(outLink), .d(inLink), .clk(clk), .rst(rst));
endmodule

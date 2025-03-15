/*
	CS/ECE 552 Fall 2024
	Filename: IF_ID.v
	Description: Fetch to Decode Pipeline
*/
module IF_ID (clk, rst, inInstruct, inPlusTwoPC, stall, flush, outInstruct, outPlusTwoPC);
	output [15:0] outInstruct;
	output [15:0] outPlusTwoPC;
	input [15:0] inInstruct;
	input [15:0] inPlusTwoPC;
	input clk;
	input rst;
	input stall;
	input flush;
	
	wire [15:0] instructionD;
	wire [15:0] plusTwoPCD;
	
	//Stall or Reset when NOP is passed through
	assign instructionD = (rst | flush) ? 16'h0800 : stall ? outInstruct : inInstruct;
	
	assign plusTwoPCD = stall ? outPlusTwoPC : inPlusTwoPC;
	
	//Store the instruction and next PC for pipeline use
	dff instruction[15:0](.q(outInstruct), .d(instructionD), .clk(clk), .rst(1'b0));
	dff pc_plus_two[15:0](.q(outPlusTwoPC), .d(plusTwoPCD), .clk(clk), .rst(rst));
endmodule

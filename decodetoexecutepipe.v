/*
	CS/ECE 552 Fall 2024
	Filename: decodetoexecutepipe.v
	Description: Decode to Execute pipeline
*/
module decodetoexecutepipe (clk, rst, inRead1Data, inRead2Data, inImmediateExt, inWriteRegister, inHalt, inCreateDump, inALUOp, inSrcALU, inSrcALUClear, inCin, inInvA, inInvB, inSign,
				inJumpImm, inPlusTwoPC, inMemoryWrite, inMemoryRead, inSetCmp, inCmpOp, inMemoryToRegister, inLink, inExtendedOp, inRegisterWrite, nop, stall, outRead1Data, outRead2Data, outImmediateExt, outWriteRegister, outHalt, outCreateDump,
				outALUOp, outSrcALU, outSrcALUClear, outCin, outInvA, outInvB, outSign, outJumpImm, outPlusTwoPC, outMemoryWrite, outMemoryRead, outSetCmp, outCmpOp, outMemoryToRegister, outLink, outExtendedOp, outRegisterWrite);
	output [15:0] outRead1Data;
	output [15:0] outRead2Data;
	output [15:0] outPlusTwoPC;
	output [15:0] outImmediateExt;
	output [2:0] outWriteRegister;
	output [2:0] outALUOp;
	output [1:0] outExtendedOp;
	output [1:0] outCmpOp;
	output outHalt;
	output outCreateDump;
	output outSrcALU;
	output outSrcALUClear;
	output outCin;
	output outInvA;
	output outInvB;
	output outSign;
	output outJumpImm;
	output outMemoryWrite;
	output outMemoryRead;
	output outSetCmp;
	output outMemoryToRegister;
	output outLink;
	output outRegisterWrite;
	input [15:0] inRead1Data;
	input [15:0] inRead2Data;
	input [15:0] inPlusTwoPC;
	input [15:0] inImmediateExt;
	input [2:0] inWriteRegister;
	input [2:0] inALUOp;
	input [1:0] inExtendedOp;
	input [1:0] inCmpOp;
	input clk;
	input rst;
	input inHalt;
	input inCreateDump;
	input inSrcALU;
	input inSrcALUClear;
	input inCin;
	input inInvA;
	input inInvB;
	input inSign;
	input inJumpImm;
	input inMemoryWrite;
	input inMemoryRead;
	input inSetCmp;
	input inMemoryToRegister;
	input inLink;
	input inRegisterWrite;
	input nop;
	input stall;
	//Pipe Inputs to Outputs
	//read1
	dff read1Data[15:0](.q(outRead1Data), .d(inRead1Data), .clk(clk), .rst(rst));
	//read2
	dff read2Data[15:0](.q(outRead2Data), .d(inRead2Data), .clk(clk), .rst(rst));
	//next PC
	dff pc_plus_two[15:0](.q(outPlusTwoPC), .d(inPlusTwoPC), .clk(clk), .rst(rst));
	//immediate Ext
	dff immediateExt[15:0](.q(outImmediateExt), .d(inImmediateExt), .clk(clk), .rst(rst));
	//write register out
	dff writeregister[2:0](.q(outWriteRegister), .d(inWriteRegister), .clk(clk), .rst(rst));
	//Alu Operation
	dff aluop[2:0](.q(outALUOp), .d(inALUOp), .clk(clk), .rst(rst));
	//Cmp operation
	dff cmpop[1:0](.q(outCmpOp), .d(inCmpOp), .clk(clk), .rst(rst));
	//extended operation
	dff specialop[1:0](.q(outExtendedOp), .d(inExtendedOp), .clk(clk), .rst(rst));
	//SRC ALU
	dff alusrc(.q(outSrcALU), .d(inSrcALU), .clk(clk), .rst(rst));
	//Clear SRC ALU
	dff clralusrc(.q(outSrcALUClear), .d(inSrcALUClear), .clk(clk), .rst(rst));
	//Cin
	dff cin(.q(outCin), .d(inCin), .clk(clk), .rst(rst));
	//invA
	dff inva(.q(outInvA), .d(inInvA), .clk(clk), .rst(rst));
	//invB
	dff invb(.q(outInvB), .d(inInvB), .clk(clk), .rst(rst));
	//sign
	dff sign(.q(outSign), .d(inSign), .clk(clk), .rst(rst));
	//jump immediate
	dff jumpi(.q(outJumpImm), .d(inJumpImm & ~stall), .clk(clk), .rst(rst));
	//link
	dff link(.q(outLink), .d(inLink), .clk(clk), .rst(rst));
	//register write
	dff regwrite(.q(outRegisterWrite), .d(inRegisterWrite & ~nop), .clk(clk), .rst(rst));
	//memory write
	dff memwrite(.q(outMemoryWrite), .d(inMemoryWrite & ~nop), .clk(clk), .rst(rst));
	//memory read
	dff memread(.q(outMemoryRead), .d(inMemoryRead & ~nop), .clk(clk), .rst(rst));
	//cmp set
	dff cmpset(.q(outSetCmp), .d(inSetCmp), .clk(clk), .rst(rst));
	//memory to register
	dff memtoreg(.q(outMemoryToRegister), .d(inMemoryToRegister), .clk(clk), .rst(rst));
	//halt op
	dff halt(.q(outHalt), .d(inHalt & ~nop), .clk(clk), .rst(rst));
	//dump
	dff createdump(.q(outCreateDump), .d(inCreateDump & ~nop), .clk(clk), .rst(rst));
endmodule

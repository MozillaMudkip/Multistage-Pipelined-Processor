/*
	CS/ECE 552 Fall 2024
	Filename: decode.v
	Description: This module will contain the decode stage of the processor
*/
module decode (err, read1Data, read2Data, immediateExt, writeToRegister, halt, createdump, ALUOp, srcALU, srcALUClear, Cin, invA, invB, sign, jumpImm, MemWrite, MemRead, CmpSet, CmpOp, memoryToRegister, link, specialOP, jumpDTaken, jumpDDest, RegWrite, clk, rst, currInstruct, writeBackData, writeBackRegister, writeBackRegisterWrite, plusTwoPC);
	input [15:0] currInstruct;
	input [15:0] writeBackData;
	input [15:0] plusTwoPC;
	input [2:0] writeBackRegister;
	input clk;				
	input rst;				
	input writeBackRegisterWrite;
	output [15:0] read1Data;
	output [15:0] read2Data;
	output [15:0] immediateExt;
	output err;
	
	/* Outputs from control below */
	output [15:0] jumpDDest;
	output [2:0] ALUOp;
	output reg [2:0] writeToRegister;
	output [1:0] CmpOp;	
	output [1:0] specialOP;	
	output halt;
	output createdump;
	output srcALU;
	output srcALUClear;					
	output Cin;
	output invA;
	output invB;
	output sign;		
	output jumpImm;
	output jumpDTaken;
	output MemWrite;
	output MemRead;
	output CmpSet;				
	output memoryToRegister;
	output link;			
	output RegWrite;
	
	//Internal wires for decode and jump detection
	wire [1:0] RegDst;					
	wire SignImm;
	wire immediateFive;
	wire branch;
	wire jumpD;
	wire jumpDconditional;
	reg errDestReg;
	wire errRF;
	wire errControl;
	wire errJumpDetect;
	
	//Master Error detection and jump detection
	assign err = (errRF | errDestReg | errControl | errJumpDetect | (^writeBackData === 1'bz) | (^writeBackData === 1'bx));
	
	//Access Register File
	regFile_bypass i_RF_bypass(.read1Data(read1Data), .read2Data(read2Data), .err(errRF), .clk(clk), .rst(rst), .read1RegSel(currInstruct[10:8]), .read2RegSel(currInstruct[7:5]), .writeRegSel(writeBackRegister), .writeData(writeBackData), .writeEn(writeBackRegisterWrite));
	
	//Call to Jump Detection (This is needed if there is a branch or jump operation)
	branchJumpD jumpDetection(.err(errJumpDetect), .jumpDDest(jumpDDest), .jumpDconditional(jumpDconditional), .branchOp(currInstruct[12:11]), .Rs(read1Data), .immediateExt(immediateExt), 
		.plusTwoPC(plusTwoPC), .branch(branch), .jumpD(jumpD), .D(currInstruct[10:0]));
		
	assign jumpDTaken = (branch | jumpD) & jumpDconditional;
	
	//With register destination, write correct segment to the register
	always @(*) begin
		errDestReg = 1'b0;
		writeToRegister = 3'b000;
		case(RegDst)
			2'b00: writeToRegister = currInstruct[10:8];			
			2'b01: writeToRegister = currInstruct[7:5];			
			2'b10: writeToRegister = currInstruct[4:2];			
			2'b11: writeToRegister = 3'b111;						
			default: errDestReg = 1'b1;
		endcase
	end
	
	assign immediateExt = SignImm ? (immediateFive ? {{11{currInstruct[4]}}, currInstruct[4:0]} : 
									  {{8{currInstruct[7]}}, currInstruct[7:0]}) :
									  (immediateFive ? {11'h000, currInstruct[4:0]} : 
									  {8'h00, currInstruct[7:0]});
							  
	//Determine the currInstruct's control based on its control variables					  
	control globalControlSignal(.err(errControl), .halt(halt), .createdump(createdump), .RegDst(RegDst), .immediateFive(immediateFive), .SignImm(SignImm), .ALUOp(ALUOp), .srcALU(srcALU), .srcALUClear(srcALUClear), .Cin(Cin), .invA(invA), .invB(invB), .sign(sign), .jumpImm(jumpImm), .jumpD(jumpD),
		.branch(branch), .MemWrite(MemWrite), .MemRead(MemRead), .CmpSet(CmpSet), .CmpOp(CmpOp), .memoryToRegister(memoryToRegister), .RegWrite(RegWrite), .link(link), .specialOP(specialOP), .OpCode(currInstruct[15:11]), .funct(currInstruct[1:0]));
	
endmodule

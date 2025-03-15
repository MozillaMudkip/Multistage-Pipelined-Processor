/*
   CS/ECE 552 Fall 2024
   Filename: execute.v
   Description: This module will contain the execute stage of the processor
*/
module execute (err, XOut, jumpImmDest, read1Data, read2Data, immediateExt, ALUOp, srcALU, srcALUClear, Cin, invA, invB, sign, CmpOp, specialOP, CmpSet, jumpImm);
	output [15:0] XOut;
	output [15:0] jumpImmDest;
	output err;
	input [15:0] read1Data;
	input [15:0] read2Data;
	input [15:0] immediateExt;
	input [2:0] ALUOp;
	input [1:0] CmpOp;				
	input [1:0] specialOP;	
	input Cin;
	input invA;
	input invB;
	input sign;			
	input CmpSet;
	input jumpImm;
	input srcALU;
	input srcALUClear;
	
	wire [15:0] InB;
	wire [15:0] ALUOut;
	wire [15:0] read1DataModified;
	reg [15:0] extendedALUOutput;
	reg cmp_Out;
	reg errALU;
	reg errSignals;
	wire Zero;
	wire Neg;
	wire Ofl;
	
	//Master Error based on inputs
	assign err = (errSignals | errALU);
	
	//Execute using the ALU based on inputs from A and B
	assign InB = srcALUClear ? 16'h0000 : (srcALU ? immediateExt : read2Data);
	alu i_ALU(.Out(ALUOut), .Zero(Zero), .Ofl(Ofl), .InA(read1Data), .InB(InB), .Cin(Cin), .Oper(ALUOp), .invA(invA), .invB(invB), .sign(sign));
	
	//If the ALU ouput MSB is 1, we know this is a Neg
	assign Neg = ALUOut[15];
	always @(*) begin
		errSignals = 1'b0;
		cmp_Out = 1'b0;
		case(CmpOp)
			2'b00: cmp_Out = Zero;
			2'b01: cmp_Out = Neg ^ Ofl;				
			2'b10: cmp_Out = (Neg ^ Ofl) | Zero;
			2'b11: cmp_Out = Ofl;
			default: errSignals = 1'b1;
		endcase
	end

	always @(*) begin
		errALU = 1'b0;
		extendedALUOutput = 16'h0000;
		case(specialOP)
			2'b00: extendedALUOutput = ALUOut;								
			2'b01: extendedALUOutput = read1DataModified;						
			2'b10: extendedALUOutput = immediateExt;								
			2'b11: extendedALUOutput = {read1Data[7:0], immediateExt[7:0]};		
			default: errALU = 1'b1;
		endcase
	end
	
	assign read1DataModified = {read1Data[0], read1Data[1], read1Data[2], read1Data[3], read1Data[4], read1Data[5], read1Data[6], read1Data[7], 
					read1Data[8], read1Data[9], read1Data[10], read1Data[11], read1Data[12], read1Data[13], read1Data[14], read1Data[15]};
	
	assign XOut = CmpSet ? cmp_Out : extendedALUOutput;
	
	assign jumpImmDest = ALUOut;			
endmodule

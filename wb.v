/*
   CS/ECE 552 Fall 2024
   Filename: wb.v
   Description: This module will contain the Write Back stage of the processor
*/
module wb (err, plusTwoPC, XOut, writeBackData, memoryToRegister, memoryOut, link);
	output [15:0] writeBackData;
	output err;
	input [15:0] memoryOut;
	input [15:0] plusTwoPC;
	input [15:0] XOut;
	input memoryToRegister;
	input link;
	
	//Master Error based on method inputs
	assign err = (link === 1'bz) | (memoryToRegister === 1'bz) | (^memoryOut === 1'bz) | (^plusTwoPC === 1'bz) | (link === 1'bx) | (memoryToRegister === 1'bx) | (^memoryOut === 1'bx) | (^plusTwoPC === 1'bx);
	
	//Write back the data to the processors register file
	assign writeBackData = link ? plusTwoPC : (memoryToRegister ? memoryOut : XOut);
endmodule

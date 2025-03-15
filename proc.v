module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );
   input clk;
   input rst;
   output err;
	wire errFetch; //Error Output for fetch
	wire errDecode; //Error Output for Decode
	wire errExecute; //Error Output for Execute
	wire errMemory; //Error Output for Memory
	wire errWriteBack; //Error Output for Writeback
	assign err = (errFetch | errDecode | errExecute | errMemory | errWriteBack); //Combined Master Error Signal
	
	//currInstruct and PC data for pipelining use
	wire [15:0] plusTwoPCFetch;
	wire [15:0] plusTwoPCDecode;
	wire [15:0] plusTwoPCExecute;
	wire [15:0] plusTwoPCMemory;
	wire [15:0] plusTwoPCWriteBack;
	wire [15:0] instructionFetch;
	wire [15:0] instructionDecode;
	
	//Jump logic
	wire [15:0] jumpDDest;
	wire jumpDTaken;
	wire jumpImmDecodePipe;
	wire jumpImmExecutePipe;
	
	//Decode Pipeline Logic
	wire [15:0] read1DataDecode;
	wire [15:0] read2DataDecode;
	wire [15:0] immediateExtDecode;
	wire [2:0] writeToRegDecode;
	wire [2:0] ALUOpDecode;
	wire [1:0] CmpOpDecode;
	wire [1:0] extendedOpDecode;
	wire decodeHalt;
	wire createDumpDecode;
	wire srcALUDecode;
	wire srcALUClearDecode;
	wire CinDecode;
	wire invADecode;
	wire invBDecode;
	wire signDecode;
	wire memoryWriteDecode;
	wire memoryReadDecode;
	wire setCmpDecode;
	wire memoryToRegisterDecode;
	wire linkDecode;
	wire registerWriteDecode;
	
	//Execute Pipeline Logic
	wire [15:0] read1DataExecute;
    	wire [15:0] read2DataExecute;
	wire [15:0] immediateExtExecute;
	wire [15:0] XOutExecute;
	wire [15:0] jumpImmDestExecute;
	wire [2:0] writeToRegExecute;
	wire [2:0] ALUOpExecute;
	wire [1:0] CmpOpExecute;
	wire [1:0] extendedOpExecute;
	wire executeHalt;
	wire createDumpExecute;
	wire srcALUExecute;
	wire srcALUClearExecute;
	wire CinExecute;
	wire invAExecute; 
	wire invBExecute; 
	wire signExecute;
	wire memoryWriteExecute;
	wire memoryReadExecute;
	wire setCmpExecute;
	wire memoryToRegisterExecute;
	wire linkExecute;
	wire registerWriteExecute;
	
	//Memory Pipeline Logic
	wire [15:0] read2DataMemory;
	wire [15:0] XOutMemory;
	wire [15:0] memOutMemory;
	wire [2:0] writeToRegMemory;
	wire memoryHalt;
	wire createDumpMemory;
	wire memoryToRegisterMemory;
	wire linkMemory;
	wire registerWriteMemory;
	
	//Write Back Pipeline Logic
	wire [15:0] XOutWriteBack;
	wire [15:0] memOutWriteBack;
	wire [15:0] writeBackData;
	wire [2:0] writeToRegWriteBack;
	wire writeBackHalt;
	wire memoryToRegisterWriteBack;
	wire linkWriteBack;
	wire registerWriteWriteBack;
	
	//Misc Signals
	wire memoryWriteMemory;
	wire memoryReadMemory;
	wire stall;		


	fetch fetch_first_stage(.err(errFetch), .currInstruct(instructionFetch), .plusTwoPC(plusTwoPCFetch), .clk(clk), .rst(rst), .halt(decodeHalt & (~jumpImmExecutePipe) & (~jumpDTaken)),
		.jumpDTaken(jumpDTaken), .jumpDDest(jumpDDest), .jumpImm(jumpImmExecutePipe), .jumpImmDest(jumpImmDestExecute), .stall(stall & ~jumpImmExecutePipe));
	
	fetchtodecodepipe FetchDecodePipe(.outInstruct(instructionDecode), .outPlusTwoPC(plusTwoPCDecode), .clk(clk), .rst(rst), .inInstruct(instructionFetch), .inPlusTwoPC(plusTwoPCFetch),
		.stall(stall), .flush((jumpImmExecutePipe & ~(stall & jumpImmDecodePipe)) | (jumpDTaken & ~stall)));
	
	decode decode_second_stage(.err(errDecode), .read1Data(read1DataDecode), .read2Data(read2DataDecode), .immediateExt(immediateExtDecode), .writeToRegister(writeToRegDecode), .halt(decodeHalt),
		.createdump(createDumpDecode), .ALUOp(ALUOpDecode), .srcALU(srcALUDecode), .srcALUClear(srcALUClearDecode), .Cin(CinDecode), .invA(invADecode), .invB(invBDecode), .sign(signDecode),
		.jumpImm(jumpImmDecodePipe), .jumpDTaken(jumpDTaken), .jumpDDest(jumpDDest), .MemWrite(memoryWriteDecode), .MemRead(memoryReadDecode), .CmpSet(setCmpDecode),
		.CmpOp(CmpOpDecode), .memoryToRegister(memoryToRegisterDecode), .link(linkDecode), .specialOP(extendedOpDecode), .RegWrite(registerWriteDecode), .clk(clk), .rst(rst), .currInstruct(instructionDecode),
		.writeBackData(writeBackData), .writeBackRegister(writeToRegWriteBack), .writeBackRegisterWrite(registerWriteWriteBack), .plusTwoPC(plusTwoPCDecode));
	
	execute execute_third_stage(.err(errExecute), .XOut(XOutExecute), .jumpImmDest(jumpImmDestExecute), .read1Data(read1DataExecute), .read2Data(read2DataExecute), .immediateExt(immediateExtExecute),
		.ALUOp(ALUOpExecute), .srcALU(srcALUExecute), .srcALUClear(srcALUClearExecute), .Cin(CinExecute), .invA(invAExecute), .invB(invBExecute), .sign(signExecute), .CmpOp(CmpOpExecute),
		.specialOP(extendedOpExecute), .CmpSet(setCmpExecute), .jumpImm(jumpImmExecutePipe));
		
	decodetoexecutepipe DecodeExecutePipe(.outRead1Data(read1DataExecute), .outRead2Data(read2DataExecute), .outImmediateExt(immediateExtExecute), .outWriteRegister(writeToRegExecute), .outHalt(executeHalt),
		.outCreateDump(createDumpExecute), .outALUOp(ALUOpExecute), .outSrcALU(srcALUExecute), .outSrcALUClear(srcALUClearExecute), .outCin(CinExecute), .outInvA(invAExecute), .outInvB(invBExecute),
		.outSign(signExecute), .outJumpImm(jumpImmExecutePipe), .outPlusTwoPC(plusTwoPCExecute), .outMemoryWrite(memoryWriteExecute), .outMemoryRead(memoryReadExecute), .outSetCmp(setCmpExecute),
		.outCmpOp(CmpOpExecute), .outMemoryToRegister(memoryToRegisterExecute), .outLink(linkExecute), .outExtendedOp(extendedOpExecute), .outRegisterWrite(registerWriteExecute), .clk(clk), .rst(rst), .inRead1Data(read1DataDecode),
		.inRead2Data(read2DataDecode), .inImmediateExt(immediateExtDecode), .inWriteRegister(writeToRegDecode), .inHalt(decodeHalt), .inCreateDump(createDumpDecode), .inALUOp(ALUOpDecode),
		.inSrcALU(srcALUDecode), .inSrcALUClear(srcALUClearDecode), .inCin(CinDecode), .inInvA(invADecode), .inInvB(invBDecode), .inSign(signDecode), .inJumpImm(jumpImmDecodePipe), .inPlusTwoPC(plusTwoPCDecode),
		.inMemoryWrite(memoryWriteDecode), .inMemoryRead(memoryReadDecode), .inSetCmp(setCmpDecode), .inCmpOp(CmpOpDecode), .inMemoryToRegister(memoryToRegisterDecode), .inLink(linkDecode), .inExtendedOp(extendedOpDecode),
		.inRegisterWrite(registerWriteDecode), .stall(stall), .nop(stall | jumpImmExecutePipe));
	
	memory memory_fourth_stage(.err(errMemory), .memoryOut(memOutMemory), .clk(clk), .rst(rst), .XOut(XOutMemory), .WriteData(read2DataMemory), .MemWrite(memoryWriteMemory & ~writeBackHalt),
		.MemRead(memoryReadMemory), .createdump(createDumpMemory));
		
	executetomemorypipe ExecuteMemoryPipe(.outXout(XOutMemory), .outRead2Data(read2DataMemory), .outMemoryWrite(memoryWriteMemory), .outMemoryRead(memoryReadMemory), .outHalt(memoryHalt), .outCreateDump(createDumpMemory),
		.outLink(linkMemory), .outPlusTwoPC(plusTwoPCMemory), .outMemoryToRegister(memoryToRegisterMemory), .outWriteRegister(writeToRegMemory), .outRegisterWrite(registerWriteMemory),
		.clk(clk), .rst(rst), .inXOut(XOutExecute), .inRead2Data(read2DataExecute), .inMemoryWrite(memoryWriteExecute), .inMemoryRead(memoryReadExecute), .inHalt(executeHalt), .inCreateDump(createDumpExecute),
		.inLink(linkExecute), .inPlusTwoPC(plusTwoPCExecute), .inMemoryToRegister(memoryToRegisterExecute), .inWriteRegister(writeToRegExecute), .inRegisterWrite(registerWriteExecute));
	
	wb wb_fifth_stage(.err(errWriteBack), .writeBackData(writeBackData), .link(linkWriteBack), .plusTwoPC(plusTwoPCWriteBack), .memoryToRegister(memoryToRegisterWriteBack), .memoryOut(memOutWriteBack), .XOut(XOutWriteBack));
	
	memorytowritebackpipe MemoryWBPipe(.outMemoryOut(memOutWriteBack), .outXout(XOutWriteBack), .outLink(linkWriteBack), .outPlusTwoPC(plusTwoPCWriteBack), .outMemoryToRegister(memoryToRegisterWriteBack), .outWriteRegister(writeToRegWriteBack),
		.outRegisterWrite(registerWriteWriteBack), .outHalt(writeBackHalt), .clk(clk), .rst(rst), .inMemoryOut(memOutMemory), .inXOut(XOutMemory), .inLink(linkMemory), .inPlusTwoPC(plusTwoPCMemory), .inMemoryToRegister(memoryToRegisterMemory),
		.inWriteRegister(writeToRegMemory), .inRegisterWrite(registerWriteMemory), .inHalt(memoryHalt));
endmodule 
// DUMMY LINE FOR REV CONTROL :0:

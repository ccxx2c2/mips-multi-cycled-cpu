module cpu(input reset,[4:0]p);
    wire [31:0]imemin,imemout;
    wire pcsgn,pcinc;
    wire [31:0]pcin,pcout,pcnext;
    wire irsgn,error;
    wire [31:0]irin,irout;
    wire [5:0]cuop,cufunc;
    wire [4:0]regimm;
    wire[1:0] lorD, AluSrcA;
    wire [3:0]  RegDst, MemtoReg;
    wire [3:0] AluSrcB,PCSource;
    wire [0:0]PCWrite,ImemWrite,cupcinc,regwrite,memWrite,pccond;
    wire [1:0]shiftSrc,mdrinctrl;
    wire [5:0]AluOp;
    wire [4:0] graddr1,graddr2,grinaddr;
    wire grsignal;
    wire [31:0] grdata;
    wire [31:0] gro1,gro2;
    wire[31:0] ain,bin,aoin;
    wire [31:0] aout,bout,aoout;
    wire [31:0] alua,alub;
    wire [5:0]alufunc;
    wire [31:0] aluo;
    wire aluov,aluerr;
    wire [15:0] sgnexin;
    wire [31:0] sgnexout,sft2in,sft2out;
    wire [31:0] dmemdata,dmeminaddr, dmemoaddr, dmemout;
    wire dmemsignal;
    wire [31:0] mdrin,mdrout;
    wire pcwritecond;
    IMem IMem(imemin,imemout);
    pc pc(pcin,pcsgn,pcinc,reset,pcnext,pcout);
    IR IR(irin,irsgn,irout);
    CU CU(cuop,cufunc,regimm,p,reset,error,lorD,RegDst,MemtoReg,AluSrcA,AluSrcB,PCSource,PCWrite,ImemWrite,cupcinc,AluOp,regwrite,memWrite,shiftSrc,pccond,mdrinctrl);
    gr gr(graddr1,graddr2, grinaddr,grsignal,grdata,gro1,gro2);
    A A(ain,aout);
    A B(bin,bout);
    alu alu(alua,alub,alufunc,aluo,aluov,aluerr);
    A aluout(aoin,aoout);
    SignExtend SignExtend(sgnexin,sgnexout);
    shift2 shift2(sft2in,sft2out);
    DMem DMem(dmemdata,dmemsignal,dmeminaddr, dmemoaddr, dmemout);
    A mdr(mdrin,mdrout);
    
    assign pcsgn = PCWrite || (pccond && pcwritecond);
    assign imemin = pcout;
    assign irsgn = ImemWrite;
    assign irin = imemout;
    assign pcinc = cupcinc;
    
    assign cuop = irout[31:26];
    assign graddr1 = irout[25:21];
    assign graddr2 = irout[20:16];
    assign cufunc = irout[5:0];
    assign sgnexin = irout[15:0];
    assign regimm = irout[20:16];
    mux2 mux23(sgnexout,irout,shiftSrc,sft2in);
    
    assign ain = gro1;
    assign bin = gro2;
    mux2 mux21(pcout,aout,AluSrcA,alua);
    mux4 mux41(bout,0,sgnexout,sft2out,AluSrcB,alub);
    assign alufunc = AluOp;
    assign aoin = aluo;
    assign error = aluerr;
    
    mux4 mux44(0,aoout,{pcout[31:28],sft2out[27:0]},0,PCSource,pcin);
    assign dmemoaddr = aoout;
    assign pcwritecond = aluov;
    assign dmemsignal = memWrite;
    assign dmeminaddr = aoout;
    assign dmemdata = bout;
    mux2 mux22(dmemout,pcnext,mdrinctrl,mdrin);
    
    
    mux4 mux42(irout[20:16],irout[15:11],31,0,RegDst,grinaddr);
    mux4 mux43(aoout,mdrout,0,0,MemtoReg,grdata);
    assign grsignal = regwrite;
    
endmodule
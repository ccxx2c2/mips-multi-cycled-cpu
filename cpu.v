module cpu(input reset,[4:0]p);
    wire [31:0]imemin,imemout;
    reg pcsgn,pcinc;
    reg [31:0]pcin;
    wire [31:0]pcout,pcnext;
    reg irsgn;
    wire [31:0]irin,irout;
    wire [5:0]cuop,cufunc;
    wire[1:0] lorD, RegDst, MemtoReg, AluSrcA;
    wire [3:0] AluSrcB;
    wire [2:0] PCSource;
    wire [4:0] graddr1,graddr2,grinaddr;
    reg grsignal;
    wire [31:0] grdata;
    wire [31:0] gro1,gro2;
    wire[31:0] ain,bin,aoin;
    reg asignal,bsignal,aosignal;
    wire [31:0] aout,bout,aoout;
    wire [31:0] alua,alub;
    reg [5:0]alufunc;
    wire [31:0] aluo;
    wire aluov;
    IMem IMem(imemin,imemout);
    pc pc(pcin,pcsgn,pcinc,pcnext,pcout);
    IR IR(irin,irsgn,irout);
    CU CU(cuop,cufunc,p,lorD,RegDst,MemtoReg,AluSrcA,AluSrcB,PCSource);
    gr gr(graddr1,graddr2, grinaddr,grsignal,grdata,gro1,gro2);
    A A(ain,asignal,aout);
    B B(bin,bsignal,bout);
    alu alu(alua,alub,alufunc,aluo,aluov);
    aluout aluout(aoin,aosignal,aoout);
    assign imemin = pcout;
    assign irin = imemout;
    assign cuop = irout[31:26];
    assign graddr1 = irout[25:21];
    assign graddr2 = irout[20:16];
    assign cufunc = irout[5:0];
    assign ain = gro1;
    assign bin = gro2;
    assign alua = aout;
    assign alub = bout;
    assign aoin = aluo;
    assign grinaddr = irout[15:11];
    assign grdata = aoout;
    always @(p,reset)
    begin
        pcsgn = 0;
        irsgn = 0;
        grsignal = 0;
        asignal = 0;
        bsignal = 0;
        aosignal = 0;
        if(reset) begin
            pcin = 0;
            pcsgn = 1;
            pcinc = 0;
        end
        if(p[0]) begin
            irsgn = 1;
        end
        if(p[1]) begin
            pcinc = 1;
            pcin = pcout;
            asignal = 1;
            bsignal = 1;
        end
        if(p[2]) begin
            alufunc = 6'b000010;
            aosignal = 1;
        end
        if(p[4]) begin
            grsignal = 1;
        end
    end
endmodule
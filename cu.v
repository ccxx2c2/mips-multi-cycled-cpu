module CU(input[5:0] op,[5:0] irfunc,[4:0] p, output[1:0] lorD,[1:0] RegDst,[1:0] MemtoReg,[1:0] AluSrcA,[3:0] AluSrcB,[2:0] PCSource);
//p:p0~p4的阶段值，为p0时p[0]=1,类推
wire add,lw,sw;
assign add = (op == 6'b000000) && (irfunc == 6'b100000);
//add : op == 0, irfunc == 6'b100000
assign lw = op[5] && (!op[4]) && (!op[3]) && (!op[2]) && op[1] && op[0] ? 1 : 0 ;
//lw == 6'b100011
assign sw = op[5] && (!op[4]) && op[3] && (!op[2]) && op[1] && op[0] ? 1 : 0 ;
//sw == 6'b101011
assign lorD = p[0] ? 2'b01 :
        p[3] && lw ? 2'b10 : 2'b00 ;
assign RegDst = p[4] && lw ? 2'b01 :
                p[4] && add ? 2'b10 : 2'b00 ;
assign MemtoReg = p[4] && add ? 2'b01 :
                  p[3] && lw ? 2'b10 : 2'b00 ;
assign AluSrcA = p[0] ? 2'b01 :
              p[2] ? 2'b10 : 2'b00 ;
assign AluSrcB = p[2] && add ? 4'b0001 :
                     p[0] ? 4'b0010 :
       p[2] && (lw || sw) ? 4'b1000 : 4'b0000 ;
assign PCSource = p[0] ? 3'b001 : 3'b000 ;
endmodule;


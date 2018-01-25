module CU(input[5:0] op,[5:0] irfunc,[4:0] p,[0:0]reset, output[1:0] lorD,[3:0] RegDst,[3:0] MemtoReg,[1:0] AluSrcA,[3:0] AluSrcB,[3:0] PCSource,PCWrite,ImemWrite,pcinc,[5:0]AluOp,regwrite,memWrite,[1:0] shiftSrc,pccond);
//p:p0~p4的阶段值，为p0时p[0]=1,类推
wire add,lw,sw,j,jal;
assign add = (op == 6'b000000) && (irfunc == 6'b100000);
assign lw = (op == 6'b100011) ;
assign sw = (op == 6'b101011) ;
assign j = op == 6'b000010;
assign jal = op == 6'b000011;
assign beq = op == 6'b000100;
assign bne = op == 6'b000101;


assign ImemWrite = p[0] ? 1'b1 : 1'b0;
assign PCWrite = p[4] && (j || jal) ? 1'b1 : 1'b0;
assign pccond = p[2] && (beq || bne) ? 1'b1 : 1'b0;
assign pcinc = p[1] ? 1 : 0;
assign lorD = p[0] ? 2'b01 :
        p[3] && lw ? 2'b10 : 2'b00 ;
assign RegDst = p[4] && lw ? 4'b0001 :
                p[4] && add ? 4'b0010 : 
                p[4] && jal ? 4'b0100 :4'b0000 ;
assign MemtoReg = p[4] && add ? 4'b0001 :
                  p[3] && lw ? 4'b0010 :
                  p[4] && jal ? 4'b0100 :4'b0000 ;
assign AluSrcA = (p[2] && (add || lw || sw || beq || bne)) ? 2'b10 :
                 (p[1] && (beq || bne)) ? 2'b01 : 2'b00 ;
assign AluSrcB = (p[2] && (add || beq || bne)) ? 4'b0001 :
                 (p[2] && (lw || sw) || p[1] && ( beq || bne)) ? 4'b1000 : 4'b0000 ;
assign AluOp = p[2] && add || p[1] && (beq || bne) || p[3] && (lw || sw) ? 6'b000010 :
               p[2] && beq ? 6'b100011 :
               p[2] && bne ? 6'b100001 : 6'b000000;
assign PCSource = p[2] && (j || jal) ? 4'b0100 : 
                  p[2] && (beq || bne) ? 4'b0010 : 4'b000 ;
assign regwrite = p[4] ? 1 : 0;
assign memWrite = p[3] && sw ? 1 : 0;
assign shiftSrc = p[2] && (lw || sw ) || p[1] && (beq || bne) ? 2'b01 :
                  p[2] && (j || jal) ? 2'b10 : 2'b00;
endmodule;


module CU(input[5:0] op,[5:0] irfunc,[4:0]regimm,[4:0] p,[0:0]reset,[0:0]error, output[1:0] lorD,[3:0] RegDst,[3:0] MemtoReg,[3:0] AluSrcA,[4:0] AluSrcB,[3:0] PCSource,PCWrite,ImemWrite,pcinc,[5:0]AluOp,regwrite,memWrite,[1:0] shiftSrc,pccond,[1:0]mdrinctrl,[3:0]lsgn,[3:0]ssgn);
//p:p0~p4的阶段值，为p0时p[0]=1,类推
wire add,lw,sw,j,jal,beq,bne,slt,jr,jalr;
wire myand,myor,myxor,mynor,addiu,andi,ori,xori;
wire bgez, bgtz, blez, bltz, sub, subu, slti, sltu, sltiu;
wire lbu,lb,lhu,lh,sb,sh,lui;
wire excp;
assign add = (op == 6'b000000) && (irfunc == 6'b100000);
assign lw = (op == 6'b100011) ;
assign sw = (op == 6'b101011) ;
assign j = op == 6'b000010;
assign jal = op == 6'b000011;
assign beq = op == 6'b000100;
assign bne = op == 6'b000101;
assign bgez = (op == 6'b000001) && (regimm == 5'b00001);
assign bgtz = (op == 6'b000111);
assign blez = (op == 6'b000110);
assign bltz = (op == 6'b000001) && (regimm == 5'b00000);
assign slt = (op == 6'b000000) && (irfunc == 6'b101010);
assign jr = (op == 6'b000000) && (irfunc == 6'b001000);
assign jalr = (op == 6'b000000) && (irfunc == 6'b001001);
assign myand = (op == 6'b000000) && (irfunc == 6'b100100);
assign myor = (op == 6'b000000) && (irfunc == 6'b100101);
assign myxor = (op == 6'b000000) && (irfunc == 6'b100110);
assign mynor = (op == 6'b000000) && (irfunc == 6'b100111);
assign addiu = (op == 6'b001001);
assign andi = (op == 6'b001100);
assign ori = (op == 6'b001101);
assign xori = (op == 6'b001110);
assign sub  = (op == 6'b000000) && (irfunc == 6'b100010);
assign subu  = (op == 6'b000000) && (irfunc == 6'b100011);
assign slti = (op == 6'b001010);
assign sltiu = (op == 6'b001011);
assign sltu = (op == 6'b000000) && (irfunc == 6'b101011);
assign sh = (op == 6'b101001);
assign sb = (op == 6'b101000);
assign lb = (op == 6'b100000);
assign lbu = (op == 6'b100100);
assign lh = (op == 6'b100001);
assign lhu = (op == 6'b100101);
assign lui = (op == 6'b001111);
assign sra  = (op == 6'b000000) && (irfunc == 6'b000011);
assign srav  = (op == 6'b000000) && (irfunc == 6'b000111);
assign srl  = (op == 6'b000000) && (irfunc == 6'b000010);
assign srlv  = (op == 6'b000000) && (irfunc == 6'b000110);
assign sll = (op == 6'b000000) && (irfunc == 6'b000000);
assign sllv = (op == 6'b000000) && (irfunc == 6'b000010);

assign simpleCalcR = (add || slt || myand || myor || myxor || mynor || sub || subu || sltu || srav || srlv || sllv);
assign simpleCalcI = (addiu || andi || ori || xori || slti || sltiu || sra || srl || sll);
assign branches = (beq || bne || bgez || bgtz || blez || bltz);
assign loads = (lw || lb || lbu || lh || lhu);
assign saves = (sw || sh || sb);
assign shifts = (sra || srav || srl || srlv || sll || sllv);

assign ImemWrite = p[0] ? 1'b1 : 1'b0;
assign PCWrite = p[4] && (j || jal || jr || jalr) ? 1'b1 : 1'b0;
assign pccond = p[2] && branches ? 1'b1 : 1'b0;
assign pcinc = p[1] ? 1 : 0;
assign lorD = p[0] ? 2'b01 :
        p[3] && loads ? 2'b10 : 2'b00 ;
assign RegDst = p[4] && (loads || simpleCalcI || lui) ? 4'b0001 :
                p[4] && (simpleCalcR || jalr) ? 4'b0010 : 
                p[4] && jal ? 4'b0100 :4'b0000 ;
assign MemtoReg = p[4] && (simpleCalcR || simpleCalcI) ? 4'b0001 :
                  p[3] && lw || p[4] && (jal || jalr)? 4'b0010 :
                  p[3] && (lb || lbu || lh || lhu) ? 4'b0100 : 
                  p[4] && (lui) ? 4'b1000 : 4'b0000 ;
assign AluSrcA = (p[2] && (simpleCalcR  || (simpleCalcI && ~shifts) || loads || saves || branches || jr || jalr)) ? 4'b0010 :
                 (p[1] && branches) ? 4'b0001 : 
                 (p[2] && shifts && ~simpleCalcR) ? 4'b0100 : 4'b0000 ;
assign AluSrcB = (p[2] && (simpleCalcR || beq || bne || shifts)) ? 5'b00001 :
                 (p[2] && (bgez || bgtz || blez || bltz)) ? 5'b00010 :
                 (p[2] && simpleCalcI && ~shifts) ? 5'b00100 :
                 (p[2] && (loads || saves) || p[1] && branches) ? 5'b01000 : 5'b00000 ;
assign AluOp = p[2] && (add || addiu) || p[1] && branches || p[3] && (loads || saves) ? 6'b000010 :
               p[2] && (sub || subu) ? 6'b000100 :
               p[2] && beq ? 6'b000110 :
               p[2] && bne ? 6'b100001 :
               p[2] && bgez ? 6'b010100 :
               p[2] && bgtz ? 6'b100010 :
               p[2] && blez ? 6'b001100 :
               p[2] && bltz ? 6'b100100 :
               p[2] && (slt || slti) ? 6'b001001 : 
               p[2] && (sltu || sltiu) ? 6'b000101 : 
               p[2] && (myand || andi) ? 6'b001000 : 
               p[2] && (myor || ori) ? 6'b010000 : 
               p[2] && (myxor || xori) ? 6'b010001 : 
               p[2] && mynor ? 6'b100000 : 
               p[2] && (jr || jalr) ? 6'b001010 :
               p[2] && (sra || srav) ? 6'b011000 :
               p[2] && (srl || srlv) ? 6'b101000 :
               p[2] && (sll || sllv) ? 6'b110000 : 6'b000000;
               
               
assign lsgn =  p[3] && lh ? 4'b0001 :
               p[3] && lhu ? 4'b0010 :
               p[3] && lb ? 4'b0100 :
               p[3] && lbu ? 4'b1000 : 4'b0000;
               
               
assign ssgn =  p[3] && sw ? 4'b0001 :
               p[3] && sh ? 4'b0010 :
               p[3] && sb ? 4'b0100 : 4'b0000;
assign PCSource = p[2] && (j || jal) ? 4'b0100 : 
                  p[2] && (branches || jr || jalr) ? 4'b0010 : 4'b000 ;
assign regwrite = (p[4] && ~excp) ? 1 : 0;
assign memWrite = p[3] && saves ? 1 : 0;
assign shiftSrc = p[2] && (loads || saves) || p[1] && branches ? 2'b01 :
                  p[2] && (j || jal) ? 2'b10 : 2'b00;
assign mdrinctrl = (p[2]) && (jal || jalr) ? 2'b10 :
                    (p[3] || p[4]) && (jal || jalr) ? 2'b00 : 2'b01;
                    
assign excp = (add || sub) && error;
endmodule;


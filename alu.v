
module alu(input[31:0] A,input[31:0] B,input[5:0] Func,output [31:0] O,output sgn,output err);
    wire t;
    reg clk;
    reg[31:0] OO;
    wire OV1;
    wire OV2;
    wire[31:0] O0;
    wire[31:0] O1;
    wire[31:0] O2;
    wire[31:0] O3;
    wire[31:0] O4;
    wire[31:0] O5;
    wire[31:0] O6;
    wire[31:0] O7;
    wire[31:0] O8;
    assign t=0;
    add f0(.A(A),.B(B),.C0(t),.O(O0),.C32(OV1));
    minus f1(.A(A),.B(B),.O(O1),.C32(OV2));
    myand f2(.A(A),.B(B),.O(O2));
    myor f3(.A(A),.B(B),.O(O3));
    mynor f4(.A(A),.B(B),.O(O4));
    mynand f5(.A(A),.B(B),.O(O5));
    ult f6(.A(A),.B(B),.O(O6));
    lte f7(.A(A),.B(B),.O(O7));
    myxor f8(A,B,O8);
    //unequal f9(A,B,O9);
        assign sgn= (Func == 6'b100001)? ~(O8 == 0) :
       (Func == 6'b000110)? O8 == 0:
       (Func == 6'b001100)? O7[0] :
       (Func == 6'b100100)? O7[0] & ~(O8 == 0):
       (Func == 6'b100010)? ~ O7[0] :
       (Func == 6'b010100)? ~(O7[0] & ~(O8 == 0)) : 0;     
       assign O=(Func == 6'b000010)?O0:
       (Func == 6'b000100)?O1:
       (Func == 6'b001000)?O2:
       (Func == 6'b010000)?O3:
       (Func == 6'b100000)?O4:
       (Func == 6'b000011)?O5:
       (Func == 6'b000101)?O6:
       (Func == 6'b001001)?O7 & ~(O8 == 0):
       (Func == 6'b010001)?O8:
       (Func == 6'b001010)?A:
       (Func == 6'b010010)?B:O;
        assign err = (Func == 6'b000010)?OV1:
       (Func == 6'b000100)?OV2: 0;
endmodule;

module adder(input ai,input bi,input ci,output oi);
  assign oi = (ai^bi)^ci;
endmodule;

module CLA_8(input[7:0] A,input[7:0] B,input C0,output[7:0] C,output Gs,output Ps);
  wire[7:0] G;
  wire[7:0] P;
  
  assign G[0] = A[0]&B[0];
  assign G[1] = A[1]&B[1];
  assign G[2] = A[2]&B[2];
  assign G[3] = A[3]&B[3];
  assign G[4] = A[4]&B[4];
  assign G[5] = A[5]&B[5];
  assign G[6] = A[6]&B[6];
  assign G[7] = A[7]&B[7];
  
  assign P[0] = A[0]^B[0];
  assign P[1] = A[1]^B[1];
  assign P[2] = A[2]^B[2];
  assign P[3] = A[3]^B[3];
  assign P[4] = A[4]^B[4];
  assign P[5] = A[5]^B[5];
  assign P[6] = A[6]^B[6];
  assign P[7] = A[7]^B[7];
  
  assign C[0]= G[0] | (P[0]&C0);
  assign C[1]= G[1] | (P[1]&G[0]) | (P[1]&P[0]&C0);
  assign C[2]= G[2] | (P[2]&G[1]) | (P[2]&P[1]&G[0]) | (P[2]&P[1]&P[0]&C0);
  assign C[3]= G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]) | (P[3]&P[2]&P[1]&P[0]&C0);
  assign C[4]= G[4] | (P[4]&G[3]) | (P[4]&P[3]&G[2]) | (P[4]&P[3]&P[2]&G[1]) | (P[4]&P[3]&P[2]&P[1]&G[0]) | (P[4]&P[3]&P[2]&P[1]&P[0]&C0);
  assign C[5]= G[5] | (P[5]&G[4]) | (P[5]&P[4]&G[3]) | (P[5]&P[4]&P[3]&G[2]) | (P[5]&P[4]&P[3]&P[2]&G[1]) | (P[5]&P[4]&P[3]&P[2]&P[1]&G[0]) | (P[5]&P[4]&P[3]&P[2]&P[1]&P[0]&C0);
  assign C[6]= G[6] | (P[6]&G[5]) | (P[6]&P[5]&G[4]) | (P[6]&P[5]&P[4]&G[3]) | (P[6]&P[5]&P[4]&P[3]&G[2]) | (P[6]&P[5]&P[4]&P[3]&P[2]&G[1]) | (P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&G[0]) | (P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&P[0]&C0);
  assign C[7]= G[7] | (P[7]&G[6]) | (P[7]&P[6]&G[5]) | (P[7]&P[6]&P[5]&G[4]) | (P[7]&P[6]&P[5]&P[4]&G[3]) | (P[7]&P[6]&P[5]&P[4]&P[3]&G[2]) | (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&G[1]) | (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&G[0]) | (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&P[0]&C0);

  assign Gs = G[7] | (P[7]&G[6]) | (P[7]&P[6]&G[5]) | (P[7]&P[6]&P[5]&G[4]) | (P[7]&P[6]&P[5]&P[4]&G[3]) | (P[7]&P[6]&P[5]&P[4]&P[3]&G[2]) | (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&G[1]) | (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&G[0]);//G*
  
  assign Ps = P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&P[0];//P*
endmodule;

module CLA_4(input[3:0] G,input[3:0] P,input C0,output C1,output C2,output C3,output C4);
  
  wire[3:0] C;
  assign  C[0]= G[0] | (P[0]&C0);
  assign C[1]= G[1] | (P[1]&G[0]) | (P[1]&P[0]&C0);
  assign C[2]= G[2] | (P[2]&G[1]) | (P[2]&P[1]&G[0]) | (P[2]&P[1]&P[0]&C0);
  assign C[3]= G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]) | (P[3]&P[2]&P[1]&P[0]&C0);
  
  assign C1=C[0];
  assign C2=C[1];
  assign C3=C[2];
  assign C4=C[3];
endmodule;

module add(input[31:0] A,input[31:0] B,input C0,output[31:0] O,output C32);
  
  wire [31:0] C;
  wire [31:0] T;
  wire [3:0] Gs;
  wire [3:0] Ps;
  
  wire [3:0] tt;
  wire [3:0] ts;
  wire [7:0] ttt;
  wire ttq;
  
  reg [3:0] b;
  reg clk;
  reg c=1;
  wire a;
  
  CLA_8 md1(.A(A[7:0]),.B(B[7:0]),.C0(C0),.C({ttq,C[6:0]}),.Gs(Gs[0]),.Ps(Ps[0]));
  CLA_8 md2(.A(A[15:8]),.B(B[15:8]),.C0(C0),.C(ttt[7:0]),.Gs(Gs[1]),.Ps(Ps[1]));
  CLA_8 md3(.A(A[23:16]),.B(B[23:16]),.C0(C0),.C(ttt[7:0]),.Gs(Gs[2]),.Ps(Ps[2]));
  CLA_8 md4(.A(A[31:24]),.B(B[31:24]),.C0(C0),.C(ttt[7:0]),.Gs(Gs[3]),.Ps(Ps[3]));
/*  always@(posedge clk) begin
   b<={b[3:1],c};
 end*/
  CLA_4 md5(.G(Gs[3:0]),.P(Ps[3:0]),.C0(C0),.C1(C[7]),.C2(C[15]),.C3(C[23]),.C4(C[31]));
/* always@(posedge clk) begin
   b<={b[3:1],c};
 end*/
  
  CLA_8 md6(.A(A[15:8]),.B(B[15:8]),.C0(C[7]),.C({ttq,C[14:8]}),.Gs(tt[1]),.Ps(ts[1]));
  CLA_8 md7(.A(A[23:16]),.B(B[23:16]),.C0(C[15]),.C({ttq,C[22:16]}),.Gs(tt[2]),.Ps(ts[2]));
  CLA_8 md8(.A(A[31:24]),.B(B[31:24]),.C0(C[23]),.C({ttq,C[30:24]}),.Gs(tt[3]),.Ps(ts[3]));
  
  assign O[0]=A[0]^B[0]^C0;
  assign O[1]=A[1]^B[1]^C[0];
  assign O[2]=A[2]^B[2]^C[1];
  assign O[3]=A[3]^B[3]^C[2];
  assign O[4]=A[4]^B[4]^C[3];
  assign O[5]=A[5]^B[5]^C[4];
  assign O[6]=A[6]^B[6]^C[5];
  assign O[7]=A[7]^B[7]^C[6];
  assign O[8]=A[8]^B[8]^C[7];
  assign O[9]=A[9]^B[9]^C[8];
  assign O[10]=A[10]^B[10]^C[9];
  assign O[11]=A[11]^B[11]^C[10];
  assign O[12]=A[12]^B[12]^C[11];
  assign O[13]=A[13]^B[13]^C[12];
  assign O[14]=A[14]^B[14]^C[13];
  assign O[15]=A[15]^B[15]^C[14];
  assign O[16]=A[16]^B[16]^C[15];
  assign O[17]=A[17]^B[17]^C[16];
  assign O[18]=A[18]^B[18]^C[17];
  assign O[19]=A[19]^B[19]^C[18];
  assign O[20]=A[20]^B[20]^C[19];
  assign O[21]=A[21]^B[21]^C[20];
  assign O[22]=A[22]^B[22]^C[21];
  assign O[23]=A[23]^B[23]^C[22];
  assign O[24]=A[24]^B[24]^C[23];
  assign O[25]=A[25]^B[25]^C[24];
  assign O[26]=A[26]^B[26]^C[25];
  assign O[27]=A[27]^B[27]^C[26];
  assign O[28]=A[28]^B[28]^C[27];
  assign O[29]=A[29]^B[29]^C[28];
  assign O[30]=A[30]^B[30]^C[29];
  assign O[31]=A[31]^B[31]^C[30];
  assign C32=C[31];
endmodule


module minus(input[31:0] A,input[31:0] B,output[31:0] O,output C32);
  wire [31:0] GG;
  wire [31:0] T;
  wire [31:0] Q;
  wire [31:0] R;
  wire tt;
  wire tq;
  wire ts;
  
  assign T[0]=~B[0];
  assign T[1]=~B[1];
  assign T[2]=~B[2];
  assign T[3]=~B[3];
  assign T[4]=~B[4];
  assign T[5]=~B[5];
  assign T[6]=~B[6];
  assign T[7]=~B[7];
  assign T[8]=~B[8];
  assign T[9]=~B[9];
  assign T[10]=~B[10];
  assign T[11]=~B[11];
  assign T[12]=~B[12];
  assign T[13]=~B[13];
  assign T[14]=~B[14];
  assign T[15]=~B[15];
  assign T[16]=~B[16];
  assign T[17]=~B[17];
  assign T[18]=~B[18];
  assign T[19]=~B[19];
  assign T[20]=~B[20];
  assign T[21]=~B[21];
  assign T[22]=~B[22];
  assign T[23]=~B[23];
  assign T[24]=~B[24];
  assign T[25]=~B[25];
  assign T[26]=~B[26];
  assign T[27]=~B[27];
  assign T[28]=~B[28];
  assign T[29]=~B[29];
  assign T[30]=~B[30];
  assign T[31]=~B[31];
  
  assign Q[0]=1;
  assign Q[1]=0;
  assign Q[2]=0;
  assign Q[3]=0;
  assign Q[4]=0;
  assign Q[5]=0;
  assign Q[6]=0;
  assign Q[7]=0;
  assign Q[8]=0;
  assign Q[9]=0;
  assign Q[10]=0;
  assign Q[11]=0;
  assign Q[12]=0;
  assign Q[13]=0;
  assign Q[14]=0;
  assign Q[15]=0;
  assign Q[16]=0;
  assign Q[17]=0;
  assign Q[18]=0;
  assign Q[19]=0;
  assign Q[20]=0;
  assign Q[21]=0;
  assign Q[22]=0;
  assign Q[23]=0;
  assign Q[24]=0;
  assign Q[25]=0;
  assign Q[26]=0;
  assign Q[27]=0;
  assign Q[28]=0;
  assign Q[29]=0;
  assign Q[30]=0;
  assign Q[31]=0;
  
  assign tt=1;
  assign tq=0;
   // add DUT1 (.A(T),.B(Q),.C0(tt),.O(R),.C32(ts));
    add DUT2 (.A(A),.B(T),.C0(tt),.O(O),.C32(C32));
endmodule

module myand(input [31:0]A,input [31:0] B,output [31:0] O);
 assign O[0] = A[0]&B[0];
 assign O[1] = A[1]&B[1];
 assign O[2] = A[2]&B[2];
 assign O[3] = A[3]&B[3];
 assign O[4] = A[4]&B[4];
 assign O[5] = A[5]&B[5];
 assign O[6] = A[6]&B[6];
 assign O[7] = A[7]&B[7];
 assign O[8] = A[8]&B[8];
 assign O[9] = A[9]&B[9];
 assign O[10] = A[10]&B[10];
 assign O[11] = A[11]&B[11];
 assign O[12] = A[12]&B[12];
 assign O[13] = A[13]&B[13];
 assign O[14] = A[14]&B[14];
 assign O[15] = A[15]&B[15];
 assign O[16] = A[16]&B[16];
 assign O[17] = A[17]&B[17];
 assign O[18] = A[18]&B[18];
 assign O[19] = A[19]&B[19];
 assign O[20] = A[20]&B[20];
 assign O[21] = A[21]&B[21];
 assign O[22] = A[22]&B[22];
 assign O[23] = A[23]&B[23];
 assign O[24] = A[24]&B[24];
 assign O[25] = A[25]&B[25];
 assign O[26] = A[26]&B[26];
 assign O[27] = A[27]&B[27];
 assign O[28] = A[28]&B[28];
 assign O[29] = A[29]&B[29];
 assign O[30] = A[30]&B[30];
 assign O[31] = A[31]&B[31];
endmodule

module myor(input [31:0]A,input [31:0] B,output [31:0] O);
 assign O[0] = A[0]|B[0];
 assign O[1] = A[1]|B[1];
 assign O[2] = A[2]|B[2];
 assign O[3] = A[3]|B[3];
 assign O[4] = A[4]|B[4];
 assign O[5] = A[5]|B[5];
 assign O[6] = A[6]|B[6];
 assign O[7] = A[7]|B[7];
 assign O[8] = A[8]|B[8];
 assign O[9] = A[9]|B[9];
 assign O[10] = A[10]|B[10];
 assign O[11] = A[11]|B[11];
 assign O[12] = A[12]|B[12];
 assign O[13] = A[13]|B[13];
 assign O[14] = A[14]|B[14];
 assign O[15] = A[15]|B[15];
 assign O[16] = A[16]|B[16];
 assign O[17] = A[17]|B[17];
 assign O[18] = A[18]|B[18];
 assign O[19] = A[19]|B[19];
 assign O[20] = A[20]|B[20];
 assign O[21] = A[21]|B[21];
 assign O[22] = A[22]|B[22];
 assign O[23] = A[23]|B[23];
 assign O[24] = A[24]|B[24];
 assign O[25] = A[25]|B[25];
 assign O[26] = A[26]|B[26];
 assign O[27] = A[27]|B[27];
 assign O[28] = A[28]|B[28];
 assign O[29] = A[29]|B[29];
 assign O[30] = A[30]|B[30];
 assign O[31] = A[31]|B[31];
endmodule

module mynor(input [31:0]A,input [31:0] B,output [31:0] O);
 assign O[0] = ~(A[0]|B[0]);
 assign O[1] = ~(A[1]|B[1]);
 assign O[2] = ~(A[2]|B[2]);
 assign O[3] = ~(A[3]|B[3]);
 assign O[4] = ~(A[4]|B[4]);
 assign O[5] = ~(A[5]|B[5]);
 assign O[6] = ~(A[6]|B[6]);
 assign O[7] = ~(A[7]|B[7]);
 assign O[8] = ~(A[8]|B[8]);
 assign O[9] = ~(A[9]|B[9]);
 assign O[10] = ~(A[10]|B[10]);
 assign O[11] = ~(A[11]|B[11]);
 assign O[12] = ~(A[12]|B[12]);
 assign O[13] = ~(A[13]|B[13]);
 assign O[14] = ~(A[14]|B[14]);
 assign O[15] = ~(A[15]|B[15]);
 assign O[16] = ~(A[16]|B[16]);
 assign O[17] = ~(A[17]|B[17]);
 assign O[18] = ~(A[18]|B[18]);
 assign O[19] = ~(A[19]|B[19]);
 assign O[20] = ~(A[20]|B[20]);
 assign O[21] = ~(A[21]|B[21]);
 assign O[22] = ~(A[22]|B[22]);
 assign O[23] = ~(A[23]|B[23]);
 assign O[24] = ~(A[24]|B[24]);
 assign O[25] = ~(A[25]|B[25]);
 assign O[26] = ~(A[26]|B[26]);
 assign O[27] = ~(A[27]|B[27]);
 assign O[28] = ~(A[28]|B[28]);
 assign O[29] = ~(A[29]|B[29]);
 assign O[30] = ~(A[30]|B[30]);
 assign O[31] = ~(A[31]|B[31]);
endmodule

module mynand(input [31:0]A,input [31:0] B,output [31:0] O);
 assign O[0] = ~(A[0]&B[0]);
 assign O[1] = ~(A[1]&B[1]);
 assign O[2] = ~(A[2]&B[2]);
 assign O[3] = ~(A[3]&B[3]);
 assign O[4] = ~(A[4]&B[4]);
 assign O[5] = ~(A[5]&B[5]);
 assign O[6] = ~(A[6]&B[6]);
 assign O[7] = ~(A[7]&B[7]);
 assign O[8] = ~(A[8]&B[8]);
 assign O[9] = ~(A[9]&B[9]);
 assign O[10] = ~(A[10]&B[10]);
 assign O[11] = ~(A[11]&B[11]);
 assign O[12] = ~(A[12]&B[12]);
 assign O[13] = ~(A[13]&B[13]);
 assign O[14] = ~(A[14]&B[14]);
 assign O[15] = ~(A[15]&B[15]);
 assign O[16] = ~(A[16]&B[16]);
 assign O[17] = ~(A[17]&B[17]);
 assign O[18] = ~(A[18]&B[18]);
 assign O[19] = ~(A[19]&B[19]);
 assign O[20] = ~(A[20]&B[20]);
 assign O[21] = ~(A[21]&B[21]);
 assign O[22] = ~(A[22]&B[22]);
 assign O[23] = ~(A[23]&B[23]);
 assign O[24] = ~(A[24]&B[24]);
 assign O[25] = ~(A[25]&B[25]);
 assign O[26] = ~(A[26]&B[26]);
 assign O[27] = ~(A[27]&B[27]);
 assign O[28] = ~(A[28]&B[28]);
 assign O[29] = ~(A[29]&B[29]);
 assign O[30] = ~(A[30]&B[30]);
 assign O[31] = ~(A[31]&B[31]);
endmodule

module ult(input[31:0] A,input[31:0] B,output[31:0] O);
  wire [31:0] T;
  wire [30:0] tt;
  wire C32;
  assign tt=0;
  minus DUT2 (.A(A),.B(B),.O(T),.C32(C32));
 // assign O = 0;
  assign O = {tt,~C32};
endmodule

module lte(input[31:0] A,input[31:0] B,output[31:0] O);
  wire [31:0] T;
  wire [30:0] tt;
  wire C32;
  assign tt=0;
  minus DUT2 (.A(A),.B(B),.O(T),.C32(C32));
  assign O = {tt,T[31]};
endmodule 

module myxor(input [31:0]A,input [31:0] B,output [31:0] O);
 assign O[0] = A[0] ^ B[0];
 assign O[1] = A[1] ^ B[1];
 assign O[2] = A[2] ^ B[2];
 assign O[3] = A[3] ^ B[3];
 assign O[4] = A[4] ^ B[4];
 assign O[5] = A[5] ^ B[5];
 assign O[6] = A[6] ^ B[6];
 assign O[7] = A[7] ^ B[7];
 assign O[8] = A[8] ^ B[8];
 assign O[9] = A[9] ^ B[9];
 assign O[10] = A[10] ^ B[10];
 assign O[11] = A[11] ^ B[11];
 assign O[12] = A[12] ^ B[12];
 assign O[13] = A[13] ^ B[13];
 assign O[14] = A[14] ^ B[14];
 assign O[15] = A[15] ^ B[15];
 assign O[16] = A[16] ^ B[16];
 assign O[17] = A[17] ^ B[17];
 assign O[18] = A[18] ^ B[18];
 assign O[19] = A[19] ^ B[19];
 assign O[20] = A[20] ^ B[20];
 assign O[21] = A[21] ^ B[21];
 assign O[22] = A[22] ^ B[22];
 assign O[23] = A[23] ^ B[23];
 assign O[24] = A[24] ^ B[24];
 assign O[25] = A[25] ^ B[25];
 assign O[26] = A[26] ^ B[26];
 assign O[27] = A[27] ^ B[27];
 assign O[28] = A[28] ^ B[28];
 assign O[29] = A[29] ^ B[29];
 assign O[30] = A[30] ^ B[30];
 assign O[31] = A[31] ^ B[31];
endmodule



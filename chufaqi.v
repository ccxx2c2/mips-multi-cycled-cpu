module nand_3(output o,input i1,i2,i3);
    assign o=~(i1&i2&i3);
endmodule;

module flipflop(input nRD,nSD,CP,D,output Q, nQ);
    wire Q3,Q4,Q5,Q6;
    nand_3 a1(Q6,D,nRD,Q4);
    nand_3 a2(Q5,Q6,nSD,Q3);
    nand_3 a3(Q4,Q6,Q3,CP);
    nand_3 a4(Q3,nRD,Q5,CP);
    nand_3 a5(Q,nSD,Q3,nQ);
    nand_3 a6(nQ,nRD,Q4,Q);
endmodule;

module counter(input dt1,dt2,dt3,clk,clr,output dt1x,dt2x,dt3x);
    wire a,b,c,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12;
    not(t11,dt3);
    and(t12,dt1,dt3);
    or(c,t11,t12);
    
    and(t1,dt2,dt3);
    and(t2,dt1,t11);
    or(a,t1,t2);
    
    not(t4,dt1);
    not(t5,dt2);
    and(t6,t4,t5,dt3);
    and(t10,dt2,t11);
    or(b,t10,t6);
    
    flipflop p1(~clr,1'b1,clk,a,dt1x,t7);
    flipflop p2(~clr,1'b1,clk,b,dt2x,t8);
    flipflop p3(~clr,1'b1,clk,c,dt3x,t9);
endmodule;
module clkgen(input clr,clk,[0:2]datain,output reset,[4:0]p);
    wire t1;
    nor(t1,datain[0],datain[1],datain[2]);
    or(reset,clr,t1);
    
    and(p[0],~datain[0],~datain[1],datain[2]);
    and(p[1],~datain[0],datain[1],~datain[2]);
    and(p[2],~datain[0],datain[1],datain[2]);
    and(p[3],datain[0],~datain[1],~datain[2]);
    and(p[4],datain[0],~datain[1],datain[2]);
endmodule;

module trigger(input cp,clr,output reset,[4:0]p);
  wire o1,o2,o3,dt1,dt2,dt3;
  wire [2:0] datain;
  counter dp3(dt1,dt2,dt3,cp,clr,o1,o2,o3);
  assign dt1=o1;
  assign dt2=o2;
  assign dt3=o3;
  assign datain = {dt1,dt2,dt3};
  clkgen dp4(clr,cp,datain,reset,p);

endmodule;
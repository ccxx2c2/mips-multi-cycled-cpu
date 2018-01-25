module mux2(input[31:0] i0, [31:0] i1,[1:0] sgn, output[31:0] Out);
    assign Out = sgn[0] ? i0 :
                 sgn[1] ? i1 : Out;
endmodule;
//dmem.address, gpr.wdata, alu.a,

module mux2Reg(input [4:0] i0, [4:0] i1,[1:0] sgn, output[4:0] Out);
    assign Out = sgn[0] ? i0 :
                 sgn[1] ? i1 : Out;
endmodule; 
//gpr.wreg

module mux4(input[31:0] i0,[31:0] i1,[31:0] i2,[31:0] i3,[3:0] sgn, output[31:0] Out);
    assign Out = sgn[0] ? i0 :
                 sgn[1] ? i1 :
                 sgn[2] ? i2 :
                 sgn[3] ? i3 : Out;
endmodule; 
//alu.b


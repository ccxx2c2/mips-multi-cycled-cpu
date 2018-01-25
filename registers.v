module IR(input[31:0] in,input signal,output[31:0] out);
    reg[31:0] IR;
    always @(in,signal)
    begin
        if(signal == 1)
            IR = in;
    end
    assign out = IR;
    
endmodule;
module A(input[31:0] in,output[31:0] out);
    reg[31:0] A;
    always @(in)
    begin
        A = in;
    end
    assign out = A;
    
endmodule;
module pc(input[31:0] in,input signal,input increment,input reset,output[31:0] onext,output[31:0] out);
    reg[31:0] pc; //mem address of lmem
    wire[31:0] increpc;
    assign increpc = pc + 1;
    always @(reset)
    begin
        pc = 0;
    end
    always @(in,increment,signal)
    begin
        pc = signal ? {{12{1'b0}},2'b00,in[20:2]} : pc;
        pc = increment ? increpc : pc;
    end
   
    assign onext = increpc;
    assign out =  pc ;
    
endmodule;

module gr(input[4:0] addr1,input[4:0] addr2, input[4:0] inaddr,input signal,input[31:0] data,output[31:0] o1,output[31:0] o2);
    reg[31:0] x[31:0];
    always @(data,inaddr,signal)
    begin
        x[0] = 0;
        if(signal == 1)
            x[inaddr] = data;
    end
    assign o1 = x[addr1];
    assign o2 = x[addr2];
    
 endmodule;
 
 module IMem(input[31:0] in,output[31:0] out);
    reg[31:0] mem[1023:0];
    assign out = mem[in];
 endmodule;
 
 module DMem(input[31:0] data,input signal,input[31:0] inaddr,input[31:0] oaddr,output[31:0] out);
    reg[31:0] mem[1023:0];
    always @(data,inaddr,signal)
    begin
        
        if(signal == 1)
            mem[{2'b00,inaddr[31:2]}] = data;
    end
    assign out = mem[{2'b00,oaddr[31:2]}];
 endmodule;
 module SignExtend(in,out);
    input [15:0] in;
    output [31:0] out;
    assign out = {{16{in[15]}},in};
 endmodule;
 
 module shift2(in,out);
    input [31:0]in;
    output [31:0]out;
    assign out = {in[29:0],2'b00};
 endmodule;
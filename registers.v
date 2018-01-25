module IR(input[31:0] in,input signal,output[31:0] out);
    reg[31:0] IR;
    always @(in,signal)
    begin
        if(signal == 1)
            IR = in;
    end
    assign out = IR;
    
endmodule;
module A(input[31:0] in,input signal,output[31:0] out);
    reg[31:0] A;
    always @(in,signal)
    begin
        if(signal == 1)
            A = in;
    end
    assign out = A;
    
endmodule;
module B(input[31:0] in,input signal,output[31:0] out);
    reg[31:0] B;
    always @(in,signal)
    begin
        if(signal == 1)
            B = in;
    end
    assign out = B;
endmodule;
module aluout(input[31:0] in,input signal,output[31:0] out);
    reg[31:0] aluout;
    always @(in,signal)
    begin
        if(signal == 1)
            aluout = in;
    end
    assign out = aluout;
endmodule;
module pc(input[31:0] in,input signal,input increment,output[31:0] onext,output[31:0] out);
    reg[31:0] pc; //mem address of lmem
    wire[31:0] increpc;
    assign increpc = pc + 1;
    always @(in,increment)
    begin
        pc = signal ? in : pc;
        pc = increment ? increpc : pc;
    end
   
    assign onext = increpc;
    assign out =  pc ;
    
endmodule;

module gr(input[4:0] addr1,input[4:0] addr2, input[4:0] inaddr,input signal,input[31:0] data,output[31:0] o1,output[31:0] o2);
    reg[31:0] x[31:0];
    always @(data,inaddr,signal)
    begin
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
    always @(data,inaddr)
    begin
        if(signal == 1)
            mem[inaddr] = data;
    end
    assign out = mem[oaddr];
 endmodule;
 
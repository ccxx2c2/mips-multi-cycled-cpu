`timescale 1ps / 1ps
module start;
    reg cp,clr;
    wire reset;
    wire [4:0]p;
    trigger trigger(cp,clr,reset,p);
    cpu cpu(reset,p);    
    initial begin                                                    
    // code that executes only once                          
    // insert code here --> begin     
    #0
    cp = 0;
    clr = 1;
    #15
    clr = 0;
    // --> end                                               
        $readmemh( "code.txt" , cpu.IMem.mem ) ;            
        $readmemh( "reg.txt" , cpu.gr.x ) ;    
      //  $readmemh( "data.txt" , cpu.DMem.mem ) ;  
        $monitor("PC = 0x%8X, IR = 0x%8X", cpu.pc.in, cpu.IR.out );  
      
    //code  
      
    end  
      always  begin
      #5
      cp = ~cp;
      
      end
endmodule;
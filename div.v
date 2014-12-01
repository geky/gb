//
// general timing modules
//

module div(in, out);

// division amount
parameter DIV = 1;
parameter COUNT = DIV / 2;

input in;
output reg out;

reg [$clog2(COUNT)-1:0] count = 0;

always @(posedge in) begin
    if (count == COUNT-1) begin
        out <= ~out;
        count <= 0;
    end else begin
        count <= count + 1'b1;
    end
end

endmodule


module delay(clock, resetn, in, out);

parameter DELAY = 0;
parameter SIZE = 1;

input clock;
input resetn;
input [SIZE-1:0] in;
output [SIZE-1:0] out = shift[0];

reg [SIZE-1:0] shift [DELAY];

always @(posedge clock or negedge resetn) begin
    integer i;

    shift[DELAY-1] <= in;
    
    if (!resetn) begin
        for (i=0; i < DELAY; i=i+1) begin
            shift[i] <= 0;
        end
    end else begin
        for (i=0; i < DELAY-1; i=i+1) begin
            shift[i] <= shift[i+1'b1];
        end
    end
end

endmodule

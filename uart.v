//
// UART interface
//

module uarttx(
    clock115200, resetn, data, send, ready,
    UART_TX
);

input clock115200;
input resetn;
input [7:0] data;
input send;
output reg ready;
output UART_TX = tx;

reg tx;
reg [3:0] state;

always @(posedge clock115200 or negedge resetn) begin
    if (!resetn) begin
        tx <= 1'b1;
        ready <= 0;
        state <= 0;
    end else begin
        if (state == 0) begin
            tx <= 1'b1;
            ready <= send ? 1'b0 : 1'b1;
            state <= send ? 4'h1 : 4'h0;
        end else begin
            tx <= state == 4'h1 ? 1'b0 : data[state-2];
            state <= state == 4'h9 ? 4'h0 : state + 1'b1;
        end
    end
end

endmodule


module uartrx(
    clock115200, resetn, data, recv,
    UART_RX
);

input clock115200;
input resetn;
output reg [7:0] data;
output reg recv;
input UART_RX;

wire rx = UART_RX;
reg [3:0] state;
reg [7:0] buffer;

always @(posedge clock115200 or negedge resetn) begin
    if (!resetn) begin
        data <= 0;
        recv <= 0;
        state <= 0;
    end else begin
        if (state == 0) begin
            recv <= 1'b0;
            state <= rx == 1'b0 ? 4'h1 : 4'h0;
        end else if (state == 9) begin
            data <= buffer;
            recv <= 1'b1;
            state <= 4'h0;
        end else begin
            buffer[state-1] <= rx;
            state <= state + 1'b1;
        end
    end
end

endmodule

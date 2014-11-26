module link(
    clock115200, clock4, resetn,
    address, indata, outdata, load, store,

    //////////// Uart to USB //////////
    UART_RX,
    UART_TX
);


input clock115200;
input clock4;
input resetn;

input [15:0] address;
input [7:0] indata;
output reg [7:0] outdata;
input load;
input store;

input UART_RX;
output UART_TX = tx;


reg [7:0] data;
reg send;

reg [3:0] state;
reg tx;

always @(posedge clock4 or negedge resetn) begin
    if (!resetn) begin
        data <= 0;
        send <= 0;
    end else begin
        if (state != 0) begin
            send <= 0;
        end
    
        if (store) begin
            if (address == 16'hff01) begin
                data <= indata;
            end else if (address == 16'hff02) begin
                send <= indata[7];
            end
        end else if (load) begin
            if (address == 16'hff02) begin
                outdata <= {state != 0 || send, 7'h00};
            end else begin
                outdata <= 0;
            end
        end
    end
end

always @(posedge clock115200 or negedge resetn) begin
    if (!resetn) begin
        tx <= 1'b1;
        state <= 0;
    end else begin
        if (state == 0) begin
            tx <= 1'b1;
            state <= send ? 4'h1 : 4'h0;
        end else begin
            tx <= state == 4'h1 ? 1'h0 : data[state-2];
            state <= state == 4'h9 ? 4'h0 : state + 1'b1;
        end
    end
end

endmodule

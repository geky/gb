module sram(
    clock4, clock115200, resetn,
    address, indata, outdata, load, store,
    prog, 
    
    //////////// Uart to USB //////////
	UART_RX,
    
    //////////// SRAM //////////
	SRAM_A,
	SRAM_CE_n,
	SRAM_D,
	SRAM_LB_n,
	SRAM_OE_n,
	SRAM_UB_n,
	SRAM_WE_n
);

input clock4;
input clock115200;
input resetn;

input [15:0] address;
input [7:0] indata;
output [7:0] outdata;
input load;
input store;
input prog;

//////////// Uart to USB //////////
input UART_RX;

//////////// SRAM //////////
output [17:0] SRAM_A = ram_address[18:1];
inout [15:0] SRAM_D = ram_bus;
output SRAM_CE_n = ~1'b1;
output SRAM_UB_n = ~ram_bytes[1];
output SRAM_LB_n = ~ram_bytes[0];
output SRAM_OE_n = ~ram_load;
output SRAM_WE_n = ~ram_store;

wire [15:0] ram_bus = ram_store ? {ram_outdata, ram_outdata} : 16'hzzzz;
wire [1:0] ram_bytes = ram_address[0] ? 2'b01 : 2'b10;

reg [18:0] ram_address;
reg [7:0] ram_outdata;
reg ram_load;
reg ram_store;

assign outdata = ram_address[0] ? SRAM_D[7:0] : SRAM_D[15:8];


wire [7:0] uart_data;
wire uart_recv;
reg uart_recv_ack;

uartrx comm(clock115200, resetn, uart_data, uart_recv, UART_RX);


reg [18:0] flash_address;
reg [18:0] flash_count;
reg [3:0] flash_state;

always @(posedge clock4 or negedge resetn) begin
    if (!resetn) begin
        ram_address <= 0;
        ram_outdata <= 0;
        ram_load <= 0;
        ram_store <= 0;
        uart_recv_ack <= 0;
    end else if (prog) begin
        uart_recv_ack <= uart_recv;
    
        if (uart_recv && !uart_recv_ack) begin
            case (flash_state)
            4'h0: begin flash_state <= 4'h1; flash_address <= {flash_address[10:0], uart_data}; end
            4'h1: begin flash_state <= 4'h2; flash_address <= {flash_address[10:0], uart_data}; end
            4'h2: begin flash_state <= 4'h3; flash_address <= {flash_address[10:0], uart_data}; end
            4'h3: begin flash_state <= 4'h4; flash_address <= {flash_address[10:0], uart_data}; end
            4'h4: begin flash_state <= 4'h5; flash_count <= {flash_count[10:0], uart_data}; end
            4'h5: begin flash_state <= 4'h6; flash_count <= {flash_count[10:0], uart_data}; end
            4'h6: begin flash_state <= 4'h7; flash_count <= {flash_count[10:0], uart_data}; end
            4'h7: begin flash_state <= 4'h8; flash_count <= {flash_count[10:0], uart_data}; end
            4'h8: begin 
                if (flash_count == 0) begin
                    flash_state <= 4'h0;
                end else begin
                    flash_address <= flash_address + 1'b1;
                    flash_count <= flash_count - 1'b1;
                    ram_address <= flash_address;
                    ram_outdata <= uart_data;
                    ram_load <= 1'b0;
                    ram_store <= 1'b1;
                end
            end
            endcase
        end
    end else begin
        // TODO
        ram_address <= address;
        ram_outdata <= indata;
        ram_load <= load;
        ram_store <= store;
    end 
end

endmodule

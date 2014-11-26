module mbc1(
    clock4, clock115200, clock460800, resetn,
    address, indata, outdata, load, store, prog,
    
    //////////// Uart to USB //////////
	UART_RX,
    UART_TX,
    
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
input clock460800;
input resetn;

input [15:0] address;
input [7:0] indata;
output [7:0] outdata = rom_data;
input load;
input store;
input prog;

//////////// Uart to USB //////////
input UART_RX;
output UART_TX;

//////////// SRAM //////////
output [17:0] SRAM_A;
inout [15:0] SRAM_D;
output SRAM_CE_n;
output SRAM_UB_n;
output SRAM_LB_n;
output SRAM_OE_n;
output SRAM_WE_n;


reg [15:0] rom_address;
wire [7:0] rom_data;

sram cart_rom(
    clock4, clock115200, clock460800, resetn,
    rom_address, , rom_data, load, , prog, 
    
    //////////// Uart to USB //////////
	UART_RX,
    UART_TX,
    
    //////////// SRAM //////////
	SRAM_A,
	SRAM_CE_n,
	SRAM_D,
	SRAM_LB_n,
	SRAM_OE_n,
	SRAM_UB_n,
	SRAM_WE_n
);


reg [1:0] select;

always @(*) begin
    if (address < 16'h4000) begin
        rom_address = address;
    end else begin
        rom_address = {select, address[13:0]};
    end
end

always @(posedge clock4 or negedge resetn) begin
    if (!resetn) begin
        select <= 2'b1;
    end else begin
        if (store && address >= 16'h2000 && address < 16'h4000) begin
            if (indata[1:0] == 2'b00) begin
                select <= 2'b01;
            end else begin
                select <= indata[1:0];
            end
        end
    end
end 

endmodule

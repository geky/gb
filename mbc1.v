module mbc1(
    clockgb, clock115200, clock460800, resetn,
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

input clockgb;
input clock115200;
input clock460800;
input resetn;

input [15:0] address;
input [7:0] indata;
output [7:0] outdata;
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


reg [15:0] sram_address;
wire [7:0] sram_data;

sram cart_sram(
    clockgb, clock115200, clock460800, resetn,
    sram_address,, sram_data, load, 1'b0, prog, 
    
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


reg [1:0] bank;

always @(*) begin
    if (rom_address < 16'h4000) begin
        sram_address = rom_address;
    end else begin
        sram_address = {bank, rom_address[13:0]};
    end
end

always @(posedge clockgb or negedge resetn) begin
    if (!resetn) begin
        bank <= 2'b1;
    end else begin
        if (bank_store) begin
            if (bank_indata == 0) begin
                bank <= 2'b1;
            end else begin
                bank <= bank_indata[1:0];
            end
        end
    end
end 


wire [15:0] rom_address;

mmap #(16'h0000, 16'h7fff) rom_mmap(
    clockgb, resetn,
    address, indata, outdata, load, store,
    rom_address,, sram_data
);

wire [7:0] bank_indata;
wire bank_store;

mmap #(16'h2000, 16'h3fff) bank_mmap(
    clockgb, resetn,
    address, indata,, load, store,, 
    bank_indata,,, bank_store
);

endmodule

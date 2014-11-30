// Entry Point //

module gbc(

	//////////// CLOCK //////////
	CLOCK_125_p,
	CLOCK_50_B5B,
	CLOCK_50_B6A,
	CLOCK_50_B7A,
	CLOCK_50_B8A,

	//////////// LED //////////
	LEDG,
	LEDR,

	//////////// KEY //////////
	CPU_RESET_n,
	KEY,

	//////////// SW //////////
	SW,

	//////////// SEG7 //////////
	HEX0,
	HEX1,
	HEX2,
	HEX3,

	//////////// HDMI-TX //////////
	HDMI_TX_CLK,
	HDMI_TX_D,
	HDMI_TX_DE,
	HDMI_TX_HS,
	HDMI_TX_INT,
	HDMI_TX_VS,

	//////////// I2C for Audio/HDMI-TX/Si5338/HSMC //////////
	I2C_SCL,
	I2C_SDA,

	//////////// SDCARD //////////
	SD_CLK,
	SD_CMD,
	SD_DAT,

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

//////////// CLOCK //////////
input 		          		CLOCK_125_p;
input 		          		CLOCK_50_B5B;
input 		          		CLOCK_50_B6A;
input 		          		CLOCK_50_B7A;
input 		          		CLOCK_50_B8A;

//////////// LED //////////
output		     [7:0]		LEDG;
output		     [9:0]		LEDR;

//////////// KEY //////////
input 		          		CPU_RESET_n;
input 		     [3:0]		KEY;

//////////// SW //////////
input 		     [9:0]		SW;

//////////// SEG7 //////////
output		     [6:0]		HEX0;
output		     [6:0]		HEX1;
output		     [6:0]		HEX2;
output		     [6:0]		HEX3;

//////////// HDMI-TX //////////
output		          		HDMI_TX_CLK;
output		    [23:0]		HDMI_TX_D;
output		          		HDMI_TX_DE;
output		          		HDMI_TX_HS;
input 		          		HDMI_TX_INT;
output		          		HDMI_TX_VS;

//////////// I2C for Audio/HDMI-TX/Si5338/HSMC //////////
output		          		I2C_SCL;
inout 		          		I2C_SDA;

//////////// SDCARD //////////
output		          		SD_CLK;
inout 		          		SD_CMD;
inout 		     [3:0]		SD_DAT;

//////////// Uart to USB //////////
input 		          		UART_RX;
output		          		UART_TX;

//////////// SRAM //////////
output		    [17:0]		SRAM_A;
output		          		SRAM_CE_n;
inout 		    [15:0]		SRAM_D;
output		          		SRAM_LB_n;
output		          		SRAM_OE_n;
output		          		SRAM_UB_n;
output		          		SRAM_WE_n;


// Clocking //
wire clock50 = CLOCK_50_B5B;

wire clock25;
wire clock8;
wire clock4;
wire clock115200;
wire clock460800;

div #(2) div25(clock50, clock25);
div #(6) div8(clock50, clock8);
div #(12) div4(clock50, clock4);
div #(432) div115200(clock50, clock115200); // previously 434
div #(432/4) div460800(clock50, clock460800);

wire clocka;
wire clockb;
wire clockc;
div #(1000) diva(clock50, clocka);
div #(100000) divb(clock50, clockb);
div #(1000000) divc(clock50, clockc);

wire clockgb = SW[8] ? clock8 :
               SW[7] ? clock4 : 
               SW[6] ? clocka : 
               SW[5] ? clockb : 
               SW[4] ? clockc : KEY[0];
               
wire resetn = KEY[1];


// Connecting Wires //
wire [15:0] address;
wire [7:0] outdata;
wire load;
wire store;

wire [7:0] indata = ppu_data | link_data | timer_data | joy_data | 
                    rom_data | loram_data | hiram_data | int_data;
                    
assign UART_TX = link_tx & rom_tx;


// PPU //
wire [7:0] ppu_data;
wire vblank_int;
wire lcdc_int;
wire [1:0] dmode;

ppu ppu(
    clock25, clockgb, resetn, vblank_int, lcdc_int,
    address, outdata, ppu_data, load, store,
    
	//////////// HDMI-TX //////////
	HDMI_TX_CLK,
	HDMI_TX_D,
	HDMI_TX_DE,
	HDMI_TX_HS,
	HDMI_TX_INT,
	HDMI_TX_VS,
    dmode
);


// Link Cable (Primarily for debugging) //
wire [7:0] link_data;
wire link_tx;

link link(
    clock115200, clockgb, resetn,
    address, outdata, link_data, load, store,

    //////////// Uart to USB //////////
    UART_RX,
    link_tx
);


// Timer //
wire [7:0] timer_data;
wire timer_int;
wire [7:0] dtimer;

timer timer(
    clockgb, resetn, timer_int,
    address, outdata, timer_data, load, store,
    dtimer
);


// Cartridge ROM //          
wire [7:0] rom_data;
wire rom_tx;

mbc1 cart_rom(
    SW[9] ? clock4 : clockgb, clock115200, clock460800, resetn, 
    address, outdata, rom_data, load, store, SW[9],

    //////////// Uart to USB //////////
	UART_RX,
    rom_tx,
    
    //////////// SRAM //////////
	SRAM_A,
	SRAM_CE_n,
	SRAM_D,
	SRAM_LB_n,
	SRAM_OE_n,
	SRAM_UB_n,
	SRAM_WE_n
);


// Low RAM (Large) //
wire [15:0] loram_address;
wire [7:0] loram_indata;
wire [7:0] loram_outdata;
wire [7:0] loram_data;
wire loram_store;

loram loram(
	loram_address[12:0],
	clockgb,
	loram_indata,
	loram_store,
	loram_outdata
);

mmap #(16'hc000, 16'hfdff) loram_mmap(
    clockgb, resetn,
    address, outdata, loram_data, load, store,
    loram_address, loram_indata, loram_outdata,, loram_store
);


// High RAM (Small but faster) //
wire [15:0] hiram_address;
wire [7:0] hiram_indata;
wire [7:0] hiram_outdata;
wire [7:0] hiram_data;
wire hiram_store;

hiram hiram(
    hiram_address,
	clockgb,
	hiram_indata,
	hiram_store,
	hiram_outdata
);

mmap #(16'hff80, 16'hfffe) hiram_mmap(
    clockgb, resetn,
    address, outdata, hiram_data, load, store,
    hiram_address, hiram_indata, hiram_outdata,, hiram_store
);


// temporary joypad input //
wire [7:0] joy_data;

rrmmap #(16'hff00) joy_map(
    clockgb, resetn,
    address, outdata, joy_data, load, store,,,
    8'h0f
);


// Interrupt Handling //
wire [7:0] int_data;
wire intreq;
wire [15:0] intaddress;
wire intack;
wire [4:0] dints;

inthandle inth(
    clockgb, resetn,
    address, outdata, int_data, load, store,
    {1'b0, 1'b0, timer_int, lcdc_int, vblank_int},
    intreq, intaddress, intack, 
    dints
);

  
// CPU //  
wire [15:0] du;
wire [3:0] df;
wire [15:0] daf;
wire [15:0] dbc;
wire [15:0] dde;
wire [15:0] dhl;
wire [15:0] dsp;
wire [15:0] dpc;

lr35902 cpu(
    clockgb, resetn, 
    address, indata, outdata, load, store, 
    intreq, intaddress, intack,
    du, df, daf, dbc, dde, dhl, dsp, dpc
);


// Debugging Signals //
assign LEDR[9:5] = dints;
assign LEDR[1:0] = dmode;
assign LEDG[7:4] = df;
assign LEDG[1] = load;
assign LEDG[0] = store;

reg [15:0] debug;
seg16 segs(debug, {HEX3,HEX2,HEX1,HEX0});

always @(*) begin
    case (SW[3:0])
    4'b1101: debug = dpc;
    4'b1100: debug = dsp;
    4'b1011: debug = dhl;
    4'b1010: debug = dde;
    4'b1001: debug = dbc;
    4'b1000: debug = daf;
    4'b0100: debug = dtimer;
    default: debug = du;
    endcase
end  
  
endmodule

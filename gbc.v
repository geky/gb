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
output		          		UART_TX = linktx & romtx;

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

wire clockgb = tclock;

/*
ppu #(640, 480) ppu(clock, LEDG[0], LEDG[1],
    HDMI_TX_CLK,
    HDMI_TX_D,
    HDMI_TX_DE,
    HDMI_TX_HS,
    HDMI_TX_INT,
    HDMI_TX_VS
);*/
/*
wire clk_50 = clock;
reg clk_25 = 0;
reg clk_locked = 0;
always @(posedge clk_50) begin
    clk_25 <= !clk_25;
    clk_locked <= 1'b1;
end
*/
//assign HDMI_TX_CLK = clk_25;
/*
vga_generator u_vga_generator (                                    
  .clk(clk_25),            
  .reset_n(clk_locked),                                                
  .h_total(12'd799),           
  .h_sync(12'd95),           
  .h_start(12'd141),             
  .h_end(12'd781),                                                    
  .v_total(12'd524),           
  .v_sync(12'd1),            
  .v_start(12'd34),           
  .v_end(12'd514), 
  .v_active_14(12'd154), 
  .v_active_24(12'd274), 
  .v_active_34(12'd394), 
  .vga_hs(HDMI_TX_HS),
  .vga_vs(HDMI_TX_VS),           
  .vga_de(HDMI_TX_DE),
  .vga_r(HDMI_TX_D[2*8 +: 8]),
  .vga_g(HDMI_TX_D[1*8 +: 8]),
  .vga_b(HDMI_TX_D[0*8 +: 8]) );*/

 /*
wire [11:0] x;
wire [11:0] y;
  
hdmi #(4) test(
    clock25, resetn,
    x, y,
    x[7:0] << 4, y[7:0] << 4, 8'd0,
    
	//////////// HDMI-TX //////////
	HDMI_TX_CLK,
	HDMI_TX_D,
	HDMI_TX_DE,
	HDMI_TX_HS,
	HDMI_TX_INT,
	HDMI_TX_VS
);*/

wire [7:0] ppudata;
ppu ppu(
    clock25, clockgb, resetn,
    addr, outdata, ppudata, load, store,
    
	//////////// HDMI-TX //////////
	HDMI_TX_CLK,
	HDMI_TX_D,
	HDMI_TX_DE,
	HDMI_TX_HS,
	HDMI_TX_INT,
	HDMI_TX_VS,
    LEDR
);

/*
// PPU Instantiation //
wire [7:0] ppudata;
ppu ppu0(
    clock25, clockgb, resetn,
    addrlatch, datalatch, ppudata, loadlatch, storelatch,
    
	//////////// HDMI-TX //////////
	HDMI_TX_CLK,
	HDMI_TX_D,
	HDMI_TX_DE,
	HDMI_TX_HS,
	HDMI_TX_INT,
	HDMI_TX_VS
);*/

// Peripherals //
wire [7:0] linkdata;
wire linktx;
link l0(clock115200, tclock, resetn,
        addrlatch, datalatch, linkdata, loadlatch, storelatch,

        //////////// Uart to USB //////////
        UART_RX,
        linktx
);

wire [15:0] addr;
wire [15:0] u;
wire [3:0] f;
reg [7:0] indata;
wire [7:0] outdata;
assign LEDG[2] = KEY[0];
assign LEDG[3] = KEY[1];
    
wire clocka;
wire clockb;
wire clockc;
div #(1000) diva(clock50, clocka);
div #(100000) divb(clock50, clockb);
div #(1000000) divc(clock50, clockc);
wire tclock = SW[8] ? clock8 :
              SW[7] ? clock4 : 
              SW[6] ? clocka : 
              SW[5] ? clockb : 
              SW[4] ? clockc : KEY[0];
wire resetn = KEY[1];
           
wire [7:0] romdata;
wire romtx;
mbc1 cart_rom(
    SW[9] ? clock4 : tclock, clock115200, clock460800, resetn, 
    addr, outdata, romdata, load, store, SW[9],

    //////////// Uart to USB //////////
	UART_RX,
    romtx,
    
    //////////// SRAM //////////
	SRAM_A,
	SRAM_CE_n,
	SRAM_D,
	SRAM_LB_n,
	SRAM_OE_n,
	SRAM_UB_n,
	SRAM_WE_n
);

wire [7:0] ramdata;
ram ram0(addr, tclock, outdata, 
         store && addr >= 16'hc000 && addr < 16'he000, 
         ramdata);
         
wire [7:0] highramdata;
highram ramh(addr, tclock, outdata,
             store && addr >= 16'hff80 && addr < 16'hffff,
             highramdata);

         
wire [15:0] daf;
wire [15:0] dbc;
wire [15:0] dde;
wire [15:0] dhl;
wire [15:0] dsp;
wire [15:0] dpc;
lr35902 cpu(tclock, resetn, addr, indata, outdata, load, store, u, f, daf, dbc, dde, dhl, dsp, dpc);
wire load;
wire store;
assign LEDG[7:4] = f;
assign LEDG[1] = load;
assign LEDG[0] = store;

reg [15:0] addrlatch;
reg [15:0] addrlatch2;
reg [15:0] datalatch;
reg loadlatch;
reg loadlatch2;
reg storelatch;

always @(posedge tclock or negedge resetn) begin
    if (!resetn) begin
        addrlatch <= 0;
        addrlatch2 <= 0;
        datalatch <= 0;
        loadlatch <= 0;
        loadlatch2 <= 0;
        storelatch <= 0;
    end else begin
        addrlatch <= addr;
        addrlatch2 <= addrlatch;
        datalatch <= outdata;
        loadlatch <= load;
        loadlatch2 <= loadlatch;
        storelatch <= store;
    end
end

always @(*) begin
    if (addrlatch2 < 16'h8000) begin
        indata = romdata;
    end else if (addrlatch2 >= 16'hc000 && addrlatch2 < 16'he000) begin
        indata = ramdata;
    end else if (addrlatch2 >= 16'hff80 && addrlatch2 < 16'hffff) begin
        indata = highramdata;
    end else if ((addrlatch2 >= 16'h9800 && addrlatch2 <= 16'hbfff) || 
                 (addrlatch2 >= 16'h8000 && addrlatch2 <= 16'h97ff) || 
                 (addrlatch2 >= 16'hfe00 && addrlatch2 <= 16'hfe9f) || 
                 (addrlatch2 >= 16'hff47 && addrlatch2 <= 16'hff49) ||
                 addrlatch2 == 16'hff42 || addrlatch2 == 16'hff43) begin
        indata = ppudata;
    end else begin
        indata = linkdata;
    end
end


seg16 segs(debug, {HEX3,HEX2,HEX1,HEX0});

reg [15:0] debug;

always @(*) begin
    case (SW[3:0])
    4'b1101: debug = dpc;
    4'b1100: debug = dsp;
    4'b1011: debug = dhl;
    4'b1010: debug = dde;
    4'b1001: debug = dbc;
    4'b1000: debug = daf;
    4'b0101: debug = loadlatch2 ? indata : 16'h0000;
    4'b0100: debug = loadlatch2 ? addrlatch2 : 16'h0000;
    4'b0011: debug = store ? outdata : 16'h0000;
    4'b0010: debug = store ? addr : 16'h0000;
    default: debug = u;
    endcase
end  
  
endmodule

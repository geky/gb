module ppu(
    clock25, clockgb, resetn,
    address, indata, outdata, load, store,
    
	//////////// HDMI-TX //////////
	HDMI_TX_CLK,
	HDMI_TX_D,
	HDMI_TX_DE,
	HDMI_TX_HS,
	HDMI_TX_INT,
	HDMI_TX_VS,
    R
);

output [7:0] R = mode;

parameter WIDTH = 160;
parameter HEIGHT = 144;

parameter SPRITE_COUNT = 40;

parameter MODE2_COUNT = 80;
parameter MODE3_COUNT = 171;
parameter MODE0_COUNT = 205;
parameter MODE1_COUNT = 4560;


input clock25;
input clockgb;
input resetn;

input [15:0] address;
input [7:0] indata;
output [7:0] outdata;
input load;
input store;

output HDMI_TX_CLK;
output [23:0] HDMI_TX_D;
output HDMI_TX_DE;
output HDMI_TX_HS;
output HDMI_TX_VS;
input HDMI_TX_INT;


wire [7:0] x;
wire [7:0] y;
wire [7:0] r;
wire [7:0] g;
wire [7:0] b;
  
hdmi #(4) display(
    clock25, resetn,
    x, y,
    r, g, b,
    
	//////////// HDMI-TX //////////
	HDMI_TX_CLK,
	HDMI_TX_D,
	HDMI_TX_DE,
	HDMI_TX_HS,
	HDMI_TX_INT,
	HDMI_TX_VS
);


wire [5:0] p_id;
wire [15:0] p_color = gbm_color[1];

vram vram(
	gb_id,
	{y, x},
	clock25,
	{gb_y[3], gb_x[3]},
	clockgb,
	mode == 2'h3,
	p_id
);


reg [7:0] gbm_palette [3];
reg [15:0] gbm_color [2];

wire [1:0] gbm_shade = ~gbm_palette[p_id[5:2]][2*p_id[1:0] +: 2];

always @(posedge clock25) begin
    gbm_color[0] <= {gbm_shade, 3'h0,
                     gbm_shade, 3'h0,
                     gbm_shade, 3'h0};
    
    gbm_color[1] <= gbm_color[0];
end

/* TODO with gbc
pram pram(
	address_a,
	p_id,
	clock_a,
	clock25,
	data_a,
	,
	wren_a,
	1'b0,
	q_a,
	p_color
);*/

assign r = {p_color[4:0], 2'h0};
assign g = {p_color[9:5], 2'h0};
assign b = {p_color[14:10], 2'h0};



reg [7:0] gb_x [4];
reg [7:0] gb_y [4];
reg [5:0] gb_id;


reg [7:0] sprites [SPRITE_COUNT] [4];

reg [7:0] sprite_tile;
reg [3:0] sprite_pal [3];
reg [2:0] sprite_x [3];
reg [2:0] sprite_y [3];
reg sprite_pri [3];
wire [5:0] sprite_id = {sprite_pal[2], sprite_pid};


always @(posedge clockgb) begin
    integer i;
    
    sprite_x[1] <= sprite_x[0];
    sprite_x[2] <= sprite_x[1];
    sprite_y[1] <= sprite_y[0];
    sprite_y[2] <= sprite_y[1];
    sprite_pal[1] <= sprite_pal[0];
    sprite_pal[2] <= sprite_pal[1];
    sprite_pri[1] <= sprite_pri[0];
    sprite_pri[2] <= sprite_pri[1];

    for (i=SPRITE_COUNT-1; i >= 0; i=i-1) begin
        if (gb_x[0] >= sprites[i][1]-8'd16 && gb_x[0] < sprites[i][1]-8'd16+8'h8 &&
            gb_y[0] >= sprites[i][0]-8'd16 && gb_y[0] < sprites[i][0]-8'd16+8'h8) begin
            
            sprite_tile <= sprites[i][2];
            
            if (!sprites[i][3][5]) begin
                sprite_x[0] <= gb_x[0][2:0] - sprites[i][1][2:0];
            end else begin
                sprite_x[0] <= 3'd7-(gb_x[0][2:0] - sprites[i][1][2:0]);
            end
            
            if (!sprites[i][3][6]) begin
                sprite_y[0] <= gb_y[0][2:0] - sprites[i][0][2:0];
            end else begin
                sprite_y[0] <= 3'd7-(gb_y[0][2:0] - sprites[i][0][2:0]);
            end
            
            sprite_pal[0] <= 0; // change for gbc
            sprite_pri[0] <= sprites[i][3][7];
        end
    end
end


wire [7:0] bg_xreal = gb_x[0] + scrollx;
wire [7:0] bg_yreal = gb_y[0] + scrolly;

reg [2:0] bg_x [3];
reg [2:0] bg_y [3];
reg [3:0] bg_pal [3];
wire [7:0] bg_tile;
wire [5:0] bg_id = {bg_pal[2], bg_pid};

always @(posedge clockgb) begin
    bg_x[1] <= bg_x[0];
    bg_x[2] <= bg_x[1];
    bg_y[1] <= bg_y[0];
    bg_y[2] <= bg_y[1];
    bg_pal[1] <= bg_pal[0];
    bg_pal[2] <= bg_pal[1];
    
    bg_x[0] <= bg_xreal[2:0];
    bg_y[0] <= bg_yreal[2:0];
    bg_pal[0] <= 0; // change for gbc
end


reg [2:0] w_x [3];
reg [2:0] w_y [3];
reg [3:0] w_pal [3];
wire [7:0] w_tile;
wire [5:0] w_id = {w_pal[2], w_pid};

always @(posedge clockgb) begin
    w_x[1] <= w_x[0];
    w_x[2] <= w_x[1];
    w_y[1] <= w_y[0];
    w_y[2] <= w_y[1];
    w_pal[1] <= w_pal[0];
    w_pal[2] <= w_pal[1];
    
    w_x[0] <= w_x[0][2:0];
    w_y[0] <= w_y[0][2:0];
    w_pal[0] <= 0; // change for gbc
end



bgram bgram(
	bg_store ? bg_address[10:0] : {bg_yreal[7:3], bg_xreal[7:3]},
	{bg_yreal[7:3], bg_xreal[7:3]},
	clockgb,
	bg_indata,
	,
	bg_store,
	1'b0,
	bg_tile,
	w_tile
);

wire [15:0] bg_address;
wire [7:0] bg_indata;
reg  [7:0] bg_outdata;
wire [7:0] bg_data;
wire bg_store;

always @(posedge clockgb) begin
    bg_outdata <= bg_tile;
end

mmap #(16'h9800, 16'hbfff) bg_mmap(
    clockgb, resetn,
    address, indata, bg_data, load, store,
    bg_address, bg_indata, bg_outdata,, bg_store
);


wire [7:0] sprite_hi;
wire [7:0] sprite_lo;
wire [1:0] sprite_pid = {sprite_hi[3'd7-sprite_x[2]], sprite_lo[3'd7-sprite_x[2]]};
wire [7:0] bg_hi;
wire [7:0] bg_lo;
wire [1:0] bg_pid = {bg_hi[3'd7-bg_x[2]], bg_lo[3'd7-bg_x[2]]};
wire [7:0] w_hi;
wire [7:0] w_lo;
wire [1:0] w_pid = {w_hi[3'd7-bg_x[2]], w_lo[3'd7-bg_x[2]]};

tram sprite_tram(
	tile_address,
	{sprite_tile, sprite_y[0]},
	clockgb,
	tile_indata,
	,
	tile_store,
	1'b0,
	tile_outdata,
	{sprite_hi, sprite_lo}
);

tram bg_tram(
	tile_address,
	{bg_tile, bg_y[0]},
	clockgb,
	tile_indata,
	,
	tile_store,
	1'b0,
	,
	{bg_hi, bg_lo}
);

tram w_tram(
	tile_address,
	{w_tile, w_y[0]},
	clockgb,
	tile_indata,
	,
	tile_store,
	1'b0,
	,
	{w_hi, w_lo}
);

wire [15:0] tile_address;
wire [7:0] tile_indata;
wire [7:0] tile_outdata;
wire [7:0] tile_data;
wire tile_store;

mmap #(16'h8000, 16'h97ff) tile_mmap(
    clockgb, resetn,
    address, indata, tile_data, load, store,
    tile_address, tile_indata, tile_outdata,, tile_store
);


always @(*) begin
    /*if (sprite_id == 0 || sprite_pri[2]) begin
        gb_id = w_id;
    end 
    if (sprite_id == 0 || (sprite_pri[2] && bg_id != 0)) begin*/
        gb_id = bg_id;
    /*end else begin
        gb_id = sprite_id;
    end*/
end
    



reg [2:0] mode;
reg [15:0] mode_count; 

always @(posedge clockgb or negedge resetn) begin
    integer i;

    if (!resetn) begin
        mode <= 2'h2;
        mode_count <= 0;
        
        for (i=0; i < 4; i=i+1) begin
            gb_x[i] <= 0;
            gb_y[i] <= 0;
        end
    end else begin
        gb_x[1] <= gb_x[0];
        gb_x[2] <= gb_x[1];
        gb_x[3] <= gb_x[2];
        gb_y[1] <= gb_y[0];
        gb_y[2] <= gb_y[1];
        gb_y[3] <= gb_y[2];
    
        case (mode)
            2'h2: begin            
                if (mode_count+1'b1 == MODE2_COUNT) begin
                    mode <= 2'h3;
                    mode_count <= 0;
                end else begin
                    mode_count <= mode_count + 1'b1;
                end 
            end
            2'h3: begin
                if (gb_x[0]+1'b1 != WIDTH) begin
                    gb_x[0] <= gb_x[0] + 1'b1;
                end
            
                if (mode_count+1'b1 == MODE3_COUNT) begin
                    gb_x[0] <= 0;
                    mode <= 2'h0;
                    mode_count <= 0;
                end else begin
                    mode_count <= mode_count + 1'b1;
                end 
            end
            2'h0: begin
                if (mode_count+1'b1 == MODE0_COUNT) begin
                    if (gb_y[0]+1'b1 != HEIGHT) begin
                        gb_y[0] <= gb_y[0] + 1'b1;
                        mode <= 2'h2;
                    end else begin
                        mode <= 2'h1;
                    end
                        
                    mode_count <= 0;
                end else begin
                    mode_count <= mode_count + 1'b1;
                end 
            end
            2'h1: begin
                if (mode_count+1'b1 == MODE1_COUNT) begin
                    gb_y[0] <= 0;
                    mode <= 2'h2;
                    mode_count <= 0;
                end else begin
                    mode_count <= mode_count + 1'b1;
                end 
            end
        endcase
    end
end


reg [7:0] scrolly;
reg [7:0] scrollx;

always @(posedge clockgb or negedge resetn) begin
    if (!resetn) begin
        gbm_palette[0] <= 8'h00;
        gbm_palette[1] <= 8'h00;
        gbm_palette[2] <= 8'h00;
        scrolly <= 0;
        scrollx <= 0;
    end else begin
        if (sprite_store) begin
            sprites[sprite_address[15:2]][sprite_address[1:0]] <= sprite_indata;
        end
        if (gbm_store) begin
            gbm_palette[gbm_address] <= gbm_indata;
        end
        if (scrolly_store) begin
            scrolly <= scrolly_indata;
        end
        if (scrollx_store) begin
            scrollx <= scrollx_indata;
        end
    end
end


wire [15:0] sprite_address;
wire [7:0] sprite_indata;
wire [7:0] sprite_outdata = sprites[sprite_address[15:2]][sprite_address[1:0]];
wire [7:0] sprite_data;
wire sprite_store;

rrmmap #(16'hfe00, 16'hfe9f) sprite_mmap(
    clockgb, resetn,
    address, indata, sprite_data, load, store,
    sprite_address, sprite_indata, sprite_outdata,, sprite_store
);

wire [15:0] gbm_address;
wire [7:0] gbm_indata;
wire [7:0] gbm_outdata = gbm_palette[gbm_address];
wire [7:0] gbm_data;
wire gbm_store;

rrmmap #(16'hff47, 16'hff49) gbm_mmap(
    clockgb, resetn,
    address, indata, gbm_data, load, store,
    gbm_address, gbm_indata, gbm_outdata,, gbm_store
);

wire [7:0] scrolly_indata;
wire [7:0] scrolly_data;
wire scrolly_store;

rrmmap #(16'hff42, 16'hff42) scrolly_mmap(
    clockgb, resetn,
    address, indata, scrolly_data, load, store,
    , scrolly_indata, scrolly,, scrolly_store
);

wire [7:0] scrollx_indata;
wire [7:0] scrollx_data;
wire scrollx_store;

rrmmap #(16'hff43, 16'hff43) scrollx_mmap(
    clockgb, resetn,
    address, indata, scrollx_data, load, store,
    , scrollx_indata, scrollx,, scrollx_store
);


assign outdata = bg_data | tile_data | sprite_data | gbm_data |
                 scrolly_data | scrollx_data;


endmodule

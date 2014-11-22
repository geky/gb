module hdmi(
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

parameter WIDTH = 160;
parameter HEIGHT = 144;
parameter XDIV = 3;
parameter YDIV = 3;
parameter XSTART = 80;
parameter XEND = XSTART + XDIV*WIDTH;
parameter YSTART = 24;
parameter YEND = YSTART + YDIV*HEIGHT;

parameter HSIZE = 640;
parameter VSIZE = 480;
parameter HTOTAL = 800;
parameter VTOTAL = 525;
parameter HSTART = 141;
parameter HEND = HSTART + HSIZE;
parameter VSTART = 34;
parameter VEND = VSTART + VSIZE;

input clock25;
input resetn;
output reg [11:0] x;
output reg [11:0] y;
input [7:0] r;
input [7:0] g;
input [7:0] b;

output HDMI_TX_CLK = clock25;
output [23:0] HDMI_TX_D = hdmi_data;
output HDMI_TX_DE = hdmi_de[1];
output HDMI_TX_HS = hdmi_hsync;
output HDMI_TX_VS = hdmi_vsync;
input HDMI_TX_INT;


reg [23:0] hdmi_data;
reg [1:0] hdmi_de;

reg [11:0] hdmi_hcount;
reg [11:0] hdmi_vcount;
wire hdmi_hactive = hdmi_hcount >= HSTART && hdmi_hcount < HEND;
wire hdmi_vactive = hdmi_vcount >= VSTART && hdmi_vcount < VEND;
wire hdmi_active = hdmi_hactive && hdmi_vactive;
wire hdmi_hsync = hdmi_hcount >= HEND;
wire hdmi_vsync = hdmi_vcount >= VEND;

always @(posedge clock25 or negedge resetn) begin
    if (!resetn) begin
        hdmi_de <= 0;
        hdmi_hcount <= 0;
        hdmi_vcount <= 0;
    end else begin
        hdmi_de[1] <= hdmi_de[0];
        hdmi_de[0] <= hdmi_active;
    
        if (hdmi_hcount + 1'b1 == HTOTAL) begin
            hdmi_hcount <= 0;
            
            if (hdmi_vcount + 1'b1 == VTOTAL) begin
                hdmi_vcount <= 0;
            end else begin
                hdmi_vcount <= hdmi_vcount + 1'b1;
            end
        end else begin
            hdmi_hcount <= hdmi_hcount + 1'b1;
        end
    end
end


wire xactive = hdmi_hcount >= HSTART+XSTART && hdmi_hcount < HSTART+XEND;
wire yactive = hdmi_vcount >= VSTART+YSTART && hdmi_vcount < VSTART+YEND;

reg [$clog2(XDIV)-1:0] xcount;
reg [$clog2(YDIV)-1:0] ycount;

always @(posedge clock25 or negedge resetn) begin
    if (!resetn) begin
        hdmi_data <= 0;
        xcount <= 0;
        x <= 0;
        ycount <= 0;
        y <= 0;
    end else begin
        if (xactive && yactive) begin
            hdmi_data <= {r, g, b};
        
            if (xcount + 1'b1 == XDIV) begin
                xcount <= 0;
                if (x + 1'b1 == WIDTH) begin
                    x <= 0;
                    if (ycount + 1'b1 == YDIV) begin
                        ycount <= 0;
                        if (y + 1'b1 == HEIGHT) begin
                            y <= 0;
                        end else begin
                            y <= y + 1'b1;
                        end
                    end else begin
                        ycount <= ycount + 1'b1;
                    end
                end else begin
                    x <= x + 1'b1;
                end
            end else begin
                xcount <= xcount + 1'b1;
            end
        end else begin
            hdmi_data <= 0;
        end
    end 
end

endmodule

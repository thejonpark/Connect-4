`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:10 04/23/2014 
// Design Name: 
// Module Name:    connect_4_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module connect_4_top
	(MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS,
	ClkPort,
	Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0,
	BtnL, BtnU, BtnR, BtnC, BtnD,
	Ld7, Ld6, Ld5, Ld4, Ld3, Ld2, Ld1, Ld0,
	An3, An2, An1, An0,
	Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b
    );
	
	input ClkPort;
	input BtnL, BtnU, BtnR, BtnC, BtnD;
	input Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0;
	
	output MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS;
	output Ld0, Ld1, Ld2, Ld3, Ld4, Ld5, Ld6, Ld7;
	output An0, An1, An2, An3;
	output vga_h_sync, vga_v_sync;
	output vga_r, vga_g, vga_b;
	output Cg, Cf, Ce, Cd, Cc, Cb, Ca, Dp;
	
	wire ClkPort, ack, reset, start, enter;
	wire Q_INI, Q_PL1, Q_PL1C, Q_PL2, Q_PL2C, Q_END;
	wire board_clk, sys_clk;
	wire [41:0] game_board;
	wire [41:0] empty_board;
	wire [6:0] player_choice;
	wire [1:0] win;
	wire error_condition;
	wire [1:0] ssdscan_clk;
	reg [26:0] DIV_CLK;
	reg [3:0] ssd_column;
	wire [1:0] which_player;
	wire BtnL, BtnU, BtnD, BtnR, BtnC;
	wire BtnL_pulse, BtnU_pulse, BtnR_pulse, BtnC_pulse; 

	reg[3:0] col_pos;
	
	assign {MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS} = 5'b11111;

		deb #(.N_dc(28)) deb_u
        (.CLK(sys_clk), .RESET(reset), .PB(BtnU), .DPB(), 
		.SCEN(BtnU_pulse), .MCEN( ), .CCEN( ));
		
		deb #(.N_dc(28)) deb_c
        (.CLK(sys_clk), .RESET(reset), .PB(BtnC), .DPB(), 
		.SCEN(BtnC_pulse), .MCEN( ), .CCEN( ));

	assign player_choice = {Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1 }; 
	assign start = BtnD;
	assign reset = BtnU_pulse;
	assign enter = BtnC_pulse; 
	assign ack = BtnU_pulse; 
	
	BUFGP BUFGP1 (board_clk, ClkPort);
	
	//Divided Clock
	always @(posedge board_clk, posedge reset)
		begin
			if (reset)
				DIV_CLK <= 0;
			else
				DIV_CLK <= DIV_CLK + 1'b1;

		end
		
	assign sys_clk = board_clk;
	assign which_player = Sw0;
	
	localparam
	LEFT = 2'b10,
	RIGHT = 2'b01;
	
	localparam
	C7 = 7'b0000001,
	C6 = 7'b0000010,
	C5 = 7'b0000100,
	C4 = 7'b0001000,
	C3 = 7'b0010000,
	C2 = 7'b0100000,
	C1 = 7'b1000000;
	
	//determines column from switches (only one column switch can be active at any given time)
	always @ (posedge sys_clk)
		begin 
			case(player_choice)
				C7:	
					col_pos <= 4'b0111;
				C6:
					col_pos <= 4'b0110;
				C5:
					col_pos <= 4'b0101;
				C4:
					col_pos <= 4'b0100;
				C3:
					col_pos <= 4'b0011;
				C2:
					col_pos <= 4'b0010;
				C1:
					col_pos <= 4'b0001;
				default: 
					col_pos <= 4'b1111;	
			endcase
		end
	
	connect_4_v3 sm(.player_choice(player_choice), .player(which_player), .enter(enter), 
	.start(start), .clk(sys_clk), .ack(ack), .reset(reset), .Q_INI(Q_INI),
	.Q_PL1(Q_PL1), .Q_PL1C(Q_PL1C), .Q_PL2(Q_PL2), .Q_PL2C(Q_PL2C), .Q_END(Q_END),  
	.game_board(game_board), .empty_board(empty_board), .win(win), .error_condition(error_condition));

	//OUTPUT: LEDS
	//shows state
	assign {Ld7, Ld6, Ld5, Ld4, Ld3, Ld2} = {Q_INI, Q_PL1, Q_PL1C, Q_PL2, Q_PL2C, Q_END};
		
	/* SSD SIGNALS */
	reg [3:0] SSD;
	wire [3:0] SSD3, SSD2, SSD1, SSD0;
	reg [7:0] SSD_CATHODES;

	assign An0 = !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1 = !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2 = !((ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3 = !((ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES};

	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
		begin : SSD_SCAN_OUT
			case (ssdscan_clk) 
				2'b00: SSD = SSD0;
				2'b01: SSD = SSD1;
				2'b10: SSD = SSD2;
				2'b11: SSD = SSD3;
			endcase 
		end

	always @ (SSD) 
		begin : HEX_TO_SSD
			case (SSD) 
				4'b0000: SSD_CATHODES = 8'b00000011; // 0
				4'b0001: SSD_CATHODES = 8'b10011111; // 1
				4'b0010: SSD_CATHODES = 8'b00100101; // 2
				4'b0011: SSD_CATHODES = 8'b00001101; // 3
				4'b0100: SSD_CATHODES = 8'b10011001; // 4
				4'b0101: SSD_CATHODES = 8'b01001001; // 5
				4'b0110: SSD_CATHODES = 8'b01000001; // 6
				4'b0111: SSD_CATHODES = 8'b00011111; // 7
				4'b1000: SSD_CATHODES = 8'b00000001; // 8
				4'b1001: SSD_CATHODES = 8'b00001001; // 9
				4'b1010: SSD_CATHODES = 8'b00010001; // A
				4'b1011: SSD_CATHODES = 8'b11000001; // B
				4'b1100: SSD_CATHODES = 8'b01100011; // C
				4'b1101: SSD_CATHODES = 8'b10000101; // D
				4'b1110: SSD_CATHODES = 8'b01100001; // E
				4'b1111: SSD_CATHODES = 8'b11111111; // all empty
			endcase
		end	

	assign SSD3 = {2'b0, which_player + 1'b0001};
	assign SSD2 = col_pos;
	assign SSD1 = {3'b111, ~error_condition}; 
	assign SSD0 = {2'b0, win}; // 0 = none/draw, 1 = player 1, 2 = player 2

	assign ssdscan_clk = DIV_CLK[19:18]; // or [18:17]	

	//VGA 
	wire clk;
	assign clk = DIV_CLK[1]; 
	
	connect_4_vga vga(.clk(clk), .sys_clk(sys_clk), .reset(reset), .game_board(game_board), .frodo(empty_board), .vga_h_sync(vga_h_sync), 
	.vga_v_sync(vga_v_sync), .vga_r(vga_r), .vga_g(vga_g), .vga_b(vga_b));

endmodule

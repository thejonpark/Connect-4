`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:03:38 04/30/2014 
// Design Name: 
// Module Name:    connect_4_vga 
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
module connect_4_vga
	(game_board, frodo, clk, sys_clk, reset,
	 vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b
    );

	input [41:0] game_board;
	input [41:0] frodo;
	input clk, sys_clk, reset;
	
	output vga_h_sync, vga_v_sync;
	output reg vga_r, vga_g, vga_b;
	
	wire [9:0] CounterX;
	wire [9:0] CounterY;
	wire p1;
	wire p2;
	wire grid;
	reg [9:0] positionX = 60;
	reg [9:0] positionY = 60;
	wire inDisplayArea;

	always @ (posedge sys_clk)
		begin
			vga_r <= (p2 & inDisplayArea)|(p1 & inDisplayArea);
			vga_b <= grid & inDisplayArea;
			vga_g <= p2 & inDisplayArea;
		end
		
	sync sync(.clk(clk), .reset(reset), .vga_h_sync(vga_h_sync), 
	.vga_v_sync(vga_v_sync), .inDisplayArea(inDisplayArea), 
	.CounterX(CounterX), .CounterY(CounterY));
	
	//sets up grid in blue
	assign grid = 
			(CounterX >= 40 && CounterX <= 44) || 
			(CounterX >= 120 && CounterX <= 124) || 
			(CounterX >= 200 && CounterX <= 204) ||
			(CounterX >= 280 && CounterX <= 284) ||
			(CounterX >= 360 && CounterX <= 364) ||
			(CounterX >= 440 && CounterX <= 444) ||
			(CounterX >= 520 && CounterX <= 524) ||
			(CounterX >= 600 && CounterX <= 604) ||
			((CounterX >= 40 && CounterX <= 604) && (
			(CounterY >= 75 && CounterY <= 79) || 
			(CounterY >= 155 && CounterY <= 159) ||
			(CounterY >= 235 && CounterY <= 239) ||
			(CounterY >= 315 && CounterY <= 319) ||
			(CounterY >= 395 && CounterY <= 399) ||
			(CounterY >= 475 && CounterY <= 479) ||
			(CounterY >= 555 && CounterY <= 559)));

	//determines position of player 1's pieces in red
	assign p1 = 
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 410 && CounterY <= 464 && (frodo[0]==1) && (game_board[0]==0)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 410 && CounterY <= 464 && (frodo[1]==1) && (game_board[1]==0)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 410 && CounterY <= 464 && (frodo[2]==1) && (game_board[2]==0)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 410 && CounterY <= 464 && (frodo[3]==1) && (game_board[3]==0)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 410 && CounterY <= 464 && (frodo[4]==1) && (game_board[4]==0)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 410 && CounterY <= 464 && (frodo[5]==1) && (game_board[5]==0)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 410 && CounterY <= 464 && (frodo[6]==1) && (game_board[6]==0)) ||
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 330 && CounterY <= 384 && (frodo[7]==1) && (game_board[7]==0)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 330 && CounterY <= 384 && (frodo[8]==1) && (game_board[8]==0)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 330 && CounterY <= 384 && (frodo[9]==1) && (game_board[9]==0)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 330 && CounterY <= 384 && (frodo[10]==1) && (game_board[10]==0)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 330 && CounterY <= 384 && (frodo[11]==1) && (game_board[11]==0)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 330 && CounterY <= 384 && (frodo[12]==1) && (game_board[12]==0)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 330 && CounterY <= 384 && (frodo[13]==1) && (game_board[13]==0)) ||
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 250 && CounterY <= 304 && (frodo[14]==1) && (game_board[14]==0)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 250 && CounterY <= 304 && (frodo[15]==1) && (game_board[15]==0)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 250 && CounterY <= 304 && (frodo[16]==1) && (game_board[16]==0)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 250 && CounterY <= 304 && (frodo[17]==1) && (game_board[17]==0)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 250 && CounterY <= 304 && (frodo[18]==1) && (game_board[18]==0)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 250 && CounterY <= 304 && (frodo[19]==1) && (game_board[19]==0)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 250 && CounterY <= 304 && (frodo[20]==1) && (game_board[20]==0)) ||
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 170 && CounterY <= 224 && (frodo[21]==1) && (game_board[21]==0)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 170 && CounterY <= 224 && (frodo[22]==1) && (game_board[22]==0)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 170 && CounterY <= 224 && (frodo[23]==1) && (game_board[23]==0)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 170 && CounterY <= 224 && (frodo[24]==1) && (game_board[24]==0)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 170 && CounterY <= 224 && (frodo[25]==1) && (game_board[25]==0)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 170 && CounterY <= 224 && (frodo[26]==1) && (game_board[26]==0)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 170 && CounterY <= 224 && (frodo[27]==1) && (game_board[27]==0)) ||			
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 90 && CounterY <= 144 && (frodo[28]==1) && (game_board[28]==0)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 90 && CounterY <= 144 && (frodo[29]==1) && (game_board[29]==0)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 90 && CounterY <= 144 && (frodo[30]==1) && (game_board[30]==0)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 90 && CounterY <= 144 && (frodo[31]==1) && (game_board[31]==0)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 90 && CounterY <= 144 && (frodo[32]==1) && (game_board[32]==0)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 90 && CounterY <= 144 && (frodo[33]==1) && (game_board[33]==0)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 90 && CounterY <= 144 && (frodo[34]==1) && (game_board[34]==0)) ||
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 10 && CounterY <= 64 && (frodo[35]==1) && (game_board[35]==0)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 10 && CounterY <= 64 && (frodo[36]==1) && (game_board[36]==0)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 10 && CounterY <= 64 && (frodo[37]==1) && (game_board[37]==0)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 10 && CounterY <= 64 && (frodo[38]==1) && (game_board[38]==0)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 10 && CounterY <= 64 && (frodo[39]==1) && (game_board[39]==0)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 10 && CounterY <= 64 && (frodo[40]==1) && (game_board[40]==0)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 10 && CounterY <= 64 && (frodo[41]==1) && (game_board[41]==0));

	//determines position of player 2's pieces in yellow
	assign p2 = 
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 410 && CounterY <= 464 && (frodo[0]==1) && (game_board[0]==1)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 410 && CounterY <= 464 && (frodo[1]==1) && (game_board[1]==1)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 410 && CounterY <= 464 && (frodo[2]==1) && (game_board[2]==1)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 410 && CounterY <= 464 && (frodo[3]==1) && (game_board[3]==1)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 410 && CounterY <= 464 && (frodo[4]==1) && (game_board[4]==1)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 410 && CounterY <= 464 && (frodo[5]==1) && (game_board[5]==1)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 410 && CounterY <= 464 && (frodo[6]==1) && (game_board[6]==1)) ||
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 330 && CounterY <= 384 && (frodo[7]==1) && (game_board[7]==1)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 330 && CounterY <= 384 && (frodo[8]==1) && (game_board[8]==1)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 330 && CounterY <= 384 && (frodo[9]==1) && (game_board[9]==1)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 330 && CounterY <= 384 && (frodo[10]==1) && (game_board[10]==1)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 330 && CounterY <= 384 && (frodo[11]==1) && (game_board[11]==1)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 330 && CounterY <= 384 && (frodo[12]==1) && (game_board[12]==1)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 330 && CounterY <= 384 && (frodo[13]==1) && (game_board[13]==1)) ||
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 250 && CounterY <= 304 && (frodo[14]==1) && (game_board[14]==1)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 250 && CounterY <= 304 && (frodo[15]==1) && (game_board[15]==1)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 250 && CounterY <= 304 && (frodo[16]==1) && (game_board[16]==1)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 250 && CounterY <= 304 && (frodo[17]==1) && (game_board[17]==1)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 250 && CounterY <= 304 && (frodo[18]==1) && (game_board[18]==1)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 250 && CounterY <= 304 && (frodo[19]==1) && (game_board[19]==1)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 250 && CounterY <= 304 && (frodo[20]==1) && (game_board[20]==1)) ||
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 170 && CounterY <= 224 && (frodo[21]==1) && (game_board[21]==1)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 170 && CounterY <= 224 && (frodo[22]==1) && (game_board[22]==1)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 170 && CounterY <= 224 && (frodo[23]==1) && (game_board[23]==1)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 170 && CounterY <= 224 && (frodo[24]==1) && (game_board[24]==1)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 170 && CounterY <= 224 && (frodo[25]==1) && (game_board[25]==1)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 170 && CounterY <= 224 && (frodo[26]==1) && (game_board[26]==1)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 170 && CounterY <= 224 && (frodo[27]==1) && (game_board[27]==1)) ||			
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 90 && CounterY <= 144 && (frodo[28]==1) && (game_board[28]==1)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 90 && CounterY <= 144 && (frodo[29]==1) && (game_board[29]==1)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 90 && CounterY <= 144 && (frodo[30]==1) && (game_board[30]==1)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 90 && CounterY <= 144 && (frodo[31]==1) && (game_board[31]==1)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 90 && CounterY <= 144 && (frodo[32]==1) && (game_board[32]==1)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 90 && CounterY <= 144 && (frodo[33]==1) && (game_board[33]==1)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 90 && CounterY <= 144 && (frodo[34]==1) && (game_board[34]==1)) ||
			(CounterX >= 55 && CounterX <= 109 && CounterY >= 10 && CounterY <= 64 && (frodo[35]==1) && (game_board[35]==1)) ||
			(CounterX >= 135 && CounterX <= 189 && CounterY >= 10 && CounterY <= 64 && (frodo[36]==1) && (game_board[36]==1)) ||
			(CounterX >= 215 && CounterX <= 269 && CounterY >= 10 && CounterY <= 64 && (frodo[37]==1) && (game_board[37]==1)) ||
			(CounterX >= 295 && CounterX <= 349 && CounterY >= 10 && CounterY <= 64 && (frodo[38]==1) && (game_board[38]==1)) ||
			(CounterX >= 375 && CounterX <= 429 && CounterY >= 10 && CounterY <= 64 && (frodo[39]==1) && (game_board[39]==1)) ||
			(CounterX >= 455 && CounterX <= 509 && CounterY >= 10 && CounterY <= 64 && (frodo[40]==1) && (game_board[40]==1)) ||
			(CounterX >= 535 && CounterX <= 589 && CounterY >= 10 && CounterY <= 64 && (frodo[41]==1) && (game_board[41]==1));
endmodule

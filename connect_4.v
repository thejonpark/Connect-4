`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// EE 201 Final Project
// Connect 4
// by Kunal Shah & Jonathan Park
//////////////////////////////////////////////////////////////////////////////////
module connect_4_v3(player_choice, player, start, clk, reset, ack, enter, Q_INI, Q_PL1, Q_PL1C, Q_PL2, Q_PL2C, Q_END,
	game_board, empty_board, win, error_condition);
	
	input start, clk, reset, ack, enter;
	input [6:0] player_choice;
	input [1:0] player;
	
	// |35|36|37|38|39|40|41|
	// |28|29|30|31|32|33|34|
	// |21|22|23|24|25|26|27|
	// |14|15|16|17|18|19|20|
	// |7 |8 |9 |10|11|12|13|
	// |0 |1 |2 |3 |4 |5 |6 |

	// Above is representation of board, with the numbers of each
	// square being represented by the number 'location'. 
	// Everytime a piece is placed in a column, the location must increase
	// by 7 (or 6'b000111). Two outputs, game_board and game_empty, will 
	// be kept in order to keep track what locations are empty and filled. 
	// For game_empty, a 1 in a location means it is filled. 
	// For game_board, a 0 means that this is a player 1 piece,
	// a 1 means that this is a player 2 piece.
	
	//reg [1:0] which_player; // (00 = none, 10 = player 1, 11 = player 2)
	reg [5:0] location; // location in game board grid
	reg [5:0] loc; //location reg used in CHECK_WIN function
	reg [1:0] did_win; //boolean for checking if won
	
	integer i, j, k;
	integer draw_counter; 

	output reg [41:0] game_board;
	output reg [41:0] empty_board;
	output reg [1:0] win; // 00 = draw, 01 = player 1 win, 10 = player 2 win
	output reg error_condition;
	
	reg [5:0] state;
	output wire Q_INI, Q_PL1, Q_PL1C, Q_PL2, Q_PL2C, Q_END;
	assign {Q_END, Q_PL2C, Q_PL2, Q_PL1C, Q_PL1, Q_INI} = state;
	 
	reg flag_down; 
	reg flag_left; 
	reg flag_right;
	reg flag_up_left;
	reg	flag_up_right;
	reg flag_down_left;
	reg flag_down_right;
	
	reg [2:0] horizontal;
	reg [2:0] vertical;
	reg [2:0] diagonal1; 
	reg [2:0] diagonal2;
	
	localparam
	INI  = 6'b000001, //initial state
	PL1  = 6'b000010, //player 1 move
	PL1C = 6'b000100, //check player 1 move
	PL2  = 6'b001000, //player 2 move
	PL2C = 6'b010000, //check player 2 move
	END  = 6'b100000, //end state
	UNK  = 6'bXXXXXX;
	
	//columns
	localparam
	C7 = 7'b0000001,
	C6 = 7'b0000010,
	C5 = 7'b0000100,
	C4 = 7'b0001000,
	C3 = 7'b0010000,
	C2 = 7'b0100000,
	C1 = 7'b1000000;

	function [1:0] CHECK_WIN; //function to make checking if game is won easier
		input player;
		input [5:0] loc;
		begin
			horizontal = 3'b0; 
			vertical = 3'b0; 
			diagonal1 = 3'b0; 
			diagonal2 = 3'b0; 
			flag_down = 1'b1;
			flag_left = 1'b1;
			flag_right = 1'b1;
			flag_up_left = 1'b1;
			flag_up_right = 1'b1;
			flag_down_left = 1'b1;
			flag_down_right = 1'b1;
				
				for(i = 1; i <= 3; i = i + 1)
					begin 
					// Straight Line Win Condition
						//check left
						if((game_board[loc - i] == player) && (flag_left == 1) && (empty_board[loc - i] == 1) && ((loc - i + 1)%7 != 0))
							horizontal = horizontal + 1;
						else
							flag_left = 0; 
						
						//check right
						if((game_board[loc + i] == player) && (flag_right == 1) && (empty_board[loc + i] == 1) && ((loc + i)%7 != 0))
							horizontal = horizontal + 1;
						else
							flag_right = 0; 	

					// Straight Line Down Win Condition
						//check down
						if((game_board[loc - 7*i] == player) && (flag_down == 1) && (empty_board[loc - 7*i] == 1))
							vertical = vertical + 1;
						else
							flag_down = 0; 
					
					// Diagonal Line Win Condition
						//checks up left
						if((game_board[loc + (6*i)] == player) && (flag_up_left == 1) && (empty_board[loc + 6*i] == 1)) //&& ((loc + 6*i) > 6) && ((loc + 6*i + 1)%7 != 0))
							if(((loc + 6*i) > 6) && ((loc + 6*i + 1)%7 != 0))
								diagonal1 = diagonal1 + 1;
						else
							flag_up_left = 0; 

						//checks down right 
						if((game_board[loc - (6*i)] == player) && (flag_down_right == 1) && (empty_board[loc - 6*i] == 1)) 
							if(((loc - 6*i) < 35) && ((loc - 6*i)%7 != 0))
								diagonal1 = diagonal1 + 1;
						else
							flag_down_right = 0;

						//checks up right 
						if((game_board[loc + (8*i)] == player) && (flag_up_right == 1) && (empty_board[loc + 8*i] == 1))
							if(((loc + 8*i) > 6) && ((loc + 8*i)%7 != 0))
								diagonal2 = diagonal2 + 1;
						else
							flag_up_right = 0;

						//checks down left
						if((game_board[loc - (8*i)] == player) && (flag_down_left == 1) && (empty_board[loc - 8*i] == 1)) 
								diagonal2 = diagonal2 + 1;
						else
							flag_down_left = 0;   
				
					end
					
					//wins if there is 3 in a row + the piece just placed
					if(vertical >= 3 || horizontal >= 3 || diagonal1 >= 3 || diagonal2 >= 3)
						CHECK_WIN = 1;
					else
						CHECK_WIN = 0;
						
					flag_down = 1'b1;
					flag_left = 1'b1;
					flag_right = 1'b1;
					flag_up_left = 1'b1;
					flag_up_right = 1'b1;
					flag_down_left = 1'b1;
					flag_down_right = 1'b1;
					horizontal = 3'b000; 
					vertical = 3'b000;
					diagonal1 = 3'b000; 
					diagonal2 = 3'b000; 
		end
	endfunction	
	
	always @(posedge clk, posedge reset)
		begin
				if (reset)
					begin
						state <= INI;
						location <= 6'bXXXXXX;
						win <= 2'bX;
						game_board <= 42'bX;
						empty_board <= 42'bX;
						error_condition <= 1'b0;
						draw_counter <= 3'b0;
					end
				else
				begin
						case (state)
							INI:
								begin
									if(start)
										begin
											if(~player)
												state <= PL1;
											if(player)
												state <= PL2; 
										end
										
									location <= 6'b000000;
									win <= 2'b00;
									game_board <= 42'b0;
									empty_board <= 42'b0;
									error_condition <= 1'b0;
									draw_counter <= 3'b0;
								end
							PL1:
								begin
									if(enter && player == 2'b00)
										begin
											error_condition <= 1'b0;
											state <= PL1C; 
											
											//player 1's column selection
											case (player_choice)
												C1:
													begin
														location <= 6'b000000;
													end
												C2:
													begin
														location <= 6'b000001;
													end
												C3:
													begin
														location <= 6'b000010;
													end
												C4:
													begin
														location <= 6'b000011;
													end
												C5:
													begin
														location <= 6'b000100;
													end
												C6: 
													begin
														location <= 6'b000101;
													end
												C7:
													begin
														location <= 6'b000110;
													end
												default:
													begin
														state <= PL1;
													end
											endcase
										end
								end
							PL1C:
								begin
									if (location >= 6'b101010) //selected column is full
										begin
											error_condition <= 1'b1;
											state <= PL1;
										end
										
									else if (empty_board[location] != 1'b1) //selected area is empty
										begin
											empty_board[location] <= 1'b1; 
											game_board[location] <= 1'b0; //player 1 selection
											did_win = CHECK_WIN(0, location);
											
											if (did_win == 1'b1)
												begin
													state <= END;
													win <= 2'b01;
												end
											else 
												begin
													state <= PL2;
												end
										end
										
									else if (empty_board[location] == 1'b1)	//selected area is full, go to next one up!
										begin
											location <= location + 6'b000111;
											state <= PL1C; 
										end
									
								end
							PL2:
								begin
									if(enter && player == 2'b01)
										begin
											error_condition <= 1'b0;
											state <= PL2C; 
											
											//player 2's column selection
											case (player_choice)
												C1:
													begin
														location <= 6'b000000;
													end
												C2:
													begin
														location <= 6'b000001;
													end
												C3:
													begin
														location <= 6'b000010;
													end
												C4:
													begin
														location <= 6'b000011;
													end
												C5:
													begin
														location <= 6'b000100;
													end
												C6: 
													begin
														location <= 6'b000101;
													end
												C7:
													begin
														location <= 6'b000110;
													end
												default:
													begin
														state <= PL2;
													end
											endcase
										end
								end
							PL2C:
								begin
									if (location >= 6'b101010) //selected column is full
										begin
											error_condition <= 1'b1;
											state <= PL2;
										end
										
									else if (empty_board[location] != 1'b1) //selected area is empty
										begin
											empty_board[location] <= 1'b1;
											game_board[location] <= 1'b1; //player 2 selection
											did_win = CHECK_WIN(1, location);
											if (did_win == 1'b1)
												begin
													state <= END;
													win <= 2'b10;
												end
											else
												begin
													//draw if top row is completely full
													if(empty_board[41:35] == 7'b1111111)
														begin
															state <= END;
															win  <= 2'b00;
														end

													else	
														state <= PL1;
												end
										end
										
									else if (empty_board[location] == 1) //selected area is full, go to next one up!
										begin
											location <= location + 6'b000111;
											state <= PL2C; 
										end
									
								end									
							END:
								if (ack)
									state <= INI;
						endcase
					end
				end

endmodule


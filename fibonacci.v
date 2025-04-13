`ifndef FIBONACCI
	`define FIBONACCI
	module fibonacci(
		output reg [9:0] result,
		output reg done_tick, 
		input [3:0] n,
		input clk, reset, start
	);
		localparam READY=0, 
				   INIT=1,
				   PROC=2,
				   FINISH=3;
		reg [3:0] counter;
		reg [9:0] first, 
				  second;
		reg [1:0] state;
	   	always @(posedge clk, posedge reset) begin
			if (reset) begin
				result <= 0;
				done_tick <= 0;
				first <= 0;
				second <= 0;
				state <= 0;
				counter <= 1;
			end
			else begin
				case (state) 
					READY: begin
						first <= 0;
						second <= 0;
						counter <= 0;
						if (start) state <= INIT;
					end
					INIT: begin
						second <= 1;
						counter <= counter +1;
						if (counter == n) begin
							done_tick <= 1;
							result <= second;
							state <= FINISH;
						end
						else state <= PROC; 
					end
					PROC: begin
						second <= first + second;
						first <= second;	
						if (counter >= n) begin
						   	state <= FINISH;
							done_tick <= 1;
							result <= second;
					   	end
						counter <= counter + 1;
					end
					FINISH: begin
						state <= READY;
						done_tick <= 0;		
					end
				endcase
			end
		end
	endmodule
`endif

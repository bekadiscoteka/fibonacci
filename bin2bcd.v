`ifndef bin2bcd
`define bin2bcd
module bin2bcd(
    output ready, done_tick,
    output reg [3:0] bcd5, bcd4, bcd3, bcd2, bcd1, bcd0,
    input clk, reset, start,
    input [19:0] bin
);
	localparam READY = 0, PROC = 1, FINISH = 2, LAST=3;
    
    reg [1:0] state;
    reg [19:0] bin_reg;
    reg [4:0] counter;
	
	reg [3:0] _bcd5, _bcd4, _bcd3, _bcd2, _bcd1, _bcd0;
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= 0;
			bin_reg <= bin;
			counter <= 0;
			_bcd5 <= 0;
			_bcd4 <= 0;
			_bcd3 <= 0;
			_bcd2 <= 0;
			_bcd1 <= 0;
			_bcd0 <= 0;
			bcd5 <= 0;
			bcd4 <= 0;
			bcd3 <= 0;
			bcd2 <= 0;
			bcd1 <= 0;
			bcd0 <= 0;
				
		end
		else begin
			case (state) 
				READY: begin
					state <= start ? PROC : 0;
					bin_reg <= bin;
					counter <= 0;
					_bcd5 <= 0;
					_bcd4 <= 0;
					_bcd3 <= 0;
					_bcd2 <= 0;
					_bcd1 <= 0;
					_bcd0 <= 0;
				end
				PROC: begin				
					proc_and_shift();
					if (counter == 18) state <= LAST;
					counter <= counter + 1;
				end
				LAST: begin
					proc_and_shift();
					state <= FINISH;
				end
				FINISH: begin
					state <= READY;
					bcd5 <= _bcd5;
					bcd4 <= _bcd4;
					bcd3 <= _bcd3;
					bcd2 <= _bcd2;
					bcd1 <= _bcd1;
					bcd0 <= _bcd0;
				end
			endcase	
		end
	end
   	
   		
    assign ready = (state == READY);
    assign done_tick = (state == FINISH);

	task automatic proc_and_shift;
		begin
		{
			_bcd5,
			_bcd4, 
			_bcd3,
			_bcd2,
			_bcd1,
			_bcd0,
			bin_reg
		} <= ({
			(_bcd5 >= 4'd5) ? _bcd5 + 4'd3 : _bcd5,
    		(_bcd4 >= 4'd5) ? _bcd4 + 4'd3 : _bcd4,
    		(_bcd3 >= 4'd5) ? _bcd3 + 4'd3 : _bcd3,
			(_bcd2 >= 4'd5) ? _bcd2 + 4'd3 : _bcd2,
			(_bcd1 >= 4'd5) ? _bcd1 + 4'd3 : _bcd1,
			(_bcd0 >= 4'd5) ? _bcd0 + 4'd3 : _bcd0,
			bin_reg
	   	}) << 1;
		end
	endtask

	task automatic shift;
		begin
		{
			_bcd5,
			_bcd4, 
			_bcd3,
			_bcd2,
			_bcd1,
			_bcd0,
			bin_reg
		} <= ({
			_bcd5,
    		_bcd4,
    		_bcd3,
			_bcd2,
			_bcd1,
			_bcd0,
			bin_reg
	   	}) << 1;
		end
	endtask

endmodule
`endif

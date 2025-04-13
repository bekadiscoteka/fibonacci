`include "fibonacci.v"
`include "edge_detector.v"
`include "bin2bcd.v"
`include "bcd2sseg_active_low.v"
module fibonacci_top(
	output [7:0] sseg5,
				 sseg4,
				 sseg3,
				 sseg2,
				 sseg1,
				 sseg0,
	output [3:0] leds,
	input [3:0] in_bin,
	input start, //active-low button
	input clk, reset
);
	assign leds = in_bin;


	edge_detector #(.MODE(0)) button( // set mode fall output do_start,
		.tick(do_start),
		.in(start),	
		.clk(clk), .reset(reset)
	);

	wire fib_done_tick;
	wire [9:0] fib_result; 	
	fibonacci n_compute(
		.clk(clk),
		.reset(reset),
		.start(do_start),
		.done_tick(fib_done_tick),
		.n(in_bin),
		.result(fib_result)
	);
	wire [3:0] bcd5, bcd4, bcd3, bcd2, bcd1, bcd0;	
	bin2bcd get_bcd(
		.clk(clk),
		.reset(reset),
		.start(fib_done_tick),
		.bcd5(bcd5),
		.bcd4(bcd4),
		.bcd3(bcd3),
		.bcd2(bcd2),
		.bcd1(bcd1),
		.bcd0(bcd0),
		.bin({10'd0, fib_result})
	);

	assign {
		sseg5[7],	
		sseg4[7],
		sseg3[7],	
		sseg2[7],
		sseg1[7],	
		sseg0[7]
	} = 6'b111_111;	
	bcd2sseg_active_low b2ssAL(
		.bcd5(bcd5),
		.bcd4(bcd4),
		.bcd3(bcd3),
		.bcd2(bcd2),
		.bcd1(bcd1),
		.bcd0(bcd0),
		.sseg5(sseg5[6:0]),
		.sseg4(sseg4[6:0]),
		.sseg3(sseg3[6:0]),
		.sseg2(sseg2[6:0]),
		.sseg1(sseg1[6:0]),
		.sseg0(sseg0[6:0])
	);
endmodule

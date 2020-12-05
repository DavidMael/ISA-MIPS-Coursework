module single_reg_1bit(
    input logic clk, rst,
    input logic  p,
    output logic q
);

	always_ff @(posedge clk, posedge rst) begin

		if (rst == 1) begin
			q <= 1'b0;
		end else begin
			q <= p;
		end

	end



endmodule

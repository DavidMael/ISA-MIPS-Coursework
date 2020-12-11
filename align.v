//the module prepares the division a/b by shifting b left as much as possible while still having b<a
module align (
	input logic clk, alrst,
	input logic [31:0] ala, alb,
	output logic [31:0] shiftb 
	//output logic [15:0] bhigh, blow,
	//output logic [3:0] cnt, botcnt,
	//output logic aldone
);
	logic [31:0] shifted;
	logic [15:0] ahi, alo;
	//the bs have an extra bit to avoid overflow when shifting  
	logic [16:0] bhi, blo;
	logic [4:0] i, blo_cnt;
	logic end_lo, ahizero;

	/*initial begin
		alfinished <= 0;
	end*/
	
	always_comb begin
		//cnt = i;
		shiftb = shifted;
		//bhigh = bhi;
		//blow = blo;
		//aldone = alfinished;
		//botcnt = blo_cnt;
	end

	always_ff @(posedge clk) begin

		//if( alfinished == 1 ) begin
		//	alfinished <= 0;
		//end

		if(alrst == 1) begin
            //for speed, a and b are divided into two halves
			ahi <= ala[31:16];
			alo <= ala[15:0];
			bhi <= alb[31:16];
			blo <= alb[15:0];
			i <= 5'b00000;
			blo_cnt <= 5'h00;
			//ahi_cnt <= 4'h0;
			//alfinished <= 0; 
			end_lo <= 0;
			ahizero <= ( ala[31:16] == 16'h0000 );
		end else begin
				
            //shift both b halves and compare to corresponding a half-word, to determine amount by which to shift whole b.
			if (bhi > ahi) begin
				shifted <= (alb<<(i-1));
				//alfinished <= 1;
			end else begin
				if(i == 5'b10000) begin
					if( ahizero == 1 ) begin
						shifted <= (alb<<(blo_cnt-1));
						//alfinished <= 1;
					end else begin
						shifted <= {alb<<(blo_cnt-1), {16'h0000} };
					end					
				end else begin
					i <= (i + 1);
					bhi <= (bhi << 1);
				end
			end
	
	
			if(end_lo == 0) begin
				if( ( (blo > alo) & (ahizero == 1) ) | ( (blo > ahi) & (ahizero == 0) ) ) begin
					end_lo <= 1;
				end else begin
					blo <= (blo << 1);
					blo_cnt <= (blo_cnt + 1);
				end
			end
						
		end
		
	end
	
endmodule
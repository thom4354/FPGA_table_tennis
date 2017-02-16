`timescale 1ns / 1ps

module pong(mclk, an, HSYNC, VSYNC, OutRed, OutGreen, OutBlue, AUDIO_L, AUDIO_R, data1, data2);
	input mclk;
	
	output[2:0] an;
	//output[7:0] seg;
	output HSYNC, VSYNC, AUDIO_L, AUDIO_R;
	output[2:0] OutRed, OutGreen;
	output[1:0] OutBlue;
	
	inout data1;
	inout data2;
	
	//integer led_count = 0;
	//integer left_score = 0;
	//integer right_score = 0;
	
	reg[10:0] hsync_count = 1;
	reg[9:0] lines = 1;
	
	reg[15:0] clock_count = 0;
	reg[0:0] slow_clock = 0;
	
	reg[9:0] ypos_1_top = 270;
	reg[9:0] ypos_1_bottom = 330;
	
	parameter xpos_1_left = 1;
	parameter xpos_1_right = 10;
	
	reg[9:0] ypos_2_top = 270;
	reg[9:0] ypos_2_bottom = 330;
	
	parameter xpos_2_left = 790;
	parameter xpos_2_right = 799;
	
	reg[9:0] ballxleft = 391;
	reg[9:0] ballxright = 400;
	reg[9:0] ballybottom = 305;
	reg[9:0] ballytop = 296;
	reg[0:0] dir = 0;
	reg[0:0] ydir = 0;
	//integer yspeed = 65000;
	reg[1:0] audio_count = 0;
	reg[0:0] hit = 0;// = 4000000;
	reg[5:0] time_count = 0;
	
	reg [7:0] data_reg1 = 0;
	reg [7:0] data_reg2 = 0;

	//reg[2:0] an;
	//reg[7:0] seg;
	reg[2:0] OutRed;
	reg[2:0] OutGreen;
	reg[1:0] OutBlue;
	reg HSYNC;
	reg VSYNC;
	reg AUDIO_L;
	reg AUDIO_R;
	
	clockfx clock(.CLKIN_IN(mclk), 
		.CLKFX_OUT(clk));
		
	//clockdiv clock2(.CLKIN_IN(clk), .CLKFX_OUT(n64_clk));
		
	//wire audio_out;
	//assign audio_out = (clk && countdown);
		
	/*always @(posedge clk)
	begin
		if(hit && (time_count <= 4000000))
		begin
			audio_count <= audio_count + 1;
			time_count <= time_count + 1;
			if(audio_count == 133333)
			begin
				AUDIO_L <= ~AUDIO_L;
				AUDIO_R <= ~AUDIO_R;
				audio_count <= 0;
			end
		end
		
		else if(hit && (time_count == 4000000))
		begin
			time_count <= 0;
			hit <= 0;
		end
	end*/
	
	/*always @(posedge clk)
	begin
		if(countdown > 0) countdown <= countdown - 1;
	end*/
		
	always @(posedge clk)
	begin
		clock_count <= clock_count + 1;
		
		if(clock_count == 40000)
		begin
			slow_clock <= ~slow_clock;
			clock_count <= 0;
		end
	end
		
	always @(posedge slow_clock)
	begin
		if(data_reg1[4] && ypos_1_top >= 1)
		begin
			ypos_1_top <= ypos_1_top - 1;
			ypos_1_bottom <= ypos_1_bottom - 1;
		end
		
		if(data_reg1[5] && ypos_1_bottom <= 600)
		begin
			ypos_1_top <= ypos_1_top + 1;
			ypos_1_bottom <= ypos_1_bottom + 1;
		end
		
		if(data_reg2[4] && ypos_2_top >= 1)
		begin
			ypos_2_top <= ypos_2_top - 1;
			ypos_2_bottom <= ypos_2_bottom - 1;
		end
		
		if(data_reg2[5] && ypos_2_bottom <= 600)
		begin
			ypos_2_top <= ypos_2_top + 1;
			ypos_2_bottom <= ypos_2_bottom + 1;
		end
		
		if(dir)
		begin
			ballxright <= ballxright + 1;
			ballxleft <= ballxleft + 1;
		end
		
		else if(!dir)
		begin
			ballxright <= ballxright - 1;
			ballxleft <= ballxleft - 1;
		end
		
		if(ydir)
		begin
			ballytop <= ballytop - 1;
			ballybottom <= ballybottom - 1;
		end
		
		else if(!ydir)
		begin
			ballytop <= ballytop + 1;
			ballybottom <= ballybottom + 1;
		end
		
		if((ballxleft == xpos_1_right) && (((ballytop <= ypos_1_bottom) && (ballytop >= ypos_1_top)) || ((ballybottom <= ypos_1_bottom) && (ballybottom >= ypos_1_top))))
		begin
			dir <= 1;
			hit <= 1;
		end
		
		else if(ballxright == 0)
		begin
			ballxleft <= 391;
			ballxright <= 400;
			ballybottom <= 305;
			ballytop <= 296;
			
			//right_score <= right_score + 1;
			//if(right_score == 9) right_score <= 0;
		end

		else if((ballxright == xpos_2_left) && (((ballytop <= ypos_2_bottom) && (ballytop >= ypos_2_top)) || ((ballybottom <= ypos_2_bottom) && (ballybottom >= ypos_2_top))))
		begin
			dir <= 0;
			hit <= 1;
		end
		
		else if(ballxleft == 801)
		begin
			ballxleft <= 391;
			ballxright <= 400;
			ballybottom <= 305;
			ballytop <= 296;
			
			//left_score <= left_score + 1;
			//if(left_score == 9) left_score <= 0;
		end
		
		if(ballytop == 0) ydir <= 0;
		
		else if(ballybottom == 600) ydir <= 1;
		
		if(hit && (time_count < 60))
		begin
			audio_count <= audio_count + 1;
			time_count <= time_count + 1;
			if(audio_count == 2)
			begin
				AUDIO_L <= ~AUDIO_L;
				AUDIO_R <= ~AUDIO_R;
				audio_count <= 0;
			end
		end
		
		else if(time_count == 60)
		begin
			time_count <= 0;
			hit <= 0;
		end
	end
	
	//assign seg[7:0] = 8'b11111111;
	assign an[2:0] = 3'b111;
/*	always @(posedge clk)
	begin
		led_count <= led_count + 1;
		
		if(led_count == 40000)
		begin
			an <= 3'b110;
			case(right_score)
				0: seg <= 7'b1000000;
				1: seg <= 7'b1111001;
				2: seg <= 7'b0100100;
				3: seg <= 7'b0110000;
				4: seg <= 7'b0011001;
				5: seg <= 7'b0010010;
				6: seg <= 7'b0000010;
				7: seg <= 7'b1111000;
				8: seg <= 7'b0000000;
				9: seg <= 7'b0010000;
			endcase
		end
		
		else if(led_count == 80000)
		begin
			an <= 3'b101;
			seg <= 7'b1111111;
		end
		
		else if(led_count == 120000)
		begin
			an <= 3'b011;
			case(left_score)
				0: seg <= 7'b1000000;
				1: seg <= 7'b1111001;
				2: seg <= 7'b0100100;
				3: seg <= 7'b0110000;
				4: seg <= 7'b0011001;
				5: seg <= 7'b0010010;
				6: seg <= 7'b0000010;
				7: seg <= 7'b1111000;
				8: seg <= 7'b0000000;
				9: seg <= 7'b0010000;
			endcase
		end
	end*/
		
	
	always @(posedge clk)
	begin
		hsync_count <= hsync_count + 1;
		
		if((hsync_count > 799) || (lines > 602))
		begin
			OutBlue[1:0] <= 2'b00;
			OutRed[2:0] <= 3'b000;
			OutGreen[2:0] <= 3'b000;
		end
		
		else if((hsync_count >= ballxleft) && (hsync_count <= ballxright) && (lines >= ballytop) && (lines <= ballybottom))
		begin
			OutBlue[1:0] <= 2'b11;
			OutRed[2:0] <= 3'b111;
			OutGreen[2:0] <= 3'b111;
		end
		
		else if(((hsync_count > 398) && (hsync_count < 401)) && ((lines % 16 < 8) && (lines < 602)))
		begin
			OutBlue[1:0] <= 2'b11;
			OutRed[2:0] <= 3'b111;
			OutGreen[2:0] <= 3'b111;
		end
		
		else if((hsync_count >= xpos_1_left) && (hsync_count <= xpos_1_right) && (lines >= ypos_1_top) && (lines <= ypos_1_bottom))
		begin
			OutBlue[1:0] <= 2'b11;
			OutRed[2:0] <= 3'b111;
			OutGreen[2:0] <= 3'b111;
		end
		
		else if((hsync_count >= xpos_2_left) && (hsync_count <= xpos_2_right) && (lines >= ypos_2_top) && (lines <= ypos_2_bottom))
		begin
			OutBlue[1:0] <= 2'b11;
			OutRed[2:0] <= 3'b111;
			OutGreen[2:0] <= 3'b111;
		end
		
		else
		begin
			OutBlue[1:0] <= 2'b00;
			OutRed[2:0] <= 3'b000;
			OutGreen[2:0] <= 3'b011;
		end
		
		if((hsync_count > 839) && (hsync_count < 968)) HSYNC <= 1;
		else HSYNC <= 0;
		
		if(hsync_count > 1054)
		begin
			hsync_count <= 1;
			lines <= lines + 1;
		end
		
		if((lines > 601) && (lines < 606)) VSYNC <= 1;
		else VSYNC <= 0;
		
		if(lines > 629) lines <= 1;
	end
	
//////////////////////////////////////////////////////////////////////////////////////////

	reg [0:0] n64_clk = 0;
	reg [1:0] n64_count = 0;
	
	always @(posedge clk)
	begin
		n64_count <= n64_count + 1;
		
		if(n64_count == 2)
		begin
			n64_count <= 0;
			n64_clk <= ~n64_clk;
		end
	end
		
	reg [0:0] direction1 = 0;
		
	assign data1 = direction1 ? 0 : 'bz;
		
	reg [13:0] millisec1 = 0;
	reg [0:0] start_signal1;
	reg [8:0] pos_count1 = 0;
	reg [0:0] listen1;
	reg [8:0] count1 = 0;
	reg [0:0] start_reading1 = 0;
	reg [0:0] hold1 = 0;
	reg [0:0] hold_finished1 = 0;
		
	always @(posedge n64_clk)
	begin
	
		millisec1 <= millisec1 + 1;
		if(millisec1 == 9999) begin
			start_signal1 <= 1;
		end
		
		if(start_signal1 == 1)
		begin
			pos_count1 <= pos_count1 + 1;
			case(pos_count1)
				0:
				begin
					direction1 <= 1;
					listen1 <= 0;
				end
				30: direction1 <= 0;
				40: direction1 <= 1;
				70: direction1 <= 0;
				80: direction1 <= 1;
				110: direction1 <= 0;
				120: direction1 <= 1;
				150: direction1 <= 0;
				160: direction1 <= 1;
				190: direction1 <= 0;
				200: direction1 <= 1;
				230: direction1 <= 0;
				240: direction1 <= 1;
				270: direction1 <= 0;
				280: direction1 <= 1;
				290: direction1 <= 0;
				320: direction1 <= 1;
				330: 
				begin
					direction1 <= 0;
					listen1 <= 1;
					pos_count1 <= 0;
					start_signal1 <= 0;
					millisec1 <= 0;
					hold1 <= 1;
				end
			endcase				
		end
		
		if(hold_finished1 && ~data1)
		begin
			start_reading1 <= 1;
			hold_finished1 <= 0;
		end
		
		if(hold1 && data1)
		begin
			hold_finished1 <= 1;
			hold1 <= 0;
		end
		
		if(start_reading1 && listen1)
		begin
			count1 <= count1 + 1;
			
			case(count1)
			20: 
			begin
				data_reg1[0] <= data1;
				start_reading1 <= 0;
				hold1 <= 1;
			end
			
			40:
			begin
				data_reg1[1] <= data1;
				start_reading1 <= 0;
				hold1 <= 1;
			end
			
			60:
			begin
				data_reg1[2] <= data1;
				start_reading1 <= 0;
				hold1 <= 1;
			end
			
			80:
			begin
				data_reg1[3] <= data1;
				start_reading1 <= 0;
				hold1 <= 1;
			end
			
			100:
			begin
				data_reg1[4] <= data1;
				start_reading1 <= 0;
				hold1 <= 1;
			end
			
			120:
			begin
				data_reg1[5] <= data1;
				start_reading1 <= 0;
				hold1 <= 1;
			end
			
			140:
			begin
				data_reg1[6] <= data1;
				start_reading1 <= 0;
				hold1 <= 1;
			end
			
			160: 
			begin
				data_reg1[7] <= data1;
				count1 <= 0;
				listen1 <= 0;
				start_reading1 <= 0;
			end
			endcase
		end
	end
	
	////////////////////////////////////////////////////////////////////////////////////
	
	reg [0:0] direction2 = 0;
		
	assign data2 = direction2 ? 0 : 'bz;
		
	reg [13:0] millisec2 = 0;
	reg [0:0] start_signal2;
	reg [8:0] pos_count2 = 0;
	reg [0:0] listen2;
	reg [8:0] count2 = 0;
	reg [0:0] start_reading2 = 0;
	reg [0:0] hold2 = 0;
	reg [0:0] hold_finished2 = 0;
		
	always @(posedge n64_clk)
	begin
	
		millisec2 <= millisec2 + 1;
		if(millisec2 == 9999) begin
			start_signal2 <= 1;
		end
		
		if(start_signal2 == 1)
		begin
			pos_count2 <= pos_count2 + 1;
			case(pos_count2)
				0:
				begin
					direction2 <= 1;
					listen2 <= 0;
				end
				30: direction2 <= 0;
				40: direction2 <= 1;
				70: direction2 <= 0;
				80: direction2 <= 1;
				110: direction2 <= 0;
				120: direction2 <= 1;
				150: direction2 <= 0;
				160: direction2 <= 1;
				190: direction2 <= 0;
				200: direction2 <= 1;
				230: direction2 <= 0;
				240: direction2 <= 1;
				270: direction2 <= 0;
				280: direction2 <= 1;
				290: direction2 <= 0;
				320: direction2 <= 1;
				330: 
				begin
					direction2 <= 0;
					listen2 <= 1;
					pos_count2 <= 0;
					start_signal2 <= 0;
					millisec2 <= 0;
					hold2 <= 1;
				end
			endcase				
		end
		
		if(hold_finished2 && ~data2)
		begin
			start_reading2 <= 1;
			hold_finished2 <= 0;
		end
		
		if(hold2 && data2)
		begin
			hold_finished2 <= 1;
			hold2 <= 0;
		end
		
		if(start_reading2 && listen2)
		begin
			count2 <= count2 + 1;
			
			case(count2)
			20: 
			begin
				data_reg2[0] <= data2;
				start_reading2 <= 0;
				hold2 <= 1;
			end
			
			40:
			begin
				data_reg2[1] <= data2;
				start_reading2 <= 0;
				hold2 <= 1;
			end
			
			60:
			begin
				data_reg2[2] <= data2;
				start_reading2 <= 0;
				hold2 <= 1;
			end
			
			80:
			begin
				data_reg2[3] <= data2;
				start_reading2 <= 0;
				hold2 <= 1;
			end
			
			100:
			begin
				data_reg2[4] <= data2;
				start_reading2 <= 0;
				hold2 <= 1;
			end
			
			120:
			begin
				data_reg2[5] <= data2;
				start_reading2 <= 0;
				hold2 <= 1;
			end
			
			140:
			begin
				data_reg2[6] <= data2;
				start_reading2 <= 0;
				hold2 <= 1;
			end
			
			160: 
			begin
				data_reg2[7] <= data2;
				count2 <= 0;
				listen2 <= 0;
				start_reading2 <= 0;
			end
			endcase
		end
	end

endmodule

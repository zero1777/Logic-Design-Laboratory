`define silence 32'd50000000
`define sil   32'd50000000 // slience
`define alpha_A 7'b0100000
`define alpha_B 7'b0000011
`define alpha_C 7'b0100111
`define alpha_D 7'b0100001
`define alpha_E 7'b0000110
`define alpha_F 7'b0001110
`define alpha_G 7'b1000010
`define AA 4'd1
`define BB 4'd2
`define CC 4'd3
`define DD 4'd4
`define EE 4'd5
`define FF 4'd6
`define GG 4'd7

`define hc  32'd524   // C4
`define hd  32'd588   // D4
`define he  32'd660   // E4
`define hf  32'd698   // F4
`define hg  32'd784   // G4
`define ha  32'd880   // G4
`define hb  32'd988   // G4
`define hhc  32'd1046   // G4
`define da  32'd220   // G4
`define db  32'd245   // G4
`define c   32'd262   // C3
`define d   32'd294   // D3
`define e   32'd330   // D3
`define f   32'd349   // D3
`define g   32'd392   // G3
`define a   32'd440   // G3
`define b   32'd494   // B3
`define rc   32'd277   // c#
`define ld   32'd277   // c#
`define rd   32'd311   // c#
`define le   32'd311   // c#
`define rf   32'd370   // c#
`define lg   32'd370   // c#
`define rg   32'd415   // c#
`define la   32'd415   // c#
`define ra   32'd466   // c#
`define lb   32'd466   // c#
`define rhc   32'd554   // c#
`define lhd   32'd554   // c#
`define rhd   32'd622   // c#
`define lhe   32'd622   // c#
`define rhf   32'd740   // c#
`define lhg   32'd740   // c#
`define rhg   32'd831   // c#
`define lha   32'd831   // c#
`define rha   32'd932   // c#

module speaker(
    clk, // clock from crystal
    rst, // active high reset: BTNC
    _play, // SW: Play/Pause
    _mute, // SW: Mute
    _repeat, // SW: Repeat
    _music, // SW: Music
    _volUP, // BTN: Vol up
    _volDOWN, // BTN: Vol down
    _led_vol, // LED: volume
    audio_mclk, // master clock
    audio_lrck, // left-right clock
    audio_sck, // serial clock
    audio_sdin, // serial audio data input
    DISPLAY, // 7-seg
    DIGIT // 7-seg
);

    // I/O declaration
    input clk;  // clock from the crystal
    input rst;  // active high reset
    input _play, _mute, _repeat, _music, _volUP, _volDOWN;
    output reg [4:0] _led_vol;
    output audio_mclk; // master clock
    output audio_lrck; // left-right clock
    output audio_sck; // serial clock
    output audio_sdin; // serial audio data input
    output reg [6:0] DISPLAY;
    output reg [3:0] DIGIT;
    
    reg [4:0] next_led_vol, led_vol;
    reg [2:0] volume, next_volume, volume1;
    reg [3:0] TONE;
    reg [3:0] tn;
    //reg [14:0] LEN;
    wire _volUP_de, _volUP_onepulse, _volDOWN_de, _volDOWN_onepulse;
    // assign DIGIT = 4'b0001;
    // assign DISPLAY = 7'b111_1111;

    // Internal Signal
    wire [15:0] audio_in_left, audio_in_right;
    
    wire clkDiv22, clkDiv13;
    wire [14:0] ibeatNum; // Beat counter
    wire [31:0] freqL, freqR; // Raw frequency, produced by music module
    wire [21:0] freq_outL, freq_outR; // Processed Frequency, adapted to the clock rate of Basys3

    assign freq_outL = 50000000 / (_mute ? `silence : freqL); // Note gen makes no sound, if freq_out = 50000000 / `silence = 1
    assign freq_outR = 50000000 / (_mute ? `silence : freqR);

    debounce de1 (.pb_debounced(_volDOWN_de), .pb(_volDOWN) ,.clk(clkDiv13));
    debounce de2 (.pb_debounced(_volUP_de), .pb(_volUP) ,.clk(clkDiv13));

    onepulse op1(.signal(_volDOWN_de), .clk(clk), .op(_volDOWN_onepulse));
    onepulse op2(.signal(_volUP_de), .clk(clk), .op(_volUP_onepulse));

    clock_divider #(.n(13)) clock_(
        .clk(clk),
        .clk_div(clkDiv13)
    );

    clock_divider #(.n(22)) clock_22(
        .clk(clk),
        .clk_div(clkDiv22)
    );

    // Player Control
    player_control playerCtrl_00 ( 
        .clk(clkDiv22),
        .reset(rst),
        ._play(_play),
        ._repeat(_repeat),
        ._music(_music),
        .ibeat(ibeatNum)
    );

    // Music module
    // [in]  beat number and en
    // [out] left & right raw frequency
    music_example music_00 (
        .ibeatNum(ibeatNum),
        .en(_play),
        ._music(_music),
        .toneL(freqL),
        .toneR(freqR)
    );

    // Note generation
    // [in]  processed frequency
    // [out] audio wave signal (using square wave here)
    note_gen noteGen_00(
        .clk(clk), // clock from crystal
        .rst(rst), // active high reset
        .note_div_left(freq_outL),
        .note_div_right(freq_outR),
        .audio_left(audio_in_left), // left sound audio
        .audio_right(audio_in_right),
        .volume(volume) // 3 bits for 5 levels
    );

    // Speaker controller
    speaker_control sc(
        .clk(clk),  // clock from the crystal
        .rst(rst),  // active high reset
        .audio_in_left(audio_in_left), // left channel audio data input
        .audio_in_right(audio_in_right), // right channel audio data input
        .audio_mclk(audio_mclk), // master clock
        .audio_lrck(audio_lrck), // left-right clock
        .audio_sck(audio_sck), // serial clock
        .audio_sdin(audio_sdin) // serial audio data input
    );

    // seven segment
    always @(posedge clkDiv13) begin
        case (DIGIT)
            4'b1110: begin
                DIGIT = 4'b1101;
                TONE = 4'd10;
            end
            4'b1101: begin
                DIGIT = 4'b1011;
                TONE = 4'd10;
            end
            4'b1011: begin
                DIGIT = 4'b0111;
                TONE = 4'd10;
            end
            4'b0111: begin
                DIGIT = 4'b1110;
                TONE = tn;
            end
            default: begin
                DIGIT = 4'b1110;
                TONE = 4'd11;
            end
        endcase
    end

    always @(*) begin
        case (TONE)
    		`AA : DISPLAY = `alpha_A;	//0000
		    `BB : DISPLAY = `alpha_B;   //0001                                                
			`CC : DISPLAY = `alpha_C;   //0010                                                
			`DD : DISPLAY = `alpha_D;   //0011                                             
			`EE : DISPLAY = `alpha_E;   //0100                                               
			`FF : DISPLAY = `alpha_F;   //0101                                               
			`GG : DISPLAY = `alpha_G;   //0110
			4'd10 : DISPLAY = 7'b0111111;  // "-" 
			4'd11 : DISPLAY = 7'b1111111;  // light down
			default : DISPLAY = 7'b0111111;
    	endcase
    end

    always @(*) begin
        if (freqR == `a || freqR == `ha || freqR == `ra || freqR == `rha || freqR == `da) tn = `AA;
        else if (freqR == `b || freqR == `lb || freqR == `hb || freqR == `db) tn = `BB;
        else if (freqR == `c || freqR == `hc || freqR == `rc || freqR == `rhc || freqR == `hhc) tn = `CC;
        else if (freqR == `d || freqR == `hd || freqR == `rd || freqR == `rhd 
        || freqR == `ld || freqR == `lhd) tn = `DD;
        else if (freqR == `e || freqR == `he || freqR == `le || freqR == `lhe) tn = `EE;
        else if (freqR == `f || freqR == `hf || freqR == `rf || freqR == `rhf) tn = `FF;
        else if (freqR == `g || freqR == `hg || freqR == `rg || freqR == `rhg 
        || freqR == `lg || freqR == `lhg) tn = `GG;
        else if (freqR == `silence) tn = 4'd10;
        else tn = 4'd10;
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            _led_vol <= 5'b0_0111;
            led_vol <= 5'b0_0111;
        end
        else begin
            _led_vol <= (_mute) ? 5'b0_0000 : next_led_vol;
            led_vol <= next_led_vol;
        end
    end

    always @* begin
        next_led_vol = led_vol;
        if (_volUP_onepulse) begin
            next_led_vol = (led_vol == 5'b1_1111) ? 5'b1_1111 : {led_vol[3:0], 1'b1};
        end
        else if (_volDOWN_onepulse) begin
            next_led_vol = (led_vol == 5'b0_0001) ? 5'b0_0001 : {1'b0, led_vol[4:1]};
        end
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            volume <= 3'd3;
            volume1 <= 3'd3;
        end
        else begin
            volume <= (_mute) ? 3'd0 : next_volume;
            volume1 <= next_volume;
        end
    end

    always @(*) begin
        next_volume = volume1;
        if (_volUP_onepulse) begin
            next_volume = (volume1 == 3'd5) ? 3'd5 : volume1 + 3'd1;
        end
        else if (_volDOWN_onepulse) begin
            next_volume = (volume1 == 3'b001) ? 3'b001 : volume1 - 3'd1;
        end
    end

//    always @(*) begin
//        if (_music) begin
//            LEN = 15'd319;
//        end
//        else begin
//            LEN = 15'd511;
//        end
//    end
    
endmodule

module debounce(pb_debounced, pb ,clk);
    output pb_debounced;
    input pb;
    input clk;
    
    reg [6:0] shift_reg;
    always @(posedge clk) begin
        shift_reg[6:1] <= shift_reg[5:0];
        shift_reg[0] <= pb;
    end
    
    assign pb_debounced = shift_reg == 7'b111_1111 ? 1'b1 : 1'b0;
endmodule

module onepulse(signal, clk, op);
    input signal, clk;
    output op;
    
    reg op;
    reg delay;
    
    always @(posedge clk) begin
        if((signal == 1) & (delay == 0)) op <= 1;
        else op <= 0; 
        delay = signal;
    end
endmodule

module clock_divider(clk, clk_div);   
    parameter n = 26;     
    input clk;   
    output clk_div;   
    
    reg [n-1:0] num;
    wire [n-1:0] next_num;
    
    always@(posedge clk)begin
    	num<=next_num;
    end
    
    assign next_num = num +1;
    assign clk_div = num[n-1];
    
endmodule

module player_control (
	input clk,
	input reset,
	input _play,
	input _repeat,
	input _music,
//	input [14:0] LEN,
	output reg [11:0] ibeat
);
    reg [14:0] next_ibeat;
	reg check;
	reg [14:0] LEN;

	// always @(posedge clk, posedge reset) begin
	// 	if (reset)
	// 		ibeat <= 0;
	// 	else begin
    //         ibeat <= next_ibeat;
	// 	end
	// end

    always @* begin
		if (_play) begin
			next_ibeat = (ibeat + 1 < LEN) ? (ibeat + 1) : ((_repeat) ? 15'd0 : ibeat);
		end
		else begin
			next_ibeat = ibeat;
		end
    end

	always @(posedge clk, posedge reset) begin
		if (reset) begin
			check = 1'b0;
			ibeat = 0;
		end
		else begin
			ibeat = next_ibeat;
			if (_music) begin
				check = check;
				if (check == 1'b0) begin
					check = 1'b1;
					ibeat = 0;
				end
			end
			else begin
				check = check;
				if (check == 1'b1) begin
					check = 1'b0;
					ibeat = 0;
				end
			end
		end
	end

    always @(*) begin
        if (_music) begin
            LEN = 15'd321;
        end
        else begin
            LEN = 15'd513;
        end
    end

endmodule


module music_example (
	input [14:0] ibeatNum,
	input en,
    input _music,
	output reg [31:0] toneL,
    output reg [31:0] toneR
);

    always @* begin
        if(en == 1) begin
            if (_music) begin
                case(ibeatNum)
                    // // --- Measure 1 ---
                    // 12'd0: toneR = `hg;      12'd1: toneR = `hg; // HG (half-beat)
                    // 12'd2: toneR = `hg;      12'd3: toneR = `hg;
                    // 12'd4: toneR = `hg;      12'd5: toneR = `hg;
                    // 12'd6: toneR = `hg;      12'd7: toneR = `hg;
                    // 12'd8: toneR = `he;      12'd9: toneR = `he; // HE (half-beat)
                    // 12'd10: toneR = `he;     12'd11: toneR = `he;
                    // 12'd12: toneR = `he;     12'd13: toneR = `he;
                    // 12'd14: toneR = `he;     12'd15: toneR = `sil; // (Short break for repetitive notes: high E)

                    // 12'd16: toneR = `he;     12'd17: toneR = `he; // HE (one-beat)
                    // 12'd18: toneR = `he;     12'd19: toneR = `he;
                    // 12'd20: toneR = `he;     12'd21: toneR = `he;
                    // 12'd22: toneR = `he;     12'd23: toneR = `he;
                    // 12'd24: toneR = `he;     12'd25: toneR = `he;
                    // 12'd26: toneR = `he;     12'd27: toneR = `he;
                    // 12'd28: toneR = `he;     12'd29: toneR = `he;
                    // 12'd30: toneR = `he;     12'd31: toneR = `he;

                    // 12'd32: toneR = `hf;     12'd33: toneR = `hf; // HF (half-beat)
                    // 12'd34: toneR = `hf;     12'd35: toneR = `hf;
                    // 12'd36: toneR = `hf;     12'd37: toneR = `hf;
                    // 12'd38: toneR = `hf;     12'd39: toneR = `hf;
                    // 12'd40: toneR = `hd;     12'd41: toneR = `hd; // HD (half-beat)
                    // 12'd42: toneR = `hd;     12'd43: toneR = `hd;
                    // 12'd44: toneR = `hd;     12'd45: toneR = `hd;
                    // 12'd46: toneR = `hd;     12'd47: toneR = `sil; // (Short break for repetitive notes: high D)

                    // 12'd48: toneR = `hd;     12'd49: toneR = `hd; // HD (one-beat)
                    // 12'd50: toneR = `hd;     12'd51: toneR = `hd;
                    // 12'd52: toneR = `hd;     12'd53: toneR = `hd;
                    // 12'd54: toneR = `hd;     12'd55: toneR = `hd;
                    // 12'd56: toneR = `hd;     12'd57: toneR = `hd;
                    // 12'd58: toneR = `hd;     12'd59: toneR = `hd;
                    // 12'd60: toneR = `hd;     12'd61: toneR = `hd;
                    // 12'd62: toneR = `hd;     12'd63: toneR = `hd;

                    // // --- Measure 2 ---
                    // 12'd64: toneR = `hc;     12'd65: toneR = `hc; // HC (half-beat)
                    // 12'd66: toneR = `hc;     12'd67: toneR = `hc;
                    // 12'd68: toneR = `hc;     12'd69: toneR = `hc;
                    // 12'd70: toneR = `hc;     12'd71: toneR = `hc;
                    // 12'd72: toneR = `hd;     12'd73: toneR = `hd; // HD (half-beat)
                    // 12'd74: toneR = `hd;     12'd75: toneR = `hd;
                    // 12'd76: toneR = `hd;     12'd77: toneR = `hd;
                    // 12'd78: toneR = `hd;     12'd79: toneR = `hd;

                    // 12'd80: toneR = `he;     12'd81: toneR = `he; // HE (half-beat)
                    // 12'd82: toneR = `he;     12'd83: toneR = `he;
                    // 12'd84: toneR = `he;     12'd85: toneR = `he;
                    // 12'd86: toneR = `he;     12'd87: toneR = `he;
                    // 12'd88: toneR = `hf;     12'd89: toneR = `hf; // HF (half-beat)
                    // 12'd90: toneR = `hf;     12'd91: toneR = `hf;
                    // 12'd92: toneR = `hf;     12'd93: toneR = `hf;
                    // 12'd94: toneR = `hf;     12'd95: toneR = `hf;

                    // 12'd96: toneR = `hg;     12'd97: toneR = `hg; // HG (half-beat)
                    // 12'd98: toneR = `hg;     12'd99: toneR = `hg;
                    // 12'd100: toneR = `hg;     12'd101: toneR = `hg;
                    // 12'd102: toneR = `hg;     12'd103: toneR = `sil; // (Short break for repetitive notes: high D)
                    // 12'd104: toneR = `hg;     12'd105: toneR = `hg; // HG (half-beat)
                    // 12'd106: toneR = `hg;     12'd107: toneR = `hg;
                    // 12'd108: toneR = `hg;     12'd109: toneR = `hg;
                    // 12'd110: toneR = `hg;     12'd111: toneR = `sil; // (Short break for repetitive notes: high D)

                    // 12'd112: toneR = `hg;     12'd113: toneR = `hg; // HG (one-beat)
                    // 12'd114: toneR = `hg;     12'd115: toneR = `hg;
                    // 12'd116: toneR = `hg;     12'd117: toneR = `hg;
                    // 12'd118: toneR = `hg;     12'd119: toneR = `hg;
                    // 12'd120: toneR = `hg;     12'd121: toneR = `hg;
                    // 12'd122: toneR = `hg;     12'd123: toneR = `hg;
                    // 12'd124: toneR = `hg;     12'd125: toneR = `hg;
                    // 12'd126: toneR = `hg;     12'd127: toneR = `hg;

                     15'd0: toneR = `ha;     15'd1: toneR = `ha;
                     15'd2: toneR = `ha;     15'd3: toneR = `ha;
                     15'd4: toneR = `ha;     15'd5: toneR = `ha;
                     15'd6: toneR = `ha;     15'd7: toneR = `ha;
                     15'd8: toneR = `rhf;     15'd9: toneR = `rhf;
                     15'd10: toneR = `rhf;     15'd11: toneR = `rhf;
                     15'd12: toneR = `hg;     15'd13: toneR = `hg;
                     15'd14: toneR = `hg;     15'd15: toneR = `hg;
                     15'd16: toneR = `ha;     15'd17: toneR = `ha;
                     15'd18: toneR = `ha;     15'd19: toneR = `ha;
                     15'd20: toneR = `ha;     15'd21: toneR = `ha;
                     15'd22: toneR = `ha;     15'd23: toneR = `ha;
                     15'd24: toneR = `rhf;     15'd25: toneR = `rhf;
                     15'd26: toneR = `rhf;     15'd27: toneR = `rhf;
                     15'd28: toneR = `hg;     15'd29: toneR = `hg;
                     15'd30: toneR = `hg;     15'd31: toneR = `hg;
                     15'd32: toneR = `ha;     15'd33: toneR = `ha;
                     15'd34: toneR = `ha;     15'd35: toneR = `ha;
                     15'd36: toneR = `a;     15'd37: toneR = `a;
                     15'd38: toneR = `a;     15'd39: toneR = `a;
                     15'd40: toneR = `b;     15'd41: toneR = `b;
                     15'd42: toneR = `b;     15'd43: toneR = `b;
                     15'd44: toneR = `rhc;     15'd45: toneR = `rhc;
                     15'd46: toneR = `rhc;     15'd47: toneR = `rhc;
                     15'd48: toneR = `hd;     15'd49: toneR = `hd;
                     15'd50: toneR = `hd;     15'd51: toneR = `hd;
                     15'd52: toneR = `he;     15'd53: toneR = `he;
                     15'd54: toneR = `he;     15'd55: toneR = `he;
                     15'd56: toneR = `rhf;     15'd57: toneR = `rhf;
                     15'd58: toneR = `rhf;     15'd59: toneR = `rhf;
                     15'd60: toneR = `hg;     15'd61: toneR = `hg;
                     15'd62: toneR = `hg;     15'd63: toneR = `hg;
                     15'd64: toneR = `rhf;     15'd65: toneR = `rhf;
                     15'd66: toneR = `rhf;     15'd67: toneR = `rhf;
                     15'd68: toneR = `rhf;     15'd69: toneR = `rhf;
                     15'd70: toneR = `rhf;     15'd71: toneR = `rhf;
                     15'd72: toneR = `hd;     15'd73: toneR = `hd;
                     15'd74: toneR = `hd;     15'd75: toneR = `hd;
                     15'd76: toneR = `he;     15'd77: toneR = `he;
                     15'd78: toneR = `he;     15'd79: toneR = `he;
                     15'd80: toneR = `rhf;     15'd81: toneR = `rhf;
                     15'd82: toneR = `rhf;     15'd83: toneR = `rhf;
                     15'd84: toneR = `rhf;     15'd85: toneR = `rhf;
                     15'd86: toneR = `rhf;     15'd87: toneR = `rhf;
                     15'd88: toneR = `rf;     15'd89: toneR = `rf;
                     15'd90: toneR = `rf;     15'd91: toneR = `rf;
                     15'd92: toneR = `g;     15'd93: toneR = `g;
                     15'd94: toneR = `g;     15'd95: toneR = `g;
                     15'd96: toneR = `a;     15'd97: toneR = `a;
                     15'd98: toneR = `a;     15'd99: toneR = `a;
                     15'd100: toneR = `b;     15'd101: toneR = `b;
                     15'd102: toneR = `b;     15'd103: toneR = `b;
                     15'd104: toneR = `a;     15'd105: toneR = `a;
                     15'd106: toneR = `a;     15'd107: toneR = `a;
                     15'd108: toneR = `g;     15'd109: toneR = `g;
                     15'd110: toneR = `g;     15'd111: toneR = `g;
                     15'd112: toneR = `a;     15'd113: toneR = `a;
                     15'd114: toneR = `a;     15'd115: toneR = `a;
                     15'd116: toneR = `rf;     15'd117: toneR = `rf;
                     15'd118: toneR = `rf;     15'd119: toneR = `rf;
                     15'd120: toneR = `g;     15'd121: toneR = `g;
                     15'd122: toneR = `g;     15'd123: toneR = `g;
                     15'd124: toneR = `a;     15'd125: toneR = `a;
                     15'd126: toneR = `a;     15'd127: toneR = `a;
                     15'd128: toneR = `g;     15'd129: toneR = `g;
                     15'd130: toneR = `g;     15'd131: toneR = `g;
                     15'd132: toneR = `g;     15'd133: toneR = `g;
                     15'd134: toneR = `g;     15'd135: toneR = `g;
                     15'd136: toneR = `b;     15'd137: toneR = `b;
                     15'd138: toneR = `b;     15'd139: toneR = `b;
                     15'd140: toneR = `a;     15'd141: toneR = `a;
                     15'd142: toneR = `a;     15'd143: toneR = `a;
                     15'd144: toneR = `g;     15'd145: toneR = `g;
                     15'd146: toneR = `g;     15'd147: toneR = `g;
                     15'd148: toneR = `g;     15'd149: toneR = `g;
                     15'd150: toneR = `g;     15'd151: toneR = `g;
                     15'd152: toneR = `rf;     15'd153: toneR = `rf;
                     15'd154: toneR = `rf;     15'd155: toneR = `rf;
                     15'd156: toneR = `e;     15'd157: toneR = `e;
                     15'd158: toneR = `e;     15'd159: toneR = `e;
                     15'd160: toneR = `rf;     15'd161: toneR = `rf;
                     15'd162: toneR = `rf;     15'd163: toneR = `rf;
                     15'd164: toneR = `e;     15'd165: toneR = `e;
                     15'd166: toneR = `e;     15'd167: toneR = `e;
                     15'd168: toneR = `d;     15'd169: toneR = `d;
                     15'd170: toneR = `d;     15'd171: toneR = `d;
                     15'd172: toneR = `e;     15'd173: toneR = `e;
                     15'd174: toneR = `e;     15'd175: toneR = `e;
                     15'd176: toneR = `rf;     15'd177: toneR = `rf;
                     15'd178: toneR = `rf;     15'd179: toneR = `rf;
                     15'd180: toneR = `g;     15'd181: toneR = `g;
                     15'd182: toneR = `g;     15'd183: toneR = `g;
                     15'd184: toneR = `a;     15'd185: toneR = `a;
                     15'd186: toneR = `a;     15'd187: toneR = `a;
                     15'd188: toneR = `b;     15'd189: toneR = `b;
                     15'd190: toneR = `b;     15'd191: toneR = `b;
                     15'd192: toneR = `g;     15'd193: toneR = `g;
                     15'd194: toneR = `g;     15'd195: toneR = `g;
                     15'd196: toneR = `g;     15'd197: toneR = `g;
                     15'd198: toneR = `g;     15'd199: toneR = `g;
                     15'd200: toneR = `b;     15'd201: toneR = `b;
                     15'd202: toneR = `b;     15'd203: toneR = `b;
                     15'd204: toneR = `a;     15'd205: toneR = `a;
                     15'd206: toneR = `a;     15'd207: toneR = `a;
                     15'd208: toneR = `b;     15'd209: toneR = `b;
                     15'd210: toneR = `b;     15'd211: toneR = `b;
                     15'd212: toneR = `b;     15'd213: toneR = `b;
                     15'd214: toneR = `b;     15'd215: toneR = `b;
                     15'd216: toneR = `rhc;     15'd217: toneR = `rhc;
                     15'd218: toneR = `rhc;     15'd219: toneR = `rhc;
                     15'd220: toneR = `hd;     15'd221: toneR = `hd;
                     15'd222: toneR = `hd;     15'd223: toneR = `hd;
                     15'd224: toneR = `a;     15'd225: toneR = `a;
                     15'd226: toneR = `a;     15'd227: toneR = `a;
                     15'd228: toneR = `b;     15'd229: toneR = `b;
                     15'd230: toneR = `b;     15'd231: toneR = `b;
                     15'd232: toneR = `rhc;     15'd233: toneR = `rhc;
                     15'd234: toneR = `rhc;     15'd235: toneR = `rhc;
                     15'd236: toneR = `hd;     15'd237: toneR = `hd;
                     15'd238: toneR = `hd;     15'd239: toneR = `hd;
                     15'd240: toneR = `he;     15'd241: toneR = `he;
                     15'd242: toneR = `he;     15'd243: toneR = `he;
                     15'd244: toneR = `rhf;     15'd245: toneR = `rhf;
                     15'd246: toneR = `rhf;     15'd247: toneR = `rhf;
                     15'd248: toneR = `hg;     15'd249: toneR = `hg;
                     15'd250: toneR = `hg;     15'd251: toneR = `hg;
                     15'd252: toneR = `ha;     15'd253: toneR = `ha;
                     15'd254: toneR = `ha;     15'd255: toneR = `ha;
                     15'd256: toneR = `rhf;     15'd257: toneR = `rhf;
                     15'd258: toneR = `rhf;     15'd259: toneR = `rhf;
                     15'd260: toneR = `rhf;     15'd261: toneR = `rhf;
                     15'd262: toneR = `rhf;     15'd263: toneR = `rhf;
                     15'd264: toneR = `hd;     15'd265: toneR = `hd;
                     15'd266: toneR = `hd;     15'd267: toneR = `hd;
                     15'd268: toneR = `he;     15'd269: toneR = `he;
                     15'd270: toneR = `he;     15'd271: toneR = `he;
                     15'd272: toneR = `rhf;     15'd273: toneR = `rhf;
                     15'd274: toneR = `rhf;     15'd275: toneR = `rhf;
                     15'd276: toneR = `rhf;     15'd277: toneR = `rhf;
                     15'd278: toneR = `rhf;     15'd279: toneR = `rhf;
                     15'd280: toneR = `he;     15'd281: toneR = `he;
                     15'd282: toneR = `he;     15'd283: toneR = `he;
                     15'd284: toneR = `hd;     15'd285: toneR = `hd;
                     15'd286: toneR = `hd;     15'd287: toneR = `hd;
                     15'd288: toneR = `he;     15'd289: toneR = `he;
                     15'd290: toneR = `he;     15'd291: toneR = `he;
                     15'd292: toneR = `rhc;     15'd293: toneR = `rhc;
                     15'd294: toneR = `rhc;     15'd295: toneR = `rhc;
                     15'd296: toneR = `hd;     15'd297: toneR = `hd;
                     15'd298: toneR = `hd;     15'd299: toneR = `hd;
                     15'd300: toneR = `he;     15'd301: toneR = `he;
                     15'd302: toneR = `he;     15'd303: toneR = `he;
                     15'd304: toneR = `rhf;     15'd305: toneR = `rhf;
                     15'd306: toneR = `rhf;     15'd307: toneR = `rhf;
                     15'd308: toneR = `he;     15'd309: toneR = `he;
                     15'd310: toneR = `he;     15'd311: toneR = `he;
                     15'd312: toneR = `hd;     15'd313: toneR = `hd;
                     15'd314: toneR = `hd;     15'd315: toneR = `hd;
                     15'd316: toneR = `rhc;     15'd317: toneR = `rhc;
                     15'd318: toneR = `rhc;     15'd319: toneR = `rhc;

//                    15'd0: toneR = `e;     15'd1: toneR = `e;
//15'd2: toneR = `e;     15'd3: toneR = `e;
//15'd4: toneR = `f;     15'd5: toneR = `f;
//15'd6: toneR = `f;     15'd7: toneR = `f;
//15'd8: toneR = `g;     15'd9: toneR = `g;
//15'd10: toneR = `g;     15'd11: toneR = `g;
//15'd12: toneR = `g;     15'd13: toneR = `g;
//15'd14: toneR = `g;     15'd15: toneR = `g;
//15'd16: toneR = `g;     15'd17: toneR = `g;
//15'd18: toneR = `g;     15'd19: toneR = `g;
//15'd20: toneR = `g;     15'd21: toneR = `g;
//15'd22: toneR = `g;     15'd23: toneR = `g;
//15'd24: toneR = `sil;     15'd25: toneR = `g;
//15'd26: toneR = `g;     15'd27: toneR = `g;
//15'd28: toneR = `g;     15'd29: toneR = `g;
//15'd30: toneR = `g;     15'd31: toneR = `g;
//15'd32: toneR = `g;     15'd33: toneR = `g;
//15'd34: toneR = `g;     15'd35: toneR = `g;
//15'd36: toneR = `g;     15'd37: toneR = `g;
//15'd38: toneR = `g;     15'd39: toneR = `g;
//15'd40: toneR = `f;     15'd41: toneR = `f;
//15'd42: toneR = `f;     15'd43: toneR = `f;
//15'd44: toneR = `f;     15'd45: toneR = `f;
//15'd46: toneR = `f;     15'd47: toneR = `f;
//15'd48: toneR = `e;     15'd49: toneR = `e;
//15'd50: toneR = `e;     15'd51: toneR = `e;
//15'd52: toneR = `e;     15'd53: toneR = `e;
//15'd54: toneR = `e;     15'd55: toneR = `e;
//15'd56: toneR = `d;     15'd57: toneR = `d;
//15'd58: toneR = `d;     15'd59: toneR = `d;
//15'd60: toneR = `d;     15'd61: toneR = `d;
//15'd62: toneR = `d;     15'd63: toneR = `d;
//15'd64: toneR = `c;     15'd65: toneR = `c;
//15'd66: toneR = `c;     15'd67: toneR = `c;
//15'd68: toneR = `c;     15'd69: toneR = `c;
//15'd70: toneR = `c;     15'd71: toneR = `c;
//15'd72: toneR = `db;     15'd73: toneR = `db;
//15'd74: toneR = `db;     15'd75: toneR = `db;
//15'd76: toneR = `db;     15'd77: toneR = `db;
//15'd78: toneR = `db;     15'd79: toneR = `db;
//15'd80: toneR = `g;     15'd81: toneR = `g;
//15'd82: toneR = `g;     15'd83: toneR = `g;
//15'd84: toneR = `g;     15'd85: toneR = `g;
//15'd86: toneR = `g;     15'd87: toneR = `g;
//15'd88: toneR = `g;     15'd89: toneR = `g;
//15'd90: toneR = `g;     15'd91: toneR = `g;
//15'd92: toneR = `g;     15'd93: toneR = `g;
//15'd94: toneR = `g;     15'd95: toneR = `g;
//15'd96: toneR = `e;     15'd97: toneR = `e;
//15'd98: toneR = `e;     15'd99: toneR = `e;
//15'd100: toneR = `e;     15'd101: toneR = `e;
//15'd102: toneR = `e;     15'd103: toneR = `e;
//15'd104: toneR = `e;     15'd105: toneR = `e;
//15'd106: toneR = `e;     15'd107: toneR = `e;
//15'd108: toneR = `e;     15'd109: toneR = `e;
//15'd110: toneR = `e;     15'd111: toneR = `e;
//15'd112: toneR = `e;     15'd113: toneR = `e;
//15'd114: toneR = `e;     15'd115: toneR = `e;
//15'd116: toneR = `e;     15'd117: toneR = `e;
//15'd118: toneR = `e;     15'd119: toneR = `e;
//15'd120: toneR = `e;     15'd121: toneR = `e;
//15'd122: toneR = `e;     15'd123: toneR = `e;
//15'd124: toneR = `e;     15'd125: toneR = `e;
//15'd126: toneR = `e;     15'd127: toneR = `e;
//15'd128: toneR = `e;     15'd129: toneR = `e;
//15'd130: toneR = `e;     15'd131: toneR = `e;
//15'd132: toneR = `e;     15'd133: toneR = `e;
//15'd134: toneR = `e;     15'd135: toneR = `e;
//15'd136: toneR = `c;     15'd137: toneR = `c;
//15'd138: toneR = `c;     15'd139: toneR = `c;
//15'd140: toneR = `c;     15'd141: toneR = `c;
//15'd142: toneR = `c;     15'd143: toneR = `c;
//15'd144: toneR = `c;     15'd145: toneR = `c;
//15'd146: toneR = `c;     15'd147: toneR = `c;
//15'd148: toneR = `c;     15'd149: toneR = `c;
//15'd150: toneR = `c;     15'd151: toneR = `c;
//15'd152: toneR = `g;     15'd153: toneR = `g;
//15'd154: toneR = `g;     15'd155: toneR = `g;
//15'd156: toneR = `g;     15'd157: toneR = `g;
//15'd158: toneR = `g;     15'd159: toneR = `g;
//15'd160: toneR = `g;     15'd161: toneR = `g;
//15'd162: toneR = `g;     15'd163: toneR = `g;
//15'd164: toneR = `g;     15'd165: toneR = `g;
//15'd166: toneR = `g;     15'd167: toneR = `g;
//15'd168: toneR = `f;     15'd169: toneR = `f;
//15'd170: toneR = `f;     15'd171: toneR = `f;
//15'd172: toneR = `f;     15'd173: toneR = `f;
//15'd174: toneR = `f;     15'd175: toneR = `f;
//15'd176: toneR = `e;     15'd177: toneR = `e;
//15'd178: toneR = `e;     15'd179: toneR = `e;
//15'd180: toneR = `e;     15'd181: toneR = `e;
//15'd182: toneR = `e;     15'd183: toneR = `e;
//15'd184: toneR = `d;     15'd185: toneR = `d;
//15'd186: toneR = `d;     15'd187: toneR = `d;
//15'd188: toneR = `d;     15'd189: toneR = `d;
//15'd190: toneR = `d;     15'd191: toneR = `d;
//15'd192: toneR = `c;     15'd193: toneR = `c;
//15'd194: toneR = `c;     15'd195: toneR = `c;
//15'd196: toneR = `c;     15'd197: toneR = `c;
//15'd198: toneR = `c;     15'd199: toneR = `c;
//15'd200: toneR = `d;     15'd201: toneR = `d;
//15'd202: toneR = `d;     15'd203: toneR = `d;
//15'd204: toneR = `d;     15'd205: toneR = `d;
//15'd206: toneR = `d;     15'd207: toneR = `d;
//15'd208: toneR = `d;     15'd209: toneR = `d;
//15'd210: toneR = `d;     15'd211: toneR = `d;
//15'd212: toneR = `d;     15'd213: toneR = `d;
//15'd214: toneR = `d;     15'd215: toneR = `d;
//15'd216: toneR = `d;     15'd217: toneR = `d;
//15'd218: toneR = `d;     15'd219: toneR = `d;
//15'd220: toneR = `d;     15'd221: toneR = `d;
//15'd222: toneR = `d;     15'd223: toneR = `d;
//15'd224: toneR = `c;     15'd225: toneR = `c;
//15'd226: toneR = `c;     15'd227: toneR = `c;
//15'd228: toneR = `c;     15'd229: toneR = `c;
//15'd230: toneR = `c;     15'd231: toneR = `c;
//15'd232: toneR = `sil;     15'd233: toneR = `c;
//15'd234: toneR = `c;     15'd235: toneR = `c;
//15'd236: toneR = `c;     15'd237: toneR = `c;
//15'd238: toneR = `c;     15'd239: toneR = `c;
//15'd240: toneR = `c;     15'd241: toneR = `c;
//15'd242: toneR = `c;     15'd243: toneR = `c;
//15'd244: toneR = `c;     15'd245: toneR = `c;
//15'd246: toneR = `c;     15'd247: toneR = `c;
//15'd248: toneR = `sil;     15'd249: toneR = `sil;
//15'd250: toneR = `sil;     15'd251: toneR = `sil;
//15'd252: toneR = `sil;     15'd253: toneR = `sil;
//15'd254: toneR = `sil;     15'd255: toneR = `sil;
//15'd256: toneR = `e;     15'd257: toneR = `e;
//15'd258: toneR = `e;     15'd259: toneR = `e;
//15'd260: toneR = `f;     15'd261: toneR = `f;
//15'd262: toneR = `f;     15'd263: toneR = `f;
//15'd264: toneR = `g;     15'd265: toneR = `g;
//15'd266: toneR = `g;     15'd267: toneR = `g;
//15'd268: toneR = `g;     15'd269: toneR = `g;
//15'd270: toneR = `g;     15'd271: toneR = `g;
//15'd272: toneR = `sil;     15'd273: toneR = `g;
//15'd274: toneR = `g;     15'd275: toneR = `g;
//15'd276: toneR = `g;     15'd277: toneR = `g;
//15'd278: toneR = `g;     15'd279: toneR = `g;
//15'd280: toneR = `sil;     15'd281: toneR = `g;
//15'd282: toneR = `g;     15'd283: toneR = `g;
//15'd284: toneR = `g;     15'd285: toneR = `g;
//15'd286: toneR = `a;     15'd287: toneR = `a;
//15'd288: toneR = `a;     15'd289: toneR = `a;
//15'd290: toneR = `a;     15'd291: toneR = `a;
//15'd292: toneR = `a;     15'd293: toneR = `a;
//15'd294: toneR = `a;     15'd295: toneR = `a;
//15'd296: toneR = `g;     15'd297: toneR = `g;
//15'd298: toneR = `g;     15'd299: toneR = `g;
//15'd300: toneR = `g;     15'd301: toneR = `g;
//15'd302: toneR = `g;     15'd303: toneR = `g;
//15'd304: toneR = `g;     15'd305: toneR = `g;
//15'd306: toneR = `g;     15'd307: toneR = `g;
//15'd308: toneR = `g;     15'd309: toneR = `g;
//15'd310: toneR = `g;     15'd311: toneR = `g;
//15'd312: toneR = `g;     15'd313: toneR = `g;
//15'd314: toneR = `g;     15'd315: toneR = `g;
//15'd316: toneR = `g;     15'd317: toneR = `g;
//15'd318: toneR = `g;     15'd319: toneR = `g;
//15'd320: toneR = `e;     15'd321: toneR = `e;
//15'd322: toneR = `e;     15'd323: toneR = `e;
//15'd324: toneR = `f;     15'd325: toneR = `f;
//15'd326: toneR = `f;     15'd327: toneR = `f;
//15'd328: toneR = `g;     15'd329: toneR = `g;
//15'd330: toneR = `g;     15'd331: toneR = `g;
//15'd332: toneR = `g;     15'd333: toneR = `g;
//15'd334: toneR = `g;     15'd335: toneR = `g;
//15'd336: toneR = `sil;     15'd337: toneR = `g;
//15'd338: toneR = `g;     15'd339: toneR = `g;
//15'd340: toneR = `g;     15'd341: toneR = `g;
//15'd342: toneR = `g;     15'd343: toneR = `g;
//15'd344: toneR = `sil;     15'd345: toneR = `g;
//15'd346: toneR = `g;     15'd347: toneR = `g;
//15'd348: toneR = `g;     15'd349: toneR = `g;
//15'd350: toneR = `g;     15'd351: toneR = `g;
//15'd352: toneR = `d;     15'd353: toneR = `d;
//15'd354: toneR = `d;     15'd355: toneR = `d;
//15'd356: toneR = `d;     15'd357: toneR = `d;
//15'd358: toneR = `d;     15'd359: toneR = `d;
//15'd360: toneR = `e;     15'd361: toneR = `e;
//15'd362: toneR = `e;     15'd363: toneR = `e;
//15'd364: toneR = `e;     15'd365: toneR = `e;
//15'd366: toneR = `e;     15'd367: toneR = `e;
//15'd368: toneR = `e;     15'd369: toneR = `e;
//15'd370: toneR = `e;     15'd371: toneR = `e;
//15'd372: toneR = `e;     15'd373: toneR = `e;
//15'd374: toneR = `e;     15'd375: toneR = `e;
//15'd376: toneR = `e;     15'd377: toneR = `e;
//15'd378: toneR = `e;     15'd379: toneR = `e;
//15'd380: toneR = `e;     15'd381: toneR = `e;
//15'd382: toneR = `e;     15'd383: toneR = `e;
//15'd384: toneR = `sil;     15'd385: toneR = `e;
//15'd386: toneR = `e;     15'd387: toneR = `e;
//15'd388: toneR = `f;     15'd389: toneR = `f;
//15'd390: toneR = `f;     15'd391: toneR = `f;
//15'd392: toneR = `g;     15'd393: toneR = `g;
//15'd394: toneR = `g;     15'd395: toneR = `g;
//15'd396: toneR = `g;     15'd397: toneR = `g;
//15'd398: toneR = `g;     15'd399: toneR = `g;
//15'd400: toneR = `sil;     15'd401: toneR = `g;
//15'd402: toneR = `g;     15'd403: toneR = `g;
//15'd404: toneR = `sil;     15'd405: toneR = `g;
//15'd406: toneR = `g;     15'd407: toneR = `g;
//15'd408: toneR = `g;     15'd409: toneR = `g;
//15'd410: toneR = `g;     15'd411: toneR = `g;
//15'd412: toneR = `g;     15'd413: toneR = `g;
//15'd414: toneR = `sil;     15'd415: toneR = `g;
//15'd416: toneR = `g;     15'd417: toneR = `g;
//15'd418: toneR = `g;     15'd419: toneR = `g;
//15'd420: toneR = `g;     15'd421: toneR = `g;
//15'd422: toneR = `sil;     15'd423: toneR = `sil;
//15'd424: toneR = `a;     15'd425: toneR = `a;
//15'd426: toneR = `a;     15'd427: toneR = `a;
//15'd428: toneR = `a;     15'd429: toneR = `a;
//15'd430: toneR = `a;     15'd431: toneR = `a;
//15'd432: toneR = `g;     15'd433: toneR = `g;
//15'd434: toneR = `g;     15'd435: toneR = `g;
//15'd436: toneR = `g;     15'd437: toneR = `g;
//15'd438: toneR = `g;     15'd439: toneR = `g;
//15'd440: toneR = `f;     15'd441: toneR = `f;
//15'd442: toneR = `f;     15'd443: toneR = `f;
//15'd444: toneR = `f;     15'd445: toneR = `f;
//15'd446: toneR = `f;     15'd447: toneR = `f;
//15'd448: toneR = `e;     15'd449: toneR = `e;
//15'd450: toneR = `e;     15'd451: toneR = `e;
//15'd452: toneR = `e;     15'd453: toneR = `e;
//15'd454: toneR = `e;     15'd455: toneR = `e;
//15'd456: toneR = `d;     15'd457: toneR = `d;
//15'd458: toneR = `d;     15'd459: toneR = `d;
//15'd460: toneR = `d;     15'd461: toneR = `d;
//15'd462: toneR = `d;     15'd463: toneR = `d;
//15'd464: toneR = `d;     15'd465: toneR = `d;
//15'd466: toneR = `d;     15'd467: toneR = `d;
//15'd468: toneR = `d;     15'd469: toneR = `d;
//15'd470: toneR = `d;     15'd471: toneR = `d;
//15'd472: toneR = `e;     15'd473: toneR = `e;
//15'd474: toneR = `e;     15'd475: toneR = `e;
//15'd476: toneR = `e;     15'd477: toneR = `e;
//15'd478: toneR = `e;     15'd479: toneR = `e;
//15'd480: toneR = `e;     15'd481: toneR = `e;
//15'd482: toneR = `e;     15'd483: toneR = `e;
//15'd484: toneR = `e;     15'd485: toneR = `e;
//15'd486: toneR = `e;     15'd487: toneR = `e;
//15'd488: toneR = `sil;     15'd489: toneR = `e;
//15'd490: toneR = `e;     15'd491: toneR = `e;
//15'd492: toneR = `e;     15'd493: toneR = `e;
//15'd494: toneR = `e;     15'd495: toneR = `e;
//15'd496: toneR = `e;     15'd497: toneR = `e;
//15'd498: toneR = `e;     15'd499: toneR = `e;
//15'd500: toneR = `e;     15'd501: toneR = `e;
//15'd502: toneR = `e;     15'd503: toneR = `e;
//15'd504: toneR = `hc;     15'd505: toneR = `hc;
//15'd506: toneR = `hc;     15'd507: toneR = `hc;
//15'd508: toneR = `hc;     15'd509: toneR = `hc;
//15'd510: toneR = `hc;     15'd511: toneR = `hc;
//15'd512: toneR = `b;     15'd513: toneR = `b;
//15'd514: toneR = `b;     15'd515: toneR = `b;
//15'd516: toneR = `b;     15'd517: toneR = `b;
//15'd518: toneR = `b;     15'd519: toneR = `b;
//15'd520: toneR = `a;     15'd521: toneR = `a;
//15'd522: toneR = `a;     15'd523: toneR = `a;
//15'd524: toneR = `a;     15'd525: toneR = `a;
//15'd526: toneR = `a;     15'd527: toneR = `a;
//15'd528: toneR = `g;     15'd529: toneR = `g;
//15'd530: toneR = `g;     15'd531: toneR = `g;
//15'd532: toneR = `g;     15'd533: toneR = `g;
//15'd534: toneR = `g;     15'd535: toneR = `g;
//15'd536: toneR = `e;     15'd537: toneR = `e;
//15'd538: toneR = `e;     15'd539: toneR = `e;
//15'd540: toneR = `e;     15'd541: toneR = `e;
//15'd542: toneR = `e;     15'd543: toneR = `e;
//15'd544: toneR = `d;     15'd545: toneR = `d;
//15'd546: toneR = `d;     15'd547: toneR = `d;
//15'd548: toneR = `sil;     15'd549: toneR = `d;
//15'd550: toneR = `d;     15'd551: toneR = `d;
//15'd552: toneR = `d;     15'd553: toneR = `d;
//15'd554: toneR = `d;     15'd555: toneR = `d;
//15'd556: toneR = `d;     15'd557: toneR = `d;
//15'd558: toneR = `d;     15'd559: toneR = `d;
//15'd560: toneR = `c;     15'd561: toneR = `c;
//15'd562: toneR = `c;     15'd563: toneR = `c;
//15'd564: toneR = `c;     15'd565: toneR = `c;
//15'd566: toneR = `c;     15'd567: toneR = `c;
//15'd568: toneR = `da;     15'd569: toneR = `da;
//15'd570: toneR = `da;     15'd571: toneR = `da;
//15'd572: toneR = `da;     15'd573: toneR = `da;
//15'd574: toneR = `da;     15'd575: toneR = `da;
//15'd576: toneR = `db;     15'd577: toneR = `db;
//15'd578: toneR = `db;     15'd579: toneR = `db;
//15'd580: toneR = `c;     15'd581: toneR = `c;
//15'd582: toneR = `c;     15'd583: toneR = `c;
//15'd584: toneR = `c;     15'd585: toneR = `c;
//15'd586: toneR = `c;     15'd587: toneR = `c;
//15'd588: toneR = `c;     15'd589: toneR = `c;
//15'd590: toneR = `c;     15'd591: toneR = `c;
//15'd592: toneR = `c;     15'd593: toneR = `c;
//15'd594: toneR = `c;     15'd595: toneR = `c;
//15'd596: toneR = `c;     15'd597: toneR = `c;
//15'd598: toneR = `c;     15'd599: toneR = `c;
//15'd600: toneR = `sil;     15'd601: toneR = `sil;
//15'd602: toneR = `sil;     15'd603: toneR = `sil;
//15'd604: toneR = `sil;     15'd605: toneR = `sil;
//15'd606: toneR = `sil;     15'd607: toneR = `sil;
//15'd608: toneR = `sil;     15'd609: toneR = `sil;
//15'd610: toneR = `sil;     15'd611: toneR = `sil;
//15'd612: toneR = `sil;     15'd613: toneR = `sil;
//15'd614: toneR = `sil;     15'd615: toneR = `sil;
//15'd616: toneR = `sil;     15'd617: toneR = `sil;
//15'd618: toneR = `sil;     15'd619: toneR = `sil;
//15'd620: toneR = `sil;     15'd621: toneR = `sil;
//15'd622: toneR = `sil;     15'd623: toneR = `sil;
//15'd624: toneR = `sil;     15'd625: toneR = `sil;
//15'd626: toneR = `sil;     15'd627: toneR = `sil;
//15'd628: toneR = `sil;     15'd629: toneR = `sil;
//15'd630: toneR = `sil;     15'd631: toneR = `sil;
//15'd632: toneR = `sil;     15'd633: toneR = `sil;
//15'd634: toneR = `sil;     15'd635: toneR = `sil;
//15'd636: toneR = `sil;     15'd637: toneR = `sil;
//15'd638: toneR = `sil;     15'd639: toneR = `sil;
//15'd640: toneR = `sil;     15'd641: toneR = `sil;
//15'd642: toneR = `sil;     15'd643: toneR = `sil;
//15'd644: toneR = `sil;     15'd645: toneR = `sil;
//15'd646: toneR = `sil;     15'd647: toneR = `sil;
//15'd648: toneR = `sil;     15'd649: toneR = `sil;
//15'd650: toneR = `sil;     15'd651: toneR = `sil;
//15'd652: toneR = `sil;     15'd653: toneR = `sil;
//15'd654: toneR = `sil;     15'd655: toneR = `sil;
//15'd656: toneR = `sil;     15'd657: toneR = `sil;
//15'd658: toneR = `sil;     15'd659: toneR = `sil;
//15'd660: toneR = `sil;     15'd661: toneR = `sil;
//15'd662: toneR = `sil;     15'd663: toneR = `sil;
//15'd664: toneR = `sil;     15'd665: toneR = `sil;
//15'd666: toneR = `sil;     15'd667: toneR = `sil;
//15'd668: toneR = `sil;     15'd669: toneR = `sil;
//15'd670: toneR = `sil;     15'd671: toneR = `sil;
//15'd672: toneR = `sil;     15'd673: toneR = `sil;
//15'd674: toneR = `sil;     15'd675: toneR = `sil;
//15'd676: toneR = `sil;     15'd677: toneR = `sil;
//15'd678: toneR = `sil;     15'd679: toneR = `sil;
//15'd680: toneR = `sil;     15'd681: toneR = `sil;
//15'd682: toneR = `sil;     15'd683: toneR = `sil;
//15'd684: toneR = `sil;     15'd685: toneR = `sil;
//15'd686: toneR = `sil;     15'd687: toneR = `sil;
//15'd688: toneR = `sil;     15'd689: toneR = `sil;
//15'd690: toneR = `sil;     15'd691: toneR = `sil;
//15'd692: toneR = `sil;     15'd693: toneR = `sil;
//15'd694: toneR = `sil;     15'd695: toneR = `sil;
//15'd696: toneR = `sil;     15'd697: toneR = `sil;
//15'd698: toneR = `sil;     15'd699: toneR = `sil;
//15'd700: toneR = `sil;     15'd701: toneR = `sil;
//15'd702: toneR = `sil;     15'd703: toneR = `sil;
//15'd704: toneR = `e;     15'd705: toneR = `e;
//15'd706: toneR = `e;     15'd707: toneR = `e;
//15'd708: toneR = `f;     15'd709: toneR = `f;
//15'd710: toneR = `f;     15'd711: toneR = `f;
//15'd712: toneR = `g;     15'd713: toneR = `g;
//15'd714: toneR = `g;     15'd715: toneR = `g;
//15'd716: toneR = `g;     15'd717: toneR = `g;
//15'd718: toneR = `g;     15'd719: toneR = `g;
//15'd720: toneR = `sil;     15'd721: toneR = `g;
//15'd722: toneR = `g;     15'd723: toneR = `g;
//15'd724: toneR = `g;     15'd725: toneR = `g;
//15'd726: toneR = `g;     15'd727: toneR = `g;
//15'd728: toneR = `sil;     15'd729: toneR = `g;
//15'd730: toneR = `g;     15'd731: toneR = `g;
//15'd732: toneR = `g;     15'd733: toneR = `g;
//15'd734: toneR = `a;     15'd735: toneR = `a;
//15'd736: toneR = `a;     15'd737: toneR = `a;
//15'd738: toneR = `a;     15'd739: toneR = `a;
//15'd740: toneR = `a;     15'd741: toneR = `a;
//15'd742: toneR = `a;     15'd743: toneR = `a;
//15'd744: toneR = `g;     15'd745: toneR = `g;
//15'd746: toneR = `g;     15'd747: toneR = `g;
//15'd748: toneR = `g;     15'd749: toneR = `g;
//15'd750: toneR = `g;     15'd751: toneR = `g;
//15'd752: toneR = `g;     15'd753: toneR = `g;
//15'd754: toneR = `g;     15'd755: toneR = `g;
//15'd756: toneR = `g;     15'd757: toneR = `g;
//15'd758: toneR = `g;     15'd759: toneR = `g;
//15'd760: toneR = `g;     15'd761: toneR = `g;
//15'd762: toneR = `g;     15'd763: toneR = `g;
//15'd764: toneR = `g;     15'd765: toneR = `g;
//15'd766: toneR = `g;     15'd767: toneR = `g;
//15'd768: toneR = `e;     15'd769: toneR = `e;
//15'd770: toneR = `e;     15'd771: toneR = `e;
//15'd772: toneR = `f;     15'd773: toneR = `f;
//15'd774: toneR = `f;     15'd775: toneR = `f;
//15'd776: toneR = `g;     15'd777: toneR = `g;
//15'd778: toneR = `g;     15'd779: toneR = `g;
//15'd780: toneR = `g;     15'd781: toneR = `g;
//15'd782: toneR = `g;     15'd783: toneR = `g;
//15'd784: toneR = `sil;     15'd785: toneR = `g;
//15'd786: toneR = `g;     15'd787: toneR = `g;
//15'd788: toneR = `g;     15'd789: toneR = `g;
//15'd790: toneR = `g;     15'd791: toneR = `g;
//15'd792: toneR = `sil;     15'd793: toneR = `g;
//15'd794: toneR = `g;     15'd795: toneR = `g;
//15'd796: toneR = `g;     15'd797: toneR = `g;
//15'd798: toneR = `g;     15'd799: toneR = `g;
//15'd800: toneR = `d;     15'd801: toneR = `d;
//15'd802: toneR = `d;     15'd803: toneR = `d;
//15'd804: toneR = `d;     15'd805: toneR = `d;
//15'd806: toneR = `d;     15'd807: toneR = `d;
//15'd808: toneR = `e;     15'd809: toneR = `e;
//15'd810: toneR = `e;     15'd811: toneR = `e;
//15'd812: toneR = `e;     15'd813: toneR = `e;
//15'd814: toneR = `e;     15'd815: toneR = `e;
//15'd816: toneR = `e;     15'd817: toneR = `e;
//15'd818: toneR = `e;     15'd819: toneR = `e;
//15'd820: toneR = `e;     15'd821: toneR = `e;
//15'd822: toneR = `e;     15'd823: toneR = `e;
//15'd824: toneR = `e;     15'd825: toneR = `e;
//15'd826: toneR = `e;     15'd827: toneR = `e;
//15'd828: toneR = `e;     15'd829: toneR = `e;
//15'd830: toneR = `e;     15'd831: toneR = `e;
//15'd832: toneR = `sil;     15'd833: toneR = `e;
//15'd834: toneR = `e;     15'd835: toneR = `e;
//15'd836: toneR = `f;     15'd837: toneR = `f;
//15'd838: toneR = `f;     15'd839: toneR = `f;
//15'd840: toneR = `g;     15'd841: toneR = `g;
//15'd842: toneR = `g;     15'd843: toneR = `g;
//15'd844: toneR = `g;     15'd845: toneR = `g;
//15'd846: toneR = `g;     15'd847: toneR = `g;
//15'd848: toneR = `sil;     15'd849: toneR = `g;
//15'd850: toneR = `g;     15'd851: toneR = `g;
//15'd852: toneR = `sil;     15'd853: toneR = `g;
//15'd854: toneR = `g;     15'd855: toneR = `g;
//15'd856: toneR = `g;     15'd857: toneR = `g;
//15'd858: toneR = `g;     15'd859: toneR = `g;
//15'd860: toneR = `sil;     15'd861: toneR = `g;
//15'd862: toneR = `g;     15'd863: toneR = `g;
//15'd864: toneR = `g;     15'd865: toneR = `g;
//15'd866: toneR = `g;     15'd867: toneR = `g;
//15'd868: toneR = `g;     15'd869: toneR = `g;
//15'd870: toneR = `g;     15'd871: toneR = `g;
//15'd872: toneR = `a;     15'd873: toneR = `a;
//15'd874: toneR = `a;     15'd875: toneR = `a;
//15'd876: toneR = `a;     15'd877: toneR = `a;
//15'd878: toneR = `a;     15'd879: toneR = `a;
//15'd880: toneR = `g;     15'd881: toneR = `g;
//15'd882: toneR = `g;     15'd883: toneR = `g;
//15'd884: toneR = `g;     15'd885: toneR = `g;
//15'd886: toneR = `g;     15'd887: toneR = `g;
//15'd888: toneR = `f;     15'd889: toneR = `f;
//15'd890: toneR = `f;     15'd891: toneR = `f;
//15'd892: toneR = `f;     15'd893: toneR = `f;
//15'd894: toneR = `f;     15'd895: toneR = `f;
//15'd896: toneR = `e;     15'd897: toneR = `e;
//15'd898: toneR = `e;     15'd899: toneR = `e;
//15'd900: toneR = `e;     15'd901: toneR = `e;
//15'd902: toneR = `e;     15'd903: toneR = `e;
//15'd904: toneR = `d;     15'd905: toneR = `d;
//15'd906: toneR = `d;     15'd907: toneR = `d;
//15'd908: toneR = `d;     15'd909: toneR = `d;
//15'd910: toneR = `d;     15'd911: toneR = `d;
//15'd912: toneR = `d;     15'd913: toneR = `d;
//15'd914: toneR = `d;     15'd915: toneR = `d;
//15'd916: toneR = `d;     15'd917: toneR = `d;
//15'd918: toneR = `d;     15'd919: toneR = `d;
                    default: toneR = `sil;
                endcase
            end
            else begin
                case(ibeatNum)
                    15'd0: toneR = `hc;     15'd1: toneR = `hc;
                    15'd2: toneR = `hc;     15'd3: toneR = `hc;
                    15'd4: toneR = `hc;     15'd5: toneR = `hc;
                    15'd6: toneR = `hc;     15'd7: toneR = `hc;
                    15'd8: toneR = `hc;     15'd9: toneR = `hc;
                    15'd10: toneR = `hc;     15'd11: toneR = `hc;
                    15'd12: toneR = `hc;     15'd13: toneR = `hc;
                    15'd14: toneR = `hc;     15'd15: toneR = `hc;
                    15'd16: toneR = `hd;     15'd17: toneR = `hd;
                    15'd18: toneR = `hd;     15'd19: toneR = `hd;
                    15'd20: toneR = `hd;     15'd21: toneR = `hd;
                    15'd22: toneR = `hd;     15'd23: toneR = `hd;
                    15'd24: toneR = `hd;     15'd25: toneR = `hd;
                    15'd26: toneR = `hd;     15'd27: toneR = `hd;
                    15'd28: toneR = `hd;     15'd29: toneR = `hd;
                    15'd30: toneR = `hd;     15'd31: toneR = `hd;
                    15'd32: toneR = `he;     15'd33: toneR = `he;
                    15'd34: toneR = `he;     15'd35: toneR = `he;
                    15'd36: toneR = `he;     15'd37: toneR = `he;
                    15'd38: toneR = `he;     15'd39: toneR = `he;
                    15'd40: toneR = `he;     15'd41: toneR = `he;
                    15'd42: toneR = `he;     15'd43: toneR = `he;
                    15'd44: toneR = `he;     15'd45: toneR = `he;
                    15'd46: toneR = `he;     15'd47: toneR = `he;
                    15'd48: toneR = `hc;     15'd49: toneR = `hc;
                    15'd50: toneR = `hc;     15'd51: toneR = `hc;
                    15'd52: toneR = `hc;     15'd53: toneR = `hc;
                    15'd54: toneR = `hc;     15'd55: toneR = `hc;
                    15'd56: toneR = `hc;     15'd57: toneR = `hc;
                    15'd58: toneR = `hc;     15'd59: toneR = `hc;
                    15'd60: toneR = `hc;     15'd61: toneR = `hc;
                    15'd62: toneR = `hc;     15'd63: toneR = `hc;
                    15'd64: toneR = `hc;     15'd65: toneR = `hc;
                    15'd66: toneR = `hc;     15'd67: toneR = `hc;
                    15'd68: toneR = `hc;     15'd69: toneR = `hc;
                    15'd70: toneR = `hc;     15'd71: toneR = `hc;
                    15'd72: toneR = `hc;     15'd73: toneR = `hc;
                    15'd74: toneR = `hc;     15'd75: toneR = `hc;
                    15'd76: toneR = `hc;     15'd77: toneR = `hc;
                    15'd78: toneR = `hc;     15'd79: toneR = `hc;
                    15'd80: toneR = `hd;     15'd81: toneR = `hd;
                    15'd82: toneR = `hd;     15'd83: toneR = `hd;
                    15'd84: toneR = `hd;     15'd85: toneR = `hd;
                    15'd86: toneR = `hd;     15'd87: toneR = `hd;
                    15'd88: toneR = `hd;     15'd89: toneR = `hd;
                    15'd90: toneR = `hd;     15'd91: toneR = `hd;
                    15'd92: toneR = `hd;     15'd93: toneR = `hd;
                    15'd94: toneR = `hd;     15'd95: toneR = `hd;
                    15'd96: toneR = `he;     15'd97: toneR = `he;
                    15'd98: toneR = `he;     15'd99: toneR = `he;
                    15'd100: toneR = `he;     15'd101: toneR = `he;
                    15'd102: toneR = `he;     15'd103: toneR = `he;
                    15'd104: toneR = `he;     15'd105: toneR = `he;
                    15'd106: toneR = `he;     15'd107: toneR = `he;
                    15'd108: toneR = `he;     15'd109: toneR = `he;
                    15'd110: toneR = `he;     15'd111: toneR = `he;
                    15'd112: toneR = `hc;     15'd113: toneR = `hc;
                    15'd114: toneR = `hc;     15'd115: toneR = `hc;
                    15'd116: toneR = `hc;     15'd117: toneR = `hc;
                    15'd118: toneR = `hc;     15'd119: toneR = `hc;
                    15'd120: toneR = `hc;     15'd121: toneR = `hc;
                    15'd122: toneR = `hc;     15'd123: toneR = `hc;
                    15'd124: toneR = `hc;     15'd125: toneR = `hc;
                    15'd126: toneR = `hc;     15'd127: toneR = `hc;
                    15'd128: toneR = `he;     15'd129: toneR = `he;
                    15'd130: toneR = `he;     15'd131: toneR = `he;
                    15'd132: toneR = `he;     15'd133: toneR = `he;
                    15'd134: toneR = `he;     15'd135: toneR = `he;
                    15'd136: toneR = `he;     15'd137: toneR = `he;
                    15'd138: toneR = `he;     15'd139: toneR = `he;
                    15'd140: toneR = `he;     15'd141: toneR = `he;
                    15'd142: toneR = `he;     15'd143: toneR = `he;
                    15'd144: toneR = `hf;     15'd145: toneR = `hf;
                    15'd146: toneR = `hf;     15'd147: toneR = `hf;
                    15'd148: toneR = `hf;     15'd149: toneR = `hf;
                    15'd150: toneR = `hf;     15'd151: toneR = `hf;
                    15'd152: toneR = `hf;     15'd153: toneR = `hf;
                    15'd154: toneR = `hf;     15'd155: toneR = `hf;
                    15'd156: toneR = `hf;     15'd157: toneR = `hf;
                    15'd158: toneR = `hf;     15'd159: toneR = `hf;
                    15'd160: toneR = `hg;     15'd161: toneR = `hg;
                    15'd162: toneR = `hg;     15'd163: toneR = `hg;
                    15'd164: toneR = `hg;     15'd165: toneR = `hg;
                    15'd166: toneR = `hg;     15'd167: toneR = `hg;
                    15'd168: toneR = `hg;     15'd169: toneR = `hg;
                    15'd170: toneR = `hg;     15'd171: toneR = `hg;
                    15'd172: toneR = `hg;     15'd173: toneR = `hg;
                    15'd174: toneR = `hg;     15'd175: toneR = `hg;
                    15'd176: toneR = `hg;     15'd177: toneR = `hg;
                    15'd178: toneR = `hg;     15'd179: toneR = `hg;
                    15'd180: toneR = `hg;     15'd181: toneR = `hg;
                    15'd182: toneR = `hg;     15'd183: toneR = `hg;
                    15'd184: toneR = `hg;     15'd185: toneR = `hg;
                    15'd186: toneR = `hg;     15'd187: toneR = `hg;
                    15'd188: toneR = `hg;     15'd189: toneR = `hg;
                    15'd190: toneR = `hg;     15'd191: toneR = `hg;
                    15'd192: toneR = `he;     15'd193: toneR = `he;
                    15'd194: toneR = `he;     15'd195: toneR = `he;
                    15'd196: toneR = `he;     15'd197: toneR = `he;
                    15'd198: toneR = `he;     15'd199: toneR = `he;
                    15'd200: toneR = `he;     15'd201: toneR = `he;
                    15'd202: toneR = `he;     15'd203: toneR = `he;
                    15'd204: toneR = `he;     15'd205: toneR = `he;
                    15'd206: toneR = `he;     15'd207: toneR = `he;
                    15'd208: toneR = `hf;     15'd209: toneR = `hf;
                    15'd210: toneR = `hf;     15'd211: toneR = `hf;
                    15'd212: toneR = `hf;     15'd213: toneR = `hf;
                    15'd214: toneR = `hf;     15'd215: toneR = `hf;
                    15'd216: toneR = `hf;     15'd217: toneR = `hf;
                    15'd218: toneR = `hf;     15'd219: toneR = `hf;
                    15'd220: toneR = `hf;     15'd221: toneR = `hf;
                    15'd222: toneR = `hf;     15'd223: toneR = `hf;
                    15'd224: toneR = `hg;     15'd225: toneR = `hg;
                    15'd226: toneR = `hg;     15'd227: toneR = `hg;
                    15'd228: toneR = `hg;     15'd229: toneR = `hg;
                    15'd230: toneR = `hg;     15'd231: toneR = `hg;
                    15'd232: toneR = `hg;     15'd233: toneR = `hg;
                    15'd234: toneR = `hg;     15'd235: toneR = `hg;
                    15'd236: toneR = `hg;     15'd237: toneR = `hg;
                    15'd238: toneR = `hg;     15'd239: toneR = `hg;
                    15'd240: toneR = `hg;     15'd241: toneR = `hg;
                    15'd242: toneR = `hg;     15'd243: toneR = `hg;
                    15'd244: toneR = `hg;     15'd245: toneR = `hg;
                    15'd246: toneR = `hg;     15'd247: toneR = `hg;
                    15'd248: toneR = `hg;     15'd249: toneR = `hg;
                    15'd250: toneR = `hg;     15'd251: toneR = `hg;
                    15'd252: toneR = `hg;     15'd253: toneR = `hg;
                    15'd254: toneR = `hg;     15'd255: toneR = `hg;
                    15'd256: toneR = `hg;     15'd257: toneR = `hg;
                    15'd258: toneR = `hg;     15'd259: toneR = `hg;
                    15'd260: toneR = `hg;     15'd261: toneR = `hg;
                    15'd262: toneR = `hg;     15'd263: toneR = `hg;
                    15'd264: toneR = `ha;     15'd265: toneR = `ha;
                    15'd266: toneR = `ha;     15'd267: toneR = `ha;
                    15'd268: toneR = `ha;     15'd269: toneR = `ha;
                    15'd270: toneR = `ha;     15'd271: toneR = `ha;
                    15'd272: toneR = `hg;     15'd273: toneR = `hg;
                    15'd274: toneR = `hg;     15'd275: toneR = `hg;
                    15'd276: toneR = `hg;     15'd277: toneR = `hg;
                    15'd278: toneR = `hg;     15'd279: toneR = `hg;
                    15'd280: toneR = `hf;     15'd281: toneR = `hf;
                    15'd282: toneR = `hf;     15'd283: toneR = `hf;
                    15'd284: toneR = `hf;     15'd285: toneR = `hf;
                    15'd286: toneR = `hf;     15'd287: toneR = `hf;
                    15'd288: toneR = `he;     15'd289: toneR = `he;
                    15'd290: toneR = `he;     15'd291: toneR = `he;
                    15'd292: toneR = `he;     15'd293: toneR = `he;
                    15'd294: toneR = `he;     15'd295: toneR = `he;
                    15'd296: toneR = `he;     15'd297: toneR = `he;
                    15'd298: toneR = `he;     15'd299: toneR = `he;
                    15'd300: toneR = `he;     15'd301: toneR = `he;
                    15'd302: toneR = `he;     15'd303: toneR = `he;
                    15'd304: toneR = `hc;     15'd305: toneR = `hc;
                    15'd306: toneR = `hc;     15'd307: toneR = `hc;
                    15'd308: toneR = `hc;     15'd309: toneR = `hc;
                    15'd310: toneR = `hc;     15'd311: toneR = `hc;
                    15'd312: toneR = `hc;     15'd313: toneR = `hc;
                    15'd314: toneR = `hc;     15'd315: toneR = `hc;
                    15'd316: toneR = `hc;     15'd317: toneR = `hc;
                    15'd318: toneR = `hc;     15'd319: toneR = `hc;
                    15'd320: toneR = `hg;     15'd321: toneR = `hg;
                    15'd322: toneR = `hg;     15'd323: toneR = `hg;
                    15'd324: toneR = `hg;     15'd325: toneR = `hg;
                    15'd326: toneR = `hg;     15'd327: toneR = `hg;
                    15'd328: toneR = `ha;     15'd329: toneR = `ha;
                    15'd330: toneR = `ha;     15'd331: toneR = `ha;
                    15'd332: toneR = `ha;     15'd333: toneR = `ha;
                    15'd334: toneR = `ha;     15'd335: toneR = `ha;
                    15'd336: toneR = `hg;     15'd337: toneR = `hg;
                    15'd338: toneR = `hg;     15'd339: toneR = `hg;
                    15'd340: toneR = `hg;     15'd341: toneR = `hg;
                    15'd342: toneR = `hg;     15'd343: toneR = `hg;
                    15'd344: toneR = `hf;     15'd345: toneR = `hf;
                    15'd346: toneR = `hf;     15'd347: toneR = `hf;
                    15'd348: toneR = `hf;     15'd349: toneR = `hf;
                    15'd350: toneR = `hf;     15'd351: toneR = `hf;
                    15'd352: toneR = `he;     15'd353: toneR = `he;
                    15'd354: toneR = `he;     15'd355: toneR = `he;
                    15'd356: toneR = `he;     15'd357: toneR = `he;
                    15'd358: toneR = `he;     15'd359: toneR = `he;
                    15'd360: toneR = `he;     15'd361: toneR = `he;
                    15'd362: toneR = `he;     15'd363: toneR = `he;
                    15'd364: toneR = `he;     15'd365: toneR = `he;
                    15'd366: toneR = `he;     15'd367: toneR = `he;
                    15'd368: toneR = `hc;     15'd369: toneR = `hc;
                    15'd370: toneR = `hc;     15'd371: toneR = `hc;
                    15'd372: toneR = `hc;     15'd373: toneR = `hc;
                    15'd374: toneR = `hc;     15'd375: toneR = `hc;
                    15'd376: toneR = `hc;     15'd377: toneR = `hc;
                    15'd378: toneR = `hc;     15'd379: toneR = `hc;
                    15'd380: toneR = `hc;     15'd381: toneR = `hc;
                    15'd382: toneR = `hc;     15'd383: toneR = `hc;
                    15'd384: toneR = `sil;     15'd385: toneR = `sil;
                    15'd386: toneR = `hc;     15'd387: toneR = `hc;
                    15'd388: toneR = `hc;     15'd389: toneR = `hc;
                    15'd390: toneR = `hc;     15'd391: toneR = `hc;
                    15'd392: toneR = `hc;     15'd393: toneR = `hc;
                    15'd394: toneR = `hc;     15'd395: toneR = `hc;
                    15'd396: toneR = `hc;     15'd397: toneR = `hc;
                    15'd398: toneR = `hc;     15'd399: toneR = `hc;
                    15'd400: toneR = `g;     15'd401: toneR = `g;
                    15'd402: toneR = `g;     15'd403: toneR = `g;
                    15'd404: toneR = `g;     15'd405: toneR = `g;
                    15'd406: toneR = `g;     15'd407: toneR = `g;
                    15'd408: toneR = `g;     15'd409: toneR = `g;
                    15'd410: toneR = `g;     15'd411: toneR = `g;
                    15'd412: toneR = `g;     15'd413: toneR = `g;
                    15'd414: toneR = `g;     15'd415: toneR = `g;
                    15'd416: toneR = `hc;     15'd417: toneR = `hc;
                    15'd418: toneR = `hc;     15'd419: toneR = `hc;
                    15'd420: toneR = `hc;     15'd421: toneR = `hc;
                    15'd422: toneR = `hc;     15'd423: toneR = `hc;
                    15'd424: toneR = `hc;     15'd425: toneR = `hc;
                    15'd426: toneR = `hc;     15'd427: toneR = `hc;
                    15'd428: toneR = `hc;     15'd429: toneR = `hc;
                    15'd430: toneR = `hc;     15'd431: toneR = `hc;
                    15'd432: toneR = `hc;     15'd433: toneR = `hc;
                    15'd434: toneR = `hc;     15'd435: toneR = `hc;
                    15'd436: toneR = `hc;     15'd437: toneR = `hc;
                    15'd438: toneR = `hc;     15'd439: toneR = `hc;
                    15'd440: toneR = `hc;     15'd441: toneR = `hc;
                    15'd442: toneR = `hc;     15'd443: toneR = `hc;
                    15'd444: toneR = `hc;     15'd445: toneR = `hc;
                    15'd446: toneR = `sil;     15'd447: toneR = `sil;
                    15'd448: toneR = `hc;     15'd449: toneR = `hc;
                    15'd450: toneR = `hc;     15'd451: toneR = `hc;
                    15'd452: toneR = `hc;     15'd453: toneR = `hc;
                    15'd454: toneR = `hc;     15'd455: toneR = `hc;
                    15'd456: toneR = `hc;     15'd457: toneR = `hc;
                    15'd458: toneR = `hc;     15'd459: toneR = `hc;
                    15'd460: toneR = `hc;     15'd461: toneR = `hc;
                    15'd462: toneR = `hc;     15'd463: toneR = `hc;
                    15'd464: toneR = `g;     15'd465: toneR = `g;
                    15'd466: toneR = `g;     15'd467: toneR = `g;
                    15'd468: toneR = `g;     15'd469: toneR = `g;
                    15'd470: toneR = `g;     15'd471: toneR = `g;
                    15'd472: toneR = `g;     15'd473: toneR = `g;
                    15'd474: toneR = `g;     15'd475: toneR = `g;
                    15'd476: toneR = `g;     15'd477: toneR = `g;
                    15'd478: toneR = `g;     15'd479: toneR = `g;
                    15'd480: toneR = `hc;     15'd481: toneR = `hc;
                    15'd482: toneR = `hc;     15'd483: toneR = `hc;
                    15'd484: toneR = `hc;     15'd485: toneR = `hc;
                    15'd486: toneR = `hc;     15'd487: toneR = `hc;
                    15'd488: toneR = `hc;     15'd489: toneR = `hc;
                    15'd490: toneR = `hc;     15'd491: toneR = `hc;
                    15'd492: toneR = `hc;     15'd493: toneR = `hc;
                    15'd494: toneR = `hc;     15'd495: toneR = `hc;
                    15'd496: toneR = `hc;     15'd497: toneR = `hc;
                    15'd498: toneR = `hc;     15'd499: toneR = `hc;
                    15'd500: toneR = `hc;     15'd501: toneR = `hc;
                    15'd502: toneR = `hc;     15'd503: toneR = `hc;
                    15'd504: toneR = `hc;     15'd505: toneR = `hc;
                    15'd506: toneR = `hc;     15'd507: toneR = `hc;
                    15'd508: toneR = `hc;     15'd509: toneR = `hc;
                    15'd510: toneR = `hc;     15'd511: toneR = `hc;
                    default: toneR = `sil;
                endcase
            end
            // case(ibeatNum)
                // // --- Measure 1 ---
                // 12'd0: toneR = `hg;      12'd1: toneR = `hg; // HG (half-beat)
                // 12'd2: toneR = `hg;      12'd3: toneR = `hg;
                // 12'd4: toneR = `hg;      12'd5: toneR = `hg;
                // 12'd6: toneR = `hg;      12'd7: toneR = `hg;
                // 12'd8: toneR = `he;      12'd9: toneR = `he; // HE (half-beat)
                // 12'd10: toneR = `he;     12'd11: toneR = `he;
                // 12'd12: toneR = `he;     12'd13: toneR = `he;
                // 12'd14: toneR = `he;     12'd15: toneR = `sil; // (Short break for repetitive notes: high E)

                // 12'd16: toneR = `he;     12'd17: toneR = `he; // HE (one-beat)
                // 12'd18: toneR = `he;     12'd19: toneR = `he;
                // 12'd20: toneR = `he;     12'd21: toneR = `he;
                // 12'd22: toneR = `he;     12'd23: toneR = `he;
                // 12'd24: toneR = `he;     12'd25: toneR = `he;
                // 12'd26: toneR = `he;     12'd27: toneR = `he;
                // 12'd28: toneR = `he;     12'd29: toneR = `he;
                // 12'd30: toneR = `he;     12'd31: toneR = `he;

                // 12'd32: toneR = `hf;     12'd33: toneR = `hf; // HF (half-beat)
                // 12'd34: toneR = `hf;     12'd35: toneR = `hf;
                // 12'd36: toneR = `hf;     12'd37: toneR = `hf;
                // 12'd38: toneR = `hf;     12'd39: toneR = `hf;
                // 12'd40: toneR = `hd;     12'd41: toneR = `hd; // HD (half-beat)
                // 12'd42: toneR = `hd;     12'd43: toneR = `hd;
                // 12'd44: toneR = `hd;     12'd45: toneR = `hd;
                // 12'd46: toneR = `hd;     12'd47: toneR = `sil; // (Short break for repetitive notes: high D)

                // 12'd48: toneR = `hd;     12'd49: toneR = `hd; // HD (one-beat)
                // 12'd50: toneR = `hd;     12'd51: toneR = `hd;
                // 12'd52: toneR = `hd;     12'd53: toneR = `hd;
                // 12'd54: toneR = `hd;     12'd55: toneR = `hd;
                // 12'd56: toneR = `hd;     12'd57: toneR = `hd;
                // 12'd58: toneR = `hd;     12'd59: toneR = `hd;
                // 12'd60: toneR = `hd;     12'd61: toneR = `hd;
                // 12'd62: toneR = `hd;     12'd63: toneR = `hd;

                // // --- Measure 2 ---
                // 12'd64: toneR = `hc;     12'd65: toneR = `hc; // HC (half-beat)
                // 12'd66: toneR = `hc;     12'd67: toneR = `hc;
                // 12'd68: toneR = `hc;     12'd69: toneR = `hc;
                // 12'd70: toneR = `hc;     12'd71: toneR = `hc;
                // 12'd72: toneR = `hd;     12'd73: toneR = `hd; // HD (half-beat)
                // 12'd74: toneR = `hd;     12'd75: toneR = `hd;
                // 12'd76: toneR = `hd;     12'd77: toneR = `hd;
                // 12'd78: toneR = `hd;     12'd79: toneR = `hd;

                // 12'd80: toneR = `he;     12'd81: toneR = `he; // HE (half-beat)
                // 12'd82: toneR = `he;     12'd83: toneR = `he;
                // 12'd84: toneR = `he;     12'd85: toneR = `he;
                // 12'd86: toneR = `he;     12'd87: toneR = `he;
                // 12'd88: toneR = `hf;     12'd89: toneR = `hf; // HF (half-beat)
                // 12'd90: toneR = `hf;     12'd91: toneR = `hf;
                // 12'd92: toneR = `hf;     12'd93: toneR = `hf;
                // 12'd94: toneR = `hf;     12'd95: toneR = `hf;

                // 12'd96: toneR = `hg;     12'd97: toneR = `hg; // HG (half-beat)
                // 12'd98: toneR = `hg;     12'd99: toneR = `hg;
                // 12'd100: toneR = `hg;     12'd101: toneR = `hg;
                // 12'd102: toneR = `hg;     12'd103: toneR = `sil; // (Short break for repetitive notes: high D)
                // 12'd104: toneR = `hg;     12'd105: toneR = `hg; // HG (half-beat)
                // 12'd106: toneR = `hg;     12'd107: toneR = `hg;
                // 12'd108: toneR = `hg;     12'd109: toneR = `hg;
                // 12'd110: toneR = `hg;     12'd111: toneR = `sil; // (Short break for repetitive notes: high D)

                // 12'd112: toneR = `hg;     12'd113: toneR = `hg; // HG (one-beat)
                // 12'd114: toneR = `hg;     12'd115: toneR = `hg;
                // 12'd116: toneR = `hg;     12'd117: toneR = `hg;
                // 12'd118: toneR = `hg;     12'd119: toneR = `hg;
                // 12'd120: toneR = `hg;     12'd121: toneR = `hg;
                // 12'd122: toneR = `hg;     12'd123: toneR = `hg;
                // 12'd124: toneR = `hg;     12'd125: toneR = `hg;
                // 12'd126: toneR = `hg;     12'd127: toneR = `hg;

                // 15'd0: toneR = `ha;     15'd1: toneR = `ha;
                // 15'd2: toneR = `ha;     15'd3: toneR = `ha;
                // 15'd4: toneR = `ha;     15'd5: toneR = `ha;
                // 15'd6: toneR = `ha;     15'd7: toneR = `ha;
                // 15'd8: toneR = `rhf;     15'd9: toneR = `rhf;
                // 15'd10: toneR = `rhf;     15'd11: toneR = `rhf;
                // 15'd12: toneR = `hg;     15'd13: toneR = `hg;
                // 15'd14: toneR = `hg;     15'd15: toneR = `hg;
                // 15'd16: toneR = `ha;     15'd17: toneR = `ha;
                // 15'd18: toneR = `ha;     15'd19: toneR = `ha;
                // 15'd20: toneR = `ha;     15'd21: toneR = `ha;
                // 15'd22: toneR = `ha;     15'd23: toneR = `ha;
                // 15'd24: toneR = `rhf;     15'd25: toneR = `rhf;
                // 15'd26: toneR = `rhf;     15'd27: toneR = `rhf;
                // 15'd28: toneR = `hg;     15'd29: toneR = `hg;
                // 15'd30: toneR = `hg;     15'd31: toneR = `hg;
                // 15'd32: toneR = `ha;     15'd33: toneR = `ha;
                // 15'd34: toneR = `ha;     15'd35: toneR = `ha;
                // 15'd36: toneR = `a;     15'd37: toneR = `a;
                // 15'd38: toneR = `a;     15'd39: toneR = `a;
                // 15'd40: toneR = `b;     15'd41: toneR = `b;
                // 15'd42: toneR = `b;     15'd43: toneR = `b;
                // 15'd44: toneR = `rhc;     15'd45: toneR = `rhc;
                // 15'd46: toneR = `rhc;     15'd47: toneR = `rhc;
                // 15'd48: toneR = `hd;     15'd49: toneR = `hd;
                // 15'd50: toneR = `hd;     15'd51: toneR = `hd;
                // 15'd52: toneR = `he;     15'd53: toneR = `he;
                // 15'd54: toneR = `he;     15'd55: toneR = `he;
                // 15'd56: toneR = `rhf;     15'd57: toneR = `rhf;
                // 15'd58: toneR = `rhf;     15'd59: toneR = `rhf;
                // 15'd60: toneR = `hg;     15'd61: toneR = `hg;
                // 15'd62: toneR = `hg;     15'd63: toneR = `hg;
                // 15'd64: toneR = `rhf;     15'd65: toneR = `rhf;
                // 15'd66: toneR = `rhf;     15'd67: toneR = `rhf;
                // 15'd68: toneR = `rhf;     15'd69: toneR = `rhf;
                // 15'd70: toneR = `rhf;     15'd71: toneR = `rhf;
                // 15'd72: toneR = `hd;     15'd73: toneR = `hd;
                // 15'd74: toneR = `hd;     15'd75: toneR = `hd;
                // 15'd76: toneR = `he;     15'd77: toneR = `he;
                // 15'd78: toneR = `he;     15'd79: toneR = `he;
                // 15'd80: toneR = `rhf;     15'd81: toneR = `rhf;
                // 15'd82: toneR = `rhf;     15'd83: toneR = `rhf;
                // 15'd84: toneR = `rhf;     15'd85: toneR = `rhf;
                // 15'd86: toneR = `rhf;     15'd87: toneR = `rhf;
                // 15'd88: toneR = `rf;     15'd89: toneR = `rf;
                // 15'd90: toneR = `rf;     15'd91: toneR = `rf;
                // 15'd92: toneR = `g;     15'd93: toneR = `g;
                // 15'd94: toneR = `g;     15'd95: toneR = `g;
                // 15'd96: toneR = `a;     15'd97: toneR = `a;
                // 15'd98: toneR = `a;     15'd99: toneR = `a;
                // 15'd100: toneR = `b;     15'd101: toneR = `b;
                // 15'd102: toneR = `b;     15'd103: toneR = `b;
                // 15'd104: toneR = `a;     15'd105: toneR = `a;
                // 15'd106: toneR = `a;     15'd107: toneR = `a;
                // 15'd108: toneR = `g;     15'd109: toneR = `g;
                // 15'd110: toneR = `g;     15'd111: toneR = `g;
                // 15'd112: toneR = `a;     15'd113: toneR = `a;
                // 15'd114: toneR = `a;     15'd115: toneR = `a;
                // 15'd116: toneR = `rf;     15'd117: toneR = `rf;
                // 15'd118: toneR = `rf;     15'd119: toneR = `rf;
                // 15'd120: toneR = `g;     15'd121: toneR = `g;
                // 15'd122: toneR = `g;     15'd123: toneR = `g;
                // 15'd124: toneR = `a;     15'd125: toneR = `a;
                // 15'd126: toneR = `a;     15'd127: toneR = `a;
                // 15'd128: toneR = `g;     15'd129: toneR = `g;
                // 15'd130: toneR = `g;     15'd131: toneR = `g;
                // 15'd132: toneR = `g;     15'd133: toneR = `g;
                // 15'd134: toneR = `g;     15'd135: toneR = `g;
                // 15'd136: toneR = `b;     15'd137: toneR = `b;
                // 15'd138: toneR = `b;     15'd139: toneR = `b;
                // 15'd140: toneR = `a;     15'd141: toneR = `a;
                // 15'd142: toneR = `a;     15'd143: toneR = `a;
                // 15'd144: toneR = `g;     15'd145: toneR = `g;
                // 15'd146: toneR = `g;     15'd147: toneR = `g;
                // 15'd148: toneR = `g;     15'd149: toneR = `g;
                // 15'd150: toneR = `g;     15'd151: toneR = `g;
                // 15'd152: toneR = `rf;     15'd153: toneR = `rf;
                // 15'd154: toneR = `rf;     15'd155: toneR = `rf;
                // 15'd156: toneR = `e;     15'd157: toneR = `e;
                // 15'd158: toneR = `e;     15'd159: toneR = `e;
                // 15'd160: toneR = `rf;     15'd161: toneR = `rf;
                // 15'd162: toneR = `rf;     15'd163: toneR = `rf;
                // 15'd164: toneR = `e;     15'd165: toneR = `e;
                // 15'd166: toneR = `e;     15'd167: toneR = `e;
                // 15'd168: toneR = `d;     15'd169: toneR = `d;
                // 15'd170: toneR = `d;     15'd171: toneR = `d;
                // 15'd172: toneR = `e;     15'd173: toneR = `e;
                // 15'd174: toneR = `e;     15'd175: toneR = `e;
                // 15'd176: toneR = `rf;     15'd177: toneR = `rf;
                // 15'd178: toneR = `rf;     15'd179: toneR = `rf;
                // 15'd180: toneR = `g;     15'd181: toneR = `g;
                // 15'd182: toneR = `g;     15'd183: toneR = `g;
                // 15'd184: toneR = `a;     15'd185: toneR = `a;
                // 15'd186: toneR = `a;     15'd187: toneR = `a;
                // 15'd188: toneR = `b;     15'd189: toneR = `b;
                // 15'd190: toneR = `b;     15'd191: toneR = `b;
                // 15'd192: toneR = `g;     15'd193: toneR = `g;
                // 15'd194: toneR = `g;     15'd195: toneR = `g;
                // 15'd196: toneR = `g;     15'd197: toneR = `g;
                // 15'd198: toneR = `g;     15'd199: toneR = `g;
                // 15'd200: toneR = `b;     15'd201: toneR = `b;
                // 15'd202: toneR = `b;     15'd203: toneR = `b;
                // 15'd204: toneR = `a;     15'd205: toneR = `a;
                // 15'd206: toneR = `a;     15'd207: toneR = `a;
                // 15'd208: toneR = `b;     15'd209: toneR = `b;
                // 15'd210: toneR = `b;     15'd211: toneR = `b;
                // 15'd212: toneR = `b;     15'd213: toneR = `b;
                // 15'd214: toneR = `b;     15'd215: toneR = `b;
                // 15'd216: toneR = `rhc;     15'd217: toneR = `rhc;
                // 15'd218: toneR = `rhc;     15'd219: toneR = `rhc;
                // 15'd220: toneR = `hd;     15'd221: toneR = `hd;
                // 15'd222: toneR = `hd;     15'd223: toneR = `hd;
                // 15'd224: toneR = `a;     15'd225: toneR = `a;
                // 15'd226: toneR = `a;     15'd227: toneR = `a;
                // 15'd228: toneR = `b;     15'd229: toneR = `b;
                // 15'd230: toneR = `b;     15'd231: toneR = `b;
                // 15'd232: toneR = `rhc;     15'd233: toneR = `rhc;
                // 15'd234: toneR = `rhc;     15'd235: toneR = `rhc;
                // 15'd236: toneR = `hd;     15'd237: toneR = `hd;
                // 15'd238: toneR = `hd;     15'd239: toneR = `hd;
                // 15'd240: toneR = `he;     15'd241: toneR = `he;
                // 15'd242: toneR = `he;     15'd243: toneR = `he;
                // 15'd244: toneR = `rhf;     15'd245: toneR = `rhf;
                // 15'd246: toneR = `rhf;     15'd247: toneR = `rhf;
                // 15'd248: toneR = `hg;     15'd249: toneR = `hg;
                // 15'd250: toneR = `hg;     15'd251: toneR = `hg;
                // 15'd252: toneR = `ha;     15'd253: toneR = `ha;
                // 15'd254: toneR = `ha;     15'd255: toneR = `ha;
                // 15'd256: toneR = `rhf;     15'd257: toneR = `rhf;
                // 15'd258: toneR = `rhf;     15'd259: toneR = `rhf;
                // 15'd260: toneR = `rhf;     15'd261: toneR = `rhf;
                // 15'd262: toneR = `rhf;     15'd263: toneR = `rhf;
                // 15'd264: toneR = `hd;     15'd265: toneR = `hd;
                // 15'd266: toneR = `hd;     15'd267: toneR = `hd;
                // 15'd268: toneR = `he;     15'd269: toneR = `he;
                // 15'd270: toneR = `he;     15'd271: toneR = `he;
                // 15'd272: toneR = `rhf;     15'd273: toneR = `rhf;
                // 15'd274: toneR = `rhf;     15'd275: toneR = `rhf;
                // 15'd276: toneR = `rhf;     15'd277: toneR = `rhf;
                // 15'd278: toneR = `rhf;     15'd279: toneR = `rhf;
                // 15'd280: toneR = `he;     15'd281: toneR = `he;
                // 15'd282: toneR = `he;     15'd283: toneR = `he;
                // 15'd284: toneR = `hd;     15'd285: toneR = `hd;
                // 15'd286: toneR = `hd;     15'd287: toneR = `hd;
                // 15'd288: toneR = `he;     15'd289: toneR = `he;
                // 15'd290: toneR = `he;     15'd291: toneR = `he;
                // 15'd292: toneR = `rhc;     15'd293: toneR = `rhc;
                // 15'd294: toneR = `rhc;     15'd295: toneR = `rhc;
                // 15'd296: toneR = `hd;     15'd297: toneR = `hd;
                // 15'd298: toneR = `hd;     15'd299: toneR = `hd;
                // 15'd300: toneR = `he;     15'd301: toneR = `he;
                // 15'd302: toneR = `he;     15'd303: toneR = `he;
                // 15'd304: toneR = `rhf;     15'd305: toneR = `rhf;
                // 15'd306: toneR = `rhf;     15'd307: toneR = `rhf;
                // 15'd308: toneR = `he;     15'd309: toneR = `he;
                // 15'd310: toneR = `he;     15'd311: toneR = `he;
                // 15'd312: toneR = `hd;     15'd313: toneR = `hd;
                // 15'd314: toneR = `hd;     15'd315: toneR = `hd;
                // 15'd316: toneR = `rhc;     15'd317: toneR = `rhc;
                // 15'd318: toneR = `rhc;     15'd319: toneR = `rhc;

        //         15'd0: toneR = `hc;     15'd1: toneR = `hc;
        //             15'd2: toneR = `hc;     15'd3: toneR = `hc;
        //             15'd4: toneR = `hc;     15'd5: toneR = `hc;
        //             15'd6: toneR = `hc;     15'd7: toneR = `hc;
        //             15'd8: toneR = `hc;     15'd9: toneR = `hc;
        //             15'd10: toneR = `hc;     15'd11: toneR = `hc;
        //             15'd12: toneR = `hc;     15'd13: toneR = `hc;
        //             15'd14: toneR = `hc;     15'd15: toneR = `hc;
        //             15'd16: toneR = `hd;     15'd17: toneR = `hd;
        //             15'd18: toneR = `hd;     15'd19: toneR = `hd;
        //             15'd20: toneR = `hd;     15'd21: toneR = `hd;
        //             15'd22: toneR = `hd;     15'd23: toneR = `hd;
        //             15'd24: toneR = `hd;     15'd25: toneR = `hd;
        //             15'd26: toneR = `hd;     15'd27: toneR = `hd;
        //             15'd28: toneR = `hd;     15'd29: toneR = `hd;
        //             15'd30: toneR = `hd;     15'd31: toneR = `hd;
        //             15'd32: toneR = `he;     15'd33: toneR = `he;
        //             15'd34: toneR = `he;     15'd35: toneR = `he;
        //             15'd36: toneR = `he;     15'd37: toneR = `he;
        //             15'd38: toneR = `he;     15'd39: toneR = `he;
        //             15'd40: toneR = `he;     15'd41: toneR = `he;
        //             15'd42: toneR = `he;     15'd43: toneR = `he;
        //             15'd44: toneR = `he;     15'd45: toneR = `he;
        //             15'd46: toneR = `he;     15'd47: toneR = `he;
        //             15'd48: toneR = `hc;     15'd49: toneR = `hc;
        //             15'd50: toneR = `hc;     15'd51: toneR = `hc;
        //             15'd52: toneR = `hc;     15'd53: toneR = `hc;
        //             15'd54: toneR = `hc;     15'd55: toneR = `hc;
        //             15'd56: toneR = `hc;     15'd57: toneR = `hc;
        //             15'd58: toneR = `hc;     15'd59: toneR = `hc;
        //             15'd60: toneR = `hc;     15'd61: toneR = `hc;
        //             15'd62: toneR = `hc;     15'd63: toneR = `hc;
        //             15'd64: toneR = `hc;     15'd65: toneR = `hc;
        //             15'd66: toneR = `hc;     15'd67: toneR = `hc;
        //             15'd68: toneR = `hc;     15'd69: toneR = `hc;
        //             15'd70: toneR = `hc;     15'd71: toneR = `hc;
        //             15'd72: toneR = `hc;     15'd73: toneR = `hc;
        //             15'd74: toneR = `hc;     15'd75: toneR = `hc;
        //             15'd76: toneR = `hc;     15'd77: toneR = `hc;
        //             15'd78: toneR = `hc;     15'd79: toneR = `hc;
        //             15'd80: toneR = `hd;     15'd81: toneR = `hd;
        //             15'd82: toneR = `hd;     15'd83: toneR = `hd;
        //             15'd84: toneR = `hd;     15'd85: toneR = `hd;
        //             15'd86: toneR = `hd;     15'd87: toneR = `hd;
        //             15'd88: toneR = `hd;     15'd89: toneR = `hd;
        //             15'd90: toneR = `hd;     15'd91: toneR = `hd;
        //             15'd92: toneR = `hd;     15'd93: toneR = `hd;
        //             15'd94: toneR = `hd;     15'd95: toneR = `hd;
        //             15'd96: toneR = `he;     15'd97: toneR = `he;
        //             15'd98: toneR = `he;     15'd99: toneR = `he;
        //             15'd100: toneR = `he;     15'd101: toneR = `he;
        //             15'd102: toneR = `he;     15'd103: toneR = `he;
        //             15'd104: toneR = `he;     15'd105: toneR = `he;
        //             15'd106: toneR = `he;     15'd107: toneR = `he;
        //             15'd108: toneR = `he;     15'd109: toneR = `he;
        //             15'd110: toneR = `he;     15'd111: toneR = `he;
        //             15'd112: toneR = `hc;     15'd113: toneR = `hc;
        //             15'd114: toneR = `hc;     15'd115: toneR = `hc;
        //             15'd116: toneR = `hc;     15'd117: toneR = `hc;
        //             15'd118: toneR = `hc;     15'd119: toneR = `hc;
        //             15'd120: toneR = `hc;     15'd121: toneR = `hc;
        //             15'd122: toneR = `hc;     15'd123: toneR = `hc;
        //             15'd124: toneR = `hc;     15'd125: toneR = `hc;
        //             15'd126: toneR = `hc;     15'd127: toneR = `hc;
        //             15'd128: toneR = `he;     15'd129: toneR = `he;
        //             15'd130: toneR = `he;     15'd131: toneR = `he;
        //             15'd132: toneR = `he;     15'd133: toneR = `he;
        //             15'd134: toneR = `he;     15'd135: toneR = `he;
        //             15'd136: toneR = `he;     15'd137: toneR = `he;
        //             15'd138: toneR = `he;     15'd139: toneR = `he;
        //             15'd140: toneR = `he;     15'd141: toneR = `he;
        //             15'd142: toneR = `he;     15'd143: toneR = `he;
        //             15'd144: toneR = `hf;     15'd145: toneR = `hf;
        //             15'd146: toneR = `hf;     15'd147: toneR = `hf;
        //             15'd148: toneR = `hf;     15'd149: toneR = `hf;
        //             15'd150: toneR = `hf;     15'd151: toneR = `hf;
        //             15'd152: toneR = `hf;     15'd153: toneR = `hf;
        //             15'd154: toneR = `hf;     15'd155: toneR = `hf;
        //             15'd156: toneR = `hf;     15'd157: toneR = `hf;
        //             15'd158: toneR = `hf;     15'd159: toneR = `hf;
        //             15'd160: toneR = `hg;     15'd161: toneR = `hg;
        //             15'd162: toneR = `hg;     15'd163: toneR = `hg;
        //             15'd164: toneR = `hg;     15'd165: toneR = `hg;
        //             15'd166: toneR = `hg;     15'd167: toneR = `hg;
        //             15'd168: toneR = `hg;     15'd169: toneR = `hg;
        //             15'd170: toneR = `hg;     15'd171: toneR = `hg;
        //             15'd172: toneR = `hg;     15'd173: toneR = `hg;
        //             15'd174: toneR = `hg;     15'd175: toneR = `hg;
        //             15'd176: toneR = `hg;     15'd177: toneR = `hg;
        //             15'd178: toneR = `hg;     15'd179: toneR = `hg;
        //             15'd180: toneR = `hg;     15'd181: toneR = `hg;
        //             15'd182: toneR = `hg;     15'd183: toneR = `hg;
        //             15'd184: toneR = `hg;     15'd185: toneR = `hg;
        //             15'd186: toneR = `hg;     15'd187: toneR = `hg;
        //             15'd188: toneR = `hg;     15'd189: toneR = `hg;
        //             15'd190: toneR = `hg;     15'd191: toneR = `hg;
        //             15'd192: toneR = `he;     15'd193: toneR = `he;
        //             15'd194: toneR = `he;     15'd195: toneR = `he;
        //             15'd196: toneR = `he;     15'd197: toneR = `he;
        //             15'd198: toneR = `he;     15'd199: toneR = `he;
        //             15'd200: toneR = `he;     15'd201: toneR = `he;
        //             15'd202: toneR = `he;     15'd203: toneR = `he;
        //             15'd204: toneR = `he;     15'd205: toneR = `he;
        //             15'd206: toneR = `he;     15'd207: toneR = `he;
        //             15'd208: toneR = `hf;     15'd209: toneR = `hf;
        //             15'd210: toneR = `hf;     15'd211: toneR = `hf;
        //             15'd212: toneR = `hf;     15'd213: toneR = `hf;
        //             15'd214: toneR = `hf;     15'd215: toneR = `hf;
        //             15'd216: toneR = `hf;     15'd217: toneR = `hf;
        //             15'd218: toneR = `hf;     15'd219: toneR = `hf;
        //             15'd220: toneR = `hf;     15'd221: toneR = `hf;
        //             15'd222: toneR = `hf;     15'd223: toneR = `hf;
        //             15'd224: toneR = `hg;     15'd225: toneR = `hg;
        //             15'd226: toneR = `hg;     15'd227: toneR = `hg;
        //             15'd228: toneR = `hg;     15'd229: toneR = `hg;
        //             15'd230: toneR = `hg;     15'd231: toneR = `hg;
        //             15'd232: toneR = `hg;     15'd233: toneR = `hg;
        //             15'd234: toneR = `hg;     15'd235: toneR = `hg;
        //             15'd236: toneR = `hg;     15'd237: toneR = `hg;
        //             15'd238: toneR = `hg;     15'd239: toneR = `hg;
        //             15'd240: toneR = `hg;     15'd241: toneR = `hg;
        //             15'd242: toneR = `hg;     15'd243: toneR = `hg;
        //             15'd244: toneR = `hg;     15'd245: toneR = `hg;
        //             15'd246: toneR = `hg;     15'd247: toneR = `hg;
        //             15'd248: toneR = `hg;     15'd249: toneR = `hg;
        //             15'd250: toneR = `hg;     15'd251: toneR = `hg;
        //             15'd252: toneR = `hg;     15'd253: toneR = `hg;
        //             15'd254: toneR = `hg;     15'd255: toneR = `hg;
        //             15'd256: toneR = `hg;     15'd257: toneR = `hg;
        //             15'd258: toneR = `hg;     15'd259: toneR = `hg;
        //             15'd260: toneR = `hg;     15'd261: toneR = `hg;
        //             15'd262: toneR = `hg;     15'd263: toneR = `hg;
        //             15'd264: toneR = `ha;     15'd265: toneR = `ha;
        //             15'd266: toneR = `ha;     15'd267: toneR = `ha;
        //             15'd268: toneR = `ha;     15'd269: toneR = `ha;
        //             15'd270: toneR = `ha;     15'd271: toneR = `ha;
        //             15'd272: toneR = `hg;     15'd273: toneR = `hg;
        //             15'd274: toneR = `hg;     15'd275: toneR = `hg;
        //             15'd276: toneR = `hg;     15'd277: toneR = `hg;
        //             15'd278: toneR = `hg;     15'd279: toneR = `hg;
        //             15'd280: toneR = `hf;     15'd281: toneR = `hf;
        //             15'd282: toneR = `hf;     15'd283: toneR = `hf;
        //             15'd284: toneR = `hf;     15'd285: toneR = `hf;
        //             15'd286: toneR = `hf;     15'd287: toneR = `hf;
        //             15'd288: toneR = `he;     15'd289: toneR = `he;
        //             15'd290: toneR = `he;     15'd291: toneR = `he;
        //             15'd292: toneR = `he;     15'd293: toneR = `he;
        //             15'd294: toneR = `he;     15'd295: toneR = `he;
        //             15'd296: toneR = `he;     15'd297: toneR = `he;
        //             15'd298: toneR = `he;     15'd299: toneR = `he;
        //             15'd300: toneR = `he;     15'd301: toneR = `he;
        //             15'd302: toneR = `he;     15'd303: toneR = `he;
        //             15'd304: toneR = `hc;     15'd305: toneR = `hc;
        //             15'd306: toneR = `hc;     15'd307: toneR = `hc;
        //             15'd308: toneR = `hc;     15'd309: toneR = `hc;
        //             15'd310: toneR = `hc;     15'd311: toneR = `hc;
        //             15'd312: toneR = `hc;     15'd313: toneR = `hc;
        //             15'd314: toneR = `hc;     15'd315: toneR = `hc;
        //             15'd316: toneR = `hc;     15'd317: toneR = `hc;
        //             15'd318: toneR = `hc;     15'd319: toneR = `hc;
        //             15'd320: toneR = `hg;     15'd321: toneR = `hg;
        //             15'd322: toneR = `hg;     15'd323: toneR = `hg;
        //             15'd324: toneR = `hg;     15'd325: toneR = `hg;
        //             15'd326: toneR = `hg;     15'd327: toneR = `hg;
        //             15'd328: toneR = `ha;     15'd329: toneR = `ha;
        //             15'd330: toneR = `ha;     15'd331: toneR = `ha;
        //             15'd332: toneR = `ha;     15'd333: toneR = `ha;
        //             15'd334: toneR = `ha;     15'd335: toneR = `ha;
        //             15'd336: toneR = `hg;     15'd337: toneR = `hg;
        //             15'd338: toneR = `hg;     15'd339: toneR = `hg;
        //             15'd340: toneR = `hg;     15'd341: toneR = `hg;
        //             15'd342: toneR = `hg;     15'd343: toneR = `hg;
        //             15'd344: toneR = `hf;     15'd345: toneR = `hf;
        //             15'd346: toneR = `hf;     15'd347: toneR = `hf;
        //             15'd348: toneR = `hf;     15'd349: toneR = `hf;
        //             15'd350: toneR = `hf;     15'd351: toneR = `hf;
        //             15'd352: toneR = `he;     15'd353: toneR = `he;
        //             15'd354: toneR = `he;     15'd355: toneR = `he;
        //             15'd356: toneR = `he;     15'd357: toneR = `he;
        //             15'd358: toneR = `he;     15'd359: toneR = `he;
        //             15'd360: toneR = `he;     15'd361: toneR = `he;
        //             15'd362: toneR = `he;     15'd363: toneR = `he;
        //             15'd364: toneR = `he;     15'd365: toneR = `he;
        //             15'd366: toneR = `he;     15'd367: toneR = `he;
        //             15'd368: toneR = `hc;     15'd369: toneR = `hc;
        //             15'd370: toneR = `hc;     15'd371: toneR = `hc;
        //             15'd372: toneR = `hc;     15'd373: toneR = `hc;
        //             15'd374: toneR = `hc;     15'd375: toneR = `hc;
        //             15'd376: toneR = `hc;     15'd377: toneR = `hc;
        //             15'd378: toneR = `hc;     15'd379: toneR = `hc;
        //             15'd380: toneR = `hc;     15'd381: toneR = `hc;
        //             15'd382: toneR = `hc;     15'd383: toneR = `hc;
        //             15'd384: toneR = `sil;     15'd385: toneR = `sil;
        //             15'd386: toneR = `hc;     15'd387: toneR = `hc;
        //             15'd388: toneR = `hc;     15'd389: toneR = `hc;
        //             15'd390: toneR = `hc;     15'd391: toneR = `hc;
        //             15'd392: toneR = `hc;     15'd393: toneR = `hc;
        //             15'd394: toneR = `hc;     15'd395: toneR = `hc;
        //             15'd396: toneR = `hc;     15'd397: toneR = `hc;
        //             15'd398: toneR = `hc;     15'd399: toneR = `hc;
        //             15'd400: toneR = `g;     15'd401: toneR = `g;
        //             15'd402: toneR = `g;     15'd403: toneR = `g;
        //             15'd404: toneR = `g;     15'd405: toneR = `g;
        //             15'd406: toneR = `g;     15'd407: toneR = `g;
        //             15'd408: toneR = `g;     15'd409: toneR = `g;
        //             15'd410: toneR = `g;     15'd411: toneR = `g;
        //             15'd412: toneR = `g;     15'd413: toneR = `g;
        //             15'd414: toneR = `g;     15'd415: toneR = `g;
        //             15'd416: toneR = `hc;     15'd417: toneR = `hc;
        //             15'd418: toneR = `hc;     15'd419: toneR = `hc;
        //             15'd420: toneR = `hc;     15'd421: toneR = `hc;
        //             15'd422: toneR = `hc;     15'd423: toneR = `hc;
        //             15'd424: toneR = `hc;     15'd425: toneR = `hc;
        //             15'd426: toneR = `hc;     15'd427: toneR = `hc;
        //             15'd428: toneR = `hc;     15'd429: toneR = `hc;
        //             15'd430: toneR = `hc;     15'd431: toneR = `hc;
        //             15'd432: toneR = `hc;     15'd433: toneR = `hc;
        //             15'd434: toneR = `hc;     15'd435: toneR = `hc;
        //             15'd436: toneR = `hc;     15'd437: toneR = `hc;
        //             15'd438: toneR = `hc;     15'd439: toneR = `hc;
        //             15'd440: toneR = `hc;     15'd441: toneR = `hc;
        //             15'd442: toneR = `hc;     15'd443: toneR = `hc;
        //             15'd444: toneR = `hc;     15'd445: toneR = `hc;
        //             15'd446: toneR = `sil;     15'd447: toneR = `sil;
        //             15'd448: toneR = `hc;     15'd449: toneR = `hc;
        //             15'd450: toneR = `hc;     15'd451: toneR = `hc;
        //             15'd452: toneR = `hc;     15'd453: toneR = `hc;
        //             15'd454: toneR = `hc;     15'd455: toneR = `hc;
        //             15'd456: toneR = `hc;     15'd457: toneR = `hc;
        //             15'd458: toneR = `hc;     15'd459: toneR = `hc;
        //             15'd460: toneR = `hc;     15'd461: toneR = `hc;
        //             15'd462: toneR = `hc;     15'd463: toneR = `hc;
        //             15'd464: toneR = `g;     15'd465: toneR = `g;
        //             15'd466: toneR = `g;     15'd467: toneR = `g;
        //             15'd468: toneR = `g;     15'd469: toneR = `g;
        //             15'd470: toneR = `g;     15'd471: toneR = `g;
        //             15'd472: toneR = `g;     15'd473: toneR = `g;
        //             15'd474: toneR = `g;     15'd475: toneR = `g;
        //             15'd476: toneR = `g;     15'd477: toneR = `g;
        //             15'd478: toneR = `g;     15'd479: toneR = `g;
        //             15'd480: toneR = `hc;     15'd481: toneR = `hc;
        //             15'd482: toneR = `hc;     15'd483: toneR = `hc;
        //             15'd484: toneR = `hc;     15'd485: toneR = `hc;
        //             15'd486: toneR = `hc;     15'd487: toneR = `hc;
        //             15'd488: toneR = `hc;     15'd489: toneR = `hc;
        //             15'd490: toneR = `hc;     15'd491: toneR = `hc;
        //             15'd492: toneR = `hc;     15'd493: toneR = `hc;
        //             15'd494: toneR = `hc;     15'd495: toneR = `hc;
        //             15'd496: toneR = `hc;     15'd497: toneR = `hc;
        //             15'd498: toneR = `hc;     15'd499: toneR = `hc;
        //             15'd500: toneR = `hc;     15'd501: toneR = `hc;
        //             15'd502: toneR = `hc;     15'd503: toneR = `hc;
        //             15'd504: toneR = `hc;     15'd505: toneR = `hc;
        //             15'd506: toneR = `hc;     15'd507: toneR = `hc;
        //             15'd508: toneR = `hc;     15'd509: toneR = `hc;
        //             15'd510: toneR = `hc;     15'd511: toneR = `hc;
        //         default: toneR = `sil;
        //     endcase
         end else begin
             toneR = `sil;
         end
    end

    always @(*) begin
        if(en == 1) begin
            if (_music) begin
                case(ibeatNum)
                    15'd0: toneL = `hd;     15'd1: toneL = `hd;
                    15'd2: toneL = `hd;     15'd3: toneL = `hd;
                    15'd4: toneL = `hd;     15'd5: toneL = `hd;
                    15'd6: toneL = `hd;     15'd7: toneL = `hd;
                    15'd8: toneL = `hd;     15'd9: toneL = `hd;
                    15'd10: toneL = `hd;     15'd11: toneL = `hd;
                    15'd12: toneL = `hd;     15'd13: toneL = `hd;
                    15'd14: toneL = `hd;     15'd15: toneL = `hd;
                    15'd16: toneL = `hd;     15'd17: toneL = `hd;
                    15'd18: toneL = `hd;     15'd19: toneL = `hd;
                    15'd20: toneL = `hd;     15'd21: toneL = `hd;
                    15'd22: toneL = `hd;     15'd23: toneL = `hd;
                    15'd24: toneL = `hd;     15'd25: toneL = `hd;
                    15'd26: toneL = `hd;     15'd27: toneL = `hd;
                    15'd28: toneL = `hd;     15'd29: toneL = `hd;
                    15'd30: toneL = `hd;     15'd31: toneL = `hd;
                    15'd32: toneL = `a;     15'd33: toneL = `a;
                    15'd34: toneL = `a;     15'd35: toneL = `a;
                    15'd36: toneL = `a;     15'd37: toneL = `a;
                    15'd38: toneL = `a;     15'd39: toneL = `a;
                    15'd40: toneL = `a;     15'd41: toneL = `a;
                    15'd42: toneL = `a;     15'd43: toneL = `a;
                    15'd44: toneL = `a;     15'd45: toneL = `a;
                    15'd46: toneL = `a;     15'd47: toneL = `a;
                    15'd48: toneL = `a;     15'd49: toneL = `a;
                    15'd50: toneL = `a;     15'd51: toneL = `a;
                    15'd52: toneL = `a;     15'd53: toneL = `a;
                    15'd54: toneL = `a;     15'd55: toneL = `a;
                    15'd56: toneL = `a;     15'd57: toneL = `a;
                    15'd58: toneL = `a;     15'd59: toneL = `a;
                    15'd60: toneL = `a;     15'd61: toneL = `a;
                    15'd62: toneL = `a;     15'd63: toneL = `a;
                    15'd64: toneL = `b;     15'd65: toneL = `b;
                    15'd66: toneL = `b;     15'd67: toneL = `b;
                    15'd68: toneL = `b;     15'd69: toneL = `b;
                    15'd70: toneL = `b;     15'd71: toneL = `b;
                    15'd72: toneL = `b;     15'd73: toneL = `b;
                    15'd74: toneL = `b;     15'd75: toneL = `b;
                    15'd76: toneL = `b;     15'd77: toneL = `b;
                    15'd78: toneL = `b;     15'd79: toneL = `b;
                    15'd80: toneL = `b;     15'd81: toneL = `b;
                    15'd82: toneL = `b;     15'd83: toneL = `b;
                    15'd84: toneL = `b;     15'd85: toneL = `b;
                    15'd86: toneL = `b;     15'd87: toneL = `b;
                    15'd88: toneL = `b;     15'd89: toneL = `b;
                    15'd90: toneL = `b;     15'd91: toneL = `b;
                    15'd92: toneL = `b;     15'd93: toneL = `b;
                    15'd94: toneL = `b;     15'd95: toneL = `b;
                    15'd96: toneL = `rf;     15'd97: toneL = `rf;
                    15'd98: toneL = `rf;     15'd99: toneL = `rf;
                    15'd100: toneL = `rf;     15'd101: toneL = `rf;
                    15'd102: toneL = `rf;     15'd103: toneL = `rf;
                    15'd104: toneL = `rf;     15'd105: toneL = `rf;
                    15'd106: toneL = `rf;     15'd107: toneL = `rf;
                    15'd108: toneL = `rf;     15'd109: toneL = `rf;
                    15'd110: toneL = `rf;     15'd111: toneL = `rf;
                    15'd112: toneL = `rf;     15'd113: toneL = `rf;
                    15'd114: toneL = `rf;     15'd115: toneL = `rf;
                    15'd116: toneL = `rf;     15'd117: toneL = `rf;
                    15'd118: toneL = `rf;     15'd119: toneL = `rf;
                    15'd120: toneL = `rf;     15'd121: toneL = `rf;
                    15'd122: toneL = `rf;     15'd123: toneL = `rf;
                    15'd124: toneL = `rf;     15'd125: toneL = `rf;
                    15'd126: toneL = `rf;     15'd127: toneL = `rf;
                    15'd128: toneL = `g;     15'd129: toneL = `g;
                    15'd130: toneL = `g;     15'd131: toneL = `g;
                    15'd132: toneL = `g;     15'd133: toneL = `g;
                    15'd134: toneL = `g;     15'd135: toneL = `g;
                    15'd136: toneL = `g;     15'd137: toneL = `g;
                    15'd138: toneL = `g;     15'd139: toneL = `g;
                    15'd140: toneL = `g;     15'd141: toneL = `g;
                    15'd142: toneL = `g;     15'd143: toneL = `g;
                    15'd144: toneL = `g;     15'd145: toneL = `g;
                    15'd146: toneL = `g;     15'd147: toneL = `g;
                    15'd148: toneL = `g;     15'd149: toneL = `g;
                    15'd150: toneL = `g;     15'd151: toneL = `g;
                    15'd152: toneL = `g;     15'd153: toneL = `g;
                    15'd154: toneL = `g;     15'd155: toneL = `g;
                    15'd156: toneL = `g;     15'd157: toneL = `g;
                    15'd158: toneL = `g;     15'd159: toneL = `g;
                    15'd160: toneL = `d;     15'd161: toneL = `d;
                    15'd162: toneL = `d;     15'd163: toneL = `d;
                    15'd164: toneL = `d;     15'd165: toneL = `d;
                    15'd166: toneL = `d;     15'd167: toneL = `d;
                    15'd168: toneL = `d;     15'd169: toneL = `d;
                    15'd170: toneL = `d;     15'd171: toneL = `d;
                    15'd172: toneL = `d;     15'd173: toneL = `d;
                    15'd174: toneL = `d;     15'd175: toneL = `d;
                    15'd176: toneL = `d;     15'd177: toneL = `d;
                    15'd178: toneL = `d;     15'd179: toneL = `d;
                    15'd180: toneL = `d;     15'd181: toneL = `d;
                    15'd182: toneL = `d;     15'd183: toneL = `d;
                    15'd184: toneL = `d;     15'd185: toneL = `d;
                    15'd186: toneL = `d;     15'd187: toneL = `d;
                    15'd188: toneL = `d;     15'd189: toneL = `d;
                    15'd190: toneL = `d;     15'd191: toneL = `d;
                    15'd192: toneL = `g;     15'd193: toneL = `g;
                    15'd194: toneL = `g;     15'd195: toneL = `g;
                    15'd196: toneL = `g;     15'd197: toneL = `g;
                    15'd198: toneL = `g;     15'd199: toneL = `g;
                    15'd200: toneL = `g;     15'd201: toneL = `g;
                    15'd202: toneL = `g;     15'd203: toneL = `g;
                    15'd204: toneL = `g;     15'd205: toneL = `g;
                    15'd206: toneL = `g;     15'd207: toneL = `g;
                    15'd208: toneL = `g;     15'd209: toneL = `g;
                    15'd210: toneL = `g;     15'd211: toneL = `g;
                    15'd212: toneL = `g;     15'd213: toneL = `g;
                    15'd214: toneL = `g;     15'd215: toneL = `g;
                    15'd216: toneL = `g;     15'd217: toneL = `g;
                    15'd218: toneL = `g;     15'd219: toneL = `g;
                    15'd220: toneL = `g;     15'd221: toneL = `g;
                    15'd222: toneL = `g;     15'd223: toneL = `g;
                    15'd224: toneL = `a;     15'd225: toneL = `a;
                    15'd226: toneL = `a;     15'd227: toneL = `a;
                    15'd228: toneL = `a;     15'd229: toneL = `a;
                    15'd230: toneL = `a;     15'd231: toneL = `a;
                    15'd232: toneL = `a;     15'd233: toneL = `a;
                    15'd234: toneL = `a;     15'd235: toneL = `a;
                    15'd236: toneL = `a;     15'd237: toneL = `a;
                    15'd238: toneL = `a;     15'd239: toneL = `a;
                    15'd240: toneL = `a;     15'd241: toneL = `a;
                    15'd242: toneL = `a;     15'd243: toneL = `a;
                    15'd244: toneL = `a;     15'd245: toneL = `a;
                    15'd246: toneL = `a;     15'd247: toneL = `a;
                    15'd248: toneL = `a;     15'd249: toneL = `a;
                    15'd250: toneL = `a;     15'd251: toneL = `a;
                    15'd252: toneL = `a;     15'd253: toneL = `a;
                    15'd254: toneL = `a;     15'd255: toneL = `a;
                    15'd256: toneL = `ha;     15'd257: toneL = `ha;
                    15'd258: toneL = `ha;     15'd259: toneL = `ha;
                    15'd260: toneL = `ha;     15'd261: toneL = `ha;
                    15'd262: toneL = `ha;     15'd263: toneL = `ha;
                    15'd264: toneL = `rhf;     15'd265: toneL = `rhf;
                    15'd266: toneL = `rhf;     15'd267: toneL = `rhf;
                    15'd268: toneL = `hg;     15'd269: toneL = `hg;
                    15'd270: toneL = `hg;     15'd271: toneL = `hg;
                    15'd272: toneL = `ha;     15'd273: toneL = `ha;
                    15'd274: toneL = `ha;     15'd275: toneL = `ha;
                    15'd276: toneL = `ha;     15'd277: toneL = `ha;
                    15'd278: toneL = `ha;     15'd279: toneL = `ha;
                    15'd280: toneL = `rhf;     15'd281: toneL = `rhf;
                    15'd282: toneL = `rhf;     15'd283: toneL = `rhf;
                    15'd284: toneL = `hg;     15'd285: toneL = `hg;
                    15'd286: toneL = `hg;     15'd287: toneL = `hg;
                    15'd288: toneL = `ha;     15'd289: toneL = `ha;
                    15'd290: toneL = `ha;     15'd291: toneL = `ha;
                    15'd292: toneL = `a;     15'd293: toneL = `a;
                    15'd294: toneL = `a;     15'd295: toneL = `a;
                    15'd296: toneL = `b;     15'd297: toneL = `b;
                    15'd298: toneL = `b;     15'd299: toneL = `b;
                    15'd300: toneL = `rhc;     15'd301: toneL = `rhc;
                    15'd302: toneL = `rhc;     15'd303: toneL = `rhc;
                    15'd304: toneL = `hd;     15'd305: toneL = `hd;
                    15'd306: toneL = `hd;     15'd307: toneL = `hd;
                    15'd308: toneL = `he;     15'd309: toneL = `he;
                    15'd310: toneL = `he;     15'd311: toneL = `he;
                    15'd312: toneL = `rhf;     15'd313: toneL = `rhf;
                    15'd314: toneL = `rhf;     15'd315: toneL = `rhf;
                    15'd316: toneL = `hg;     15'd317: toneL = `hg;
                    15'd318: toneL = `hg;     15'd319: toneL = `hg;
                    default: toneL = `sil;
                endcase
            end
            else begin
                case(ibeatNum)
                    15'd0: toneL = `hc;     15'd1: toneL = `hc;
                    15'd2: toneL = `hc;     15'd3: toneL = `hc;
                    15'd4: toneL = `hc;     15'd5: toneL = `hc;
                    15'd6: toneL = `hc;     15'd7: toneL = `hc;
                    15'd8: toneL = `hc;     15'd9: toneL = `hc;
                    15'd10: toneL = `hc;     15'd11: toneL = `hc;
                    15'd12: toneL = `hc;     15'd13: toneL = `hc;
                    15'd14: toneL = `hc;     15'd15: toneL = `hc;
                    15'd16: toneL = `hc;     15'd17: toneL = `hc;
                    15'd18: toneL = `hc;     15'd19: toneL = `hc;
                    15'd20: toneL = `hc;     15'd21: toneL = `hc;
                    15'd22: toneL = `hc;     15'd23: toneL = `hc;
                    15'd24: toneL = `hc;     15'd25: toneL = `hc;
                    15'd26: toneL = `hc;     15'd27: toneL = `hc;
                    15'd28: toneL = `hc;     15'd29: toneL = `hc;
                    15'd30: toneL = `hc;     15'd31: toneL = `hc;
                    15'd32: toneL = `g;     15'd33: toneL = `g;
                    15'd34: toneL = `g;     15'd35: toneL = `g;
                    15'd36: toneL = `g;     15'd37: toneL = `g;
                    15'd38: toneL = `g;     15'd39: toneL = `g;
                    15'd40: toneL = `g;     15'd41: toneL = `g;
                    15'd42: toneL = `g;     15'd43: toneL = `g;
                    15'd44: toneL = `g;     15'd45: toneL = `g;
                    15'd46: toneL = `g;     15'd47: toneL = `g;
                    15'd48: toneL = `g;     15'd49: toneL = `g;
                    15'd50: toneL = `g;     15'd51: toneL = `g;
                    15'd52: toneL = `g;     15'd53: toneL = `g;
                    15'd54: toneL = `g;     15'd55: toneL = `g;
                    15'd56: toneL = `g;     15'd57: toneL = `g;
                    15'd58: toneL = `g;     15'd59: toneL = `g;
                    15'd60: toneL = `g;     15'd61: toneL = `g;
                    15'd62: toneL = `g;     15'd63: toneL = `g;
                    15'd64: toneL = `hc;     15'd65: toneL = `hc;
                    15'd66: toneL = `hc;     15'd67: toneL = `hc;
                    15'd68: toneL = `hc;     15'd69: toneL = `hc;
                    15'd70: toneL = `hc;     15'd71: toneL = `hc;
                    15'd72: toneL = `hc;     15'd73: toneL = `hc;
                    15'd74: toneL = `hc;     15'd75: toneL = `hc;
                    15'd76: toneL = `hc;     15'd77: toneL = `hc;
                    15'd78: toneL = `hc;     15'd79: toneL = `hc;
                    15'd80: toneL = `hc;     15'd81: toneL = `hc;
                    15'd82: toneL = `hc;     15'd83: toneL = `hc;
                    15'd84: toneL = `hc;     15'd85: toneL = `hc;
                    15'd86: toneL = `hc;     15'd87: toneL = `hc;
                    15'd88: toneL = `hc;     15'd89: toneL = `hc;
                    15'd90: toneL = `hc;     15'd91: toneL = `hc;
                    15'd92: toneL = `hc;     15'd93: toneL = `hc;
                    15'd94: toneL = `hc;     15'd95: toneL = `hc;
                    15'd96: toneL = `g;     15'd97: toneL = `g;
                    15'd98: toneL = `g;     15'd99: toneL = `g;
                    15'd100: toneL = `g;     15'd101: toneL = `g;
                    15'd102: toneL = `g;     15'd103: toneL = `g;
                    15'd104: toneL = `g;     15'd105: toneL = `g;
                    15'd106: toneL = `g;     15'd107: toneL = `g;
                    15'd108: toneL = `g;     15'd109: toneL = `g;
                    15'd110: toneL = `g;     15'd111: toneL = `g;
                    15'd112: toneL = `g;     15'd113: toneL = `g;
                    15'd114: toneL = `g;     15'd115: toneL = `g;
                    15'd116: toneL = `g;     15'd117: toneL = `g;
                    15'd118: toneL = `g;     15'd119: toneL = `g;
                    15'd120: toneL = `g;     15'd121: toneL = `g;
                    15'd122: toneL = `g;     15'd123: toneL = `g;
                    15'd124: toneL = `g;     15'd125: toneL = `g;
                    15'd126: toneL = `g;     15'd127: toneL = `g;
                    15'd128: toneL = `c;     15'd129: toneL = `c;
                    15'd130: toneL = `c;     15'd131: toneL = `c;
                    15'd132: toneL = `c;     15'd133: toneL = `c;
                    15'd134: toneL = `c;     15'd135: toneL = `c;
                    15'd136: toneL = `c;     15'd137: toneL = `c;
                    15'd138: toneL = `c;     15'd139: toneL = `c;
                    15'd140: toneL = `c;     15'd141: toneL = `c;
                    15'd142: toneL = `c;     15'd143: toneL = `c;
                    15'd144: toneL = `d;     15'd145: toneL = `d;
                    15'd146: toneL = `d;     15'd147: toneL = `d;
                    15'd148: toneL = `d;     15'd149: toneL = `d;
                    15'd150: toneL = `d;     15'd151: toneL = `d;
                    15'd152: toneL = `d;     15'd153: toneL = `d;
                    15'd154: toneL = `d;     15'd155: toneL = `d;
                    15'd156: toneL = `d;     15'd157: toneL = `d;
                    15'd158: toneL = `d;     15'd159: toneL = `d;
                    15'd160: toneL = `e;     15'd161: toneL = `e;
                    15'd162: toneL = `e;     15'd163: toneL = `e;
                    15'd164: toneL = `e;     15'd165: toneL = `e;
                    15'd166: toneL = `e;     15'd167: toneL = `e;
                    15'd168: toneL = `e;     15'd169: toneL = `e;
                    15'd170: toneL = `e;     15'd171: toneL = `e;
                    15'd172: toneL = `e;     15'd173: toneL = `e;
                    15'd174: toneL = `e;     15'd175: toneL = `e;
                    15'd176: toneL = `e;     15'd177: toneL = `e;
                    15'd178: toneL = `e;     15'd179: toneL = `e;
                    15'd180: toneL = `e;     15'd181: toneL = `e;
                    15'd182: toneL = `e;     15'd183: toneL = `e;
                    15'd184: toneL = `e;     15'd185: toneL = `e;
                    15'd186: toneL = `e;     15'd187: toneL = `e;
                    15'd188: toneL = `e;     15'd189: toneL = `e;
                    15'd190: toneL = `e;     15'd191: toneL = `e;
                    15'd192: toneL = `c;     15'd193: toneL = `c;
                    15'd194: toneL = `c;     15'd195: toneL = `c;
                    15'd196: toneL = `c;     15'd197: toneL = `c;
                    15'd198: toneL = `c;     15'd199: toneL = `c;
                    15'd200: toneL = `c;     15'd201: toneL = `c;
                    15'd202: toneL = `c;     15'd203: toneL = `c;
                    15'd204: toneL = `c;     15'd205: toneL = `c;
                    15'd206: toneL = `c;     15'd207: toneL = `c;
                    15'd208: toneL = `d;     15'd209: toneL = `d;
                    15'd210: toneL = `d;     15'd211: toneL = `d;
                    15'd212: toneL = `d;     15'd213: toneL = `d;
                    15'd214: toneL = `d;     15'd215: toneL = `d;
                    15'd216: toneL = `d;     15'd217: toneL = `d;
                    15'd218: toneL = `d;     15'd219: toneL = `d;
                    15'd220: toneL = `d;     15'd221: toneL = `d;
                    15'd222: toneL = `d;     15'd223: toneL = `d;
                    15'd224: toneL = `e;     15'd225: toneL = `e;
                    15'd226: toneL = `e;     15'd227: toneL = `e;
                    15'd228: toneL = `e;     15'd229: toneL = `e;
                    15'd230: toneL = `e;     15'd231: toneL = `e;
                    15'd232: toneL = `e;     15'd233: toneL = `e;
                    15'd234: toneL = `e;     15'd235: toneL = `e;
                    15'd236: toneL = `e;     15'd237: toneL = `e;
                    15'd238: toneL = `e;     15'd239: toneL = `e;
                    15'd240: toneL = `e;     15'd241: toneL = `e;
                    15'd242: toneL = `e;     15'd243: toneL = `e;
                    15'd244: toneL = `e;     15'd245: toneL = `e;
                    15'd246: toneL = `e;     15'd247: toneL = `e;
                    15'd248: toneL = `e;     15'd249: toneL = `e;
                    15'd250: toneL = `e;     15'd251: toneL = `e;
                    15'd252: toneL = `e;     15'd253: toneL = `e;
                    15'd254: toneL = `e;     15'd255: toneL = `e;
                    15'd256: toneL = `e;     15'd257: toneL = `e;
                    15'd258: toneL = `e;     15'd259: toneL = `e;
                    15'd260: toneL = `e;     15'd261: toneL = `e;
                    15'd262: toneL = `e;     15'd263: toneL = `e;
                    15'd264: toneL = `e;     15'd265: toneL = `e;
                    15'd266: toneL = `e;     15'd267: toneL = `e;
                    15'd268: toneL = `e;     15'd269: toneL = `e;
                    15'd270: toneL = `e;     15'd271: toneL = `e;
                    15'd272: toneL = `f;     15'd273: toneL = `f;
                    15'd274: toneL = `f;     15'd275: toneL = `f;
                    15'd276: toneL = `f;     15'd277: toneL = `f;
                    15'd278: toneL = `f;     15'd279: toneL = `f;
                    15'd280: toneL = `f;     15'd281: toneL = `f;
                    15'd282: toneL = `f;     15'd283: toneL = `f;
                    15'd284: toneL = `f;     15'd285: toneL = `f;
                    15'd286: toneL = `f;     15'd287: toneL = `f;
                    15'd288: toneL = `g;     15'd289: toneL = `g;
                    15'd290: toneL = `g;     15'd291: toneL = `g;
                    15'd292: toneL = `g;     15'd293: toneL = `g;
                    15'd294: toneL = `g;     15'd295: toneL = `g;
                    15'd296: toneL = `g;     15'd297: toneL = `g;
                    15'd298: toneL = `g;     15'd299: toneL = `g;
                    15'd300: toneL = `g;     15'd301: toneL = `g;
                    15'd302: toneL = `g;     15'd303: toneL = `g;
                    15'd304: toneL = `g;     15'd305: toneL = `g;
                    15'd306: toneL = `g;     15'd307: toneL = `g;
                    15'd308: toneL = `g;     15'd309: toneL = `g;
                    15'd310: toneL = `g;     15'd311: toneL = `g;
                    15'd312: toneL = `g;     15'd313: toneL = `g;
                    15'd314: toneL = `g;     15'd315: toneL = `g;
                    15'd316: toneL = `g;     15'd317: toneL = `g;
                    15'd318: toneL = `g;     15'd319: toneL = `g;
                    15'd320: toneL = `e;     15'd321: toneL = `e;
                    15'd322: toneL = `e;     15'd323: toneL = `e;
                    15'd324: toneL = `e;     15'd325: toneL = `e;
                    15'd326: toneL = `e;     15'd327: toneL = `e;
                    15'd328: toneL = `e;     15'd329: toneL = `e;
                    15'd330: toneL = `e;     15'd331: toneL = `e;
                    15'd332: toneL = `e;     15'd333: toneL = `e;
                    15'd334: toneL = `e;     15'd335: toneL = `e;
                    15'd336: toneL = `f;     15'd337: toneL = `f;
                    15'd338: toneL = `f;     15'd339: toneL = `f;
                    15'd340: toneL = `f;     15'd341: toneL = `f;
                    15'd342: toneL = `f;     15'd343: toneL = `f;
                    15'd344: toneL = `f;     15'd345: toneL = `f;
                    15'd346: toneL = `f;     15'd347: toneL = `f;
                    15'd348: toneL = `f;     15'd349: toneL = `f;
                    15'd350: toneL = `f;     15'd351: toneL = `f;
                    15'd352: toneL = `g;     15'd353: toneL = `g;
                    15'd354: toneL = `g;     15'd355: toneL = `g;
                    15'd356: toneL = `g;     15'd357: toneL = `g;
                    15'd358: toneL = `g;     15'd359: toneL = `g;
                    15'd360: toneL = `g;     15'd361: toneL = `g;
                    15'd362: toneL = `g;     15'd363: toneL = `g;
                    15'd364: toneL = `g;     15'd365: toneL = `g;
                    15'd366: toneL = `g;     15'd367: toneL = `g;
                    15'd368: toneL = `g;     15'd369: toneL = `g;
                    15'd370: toneL = `g;     15'd371: toneL = `g;
                    15'd372: toneL = `g;     15'd373: toneL = `g;
                    15'd374: toneL = `g;     15'd375: toneL = `g;
                    15'd376: toneL = `sil;     15'd377: toneL = `sil;
                    15'd378: toneL = `g;     15'd379: toneL = `g;
                    15'd380: toneL = `g;     15'd381: toneL = `g;
                    15'd382: toneL = `g;     15'd383: toneL = `g;
                    15'd384: toneL = `g;     15'd385: toneL = `g;
                    15'd386: toneL = `g;     15'd387: toneL = `g;
                    15'd388: toneL = `g;     15'd389: toneL = `g;
                    15'd390: toneL = `g;     15'd391: toneL = `g;
                    15'd392: toneL = `g;     15'd393: toneL = `g;
                    15'd394: toneL = `g;     15'd395: toneL = `g;
                    15'd396: toneL = `g;     15'd397: toneL = `g;
                    15'd398: toneL = `g;     15'd399: toneL = `g;
                    15'd400: toneL = `g;     15'd401: toneL = `g;
                    15'd402: toneL = `g;     15'd403: toneL = `g;
                    15'd404: toneL = `g;     15'd405: toneL = `g;
                    15'd406: toneL = `g;     15'd407: toneL = `g;
                    15'd408: toneL = `g;     15'd409: toneL = `g;
                    15'd410: toneL = `g;     15'd411: toneL = `g;
                    15'd412: toneL = `g;     15'd413: toneL = `g;
                    15'd414: toneL = `g;     15'd415: toneL = `g;
                    15'd416: toneL = `e;     15'd417: toneL = `e;
                    15'd418: toneL = `e;     15'd419: toneL = `e;
                    15'd420: toneL = `e;     15'd421: toneL = `e;
                    15'd422: toneL = `e;     15'd423: toneL = `e;
                    15'd424: toneL = `e;     15'd425: toneL = `e;
                    15'd426: toneL = `e;     15'd427: toneL = `e;
                    15'd428: toneL = `e;     15'd429: toneL = `e;
                    15'd430: toneL = `e;     15'd431: toneL = `e;
                    15'd432: toneL = `e;     15'd433: toneL = `e;
                    15'd434: toneL = `e;     15'd435: toneL = `e;
                    15'd436: toneL = `e;     15'd437: toneL = `e;
                    15'd438: toneL = `e;     15'd439: toneL = `e;
                    15'd440: toneL = `e;     15'd441: toneL = `e;
                    15'd442: toneL = `e;     15'd443: toneL = `e;
                    15'd444: toneL = `e;     15'd445: toneL = `e;
                    15'd446: toneL = `e;     15'd447: toneL = `e;
                    15'd448: toneL = `g;     15'd449: toneL = `g;
                    15'd450: toneL = `g;     15'd451: toneL = `g;
                    15'd452: toneL = `g;     15'd453: toneL = `g;
                    15'd454: toneL = `g;     15'd455: toneL = `g;
                    15'd456: toneL = `g;     15'd457: toneL = `g;
                    15'd458: toneL = `g;     15'd459: toneL = `g;
                    15'd460: toneL = `g;     15'd461: toneL = `g;
                    15'd462: toneL = `g;     15'd463: toneL = `g;
                    15'd464: toneL = `g;     15'd465: toneL = `g;
                    15'd466: toneL = `g;     15'd467: toneL = `g;
                    15'd468: toneL = `g;     15'd469: toneL = `g;
                    15'd470: toneL = `g;     15'd471: toneL = `g;
                    15'd472: toneL = `g;     15'd473: toneL = `g;
                    15'd474: toneL = `g;     15'd475: toneL = `g;
                    15'd476: toneL = `g;     15'd477: toneL = `g;
                    15'd478: toneL = `g;     15'd479: toneL = `g;
                    15'd480: toneL = `e;     15'd481: toneL = `e;
                    15'd482: toneL = `e;     15'd483: toneL = `e;
                    15'd484: toneL = `e;     15'd485: toneL = `e;
                    15'd486: toneL = `e;     15'd487: toneL = `e;
                    15'd488: toneL = `e;     15'd489: toneL = `e;
                    15'd490: toneL = `e;     15'd491: toneL = `e;
                    15'd492: toneL = `e;     15'd493: toneL = `e;
                    15'd494: toneL = `e;     15'd495: toneL = `e;
                    15'd496: toneL = `e;     15'd497: toneL = `e;
                    15'd498: toneL = `e;     15'd499: toneL = `e;
                    15'd500: toneL = `e;     15'd501: toneL = `e;
                    15'd502: toneL = `e;     15'd503: toneL = `e;
                    15'd504: toneL = `e;     15'd505: toneL = `e;
                    15'd506: toneL = `e;     15'd507: toneL = `e;
                    15'd508: toneL = `e;     15'd509: toneL = `e;
                    15'd510: toneL = `e;     15'd511: toneL = `e;
                    default: toneL = `sil;
                endcase
            end
            //case(ibeatNum)
                // 12'd0: toneL = `hc;  	12'd1: toneL = `hc; // HC (two-beat)
                // 12'd2: toneL = `hc;  	12'd3: toneL = `hc;
                // 12'd4: toneL = `hc;	    12'd5: toneL = `hc;
                // 12'd6: toneL = `hc;  	12'd7: toneL = `hc;
                // 12'd8: toneL = `hc;	    12'd9: toneL = `hc;
                // 12'd10: toneL = `hc;	12'd11: toneL = `hc;
                // 12'd12: toneL = `hc;	12'd13: toneL = `hc;
                // 12'd14: toneL = `hc;	12'd15: toneL = `hc;

                // 12'd16: toneL = `hc;	12'd17: toneL = `hc;
                // 12'd18: toneL = `hc;	12'd19: toneL = `hc;
                // 12'd20: toneL = `hc;	12'd21: toneL = `hc;
                // 12'd22: toneL = `hc;	12'd23: toneL = `hc;
                // 12'd24: toneL = `hc;	12'd25: toneL = `hc;
                // 12'd26: toneL = `hc;	12'd27: toneL = `hc;
                // 12'd28: toneL = `hc;	12'd29: toneL = `hc;
                // 12'd30: toneL = `hc;	12'd31: toneL = `hc;

                // 12'd32: toneL = `g;	    12'd33: toneL = `g; // G (one-beat)
                // 12'd34: toneL = `g;	    12'd35: toneL = `g;
                // 12'd36: toneL = `g;	    12'd37: toneL = `g;
                // 12'd38: toneL = `g;	    12'd39: toneL = `g;
                // 12'd40: toneL = `g;	    12'd41: toneL = `g;
                // 12'd42: toneL = `g;	    12'd43: toneL = `g;
                // 12'd44: toneL = `g;	    12'd45: toneL = `g;
                // 12'd46: toneL = `g;	    12'd47: toneL = `g;

                // 12'd48: toneL = `b;	    12'd49: toneL = `b; // B (one-beat)
                // 12'd50: toneL = `b;	    12'd51: toneL = `b;
                // 12'd52: toneL = `b;	    12'd53: toneL = `b;
                // 12'd54: toneL = `b;	    12'd55: toneL = `b;
                // 12'd56: toneL = `b;	    12'd57: toneL = `b;
                // 12'd58: toneL = `b;	    12'd59: toneL = `b;
                // 12'd60: toneL = `b;	    12'd61: toneL = `b;
                // 12'd62: toneL = `b;	    12'd63: toneL = `b;

                // 12'd64: toneL = `hc;	    12'd65: toneL = `hc; // HC (two-beat)
                // 12'd66: toneL = `hc;	    12'd67: toneL = `hc;
                // 12'd68: toneL = `hc;	    12'd69: toneL = `hc;
                // 12'd70: toneL = `hc;	    12'd71: toneL = `hc;
                // 12'd72: toneL = `hc;	    12'd73: toneL = `hc;
                // 12'd74: toneL = `hc;	    12'd75: toneL = `hc;
                // 12'd76: toneL = `hc;	    12'd77: toneL = `hc;
                // 12'd78: toneL = `hc;	    12'd79: toneL = `hc;

                // 12'd80: toneL = `hc;	    12'd81: toneL = `hc;
                // 12'd82: toneL = `hc;	    12'd83: toneL = `hc;
                // 12'd84: toneL = `hc;	    12'd85: toneL = `hc;
                // 12'd86: toneL = `hc;	    12'd87: toneL = `hc;
                // 12'd88: toneL = `hc;	    12'd89: toneL = `hc;
                // 12'd90: toneL = `hc;	    12'd91: toneL = `hc;
                // 12'd92: toneL = `hc;	    12'd93: toneL = `hc;
                // 12'd94: toneL = `hc;	    12'd95: toneL = `hc;

                // 12'd96: toneL = `g;	    12'd97: toneL = `g; // G (one-beat)
                // 12'd98: toneL = `g; 	12'd99: toneL = `g;
                // 12'd100: toneL = `g;	12'd101: toneL = `g;
                // 12'd102: toneL = `g;	12'd103: toneL = `g;
                // 12'd104: toneL = `g;	12'd105: toneL = `g;
                // 12'd106: toneL = `g;	12'd107: toneL = `g;
                // 12'd108: toneL = `g;	12'd109: toneL = `g;
                // 12'd110: toneL = `g;	12'd111: toneL = `g;

                // 12'd112: toneL = `b;	12'd113: toneL = `b; // B (one-beat)
                // 12'd114: toneL = `b;	12'd115: toneL = `b;
                // 12'd116: toneL = `b;	12'd117: toneL = `b;
                // 12'd118: toneL = `b;	12'd119: toneL = `b;
                // 12'd120: toneL = `b;	12'd121: toneL = `b;
                // 12'd122: toneL = `b;	12'd123: toneL = `b;
                // 12'd124: toneL = `b;	12'd125: toneL = `b;
                // 12'd126: toneL = `b;	12'd127: toneL = `b;
                // 15'd0: toneL = `hd;     15'd1: toneL = `hd;
                //     15'd2: toneL = `hd;     15'd3: toneL = `hd;
                //     15'd4: toneL = `hd;     15'd5: toneL = `hd;
                //     15'd6: toneL = `hd;     15'd7: toneL = `hd;
                //     15'd8: toneL = `hd;     15'd9: toneL = `hd;
                //     15'd10: toneL = `hd;     15'd11: toneL = `hd;
                //     15'd12: toneL = `hd;     15'd13: toneL = `hd;
                //     15'd14: toneL = `hd;     15'd15: toneL = `hd;
                //     15'd16: toneL = `hd;     15'd17: toneL = `hd;
                //     15'd18: toneL = `hd;     15'd19: toneL = `hd;
                //     15'd20: toneL = `hd;     15'd21: toneL = `hd;
                //     15'd22: toneL = `hd;     15'd23: toneL = `hd;
                //     15'd24: toneL = `hd;     15'd25: toneL = `hd;
                //     15'd26: toneL = `hd;     15'd27: toneL = `hd;
                //     15'd28: toneL = `hd;     15'd29: toneL = `hd;
                //     15'd30: toneL = `hd;     15'd31: toneL = `hd;
                //     15'd32: toneL = `a;     15'd33: toneL = `a;
                //     15'd34: toneL = `a;     15'd35: toneL = `a;
                //     15'd36: toneL = `a;     15'd37: toneL = `a;
                //     15'd38: toneL = `a;     15'd39: toneL = `a;
                //     15'd40: toneL = `a;     15'd41: toneL = `a;
                //     15'd42: toneL = `a;     15'd43: toneL = `a;
                //     15'd44: toneL = `a;     15'd45: toneL = `a;
                //     15'd46: toneL = `a;     15'd47: toneL = `a;
                //     15'd48: toneL = `a;     15'd49: toneL = `a;
                //     15'd50: toneL = `a;     15'd51: toneL = `a;
                //     15'd52: toneL = `a;     15'd53: toneL = `a;
                //     15'd54: toneL = `a;     15'd55: toneL = `a;
                //     15'd56: toneL = `a;     15'd57: toneL = `a;
                //     15'd58: toneL = `a;     15'd59: toneL = `a;
                //     15'd60: toneL = `a;     15'd61: toneL = `a;
                //     15'd62: toneL = `a;     15'd63: toneL = `a;
                //     15'd64: toneL = `b;     15'd65: toneL = `b;
                //     15'd66: toneL = `b;     15'd67: toneL = `b;
                //     15'd68: toneL = `b;     15'd69: toneL = `b;
                //     15'd70: toneL = `b;     15'd71: toneL = `b;
                //     15'd72: toneL = `b;     15'd73: toneL = `b;
                //     15'd74: toneL = `b;     15'd75: toneL = `b;
                //     15'd76: toneL = `b;     15'd77: toneL = `b;
                //     15'd78: toneL = `b;     15'd79: toneL = `b;
                //     15'd80: toneL = `b;     15'd81: toneL = `b;
                //     15'd82: toneL = `b;     15'd83: toneL = `b;
                //     15'd84: toneL = `b;     15'd85: toneL = `b;
                //     15'd86: toneL = `b;     15'd87: toneL = `b;
                //     15'd88: toneL = `b;     15'd89: toneL = `b;
                //     15'd90: toneL = `b;     15'd91: toneL = `b;
                //     15'd92: toneL = `b;     15'd93: toneL = `b;
                //     15'd94: toneL = `b;     15'd95: toneL = `b;
                //     15'd96: toneL = `rf;     15'd97: toneL = `rf;
                //     15'd98: toneL = `rf;     15'd99: toneL = `rf;
                //     15'd100: toneL = `rf;     15'd101: toneL = `rf;
                //     15'd102: toneL = `rf;     15'd103: toneL = `rf;
                //     15'd104: toneL = `rf;     15'd105: toneL = `rf;
                //     15'd106: toneL = `rf;     15'd107: toneL = `rf;
                //     15'd108: toneL = `rf;     15'd109: toneL = `rf;
                //     15'd110: toneL = `rf;     15'd111: toneL = `rf;
                //     15'd112: toneL = `rf;     15'd113: toneL = `rf;
                //     15'd114: toneL = `rf;     15'd115: toneL = `rf;
                //     15'd116: toneL = `rf;     15'd117: toneL = `rf;
                //     15'd118: toneL = `rf;     15'd119: toneL = `rf;
                //     15'd120: toneL = `rf;     15'd121: toneL = `rf;
                //     15'd122: toneL = `rf;     15'd123: toneL = `rf;
                //     15'd124: toneL = `rf;     15'd125: toneL = `rf;
                //     15'd126: toneL = `rf;     15'd127: toneL = `rf;
                //     15'd128: toneL = `g;     15'd129: toneL = `g;
                //     15'd130: toneL = `g;     15'd131: toneL = `g;
                //     15'd132: toneL = `g;     15'd133: toneL = `g;
                //     15'd134: toneL = `g;     15'd135: toneL = `g;
                //     15'd136: toneL = `g;     15'd137: toneL = `g;
                //     15'd138: toneL = `g;     15'd139: toneL = `g;
                //     15'd140: toneL = `g;     15'd141: toneL = `g;
                //     15'd142: toneL = `g;     15'd143: toneL = `g;
                //     15'd144: toneL = `g;     15'd145: toneL = `g;
                //     15'd146: toneL = `g;     15'd147: toneL = `g;
                //     15'd148: toneL = `g;     15'd149: toneL = `g;
                //     15'd150: toneL = `g;     15'd151: toneL = `g;
                //     15'd152: toneL = `g;     15'd153: toneL = `g;
                //     15'd154: toneL = `g;     15'd155: toneL = `g;
                //     15'd156: toneL = `g;     15'd157: toneL = `g;
                //     15'd158: toneL = `g;     15'd159: toneL = `g;
                //     15'd160: toneL = `d;     15'd161: toneL = `d;
                //     15'd162: toneL = `d;     15'd163: toneL = `d;
                //     15'd164: toneL = `d;     15'd165: toneL = `d;
                //     15'd166: toneL = `d;     15'd167: toneL = `d;
                //     15'd168: toneL = `d;     15'd169: toneL = `d;
                //     15'd170: toneL = `d;     15'd171: toneL = `d;
                //     15'd172: toneL = `d;     15'd173: toneL = `d;
                //     15'd174: toneL = `d;     15'd175: toneL = `d;
                //     15'd176: toneL = `d;     15'd177: toneL = `d;
                //     15'd178: toneL = `d;     15'd179: toneL = `d;
                //     15'd180: toneL = `d;     15'd181: toneL = `d;
                //     15'd182: toneL = `d;     15'd183: toneL = `d;
                //     15'd184: toneL = `d;     15'd185: toneL = `d;
                //     15'd186: toneL = `d;     15'd187: toneL = `d;
                //     15'd188: toneL = `d;     15'd189: toneL = `d;
                //     15'd190: toneL = `d;     15'd191: toneL = `d;
                //     15'd192: toneL = `g;     15'd193: toneL = `g;
                //     15'd194: toneL = `g;     15'd195: toneL = `g;
                //     15'd196: toneL = `g;     15'd197: toneL = `g;
                //     15'd198: toneL = `g;     15'd199: toneL = `g;
                //     15'd200: toneL = `g;     15'd201: toneL = `g;
                //     15'd202: toneL = `g;     15'd203: toneL = `g;
                //     15'd204: toneL = `g;     15'd205: toneL = `g;
                //     15'd206: toneL = `g;     15'd207: toneL = `g;
                //     15'd208: toneL = `g;     15'd209: toneL = `g;
                //     15'd210: toneL = `g;     15'd211: toneL = `g;
                //     15'd212: toneL = `g;     15'd213: toneL = `g;
                //     15'd214: toneL = `g;     15'd215: toneL = `g;
                //     15'd216: toneL = `g;     15'd217: toneL = `g;
                //     15'd218: toneL = `g;     15'd219: toneL = `g;
                //     15'd220: toneL = `g;     15'd221: toneL = `g;
                //     15'd222: toneL = `g;     15'd223: toneL = `g;
                //     15'd224: toneL = `a;     15'd225: toneL = `a;
                //     15'd226: toneL = `a;     15'd227: toneL = `a;
                //     15'd228: toneL = `a;     15'd229: toneL = `a;
                //     15'd230: toneL = `a;     15'd231: toneL = `a;
                //     15'd232: toneL = `a;     15'd233: toneL = `a;
                //     15'd234: toneL = `a;     15'd235: toneL = `a;
                //     15'd236: toneL = `a;     15'd237: toneL = `a;
                //     15'd238: toneL = `a;     15'd239: toneL = `a;
                //     15'd240: toneL = `a;     15'd241: toneL = `a;
                //     15'd242: toneL = `a;     15'd243: toneL = `a;
                //     15'd244: toneL = `a;     15'd245: toneL = `a;
                //     15'd246: toneL = `a;     15'd247: toneL = `a;
                //     15'd248: toneL = `a;     15'd249: toneL = `a;
                //     15'd250: toneL = `a;     15'd251: toneL = `a;
                //     15'd252: toneL = `a;     15'd253: toneL = `a;
                //     15'd254: toneL = `a;     15'd255: toneL = `a;
                //     15'd256: toneL = `ha;     15'd257: toneL = `ha;
                //     15'd258: toneL = `ha;     15'd259: toneL = `ha;
                //     15'd260: toneL = `ha;     15'd261: toneL = `ha;
                //     15'd262: toneL = `ha;     15'd263: toneL = `ha;
                //     15'd264: toneL = `rhf;     15'd265: toneL = `rhf;
                //     15'd266: toneL = `rhf;     15'd267: toneL = `rhf;
                //     15'd268: toneL = `hg;     15'd269: toneL = `hg;
                //     15'd270: toneL = `hg;     15'd271: toneL = `hg;
                //     15'd272: toneL = `ha;     15'd273: toneL = `ha;
                //     15'd274: toneL = `ha;     15'd275: toneL = `ha;
                //     15'd276: toneL = `ha;     15'd277: toneL = `ha;
                //     15'd278: toneL = `ha;     15'd279: toneL = `ha;
                //     15'd280: toneL = `rhf;     15'd281: toneL = `rhf;
                //     15'd282: toneL = `rhf;     15'd283: toneL = `rhf;
                //     15'd284: toneL = `hg;     15'd285: toneL = `hg;
                //     15'd286: toneL = `hg;     15'd287: toneL = `hg;
                //     15'd288: toneL = `ha;     15'd289: toneL = `ha;
                //     15'd290: toneL = `ha;     15'd291: toneL = `ha;
                //     15'd292: toneL = `a;     15'd293: toneL = `a;
                //     15'd294: toneL = `a;     15'd295: toneL = `a;
                //     15'd296: toneL = `b;     15'd297: toneL = `b;
                //     15'd298: toneL = `b;     15'd299: toneL = `b;
                //     15'd300: toneL = `rhc;     15'd301: toneL = `rhc;
                //     15'd302: toneL = `rhc;     15'd303: toneL = `rhc;
                //     15'd304: toneL = `hd;     15'd305: toneL = `hd;
                //     15'd306: toneL = `hd;     15'd307: toneL = `hd;
                //     15'd308: toneL = `he;     15'd309: toneL = `he;
                //     15'd310: toneL = `he;     15'd311: toneL = `he;
                //     15'd312: toneL = `rhf;     15'd313: toneL = `rhf;
                //     15'd314: toneL = `rhf;     15'd315: toneL = `rhf;
                //     15'd316: toneL = `hg;     15'd317: toneL = `hg;
                //     15'd318: toneL = `hg;     15'd319: toneL = `hg;

                    // 15'd0: toneL = `hc;     15'd1: toneL = `hc;
                    // 15'd2: toneL = `hc;     15'd3: toneL = `hc;
                    // 15'd4: toneL = `hc;     15'd5: toneL = `hc;
                    // 15'd6: toneL = `hc;     15'd7: toneL = `hc;
                    // 15'd8: toneL = `hc;     15'd9: toneL = `hc;
                    // 15'd10: toneL = `hc;     15'd11: toneL = `hc;
                    // 15'd12: toneL = `hc;     15'd13: toneL = `hc;
                    // 15'd14: toneL = `hc;     15'd15: toneL = `hc;
                    // 15'd16: toneL = `hc;     15'd17: toneL = `hc;
                    // 15'd18: toneL = `hc;     15'd19: toneL = `hc;
                    // 15'd20: toneL = `hc;     15'd21: toneL = `hc;
                    // 15'd22: toneL = `hc;     15'd23: toneL = `hc;
                    // 15'd24: toneL = `hc;     15'd25: toneL = `hc;
                    // 15'd26: toneL = `hc;     15'd27: toneL = `hc;
                    // 15'd28: toneL = `hc;     15'd29: toneL = `hc;
                    // 15'd30: toneL = `hc;     15'd31: toneL = `hc;
                    // 15'd32: toneL = `g;     15'd33: toneL = `g;
                    // 15'd34: toneL = `g;     15'd35: toneL = `g;
                    // 15'd36: toneL = `g;     15'd37: toneL = `g;
                    // 15'd38: toneL = `g;     15'd39: toneL = `g;
                    // 15'd40: toneL = `g;     15'd41: toneL = `g;
                    // 15'd42: toneL = `g;     15'd43: toneL = `g;
                    // 15'd44: toneL = `g;     15'd45: toneL = `g;
                    // 15'd46: toneL = `g;     15'd47: toneL = `g;
                    // 15'd48: toneL = `g;     15'd49: toneL = `g;
                    // 15'd50: toneL = `g;     15'd51: toneL = `g;
                    // 15'd52: toneL = `g;     15'd53: toneL = `g;
                    // 15'd54: toneL = `g;     15'd55: toneL = `g;
                    // 15'd56: toneL = `g;     15'd57: toneL = `g;
                    // 15'd58: toneL = `g;     15'd59: toneL = `g;
                    // 15'd60: toneL = `g;     15'd61: toneL = `g;
                    // 15'd62: toneL = `g;     15'd63: toneL = `g;
                    // 15'd64: toneL = `hc;     15'd65: toneL = `hc;
                    // 15'd66: toneL = `hc;     15'd67: toneL = `hc;
                    // 15'd68: toneL = `hc;     15'd69: toneL = `hc;
                    // 15'd70: toneL = `hc;     15'd71: toneL = `hc;
                    // 15'd72: toneL = `hc;     15'd73: toneL = `hc;
                    // 15'd74: toneL = `hc;     15'd75: toneL = `hc;
                    // 15'd76: toneL = `hc;     15'd77: toneL = `hc;
                    // 15'd78: toneL = `hc;     15'd79: toneL = `hc;
                    // 15'd80: toneL = `hc;     15'd81: toneL = `hc;
                    // 15'd82: toneL = `hc;     15'd83: toneL = `hc;
                    // 15'd84: toneL = `hc;     15'd85: toneL = `hc;
                    // 15'd86: toneL = `hc;     15'd87: toneL = `hc;
                    // 15'd88: toneL = `hc;     15'd89: toneL = `hc;
                    // 15'd90: toneL = `hc;     15'd91: toneL = `hc;
                    // 15'd92: toneL = `hc;     15'd93: toneL = `hc;
                    // 15'd94: toneL = `hc;     15'd95: toneL = `hc;
                    // 15'd96: toneL = `g;     15'd97: toneL = `g;
                    // 15'd98: toneL = `g;     15'd99: toneL = `g;
                    // 15'd100: toneL = `g;     15'd101: toneL = `g;
                    // 15'd102: toneL = `g;     15'd103: toneL = `g;
                    // 15'd104: toneL = `g;     15'd105: toneL = `g;
                    // 15'd106: toneL = `g;     15'd107: toneL = `g;
                    // 15'd108: toneL = `g;     15'd109: toneL = `g;
                    // 15'd110: toneL = `g;     15'd111: toneL = `g;
                    // 15'd112: toneL = `g;     15'd113: toneL = `g;
                    // 15'd114: toneL = `g;     15'd115: toneL = `g;
                    // 15'd116: toneL = `g;     15'd117: toneL = `g;
                    // 15'd118: toneL = `g;     15'd119: toneL = `g;
                    // 15'd120: toneL = `g;     15'd121: toneL = `g;
                    // 15'd122: toneL = `g;     15'd123: toneL = `g;
                    // 15'd124: toneL = `g;     15'd125: toneL = `g;
                    // 15'd126: toneL = `g;     15'd127: toneL = `g;
                    // 15'd128: toneL = `c;     15'd129: toneL = `c;
                    // 15'd130: toneL = `c;     15'd131: toneL = `c;
                    // 15'd132: toneL = `c;     15'd133: toneL = `c;
                    // 15'd134: toneL = `c;     15'd135: toneL = `c;
                    // 15'd136: toneL = `c;     15'd137: toneL = `c;
                    // 15'd138: toneL = `c;     15'd139: toneL = `c;
                    // 15'd140: toneL = `c;     15'd141: toneL = `c;
                    // 15'd142: toneL = `c;     15'd143: toneL = `c;
                    // 15'd144: toneL = `d;     15'd145: toneL = `d;
                    // 15'd146: toneL = `d;     15'd147: toneL = `d;
                    // 15'd148: toneL = `d;     15'd149: toneL = `d;
                    // 15'd150: toneL = `d;     15'd151: toneL = `d;
                    // 15'd152: toneL = `d;     15'd153: toneL = `d;
                    // 15'd154: toneL = `d;     15'd155: toneL = `d;
                    // 15'd156: toneL = `d;     15'd157: toneL = `d;
                    // 15'd158: toneL = `d;     15'd159: toneL = `d;
                    // 15'd160: toneL = `e;     15'd161: toneL = `e;
                    // 15'd162: toneL = `e;     15'd163: toneL = `e;
                    // 15'd164: toneL = `e;     15'd165: toneL = `e;
                    // 15'd166: toneL = `e;     15'd167: toneL = `e;
                    // 15'd168: toneL = `e;     15'd169: toneL = `e;
                    // 15'd170: toneL = `e;     15'd171: toneL = `e;
                    // 15'd172: toneL = `e;     15'd173: toneL = `e;
                    // 15'd174: toneL = `e;     15'd175: toneL = `e;
                    // 15'd176: toneL = `e;     15'd177: toneL = `e;
                    // 15'd178: toneL = `e;     15'd179: toneL = `e;
                    // 15'd180: toneL = `e;     15'd181: toneL = `e;
                    // 15'd182: toneL = `e;     15'd183: toneL = `e;
                    // 15'd184: toneL = `e;     15'd185: toneL = `e;
                    // 15'd186: toneL = `e;     15'd187: toneL = `e;
                    // 15'd188: toneL = `e;     15'd189: toneL = `e;
                    // 15'd190: toneL = `e;     15'd191: toneL = `e;
                    // 15'd192: toneL = `c;     15'd193: toneL = `c;
                    // 15'd194: toneL = `c;     15'd195: toneL = `c;
                    // 15'd196: toneL = `c;     15'd197: toneL = `c;
                    // 15'd198: toneL = `c;     15'd199: toneL = `c;
                    // 15'd200: toneL = `c;     15'd201: toneL = `c;
                    // 15'd202: toneL = `c;     15'd203: toneL = `c;
                    // 15'd204: toneL = `c;     15'd205: toneL = `c;
                    // 15'd206: toneL = `c;     15'd207: toneL = `c;
                    // 15'd208: toneL = `d;     15'd209: toneL = `d;
                    // 15'd210: toneL = `d;     15'd211: toneL = `d;
                    // 15'd212: toneL = `d;     15'd213: toneL = `d;
                    // 15'd214: toneL = `d;     15'd215: toneL = `d;
                    // 15'd216: toneL = `d;     15'd217: toneL = `d;
                    // 15'd218: toneL = `d;     15'd219: toneL = `d;
                    // 15'd220: toneL = `d;     15'd221: toneL = `d;
                    // 15'd222: toneL = `d;     15'd223: toneL = `d;
                    // 15'd224: toneL = `e;     15'd225: toneL = `e;
                    // 15'd226: toneL = `e;     15'd227: toneL = `e;
                    // 15'd228: toneL = `e;     15'd229: toneL = `e;
                    // 15'd230: toneL = `e;     15'd231: toneL = `e;
                    // 15'd232: toneL = `e;     15'd233: toneL = `e;
                    // 15'd234: toneL = `e;     15'd235: toneL = `e;
                    // 15'd236: toneL = `e;     15'd237: toneL = `e;
                    // 15'd238: toneL = `e;     15'd239: toneL = `e;
                    // 15'd240: toneL = `e;     15'd241: toneL = `e;
                    // 15'd242: toneL = `e;     15'd243: toneL = `e;
                    // 15'd244: toneL = `e;     15'd245: toneL = `e;
                    // 15'd246: toneL = `e;     15'd247: toneL = `e;
                    // 15'd248: toneL = `e;     15'd249: toneL = `e;
                    // 15'd250: toneL = `e;     15'd251: toneL = `e;
                    // 15'd252: toneL = `e;     15'd253: toneL = `e;
                    // 15'd254: toneL = `e;     15'd255: toneL = `e;
                    // 15'd256: toneL = `e;     15'd257: toneL = `e;
                    // 15'd258: toneL = `e;     15'd259: toneL = `e;
                    // 15'd260: toneL = `e;     15'd261: toneL = `e;
                    // 15'd262: toneL = `e;     15'd263: toneL = `e;
                    // 15'd264: toneL = `e;     15'd265: toneL = `e;
                    // 15'd266: toneL = `e;     15'd267: toneL = `e;
                    // 15'd268: toneL = `e;     15'd269: toneL = `e;
                    // 15'd270: toneL = `e;     15'd271: toneL = `e;
                    // 15'd272: toneL = `f;     15'd273: toneL = `f;
                    // 15'd274: toneL = `f;     15'd275: toneL = `f;
                    // 15'd276: toneL = `f;     15'd277: toneL = `f;
                    // 15'd278: toneL = `f;     15'd279: toneL = `f;
                    // 15'd280: toneL = `f;     15'd281: toneL = `f;
                    // 15'd282: toneL = `f;     15'd283: toneL = `f;
                    // 15'd284: toneL = `f;     15'd285: toneL = `f;
                    // 15'd286: toneL = `f;     15'd287: toneL = `f;
                    // 15'd288: toneL = `g;     15'd289: toneL = `g;
                    // 15'd290: toneL = `g;     15'd291: toneL = `g;
                    // 15'd292: toneL = `g;     15'd293: toneL = `g;
                    // 15'd294: toneL = `g;     15'd295: toneL = `g;
                    // 15'd296: toneL = `g;     15'd297: toneL = `g;
                    // 15'd298: toneL = `g;     15'd299: toneL = `g;
                    // 15'd300: toneL = `g;     15'd301: toneL = `g;
                    // 15'd302: toneL = `g;     15'd303: toneL = `g;
                    // 15'd304: toneL = `g;     15'd305: toneL = `g;
                    // 15'd306: toneL = `g;     15'd307: toneL = `g;
                    // 15'd308: toneL = `g;     15'd309: toneL = `g;
                    // 15'd310: toneL = `g;     15'd311: toneL = `g;
                    // 15'd312: toneL = `g;     15'd313: toneL = `g;
                    // 15'd314: toneL = `g;     15'd315: toneL = `g;
                    // 15'd316: toneL = `g;     15'd317: toneL = `g;
                    // 15'd318: toneL = `g;     15'd319: toneL = `g;
                    // 15'd320: toneL = `e;     15'd321: toneL = `e;
                    // 15'd322: toneL = `e;     15'd323: toneL = `e;
                    // 15'd324: toneL = `e;     15'd325: toneL = `e;
                    // 15'd326: toneL = `e;     15'd327: toneL = `e;
                    // 15'd328: toneL = `e;     15'd329: toneL = `e;
                    // 15'd330: toneL = `e;     15'd331: toneL = `e;
                    // 15'd332: toneL = `e;     15'd333: toneL = `e;
                    // 15'd334: toneL = `e;     15'd335: toneL = `e;
                    // 15'd336: toneL = `f;     15'd337: toneL = `f;
                    // 15'd338: toneL = `f;     15'd339: toneL = `f;
                    // 15'd340: toneL = `f;     15'd341: toneL = `f;
                    // 15'd342: toneL = `f;     15'd343: toneL = `f;
                    // 15'd344: toneL = `f;     15'd345: toneL = `f;
                    // 15'd346: toneL = `f;     15'd347: toneL = `f;
                    // 15'd348: toneL = `f;     15'd349: toneL = `f;
                    // 15'd350: toneL = `f;     15'd351: toneL = `f;
                    // 15'd352: toneL = `g;     15'd353: toneL = `g;
                    // 15'd354: toneL = `g;     15'd355: toneL = `g;
                    // 15'd356: toneL = `g;     15'd357: toneL = `g;
                    // 15'd358: toneL = `g;     15'd359: toneL = `g;
                    // 15'd360: toneL = `g;     15'd361: toneL = `g;
                    // 15'd362: toneL = `g;     15'd363: toneL = `g;
                    // 15'd364: toneL = `g;     15'd365: toneL = `g;
                    // 15'd366: toneL = `g;     15'd367: toneL = `g;
                    // 15'd368: toneL = `g;     15'd369: toneL = `g;
                    // 15'd370: toneL = `g;     15'd371: toneL = `g;
                    // 15'd372: toneL = `g;     15'd373: toneL = `g;
                    // 15'd374: toneL = `g;     15'd375: toneL = `g;
                    // 15'd376: toneL = `sil;     15'd377: toneL = `sil;
                    // 15'd378: toneL = `g;     15'd379: toneL = `g;
                    // 15'd380: toneL = `g;     15'd381: toneL = `g;
                    // 15'd382: toneL = `g;     15'd383: toneL = `g;
                    // 15'd384: toneL = `g;     15'd385: toneL = `g;
                    // 15'd386: toneL = `g;     15'd387: toneL = `g;
                    // 15'd388: toneL = `g;     15'd389: toneL = `g;
                    // 15'd390: toneL = `g;     15'd391: toneL = `g;
                    // 15'd392: toneL = `g;     15'd393: toneL = `g;
                    // 15'd394: toneL = `g;     15'd395: toneL = `g;
                    // 15'd396: toneL = `g;     15'd397: toneL = `g;
                    // 15'd398: toneL = `g;     15'd399: toneL = `g;
                    // 15'd400: toneL = `g;     15'd401: toneL = `g;
                    // 15'd402: toneL = `g;     15'd403: toneL = `g;
                    // 15'd404: toneL = `g;     15'd405: toneL = `g;
                    // 15'd406: toneL = `g;     15'd407: toneL = `g;
                    // 15'd408: toneL = `g;     15'd409: toneL = `g;
                    // 15'd410: toneL = `g;     15'd411: toneL = `g;
                    // 15'd412: toneL = `g;     15'd413: toneL = `g;
                    // 15'd414: toneL = `g;     15'd415: toneL = `g;
                    // 15'd416: toneL = `e;     15'd417: toneL = `e;
                    // 15'd418: toneL = `e;     15'd419: toneL = `e;
                    // 15'd420: toneL = `e;     15'd421: toneL = `e;
                    // 15'd422: toneL = `e;     15'd423: toneL = `e;
                    // 15'd424: toneL = `e;     15'd425: toneL = `e;
                    // 15'd426: toneL = `e;     15'd427: toneL = `e;
                    // 15'd428: toneL = `e;     15'd429: toneL = `e;
                    // 15'd430: toneL = `e;     15'd431: toneL = `e;
                    // 15'd432: toneL = `e;     15'd433: toneL = `e;
                    // 15'd434: toneL = `e;     15'd435: toneL = `e;
                    // 15'd436: toneL = `e;     15'd437: toneL = `e;
                    // 15'd438: toneL = `e;     15'd439: toneL = `e;
                    // 15'd440: toneL = `e;     15'd441: toneL = `e;
                    // 15'd442: toneL = `e;     15'd443: toneL = `e;
                    // 15'd444: toneL = `e;     15'd445: toneL = `e;
                    // 15'd446: toneL = `e;     15'd447: toneL = `e;
                    // 15'd448: toneL = `g;     15'd449: toneL = `g;
                    // 15'd450: toneL = `g;     15'd451: toneL = `g;
                    // 15'd452: toneL = `g;     15'd453: toneL = `g;
                    // 15'd454: toneL = `g;     15'd455: toneL = `g;
                    // 15'd456: toneL = `g;     15'd457: toneL = `g;
                    // 15'd458: toneL = `g;     15'd459: toneL = `g;
                    // 15'd460: toneL = `g;     15'd461: toneL = `g;
                    // 15'd462: toneL = `g;     15'd463: toneL = `g;
                    // 15'd464: toneL = `g;     15'd465: toneL = `g;
                    // 15'd466: toneL = `g;     15'd467: toneL = `g;
                    // 15'd468: toneL = `g;     15'd469: toneL = `g;
                    // 15'd470: toneL = `g;     15'd471: toneL = `g;
                    // 15'd472: toneL = `g;     15'd473: toneL = `g;
                    // 15'd474: toneL = `g;     15'd475: toneL = `g;
                    // 15'd476: toneL = `g;     15'd477: toneL = `g;
                    // 15'd478: toneL = `g;     15'd479: toneL = `g;
                    // 15'd480: toneL = `e;     15'd481: toneL = `e;
                    // 15'd482: toneL = `e;     15'd483: toneL = `e;
                    // 15'd484: toneL = `e;     15'd485: toneL = `e;
                    // 15'd486: toneL = `e;     15'd487: toneL = `e;
                    // 15'd488: toneL = `e;     15'd489: toneL = `e;
                    // 15'd490: toneL = `e;     15'd491: toneL = `e;
                    // 15'd492: toneL = `e;     15'd493: toneL = `e;
                    // 15'd494: toneL = `e;     15'd495: toneL = `e;
                    // 15'd496: toneL = `e;     15'd497: toneL = `e;
                    // 15'd498: toneL = `e;     15'd499: toneL = `e;
                    // 15'd500: toneL = `e;     15'd501: toneL = `e;
                    // 15'd502: toneL = `e;     15'd503: toneL = `e;
                    // 15'd504: toneL = `e;     15'd505: toneL = `e;
                    // 15'd506: toneL = `e;     15'd507: toneL = `e;
                    // 15'd508: toneL = `e;     15'd509: toneL = `e;
                    // 15'd510: toneL = `e;     15'd511: toneL = `e;
        //         default : toneL = `sil;
        //     endcase
        end
         else begin
             toneL = `sil;
         end
    end

    //  always @(*) begin
    //     if(en == 1) begin
    //         case(ibeatNum)
    //             12'd0: TONE = `GG;  	12'd1: TONE = `GG; // HC (two-beat)
    //             12'd2: TONE = `GG;  	12'd3: TONE = `GG;
    //             12'd4: TONE = `GG;	    12'd5: TONE = `GG;
    //             12'd6: TONE = `GG;  	12'd7: TONE = `GG;
    //             12'd8: TONE = `AA;	    12'd9: TONE = `AA;
    //             12'd10: TONE = `AA;	12'd11: TONE = `AA;
    //             12'd12: TONE = `AA;	12'd13: TONE = `AA;
    //             12'd14: TONE = `AA;	12'd15: TONE = `AA;

    //             12'd16: TONE = `AA;	12'd17: TONE = `AA;
    //             12'd18: TONE = `GG;	12'd19: TONE = `GG;
    //             12'd20: TONE = `GG;	12'd21: TONE = `GG;
    //             12'd22: TONE = `GG;	12'd23: TONE = `GG;
    //             12'd24: TONE = `GG;	12'd25: TONE = `GG;
    //             12'd26: TONE = `GG;	12'd27: TONE = `GG;
    //             12'd28: TONE = `GG;	12'd29: TONE = `GG;
    //             12'd30: TONE = `GG;	12'd31: TONE = `GG;
    //             default : TONE = `BB;
    //         endcase
    //     end
    //     else begin
    //         TONE = `sil;
    //     end
    // end
endmodule

module note_gen(
    clk, // clock from crystal
    rst, // active high reset
    note_div_left, // div for note generation
    note_div_right,
    audio_left,
    audio_right,
    volume
);

    // I/O declaration
    input clk; // clock from crystal
    input rst; // active low reset
    input [21:0] note_div_left, note_div_right; // div for note generation
    output reg [15:0] audio_left, audio_right;
    input [2:0] volume;

    // Declare internal signals
    reg [21:0] clk_cnt_next, clk_cnt;
    reg [21:0] clk_cnt_next_2, clk_cnt_2;
    reg b_clk, b_clk_next;
    reg c_clk, c_clk_next;

    // Note frequency generation
    always @(posedge clk or posedge rst)
        if (rst == 1'b1)
            begin
                clk_cnt <= 22'd0;
                clk_cnt_2 <= 22'd0;
                b_clk <= 1'b0;
                c_clk <= 1'b0;
            end
        else
            begin
                clk_cnt <= clk_cnt_next;
                clk_cnt_2 <= clk_cnt_next_2;
                b_clk <= b_clk_next;
                c_clk <= c_clk_next;
            end
        
    always @*
        if (clk_cnt == note_div_left)
            begin
                clk_cnt_next = 22'd0;
                b_clk_next = ~b_clk;
            end
        else
            begin
                clk_cnt_next = clk_cnt + 1'b1;
                b_clk_next = b_clk;
            end

    always @*
        if (clk_cnt_2 == note_div_right)
            begin
                clk_cnt_next_2 = 22'd0;
                c_clk_next = ~c_clk;
            end
        else
            begin
                clk_cnt_next_2 = clk_cnt_2 + 1'b1;
                c_clk_next = c_clk;
            end

    // Assign the amplitude of the note
    // Volume is controlled here
    // assign audio_left = (note_div_left == 22'd1) ? 16'h0000 : (b_clk == 1'b0) ? 16'hE000 : 16'h2000;
    // assign audio_right = (note_div_right == 22'd1) ? 16'h0000 : (c_clk == 1'b0) ? 16'hE000 : 16'h2000;

    always @(*) begin
        case (volume)
            3'd0 : begin
                audio_left = 16'h0000;
                audio_right = 16'h0000;
            end
            3'd1: begin
                audio_left = (b_clk == 1'b0) ? 16'hF000 : 16'h1000;
                audio_right = (c_clk == 1'b0) ? 16'hF000 : 16'h1000;
            end
            3'd2 : begin
                audio_left = (b_clk == 1'b0) ? 16'hE000 : 16'h2000;
                audio_right = (c_clk == 1'b0) ? 16'hE000 : 16'h2000;
            end
            3'd3 : begin
                audio_left = (b_clk == 1'b0) ? 16'hB000 : 16'h4000;
                audio_right = (c_clk == 1'b0) ? 16'hB000 : 16'h4000;
            end
            3'd4 : begin
                audio_left = (b_clk == 1'b0) ? 16'hA000 : 16'h6000;
                audio_right = (c_clk == 1'b0) ? 16'hA000 : 16'h6000;
            end
            3'd5 : begin
                audio_left = (b_clk == 1'b0) ? 16'h9000 : 16'h7000;
                audio_right = (c_clk == 1'b0) ? 16'h9000 : 16'h7000;
            end
            default : begin
                audio_left = 16'h0000;
                audio_right = 16'h0000;
            end
        endcase
    end 

endmodule

module speaker_control(
    clk,  // clock from the crystal
    rst,  // active high reset
    audio_in_left, // left channel audio data input
    audio_in_right, // right channel audio data input
    audio_mclk, // master clock
    audio_lrck, // left-right clock, Word Select clock, or sample rate clock
    audio_sck, // serial clock
    audio_sdin // serial audio data input
);

    // I/O declaration
    input clk;  // clock from the crystal
    input rst;  // active high reset
    input [15:0] audio_in_left; // left channel audio data input
    input [15:0] audio_in_right; // right channel audio data input
    output audio_mclk; // master clock
    output audio_lrck; // left-right clock
    output audio_sck; // serial clock
    output audio_sdin; // serial audio data input
    reg audio_sdin;

    // Declare internal signal nodes 
    wire [8:0] clk_cnt_next;
    reg [8:0] clk_cnt;
    reg [15:0] audio_left, audio_right;

    // Counter for the clock divider
    assign clk_cnt_next = clk_cnt + 1'b1;

    always @(posedge clk or posedge rst)
        if (rst == 1'b1)
            clk_cnt <= 9'd0;
        else
            clk_cnt <= clk_cnt_next;

    // Assign divided clock output
    assign audio_mclk = clk_cnt[1];
    assign audio_lrck = clk_cnt[8];
    assign audio_sck = 1'b1; // use internal serial clock mode

    // audio input data buffer
    always @(posedge clk_cnt[8] or posedge rst)
        if (rst == 1'b1)
            begin
                audio_left <= 16'd0;
                audio_right <= 16'd0;
            end
        else
            begin
                audio_left <= audio_in_left;
                audio_right <= audio_in_right;
            end

    always @*
        case (clk_cnt[8:4])
            5'b00000: audio_sdin = audio_right[0];
            5'b00001: audio_sdin = audio_left[15];
            5'b00010: audio_sdin = audio_left[14];
            5'b00011: audio_sdin = audio_left[13];
            5'b00100: audio_sdin = audio_left[12];
            5'b00101: audio_sdin = audio_left[11];
            5'b00110: audio_sdin = audio_left[10];
            5'b00111: audio_sdin = audio_left[9];
            5'b01000: audio_sdin = audio_left[8];
            5'b01001: audio_sdin = audio_left[7];
            5'b01010: audio_sdin = audio_left[6];
            5'b01011: audio_sdin = audio_left[5];
            5'b01100: audio_sdin = audio_left[4];
            5'b01101: audio_sdin = audio_left[3];
            5'b01110: audio_sdin = audio_left[2];
            5'b01111: audio_sdin = audio_left[1];
            5'b10000: audio_sdin = audio_left[0];
            5'b10001: audio_sdin = audio_right[15];
            5'b10010: audio_sdin = audio_right[14];
            5'b10011: audio_sdin = audio_right[13];
            5'b10100: audio_sdin = audio_right[12];
            5'b10101: audio_sdin = audio_right[11];
            5'b10110: audio_sdin = audio_right[10];
            5'b10111: audio_sdin = audio_right[9];
            5'b11000: audio_sdin = audio_right[8];
            5'b11001: audio_sdin = audio_right[7];
            5'b11010: audio_sdin = audio_right[6];
            5'b11011: audio_sdin = audio_right[5];
            5'b11100: audio_sdin = audio_right[4];
            5'b11101: audio_sdin = audio_right[3];
            5'b11110: audio_sdin = audio_right[2];
            5'b11111: audio_sdin = audio_right[1];
            default: audio_sdin = 1'b0;
        endcase

endmodule

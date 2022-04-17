`define silence 32'd50000000
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
            next_led_vol = (_led_vol == 5'b1_1111) ? 5'b1_1111 : {_led_vol[3:0], 1'b1};
        end
        else if (_volDOWN_onepulse) begin
            next_led_vol = (_led_vol == 5'b0_0001) ? 5'b0_0001 : {1'b0, _led_vol[4:1]};
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
            next_volume = (volume == 3'd5) ? 3'd5 : volume + 3'd1;
        end
        else if (_volDOWN_onepulse) begin
            next_volume = (volume == 3'b001) ? 3'b001 : volume - 3'd1;
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



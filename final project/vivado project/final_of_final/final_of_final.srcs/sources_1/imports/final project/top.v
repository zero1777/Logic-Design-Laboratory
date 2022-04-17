module top(
    input clk,
    input rst, // button BTND
    input lbutton, // button BTNL
    input rbutton, // button BTNR
    input select, // buuton BTNC
    input confirm, // button BTNU
    input mute, // switch mute
    input money5,
    input money10,
    output [15:0] led,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output [6:0] DISPLAY,
	  output [3:0] DIGIT,
    output [2:0] PWM,
    output [3:0] signal_out,
    output audio_lrck,
    output audio_mclk,
    output audio_sck,
    output audio_sdin,
    output hsync,
    output vsync
    );


    wire [11:0] data;
    wire clk_25MHz;
    wire clk_22;
    wire [16:0] pixel_addr;
    wire [11:0] pixel;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480
    wire [1:0] pos;
    wire [15:0] nums;
    wire music;
    wire get_beverage;
    wire complete;
    wire [2:0] state;

     clock_divisor clk_wiz_0_inst(
      .clk(clk),
      .clk1(clk_25MHz),
      .clk22(clk_22)
    );

    blk_mem_gen_0 blk_mem_gen_0_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel)
    );

    mem_addr_gen mem_addr_gen_inst(
      .clk(clk_22),
      .rst(rst),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt),
      .pixel_addr(pixel_addr)
    );

   pixel_gen pixel_gen_inst(
       .rst(rst),
       .clk(clk),
       .bclk(clk_22),
       .h_cnt(h_cnt),
       .v_cnt(v_cnt),
       .valid(valid),
       .pos(pos),
       .state(state),
       .pixel(pixel),
       .vgaRed(vgaRed),
       .vgaGreen(vgaGreen),
       .vgaBlue(vgaBlue)
    );

    vga_controller  vga_inst(
      .pclk(clk_25MHz),
      .reset(rst),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
    
    position_gen pg0 (
        .rst(rst),
        .clk(clk),
        .left(lbutton),
        .right(rbutton),
        .pos(pos),
        .state(state)
    );
      
    display ds0 (
        .rst(rst),
        .clk(clk),
        .select(select),
        .money_5(money5),
        .money_10(money10),
        .confirm(confirm),
        .complete(complete),
        .pos(pos),
        .state(state),
        .music(music),
        .get_beverage(get_beverage),
        .nums(nums)
    );

    SevenSegment seven_seg (
      .display(DISPLAY),
      .digit(DIGIT),
      .nums(nums),
      .rst(rst),
      .clk(clk)
	  );

    speaker sp0 (
      .clk(clk), // clock from crystal
      .rst(rst), // active high reset: BTNC
      ._mute(mute), // SW: Mute
      .music(music),
      .audio_mclk(audio_mclk), // master clock
      .audio_lrck(audio_lrck), // left-right clock
      .audio_sck(audio_sck), // serial clock
      .audio_sdin(audio_sdin) // serial audio data input
    );

    led_light led0 (
      .clk(clk),
      .rst(rst),
      .state(state),
      .led(led)
    );

    pmod_step_interface Pmod0 (
      .PWM(PWM),
      .select(get_beverage),
      .clk(clk),
      .rst(rst),
      .pos(pos),
      .complete(complete),
      .signal_out(signal_out)
    );

    // slot_machine_money10 money10(
    //   .clk(clk),
    //   .rst(rst),
    //   .signal(money10),
    //   .mny10(mny10)
    // );

    // slot_machine_money5 money50(
    //   .clk(clk),
    //   .rst(rst),
    //   .signal(money5),
    //   .mny5(mny5)
    // );

endmodule

`define em5 32'd622
`define f5 32'd698
`define g5 32'd784
`define bm5 32'd932
`define d5 32'd587 
`define c5 32'd523
`define c4 32'd261
`define em4 32'd311
`define f4 32'd349
`define g4 32'd392
`define g3 32'd196
`define bm4 32'd466
`define bm3 32'd233
`define d4 32'd294
`define d3 32'd147
`define am3 32'd207
`define am4 32'd415
`define c3 32'd130
`define f3 32'd174
`define sil   32'd50000000 // slience
`define b5 32'd987
`define a5 32'd880 
`define d6 32'd1174
`define fs4 32'd370

module music_example (
	input [11:0] ibeatNum,
	input music,
	output reg [31:0] toneL,
    output reg [31:0] toneR
);

    always @* begin
        if(music == 0) begin
            case(ibeatNum)
                    12'd0 : toneL = `em5; 12'd1 : toneL = `em5; 12'd2 : toneL = `em5; 12'd3 : toneL = `em5; 
                12'd4 : toneL = `em5; 12'd5 : toneL = `em5; 12'd6 : toneL = `em5; 12'd7 : toneL = `em5; 
                12'd8 : toneL = `em5; 12'd9 : toneL = `em5; 12'd10 : toneL = `em5; 12'd11 : toneL = `em5; 
                12'd12 : toneL = `em5; 12'd13 : toneL = `em5; 12'd14 : toneL = `em5; 12'd15 : toneL = `em5; 

                12'd16 : toneL = `f5; 12'd17 : toneL = `f5; 12'd18 : toneL = `f5; 12'd19 : toneL = `f5; 
                12'd20 : toneL = `f5; 12'd21 : toneL = `f5; 12'd22 : toneL = `f5; 12'd23 : toneL = `f5; 
                12'd24 : toneL = `f5; 12'd25 : toneL = `f5; 12'd26 : toneL = `f5; 12'd27 : toneL = `f5; 

                12'd28 : toneL = `em5; 12'd29 : toneL = `em5; 12'd30 : toneL = `em5; 12'd31 : toneL = `em5; 

                12'd32 : toneL = `g5; 12'd33 : toneL = `g5; 12'd34 : toneL = `g5; 12'd35 : toneL = `g5; 
                12'd36 : toneL = `g5; 12'd37 : toneL = `g5; 12'd38 : toneL = `g5; 12'd39 : toneL = `g5; 
                12'd40 : toneL = `g5; 12'd41 : toneL = `g5; 12'd42 : toneL = `g5; 12'd43 : toneL = `g5; 
                12'd44 : toneL = `g5; 12'd45 : toneL = `g5; 12'd46 : toneL = `g5; 12'd47 : toneL = `g5; 
                12'd48 : toneL = `g5; 12'd49 : toneL = `g5; 12'd50 : toneL = `g5; 12'd51 : toneL = `g5; 
                12'd52 : toneL = `g5; 12'd53 : toneL = `g5; 12'd54 : toneL = `g5; 12'd55 : toneL = `g5; 

                12'd56 : toneL = `bm5; 12'd57 : toneL = `bm5; 12'd58 : toneL = `bm5; 12'd59 : toneL = `bm5; 
                12'd60 : toneL = `bm5; 12'd61 : toneL = `bm5; 12'd62 : toneL = `bm5; 12'd63 : toneL = `bm5; 

                12'd64 : toneL = `bm5; 12'd65 : toneL = `bm5; 12'd66 : toneL = `bm5; 12'd67 : toneL = `bm5; 
                12'd68 : toneL = `bm5; 12'd69 : toneL = `bm5; 12'd70 : toneL = `bm5; 12'd71 : toneL = `bm5; 
                12'd72 : toneL = `bm5; 12'd73 : toneL = `bm5; 12'd74 : toneL = `bm5; 12'd75 : toneL = `bm5; 
                12'd76 : toneL = `bm5; 12'd77 : toneL = `bm5; 12'd78 : toneL = `bm5; 12'd79 : toneL = `bm5; 

                12'd80 : toneL = `em5; 12'd81 : toneL = `em5; 12'd82 : toneL = `em5; 12'd83 : toneL = `em5; 
                12'd84 : toneL = `em5; 12'd85 : toneL = `em5; 12'd86 : toneL = `em5; 12'd87 : toneL = `em5; 

                12'd88 : toneL = `g5; 12'd89 : toneL = `g5; 12'd90 : toneL = `g5; 12'd91 : toneL = `g5; 
                12'd92 : toneL = `g5; 12'd93 : toneL = `g5; 12'd94 : toneL = `g5; 12'd95 : toneL = `g5; 

                12'd96 : toneL = `g5; 12'd97 : toneL = `g5; 12'd98 : toneL = `g5; 12'd99 : toneL = `g5; 
                12'd100 : toneL = `g5; 12'd101 : toneL = `g5; 12'd102 : toneL = `g5; 12'd103 : toneL = `g5; 

                12'd104 : toneL = `g5; 12'd105 : toneL = `g5; 12'd106 : toneL = `g5; 12'd107 : toneL = `g5; 
                12'd108 : toneL = `g5; 12'd109 : toneL = `g5; 12'd110 : toneL = `g5; 12'd111 : toneL = `g5; 
                12'd112 : toneL = `g5; 12'd113 : toneL = `g5; 12'd114 : toneL = `g5; 12'd115 : toneL = `g5; 
                12'd116 : toneL = `g5; 12'd117 : toneL = `g5; 12'd118 : toneL = `g5; 12'd119 : toneL = `sil; 

                12'd120 : toneL = `f5; 12'd121 : toneL = `f5; 12'd122 : toneL = `f5; 12'd123 : toneL = `f5; 
                12'd124 : toneL = `f5; 12'd125 : toneL = `f5; 12'd126 : toneL = `f5; 12'd127 : toneL = `f5; 
                12'd128 : toneL = `f5; 12'd129 : toneL = `f5; 12'd130 : toneL = `f5; 12'd131 : toneL = `f5; 
                12'd132 : toneL = `f5; 12'd133 : toneL = `f5; 12'd134 : toneL = `f5; 12'd135 : toneL = `f5; 
                12'd136 : toneL = `f5; 12'd137 : toneL = `f5; 12'd138 : toneL = `f5; 12'd139 : toneL = `f5; 
                12'd140 : toneL = `f5; 12'd141 : toneL = `f5; 12'd142 : toneL = `f5; 12'd143 : toneL = `f5; 

                12'd144 : toneL = `d5; 12'd145 : toneL = `d5; 12'd146 : toneL = `d5; 12'd147 : toneL = `d5; 
                12'd148 : toneL = `d5; 12'd149 : toneL = `d5; 12'd150 : toneL = `d5; 12'd151 : toneL = `d5;

                12'd152 : toneL = `em5; 12'd153 : toneL = `em5; 12'd154 : toneL = `em5; 12'd155 : toneL = `em5; 
                12'd156 : toneL = `em5; 12'd157 : toneL = `em5; 12'd158 : toneL = `em5; 12'd159 : toneL = `em5;

                12'd160 : toneL = `f5; 12'd161 : toneL = `f5; 12'd162 : toneL = `f5; 12'd163 : toneL = `f5; 
                12'd164 : toneL = `f5; 12'd165 : toneL = `f5; 12'd166 : toneL = `f5; 12'd167 : toneL = `f5; 
                12'd168 : toneL = `f5; 12'd169 : toneL = `f5; 12'd170 : toneL = `f5; 12'd171 : toneL = `f5; 
                12'd172 : toneL = `f5; 12'd173 : toneL = `f5; 12'd174 : toneL = `f5; 12'd175 : toneL = `f5; 
                12'd176 : toneL = `f5; 12'd177 : toneL = `f5; 12'd178 : toneL = `f5; 12'd179 : toneL = `f5; 
                12'd180 : toneL = `f5; 12'd181 : toneL = `f5; 12'd182 : toneL = `f5; 12'd183 : toneL = `f5; 

                12'd184 : toneL = `bm5; 12'd185 : toneL = `bm5; 12'd186 : toneL = `bm5; 12'd187 : toneL = `bm5; 
                12'd188 : toneL = `bm5; 12'd189 : toneL = `bm5; 12'd190 : toneL = `bm5; 12'd191 : toneL = `sil; 

                12'd192 : toneL = `bm5; 12'd193 : toneL = `bm5; 12'd194 : toneL = `bm5; 12'd195 : toneL = `bm5; 
                12'd196 : toneL = `bm5; 12'd197 : toneL = `bm5; 12'd198 : toneL = `bm5; 12'd199 : toneL = `bm5; 
                12'd200 : toneL = `bm5; 12'd201 : toneL = `bm5; 12'd202 : toneL = `bm5; 12'd203 : toneL = `bm5; 
                12'd204 : toneL = `bm5; 12'd205 : toneL = `bm5; 12'd206 : toneL = `bm5; 12'd207 : toneL = `bm5;

                12'd208 : toneL = `c5; 12'd209 : toneL = `c5; 12'd210 : toneL = `c5; 12'd211 : toneL = `c5; 
                12'd212 : toneL = `c5; 12'd213 : toneL = `c5; 12'd214 : toneL = `c5; 12'd215 : toneL = `c5;

                12'd216 : toneL = `f5; 12'd217 : toneL = `f5; 12'd218 : toneL = `f5; 12'd219 : toneL = `f5; 
                12'd220 : toneL = `f5; 12'd221 : toneL = `f5; 12'd222 : toneL = `f5; 12'd223 : toneL = `f5; 
                12'd224 : toneL = `f5; 12'd225 : toneL = `f5; 12'd226 : toneL = `f5; 12'd227 : toneL = `f5; 
                12'd228 : toneL = `f5; 12'd229 : toneL = `f5; 12'd230 : toneL = `f5; 12'd231 : toneL = `f5; 

                12'd232 : toneL = `g5; 12'd233 : toneL = `g5; 12'd234 : toneL = `g5; 12'd235 : toneL = `g5; 
                12'd236 : toneL = `g5; 12'd237 : toneL = `g5; 12'd238 : toneL = `g5; 12'd239 : toneL = `g5; 
                12'd240 : toneL = `g5; 12'd241 : toneL = `g5; 12'd242 : toneL = `g5; 12'd243 : toneL = `g5; 
                12'd244 : toneL = `g5; 12'd245 : toneL = `g5; 12'd246 : toneL = `g5; 12'd247 : toneL = `g5; 

                12'd248 : toneL = `em5; 12'd249 : toneL = `em5; 12'd250 : toneL = `em5; 12'd251 : toneL = `em5; 
                12'd252 : toneL = `em5; 12'd253 : toneL = `em5; 12'd254 : toneL = `em5; 12'd255 : toneL = `em5; 
                12'd256 : toneL = `em5; 12'd257 : toneL = `em5; 12'd258 : toneL = `em5; 12'd259 : toneL = `em5; 
                12'd260 : toneL = `em5; 12'd261 : toneL = `em5; 12'd262 : toneL = `em5; 12'd263 : toneL = `em5; 

                12'd264 : toneL = `c5; 12'd265 : toneL = `c5; 12'd266 : toneL = `c5; 12'd267 : toneL = `c5; 
                12'd268 : toneL = `c5; 12'd269 : toneL = `c5; 12'd270 : toneL = `c5; 12'd271 : toneL = `c5; 

                12'd272 : toneL = `d5; 12'd273 : toneL = `d5; 12'd274 : toneL = `d5; 12'd275 : toneL = `d5; 
                12'd276 : toneL = `d5; 12'd277 : toneL = `d5; 12'd278 : toneL = `d5; 12'd279 : toneL = `d5; 

                12'd280 : toneL = `em5; 12'd281 : toneL = `em5; 12'd282 : toneL = `em5; 12'd283 : toneL = `em5; 
                12'd284 : toneL = `em5; 12'd285 : toneL = `em5; 12'd286 : toneL = `em5; 12'd287 : toneL = `em5; 

                12'd288 : toneL = `em5; 12'd289 : toneL = `em5; 12'd290 : toneL = `em5; 12'd291 : toneL = `em5; 
                12'd292 : toneL = `em5; 12'd293 : toneL = `em5; 12'd294 : toneL = `em5; 12'd295 : toneL = `em5; 
                12'd296 : toneL = `em5; 12'd297 : toneL = `em5; 12'd298 : toneL = `em5; 12'd299 : toneL = `em5; 
                12'd300 : toneL = `em5; 12'd301 : toneL = `em5; 12'd302 : toneL = `em5; 12'd303 : toneL = `em5; 
                12'd304 : toneL = `em5; 12'd305 : toneL = `em5; 12'd306 : toneL = `em5; 12'd307 : toneL = `em5; 
                12'd308 : toneL = `em5; 12'd309 : toneL = `em5; 12'd310 : toneL = `em5; 12'd311 : toneL = `em5; 
                12'd312 : toneL = `em5; 12'd313 : toneL = `em5; 12'd314 : toneL = `em5; 12'd315 : toneL = `em5; 
                12'd316 : toneL = `em5; 12'd317 : toneL = `em5; 12'd318 : toneL = `em5; 12'd319 : toneL = `em5; 

                12'd320 : toneL = `sil; 12'd321 : toneL = `sil; 12'd322 : toneL = `sil; 12'd323 : toneL = `sil; 
                12'd324 : toneL = `sil; 12'd325 : toneL = `sil; 12'd326 : toneL = `sil; 12'd327 : toneL = `sil; 

                12'd328 : toneL = `c5; 12'd329 : toneL = `c5; 12'd330 : toneL = `c5; 12'd331 : toneL = `c5; 
                12'd332 : toneL = `c5; 12'd333 : toneL = `c5; 12'd334 : toneL = `c5; 12'd335 : toneL = `c5;

                12'd336 : toneL = `f5; 12'd337 : toneL = `f5; 12'd338 : toneL = `f5; 12'd339 : toneL = `f5;

                12'd340 : toneL = `g5; 12'd341 : toneL = `g5; 12'd342 : toneL = `g5; 12'd343 : toneL = `g5; 

                12'd344 : toneL = `f5; 12'd345 : toneL = `f5; 12'd346 : toneL = `f5; 12'd347 : toneL = `f5; 
                12'd348 : toneL = `f5; 12'd349 : toneL = `f5; 12'd350 : toneL = `f5; 12'd351 : toneL = `f5; 
                12'd352 : toneL = `f5; 12'd353 : toneL = `f5; 12'd354 : toneL = `f5; 12'd355 : toneL = `f5; 
                12'd356 : toneL = `f5; 12'd357 : toneL = `f5; 12'd358 : toneL = `f5; 12'd359 : toneL = `f5; 

                12'd360 : toneL = `d5; 12'd361 : toneL = `d5; 12'd362 : toneL = `d5; 12'd363 : toneL = `d5; 
                12'd364 : toneL = `d5; 12'd365 : toneL = `d5; 12'd366 : toneL = `d5; 12'd367 : toneL = `sil; 

                12'd368 : toneL = `d5; 12'd369 : toneL = `d5; 12'd370 : toneL = `d5; 12'd371 : toneL = `d5; 
                12'd372 : toneL = `d5; 12'd373 : toneL = `d5; 12'd374 : toneL = `d5; 12'd375 : toneL = `sil; 

                12'd376 : toneL = `d5; 12'd377 : toneL = `d5; 12'd378 : toneL = `d5; 12'd379 : toneL = `d5; 
                12'd380 : toneL = `d5; 12'd381 : toneL = `d5; 12'd382 : toneL = `d5; 12'd383 : toneL = `sil;

                12'd384 : toneL = `d5; 12'd385 : toneL = `d5; 12'd386 : toneL = `d5; 12'd387 : toneL = `d5; 
                12'd388 : toneL = `d5; 12'd389 : toneL = `d5; 12'd390 : toneL = `d5; 12'd391 : toneL = `d5; 
                12'd392 : toneL = `d5; 12'd393 : toneL = `d5; 12'd394 : toneL = `d5; 12'd395 : toneL = `sil;

                12'd396 : toneL = `d5; 12'd397 : toneL = `d5; 12'd398 : toneL = `d5; 12'd399 : toneL = `d5; 
                12'd400 : toneL = `d5; 12'd401 : toneL = `d5; 12'd402 : toneL = `d5; 12'd403 : toneL = `d5; 
                12'd404 : toneL = `d5; 12'd405 : toneL = `d5; 12'd406 : toneL = `d5; 12'd407 : toneL = `d5; 

                12'd408 : toneL = `bm5; 12'd409 : toneL = `bm5; 12'd410 : toneL = `bm5; 12'd411 : toneL = `bm5; 
                12'd412 : toneL = `bm5; 12'd413 : toneL = `bm5; 12'd414 : toneL = `bm5; 12'd415 : toneL = `bm5; 
                12'd416 : toneL = `bm5; 12'd417 : toneL = `bm5; 12'd418 : toneL = `bm5; 12'd419 : toneL = `bm5; 
                12'd420 : toneL = `bm5; 12'd421 : toneL = `bm5; 12'd422 : toneL = `bm5; 12'd423 : toneL = `sil; 

                12'd424 : toneL = `bm5; 12'd425 : toneL = `bm5; 12'd426 : toneL = `bm5; 12'd427 : toneL = `bm5; 
                12'd428 : toneL = `bm5; 12'd429 : toneL = `bm5; 12'd430 : toneL = `bm5; 12'd431 : toneL = `bm5; 

                12'd432 : toneL = `c5; 12'd433 : toneL = `c5; 12'd434 : toneL = `c5; 12'd435 : toneL = `c5; 
                12'd436 : toneL = `c5; 12'd437 : toneL = `c5; 12'd438 : toneL = `c5; 12'd439 : toneL = `c5;
                12'd440 : toneL = `c5; 12'd441 : toneL = `c5; 12'd442 : toneL = `c5; 12'd443 : toneL = `c5; 
                12'd444 : toneL = `c5; 12'd445 : toneL = `c5; 12'd446 : toneL = `c5; 12'd447 : toneL = `c5; 
                12'd448 : toneL = `c5; 12'd449 : toneL = `c5; 12'd450 : toneL = `c5; 12'd451 : toneL = `c5; 
                12'd452 : toneL = `c5; 12'd453 : toneL = `c5; 12'd454 : toneL = `c5; 12'd455 : toneL = `c5; 
                12'd456 : toneL = `c5; 12'd457 : toneL = `c5; 12'd458 : toneL = `c5; 12'd459 : toneL = `c5; 
                12'd460 : toneL = `c5; 12'd461 : toneL = `c5; 12'd462 : toneL = `c5; 12'd463 : toneL = `c5; 
                12'd464 : toneL = `c5; 12'd465 : toneL = `c5; 12'd466 : toneL = `c5; 12'd467 : toneL = `c5; 
                12'd468 : toneL = `c5; 12'd469 : toneL = `c5; 12'd470 : toneL = `c5; 12'd471 : toneL = `c5; 
                12'd472 : toneL = `c5; 12'd473 : toneL = `c5; 12'd474 : toneL = `c5; 12'd475 : toneL = `c5; 
                12'd476 : toneL = `c5; 12'd477 : toneL = `c5; 12'd478 : toneL = `c5; 12'd479 : toneL = `c5;
            endcase
        end
        else begin
            case(ibeatNum) 
                12'd0 : toneL = `sil; 12'd1 : toneL = `sil; 12'd2 : toneL = `sil; 12'd3 : toneL = `sil; 
                12'd4 : toneL = `sil; 12'd5 : toneL = `sil; 12'd6 : toneL = `sil; 12'd7 : toneL = `sil; 
                12'd8 : toneL = `sil; 12'd9 : toneL = `sil; 12'd10 : toneL = `sil; 12'd11 : toneL = `sil; 
                12'd12 : toneL = `sil; 12'd13 : toneL = `sil; 12'd14 : toneL = `sil; 12'd15 : toneL = `sil;

                12'd16 : toneL = `b5; 12'd17 : toneL = `b5; 12'd18 : toneL = `b5; 12'd19 : toneL = `b5; 
                12'd20 : toneL = `b5; 12'd21 : toneL = `b5; 12'd22 : toneL = `b5; 12'd23 : toneL = `b5; 
                12'd24 : toneL = `b5; 12'd25 : toneL = `b5; 12'd26 : toneL = `b5; 12'd27 : toneL = `b5; 
                12'd28 : toneL = `b5; 12'd29 : toneL = `b5; 12'd30 : toneL = `b5; 12'd31 : toneL = `b5;

                12'd32 : toneL = `g5; 12'd33 : toneL = `g5; 12'd34 : toneL = `g5; 12'd35 : toneL = `g5; 
                12'd36 : toneL = `g5; 12'd37 : toneL = `g5; 12'd38 : toneL = `g5; 12'd39 : toneL = `g5; 
                12'd40 : toneL = `g5; 12'd41 : toneL = `g5; 12'd42 : toneL = `g5; 12'd43 : toneL = `g5; 
                12'd44 : toneL = `g5; 12'd45 : toneL = `g5; 12'd46 : toneL = `g5; 12'd47 : toneL = `g5; 

                12'd48 : toneL = `d5; 12'd49 : toneL = `d5; 12'd50 : toneL = `d5; 12'd51 : toneL = `d5; 
                12'd52 : toneL = `d5; 12'd53 : toneL = `d5; 12'd54 : toneL = `d5; 12'd55 : toneL = `d5; 
                12'd56 : toneL = `d5; 12'd57 : toneL = `d5; 12'd58 : toneL = `d5; 12'd59 : toneL = `d5; 
                12'd60 : toneL = `d5; 12'd61 : toneL = `d5; 12'd62 : toneL = `d5; 12'd63 : toneL = `d5; 

                12'd64 : toneL = `g5; 12'd65 : toneL = `g5; 12'd66 : toneL = `g5; 12'd67 : toneL = `g5; 
                12'd68 : toneL = `g5; 12'd69 : toneL = `g5; 12'd70 : toneL = `g5; 12'd71 : toneL = `g5; 
                12'd72 : toneL = `g5; 12'd73 : toneL = `g5; 12'd74 : toneL = `g5; 12'd75 : toneL = `g5; 
                12'd76 : toneL = `g5; 12'd77 : toneL = `g5; 12'd78 : toneL = `g5; 12'd79 : toneL = `g5; 

                12'd80 : toneL = `a5; 12'd81 : toneL = `a5; 12'd82 : toneL = `a5; 12'd83 : toneL = `a5; 
                12'd84 : toneL = `a5; 12'd85 : toneL = `a5; 12'd86 : toneL = `a5; 12'd87 : toneL = `a5; 
                12'd88 : toneL = `a5; 12'd89 : toneL = `a5; 12'd90 : toneL = `a5; 12'd91 : toneL = `a5; 
                12'd92 : toneL = `a5; 12'd93 : toneL = `a5; 12'd94 : toneL = `a5; 12'd95 : toneL = `a5;
                12'd96 : toneL = `d6; 12'd97 : toneL = `d6; 12'd98 : toneL = `d6; 12'd99 : toneL = `d6; 
                12'd100 : toneL = `d6; 12'd101 : toneL = `d6; 12'd102 : toneL = `d6; 12'd103 : toneL = `d6; 
                12'd104 : toneL = `d6; 12'd105 : toneL = `d6; 12'd106 : toneL = `d6; 12'd107 : toneL = `d6; 
                12'd108 : toneL = `d6; 12'd109 : toneL = `d6; 12'd110 : toneL = `d6; 12'd111 : toneL = `d6; 
                12'd112 : toneL = `d6; 12'd113 : toneL = `d6; 12'd114 : toneL = `d6; 12'd115 : toneL = `d6; 
                12'd116 : toneL = `d6; 12'd117 : toneL = `d6; 12'd118 : toneL = `d6; 12'd119 : toneL = `d6; 
                12'd120 : toneL = `d6; 12'd121 : toneL = `d6; 12'd122 : toneL = `d6; 12'd123 : toneL = `d6; 
                12'd124 : toneL = `d6; 12'd125 : toneL = `d6; 12'd126 : toneL = `d6; 12'd127 : toneL = `d6;

                12'd128 : toneL = `a5; 12'd129 : toneL = `a5; 12'd130 : toneL = `a5; 12'd131 : toneL = `a5; 
                12'd132 : toneL = `a5; 12'd133 : toneL = `a5; 12'd134 : toneL = `a5; 12'd135 : toneL = `a5; 
                12'd136 : toneL = `a5; 12'd137 : toneL = `a5; 12'd138 : toneL = `a5; 12'd139 : toneL = `a5; 
                12'd140 : toneL = `a5; 12'd141 : toneL = `a5; 12'd142 : toneL = `a5; 12'd143 : toneL = `a5; 

                12'd144 : toneL = `b5; 12'd145 : toneL = `b5; 12'd146 : toneL = `b5; 12'd147 : toneL = `b5; 
                12'd148 : toneL = `b5; 12'd149 : toneL = `b5; 12'd150 : toneL = `b5; 12'd151 : toneL = `b5; 
                12'd152 : toneL = `b5; 12'd153 : toneL = `b5; 12'd154 : toneL = `b5; 12'd155 : toneL = `b5; 
                12'd156 : toneL = `b5; 12'd157 : toneL = `b5; 12'd158 : toneL = `b5; 12'd159 : toneL = `b5; 

                12'd160 : toneL = `a5; 12'd161 : toneL = `a5; 12'd162 : toneL = `a5; 12'd163 : toneL = `a5; 
                12'd164 : toneL = `a5; 12'd165 : toneL = `a5; 12'd166 : toneL = `a5; 12'd167 : toneL = `a5; 
                12'd168 : toneL = `a5; 12'd169 : toneL = `a5; 12'd170 : toneL = `a5; 12'd171 : toneL = `a5; 
                12'd172 : toneL = `a5; 12'd173 : toneL = `a5; 12'd174 : toneL = `a5; 12'd175 : toneL = `a5; 

                12'd176 : toneL = `d5; 12'd177 : toneL = `d5; 12'd178 : toneL = `d5; 12'd179 : toneL = `d5; 
                12'd180 : toneL = `d5; 12'd181 : toneL = `d5; 12'd182 : toneL = `d5; 12'd183 : toneL = `d5; 
                12'd184 : toneL = `d5; 12'd185 : toneL = `d5; 12'd186 : toneL = `d5; 12'd187 : toneL = `d5; 
                12'd188 : toneL = `d5; 12'd189 : toneL = `d5; 12'd190 : toneL = `d5; 12'd191 : toneL = `d5; 

                
            endcase
        end
    end

    always @(*) begin
        if(music == 0)begin
            case(ibeatNum)
              12'd0 : toneR = `sil; 12'd1 : toneR = `sil; 12'd2 : toneR = `sil; 12'd3 : toneR = `sil; 
                    12'd4 : toneR = `sil; 12'd5 : toneR = `sil; 12'd6 : toneR = `sil; 12'd7 : toneR = `sil; 
                    12'd8 : toneR = `sil; 12'd9 : toneR = `sil; 12'd10 : toneR = `sil; 12'd11 : toneR = `sil; 
                    12'd12 : toneR = `sil; 12'd13 : toneR = `sil; 12'd14 : toneR = `sil; 12'd15 : toneR = `sil; 
                    12'd16 : toneR = `sil; 12'd17 : toneR = `sil; 12'd18 : toneR = `sil; 12'd19 : toneR = `sil; 
                    12'd20 : toneR = `sil; 12'd21 : toneR = `sil; 12'd22 : toneR = `sil; 12'd23 : toneR = `sil; 
                    12'd24 : toneR = `sil; 12'd25 : toneR = `sil; 12'd26 : toneR = `sil; 12'd27 : toneR = `sil; 
                    12'd28 : toneR = `sil; 12'd29 : toneR = `sil; 12'd30 : toneR = `sil; 12'd31 : toneR = `sil; 

                    12'd32 : toneR = `am3; 12'd33 : toneR = `am3; 12'd34 : toneR = `am3; 12'd35 : toneR = `am3; 
                    12'd36 : toneR = `am3; 12'd37 : toneR = `am3; 12'd38 : toneR = `am3; 12'd39 : toneR = `am3; 

                    12'd40 : toneR = `em4; 12'd41 : toneR = `em4; 12'd42 : toneR = `em4; 12'd43 : toneR = `em4; 
                    12'd44 : toneR = `em4; 12'd45 : toneR = `em4; 12'd46 : toneR = `em4; 12'd47 : toneR = `em4; 

                    12'd48 : toneR = `am4; 12'd49 : toneR = `am4; 12'd50 : toneR = `am4; 12'd51 : toneR = `am4; 
                    12'd52 : toneR = `am4; 12'd53 : toneR = `am4; 12'd54 : toneR = `am4; 12'd55 : toneR = `am4; 

                    12'd56 : toneR = `em4; 12'd57 : toneR = `em4; 12'd58 : toneR = `em4; 12'd59 : toneR = `em4; 
                    12'd60 : toneR = `em4; 12'd61 : toneR = `em4; 12'd62 : toneR = `em4; 12'd63 : toneR = `em4;


                    12'd64 : toneR = `c5; 12'd65 : toneR = `c5; 12'd66 : toneR = `c5; 12'd67 : toneR = `c5; 
                    12'd68 : toneR = `c5; 12'd69 : toneR = `c5; 12'd70 : toneR = `c5; 12'd71 : toneR = `c5; 

                    12'd72 : toneR = `em4; 12'd73 : toneR = `em4; 12'd74 : toneR = `em4; 12'd75 : toneR = `em4; 
                    12'd76 : toneR = `em4; 12'd77 : toneR = `em4; 12'd78 : toneR = `em4; 12'd79 : toneR = `em4; 

                    12'd80 : toneR = `am4; 12'd81 : toneR = `am4; 12'd82 : toneR = `am4; 12'd83 : toneR = `am4; 
                    12'd84 : toneR = `am4; 12'd85 : toneR = `am4; 12'd86 : toneR = `am4; 12'd87 : toneR = `am4; 

                    12'd88 : toneR = `em4; 12'd89 : toneR = `em4; 12'd90 : toneR = `em4; 12'd91 : toneR = `em4; 
                    12'd92 : toneR = `em4; 12'd93 : toneR = `em4; 12'd94 : toneR = `em4; 12'd95 : toneR = `em4; 

                    12'd96 : toneR = `bm3; 12'd97 : toneR = `bm3; 12'd98 : toneR = `bm3; 12'd99 : toneR = `bm3; 
                    12'd100 : toneR = `bm3; 12'd101 : toneR = `bm3; 12'd102 : toneR = `bm3; 12'd103 : toneR = `bm3;

                    12'd104 : toneR = `f4; 12'd105 : toneR = `f4; 12'd106 : toneR = `f4; 12'd107 : toneR = `f4; 
                    12'd108 : toneR = `f4; 12'd109 : toneR = `f4; 12'd110 : toneR = `f4; 12'd111 : toneR = `f4; 

                    12'd112 : toneR = `bm4; 12'd113 : toneR = `bm4; 12'd114 : toneR = `bm4; 12'd115 : toneR = `bm4; 
                    12'd116 : toneR = `bm4; 12'd117 : toneR = `bm4; 12'd118 : toneR = `bm4; 12'd119 : toneR = `bm4;

                    12'd120 : toneR = `f3; 12'd121 : toneR = `f3; 12'd122 : toneR = `f3; 12'd123 : toneR = `f3; 
                    12'd124 : toneR = `f3; 12'd125 : toneR = `f3; 12'd126 : toneR = `f3; 12'd127 : toneR = `f3;

                    12'd128 : toneR = `d4; 12'd129 : toneR = `d4; 12'd130 : toneR = `d4; 12'd131 : toneR = `d4; 
                    12'd132 : toneR = `d4; 12'd133 : toneR = `d4; 12'd134 : toneR = `d4; 12'd135 : toneR = `d4; 

                    12'd136 : toneR = `f4; 12'd137 : toneR = `f4; 12'd138 : toneR = `f4; 12'd139 : toneR = `f4; 
                    12'd140 : toneR = `f4; 12'd141 : toneR = `f4; 12'd142 : toneR = `f4; 12'd143 : toneR = `f4; 

                    12'd144 : toneR = `bm4; 12'd145 : toneR = `bm4; 12'd146 : toneR = `bm4; 12'd147 : toneR = `bm4; 
                    12'd148 : toneR = `bm4; 12'd149 : toneR = `bm4; 12'd150 : toneR = `bm4; 12'd151 : toneR = `bm4;

                    12'd152 : toneR = `f4; 12'd153 : toneR = `f4; 12'd154 : toneR = `f4; 12'd155 : toneR = `f4; 
                    12'd156 : toneR = `f4; 12'd157 : toneR = `f4; 12'd158 : toneR = `f4; 12'd159 : toneR = `f4;


                    (12'd224 - 12'd64) : toneR = `g3; (12'd225 - 12'd64) : toneR = `g3; (12'd226 - 12'd64) : toneR = `g3; (12'd227 - 12'd64) : toneR = `g3; 
                    (12'd228 - 12'd64) : toneR = `g3; (12'd229 - 12'd64) : toneR = `g3; (12'd230 - 12'd64) : toneR = `g3; (12'd231 - 12'd64) : toneR = `g3;

                    (12'd232 - 12'd64) : toneR = `d4; (12'd233 - 12'd64) : toneR = `d4; (12'd234 - 12'd64) : toneR = `d4; (12'd235 - 12'd64) : toneR = `d4; 
                    (12'd236 - 12'd64) : toneR = `d4; (12'd237 - 12'd64) : toneR = `d4; (12'd238 - 12'd64) : toneR = `d4; (12'd239 - 12'd64) : toneR = `d4;

                    (12'd240 - 12'd64) : toneR = `g4; (12'd241 - 12'd64) : toneR = `g4; (12'd242 - 12'd64) : toneR = `g4; (12'd243 - 12'd64) : toneR = `g4; 
                    (12'd244 - 12'd64) : toneR = `g4; (12'd245 - 12'd64) : toneR = `g4; (12'd246 - 12'd64) : toneR = `g4; (12'd247 - 12'd64) : toneR = `g4; 

                    (12'd248 - 12'd64) : toneR = `d4; (12'd249 - 12'd64) : toneR = `d4; (12'd250 - 12'd64) : toneR = `d4; (12'd251 - 12'd64) : toneR = `d4; 
                    (12'd252 - 12'd64) : toneR = `d4; (12'd253 - 12'd64) : toneR = `d4; (12'd254 - 12'd64) : toneR = `d4; (12'd255 - 12'd64) : toneR = `d4; 

                    (12'd256 - 12'd64) : toneR = `bm4; (12'd257 - 12'd64) : toneR = `bm4; (12'd258 - 12'd64) : toneR = `bm4; (12'd259 - 12'd64) : toneR = `bm4; 
                    (12'd260 - 12'd64) : toneR = `bm4; (12'd261 - 12'd64) : toneR = `bm4; (12'd262 - 12'd64) : toneR = `bm4; (12'd263 - 12'd64) : toneR = `bm4; 

                    (12'd264 - 12'd64) : toneR = `d3; (12'd265 - 12'd64) : toneR = `d3; (12'd266 - 12'd64) : toneR = `d3; (12'd267 - 12'd64) : toneR = `d3; 
                    (12'd268 - 12'd64) : toneR = `d3; (12'd269 - 12'd64) : toneR = `d3; (12'd270 - 12'd64) : toneR = `d3; (12'd271 - 12'd64) : toneR = `d3;

                    (12'd272 - 12'd64) : toneR = `g4; (12'd273 - 12'd64) : toneR = `g4; (12'd274 - 12'd64) : toneR = `g4; (12'd275 - 12'd64) : toneR = `g4; 
                    (12'd276 - 12'd64) : toneR = `g4; (12'd277 - 12'd64) : toneR = `g4; (12'd278 - 12'd64) : toneR = `g4; (12'd279 - 12'd64) : toneR = `g4;

                    (12'd280 - 12'd64) : toneR = `d3; (12'd281 - 12'd64) : toneR = `d3; (12'd282 - 12'd64) : toneR = `d3; (12'd283 - 12'd64) : toneR = `d3; 
                    (12'd284 - 12'd64) : toneR = `d3; (12'd285 - 12'd64) : toneR = `d3; (12'd286 - 12'd64) : toneR = `d3; (12'd287 - 12'd64) : toneR = `d3;

                    (12'd288 - 12'd64) : toneR = `c4; (12'd289 - 12'd64) : toneR = `c4; (12'd290 - 12'd64) : toneR = `c4; (12'd291 - 12'd64) : toneR = `c4; 
                    (12'd292 - 12'd64) : toneR = `c4; (12'd293 - 12'd64) : toneR = `c4; (12'd294 - 12'd64) : toneR = `c4; (12'd295 - 12'd64) : toneR = `c4;

                    (12'd296 - 12'd64) : toneR = `g4; (12'd297 - 12'd64) : toneR = `g4; (12'd298 - 12'd64) : toneR = `g4; (12'd299 - 12'd64) : toneR = `g4; 
                    (12'd300 - 12'd64) : toneR = `g4; (12'd301 - 12'd64) : toneR = `g4; (12'd302 - 12'd64) : toneR = `g4; (12'd303 - 12'd64) : toneR = `g4;

                    (12'd304 - 12'd64) : toneR = `c4; (12'd305 - 12'd64) : toneR = `c4; (12'd306 - 12'd64) : toneR = `c4; (12'd307 - 12'd64) : toneR = `c4; 
                    (12'd308 - 12'd64) : toneR = `c4; (12'd309 - 12'd64) : toneR = `c4; (12'd310 - 12'd64) : toneR = `c4; (12'd311 - 12'd64) : toneR = `c4;

                    (12'd312 - 12'd64) : toneR = `g4; (12'd313 - 12'd64) : toneR = `g4; (12'd314 - 12'd64) : toneR = `g4; (12'd315 - 12'd64) : toneR = `g4; 
                    (12'd316 - 12'd64) : toneR = `g4; (12'd317 - 12'd64) : toneR = `g4; (12'd318 - 12'd64) : toneR = `g4; (12'd319 - 12'd64) : toneR = `g4;

                    (12'd320 - 12'd64) : toneR = `em5; (12'd321 - 12'd64) : toneR = `em5; (12'd322 - 12'd64) : toneR = `em5; (12'd323 - 12'd64) : toneR = `em5; 
                    (12'd324 - 12'd64) : toneR = `em5; (12'd325 - 12'd64) : toneR = `em5; (12'd326 - 12'd64) : toneR = `em5; (12'd327 - 12'd64) : toneR = `em5;

                    (12'd328 - 12'd64) : toneR = `g4; (12'd329 - 12'd64) : toneR = `g4; (12'd330 - 12'd64) : toneR = `g4; (12'd331 - 12'd64) : toneR = `g4; 
                    (12'd332 - 12'd64) : toneR = `g4; (12'd333 - 12'd64) : toneR = `g4; (12'd334 - 12'd64) : toneR = `g4; (12'd335 - 12'd64) : toneR = `g4;   

                    (12'd336 - 12'd64) : toneR = `c5; (12'd337 - 12'd64) : toneR = `c5; (12'd338 - 12'd64) : toneR = `c5; (12'd339 - 12'd64) : toneR = `c5; 
                    (12'd340 - 12'd64) : toneR = `c5; (12'd341 - 12'd64) : toneR = `c5; (12'd342 - 12'd64) : toneR = `c5; (12'd343 - 12'd64) : toneR = `c5; 

                    (12'd344 - 12'd64) : toneR = `g4; (12'd345 - 12'd64) : toneR = `g4; (12'd346 - 12'd64) : toneR = `g4; (12'd347 - 12'd64) : toneR = `g4; 
                    (12'd348 - 12'd64) : toneR = `g4; (12'd349 - 12'd64) : toneR = `g4; (12'd350 - 12'd64) : toneR = `g4; (12'd351 - 12'd64) : toneR = `g4;

                    (12'd352 - 12'd64) : toneR = `g4; (12'd353 - 12'd64) : toneR = `g4; (12'd354 - 12'd64) : toneR = `g4; (12'd355 - 12'd64) : toneR = `g4; 
                    (12'd356 - 12'd64) : toneR = `g4; (12'd357 - 12'd64) : toneR = `g4; (12'd358 - 12'd64) : toneR = `g4; (12'd359 - 12'd64) : toneR = `g4; 
                    (12'd360 - 12'd64) : toneR = `g4; (12'd361 - 12'd64) : toneR = `g4; (12'd362 - 12'd64) : toneR = `g4; (12'd363 - 12'd64) : toneR = `g4; 
                    (12'd364 - 12'd64) : toneR = `g4; (12'd365 - 12'd64) : toneR = `g4; (12'd366 - 12'd64) : toneR = `g4; (12'd367 - 12'd64) : toneR = `g4; 
                    (12'd368 - 12'd64) : toneR = `g4; (12'd369 - 12'd64) : toneR = `g4; (12'd370 - 12'd64) : toneR = `g4; (12'd371 - 12'd64) : toneR = `g4; 
                    (12'd372 - 12'd64) : toneR = `g4; (12'd373 - 12'd64) : toneR = `g4; (12'd374 - 12'd64) : toneR = `g4; (12'd375 - 12'd64) : toneR = `g4; 
                    (12'd376 - 12'd64) : toneR = `g4; (12'd377 - 12'd64) : toneR = `g4; (12'd378 - 12'd64) : toneR = `g4; (12'd379 - 12'd64) : toneR = `g4; 
                    (12'd380 - 12'd64) : toneR = `g4; (12'd381 - 12'd64) : toneR = `g4; (12'd382 - 12'd64) : toneR = `g4; (12'd383 - 12'd64) : toneR = `g4; 

                    (12'd384 - 12'd64) : toneR = `sil; (12'd385 - 12'd64) : toneR = `sil; (12'd386 - 12'd64) : toneR = `sil; (12'd387 - 12'd64) : toneR = `sil; 
                    (12'd388 - 12'd64) : toneR = `sil; (12'd389 - 12'd64) : toneR = `sil; (12'd390 - 12'd64) : toneR = `sil; (12'd391 - 12'd64) : toneR = `sil; 

                    (12'd392 - 12'd64) : toneR = `c4; (12'd393 - 12'd64) : toneR = `c4; (12'd394 - 12'd64) : toneR = `c4; (12'd395 - 12'd64) : toneR = `c4; 
                    (12'd396 - 12'd64) : toneR = `c4; (12'd397 - 12'd64) : toneR = `c4; (12'd398 - 12'd64) : toneR = `c4; (12'd399 - 12'd64) : toneR = `c4; 

                    (12'd400 - 12'd64) : toneR = `f4; (12'd401 - 12'd64) : toneR = `f4; (12'd402 - 12'd64) : toneR = `f4; (12'd403 - 12'd64) : toneR = `f4; 
                    (12'd404 - 12'd64) : toneR = `f4; (12'd405 - 12'd64) : toneR = `f4; (12'd406 - 12'd64) : toneR = `f4; (12'd407 - 12'd64) : toneR = `f4;

                    (12'd408 - 12'd64) : toneR = `c4; (12'd409 - 12'd64) : toneR = `c4; (12'd410 - 12'd64) : toneR = `c4; (12'd411 - 12'd64) : toneR = `c4; 
                    (12'd412 - 12'd64) : toneR = `c4; (12'd413 - 12'd64) : toneR = `c4; (12'd414 - 12'd64) : toneR = `c4; (12'd415 - 12'd64) : toneR = `c4;

                    (12'd416 - 12'd64) : toneR = `bm3; (12'd417 - 12'd64) : toneR = `bm3; (12'd418 - 12'd64) : toneR = `bm3; (12'd419 - 12'd64) : toneR = `bm3; 
                    (12'd420 - 12'd64) : toneR = `bm3; (12'd421 - 12'd64) : toneR = `bm3; (12'd422 - 12'd64) : toneR = `bm3; (12'd423 - 12'd64) : toneR = `bm3;

                    (12'd424 - 12'd64) : toneR = `d4; (12'd425 - 12'd64) : toneR = `d4; (12'd426 - 12'd64) : toneR = `d4; (12'd427 - 12'd64) : toneR = `d4; 
                    (12'd428 - 12'd64) : toneR = `d4; (12'd429 - 12'd64) : toneR = `d4; (12'd430 - 12'd64) : toneR = `d4; (12'd431 - 12'd64) : toneR = `d4;

                    (12'd432 - 12'd64) : toneR = `bm4; (12'd433 - 12'd64) : toneR = `bm4; (12'd434 - 12'd64) : toneR = `bm4; (12'd435 - 12'd64) : toneR = `bm4; 
                    (12'd436 - 12'd64) : toneR = `bm4; (12'd437 - 12'd64) : toneR = `bm4; (12'd438 - 12'd64) : toneR = `bm4; (12'd439 - 12'd64) : toneR = `bm4;

                    (12'd440 - 12'd64) : toneR = `d4; (12'd441 - 12'd64) : toneR = `d4; (12'd442 - 12'd64) : toneR = `d4; (12'd443 - 12'd64) : toneR = `d4; 
                    (12'd444 - 12'd64) : toneR = `d4; (12'd445 - 12'd64) : toneR = `d4; (12'd446 - 12'd64) : toneR = `d4; (12'd447 - 12'd64) : toneR = `d4; 

                    (12'd448 - 12'd64) : toneR = `d5; (12'd449 - 12'd64) : toneR = `d5; (12'd450 - 12'd64) : toneR = `d5; (12'd451 - 12'd64) : toneR = `d5; 
                    (12'd452 - 12'd64) : toneR = `d5; (12'd453 - 12'd64) : toneR = `d5; (12'd454 - 12'd64) : toneR = `d5; (12'd455 - 12'd64) : toneR = `d5;

                    (12'd456 - 12'd64) : toneR = `f4; (12'd457 - 12'd64) : toneR = `f4; (12'd458 - 12'd64) : toneR = `f4; (12'd459 - 12'd64) : toneR = `f4; 
                    (12'd460 - 12'd64) : toneR = `f4; (12'd461 - 12'd64) : toneR = `f4; (12'd462 - 12'd64) : toneR = `f4; (12'd463 - 12'd64) : toneR = `f4;

                    (12'd464 - 12'd64) : toneR = `bm4; (12'd465 - 12'd64) : toneR = `bm4; (12'd466 - 12'd64) : toneR = `bm4; (12'd467 - 12'd64) : toneR = `bm4; 
                    (12'd468 - 12'd64) : toneR = `bm4; (12'd469 - 12'd64) : toneR = `bm4; (12'd470 - 12'd64) : toneR = `bm4; (12'd471 - 12'd64) : toneR = `bm4; 

                    (12'd472 - 12'd64) : toneR = `d4; (12'd473 - 12'd64) : toneR = `d4; (12'd474 - 12'd64) : toneR = `d4; (12'd475 - 12'd64) : toneR = `d4; 
                    (12'd476 - 12'd64) : toneR = `d4; (12'd477 - 12'd64) : toneR = `d4; (12'd478 - 12'd64) : toneR = `d4; (12'd479 - 12'd64) : toneR = `d4; 

                    (12'd480 - 12'd64) : toneR = `c4; (12'd481 - 12'd64) : toneR = `c4; (12'd482 - 12'd64) : toneR = `c4; (12'd483 - 12'd64) : toneR = `c4; 
                    (12'd484 - 12'd64) : toneR = `c4; (12'd485 - 12'd64) : toneR = `c4; (12'd486 - 12'd64) : toneR = `c4; (12'd487 - 12'd64) : toneR = `c4; 

                    (12'd488 - 12'd64) : toneR = `g4; (12'd489 - 12'd64) : toneR = `g4; (12'd490 - 12'd64) : toneR = `g4; (12'd491 - 12'd64) : toneR = `g4; 
                    (12'd492 - 12'd64) : toneR = `g4; (12'd493 - 12'd64) : toneR = `g4; (12'd494 - 12'd64) : toneR = `g4; (12'd495 - 12'd64) : toneR = `g4; 

                    (12'd496 - 12'd64) : toneR = `bm4; (12'd497 - 12'd64) : toneR = `bm4; (12'd498 - 12'd64) : toneR = `bm4; (12'd499 - 12'd64) : toneR = `bm4; 
                    (12'd500 - 12'd64) : toneR = `bm4; (12'd501 - 12'd64) : toneR = `bm4; (12'd502 - 12'd64) : toneR = `bm4; (12'd503 - 12'd64) : toneR = `bm4; 

                    (12'd504 - 12'd64) : toneR = `d4; (12'd505 - 12'd64) : toneR = `d4; (12'd506 - 12'd64) : toneR = `d4; (12'd507 - 12'd64) : toneR = `d4; 
                    (12'd508 - 12'd64) : toneR = `d4; (12'd509 - 12'd64) : toneR = `d4; (12'd510 - 12'd64) : toneR = `d4; (12'd511 - 12'd64) : toneR = `d4;

                    (12'd512 - 12'd64) : toneR = `em4; (12'd513 - 12'd64) : toneR = `em4; (12'd514 - 12'd64) : toneR = `em4; (12'd515 - 12'd64) : toneR = `em4; 
                    (12'd516 - 12'd64) : toneR = `em4; (12'd517 - 12'd64) : toneR = `em4; (12'd518 - 12'd64) : toneR = `em4; (12'd519 - 12'd64) : toneR = `em4;

                    (12'd520 - 12'd64) : toneR = `g4; (12'd521 - 12'd64) : toneR = `g4; (12'd522 - 12'd64) : toneR = `g4; (12'd523 - 12'd64) : toneR = `g4; 
                    (12'd524 - 12'd64) : toneR = `g4; (12'd525 - 12'd64) : toneR = `g4; (12'd526 - 12'd64) : toneR = `g4; (12'd527 - 12'd64) : toneR = `g4;

                    (12'd528 - 12'd64) : toneR = `c3; (12'd529 - 12'd64) : toneR = `c3; (12'd530 - 12'd64) : toneR = `c3; (12'd531 - 12'd64) : toneR = `c3; 
                    (12'd532 - 12'd64) : toneR = `c3; (12'd533 - 12'd64) : toneR = `c3; (12'd534 - 12'd64) : toneR = `c3; (12'd535 - 12'd64) : toneR = `c3; 

                    (12'd536 - 12'd64) : toneR = `d3; (12'd537 - 12'd64) : toneR = `d3; (12'd538 - 12'd64) : toneR = `d3; (12'd539 - 12'd64) : toneR = `d3; 
                    (12'd540 - 12'd64) : toneR = `d3; (12'd541 - 12'd64) : toneR = `d3; (12'd542 - 12'd64) : toneR = `d3; (12'd543 - 12'd64) : toneR = `d3;
            endcase
        end
        else begin
            case(ibeatNum)
                12'd0 : toneR = `sil; 12'd1 : toneR = `sil; 12'd2 : toneR = `sil; 12'd3 : toneR = `sil; 
                12'd4 : toneR = `sil; 12'd5 : toneR = `sil; 12'd6 : toneR = `sil; 12'd7 : toneR = `sil; 
                12'd8 : toneR = `sil; 12'd9 : toneR = `sil; 12'd10 : toneR = `sil; 12'd11 : toneR = `sil; 
                12'd12 : toneR = `sil; 12'd13 : toneR = `sil; 12'd14 : toneR = `sil; 12'd15 : toneR = `sil; 
                12'd16 : toneR = `sil; 12'd17 : toneR = `sil; 12'd18 : toneR = `sil; 12'd19 : toneR = `sil; 
                12'd20 : toneR = `sil; 12'd21 : toneR = `sil; 12'd22 : toneR = `sil; 12'd23 : toneR = `sil; 
                12'd24 : toneR = `sil; 12'd25 : toneR = `sil; 12'd26 : toneR = `sil; 12'd27 : toneR = `sil; 
                12'd28 : toneR = `sil; 12'd29 : toneR = `sil; 12'd30 : toneR = `sil; 12'd31 : toneR = `sil; 
                12'd32 : toneR = `sil; 12'd33 : toneR = `sil; 12'd34 : toneR = `sil; 12'd35 : toneR = `sil; 
                12'd36 : toneR = `sil; 12'd37 : toneR = `sil; 12'd38 : toneR = `sil; 12'd39 : toneR = `sil; 
                12'd40 : toneR = `sil; 12'd41 : toneR = `sil; 12'd42 : toneR = `sil; 12'd43 : toneR = `sil; 
                12'd44 : toneR = `sil; 12'd45 : toneR = `sil; 12'd46 : toneR = `sil; 12'd47 : toneR = `sil;

                12'd48 : toneR = `b5; 12'd49 : toneR = `b5; 12'd50 : toneR = `b5; 12'd51 : toneR = `b5; 
                12'd52 : toneR = `b5; 12'd53 : toneR = `b5; 12'd54 : toneR = `b5; 12'd55 : toneR = `b5; 
                12'd56 : toneR = `b5; 12'd57 : toneR = `b5; 12'd58 : toneR = `b5; 12'd59 : toneR = `b5; 
                12'd60 : toneR = `b5; 12'd61 : toneR = `b5; 12'd62 : toneR = `b5; 12'd63 : toneR = `b5; 
                //`c5 4
                12'd64 : toneR = `c5; 12'd65 : toneR = `c5; 12'd66 : toneR = `c5; 12'd67 : toneR = `c5; 
                12'd68 : toneR = `c5; 12'd69 : toneR = `c5; 12'd70 : toneR = `c5; 12'd71 : toneR = `c5; 
                12'd72 : toneR = `c5; 12'd73 : toneR = `c5; 12'd74 : toneR = `c5; 12'd75 : toneR = `c5; 
                12'd76 : toneR = `c5; 12'd77 : toneR = `c5; 12'd78 : toneR = `c5; 12'd79 : toneR = `c5; 
                //`b5 4
                12'd80 : toneR = `b5; 12'd81 : toneR = `b5; 12'd82 : toneR = `b5; 12'd83 : toneR = `b5; 
                12'd84 : toneR = `b5; 12'd85 : toneR = `b5; 12'd86 : toneR = `b5; 12'd87 : toneR = `b5; 
                12'd88 : toneR = `b5; 12'd89 : toneR = `b5; 12'd90 : toneR = `b5; 12'd91 : toneR = `b5; 
                12'd92 : toneR = `b5; 12'd93 : toneR = `b5; 12'd94 : toneR = `b5; 12'd95 : toneR = `b5; 

                12'd96 : toneR = `g4; 12'd97 : toneR = `g4; 12'd98 : toneR = `g4; 12'd99 : toneR = `g4; 
                12'd100 : toneR = `g4; 12'd101 : toneR = `g4; 12'd102 : toneR = `g4; 12'd103 : toneR = `g4; 
                12'd104 : toneR = `g4; 12'd105 : toneR = `g4; 12'd106 : toneR = `g4; 12'd107 : toneR = `g4; 
                12'd108 : toneR = `g4; 12'd109 : toneR = `g4; 12'd110 : toneR = `g4; 12'd111 : toneR = `g4; 
                //`c5 4
                12'd112 : toneR = `c5; 12'd113 : toneR = `c5; 12'd114 : toneR = `c5; 12'd115 : toneR = `c5; 
                12'd116 : toneR = `c5; 12'd117 : toneR = `c5; 12'd118 : toneR = `c5; 12'd119 : toneR = `c5; 
                12'd120 : toneR = `c5; 12'd121 : toneR = `c5; 12'd122 : toneR = `c5; 12'd123 : toneR = `c5; 
                12'd124 : toneR = `c5; 12'd125 : toneR = `c5; 12'd126 : toneR = `c5; 12'd127 : toneR = `c5;

                12'd128 : toneR = `d5; 12'd129 : toneR = `d5; 12'd130 : toneR = `d5; 12'd131 : toneR = `d5; 
                12'd132 : toneR = `d5; 12'd133 : toneR = `d5; 12'd134 : toneR = `d5; 12'd135 : toneR = `d5; 
                12'd136 : toneR = `d5; 12'd137 : toneR = `d5; 12'd138 : toneR = `d5; 12'd139 : toneR = `d5; 
                12'd140 : toneR = `d5; 12'd141 : toneR = `d5; 12'd142 : toneR = `d5; 12'd143 : toneR = `d5; 

                12'd144 : toneR = `c5; 12'd145 : toneR = `c5; 12'd146 : toneR = `c5; 12'd147 : toneR = `c5; 
                12'd148 : toneR = `c5; 12'd149 : toneR = `c5; 12'd150 : toneR = `c5; 12'd151 : toneR = `c5; 
                12'd152 : toneR = `c5; 12'd153 : toneR = `c5; 12'd154 : toneR = `c5; 12'd155 : toneR = `c5; 
                12'd156 : toneR = `c5; 12'd157 : toneR = `c5; 12'd158 : toneR = `c5; 12'd159 : toneR = `c5; 

                12'd160 : toneR = `fs4; 12'd161 : toneR = `fs4; 12'd162 : toneR = `fs4; 12'd163 : toneR = `fs4; 
                12'd164 : toneR = `fs4; 12'd165 : toneR = `fs4; 12'd166 : toneR = `fs4; 12'd167 : toneR = `fs4; 
                12'd168 : toneR = `fs4; 12'd169 : toneR = `fs4; 12'd170 : toneR = `fs4; 12'd171 : toneR = `fs4; 
                12'd172 : toneR = `fs4; 12'd173 : toneR = `fs4; 12'd174 : toneR = `fs4; 12'd175 : toneR = `fs4; 

                12'd176 : toneR = `g4; 12'd177 : toneR = `g4; 12'd178 : toneR = `g4; 12'd179 : toneR = `g4; 
                12'd180 : toneR = `g4; 12'd181 : toneR = `g4; 12'd182 : toneR = `g4; 12'd183 : toneR = `g4; 
                12'd184 : toneR = `g4; 12'd185 : toneR = `g4; 12'd186 : toneR = `g4; 12'd187 : toneR = `g4; 
                12'd188 : toneR = `sil; 12'd189 : toneR = `sil; 12'd190 : toneR = `sil; 12'd191 : toneR = `sil; 
            endcase
        end
    end
endmodule 
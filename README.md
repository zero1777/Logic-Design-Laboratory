# Logic-Design-Laboratory
NTHU CS. 10810 EECS207002 Logic Design Laboratory.

## Lab 1: ALU Designs

### myxor
- Write a Verilog module that models an **XOR gate** with <span style=color:red>and</span>, <span style=color:red>or</span> and <span style=color:red>not</span> gates **ONLY**.

### lab1_1 - lab1_3
- Write a Verilog module that models a **1-bit ALU** with <span style=color:red>and</span>, <span style=color:red>or</span>, <span style=color:red>not</span> and <span style=color:red>myxor</span> as basic components. 
    - gate level
    - continuous assignments (data flow modeling) 
    - behavioral modeling

### lab1_4
- Write a Verilog module that models a **4-bit ALU** by using four 1-bit ALUs

## Lab 2: Counters

### lab2_1, lab2_1_t
- Design a <span style=color:red>positive-edge-</span>triggered-clock 4-bit counter.
- Create a testbench to verify your design.

### lab2_2
- Design a <span style=color:red>negative-edge-</span>triggered-clock 2-digit gray-code counter.

### lab2_3, lab2_3_t
- Design a <span style=color:red>positive-edge-</span>triggered-clock 6-bit Linear feedback shift register (LFSR)
- Create a testbench to verify your design.

## Lab 3: Clock Divider and LED Controller

### clock_divider
- Write a Verilog module for the clock divider that divides the frequency of the input clock by $2^{26}$ to get the output clock

### lab03_1
- Write a Verilog module of the LED Controller which is synchronous with the clock whose frequency is obtained by dividing the frequency of Basys3’s clock, 100MHz, by $2^{26}$

### lab03_2
- Write a Verilog module of the LED Controller which is synchronous with the clock whose frequency is obtained by dividing the frequency of Basys3’s clock, 100MHz, by $2^{23}$ or $2^{26}$.

### lab03_3
- Write a Verilog module of the LED Controller which is synchronous at the clock rates of (100MHz / $2^{23}$) or (100MHz / $2^{26}$), dividing from Basys3’s 100MHz clock

## Lab 4: BCD Counter

### lab4_1
- Use the switches to provide binary inputs. 
- Display the decimal values on the 7-segment display.

### lab4_2
- Design the 2-digit BCD up/down counter with a record button to record the counting number. 

### lab4_3, lab4_bonus
- Implement a count-down counter. The two leftmost digits represent the **minute** and the two rightmost digits represent the **second**.
- Create the exact 1 second timestep for lab4_3 to count down.

## Lab 5: The Awesome Vending Machine
- Design a controller which is similar to an actual vending machine.
- Pressing the money/cancel button to deposite/return money
- The two **rightmost** 7-segment digits will show the balance.
- The two **leftmost** 7-segment digits will show the price of the corresponding drink.

## Lab 6: Da Vinci Code
- Design the Da Vinci Code game and implement it on the FPGA board with a keyboard.

## Lab 7: Digital Photo Frame
- Implement a digital photo frame with some transition effects on the VGA display.

## Lab 8: Music Player
- Design a music player with 2 songs.
- The player should have these functions:
  - Supporting 2 Tracks (one for melody, one for accompaniment part) per song 
  - Be able to Play / Pause 
  - Be able to Mute 
  - Be able to switch between two songs 
  - Be able to repeat playing after the song ends 
  - Supporting the 5-level volume control 
  - Be able to display the current note with 7 segment display

## Final Project: Vending machine


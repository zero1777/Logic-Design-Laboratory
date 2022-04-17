## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
	
#Buttons
set_property PACKAGE_PIN U18 [get_ports rst]                        
    set_property IOSTANDARD LVCMOS33 [get_ports rst]
    
set_property PACKAGE_PIN A14 [get_ports {PWM[0]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {PWM[0]}]
set_property PACKAGE_PIN A16 [get_ports {PWM[1]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {PWM[1]}]
set_property PACKAGE_PIN B15 [get_ports {PWM[2]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {PWM[2]}]

# Switches
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
set_property PACKAGE_PIN V2 [get_ports {sw[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
set_property PACKAGE_PIN T3 [get_ports {sw[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
set_property PACKAGE_PIN T2 [get_ports {sw[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
set_property PACKAGE_PIN R3 [get_ports {sw[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
set_property PACKAGE_PIN W2 [get_ports {sw[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
set_property PACKAGE_PIN U1 [get_ports {sw[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
set_property PACKAGE_PIN T1 [get_ports {sw[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]
set_property PACKAGE_PIN R2 [get_ports {sw[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]
	
	

 set_property PACKAGE_PIN T18 [get_ports select]
    set_property IOSTANDARD LVCMOS33 [get_ports select]
# set_property PACKAGE_PIN T18 [get_ports btnU]
#    set_property IOSTANDARD LVCMOS33 [get_ports btnU]
# set_property PACKAGE_PIN W19 [get_ports btnL]
#    set_property IOSTANDARD LVCMOS33 [get_ports btnL]
# set_property PACKAGE_PIN T17 [get_ports btnR]
#    set_property IOSTANDARD LVCMOS33 [get_ports btnR]
# set_property PACKAGE_PIN U17 [get_ports btnD]
#    set_property IOSTANDARD LVCMOS33 [get_ports btnD]
	
	
##Pmod Header JC
    ##Sch name = JC1
#    set_property PACKAGE_PIN K17 [get_ports {JC[0]}]                    
#        set_property IOSTANDARD LVCMOS33 [get_ports {JC[0]}]
    ##Sch name = JC2
    #set_property PACKAGE_PIN M18 [get_ports {JC[1]}]                    
        #set_property IOSTANDARD LVCMOS33 [get_ports {JC[1]}]
    ##Sch name = JC3
    #set_property PACKAGE_PIN N17 [get_ports {JC[2]}]                    
        #set_property IOSTANDARD LVCMOS33 [get_ports {JC[2]}]
    ##Sch name = JC4
    #set_property PACKAGE_PIN P18 [get_ports {JC[3]}]                    
        #set_property IOSTANDARD LVCMOS33 [get_ports {JC[3]}]
    #Sch name = JC7
    set_property PACKAGE_PIN L17 [get_ports {signal_out[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[0]}]
    #Sch name = JC8
    set_property PACKAGE_PIN M19 [get_ports {signal_out[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[1]}]
    #Sch name = JC9
    set_property PACKAGE_PIN P17 [get_ports {signal_out[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[2]}]
    #Sch name = JC10
    set_property PACKAGE_PIN R18 [get_ports {signal_out[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[3]}]
        
        
#         #leds
#           set_property PACKAGE_PIN U16 [get_ports {signal_out[0]}]                    
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[0]}]
#           #Sch name = JC8
#           set_property PACKAGE_PIN E19 [get_ports {signal_out[1]}]                    
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[1]}]
#           #Sch name = JC9
#           set_property PACKAGE_PIN U19 [get_ports {signal_out[2]}]                    
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[2]}]
#           #Sch name = JC10
#           set_property PACKAGE_PIN V19 [get_ports {signal_out[3]}]                    
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[3]}]
               
               
               set_property CFGBVS Vcco [current_design]
               set_property config_voltage 3.3 [current_design]

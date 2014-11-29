## Generated SDC file "gbc.sdc"

## Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 14.0.0 Build 200 06/17/2014 SJ Web Edition"

## DATE    "Sat Nov 29 01:41:39 2014"

##
## DEVICE  "5CGXFC5C6F27C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLOCK_125_p} -period 8.000 -waveform { 0.000 4.000 } [get_ports {CLOCK_125_p}]
create_clock -name {CLOCK_50_B5B} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50_B5B}]
create_clock -name {CLOCK_50_B6A} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50_B6A}]
create_clock -name {CLOCK_50_B7A} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50_B7A}]
create_clock -name {CLOCK_50_B8A} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50_B8A}]
create_clock -name {div:div4|out} -period 250.000 -waveform { 0.000 125.000 } [get_nets {div4|out}]
create_clock -name {div:div115200|out} -period 8000.000 -waveform { 0.000 4340.000 } [get_pins { div115200|out|q }]
create_clock -name {div:div460800|out} -period 2000.000 -waveform { 0.000 1085.000 } [get_pins { div460800|out|q }]
create_clock -name {div:div25|out} -period 40.000 -waveform { 0.000 20.000 } [get_nets {div25|out}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {div:div25|out}] -rise_to [get_clocks {div:div25|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div25|out}] -fall_to [get_clocks {div:div25|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div25|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div25|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div25|out}] -rise_to [get_clocks {div:div25|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div25|out}] -fall_to [get_clocks {div:div25|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div25|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div25|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800|out}] -rise_to [get_clocks {div:div460800|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800|out}] -fall_to [get_clocks {div:div460800|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800|out}] -rise_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800|out}] -fall_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800|out}] -rise_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800|out}] -fall_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800|out}] -rise_to [get_clocks {div:div460800|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800|out}] -fall_to [get_clocks {div:div460800|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800|out}] -rise_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800|out}] -fall_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800|out}] -rise_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800|out}] -fall_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200|out}] -rise_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200|out}] -fall_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200|out}] -rise_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200|out}] -fall_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200|out}] -rise_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200|out}] -fall_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200|out}] -rise_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200|out}] -fall_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4|out}] -rise_to [get_clocks {div:div25|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4|out}] -fall_to [get_clocks {div:div25|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4|out}] -rise_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4|out}] -fall_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4|out}] -rise_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4|out}] -fall_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4|out}] -rise_to [get_clocks {div:div25|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4|out}] -fall_to [get_clocks {div:div25|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4|out}] -rise_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4|out}] -fall_to [get_clocks {div:div115200|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4|out}] -rise_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4|out}] -fall_to [get_clocks {div:div4|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50_B5B}] -rise_to [get_clocks {CLOCK_50_B5B}] -setup 0.280  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50_B5B}] -rise_to [get_clocks {CLOCK_50_B5B}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50_B5B}] -fall_to [get_clocks {CLOCK_50_B5B}] -setup 0.280  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50_B5B}] -fall_to [get_clocks {CLOCK_50_B5B}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50_B5B}] -rise_to [get_clocks {CLOCK_50_B5B}] -setup 0.280  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50_B5B}] -rise_to [get_clocks {CLOCK_50_B5B}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50_B5B}] -fall_to [get_clocks {CLOCK_50_B5B}] -setup 0.280  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50_B5B}] -fall_to [get_clocks {CLOCK_50_B5B}] -hold 0.270  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************


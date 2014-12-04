## Generated SDC file "gb.sdc"

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

## DATE    "Thu Dec 04 02:52:26 2014"

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
create_clock -name {div:div4mhz|out} -period 250.000 -waveform { 0.000 125.000 } [get_nets {div4mhz|out}]
create_clock -name {div:div115200hz|out} -period 8000.000 -waveform { 0.000 4000.000 } [get_nets {div115200hz|out}]
create_clock -name {div:div460800hz|out} -period 2000.000 -waveform { 0.000 1000.000 } [get_nets {div460800hz|out}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {div:div4mhz|out}] -rise_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4mhz|out}] -fall_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4mhz|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4mhz|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4mhz|out}] -rise_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4mhz|out}] -fall_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4mhz|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4mhz|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50_B5B}] -rise_to [get_clocks {CLOCK_50_B5B}] -setup 0.280  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50_B5B}] -rise_to [get_clocks {CLOCK_50_B5B}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50_B5B}] -fall_to [get_clocks {CLOCK_50_B5B}] -setup 0.280  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50_B5B}] -fall_to [get_clocks {CLOCK_50_B5B}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50_B5B}] -rise_to [get_clocks {CLOCK_50_B5B}] -setup 0.280  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50_B5B}] -rise_to [get_clocks {CLOCK_50_B5B}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50_B5B}] -fall_to [get_clocks {CLOCK_50_B5B}] -setup 0.280  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50_B5B}] -fall_to [get_clocks {CLOCK_50_B5B}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800hz|out}] -rise_to [get_clocks {div:div460800hz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800hz|out}] -fall_to [get_clocks {div:div460800hz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800hz|out}] -rise_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800hz|out}] -fall_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800hz|out}] -rise_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800hz|out}] -fall_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800hz|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div460800hz|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800hz|out}] -rise_to [get_clocks {div:div460800hz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800hz|out}] -fall_to [get_clocks {div:div460800hz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800hz|out}] -rise_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800hz|out}] -fall_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800hz|out}] -rise_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800hz|out}] -fall_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800hz|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div460800hz|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200hz|out}] -rise_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200hz|out}] -fall_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200hz|out}] -rise_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200hz|out}] -fall_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200hz|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div115200hz|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200hz|out}] -rise_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200hz|out}] -fall_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200hz|out}] -rise_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200hz|out}] -fall_to [get_clocks {div:div4mhz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200hz|out}] -rise_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div115200hz|out}] -fall_to [get_clocks {CLOCK_50_B5B}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4mhz|out}] -rise_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {div:div4mhz|out}] -fall_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4mhz|out}] -rise_to [get_clocks {div:div115200hz|out}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {div:div4mhz|out}] -fall_to [get_clocks {div:div115200hz|out}]  0.270  


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


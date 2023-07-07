## Clock Signal
set_property -dict {PACKAGE_PIN AC19 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets PAD_JTAG_TCLK]


## LEDs
set_property -dict {PACKAGE_PIN H7 IOSTANDARD LVCMOS33} [get_ports POUT_EHS]
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_0]
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_1]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_2]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports PAD_USI0_NSS]
set_property -dict {PACKAGE_PIN F7 IOSTANDARD LVCMOS33} [get_ports PAD_USI0_SD1]
set_property -dict {PACKAGE_PIN G8 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH9]
set_property -dict {PACKAGE_PIN H8 IOSTANDARD LVCMOS33} [get_ports PAD_USI2_NSS]


## Buttons
# set_property -dict { PACKAGE_PIN B22 IOSTANDARD LVCMOS33 } [get_ports { PAD_GPIO_8 }]; #IO_L20N_T3_16 Sch=btnc  缁橲PI_NSS
set_property -dict {PACKAGE_PIN Y5 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_9]
set_property -dict {PACKAGE_PIN V6 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_10]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_11]
set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_12]
set_property -dict {PACKAGE_PIN Y3 IOSTANDARD LVCMOS33} [get_ports PAD_MCURST]


## Switches  29 30 31
set_property -dict {PACKAGE_PIN AC21 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH10]
set_property -dict {PACKAGE_PIN AD24 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH11]
set_property -dict {PACKAGE_PIN AC22 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH0]
set_property -dict {PACKAGE_PIN AC23 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH1]
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH2]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_31]
set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_30]
set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_29]
# 0518


## OLED Display
set_property -dict {PACKAGE_PIN K26 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_21]
set_property -dict {PACKAGE_PIN J25 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_22]
set_property -dict {PACKAGE_PIN H21 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_23]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_24]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_25]
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_26]


## Pmod header 7JA      SOFT SPI TEST
set_property -dict {PACKAGE_PIN M25 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_28]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_27]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_3]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_13]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_14]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_15]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_16]
set_property -dict {PACKAGE_PIN P23 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_17]


## Pmod header JB
set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH3]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH4]
set_property -dict {PACKAGE_PIN P6 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH5]
set_property -dict {PACKAGE_PIN P5 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH6]
set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH7]
set_property -dict {PACKAGE_PIN T7 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_CH8]
set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS33} [get_ports PAD_JTAG_TMS]
set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS33} [get_ports PAD_JTAG_TCLK]


set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports PAD_USI1_NSS]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports PAD_USI1_SCLK]
set_property -dict {PACKAGE_PIN R8 IOSTANDARD LVCMOS33} [get_ports PAD_USI1_SD0]
set_property -dict {PACKAGE_PIN P8 IOSTANDARD LVCMOS33} [get_ports PAD_USI1_SD1]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports PAD_USI2_SCLK]
set_property -dict {PACKAGE_PIN R5 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_4]



## UART
# set_property -dict {PACKAGE_PIN F23 IOSTANDARD LVCMOS33} [get_ports PAD_USI0_SD0]
# set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports PAD_USI0_SCLK]
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports PAD_USI0_SD0];  #txd
set_property -dict {PACKAGE_PIN F23 IOSTANDARD LVCMOS33} [get_ports PAD_USI0_SCLK]; #rxd



## Fan PWM
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports PAD_PWM_FAULT]


## DPTI/DSPI
#set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { prog_clko }]; #IO_L13P_T2_MRCC_14 Sch=prog_clko
#set_property -dict { PACKAGE_PIN U20   IOSTANDARD LVCMOS33 } [get_ports { prog_d[0]}]; #IO_L11P_T1_SRCC_14 Sch=prog_d0/sck
#set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { prog_d[1] }]; #IO_L19P_T3_A10_D26_14 Sch=prog_d1/mosi
#set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { prog_d[2] }]; #IO_L22P_T3_A05_D21_14 Sch=prog_d2/miso
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { prog_d[3]}]; #IO_L18P_T2_A12_D28_14 Sch=prog_d3/ss
#set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { prog_d[4] }]; #IO_L24N_T3_A00_D16_14 Sch=prog_d[4]
#set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { prog_d[5] }]; #IO_L24P_T3_A01_D17_14 Sch=prog_d[5]
#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { prog_d[6] }]; #IO_L20P_T3_A08_D24_14 Sch=prog_d[6]
#set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { prog_d[7] }]; #IO_L23N_T3_A02_D18_14 Sch=prog_d[7]
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { prog_oen }]; #IO_L16P_T2_CSI_B_14 Sch=prog_oen
#set_property -dict { PACKAGE_PIN P19   IOSTANDARD LVCMOS33 } [get_ports { prog_rdn }]; #IO_L5P_T0_D06_14 Sch=prog_rdn
#set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { prog_rxen }]; #IO_L21P_T3_DQS_14 Sch=prog_rxen
#set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { prog_siwun }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=prog_siwun
#set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { prog_spien }]; #IO_L19N_T3_A09_D25_VREF_14 Sch=prog_spien
#set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { prog_txen }]; #IO_L13N_T2_MRCC_14 Sch=prog_txen
#set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { prog_wrn }]; #IO_L5N_T0_D07_14 Sch=prog_wrn


## HID port
#set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33   PULLUP true } [get_ports { ps2_clk }]; #IO_L16N_T2_A15_D31_14 Sch=ps2_clk
#set_property -dict { PACKAGE_PIN N13   IOSTANDARD LVCMOS33   PULLUP true } [get_ports { ps2_data }]; #IO_L23P_T3_A03_D19_14 Sch=ps2_data


## QSPI  FLASH
#            set_property -dict { PACKAGE_PIN T19   IOSTANDARD LVCMOS33 } [get_ports { qspi_cs }]; #IO_L6P_T0_FCS_B_14 Sch = qspi_cs
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_8]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports PAD_USI2_SD0]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports PAD_USI2_SD1]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {qspi_dq[0]}]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {qspi_dq[1]}]

## SD card
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_6]
set_property -dict {PACKAGE_PIN M26 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_18]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_5]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_7]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_19]
set_property -dict {PACKAGE_PIN L23 IOSTANDARD LVCMOS33} [get_ports PAD_GPIO_20]


## I2C
#set_property -dict { PACKAGE_PIN W5    IOSTANDARD LVCMOS33 } [get_ports { scl }]; #IO_L15N_T2_DQS_34 Sch=scl
#set_property -dict { PACKAGE_PIN V5    IOSTANDARD LVCMOS33 } [get_ports { sda }]; #IO_L16N_T2_34 Sch=sda


## Voltage Adjust
set_property -dict {PACKAGE_PIN AB26 IOSTANDARD LVCMOS33} [get_ports {set_vadj[0]}]
set_property -dict {PACKAGE_PIN W26 IOSTANDARD LVCMOS33} [get_ports {set_vadj[1]}]
set_property -dict {PACKAGE_PIN V21 IOSTANDARD LVCMOS33} [get_ports vadj_en]


## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

#set_false_path -from [get_clocks -of_objects [get_pins u_clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins u_clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]

# set_false_path -from [get_clocks -of_objects [get_pins u_clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]] -to [get_pins x_cpu1_top/CPU/x_cr_tcipif_top/x_cr_coretim_top/refclk_ff1_reg/D]
# set_false_path -from [get_clocks -of_objects [get_pins u_clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]] -to [get_pins x_cpu2_top/CPU/x_cr_tcipif_top/x_cr_coretim_top/refclk_ff1_reg/D]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list u_clk_wiz_0/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {iopmp/ahb_exp_addr[0]} {iopmp/ahb_exp_addr[1]} {iopmp/ahb_exp_addr[2]} {iopmp/ahb_exp_addr[3]} {iopmp/ahb_exp_addr[4]} {iopmp/ahb_exp_addr[5]} {iopmp/ahb_exp_addr[6]} {iopmp/ahb_exp_addr[7]} {iopmp/ahb_exp_addr[8]} {iopmp/ahb_exp_addr[9]} {iopmp/ahb_exp_addr[10]} {iopmp/ahb_exp_addr[11]} {iopmp/ahb_exp_addr[12]} {iopmp/ahb_exp_addr[13]} {iopmp/ahb_exp_addr[14]} {iopmp/ahb_exp_addr[15]} {iopmp/ahb_exp_addr[16]} {iopmp/ahb_exp_addr[17]} {iopmp/ahb_exp_addr[18]} {iopmp/ahb_exp_addr[19]} {iopmp/ahb_exp_addr[20]} {iopmp/ahb_exp_addr[21]} {iopmp/ahb_exp_addr[22]} {iopmp/ahb_exp_addr[23]} {iopmp/ahb_exp_addr[24]} {iopmp/ahb_exp_addr[25]} {iopmp/ahb_exp_addr[26]} {iopmp/ahb_exp_addr[27]} {iopmp/ahb_exp_addr[28]} {iopmp/ahb_exp_addr[29]} {iopmp/ahb_exp_addr[30]} {iopmp/ahb_exp_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {mbx/ch0_status[0]} {mbx/ch0_status[1]} {mbx/ch0_status[2]} {mbx/ch0_status[3]} {mbx/ch0_status[4]} {mbx/ch0_status[5]} {mbx/ch0_status[6]} {mbx/ch0_status[7]} {mbx/ch0_status[8]} {mbx/ch0_status[9]} {mbx/ch0_status[10]} {mbx/ch0_status[11]} {mbx/ch0_status[12]} {mbx/ch0_status[13]} {mbx/ch0_status[14]} {mbx/ch0_status[15]} {mbx/ch0_status[16]} {mbx/ch0_status[17]} {mbx/ch0_status[18]} {mbx/ch0_status[19]} {mbx/ch0_status[20]} {mbx/ch0_status[21]} {mbx/ch0_status[22]} {mbx/ch0_status[23]} {mbx/ch0_status[24]} {mbx/ch0_status[25]} {mbx/ch0_status[26]} {mbx/ch0_status[27]} {mbx/ch0_status[28]} {mbx/ch0_status[29]} {mbx/ch0_status[30]} {mbx/ch0_status[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {mbx/ch0_data[0]} {mbx/ch0_data[1]} {mbx/ch0_data[2]} {mbx/ch0_data[3]} {mbx/ch0_data[4]} {mbx/ch0_data[5]} {mbx/ch0_data[6]} {mbx/ch0_data[7]} {mbx/ch0_data[8]} {mbx/ch0_data[9]} {mbx/ch0_data[10]} {mbx/ch0_data[11]} {mbx/ch0_data[12]} {mbx/ch0_data[13]} {mbx/ch0_data[14]} {mbx/ch0_data[15]} {mbx/ch0_data[16]} {mbx/ch0_data[17]} {mbx/ch0_data[18]} {mbx/ch0_data[19]} {mbx/ch0_data[20]} {mbx/ch0_data[21]} {mbx/ch0_data[22]} {mbx/ch0_data[23]} {mbx/ch0_data[24]} {mbx/ch0_data[25]} {mbx/ch0_data[26]} {mbx/ch0_data[27]} {mbx/ch0_data[28]} {mbx/ch0_data[29]} {mbx/ch0_data[30]} {mbx/ch0_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {mbx/ch1_status[0]} {mbx/ch1_status[1]} {mbx/ch1_status[2]} {mbx/ch1_status[3]} {mbx/ch1_status[4]} {mbx/ch1_status[5]} {mbx/ch1_status[6]} {mbx/ch1_status[7]} {mbx/ch1_status[8]} {mbx/ch1_status[9]} {mbx/ch1_status[10]} {mbx/ch1_status[11]} {mbx/ch1_status[12]} {mbx/ch1_status[13]} {mbx/ch1_status[14]} {mbx/ch1_status[15]} {mbx/ch1_status[16]} {mbx/ch1_status[17]} {mbx/ch1_status[18]} {mbx/ch1_status[19]} {mbx/ch1_status[20]} {mbx/ch1_status[21]} {mbx/ch1_status[22]} {mbx/ch1_status[23]} {mbx/ch1_status[24]} {mbx/ch1_status[25]} {mbx/ch1_status[26]} {mbx/ch1_status[27]} {mbx/ch1_status[28]} {mbx/ch1_status[29]} {mbx/ch1_status[30]} {mbx/ch1_status[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {mbx/ch0_ctrl[0]} {mbx/ch0_ctrl[1]} {mbx/ch0_ctrl[2]} {mbx/ch0_ctrl[3]} {mbx/ch0_ctrl[4]} {mbx/ch0_ctrl[5]} {mbx/ch0_ctrl[6]} {mbx/ch0_ctrl[7]} {mbx/ch0_ctrl[8]} {mbx/ch0_ctrl[9]} {mbx/ch0_ctrl[10]} {mbx/ch0_ctrl[11]} {mbx/ch0_ctrl[12]} {mbx/ch0_ctrl[13]} {mbx/ch0_ctrl[14]} {mbx/ch0_ctrl[15]} {mbx/ch0_ctrl[16]} {mbx/ch0_ctrl[17]} {mbx/ch0_ctrl[18]} {mbx/ch0_ctrl[19]} {mbx/ch0_ctrl[20]} {mbx/ch0_ctrl[21]} {mbx/ch0_ctrl[22]} {mbx/ch0_ctrl[23]} {mbx/ch0_ctrl[24]} {mbx/ch0_ctrl[25]} {mbx/ch0_ctrl[26]} {mbx/ch0_ctrl[27]} {mbx/ch0_ctrl[28]} {mbx/ch0_ctrl[29]} {mbx/ch0_ctrl[30]} {mbx/ch0_ctrl[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {mbx/ch1_ctrl[0]} {mbx/ch1_ctrl[1]} {mbx/ch1_ctrl[2]} {mbx/ch1_ctrl[3]} {mbx/ch1_ctrl[4]} {mbx/ch1_ctrl[5]} {mbx/ch1_ctrl[6]} {mbx/ch1_ctrl[7]} {mbx/ch1_ctrl[8]} {mbx/ch1_ctrl[9]} {mbx/ch1_ctrl[10]} {mbx/ch1_ctrl[11]} {mbx/ch1_ctrl[12]} {mbx/ch1_ctrl[13]} {mbx/ch1_ctrl[14]} {mbx/ch1_ctrl[15]} {mbx/ch1_ctrl[16]} {mbx/ch1_ctrl[17]} {mbx/ch1_ctrl[18]} {mbx/ch1_ctrl[19]} {mbx/ch1_ctrl[20]} {mbx/ch1_ctrl[21]} {mbx/ch1_ctrl[22]} {mbx/ch1_ctrl[23]} {mbx/ch1_ctrl[24]} {mbx/ch1_ctrl[25]} {mbx/ch1_ctrl[26]} {mbx/ch1_ctrl[27]} {mbx/ch1_ctrl[28]} {mbx/ch1_ctrl[29]} {mbx/ch1_ctrl[30]} {mbx/ch1_ctrl[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {mbx/ch1_data[0]} {mbx/ch1_data[1]} {mbx/ch1_data[2]} {mbx/ch1_data[3]} {mbx/ch1_data[4]} {mbx/ch1_data[5]} {mbx/ch1_data[6]} {mbx/ch1_data[7]} {mbx/ch1_data[8]} {mbx/ch1_data[9]} {mbx/ch1_data[10]} {mbx/ch1_data[11]} {mbx/ch1_data[12]} {mbx/ch1_data[13]} {mbx/ch1_data[14]} {mbx/ch1_data[15]} {mbx/ch1_data[16]} {mbx/ch1_data[17]} {mbx/ch1_data[18]} {mbx/ch1_data[19]} {mbx/ch1_data[20]} {mbx/ch1_data[21]} {mbx/ch1_data[22]} {mbx/ch1_data[23]} {mbx/ch1_data[24]} {mbx/ch1_data[25]} {mbx/ch1_data[26]} {mbx/ch1_data[27]} {mbx/ch1_data[28]} {mbx/ch1_data[29]} {mbx/ch1_data[30]} {mbx/ch1_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list iopmp/access_deny_intr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list iopmp/ahb_exp_write]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list cpu0_mbx_intr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list cpu1_mbx_intr]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets POUT_EHS_OBUF]

# NOTE: typical usage would be "vivado -mode tcl -source create_mkPcieTop_batch.tcl" 
#
# STEP#0: define output directory area.
#
set outputDir ./hw
file mkdir $outputDir
#
# STEP#1: setup design sources and constraints
#
source board.tcl
read_verilog [ glob {verilog/top/*.v} ]
read_verilog [ glob /home/wjun/bluedbm_work/xbsv/verilog/*.v ]

read_xdc {./constraints/zc7z020clg484.xdc}
read_xdc {./constraints/bluesim.xdc}
if $needspcie {
    set pcieversion {3.0}
    set maxlinkwidth {X8}
    if {$boardname == {zc706}} {
        set maxlinkwidth {X4}
    }
    if {$boardname == {ac701}} {
        set maxlinkwidth {X4}
    }
    if {$boardname == {kc705}} {
    }
    if {$boardname == {vc707}} {
    }
    if {[version -short] == "2013.2"} {
        set pcieversion {2.1}
    }
    if {[lsearch [list_property [current_project]] board_part] >= 0} {
        set_property board_part "xilinx.com:$boardname:part0:1.0" [current_project]
    } else {
        ## vivado 2013.2 uses the BOARD property instead
        set board_candidates [get_boards *$boardname*]
        set_property BOARD [lindex $board_candidates [expr [llength $board_candidates] - 1]] [current_project]
    }
    report_property [current_project]
    if [file exists $xbsvdir/generated/xilinx/$boardname/pcie_7x_0/pcie_7x_0.xci] {
       read_ip $xbsvdir/generated/xilinx/$boardname/pcie_7x_0/pcie_7x_0.xci
    }  else {
        file mkdir $xbsvdir/generated/xilinx/$boardname
        create_ip -name pcie_7x -version $pcieversion -vendor xilinx.com -library ip -module_name pcie_7x_0 -dir $xbsvdir/generated/xilinx/$boardname
        set_property -dict [list                             CONFIG.mode_selection {Advanced}                             CONFIG.ASPM_Optionality {true}                             CONFIG.Buf_Opt_BMA {true}                             CONFIG.Bar0_64bit {true}                             CONFIG.Bar0_Size {8}                             CONFIG.Bar2_64bit {true}                             CONFIG.Bar2_Enabled {true}                             CONFIG.Bar2_Scale {Megabytes}                             CONFIG.Bar2_Size {1}                             CONFIG.Bar4_64bit {true}                             CONFIG.Bar4_Enabled {true}                             CONFIG.Bar4_Prefetchable {true}                             CONFIG.Bar4_Scale {Megabytes}                             CONFIG.Bar4_Size {1}                             CONFIG.Base_Class_Menu {Memory_controller}                             CONFIG.Device_ID {c100}                             CONFIG.IntX_Generation {false}                             CONFIG.MSI_Enabled {false}                             CONFIG.MSIx_Enabled {true}                             CONFIG.MSIx_PBA_Offset {a00}                             CONFIG.MSIx_Table_Offset {800}                             CONFIG.MSIx_Table_Size {10}                             CONFIG.Maximum_Link_Width $maxlinkwidth                             CONFIG.Subsystem_ID {a705}                             CONFIG.Subsystem_Vendor_ID {1be7}                             CONFIG.Use_Class_Code_Lookup_Assistant {false}                             CONFIG.Vendor_ID {1be7}                            ] [get_ips pcie_7x_0]
        report_property [get_ips pcie_7x_0]
        generate_target all [get_files $xbsvdir/generated/xilinx/$boardname/pcie_7x_0/pcie_7x_0.xci]
    }
        if [file exists $xbsvdir/generated/xilinx/$boardname/pcie_7x_0/pcie_7x_0.dcp] {
        } else {
            catch {
                synth_ip [get_ips pcie_7x_0]
            }
        }
}

# STEP#2: run synthesis, report utilization and timing estimates, write checkpoint design
#
synth_design -name mkBsimTop -top mkBsimTop -part xc7z020clg484-1 -flatten rebuilt

write_checkpoint -force $outputDir/mkbsimtop_post_synth
report_timing_summary -verbose  -file $outputDir/mkbsimtop_post_synth_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file $outputDir/mkbsimtop_post_synth_timing.rpt
report_utilization -verbose -file $outputDir/mkbsimtop_post_synth_utilization.txt
report_datasheet -file $outputDir/mkbsimtop_post_synth_datasheet.txt
write_verilog -force $outputDir/mkbsimtop_netlist.v
#report_power -file $outputDir/mkbsimtop_post_synth_power.rpt

#
# STEP#3: run placement and logic optimization, report utilization and timing estimates, write checkpoint design
#


foreach {pat} {CLK_unused_clock* CLK_GATE_unused_clock* RST_N_unused_reset* CLK_GATE_hdmi_clock_if CLK_*deleteme_unused_clock* CLK_GATE_*deleteme_unused_clock* RST_N_*deleteme_unused_reset*} {
    foreach {net} [get_nets $pat] {
	disconnect_net -net $net -objects [get_pins -of_objects $net]
    }
}

opt_design
# power_opt_design
place_design
phys_opt_design
write_checkpoint -force $outputDir/mkbsimtop_post_place
report_timing_summary -file $outputDir/mkbsimtop_post_place_timing_summary.rpt
#
# STEP#4: run router, report actual utilization and timing, write checkpoint design, run drc, write verilog and xdc out
#
route_design
write_checkpoint -force $outputDir/mkbsimtop_post_route
report_timing_summary -file $outputDir/mkbsimtop_post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file $outputDir/mkbsimtop_post_route_timing.rpt
report_clock_utilization -file $outputDir/mkbsimtop_clock_util.rpt
report_utilization -file $outputDir/mkbsimtop_post_route_util.rpt
report_datasheet -file $outputDir/mkbsimtop_post_route_datasheet.rpt
#report_power -file $outputDir/mkbsimtop_post_route_power.rpt
#report_drc -file $outputDir/mkbsimtop_post_imp_drc.rpt
#write_verilog -force $outputDir/mkbsimtop_impl_netlist.v
write_xdc -no_fixed_only -force $outputDir/mkbsimtop_impl.xdc
#
# STEP#5: generate a bitstream
# 
write_bitstream -force -bin_file $outputDir/mkBsimTop.bit

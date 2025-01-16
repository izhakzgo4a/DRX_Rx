
################################################################
# This is a generated script based on design: DRX_Rx_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source DRX_Rx_bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# VIDEO_BUF, CC1200_Controller, CC1200_Controller, CC1200_Controller, CC1200_Controller, rgb2dvi

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name DRX_Rx_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_crossbar:2.1\
xilinx.com:ip:jtag_axi:1.2\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:v_tc:6.2\
xilinx.com:ip:xlconcat:2.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
VIDEO_BUF\
CC1200_Controller\
CC1200_Controller\
CC1200_Controller\
CC1200_Controller\
rgb2dvi\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: HEIR_CC1200_3_GPIO
proc create_hier_cell_HEIR_CC1200_3_GPIO { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_CC1200_3_GPIO() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -type clk Clk_100MHz
  create_bd_pin -dir I -from 0 -to 0 In0_0
  create_bd_pin -dir I -from 0 -to 0 In1_0
  create_bd_pin -dir I -from 0 -to 0 In2_0
  create_bd_pin -dir I -type rst peripheral_aresetn

  # Create instance: CC1200_3_GPIO, and set properties
  set CC1200_3_GPIO [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_3_GPIO ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {3} \
 ] $CC1200_3_GPIO

  # Create instance: CC1200_GPIO_CONCAT_3, and set properties
  set CC1200_GPIO_CONCAT_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 CC1200_GPIO_CONCAT_3 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $CC1200_GPIO_CONCAT_3

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins CC1200_3_GPIO/S_AXI]

  # Create port connections
  connect_bd_net -net CC1200_GPIO_CONCAT_3_dout [get_bd_pins CC1200_3_GPIO/gpio_io_i] [get_bd_pins CC1200_GPIO_CONCAT_3/dout]
  connect_bd_net -net Clk_100MHz_1 [get_bd_pins Clk_100MHz] [get_bd_pins CC1200_3_GPIO/s_axi_aclk]
  connect_bd_net -net In0_0_1 [get_bd_pins In0_0] [get_bd_pins CC1200_GPIO_CONCAT_3/In0]
  connect_bd_net -net In1_0_1 [get_bd_pins In1_0] [get_bd_pins CC1200_GPIO_CONCAT_3/In1]
  connect_bd_net -net In2_0_1 [get_bd_pins In2_0] [get_bd_pins CC1200_GPIO_CONCAT_3/In2]
  connect_bd_net -net peripheral_aresetn_1 [get_bd_pins peripheral_aresetn] [get_bd_pins CC1200_3_GPIO/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_CC1200_2_GPIO
proc create_hier_cell_HEIR_CC1200_2_GPIO { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_CC1200_2_GPIO() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -type clk Clk_100MHz
  create_bd_pin -dir I -from 0 -to 0 In0_0
  create_bd_pin -dir I -from 0 -to 0 In1_0
  create_bd_pin -dir I -from 0 -to 0 In2_0
  create_bd_pin -dir I -type rst peripheral_aresetn

  # Create instance: CC1200_2_GPIO, and set properties
  set CC1200_2_GPIO [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_2_GPIO ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {3} \
 ] $CC1200_2_GPIO

  # Create instance: CC1200_GPIO_CONCAT_2, and set properties
  set CC1200_GPIO_CONCAT_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 CC1200_GPIO_CONCAT_2 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $CC1200_GPIO_CONCAT_2

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins CC1200_2_GPIO/S_AXI]

  # Create port connections
  connect_bd_net -net CC1200_GPIO_CONCAT_2_dout [get_bd_pins CC1200_2_GPIO/gpio_io_i] [get_bd_pins CC1200_GPIO_CONCAT_2/dout]
  connect_bd_net -net Clk_100MHz_1 [get_bd_pins Clk_100MHz] [get_bd_pins CC1200_2_GPIO/s_axi_aclk]
  connect_bd_net -net In0_0_1 [get_bd_pins In0_0] [get_bd_pins CC1200_GPIO_CONCAT_2/In0]
  connect_bd_net -net In1_0_1 [get_bd_pins In1_0] [get_bd_pins CC1200_GPIO_CONCAT_2/In1]
  connect_bd_net -net In2_0_1 [get_bd_pins In2_0] [get_bd_pins CC1200_GPIO_CONCAT_2/In2]
  connect_bd_net -net peripheral_aresetn_1 [get_bd_pins peripheral_aresetn] [get_bd_pins CC1200_2_GPIO/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_CC1200_1_GPIO
proc create_hier_cell_HEIR_CC1200_1_GPIO { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_CC1200_1_GPIO() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -type clk Clk_100MHz
  create_bd_pin -dir I -from 0 -to 0 In0_0
  create_bd_pin -dir I -from 0 -to 0 In1_0
  create_bd_pin -dir I -from 0 -to 0 In2_0
  create_bd_pin -dir I -type rst peripheral_aresetn

  # Create instance: CC1200_1_GPIO, and set properties
  set CC1200_1_GPIO [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_1_GPIO ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {3} \
 ] $CC1200_1_GPIO

  # Create instance: CC1200_GPIO_CONCAT_1, and set properties
  set CC1200_GPIO_CONCAT_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 CC1200_GPIO_CONCAT_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $CC1200_GPIO_CONCAT_1

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins CC1200_1_GPIO/S_AXI]

  # Create port connections
  connect_bd_net -net CC1200_GPIO_CONCAT_1_dout [get_bd_pins CC1200_1_GPIO/gpio_io_i] [get_bd_pins CC1200_GPIO_CONCAT_1/dout]
  connect_bd_net -net Clk_100MHz_1 [get_bd_pins Clk_100MHz] [get_bd_pins CC1200_1_GPIO/s_axi_aclk]
  connect_bd_net -net In0_0_1 [get_bd_pins In0_0] [get_bd_pins CC1200_GPIO_CONCAT_1/In0]
  connect_bd_net -net In1_0_1 [get_bd_pins In1_0] [get_bd_pins CC1200_GPIO_CONCAT_1/In1]
  connect_bd_net -net In2_0_1 [get_bd_pins In2_0] [get_bd_pins CC1200_GPIO_CONCAT_1/In2]
  connect_bd_net -net peripheral_aresetn_1 [get_bd_pins peripheral_aresetn] [get_bd_pins CC1200_1_GPIO/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_CC1200_0_GPIO
proc create_hier_cell_HEIR_CC1200_0_GPIO { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_CC1200_0_GPIO() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 In0_0
  create_bd_pin -dir I -from 0 -to 0 In1_0
  create_bd_pin -dir I -from 0 -to 0 In2_0
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: CC1200_0_GPIO, and set properties
  set CC1200_0_GPIO [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_0_GPIO ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {3} \
 ] $CC1200_0_GPIO

  # Create instance: CC1200_GPIO_CONCAT_0, and set properties
  set CC1200_GPIO_CONCAT_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 CC1200_GPIO_CONCAT_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $CC1200_GPIO_CONCAT_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins CC1200_0_GPIO/S_AXI]

  # Create port connections
  connect_bd_net -net CC1200_GPIO_CONCAT_0_dout [get_bd_pins CC1200_0_GPIO/gpio_io_i] [get_bd_pins CC1200_GPIO_CONCAT_0/dout]
  connect_bd_net -net In0_0_1 [get_bd_pins In0_0] [get_bd_pins CC1200_GPIO_CONCAT_0/In0]
  connect_bd_net -net In1_0_1 [get_bd_pins In1_0] [get_bd_pins CC1200_GPIO_CONCAT_0/In1]
  connect_bd_net -net In2_0_1 [get_bd_pins In2_0] [get_bd_pins CC1200_GPIO_CONCAT_0/In2]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins CC1200_0_GPIO/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins CC1200_0_GPIO/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_CC1200_RST
proc create_hier_cell_HEIR_CC1200_RST { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_CC1200_RST() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Dout
  create_bd_pin -dir O -from 0 -to 0 Dout1
  create_bd_pin -dir O -from 0 -to 0 Dout2
  create_bd_pin -dir O -from 0 -to 0 Dout3
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: CC1200_RST, and set properties
  set CC1200_RST [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_RST ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_DOUT_DEFAULT {0x0000000f} \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $CC1200_RST

  # Create instance: CC1200_RST_0, and set properties
  set CC1200_RST_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 CC1200_RST_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {4} \
 ] $CC1200_RST_0

  # Create instance: CC1200_RST_1, and set properties
  set CC1200_RST_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 CC1200_RST_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {4} \
 ] $CC1200_RST_1

  # Create instance: CC1200_RST_2, and set properties
  set CC1200_RST_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 CC1200_RST_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $CC1200_RST_2

  # Create instance: CC1200_RST_3, and set properties
  set CC1200_RST_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 CC1200_RST_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $CC1200_RST_3

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins CC1200_RST/S_AXI]

  # Create port connections
  connect_bd_net -net CC1200_RST_0_Dout [get_bd_pins Dout] [get_bd_pins CC1200_RST_0/Dout]
  connect_bd_net -net CC1200_RST_1_Dout [get_bd_pins Dout1] [get_bd_pins CC1200_RST_1/Dout]
  connect_bd_net -net CC1200_RST_2_Dout [get_bd_pins Dout3] [get_bd_pins CC1200_RST_2/Dout]
  connect_bd_net -net CC1200_RST_3_Dout [get_bd_pins Dout2] [get_bd_pins CC1200_RST_3/Dout]
  connect_bd_net -net CC1200_RST_gpio_io_o [get_bd_pins CC1200_RST/gpio_io_o] [get_bd_pins CC1200_RST_0/Din] [get_bd_pins CC1200_RST_1/Din] [get_bd_pins CC1200_RST_2/Din] [get_bd_pins CC1200_RST_3/Din]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins CC1200_RST/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins CC1200_RST/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_CC1200_REG_OUT
proc create_hier_cell_HEIR_CC1200_REG_OUT { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_CC1200_REG_OUT() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3


  # Create pins
  create_bd_pin -dir I -from 23 -to 0 gpio_io_i
  create_bd_pin -dir I -from 23 -to 0 gpio_io_i1
  create_bd_pin -dir I -from 23 -to 0 gpio_io_i2
  create_bd_pin -dir I -from 23 -to 0 gpio_io_i3
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: CC1200_REG_OUT_0, and set properties
  set CC1200_REG_OUT_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_REG_OUT_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {24} \
 ] $CC1200_REG_OUT_0

  # Create instance: CC1200_REG_OUT_1, and set properties
  set CC1200_REG_OUT_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_REG_OUT_1 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {24} \
 ] $CC1200_REG_OUT_1

  # Create instance: CC1200_REG_OUT_2, and set properties
  set CC1200_REG_OUT_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_REG_OUT_2 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {24} \
 ] $CC1200_REG_OUT_2

  # Create instance: CC1200_REG_OUT_3, and set properties
  set CC1200_REG_OUT_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_REG_OUT_3 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {24} \
 ] $CC1200_REG_OUT_3

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins CC1200_REG_OUT_0/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins CC1200_REG_OUT_1/S_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins CC1200_REG_OUT_2/S_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins CC1200_REG_OUT_3/S_AXI]

  # Create port connections
  connect_bd_net -net gpio_io_i1_1 [get_bd_pins gpio_io_i1] [get_bd_pins CC1200_REG_OUT_2/gpio_io_i]
  connect_bd_net -net gpio_io_i2_1 [get_bd_pins gpio_io_i2] [get_bd_pins CC1200_REG_OUT_1/gpio_io_i]
  connect_bd_net -net gpio_io_i3_1 [get_bd_pins gpio_io_i3] [get_bd_pins CC1200_REG_OUT_0/gpio_io_i]
  connect_bd_net -net gpio_io_i_1 [get_bd_pins gpio_io_i] [get_bd_pins CC1200_REG_OUT_3/gpio_io_i]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins CC1200_REG_OUT_0/s_axi_aclk] [get_bd_pins CC1200_REG_OUT_1/s_axi_aclk] [get_bd_pins CC1200_REG_OUT_2/s_axi_aclk] [get_bd_pins CC1200_REG_OUT_3/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins CC1200_REG_OUT_0/s_axi_aresetn] [get_bd_pins CC1200_REG_OUT_1/s_axi_aresetn] [get_bd_pins CC1200_REG_OUT_2/s_axi_aresetn] [get_bd_pins CC1200_REG_OUT_3/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_CC1200_REG_IN
proc create_hier_cell_HEIR_CC1200_REG_IN { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_CC1200_REG_IN() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3


  # Create pins
  create_bd_pin -dir O -from 23 -to 0 gpio_io_o
  create_bd_pin -dir O -from 23 -to 0 gpio_io_o1
  create_bd_pin -dir O -from 23 -to 0 gpio_io_o2
  create_bd_pin -dir O -from 23 -to 0 gpio_io_o3
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: CC1200_REG_IN_0, and set properties
  set CC1200_REG_IN_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_REG_IN_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {24} \
 ] $CC1200_REG_IN_0

  # Create instance: CC1200_REG_IN_1, and set properties
  set CC1200_REG_IN_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_REG_IN_1 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {24} \
 ] $CC1200_REG_IN_1

  # Create instance: CC1200_REG_IN_2, and set properties
  set CC1200_REG_IN_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_REG_IN_2 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {24} \
 ] $CC1200_REG_IN_2

  # Create instance: CC1200_REG_IN_3, and set properties
  set CC1200_REG_IN_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_REG_IN_3 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {24} \
 ] $CC1200_REG_IN_3

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins CC1200_REG_IN_0/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins CC1200_REG_IN_1/S_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins CC1200_REG_IN_2/S_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins CC1200_REG_IN_3/S_AXI]

  # Create port connections
  connect_bd_net -net CC1200_REG_IN_0_gpio_io_o [get_bd_pins gpio_io_o] [get_bd_pins CC1200_REG_IN_0/gpio_io_o]
  connect_bd_net -net CC1200_REG_IN_1_gpio_io_o [get_bd_pins gpio_io_o1] [get_bd_pins CC1200_REG_IN_1/gpio_io_o]
  connect_bd_net -net CC1200_REG_IN_2_gpio_io_o [get_bd_pins gpio_io_o2] [get_bd_pins CC1200_REG_IN_2/gpio_io_o]
  connect_bd_net -net CC1200_REG_IN_3_gpio_io_o [get_bd_pins gpio_io_o3] [get_bd_pins CC1200_REG_IN_3/gpio_io_o]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins CC1200_REG_IN_0/s_axi_aclk] [get_bd_pins CC1200_REG_IN_1/s_axi_aclk] [get_bd_pins CC1200_REG_IN_2/s_axi_aclk] [get_bd_pins CC1200_REG_IN_3/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins CC1200_REG_IN_0/s_axi_aresetn] [get_bd_pins CC1200_REG_IN_1/s_axi_aresetn] [get_bd_pins CC1200_REG_IN_2/s_axi_aresetn] [get_bd_pins CC1200_REG_IN_3/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_CC1200_REG_CS
proc create_hier_cell_HEIR_CC1200_REG_CS { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_CC1200_REG_CS() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Dout
  create_bd_pin -dir O -from 0 -to 0 Dout1
  create_bd_pin -dir O -from 0 -to 0 Dout2
  create_bd_pin -dir O -from 0 -to 0 Dout3
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: CC1200_REG_CS, and set properties
  set CC1200_REG_CS [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_REG_CS ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $CC1200_REG_CS

  # Create instance: CC1200_REG_CS_0, and set properties
  set CC1200_REG_CS_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 CC1200_REG_CS_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {4} \
 ] $CC1200_REG_CS_0

  # Create instance: CC1200_REG_CS_1, and set properties
  set CC1200_REG_CS_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 CC1200_REG_CS_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {4} \
 ] $CC1200_REG_CS_1

  # Create instance: CC1200_REG_CS_2, and set properties
  set CC1200_REG_CS_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 CC1200_REG_CS_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $CC1200_REG_CS_2

  # Create instance: CC1200_REG_CS_3, and set properties
  set CC1200_REG_CS_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 CC1200_REG_CS_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $CC1200_REG_CS_3

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins CC1200_REG_CS/S_AXI]

  # Create port connections
  connect_bd_net -net CC1200_REG_CS_0_Dout [get_bd_pins Dout] [get_bd_pins CC1200_REG_CS_0/Dout]
  connect_bd_net -net CC1200_REG_CS_1_Dout [get_bd_pins Dout1] [get_bd_pins CC1200_REG_CS_1/Dout]
  connect_bd_net -net CC1200_REG_CS_2_Dout [get_bd_pins Dout3] [get_bd_pins CC1200_REG_CS_2/Dout]
  connect_bd_net -net CC1200_REG_CS_3_Dout [get_bd_pins Dout2] [get_bd_pins CC1200_REG_CS_3/Dout]
  connect_bd_net -net CC1200_REG_CS_gpio_io_o [get_bd_pins CC1200_REG_CS/gpio_io_o] [get_bd_pins CC1200_REG_CS_0/Din] [get_bd_pins CC1200_REG_CS_1/Din] [get_bd_pins CC1200_REG_CS_2/Din] [get_bd_pins CC1200_REG_CS_3/Din]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins CC1200_REG_CS/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins CC1200_REG_CS/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_CC1200_READY
proc create_hier_cell_HEIR_CC1200_READY { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_CC1200_READY() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 In0
  create_bd_pin -dir I -from 0 -to 0 In1
  create_bd_pin -dir I -from 0 -to 0 In2
  create_bd_pin -dir I -from 0 -to 0 In3
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: CC1200_READY, and set properties
  set CC1200_READY [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_READY ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $CC1200_READY

  # Create instance: CC1200_READY_CONCAT, and set properties
  set CC1200_READY_CONCAT [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 CC1200_READY_CONCAT ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $CC1200_READY_CONCAT

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins CC1200_READY/S_AXI]

  # Create port connections
  connect_bd_net -net CC1200_READY_CONCAT_dout [get_bd_pins CC1200_READY/gpio_io_i] [get_bd_pins CC1200_READY_CONCAT/dout]
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins CC1200_READY_CONCAT/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins CC1200_READY_CONCAT/In1]
  connect_bd_net -net In2_1 [get_bd_pins In2] [get_bd_pins CC1200_READY_CONCAT/In2]
  connect_bd_net -net In3_1 [get_bd_pins In3] [get_bd_pins CC1200_READY_CONCAT/In3]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins CC1200_READY/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins CC1200_READY/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_CC1200_GPIO
proc create_hier_cell_HEIR_CC1200_GPIO { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_CC1200_GPIO() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 In0_0
  create_bd_pin -dir I -from 0 -to 0 In0_1
  create_bd_pin -dir I -from 0 -to 0 In0_2
  create_bd_pin -dir I -from 0 -to 0 In0_3
  create_bd_pin -dir I -from 0 -to 0 In1_0
  create_bd_pin -dir I -from 0 -to 0 In1_1
  create_bd_pin -dir I -from 0 -to 0 In1_2
  create_bd_pin -dir I -from 0 -to 0 In1_3
  create_bd_pin -dir I -from 0 -to 0 In2_0
  create_bd_pin -dir I -from 0 -to 0 In2_1
  create_bd_pin -dir I -from 0 -to 0 In2_2
  create_bd_pin -dir I -from 0 -to 0 In2_3
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: HEIR_CC1200_0_GPIO
  create_hier_cell_HEIR_CC1200_0_GPIO $hier_obj HEIR_CC1200_0_GPIO

  # Create instance: HEIR_CC1200_1_GPIO
  create_hier_cell_HEIR_CC1200_1_GPIO $hier_obj HEIR_CC1200_1_GPIO

  # Create instance: HEIR_CC1200_2_GPIO
  create_hier_cell_HEIR_CC1200_2_GPIO $hier_obj HEIR_CC1200_2_GPIO

  # Create instance: HEIR_CC1200_3_GPIO
  create_hier_cell_HEIR_CC1200_3_GPIO $hier_obj HEIR_CC1200_3_GPIO

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins HEIR_CC1200_0_GPIO/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins HEIR_CC1200_1_GPIO/S_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins HEIR_CC1200_2_GPIO/S_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins HEIR_CC1200_3_GPIO/S_AXI]

  # Create port connections
  connect_bd_net -net In0_0_1 [get_bd_pins In0_0] [get_bd_pins HEIR_CC1200_0_GPIO/In0_0]
  connect_bd_net -net In0_0_2 [get_bd_pins In0_1] [get_bd_pins HEIR_CC1200_1_GPIO/In0_0]
  connect_bd_net -net In0_0_3 [get_bd_pins In0_2] [get_bd_pins HEIR_CC1200_2_GPIO/In0_0]
  connect_bd_net -net In0_0_4 [get_bd_pins In0_3] [get_bd_pins HEIR_CC1200_3_GPIO/In0_0]
  connect_bd_net -net In1_0_1 [get_bd_pins In1_0] [get_bd_pins HEIR_CC1200_0_GPIO/In1_0]
  connect_bd_net -net In1_0_2 [get_bd_pins In1_1] [get_bd_pins HEIR_CC1200_1_GPIO/In1_0]
  connect_bd_net -net In1_0_3 [get_bd_pins In1_2] [get_bd_pins HEIR_CC1200_2_GPIO/In1_0]
  connect_bd_net -net In1_0_4 [get_bd_pins In1_3] [get_bd_pins HEIR_CC1200_3_GPIO/In1_0]
  connect_bd_net -net In2_0_1 [get_bd_pins In2_0] [get_bd_pins HEIR_CC1200_0_GPIO/In2_0]
  connect_bd_net -net In2_0_2 [get_bd_pins In2_1] [get_bd_pins HEIR_CC1200_1_GPIO/In2_0]
  connect_bd_net -net In2_0_3 [get_bd_pins In2_2] [get_bd_pins HEIR_CC1200_2_GPIO/In2_0]
  connect_bd_net -net In2_0_4 [get_bd_pins In2_3] [get_bd_pins HEIR_CC1200_3_GPIO/In2_0]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins HEIR_CC1200_0_GPIO/s_axi_aclk] [get_bd_pins HEIR_CC1200_1_GPIO/Clk_100MHz] [get_bd_pins HEIR_CC1200_2_GPIO/Clk_100MHz] [get_bd_pins HEIR_CC1200_3_GPIO/Clk_100MHz]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins HEIR_CC1200_0_GPIO/s_axi_aresetn] [get_bd_pins HEIR_CC1200_1_GPIO/peripheral_aresetn] [get_bd_pins HEIR_CC1200_2_GPIO/peripheral_aresetn] [get_bd_pins HEIR_CC1200_3_GPIO/peripheral_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_ZQ2REG
proc create_hier_cell_HEIR_ZQ2REG { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_ZQ2REG() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI16


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_0_0
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_0_1
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_0_2
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_0_3
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_2_0
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_2_1
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_2_2
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_2_3
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_3_0
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_3_1
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_3_2
  create_bd_pin -dir I -from 0 -to 0 CC1200_GPIO_3_3
  create_bd_pin -dir O -from 0 -to 0 Dout
  create_bd_pin -dir O -from 0 -to 0 Dout1
  create_bd_pin -dir O -from 0 -to 0 Dout2
  create_bd_pin -dir O -from 0 -to 0 Dout3
  create_bd_pin -dir O -from 0 -to 0 Dout4
  create_bd_pin -dir O -from 0 -to 0 Dout5
  create_bd_pin -dir O -from 0 -to 0 Dout6
  create_bd_pin -dir O -from 0 -to 0 Dout7
  create_bd_pin -dir I -from 0 -to 0 In0
  create_bd_pin -dir I -from 0 -to 0 In1
  create_bd_pin -dir I -from 0 -to 0 In2
  create_bd_pin -dir I -from 0 -to 0 In3
  create_bd_pin -dir I -from 23 -to 0 gpio_io_i
  create_bd_pin -dir I -from 23 -to 0 gpio_io_i1
  create_bd_pin -dir I -from 23 -to 0 gpio_io_i2
  create_bd_pin -dir I -from 23 -to 0 gpio_io_i3
  create_bd_pin -dir O -from 23 -to 0 gpio_io_o
  create_bd_pin -dir O -from 23 -to 0 gpio_io_o1
  create_bd_pin -dir O -from 23 -to 0 gpio_io_o2
  create_bd_pin -dir O -from 23 -to 0 gpio_io_o3
  create_bd_pin -dir O -from 7 -to 0 gpio_io_o4
  create_bd_pin -dir O -from 3 -to 0 gpio_io_o5
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: CC1200_FIFO_TH, and set properties
  set CC1200_FIFO_TH [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CC1200_FIFO_TH ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {8} \
 ] $CC1200_FIFO_TH

  # Create instance: HEIR_CC1200_GPIO
  create_hier_cell_HEIR_CC1200_GPIO $hier_obj HEIR_CC1200_GPIO

  # Create instance: HEIR_CC1200_READY
  create_hier_cell_HEIR_CC1200_READY $hier_obj HEIR_CC1200_READY

  # Create instance: HEIR_CC1200_REG_CS
  create_hier_cell_HEIR_CC1200_REG_CS $hier_obj HEIR_CC1200_REG_CS

  # Create instance: HEIR_CC1200_REG_IN
  create_hier_cell_HEIR_CC1200_REG_IN $hier_obj HEIR_CC1200_REG_IN

  # Create instance: HEIR_CC1200_REG_OUT
  create_hier_cell_HEIR_CC1200_REG_OUT $hier_obj HEIR_CC1200_REG_OUT

  # Create instance: HEIR_CC1200_RST
  create_hier_cell_HEIR_CC1200_RST $hier_obj HEIR_CC1200_RST

  # Create instance: UPSAMPLE_FACTOR, and set properties
  set UPSAMPLE_FACTOR [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 UPSAMPLE_FACTOR ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_DOUT_DEFAULT {0x00000004} \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $UPSAMPLE_FACTOR

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI15] [get_bd_intf_pins CC1200_FIFO_TH/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI16] [get_bd_intf_pins UPSAMPLE_FACTOR/S_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins S_AXI11] [get_bd_intf_pins HEIR_CC1200_GPIO/S_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins S_AXI12] [get_bd_intf_pins HEIR_CC1200_GPIO/S_AXI1]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins S_AXI13] [get_bd_intf_pins HEIR_CC1200_GPIO/S_AXI2]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins S_AXI14] [get_bd_intf_pins HEIR_CC1200_GPIO/S_AXI3]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins S_AXI6] [get_bd_intf_pins HEIR_CC1200_READY/S_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M05_AXI [get_bd_intf_pins S_AXI1] [get_bd_intf_pins HEIR_CC1200_REG_CS/S_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI2] [get_bd_intf_pins HEIR_CC1200_REG_IN/S_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M07_AXI [get_bd_intf_pins S_AXI3] [get_bd_intf_pins HEIR_CC1200_REG_IN/S_AXI1]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M08_AXI [get_bd_intf_pins S_AXI4] [get_bd_intf_pins HEIR_CC1200_REG_IN/S_AXI2]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M09_AXI [get_bd_intf_pins S_AXI5] [get_bd_intf_pins HEIR_CC1200_REG_IN/S_AXI3]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M10_AXI [get_bd_intf_pins S_AXI7] [get_bd_intf_pins HEIR_CC1200_REG_OUT/S_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M11_AXI [get_bd_intf_pins S_AXI8] [get_bd_intf_pins HEIR_CC1200_REG_OUT/S_AXI1]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M12_AXI [get_bd_intf_pins S_AXI9] [get_bd_intf_pins HEIR_CC1200_REG_OUT/S_AXI2]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M13_AXI [get_bd_intf_pins S_AXI10] [get_bd_intf_pins HEIR_CC1200_REG_OUT/S_AXI3]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M14_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins HEIR_CC1200_RST/S_AXI]

  # Create port connections
  connect_bd_net -net CC1200_Controller_0_CC1200_READY [get_bd_pins In0] [get_bd_pins HEIR_CC1200_READY/In0]
  connect_bd_net -net CC1200_Controller_0_REG_OUT [get_bd_pins gpio_io_i3] [get_bd_pins HEIR_CC1200_REG_OUT/gpio_io_i3]
  connect_bd_net -net CC1200_Controller_1_CC1200_READY [get_bd_pins In1] [get_bd_pins HEIR_CC1200_READY/In1]
  connect_bd_net -net CC1200_Controller_1_REG_OUT [get_bd_pins gpio_io_i2] [get_bd_pins HEIR_CC1200_REG_OUT/gpio_io_i2]
  connect_bd_net -net CC1200_Controller_2_CC1200_READY [get_bd_pins In2] [get_bd_pins HEIR_CC1200_READY/In2]
  connect_bd_net -net CC1200_Controller_2_REG_OUT [get_bd_pins gpio_io_i1] [get_bd_pins HEIR_CC1200_REG_OUT/gpio_io_i1]
  connect_bd_net -net CC1200_Controller_3_CC1200_READY [get_bd_pins In3] [get_bd_pins HEIR_CC1200_READY/In3]
  connect_bd_net -net CC1200_Controller_3_REG_OUT [get_bd_pins gpio_io_i] [get_bd_pins HEIR_CC1200_REG_OUT/gpio_io_i]
  connect_bd_net -net CC1200_FIFO_TH_gpio_io_o [get_bd_pins gpio_io_o4] [get_bd_pins CC1200_FIFO_TH/gpio_io_o]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout [get_bd_pins Dout4] [get_bd_pins HEIR_CC1200_REG_CS/Dout]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout1 [get_bd_pins Dout5] [get_bd_pins HEIR_CC1200_REG_CS/Dout1]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout2 [get_bd_pins Dout6] [get_bd_pins HEIR_CC1200_REG_CS/Dout2]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout3 [get_bd_pins Dout7] [get_bd_pins HEIR_CC1200_REG_CS/Dout3]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o [get_bd_pins gpio_io_o] [get_bd_pins HEIR_CC1200_REG_IN/gpio_io_o]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o1 [get_bd_pins gpio_io_o1] [get_bd_pins HEIR_CC1200_REG_IN/gpio_io_o1]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o2 [get_bd_pins gpio_io_o2] [get_bd_pins HEIR_CC1200_REG_IN/gpio_io_o2]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o3 [get_bd_pins gpio_io_o3] [get_bd_pins HEIR_CC1200_REG_IN/gpio_io_o3]
  connect_bd_net -net HEIR_CC1200_RST_Dout [get_bd_pins Dout] [get_bd_pins HEIR_CC1200_RST/Dout]
  connect_bd_net -net HEIR_CC1200_RST_Dout1 [get_bd_pins Dout1] [get_bd_pins HEIR_CC1200_RST/Dout1]
  connect_bd_net -net HEIR_CC1200_RST_Dout2 [get_bd_pins Dout2] [get_bd_pins HEIR_CC1200_RST/Dout2]
  connect_bd_net -net HEIR_CC1200_RST_Dout3 [get_bd_pins Dout3] [get_bd_pins HEIR_CC1200_RST/Dout3]
  connect_bd_net -net In0_0_1 [get_bd_pins CC1200_GPIO_0_0] [get_bd_pins HEIR_CC1200_GPIO/In0_0]
  connect_bd_net -net In0_0_2 [get_bd_pins CC1200_GPIO_0_1] [get_bd_pins HEIR_CC1200_GPIO/In0_1]
  connect_bd_net -net In0_0_3 [get_bd_pins CC1200_GPIO_0_2] [get_bd_pins HEIR_CC1200_GPIO/In0_2]
  connect_bd_net -net In0_0_4 [get_bd_pins CC1200_GPIO_0_3] [get_bd_pins HEIR_CC1200_GPIO/In0_3]
  connect_bd_net -net In1_0_1 [get_bd_pins CC1200_GPIO_2_0] [get_bd_pins HEIR_CC1200_GPIO/In1_0]
  connect_bd_net -net In1_0_2 [get_bd_pins CC1200_GPIO_2_1] [get_bd_pins HEIR_CC1200_GPIO/In1_1]
  connect_bd_net -net In1_0_3 [get_bd_pins CC1200_GPIO_2_2] [get_bd_pins HEIR_CC1200_GPIO/In1_2]
  connect_bd_net -net In1_0_4 [get_bd_pins CC1200_GPIO_2_3] [get_bd_pins HEIR_CC1200_GPIO/In1_3]
  connect_bd_net -net In2_0_1 [get_bd_pins CC1200_GPIO_3_0] [get_bd_pins HEIR_CC1200_GPIO/In2_0]
  connect_bd_net -net In2_0_2 [get_bd_pins CC1200_GPIO_3_1] [get_bd_pins HEIR_CC1200_GPIO/In2_1]
  connect_bd_net -net In2_0_3 [get_bd_pins CC1200_GPIO_3_2] [get_bd_pins HEIR_CC1200_GPIO/In2_2]
  connect_bd_net -net In2_0_4 [get_bd_pins CC1200_GPIO_3_3] [get_bd_pins HEIR_CC1200_GPIO/In2_3]
  connect_bd_net -net PLL_Clk_100MHz [get_bd_pins s_axi_aclk] [get_bd_pins CC1200_FIFO_TH/s_axi_aclk] [get_bd_pins HEIR_CC1200_GPIO/s_axi_aclk] [get_bd_pins HEIR_CC1200_READY/s_axi_aclk] [get_bd_pins HEIR_CC1200_REG_CS/s_axi_aclk] [get_bd_pins HEIR_CC1200_REG_IN/s_axi_aclk] [get_bd_pins HEIR_CC1200_REG_OUT/s_axi_aclk] [get_bd_pins HEIR_CC1200_RST/s_axi_aclk] [get_bd_pins UPSAMPLE_FACTOR/s_axi_aclk]
  connect_bd_net -net RST_100M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins CC1200_FIFO_TH/s_axi_aresetn] [get_bd_pins HEIR_CC1200_GPIO/s_axi_aresetn] [get_bd_pins HEIR_CC1200_READY/s_axi_aresetn] [get_bd_pins HEIR_CC1200_REG_CS/s_axi_aresetn] [get_bd_pins HEIR_CC1200_REG_IN/s_axi_aresetn] [get_bd_pins HEIR_CC1200_REG_OUT/s_axi_aresetn] [get_bd_pins HEIR_CC1200_RST/s_axi_aresetn] [get_bd_pins UPSAMPLE_FACTOR/s_axi_aresetn]
  connect_bd_net -net UPSAMPLE_FACTOR_gpio_io_o [get_bd_pins gpio_io_o5] [get_bd_pins UPSAMPLE_FACTOR/gpio_io_o]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_VIDEO
proc create_hier_cell_HEIR_VIDEO { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_VIDEO() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I SerialClk
  create_bd_pin -dir O -type clk TMDS_Clk_n
  create_bd_pin -dir O -type clk TMDS_Clk_p
  create_bd_pin -dir O -from 2 -to 0 TMDS_Data_n
  create_bd_pin -dir O -from 2 -to 0 TMDS_Data_p
  create_bd_pin -dir I aRst
  create_bd_pin -dir O active_video_out
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I gen_clken
  create_bd_pin -dir O hsync_out
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir I -from 23 -to 0 vid_pData
  create_bd_pin -dir I vid_pHSync
  create_bd_pin -dir I vid_pVDE
  create_bd_pin -dir I vid_pVSync
  create_bd_pin -dir O vsync_out

  # Create instance: rgb2dvi_0, and set properties
  set block_name rgb2dvi
  set block_cell_name rgb2dvi_0
  if { [catch {set rgb2dvi_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $rgb2dvi_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.kGenerateSerialClk {false} \
 ] $rgb2dvi_0

  # Create instance: v_tc_0, and set properties
  set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.2 v_tc_0 ]
  set_property -dict [ list \
   CONFIG.GEN_F0_VFRAME_SIZE {525} \
   CONFIG.GEN_F0_VSYNC_HSTART {695} \
   CONFIG.GEN_F0_VSYNC_VEND {491} \
   CONFIG.GEN_F0_VSYNC_VSTART {489} \
   CONFIG.GEN_F1_VFRAME_SIZE {525} \
   CONFIG.GEN_F1_VSYNC_VEND {491} \
   CONFIG.GEN_F1_VSYNC_VSTART {489} \
   CONFIG.GEN_HACTIVE_SIZE {640} \
   CONFIG.GEN_HFRAME_SIZE {800} \
   CONFIG.GEN_HSYNC_END {752} \
   CONFIG.GEN_HSYNC_START {656} \
   CONFIG.GEN_VACTIVE_SIZE {480} \
   CONFIG.HAS_AXI4_LITE {false} \
   CONFIG.VIDEO_MODE {480p} \
   CONFIG.enable_detection {false} \
 ] $v_tc_0

  # Create port connections
  connect_bd_net -net PLL_Clk_25MHz [get_bd_pins clk] [get_bd_pins rgb2dvi_0/PixelClk] [get_bd_pins v_tc_0/clk]
  connect_bd_net -net RST_25M_peripheral_aresetn [get_bd_pins resetn] [get_bd_pins rgb2dvi_0/aRst_n] [get_bd_pins v_tc_0/resetn]
  connect_bd_net -net RST_25M_peripheral_reset [get_bd_pins aRst] [get_bd_pins rgb2dvi_0/aRst]
  connect_bd_net -net VTC_CLK_ENB_CONST_dout [get_bd_pins gen_clken] [get_bd_pins v_tc_0/clken] [get_bd_pins v_tc_0/gen_clken]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins SerialClk] [get_bd_pins rgb2dvi_0/SerialClk]
  connect_bd_net -net rgb2dvi_0_TMDS_Clk_n [get_bd_pins TMDS_Clk_n] [get_bd_pins rgb2dvi_0/TMDS_Clk_n]
  connect_bd_net -net rgb2dvi_0_TMDS_Clk_p [get_bd_pins TMDS_Clk_p] [get_bd_pins rgb2dvi_0/TMDS_Clk_p]
  connect_bd_net -net rgb2dvi_0_TMDS_Data_n [get_bd_pins TMDS_Data_n] [get_bd_pins rgb2dvi_0/TMDS_Data_n]
  connect_bd_net -net rgb2dvi_0_TMDS_Data_p [get_bd_pins TMDS_Data_p] [get_bd_pins rgb2dvi_0/TMDS_Data_p]
  connect_bd_net -net v_tc_0_active_video_out [get_bd_pins active_video_out] [get_bd_pins v_tc_0/active_video_out]
  connect_bd_net -net v_tc_0_hsync_out [get_bd_pins hsync_out] [get_bd_pins v_tc_0/hsync_out]
  connect_bd_net -net v_tc_0_vsync_out [get_bd_pins vsync_out] [get_bd_pins v_tc_0/vsync_out]
  connect_bd_net -net vid_pData_1 [get_bd_pins vid_pData] [get_bd_pins rgb2dvi_0/vid_pData]
  connect_bd_net -net vid_pHSync_1 [get_bd_pins vid_pHSync] [get_bd_pins rgb2dvi_0/vid_pHSync]
  connect_bd_net -net vid_pVDE_1 [get_bd_pins vid_pVDE] [get_bd_pins rgb2dvi_0/vid_pVDE]
  connect_bd_net -net vid_pVSync_1 [get_bd_pins vid_pVSync] [get_bd_pins rgb2dvi_0/vid_pVSync]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: HEIR_LEDS
proc create_hier_cell_HEIR_LEDS { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HEIR_LEDS() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Dout_0
  create_bd_pin -dir O -from 0 -to 0 Dout_1
  create_bd_pin -dir O -from 0 -to 0 Dout_2
  create_bd_pin -dir O -from 0 -to 0 Dout_3
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: LEDS, and set properties
  set LEDS [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 LEDS ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_DOUT_DEFAULT {0x00000000} \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $LEDS

  # Create instance: LED_0, and set properties
  set LED_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 LED_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {4} \
 ] $LED_0

  # Create instance: LED_1, and set properties
  set LED_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 LED_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {4} \
 ] $LED_1

  # Create instance: LED_2, and set properties
  set LED_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 LED_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $LED_2

  # Create instance: LED_3, and set properties
  set LED_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 LED_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $LED_3

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {4} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {4} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins LEDS/S_AXI]

  # Create port connections
  connect_bd_net -net LEDS_gpio_io_o [get_bd_pins LED_0/Din] [get_bd_pins LED_1/Din] [get_bd_pins LED_2/Din] [get_bd_pins LED_3/Din] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net LEDS_gpio_io_o1 [get_bd_pins LEDS/gpio_io_o] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net LED_0_Dout [get_bd_pins Dout_0] [get_bd_pins LED_0/Dout]
  connect_bd_net -net LED_1_Dout [get_bd_pins Dout_1] [get_bd_pins LED_1/Dout]
  connect_bd_net -net LED_2_Dout [get_bd_pins Dout_2] [get_bd_pins LED_2/Dout]
  connect_bd_net -net LED_3_Dout [get_bd_pins Dout_3] [get_bd_pins LED_3/Dout]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins LEDS/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins LEDS/s_axi_aresetn]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_0/Op2] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins util_vector_logic_1/Op1] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: CC1200_Controler
proc create_hier_cell_CC1200_Controler { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_CC1200_Controler() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -type clk CC1200_CLK_0
  create_bd_pin -dir O -type clk CC1200_CLK_1
  create_bd_pin -dir O -type clk CC1200_CLK_2
  create_bd_pin -dir O -type clk CC1200_CLK_3
  create_bd_pin -dir O CC1200_CS_0
  create_bd_pin -dir O CC1200_CS_1
  create_bd_pin -dir O CC1200_CS_2
  create_bd_pin -dir O CC1200_CS_3
  create_bd_pin -dir I CC1200_MISO_0
  create_bd_pin -dir I CC1200_MISO_1
  create_bd_pin -dir I CC1200_MISO_2
  create_bd_pin -dir I CC1200_MISO_3
  create_bd_pin -dir O CC1200_MOSI_0
  create_bd_pin -dir O CC1200_MOSI_1
  create_bd_pin -dir O CC1200_MOSI_2
  create_bd_pin -dir O CC1200_MOSI_3
  create_bd_pin -dir O CC1200_READY
  create_bd_pin -dir O CC1200_READY1
  create_bd_pin -dir O CC1200_READY2
  create_bd_pin -dir O CC1200_READY3
  create_bd_pin -dir O -type rst CC1200_RST_0
  create_bd_pin -dir O -type rst CC1200_RST_1
  create_bd_pin -dir O -type rst CC1200_RST_2
  create_bd_pin -dir O -type rst CC1200_RST_3
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 7 -to 0 PACKET_LENGTH_IN_BYTES
  create_bd_pin -dir I -from 23 -to 0 RAM_DATA_IN
  create_bd_pin -dir O -from 23 -to 0 REG_OUT
  create_bd_pin -dir O -from 23 -to 0 REG_OUT1
  create_bd_pin -dir O -from 23 -to 0 REG_OUT2
  create_bd_pin -dir O -from 23 -to 0 REG_OUT3
  create_bd_pin -dir I -type rst RESET
  create_bd_pin -dir I -type rst ZQ_CC1200_RST
  create_bd_pin -dir I -type rst ZQ_CC1200_RST1
  create_bd_pin -dir I -type rst ZQ_CC1200_RST2
  create_bd_pin -dir I -type rst ZQ_CC1200_RST3
  create_bd_pin -dir I ZQ_REG_CS
  create_bd_pin -dir I ZQ_REG_CS1
  create_bd_pin -dir I ZQ_REG_CS2
  create_bd_pin -dir I ZQ_REG_CS3
  create_bd_pin -dir I -from 23 -to 0 ZQ_REG_IN
  create_bd_pin -dir I -from 23 -to 0 ZQ_REG_IN1
  create_bd_pin -dir I -from 23 -to 0 ZQ_REG_IN2
  create_bd_pin -dir I -from 23 -to 0 ZQ_REG_IN3
  create_bd_pin -dir O -from 7 -to 0 cc1200_data_out
  create_bd_pin -dir O -from 7 -to 0 cc1200_data_out1
  create_bd_pin -dir O -from 7 -to 0 cc1200_data_out2
  create_bd_pin -dir O -from 7 -to 0 cc1200_data_out3
  create_bd_pin -dir O cc1200_data_out_valid
  create_bd_pin -dir O cc1200_data_out_valid1
  create_bd_pin -dir O cc1200_data_out_valid2
  create_bd_pin -dir O cc1200_data_out_valid3
  create_bd_pin -dir I ram_data_in_valid

  # Create instance: CC1200_Controller_0, and set properties
  set block_name CC1200_Controller
  set block_cell_name CC1200_Controller_0
  if { [catch {set CC1200_Controller_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CC1200_Controller_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: CC1200_Controller_1, and set properties
  set block_name CC1200_Controller
  set block_cell_name CC1200_Controller_1
  if { [catch {set CC1200_Controller_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CC1200_Controller_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: CC1200_Controller_2, and set properties
  set block_name CC1200_Controller
  set block_cell_name CC1200_Controller_2
  if { [catch {set CC1200_Controller_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CC1200_Controller_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: CC1200_Controller_3, and set properties
  set block_name CC1200_Controller
  set block_cell_name CC1200_Controller_3
  if { [catch {set CC1200_Controller_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CC1200_Controller_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net CC1200_Controller_0_CC1200_CLK [get_bd_pins CC1200_CLK_0] [get_bd_pins CC1200_Controller_0/CC1200_CLK]
  connect_bd_net -net CC1200_Controller_0_CC1200_CS [get_bd_pins CC1200_CS_0] [get_bd_pins CC1200_Controller_0/CC1200_CS]
  connect_bd_net -net CC1200_Controller_0_CC1200_MOSI [get_bd_pins CC1200_MOSI_0] [get_bd_pins CC1200_Controller_0/CC1200_MOSI]
  connect_bd_net -net CC1200_Controller_0_CC1200_READY [get_bd_pins CC1200_READY3] [get_bd_pins CC1200_Controller_0/CC1200_READY]
  connect_bd_net -net CC1200_Controller_0_CC1200_RST [get_bd_pins CC1200_RST_0] [get_bd_pins CC1200_Controller_0/CC1200_RST]
  connect_bd_net -net CC1200_Controller_0_REG_OUT [get_bd_pins REG_OUT3] [get_bd_pins CC1200_Controller_0/REG_OUT]
  connect_bd_net -net CC1200_Controller_0_cc1200_data_out [get_bd_pins cc1200_data_out3] [get_bd_pins CC1200_Controller_0/cc1200_data_out]
  connect_bd_net -net CC1200_Controller_0_cc1200_data_out_valid [get_bd_pins cc1200_data_out_valid] [get_bd_pins CC1200_Controller_0/cc1200_data_out_valid]
  connect_bd_net -net CC1200_Controller_1_CC1200_CLK [get_bd_pins CC1200_CLK_1] [get_bd_pins CC1200_Controller_1/CC1200_CLK]
  connect_bd_net -net CC1200_Controller_1_CC1200_CS [get_bd_pins CC1200_CS_1] [get_bd_pins CC1200_Controller_1/CC1200_CS]
  connect_bd_net -net CC1200_Controller_1_CC1200_MOSI [get_bd_pins CC1200_MOSI_1] [get_bd_pins CC1200_Controller_1/CC1200_MOSI]
  connect_bd_net -net CC1200_Controller_1_CC1200_READY [get_bd_pins CC1200_READY] [get_bd_pins CC1200_Controller_1/CC1200_READY]
  connect_bd_net -net CC1200_Controller_1_CC1200_RST [get_bd_pins CC1200_RST_1] [get_bd_pins CC1200_Controller_1/CC1200_RST]
  connect_bd_net -net CC1200_Controller_1_REG_OUT [get_bd_pins REG_OUT] [get_bd_pins CC1200_Controller_1/REG_OUT]
  connect_bd_net -net CC1200_Controller_1_cc1200_data_out [get_bd_pins cc1200_data_out] [get_bd_pins CC1200_Controller_1/cc1200_data_out]
  connect_bd_net -net CC1200_Controller_1_cc1200_data_out_valid [get_bd_pins cc1200_data_out_valid3] [get_bd_pins CC1200_Controller_1/cc1200_data_out_valid]
  connect_bd_net -net CC1200_Controller_2_CC1200_CLK [get_bd_pins CC1200_CLK_2] [get_bd_pins CC1200_Controller_2/CC1200_CLK]
  connect_bd_net -net CC1200_Controller_2_CC1200_CS [get_bd_pins CC1200_CS_2] [get_bd_pins CC1200_Controller_2/CC1200_CS]
  connect_bd_net -net CC1200_Controller_2_CC1200_MOSI [get_bd_pins CC1200_MOSI_2] [get_bd_pins CC1200_Controller_2/CC1200_MOSI]
  connect_bd_net -net CC1200_Controller_2_CC1200_READY [get_bd_pins CC1200_READY1] [get_bd_pins CC1200_Controller_2/CC1200_READY]
  connect_bd_net -net CC1200_Controller_2_CC1200_RST [get_bd_pins CC1200_RST_2] [get_bd_pins CC1200_Controller_2/CC1200_RST]
  connect_bd_net -net CC1200_Controller_2_REG_OUT [get_bd_pins REG_OUT1] [get_bd_pins CC1200_Controller_2/REG_OUT]
  connect_bd_net -net CC1200_Controller_2_cc1200_data_out [get_bd_pins cc1200_data_out1] [get_bd_pins CC1200_Controller_2/cc1200_data_out]
  connect_bd_net -net CC1200_Controller_2_cc1200_data_out_valid [get_bd_pins cc1200_data_out_valid2] [get_bd_pins CC1200_Controller_2/cc1200_data_out_valid]
  connect_bd_net -net CC1200_Controller_3_CC1200_CLK [get_bd_pins CC1200_CLK_3] [get_bd_pins CC1200_Controller_3/CC1200_CLK]
  connect_bd_net -net CC1200_Controller_3_CC1200_CS [get_bd_pins CC1200_CS_3] [get_bd_pins CC1200_Controller_3/CC1200_CS]
  connect_bd_net -net CC1200_Controller_3_CC1200_MOSI [get_bd_pins CC1200_MOSI_3] [get_bd_pins CC1200_Controller_3/CC1200_MOSI]
  connect_bd_net -net CC1200_Controller_3_CC1200_READY [get_bd_pins CC1200_READY2] [get_bd_pins CC1200_Controller_3/CC1200_READY]
  connect_bd_net -net CC1200_Controller_3_CC1200_RST [get_bd_pins CC1200_RST_3] [get_bd_pins CC1200_Controller_3/CC1200_RST]
  connect_bd_net -net CC1200_Controller_3_REG_OUT [get_bd_pins REG_OUT2] [get_bd_pins CC1200_Controller_3/REG_OUT]
  connect_bd_net -net CC1200_Controller_3_cc1200_data_out [get_bd_pins cc1200_data_out2] [get_bd_pins CC1200_Controller_3/cc1200_data_out]
  connect_bd_net -net CC1200_Controller_3_cc1200_data_out_valid [get_bd_pins cc1200_data_out_valid1] [get_bd_pins CC1200_Controller_3/cc1200_data_out_valid]
  connect_bd_net -net CC1200_MISO_0_1 [get_bd_pins CC1200_MISO_0] [get_bd_pins CC1200_Controller_0/CC1200_MISO]
  connect_bd_net -net CC1200_MISO_1_1 [get_bd_pins CC1200_MISO_1] [get_bd_pins CC1200_Controller_1/CC1200_MISO]
  connect_bd_net -net CC1200_MISO_2_1 [get_bd_pins CC1200_MISO_2] [get_bd_pins CC1200_Controller_2/CC1200_MISO]
  connect_bd_net -net CC1200_MISO_3_1 [get_bd_pins CC1200_MISO_3] [get_bd_pins CC1200_Controller_3/CC1200_MISO]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout [get_bd_pins ZQ_REG_CS3] [get_bd_pins CC1200_Controller_0/ZQ_REG_CS]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout1 [get_bd_pins ZQ_REG_CS] [get_bd_pins CC1200_Controller_1/ZQ_REG_CS]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout2 [get_bd_pins ZQ_REG_CS2] [get_bd_pins CC1200_Controller_3/ZQ_REG_CS]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout3 [get_bd_pins ZQ_REG_CS1] [get_bd_pins CC1200_Controller_2/ZQ_REG_CS]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o [get_bd_pins ZQ_REG_IN3] [get_bd_pins CC1200_Controller_0/ZQ_REG_IN]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o1 [get_bd_pins ZQ_REG_IN] [get_bd_pins CC1200_Controller_1/ZQ_REG_IN]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o2 [get_bd_pins ZQ_REG_IN1] [get_bd_pins CC1200_Controller_2/ZQ_REG_IN]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o3 [get_bd_pins ZQ_REG_IN2] [get_bd_pins CC1200_Controller_3/ZQ_REG_IN]
  connect_bd_net -net HEIR_CC1200_RST_Dout [get_bd_pins ZQ_CC1200_RST3] [get_bd_pins CC1200_Controller_0/ZQ_CC1200_RST]
  connect_bd_net -net HEIR_CC1200_RST_Dout1 [get_bd_pins ZQ_CC1200_RST] [get_bd_pins CC1200_Controller_1/ZQ_CC1200_RST]
  connect_bd_net -net HEIR_CC1200_RST_Dout2 [get_bd_pins ZQ_CC1200_RST2] [get_bd_pins CC1200_Controller_3/ZQ_CC1200_RST]
  connect_bd_net -net HEIR_CC1200_RST_Dout3 [get_bd_pins ZQ_CC1200_RST1] [get_bd_pins CC1200_Controller_2/ZQ_CC1200_RST]
  connect_bd_net -net HEIR_ZQ2REG_gpio_io_o4 [get_bd_pins PACKET_LENGTH_IN_BYTES] [get_bd_pins CC1200_Controller_0/PACKET_LENGTH_IN_BYTES] [get_bd_pins CC1200_Controller_1/PACKET_LENGTH_IN_BYTES] [get_bd_pins CC1200_Controller_2/PACKET_LENGTH_IN_BYTES] [get_bd_pins CC1200_Controller_3/PACKET_LENGTH_IN_BYTES]
  connect_bd_net -net Net [get_bd_pins RESET] [get_bd_pins CC1200_Controller_0/RESET] [get_bd_pins CC1200_Controller_1/RESET] [get_bd_pins CC1200_Controller_2/RESET] [get_bd_pins CC1200_Controller_3/RESET]
  connect_bd_net -net PLL_Clk_100MHz [get_bd_pins CLK] [get_bd_pins CC1200_Controller_0/CLK] [get_bd_pins CC1200_Controller_1/CLK] [get_bd_pins CC1200_Controller_2/CLK] [get_bd_pins CC1200_Controller_3/CLK]
  connect_bd_net -net RAM_DATA_IN_CONST_dout [get_bd_pins RAM_DATA_IN] [get_bd_pins CC1200_Controller_0/RAM_DATA_IN] [get_bd_pins CC1200_Controller_1/RAM_DATA_IN] [get_bd_pins CC1200_Controller_2/RAM_DATA_IN] [get_bd_pins CC1200_Controller_3/RAM_DATA_IN]
  connect_bd_net -net ram_data_in_valid_1 [get_bd_pins ram_data_in_valid] [get_bd_pins CC1200_Controller_0/ram_data_in_valid] [get_bd_pins CC1200_Controller_1/ram_data_in_valid] [get_bd_pins CC1200_Controller_2/ram_data_in_valid] [get_bd_pins CC1200_Controller_3/ram_data_in_valid]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports
  set CC1200_CLK_0 [ create_bd_port -dir O -type clk CC1200_CLK_0 ]
  set CC1200_CLK_1 [ create_bd_port -dir O -type clk CC1200_CLK_1 ]
  set CC1200_CLK_2 [ create_bd_port -dir O -type clk CC1200_CLK_2 ]
  set CC1200_CLK_3 [ create_bd_port -dir O -type clk CC1200_CLK_3 ]
  set CC1200_CS_0 [ create_bd_port -dir O CC1200_CS_0 ]
  set CC1200_CS_1 [ create_bd_port -dir O CC1200_CS_1 ]
  set CC1200_CS_2 [ create_bd_port -dir O CC1200_CS_2 ]
  set CC1200_CS_3 [ create_bd_port -dir O CC1200_CS_3 ]
  set CC1200_GPIO_0_0 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_0_0 ]
  set CC1200_GPIO_0_1 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_0_1 ]
  set CC1200_GPIO_0_2 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_0_2 ]
  set CC1200_GPIO_0_3 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_0_3 ]
  set CC1200_GPIO_2_0 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_2_0 ]
  set CC1200_GPIO_2_1 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_2_1 ]
  set CC1200_GPIO_2_2 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_2_2 ]
  set CC1200_GPIO_2_3 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_2_3 ]
  set CC1200_GPIO_3_0 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_3_0 ]
  set CC1200_GPIO_3_1 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_3_1 ]
  set CC1200_GPIO_3_2 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_3_2 ]
  set CC1200_GPIO_3_3 [ create_bd_port -dir I -from 0 -to 0 CC1200_GPIO_3_3 ]
  set CC1200_MISO_0 [ create_bd_port -dir I CC1200_MISO_0 ]
  set CC1200_MISO_1 [ create_bd_port -dir I CC1200_MISO_1 ]
  set CC1200_MISO_2 [ create_bd_port -dir I CC1200_MISO_2 ]
  set CC1200_MISO_3 [ create_bd_port -dir I CC1200_MISO_3 ]
  set CC1200_MOSI_0 [ create_bd_port -dir O CC1200_MOSI_0 ]
  set CC1200_MOSI_1 [ create_bd_port -dir O CC1200_MOSI_1 ]
  set CC1200_MOSI_2 [ create_bd_port -dir O CC1200_MOSI_2 ]
  set CC1200_MOSI_3 [ create_bd_port -dir O CC1200_MOSI_3 ]
  set CC1200_RST_0 [ create_bd_port -dir O -type rst CC1200_RST_0 ]
  set CC1200_RST_1 [ create_bd_port -dir O -type rst CC1200_RST_1 ]
  set CC1200_RST_2 [ create_bd_port -dir O -type rst CC1200_RST_2 ]
  set CC1200_RST_3 [ create_bd_port -dir O -type rst CC1200_RST_3 ]
  set LED_0 [ create_bd_port -dir O -from 0 -to 0 LED_0 ]
  set LED_1 [ create_bd_port -dir O -from 0 -to 0 LED_1 ]
  set LED_2 [ create_bd_port -dir O -from 0 -to 0 LED_2 ]
  set LED_3 [ create_bd_port -dir O -from 0 -to 0 LED_3 ]
  set TMDS_Clk_n [ create_bd_port -dir O -type clk TMDS_Clk_n ]
  set TMDS_Clk_p [ create_bd_port -dir O -type clk TMDS_Clk_p ]
  set TMDS_Data_n [ create_bd_port -dir O -from 2 -to 0 TMDS_Data_n ]
  set TMDS_Data_p [ create_bd_port -dir O -from 2 -to 0 TMDS_Data_p ]

  # Create instance: CC1200_Controler
  create_hier_cell_CC1200_Controler [current_bd_instance .] CC1200_Controler

  # Create instance: END_OF_PCKT_CONST, and set properties
  set END_OF_PCKT_CONST [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 END_OF_PCKT_CONST ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $END_OF_PCKT_CONST

  # Create instance: HEIR_LEDS
  create_hier_cell_HEIR_LEDS [current_bd_instance .] HEIR_LEDS

  # Create instance: HEIR_VIDEO
  create_hier_cell_HEIR_VIDEO [current_bd_instance .] HEIR_VIDEO

  # Create instance: HEIR_ZQ2REG
  create_hier_cell_HEIR_ZQ2REG [current_bd_instance .] HEIR_ZQ2REG

  # Create instance: MIN_FRAME_SW_DETECTED, and set properties
  set MIN_FRAME_SW_DETECTED [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 MIN_FRAME_SW_DETECTED ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_DOUT_DEFAULT {0x00000020} \
   CONFIG.C_GPIO_WIDTH {11} \
 ] $MIN_FRAME_SW_DETECTED

  # Create instance: PLL, and set properties
  set PLL [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 PLL ]
  set_property -dict [ list \
   CONFIG.CLKOUT2_JITTER {165.419} \
   CONFIG.CLKOUT2_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {25} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_OUT1_PORT {Clk_100MHz} \
   CONFIG.CLK_OUT2_PORT {Clk_25MHz} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {40} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
   CONFIG.USE_RESET {false} \
 ] $PLL

  # Create instance: RAM_DATA_IN_CONST, and set properties
  set RAM_DATA_IN_CONST [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 RAM_DATA_IN_CONST ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {24} \
 ] $RAM_DATA_IN_CONST

  # Create instance: RST_100M, and set properties
  set RST_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 RST_100M ]

  # Create instance: RST_25M, and set properties
  set RST_25M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 RST_25M ]

  # Create instance: RST_EXT, and set properties
  set RST_EXT [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 RST_EXT ]

  # Create instance: SW_TIME_OUT, and set properties
  set SW_TIME_OUT [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 SW_TIME_OUT ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_DOUT_DEFAULT {0x00000000} \
   CONFIG.C_GPIO_WIDTH {32} \
 ] $SW_TIME_OUT

  # Create instance: VIDEO_BUF_0, and set properties
  set block_name VIDEO_BUF
  set block_cell_name VIDEO_BUF_0
  if { [catch {set VIDEO_BUF_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $VIDEO_BUF_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: VTC_CLK_ENB_CONST, and set properties
  set VTC_CLK_ENB_CONST [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 VTC_CLK_ENB_CONST ]

  # Create instance: axi_crossbar_0, and set properties
  set axi_crossbar_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
 ] $axi_crossbar_0

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {660.000000} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.196078} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {110.000000} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {110.000000} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {110.000000} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {110.000000} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {110.000000} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {110.000000} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {110.000000} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {33} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {125000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1320.000} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {40} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {51} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {26} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1040.000} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {25} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {inout} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {enabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {enabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {enabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {enabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {enabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {enabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {enabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {enabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {enabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {enabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {inout} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {inout} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {inout} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {inout} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {inout} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {inout} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {inout} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#GPIO#SD 0#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#qspi_fbclk#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#gpio[28]#gpio[29]#gpio[30]#gpio[31]#gpio[32]#gpio[33]#gpio[34]#gpio[35]#gpio[36]#gpio[37]#gpio[38]#gpio[39]#clk#cmd#data[0]#data[1]#data[2]#data[3]#gpio[46]#cd#gpio[48]#gpio[49]#gpio[50]#gpio[51]#mdc#mdio} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {520.000000} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.346} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.321} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.294} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.305} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.193} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.249} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.090} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.057} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {0} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {16} \
   CONFIG.NUM_SI {2} \
 ] $ps7_0_axi_periph

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins HEIR_LEDS/S_AXI] [get_bd_intf_pins axi_crossbar_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_0_M00_AXI [get_bd_intf_pins MIN_FRAME_SW_DETECTED/S_AXI] [get_bd_intf_pins axi_crossbar_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_0_M01_AXI [get_bd_intf_pins SW_TIME_OUT/S_AXI] [get_bd_intf_pins axi_crossbar_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_0_M03_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI15] [get_bd_intf_pins axi_crossbar_0/M03_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_0_M04_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI16] [get_bd_intf_pins axi_crossbar_0/M04_AXI]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins jtag_axi_0/M_AXI] [get_bd_intf_pins ps7_0_axi_periph/S01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI11] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI12] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI13] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI14] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI6] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M05_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI1] [get_bd_intf_pins ps7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M06_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI2] [get_bd_intf_pins ps7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M07_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI3] [get_bd_intf_pins ps7_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M08_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI4] [get_bd_intf_pins ps7_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M09_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI5] [get_bd_intf_pins ps7_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M10_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI7] [get_bd_intf_pins ps7_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M11_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI8] [get_bd_intf_pins ps7_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M12_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI9] [get_bd_intf_pins ps7_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M13_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI10] [get_bd_intf_pins ps7_0_axi_periph/M13_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M14_AXI [get_bd_intf_pins HEIR_ZQ2REG/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M14_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M15_AXI [get_bd_intf_pins axi_crossbar_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M15_AXI]

  # Create port connections
  connect_bd_net -net CC1200_Controller_0_CC1200_CLK [get_bd_ports CC1200_CLK_0] [get_bd_pins CC1200_Controler/CC1200_CLK_0]
  connect_bd_net -net CC1200_Controller_0_CC1200_CS [get_bd_ports CC1200_CS_0] [get_bd_pins CC1200_Controler/CC1200_CS_0]
  connect_bd_net -net CC1200_Controller_0_CC1200_MOSI [get_bd_ports CC1200_MOSI_0] [get_bd_pins CC1200_Controler/CC1200_MOSI_0]
  connect_bd_net -net CC1200_Controller_0_CC1200_READY [get_bd_pins CC1200_Controler/CC1200_READY3] [get_bd_pins HEIR_ZQ2REG/In0]
  connect_bd_net -net CC1200_Controller_0_CC1200_RST [get_bd_ports CC1200_RST_0] [get_bd_pins CC1200_Controler/CC1200_RST_0]
  connect_bd_net -net CC1200_Controller_0_DATA_FROM_FIFO_READY [get_bd_pins CC1200_Controler/cc1200_data_out_valid] [get_bd_pins VIDEO_BUF_0/DATA_VALID_0]
  connect_bd_net -net CC1200_Controller_0_REG_OUT [get_bd_pins CC1200_Controler/REG_OUT3] [get_bd_pins HEIR_ZQ2REG/gpio_io_i3]
  connect_bd_net -net CC1200_Controller_0_cc1200_data_out [get_bd_pins CC1200_Controler/cc1200_data_out3] [get_bd_pins VIDEO_BUF_0/DATA_IN_0]
  connect_bd_net -net CC1200_Controller_1_CC1200_CLK [get_bd_ports CC1200_CLK_1] [get_bd_pins CC1200_Controler/CC1200_CLK_1]
  connect_bd_net -net CC1200_Controller_1_CC1200_CS [get_bd_ports CC1200_CS_1] [get_bd_pins CC1200_Controler/CC1200_CS_1]
  connect_bd_net -net CC1200_Controller_1_CC1200_MOSI [get_bd_ports CC1200_MOSI_1] [get_bd_pins CC1200_Controler/CC1200_MOSI_1]
  connect_bd_net -net CC1200_Controller_1_CC1200_READY [get_bd_pins CC1200_Controler/CC1200_READY] [get_bd_pins HEIR_ZQ2REG/In1]
  connect_bd_net -net CC1200_Controller_1_CC1200_RST [get_bd_ports CC1200_RST_1] [get_bd_pins CC1200_Controler/CC1200_RST_1]
  connect_bd_net -net CC1200_Controller_1_DATA_FROM_FIFO_READY [get_bd_pins CC1200_Controler/cc1200_data_out_valid3] [get_bd_pins VIDEO_BUF_0/DATA_VALID_1]
  connect_bd_net -net CC1200_Controller_1_REG_OUT [get_bd_pins CC1200_Controler/REG_OUT] [get_bd_pins HEIR_ZQ2REG/gpio_io_i2]
  connect_bd_net -net CC1200_Controller_1_cc1200_data_out [get_bd_pins CC1200_Controler/cc1200_data_out] [get_bd_pins VIDEO_BUF_0/DATA_IN_1]
  connect_bd_net -net CC1200_Controller_2_CC1200_CLK [get_bd_ports CC1200_CLK_2] [get_bd_pins CC1200_Controler/CC1200_CLK_2]
  connect_bd_net -net CC1200_Controller_2_CC1200_CS [get_bd_ports CC1200_CS_2] [get_bd_pins CC1200_Controler/CC1200_CS_2]
  connect_bd_net -net CC1200_Controller_2_CC1200_MOSI [get_bd_ports CC1200_MOSI_2] [get_bd_pins CC1200_Controler/CC1200_MOSI_2]
  connect_bd_net -net CC1200_Controller_2_CC1200_READY [get_bd_pins CC1200_Controler/CC1200_READY1] [get_bd_pins HEIR_ZQ2REG/In2]
  connect_bd_net -net CC1200_Controller_2_CC1200_RST [get_bd_ports CC1200_RST_2] [get_bd_pins CC1200_Controler/CC1200_RST_2]
  connect_bd_net -net CC1200_Controller_2_DATA_FROM_FIFO_READY [get_bd_pins CC1200_Controler/cc1200_data_out_valid2] [get_bd_pins VIDEO_BUF_0/DATA_VALID_2]
  connect_bd_net -net CC1200_Controller_2_REG_OUT [get_bd_pins CC1200_Controler/REG_OUT1] [get_bd_pins HEIR_ZQ2REG/gpio_io_i1]
  connect_bd_net -net CC1200_Controller_2_cc1200_data_out [get_bd_pins CC1200_Controler/cc1200_data_out1] [get_bd_pins VIDEO_BUF_0/DATA_IN_2]
  connect_bd_net -net CC1200_Controller_3_CC1200_CLK [get_bd_ports CC1200_CLK_3] [get_bd_pins CC1200_Controler/CC1200_CLK_3]
  connect_bd_net -net CC1200_Controller_3_CC1200_CS [get_bd_ports CC1200_CS_3] [get_bd_pins CC1200_Controler/CC1200_CS_3]
  connect_bd_net -net CC1200_Controller_3_CC1200_MOSI [get_bd_ports CC1200_MOSI_3] [get_bd_pins CC1200_Controler/CC1200_MOSI_3]
  connect_bd_net -net CC1200_Controller_3_CC1200_READY [get_bd_pins CC1200_Controler/CC1200_READY2] [get_bd_pins HEIR_ZQ2REG/In3]
  connect_bd_net -net CC1200_Controller_3_CC1200_RST [get_bd_ports CC1200_RST_3] [get_bd_pins CC1200_Controler/CC1200_RST_3]
  connect_bd_net -net CC1200_Controller_3_DATA_FROM_FIFO_READY [get_bd_pins CC1200_Controler/cc1200_data_out_valid1] [get_bd_pins VIDEO_BUF_0/DATA_VALID_3]
  connect_bd_net -net CC1200_Controller_3_REG_OUT [get_bd_pins CC1200_Controler/REG_OUT2] [get_bd_pins HEIR_ZQ2REG/gpio_io_i]
  connect_bd_net -net CC1200_Controller_3_cc1200_data_out [get_bd_pins CC1200_Controler/cc1200_data_out2] [get_bd_pins VIDEO_BUF_0/DATA_IN_3]
  connect_bd_net -net CC1200_MISO_0_1 [get_bd_ports CC1200_MISO_0] [get_bd_pins CC1200_Controler/CC1200_MISO_0]
  connect_bd_net -net CC1200_MISO_1_1 [get_bd_ports CC1200_MISO_1] [get_bd_pins CC1200_Controler/CC1200_MISO_1]
  connect_bd_net -net CC1200_MISO_2_1 [get_bd_ports CC1200_MISO_2] [get_bd_pins CC1200_Controler/CC1200_MISO_2]
  connect_bd_net -net CC1200_MISO_3_1 [get_bd_ports CC1200_MISO_3] [get_bd_pins CC1200_Controler/CC1200_MISO_3]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout [get_bd_pins CC1200_Controler/ZQ_REG_CS3] [get_bd_pins HEIR_ZQ2REG/Dout4]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout1 [get_bd_pins CC1200_Controler/ZQ_REG_CS] [get_bd_pins HEIR_ZQ2REG/Dout5]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout2 [get_bd_pins CC1200_Controler/ZQ_REG_CS2] [get_bd_pins HEIR_ZQ2REG/Dout6]
  connect_bd_net -net HEIR_CC1200_REG_CS_Dout3 [get_bd_pins CC1200_Controler/ZQ_REG_CS1] [get_bd_pins HEIR_ZQ2REG/Dout7]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o [get_bd_pins CC1200_Controler/ZQ_REG_IN3] [get_bd_pins HEIR_ZQ2REG/gpio_io_o]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o1 [get_bd_pins CC1200_Controler/ZQ_REG_IN] [get_bd_pins HEIR_ZQ2REG/gpio_io_o1]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o2 [get_bd_pins CC1200_Controler/ZQ_REG_IN1] [get_bd_pins HEIR_ZQ2REG/gpio_io_o2]
  connect_bd_net -net HEIR_CC1200_REG_IN_gpio_io_o3 [get_bd_pins CC1200_Controler/ZQ_REG_IN2] [get_bd_pins HEIR_ZQ2REG/gpio_io_o3]
  connect_bd_net -net HEIR_CC1200_RST_Dout [get_bd_pins CC1200_Controler/ZQ_CC1200_RST3] [get_bd_pins HEIR_ZQ2REG/Dout]
  connect_bd_net -net HEIR_CC1200_RST_Dout1 [get_bd_pins CC1200_Controler/ZQ_CC1200_RST] [get_bd_pins HEIR_ZQ2REG/Dout1]
  connect_bd_net -net HEIR_CC1200_RST_Dout2 [get_bd_pins CC1200_Controler/ZQ_CC1200_RST2] [get_bd_pins HEIR_ZQ2REG/Dout2]
  connect_bd_net -net HEIR_CC1200_RST_Dout3 [get_bd_pins CC1200_Controler/ZQ_CC1200_RST1] [get_bd_pins HEIR_ZQ2REG/Dout3]
  connect_bd_net -net HEIR_LEDS_Dout_0 [get_bd_ports LED_0] [get_bd_pins HEIR_LEDS/Dout_0]
  connect_bd_net -net HEIR_LEDS_Dout_1 [get_bd_ports LED_1] [get_bd_pins HEIR_LEDS/Dout_1]
  connect_bd_net -net HEIR_LEDS_Dout_2 [get_bd_ports LED_2] [get_bd_pins HEIR_LEDS/Dout_2]
  connect_bd_net -net HEIR_LEDS_Dout_3 [get_bd_ports LED_3] [get_bd_pins HEIR_LEDS/Dout_3]
  connect_bd_net -net HEIR_VIDEO_active_video_out [get_bd_pins HEIR_VIDEO/active_video_out] [get_bd_pins VIDEO_BUF_0/vtc_active_video]
  connect_bd_net -net HEIR_VIDEO_hsync_out [get_bd_pins HEIR_VIDEO/hsync_out] [get_bd_pins VIDEO_BUF_0/vtc_hsync]
  connect_bd_net -net HEIR_VIDEO_vsync_out [get_bd_pins HEIR_VIDEO/vsync_out] [get_bd_pins VIDEO_BUF_0/vtc_vsync]
  connect_bd_net -net HEIR_ZQ2REG_gpio_io_o4 [get_bd_pins CC1200_Controler/PACKET_LENGTH_IN_BYTES] [get_bd_pins HEIR_ZQ2REG/gpio_io_o4]
  connect_bd_net -net HEIR_ZQ2REG_gpio_io_o5 [get_bd_pins HEIR_ZQ2REG/gpio_io_o5] [get_bd_pins VIDEO_BUF_0/upsamp_factor]
  connect_bd_net -net In0_0_1 [get_bd_ports CC1200_GPIO_0_0] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_0_0]
  connect_bd_net -net In0_0_2 [get_bd_ports CC1200_GPIO_0_1] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_0_1]
  connect_bd_net -net In0_0_3 [get_bd_ports CC1200_GPIO_0_2] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_0_2]
  connect_bd_net -net In0_0_4 [get_bd_ports CC1200_GPIO_0_3] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_0_3]
  connect_bd_net -net In1_0_1 [get_bd_ports CC1200_GPIO_2_0] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_2_0] [get_bd_pins VIDEO_BUF_0/SW_DETECTED_0]
  connect_bd_net -net In1_0_2 [get_bd_ports CC1200_GPIO_2_1] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_2_1] [get_bd_pins VIDEO_BUF_0/SW_DETECTED_1]
  connect_bd_net -net In1_0_3 [get_bd_ports CC1200_GPIO_2_2] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_2_2] [get_bd_pins VIDEO_BUF_0/SW_DETECTED_2]
  connect_bd_net -net In1_0_4 [get_bd_ports CC1200_GPIO_2_3] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_2_3] [get_bd_pins VIDEO_BUF_0/SW_DETECTED_3]
  connect_bd_net -net In2_0_1 [get_bd_ports CC1200_GPIO_3_0] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_3_0] [get_bd_pins VIDEO_BUF_0/SW_OPPOSITE_DIRECT_0]
  connect_bd_net -net In2_0_2 [get_bd_ports CC1200_GPIO_3_1] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_3_1] [get_bd_pins VIDEO_BUF_0/SW_OPPOSITE_DIRECT_1]
  connect_bd_net -net In2_0_3 [get_bd_ports CC1200_GPIO_3_2] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_3_2] [get_bd_pins VIDEO_BUF_0/SW_OPPOSITE_DIRECT_2]
  connect_bd_net -net In2_0_4 [get_bd_ports CC1200_GPIO_3_3] [get_bd_pins HEIR_ZQ2REG/CC1200_GPIO_3_3] [get_bd_pins VIDEO_BUF_0/SW_OPPOSITE_DIRECT_3]
  connect_bd_net -net MIN_FRAME_SW_DETECTED_gpio_io_o [get_bd_pins MIN_FRAME_SW_DETECTED/gpio_io_o] [get_bd_pins VIDEO_BUF_0/min_frame_sw_detected]
  connect_bd_net -net Net [get_bd_pins CC1200_Controler/RESET] [get_bd_pins RST_100M/peripheral_reset] [get_bd_pins VIDEO_BUF_0/W_RESET]
  connect_bd_net -net Net1 [get_bd_pins CC1200_Controler/ram_data_in_valid] [get_bd_pins END_OF_PCKT_CONST/dout] [get_bd_pins VIDEO_BUF_0/END_OF_PACKET_0] [get_bd_pins VIDEO_BUF_0/END_OF_PACKET_1] [get_bd_pins VIDEO_BUF_0/END_OF_PACKET_2] [get_bd_pins VIDEO_BUF_0/END_OF_PACKET_3]
  connect_bd_net -net PLL_Clk_100MHz [get_bd_pins CC1200_Controler/CLK] [get_bd_pins HEIR_LEDS/s_axi_aclk] [get_bd_pins HEIR_ZQ2REG/s_axi_aclk] [get_bd_pins MIN_FRAME_SW_DETECTED/s_axi_aclk] [get_bd_pins PLL/Clk_100MHz] [get_bd_pins RST_100M/slowest_sync_clk] [get_bd_pins SW_TIME_OUT/s_axi_aclk] [get_bd_pins VIDEO_BUF_0/W_CLK] [get_bd_pins axi_crossbar_0/aclk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/M05_ACLK] [get_bd_pins ps7_0_axi_periph/M06_ACLK] [get_bd_pins ps7_0_axi_periph/M07_ACLK] [get_bd_pins ps7_0_axi_periph/M08_ACLK] [get_bd_pins ps7_0_axi_periph/M09_ACLK] [get_bd_pins ps7_0_axi_periph/M10_ACLK] [get_bd_pins ps7_0_axi_periph/M11_ACLK] [get_bd_pins ps7_0_axi_periph/M12_ACLK] [get_bd_pins ps7_0_axi_periph/M13_ACLK] [get_bd_pins ps7_0_axi_periph/M14_ACLK] [get_bd_pins ps7_0_axi_periph/M15_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins ps7_0_axi_periph/S01_ACLK]
  connect_bd_net -net PLL_Clk_25MHz [get_bd_pins HEIR_VIDEO/clk] [get_bd_pins PLL/Clk_25MHz] [get_bd_pins RST_25M/slowest_sync_clk] [get_bd_pins VIDEO_BUF_0/R_CLK]
  connect_bd_net -net PLL_locked [get_bd_pins PLL/locked] [get_bd_pins RST_100M/dcm_locked] [get_bd_pins RST_25M/dcm_locked]
  connect_bd_net -net RAM_DATA_IN_CONST_dout [get_bd_pins CC1200_Controler/RAM_DATA_IN] [get_bd_pins RAM_DATA_IN_CONST/dout]
  connect_bd_net -net RST_100M_peripheral_aresetn [get_bd_pins HEIR_LEDS/s_axi_aresetn] [get_bd_pins HEIR_ZQ2REG/s_axi_aresetn] [get_bd_pins MIN_FRAME_SW_DETECTED/s_axi_aresetn] [get_bd_pins RST_100M/peripheral_aresetn] [get_bd_pins SW_TIME_OUT/s_axi_aresetn] [get_bd_pins axi_crossbar_0/aresetn] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/M05_ARESETN] [get_bd_pins ps7_0_axi_periph/M06_ARESETN] [get_bd_pins ps7_0_axi_periph/M07_ARESETN] [get_bd_pins ps7_0_axi_periph/M08_ARESETN] [get_bd_pins ps7_0_axi_periph/M09_ARESETN] [get_bd_pins ps7_0_axi_periph/M10_ARESETN] [get_bd_pins ps7_0_axi_periph/M11_ARESETN] [get_bd_pins ps7_0_axi_periph/M12_ARESETN] [get_bd_pins ps7_0_axi_periph/M13_ARESETN] [get_bd_pins ps7_0_axi_periph/M14_ARESETN] [get_bd_pins ps7_0_axi_periph/M15_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins ps7_0_axi_periph/S01_ARESETN]
  connect_bd_net -net RST_25M_peripheral_aresetn [get_bd_pins HEIR_VIDEO/resetn] [get_bd_pins RST_25M/peripheral_aresetn]
  connect_bd_net -net RST_25M_peripheral_reset [get_bd_pins HEIR_VIDEO/aRst] [get_bd_pins RST_25M/peripheral_reset] [get_bd_pins VIDEO_BUF_0/R_RESET]
  connect_bd_net -net RST_EXT_dout [get_bd_pins RST_100M/ext_reset_in] [get_bd_pins RST_25M/ext_reset_in] [get_bd_pins RST_EXT/dout]
  connect_bd_net -net SW_TIME_OUT_gpio_io_o [get_bd_pins SW_TIME_OUT/gpio_io_o] [get_bd_pins VIDEO_BUF_0/sw_time_out]
  connect_bd_net -net VIDEO_BUF_0_ACTIVE_VIDEO_OUT [get_bd_pins HEIR_VIDEO/vid_pVDE] [get_bd_pins VIDEO_BUF_0/ACTIVE_VIDEO_OUT]
  connect_bd_net -net VIDEO_BUF_0_HSYNC_OUT [get_bd_pins HEIR_VIDEO/vid_pHSync] [get_bd_pins VIDEO_BUF_0/HSYNC_OUT]
  connect_bd_net -net VIDEO_BUF_0_RGB_OUT [get_bd_pins HEIR_VIDEO/vid_pData] [get_bd_pins VIDEO_BUF_0/RGB_OUT]
  connect_bd_net -net VIDEO_BUF_0_VSYNC_OUT [get_bd_pins HEIR_VIDEO/vid_pVSync] [get_bd_pins VIDEO_BUF_0/VSYNC_OUT]
  connect_bd_net -net VTC_CLK_ENB_CONST_dout [get_bd_pins HEIR_VIDEO/gen_clken] [get_bd_pins VTC_CLK_ENB_CONST/dout]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins HEIR_VIDEO/SerialClk] [get_bd_pins PLL/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK0]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins RST_100M/aux_reset_in] [get_bd_pins RST_25M/aux_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net rgb2dvi_0_TMDS_Clk_n [get_bd_ports TMDS_Clk_n] [get_bd_pins HEIR_VIDEO/TMDS_Clk_n]
  connect_bd_net -net rgb2dvi_0_TMDS_Clk_p [get_bd_ports TMDS_Clk_p] [get_bd_pins HEIR_VIDEO/TMDS_Clk_p]
  connect_bd_net -net rgb2dvi_0_TMDS_Data_n [get_bd_ports TMDS_Data_n] [get_bd_pins HEIR_VIDEO/TMDS_Data_n]
  connect_bd_net -net rgb2dvi_0_TMDS_Data_p [get_bd_ports TMDS_Data_p] [get_bd_pins HEIR_VIDEO/TMDS_Data_p]

  # Create address segments
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_GPIO/HEIR_CC1200_0_GPIO/CC1200_0_GPIO/S_AXI/Reg] -force
  assign_bd_address -offset 0x41210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_GPIO/HEIR_CC1200_1_GPIO/CC1200_1_GPIO/S_AXI/Reg] -force
  assign_bd_address -offset 0x41220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_GPIO/HEIR_CC1200_2_GPIO/CC1200_2_GPIO/S_AXI/Reg] -force
  assign_bd_address -offset 0x41230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_GPIO/HEIR_CC1200_3_GPIO/CC1200_3_GPIO/S_AXI/Reg] -force
  assign_bd_address -offset 0x41300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/CC1200_FIFO_TH/S_AXI/Reg] -force
  assign_bd_address -offset 0x41240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_READY/CC1200_READY/S_AXI/Reg] -force
  assign_bd_address -offset 0x41250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_CS/CC1200_REG_CS/S_AXI/Reg] -force
  assign_bd_address -offset 0x41260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_IN/CC1200_REG_IN_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41270000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_IN/CC1200_REG_IN_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41280000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_IN/CC1200_REG_IN_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x41290000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_IN/CC1200_REG_IN_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x412A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_OUT/CC1200_REG_OUT_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x412B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_OUT/CC1200_REG_OUT_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x412C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_OUT/CC1200_REG_OUT_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x412D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_OUT/CC1200_REG_OUT_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x412E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_RST/CC1200_RST/S_AXI/Reg] -force
  assign_bd_address -offset 0x412F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_LEDS/LEDS/S_AXI/Reg] -force
  assign_bd_address -offset 0x41310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs MIN_FRAME_SW_DETECTED/S_AXI/Reg] -force
  assign_bd_address -offset 0x41320000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs SW_TIME_OUT/S_AXI/Reg] -force
  assign_bd_address -offset 0x41330000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/UPSAMPLE_FACTOR/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_GPIO/HEIR_CC1200_0_GPIO/CC1200_0_GPIO/S_AXI/Reg] -force
  assign_bd_address -offset 0x41210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_GPIO/HEIR_CC1200_1_GPIO/CC1200_1_GPIO/S_AXI/Reg] -force
  assign_bd_address -offset 0x41220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_GPIO/HEIR_CC1200_2_GPIO/CC1200_2_GPIO/S_AXI/Reg] -force
  assign_bd_address -offset 0x41230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_GPIO/HEIR_CC1200_3_GPIO/CC1200_3_GPIO/S_AXI/Reg] -force
  assign_bd_address -offset 0x41300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/CC1200_FIFO_TH/S_AXI/Reg] -force
  assign_bd_address -offset 0x41240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_READY/CC1200_READY/S_AXI/Reg] -force
  assign_bd_address -offset 0x41250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_CS/CC1200_REG_CS/S_AXI/Reg] -force
  assign_bd_address -offset 0x41260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_IN/CC1200_REG_IN_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41270000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_IN/CC1200_REG_IN_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41280000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_IN/CC1200_REG_IN_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x41290000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_IN/CC1200_REG_IN_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x412A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_OUT/CC1200_REG_OUT_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x412B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_OUT/CC1200_REG_OUT_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x412C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_OUT/CC1200_REG_OUT_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x412D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_REG_OUT/CC1200_REG_OUT_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x412E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/HEIR_CC1200_RST/CC1200_RST/S_AXI/Reg] -force
  assign_bd_address -offset 0x412F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_LEDS/LEDS/S_AXI/Reg] -force
  assign_bd_address -offset 0x41310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs MIN_FRAME_SW_DETECTED/S_AXI/Reg] -force
  assign_bd_address -offset 0x41320000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs SW_TIME_OUT/S_AXI/Reg] -force
  assign_bd_address -offset 0x41330000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs HEIR_ZQ2REG/UPSAMPLE_FACTOR/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



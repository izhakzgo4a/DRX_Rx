# Building Vivado roject
- Clone the repository
- Open Vivado
- In Vivado, open Tcl console and write:
	- "cd <your clone dir\>/Work"
	- source ./DRX_Rx.tcl

This script will build the project's file heirarchy.
When the project is built, write in Tcl Console:

- source ./DRX_Rx_bd.tcl

This script will build the Block Design.
The Block Design will be built with some validation errors. Fix it with the script:

Make sure that Block Design validation is run successfully.

Run **Generate Bitstream** in Vivado.


# Building Vitis roject
- In **Vivado**, export hardware: 
*File->Export->Export Hardware* to the **Vitis** directory (in your clone dir).
- Open **Vitis** : *Tools->Launch Vitis IDE* and choose the **Vitis** directory
- Click **Create Application Project**->Next
- In **Platform** page choose **Create a new platform from hardware (XSA**) tab and browse to the XSA file exported in the first step. Click **Next**
- Choose project name (e.g. DRX_Rx_SW) and make sure that choosed processor is **ps7_cortexa9_0**. Click **Next** twice.
- In **Templates** page, choose **Empty Application** and click **Finish**.
- Copy the files in directory *Vitis/Src* into *Vitis/<your proj name\>/src*
- Build the Platform and the project.
/*
 * Main.c
 *
 *  Created on: 20 Aug 2022
 *      Author: GO4A
 */

#include "xparameters.h"
#include "xgpio.h"
#include "sleep.h"
#include "CC1200_param.h"
//#include "CC1200_functions.h"
//#include "ZQ_GPIO.h"
//#include "videoChainFunctions.h"
#include "xil_types.h"



XGpio CC1200_RST;
XGpio CC1200_REG_CS;
XGpio CC1200_REG_IN_0;
XGpio CC1200_REG_IN_1;
XGpio CC1200_REG_IN_2;
XGpio CC1200_REG_IN_3;
XGpio CC1200_REG_OUT_0;
XGpio CC1200_REG_OUT_1;
XGpio CC1200_REG_OUT_2;
XGpio CC1200_REG_OUT_3;
XGpio CC1200_0_GPIO;
XGpio CC1200_1_GPIO;
XGpio CC1200_2_GPIO;
XGpio CC1200_3_GPIO;
XGpio CC1200_READY;
XGpio CC1200_FIFO_TH;
XGpio CC1200_RSSI_0;
XGpio CC1200_RSSI_1;
XGpio CC1200_RSSI_2;
XGpio CC1200_RSSI_3;

XGpio LEDS;
XGpio MIN_FRAME_SW_DETECTED;
XGpio SW_TIME_OUT;
XGpio UPSAMPLE_FACTOR;

typedef struct
{
	XGpio *CC1200_RST;
	XGpio *CC1200_REG_CS;
	XGpio *CC1200_REG_IN_0;
	XGpio *CC1200_REG_IN_1;
	XGpio *CC1200_REG_IN_2;
	XGpio *CC1200_REG_IN_3;
	XGpio *CC1200_REG_OUT_0;
	XGpio *CC1200_REG_OUT_1;
	XGpio *CC1200_REG_OUT_2;
	XGpio *CC1200_REG_OUT_3;
	XGpio *CC1200_0_GPIO;
	XGpio *CC1200_1_GPIO;
	XGpio *CC1200_2_GPIO;
	XGpio *CC1200_3_GPIO;
	XGpio *CC1200_READY;
	XGpio *CC1200_FIFO_TH;
	XGpio *CC1200_RSSI_0;
	XGpio *CC1200_RSSI_1;
	XGpio *CC1200_RSSI_2;
	XGpio *CC1200_RSSI_3;
}ZQ_CC1200;

int ZQ_gpio_init(ZQ_CC1200 CC1200);

u32 CC1200_ReadReg_new(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 DataIn);
u32 CC1200_ReadReg(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 DataIn);
u32 CC1200_ReadRegByAddr(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 addr);
u32 CC1200_WriteReg_new(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 DataIn);
u32 CC1200_WriteReg(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 DataIn);
u32 CC1200_WriteRegByAddr(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 addr, u32 DataIn);
void CC1200_HardRst(u32 CC1200_Index, ZQ_CC1200 CC1200);
void CC1200_RESET(u32 CC1200_Index, ZQ_CC1200 CC1200);


u32 CC1200_Init(u32 CC1200_Index, ZQ_CC1200 CC1200);
void CC1200_setBit(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 CC1200Addr, u32 bitPos);
void CC1200_clearBit(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 CC1200Addr, u32 bitPos);
void CC1200_rmw(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 CC1200Addr, u32 mask, u32 data);
void CC1200_setFrequency(u32 CC1200_Index, ZQ_CC1200 CC1200, float freqMHz, u32 rx_tx);
u32 CC1200_setPower(u32 CC1200_Index, ZQ_CC1200 CC1200, float power, u32 rx_tx);
u32 CC1200_setFifoTh(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 th);
u32 CC1200_setPktLen(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 len);
u32 CC1200_setGPIO(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 gpio, u32 val);

void CC1200_flushRxFifo(u32 CC1200_Index, ZQ_CC1200 CC1200);

#define CH_0
#define CH_1
#define CH_2
#define CH_3

int main (void)
{
	int GpioStatus;
	u32 CC1200_Regvalue, delay = 0, leds = 0x0;

	ZQ_CC1200 CC1200;
	CC1200.CC1200_RST = &CC1200_RST;
	CC1200.CC1200_REG_CS = &CC1200_REG_CS;
	CC1200.CC1200_REG_IN_0 = &CC1200_REG_IN_0;
	CC1200.CC1200_REG_IN_1 = &CC1200_REG_IN_1;
	CC1200.CC1200_REG_IN_2 = &CC1200_REG_IN_2;
	CC1200.CC1200_REG_IN_3 = &CC1200_REG_IN_3;
	CC1200.CC1200_REG_OUT_0 = &CC1200_REG_OUT_0;
	CC1200.CC1200_REG_OUT_1 = &CC1200_REG_OUT_1;
	CC1200.CC1200_REG_OUT_2 = &CC1200_REG_OUT_2;
	CC1200.CC1200_REG_OUT_3 = &CC1200_REG_OUT_3;
	CC1200.CC1200_0_GPIO = &CC1200_0_GPIO;
	CC1200.CC1200_1_GPIO = &CC1200_1_GPIO;
	CC1200.CC1200_2_GPIO = &CC1200_2_GPIO;
	CC1200.CC1200_3_GPIO = &CC1200_3_GPIO;
	CC1200.CC1200_READY = &CC1200_READY;
	CC1200.CC1200_FIFO_TH = &CC1200_FIFO_TH;
	CC1200.CC1200_RSSI_0 = &CC1200_RSSI_0;
	CC1200.CC1200_RSSI_1 = &CC1200_RSSI_1;
	CC1200.CC1200_RSSI_2 = &CC1200_RSSI_2;
	CC1200.CC1200_RSSI_3 = &CC1200_RSSI_3;

	GpioStatus = ZQ_gpio_init(CC1200);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;


	usleep(1000);
	XGpio_DiscreteWrite(&MIN_FRAME_SW_DETECTED, 1, 240);
	usleep(1000);
	XGpio_DiscreteWrite(&SW_TIME_OUT, 1, 500000000);
//	usleep(1000);

	/* Reset CC1200 */
	CC1200_RESET(0, CC1200);
	usleep(1000);
	CC1200_RESET(1, CC1200);
	usleep(1000);
	CC1200_RESET(2, CC1200);
	usleep(1000);
	CC1200_RESET(3, CC1200);
	usleep(1000);

	/* Init CC1200 */
	CC1200_Regvalue = CC1200_Init(0, CC1200);
	if (CC1200_Regvalue != 0)
	{
		leds += 1;
	}
	usleep(1000);
	CC1200_Regvalue = CC1200_Init(1, CC1200);
	if (CC1200_Regvalue != 0)
	{
		leds += 2;
	}
	usleep(1000);
	CC1200_Regvalue = CC1200_Init(2, CC1200);
	if (CC1200_Regvalue != 0)
	{
		leds += 4;
	}
	usleep(1000);
	CC1200_Regvalue = CC1200_Init(3, CC1200);
	if (CC1200_Regvalue != 0)
	{
		leds += 8;
	}
	usleep(1000);
	XGpio_DiscreteWrite(&LEDS, 1, leds);
//	usleep(1000);

	CC1200_Regvalue = CC1200_WriteRegByAddr(0, CC1200, CC1200_PKT_CFG1, 0x43);
	CC1200_Regvalue = CC1200_WriteRegByAddr(1, CC1200, CC1200_PKT_CFG1, 0x43);
	CC1200_Regvalue = CC1200_WriteRegByAddr(2, CC1200, CC1200_PKT_CFG1, 0x43);
	CC1200_Regvalue = CC1200_WriteRegByAddr(3, CC1200, CC1200_PKT_CFG1, 0x43);

	for (u32 i = 0; i < 4; i++)
	{
		while (CC1200_setGPIO(i, CC1200, 0, 0) != 0);
		while (CC1200_setGPIO(i, CC1200, 2, 6) != 0);
		while (CC1200_setGPIO(i, CC1200, 3, 4) != 0);
		while (CC1200_setPktLen(i, CC1200, 64) != 0);
		while (CC1200_setFifoTh(i, CC1200, 6) != 0);
		CC1200_setFrequency(i, CC1200, 905 + 5*i, RX_MODE);
		usleep(10000);
	}
	// set freq and power
//	CC1200_setFrequency(0, CC1200, 905, RX_MODE);
//	usleep(10000);
//	CC1200_setFrequency(1, CC1200, 910, RX_MODE);
//	usleep(10000);
//	CC1200_setFrequency(2, CC1200, 915, RX_MODE);
//	usleep(10000);
//	CC1200_setFrequency(3, CC1200, 920, RX_MODE);
//	usleep(10000);

	for (u32 i = 0; i < 4; i++)
	{
		CC1200_WriteReg (i, CC1200, SRX);
	}




	CC1200_Regvalue = CC1200_WriteReg (0, CC1200, SNOP);
	CC1200_Regvalue = CC1200_WriteReg (1, CC1200, SNOP);
	CC1200_Regvalue = CC1200_WriteReg (2, CC1200, SNOP);
	CC1200_Regvalue = CC1200_WriteReg (3, CC1200, SNOP);

//	CC1200_setPower(1, 14, RX_MODE);
//	while (leds != 0)
//	{
//		usleep(500000);
//		XGpio_DiscreteWrite(&LEDS, 1, leds);
//		usleep(500000);
//		XGpio_DiscreteWrite(&LEDS, 1, 0x0);
//	}
	leds = 0;
#ifdef CH_0
	leds |= (1 << 0);
#endif

#ifdef CH_1
	leds |= (1 << 1);
#endif

#ifdef CH_2
	leds |= (1 << 2);
#endif

#ifdef CH_3
	leds |= (1 << 3);
#endif

	XGpio_DiscreteWrite(&LEDS, 1, leds);

	delay = 1;

	// XGpio_DiscreteWrite(CC1200.CC1200_FIFO_TH, 1, 6);

	while(1)
	{
		#ifdef CH_0
		///////////// Channel 0 ///////////////

		CC1200_Regvalue = CC1200_WriteReg (0, CC1200, SNOP);
		if (CC1200_Regvalue == 0x60) {
			CC1200_Regvalue = XGpio_DiscreteRead(CC1200.CC1200_0_GPIO, 1);
			CC1200_flushRxFifo(0, CC1200);
		}

		if ((XGpio_DiscreteRead(CC1200.CC1200_0_GPIO, 1) & (0x1)) == 0x1)	// fifo th gpio
		{
			CC1200_WriteReg(0, CC1200, STANDARD_FIFO_ACCESS_RX);
		}
		usleep(delay);
		#endif

		#ifdef CH_1
		///////////// Channel 1 ///////////////

		CC1200_Regvalue = CC1200_WriteReg (1, CC1200, SNOP);
		if (CC1200_Regvalue == 0x60) {
			CC1200_flushRxFifo(1, CC1200);
		}
	
		if ((XGpio_DiscreteRead(CC1200.CC1200_1_GPIO, 1) & (0x1)) == 0x1)	// fifo th gpio
		{
			CC1200_WriteReg(1, CC1200, STANDARD_FIFO_ACCESS_RX);
		}
		usleep(delay);
		#endif

        #ifdef CH_2
		///////////// Channel 2 ///////////////
		
		CC1200_Regvalue = CC1200_WriteReg (2, CC1200, SNOP);
		if (CC1200_Regvalue == 0x60) {
			CC1200_flushRxFifo(2, CC1200);
		}

		if ((XGpio_DiscreteRead(CC1200.CC1200_2_GPIO, 1) & (0x1)) == 0x1)	// fifo th gpio
		{
			CC1200_WriteReg(2, CC1200, STANDARD_FIFO_ACCESS_RX);
		}

		usleep(delay);
		#endif

		///////////// Channel 3 ///////////////
		#ifdef CH_3

		CC1200_Regvalue = CC1200_WriteReg (3, CC1200, SNOP);
		if (CC1200_Regvalue == 0x60) {
			CC1200_flushRxFifo(3, CC1200);
		}
	
		if ((XGpio_DiscreteRead(CC1200.CC1200_3_GPIO, 1) & (0x1)) == 0x1)	// fifo th gpio
		{
			CC1200_WriteReg(3, CC1200, STANDARD_FIFO_ACCESS_RX);
		}
		usleep(delay);
		#endif	

	};

	return 1;
}

int ZQ_gpio_init(ZQ_CC1200 CC1200)
{
	int GpioStatus;

	/* Initialize the Gpio TX_PA_LEDS driver */
	GpioStatus = XGpio_Initialize(&LEDS, XPAR_GPIO_0_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_FIFO_TH driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_FIFO_TH, XPAR_GPIO_1_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio ZQ_CC1200_0_GPIO driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_0_GPIO , XPAR_GPIO_2_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio ZQ_CC1200_1_GPIO driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_1_GPIO, XPAR_GPIO_3_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio ZQ_CC1200_2_GPIO driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_2_GPIO, XPAR_GPIO_4_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio ZQ_CC1200_3_GPIO driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_3_GPIO, XPAR_GPIO_5_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_READY driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_READY, XPAR_GPIO_6_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio ZQ_REG_CS driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_REG_CS, XPAR_GPIO_7_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_REG_IN_0 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_REG_IN_0, XPAR_GPIO_8_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_REG_IN_1 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_REG_IN_1, XPAR_GPIO_9_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_REG_IN_2 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_REG_IN_2, XPAR_GPIO_10_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_REG_IN_3 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_REG_IN_3, XPAR_GPIO_11_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_REG_OUT_0 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_REG_OUT_0, XPAR_GPIO_12_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_REG_OUT_1 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_REG_OUT_1, XPAR_GPIO_13_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_REG_OUT_2 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_REG_OUT_2, XPAR_GPIO_14_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_REG_OUT_3 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_REG_OUT_3, XPAR_GPIO_15_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio ZQ_CC1200_RST driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_RST, XPAR_GPIO_16_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio UPSAMPLE_FACTOR driver */
	GpioStatus = XGpio_Initialize(&UPSAMPLE_FACTOR, XPAR_GPIO_17_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio MIN_FRAME_SW_DETECTED driver */
	GpioStatus = XGpio_Initialize(&MIN_FRAME_SW_DETECTED, XPAR_GPIO_18_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio SW_TIME_OUT driver */
	GpioStatus = XGpio_Initialize(&SW_TIME_OUT, XPAR_GPIO_19_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_RSSI_0 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_RSSI_0, XPAR_GPIO_20_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_RSSI_1 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_RSSI_1, XPAR_GPIO_21_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_RSSI_2 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_RSSI_2, XPAR_GPIO_22_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;

	/* Initialize the Gpio CC1200_RSSI_3 driver */
	GpioStatus = XGpio_Initialize(CC1200.CC1200_RSSI_3, XPAR_GPIO_23_DEVICE_ID);
	if (GpioStatus != XST_SUCCESS) return XST_FAILURE;


	return XST_SUCCESS;
}

u32 CC1200_WriteReg_new(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 DataIn)
{
	u32 StatusVal = 0xFF;
	/* Wait until CC1200 is Ready */
	while ((XGpio_DiscreteRead(CC1200.CC1200_READY, 1) & (1 << CC1200_Index)) != (1 << CC1200_Index))
	{
//		usleep(100);
	}
	/* Prepare Data to Send */
	switch (CC1200_Index) {
		case 0:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_0, 1, DataIn);
			break;
		case 1:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_1, 1, DataIn);
			break;
		case 2:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_2, 1, DataIn);
			break;
		case 3:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_3, 1, DataIn);
			break;
		default:
			break;
	}


	// XGpio_DiscreteWrite(&ZQ_REG_IN, 1, DataIn);
	/* Set REG_CS Signal */
	XGpio_DiscreteWrite(CC1200.CC1200_REG_CS, 1, (1 << CC1200_Index));
	/* Reset REG_CS Signal */
	XGpio_DiscreteWrite(CC1200.CC1200_REG_CS, 1, 0);
	/* Wait until CC1200 is Ready */
	while ((XGpio_DiscreteRead(CC1200.CC1200_READY, 1) & (1 << CC1200_Index)) != (1 << CC1200_Index))
	{
//		usleep(100);
	}
	/* Read CC1200_REG_OUT value */

	switch (CC1200_Index) {
		case 0:
			StatusVal = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_0, 1);
			break;
		case 1:
			StatusVal = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_1, 1);
			break;
		case 2:
			StatusVal = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_2, 1);
			break;
		case 3:
			StatusVal = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_3, 1);
			break;
		default:
			break;
	}
	StatusVal = StatusVal & 0x00700000;
	StatusVal = StatusVal >> 16;
	usleep(1000);
	return StatusVal;
}

u32 CC1200_WriteReg(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 DataIn)
{
	u32 StatusVal = 0xFF;

	/* Wait until CC1200 is Ready */
	while ((XGpio_DiscreteRead(CC1200.CC1200_READY, 1) & (1 << CC1200_Index)) != (1 << CC1200_Index))
	{
//		 usleep(100);
	}
	/* Prepare Data to Send */
//	XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_0, 1, DataIn);
	switch (CC1200_Index) {
		case 0:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_0, 1, DataIn);
			break;
		case 1:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_1, 1, DataIn);
			break;
		case 2:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_2, 1, DataIn);
			break;
		case 3:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_3, 1, DataIn);
			break;
		default:
			break;
	}

	/* Set REG_CS Signal */
//	XGpio_DiscreteWrite(CC1200.CC1200_REG_CS, 1, 1);
	XGpio_DiscreteWrite(CC1200.CC1200_REG_CS, 1, (1 << CC1200_Index));
	/* Reset REG_CS Signal */
	XGpio_DiscreteWrite(CC1200.CC1200_REG_CS, 1, 0);
	/* Wait until CC1200 is Ready */
	while ((XGpio_DiscreteRead(CC1200.CC1200_READY, 1) & (1 << CC1200_Index)) != (1 << CC1200_Index))
	{
//		 usleep(100);
	}
	/* Read CC1200_REG_OUT value */
//	StatusVal = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_0, 1);
	switch (CC1200_Index) {
		case 0:
			StatusVal = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_0, 1);
			break;
		case 1:
			StatusVal = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_1, 1);
			break;
		case 2:
			StatusVal = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_2, 1);
			break;
		case 3:
			StatusVal = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_3, 1);
			break;
		default:
			break;
	}

	StatusVal = StatusVal & 0x00700000;
	StatusVal = StatusVal >> 16;
	// usleep(500);
	return StatusVal;
}

u32 CC1200_WriteRegByAddr(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 addr, u32 DataIn)
{
	u32 cc1200Reg = 0x0;

	if (addr <= 0x2E)
	{
		cc1200Reg = (addr << 16) | (DataIn << 8);
	} else
	{
		cc1200Reg = (addr << 8) | DataIn;
	}

	return CC1200_WriteReg(CC1200_Index, CC1200, cc1200Reg);
}

u32 CC1200_ReadReg_new(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 DataIn)
{
	u32 RegValue = 0;

	/* Wait until CC1200 is Ready */
	while ((XGpio_DiscreteRead(CC1200.CC1200_READY, 1) & (1 << CC1200_Index)) != (1 << CC1200_Index))
	{
		usleep(100);
	}
	/* Prepare Data to Send */
	// XGpio_DiscreteWrite(&ZQ_REG_IN, 1, (DataIn | 1 << 23));
	switch (CC1200_Index) {
		case 0:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_0, 1, (DataIn | 1 << 23));
			break;
		case 1:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_1, 1, (DataIn | 1 << 23));
			break;
		case 2:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_2, 1, (DataIn | 1 << 23));
			break;
		case 3:
			XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_3, 1, (DataIn | 1 << 23));
			break;
		default:
			break;
	}
    /* Set REG_CS Signal */
	XGpio_DiscreteWrite(CC1200.CC1200_REG_CS, 1, (1 << CC1200_Index));
	/* Reset REG_CS Signal */
	XGpio_DiscreteWrite(CC1200.CC1200_REG_CS, 1, 0);
	/* Wait until CC1200 is Ready */
	while ((XGpio_DiscreteRead(CC1200.CC1200_READY, 1) & (1 << CC1200_Index)) != (1 << CC1200_Index))
	{
		usleep(100);
	}
	/* Read CC1200_REG_OUT value */

	switch (CC1200_Index) {
	case 0:
		RegValue = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_0, 1);
		break;
	case 1:
		RegValue = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_1, 1);
		break;
	case 2:
		RegValue = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_2, 1) ;
		break;
	case 3:
		RegValue = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_3, 1) ;
		break;
	default:
		break;
	}
//	}

	return RegValue;
}

u32 CC1200_ReadReg(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 DataIn)
{
	u32 RegValue = 0;

	/* Wait until CC1200 is Ready */
	while ((XGpio_DiscreteRead(CC1200.CC1200_READY, 1) & 1) != 1)
	{
		 usleep(100);
	}
	/* Prepare Data to Send */
	XGpio_DiscreteWrite(CC1200.CC1200_REG_IN_0, 1, (DataIn | 1 << 23));

    /* Set REG_CS Signal */
	XGpio_DiscreteWrite(CC1200.CC1200_REG_CS, 1, 1);
	/* Reset REG_CS Signal */
	XGpio_DiscreteWrite(CC1200.CC1200_REG_CS, 1, 0);
	/* Wait until CC1200 is Ready */
	while ((XGpio_DiscreteRead(CC1200.CC1200_READY, 1) & 1) != 1)
	{
		 usleep(100);
	}
	/* Read CC1200_REG_OUT value */
//	HeaderVal = (DataIn & 0x003F0000) >> 16;
	/* Single Register Low Register Space Read */
//	if (HeaderVal < 0x2F)
//	{
//	    RegValue = (XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_0, 1) >> 8) & 0x000000FF ;
//	}
//	/* Single Register High Register Space Read */
//	else if (HeaderVal == 0x2F)
//	{
//		RegValue = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_0, 1);
//	}
	RegValue = XGpio_DiscreteRead(CC1200.CC1200_REG_OUT_0, 1);
	return RegValue;
}

u32 CC1200_ReadRegByAddr(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 addr)
{
	u32 cc1200Reg = 0x0;

	u32 offset = addr <= 0x2E ? 16 : 8;

	cc1200Reg = (addr << offset);

	return CC1200_ReadReg_new(CC1200_Index, CC1200, cc1200Reg);
}

void CC1200_rmw(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 CC1200Addr, u32 mask, u32 data)
{
	u32 regData;
	regData = CC1200_ReadRegByAddr(CC1200_Index, CC1200, CC1200Addr);
	CC1200_WriteRegByAddr(CC1200_Index, CC1200, CC1200Addr, (regData & ~mask) | (data & mask));
}

void CC1200_setBit(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 CC1200Addr, u32 bitPos)
{
	u32 regData;
	regData = CC1200_ReadRegByAddr(CC1200_Index, CC1200, CC1200Addr);
	CC1200_WriteRegByAddr(CC1200_Index, CC1200, CC1200Addr, regData | (1 << bitPos));
}

void CC1200_clearBit(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 CC1200Addr, u32 bitPos)
{
	u32 regData;
	regData = CC1200_ReadRegByAddr(CC1200_Index, CC1200, CC1200Addr);
	CC1200_WriteRegByAddr(CC1200_Index, CC1200, CC1200Addr, regData & ~(1 << bitPos));
}

u32 CC1200_Init(u32 CC1200_Index, ZQ_CC1200 CC1200)
{
	u32 CC1200_Regvalue;
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00001500);   // IOCFG3 = 0x15
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0000);
	if (CC1200_Regvalue !=  0x15) {
		// return (0x0000 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00010600);   // IOCFG2 = 0x06
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0001);
	if (CC1200_Regvalue !=  0x06) {
		// return (0x0001 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00023000);   // IOCFG1 = 0x30
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0002);
	if (CC1200_Regvalue !=  0x30) {
		// return (0x0002 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00033C00);   // IOCFG0 = 0x3C
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0003);
	if (CC1200_Regvalue !=  0x3C) {
		// return (0x0003 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00049300);   // SYNC3 = 0x93
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0004);
	if (CC1200_Regvalue !=  0x93) {
		// return (0x0004 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00050B00);   // SYNC2 = 0x0B
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0005);
	if (CC1200_Regvalue !=  0x0B) {
		// return (0x0005 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00065100);   // SYNC1 = 0x51
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0006);
	if (CC1200_Regvalue !=  0x51) {
		// return (0x0006 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x0007DE00);   // SYNC0 = 0xDE
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0007);
	if (CC1200_Regvalue !=  0xDE) {
		// return (0x0007 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x0008A800);   // SYNC_CFG1 = 0xA8
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0008);
	if (CC1200_Regvalue !=  0xA8) {
		// return (0x0008 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00092300);   // SYNC_CFG0 = 0x23
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0009);
	if (CC1200_Regvalue !=  0x23) {
		// return (0x0009 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x000AA500);   // DEVIATION_M = 0xA5
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x000A);
	if (CC1200_Regvalue !=  0xA5) {
		// return (0x000A << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x000B0B00);   // MODCFG_DEV_E = 0x0B
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x000B);
	if (CC1200_Regvalue !=  0x0B) {
		// return (0x000B << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x000C4B00);   // DCFILT_CFG = 0x4B
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x000C);
	if (CC1200_Regvalue !=  0x4B) {
		// return (0x000C << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x000D1400);   // PREAMBLE_CFG1 = 0x14
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x000D);
	if (CC1200_Regvalue !=  0x14) {
		// return (0x000D << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x000E8A00);   // PREAMBLE_CFG0 = 0x8A
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x000E);
	if (CC1200_Regvalue !=  0x8A) {
		// return (0x000E << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x000F5800);   // IQIC = 0x58
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x000F);
	if (CC1200_Regvalue !=  0x58) {
		// return (0x000F << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00108300);   // CHAN_BW = 0x83
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0010);
	if (CC1200_Regvalue !=  0x83) {
		// return (0x0010 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00114200);   // MDMCFG1 = 0x42
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0011);
	if (CC1200_Regvalue !=  0x42) {
		// return (0x0011 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00120500);   // MDMCFG0 = 0x05
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0012);
	if (CC1200_Regvalue !=  0x05) {
		// return (0x0012 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00139A00);   // SYMBOL_RATE2 = 0x9A
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0013);
	if (CC1200_Regvalue !=  0x9A) {
		// return (0x0013 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00145800);   // SYMBOL_RATE1 = 0x58
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0014);
	if (CC1200_Regvalue !=  0x58) {
		// return (0x0014 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00157100);   // SYMBOL_RATE0 = 0x71
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0015);
	if (CC1200_Regvalue !=  0x71) {
		// return (0x0015 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00162800);   // AGC_REF = 0x28
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0016);
	if (CC1200_Regvalue !=  0x28) {
		// return (0x0016 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x0017F600);   // AGC_CS_THR = 0xF6
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0017);
	if (CC1200_Regvalue !=  0xF6) {
		// return (0x0017 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00180000);   // AGC_GAIN_ADJUST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0018);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x0018 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x0019B100);   // AGC_CFG3 = 0xB1
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0019);
	if (CC1200_Regvalue !=  0xB1) {
		// return (0x0019 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x001A2000);   // AGC_CFG2 = 0x20
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x001A);
	if (CC1200_Regvalue !=  0x20) {
		// return (0x001A << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x001B1200);   // AGC_CFG1 = 0x12
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x001B);
	if (CC1200_Regvalue !=  0x12) {
		// return (0x001B << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x001C8000);   // AGC_CFG0 = 0x80
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x001C);
	if (CC1200_Regvalue !=  0x80) {
		// return (0x001C << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x001D0000);   // FIFO_CFG = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x001D);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x001D << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x001E0000);   // DEV_ADDR = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x001E);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x001E << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x001F0B00);   // SETTLING_CFG = 0x0B
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x001F);
	if (CC1200_Regvalue !=  0x0B) {
		// return (0x001F << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00201200);   // FS_CFG = 0x12
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0020);
	if (CC1200_Regvalue !=  0x12) {
		// return (0x0020 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00210800);   // WOR_CFG1 = 0x08
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0021);
	if (CC1200_Regvalue !=  0x08) {
		// return (0x0021 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00222100);   // WOR_CFG0 = 0x21
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0022);
	if (CC1200_Regvalue !=  0x21) {
		// return (0x0022 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00230000);   // WOR_EVENT0_MSB = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0023);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x0023 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00240000);   // WOR_EVENT0_LSB = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0024);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x0024 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00250000);   // RXDCM_TIME = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0025);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x0025 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00260000);   // PKT_CFG2 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0026);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x0026 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00274100);   // PKT_CFG1 = 0x41
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0027);
	if (CC1200_Regvalue !=  0x43) {
		// return (0x0027 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00280000);   // PKT_CFG0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0028);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x0028 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x00293F00);   // RFEND_CFG1 = 0x3F
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x0029);
	if (CC1200_Regvalue !=  0x0F) {
		// return (0x0029 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002A0000);   // RFEND_CFG0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x002A);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x002A << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002B7F00);   // PA_CFG1 = 0x7F
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x002B);
	if (CC1200_Regvalue !=  0x7F) {
		// return (0x002B << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002C5300);   // PA_CFG0 = 0x53
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x002C);
	if (CC1200_Regvalue !=  0x53) {
		// return (0x002C << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002D0F00);   // ASK_CFG = 0x0F
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x002D);
	if (CC1200_Regvalue !=  0x0F) {
		// return (0x002D << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002E4200);   // PKT_LEN = 0x42
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x002E);
	if (CC1200_Regvalue !=  0x42) {
		// return (0x002E << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F001C);   // IF_MIX_CFG = 0x1C
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F00);
	if (CC1200_Regvalue !=  0x1C) {
		// return (0x2F00 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0120);   // FREQOFF_CFG = 0x20
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F01);
	if (CC1200_Regvalue !=  0x20) {
		// return (0x2F01 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0203);   // TOC_CFG = 0x03
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F02);
	if (CC1200_Regvalue !=  0x03) {
		// return (0x2F02 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0300);   // MARC_SPARE = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F03);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F03 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0400);   // ECG_CFG = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F04);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F04 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0502);   // MDMCFG2 = 0x02
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F05);
	if (CC1200_Regvalue !=  0x02) {
		// return (0x2F05 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0601);   // EXT_CTRL = 0x01
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F06);
	if (CC1200_Regvalue !=  0x01) {
		// return (0x2F06 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0700);   // RCCAL_FINE = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F07);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F07 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0800);   // RCCAL_COARSE = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F08);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F08 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0900);   // RCCAL_OFFSET = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F09);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F09 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0A00);   // FREQOFF1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F0A);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F0A << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0B00);   // FREQOFF0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F0B);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F0B << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0C5A);   // FREQ2 = 0x5A
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F0C);
	if (CC1200_Regvalue !=  0x5A) {
		// return (0x2F0C << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0D80);   // FREQ1 = 0x80
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F0D);
	if (CC1200_Regvalue !=  0x80) {
		// return (0x2F0D << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0E00);   // FREQ0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F0E);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F0E << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F0F02);   // IF_ADC2 = 0x02
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F0F);
	if (CC1200_Regvalue !=  0x02) {
		// return (0x2F0F << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F10EE);   // IF_ADC1 = 0xEE
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F10);
	if (CC1200_Regvalue !=  0xEE) {
		// return (0x2F10 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1110);   // IF_ADC0 = 0x10
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F11);
	if (CC1200_Regvalue !=  0x10) {
		// return (0x2F11 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1207);   // FS_DIG1 = 0x07
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F12);
	if (CC1200_Regvalue !=  0x07) {
		// return (0x2F12 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F13A5);   // FS_DIG0 = 0xA5
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F13);
	if (CC1200_Regvalue !=  0xA5) {
		// return (0x2F13 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1400);   // FS_CAL3 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F14);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F14 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1520);   // FS_CAL2 = 0x20
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F15);
	if (CC1200_Regvalue !=  0x20) {
		// return (0x2F15 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1640);   // FS_CAL1 = 0x40
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F16);
	if (CC1200_Regvalue !=  0x40) {
		// return (0x2F16 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F170E);   // FS_CAL0 = 0x0E
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F17);
	if (CC1200_Regvalue !=  0x0E) {
		// return (0x2F17 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1828);   // FS_CHP = 0x28
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F18);
	if (CC1200_Regvalue !=  0x28) {
		// return (0x2F18 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1903);   // FS_DIVTWO = 0x03
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F19);
	if (CC1200_Regvalue !=  0x03) {
		// return (0x2F19 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1A00);   // FS_DSM1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F1A);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F1A << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1B33);   // FS_DSM0 = 0x33
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F1B);
	if (CC1200_Regvalue !=  0x33) {
		// return (0x2F1B << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1CFF);   // FS_DVC1 = 0xFF
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F1C);
	if (CC1200_Regvalue !=  0xFF) {
		// return (0x2F1C << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1D17);   // FS_DVC0 = 0x17
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F1D);
	if (CC1200_Regvalue !=  0x17) {
		// return (0x2F1D << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1E00);   // FS_LBI = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F1E);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F1E << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F1F00);   // FS_PFD = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F1F);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F1F << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F206E);   // FS_PRE = 0x6E
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F20);
	if (CC1200_Regvalue !=  0x6E) {
		// return (0x2F20 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F211C);   // FS_REG_DIV_CML = 0x1C
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F21);
	if (CC1200_Regvalue !=  0x1C) {
		// return (0x2F21 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F22AC);   // FS_SPARE = 0xAC
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F22);
	if (CC1200_Regvalue !=  0xAC) {
		// return (0x2F22 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2314);   // FS_VCO4 = 0x14
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F23);
	if (CC1200_Regvalue !=  0x14) {
		// return (0x2F23 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2400);   // FS_VCO3 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F24);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F24 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2500);   // FS_VCO2 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F25);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F25 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2600);   // FS_VCO1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F26);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F26 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F27B5);   // FS_VCO0 = 0xB5
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F27);
	if (CC1200_Regvalue !=  0xB5) {
		// return (0x2F27 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2800);   // GBIAS6 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F28);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F28 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2902);   // GBIAS5 = 0x02
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F29);
	if (CC1200_Regvalue !=  0x02) {
		// return (0x2F29 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2A00);   // GBIAS4 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F2A);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F2A << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2B00);   // GBIAS3 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F2B);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F2B << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2C10);   // GBIAS2 = 0x10
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F2C);
	if (CC1200_Regvalue !=  0x10) {
		// return (0x2F2C << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2D00);   // GBIAS1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F2D);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F2D << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2E00);   // GBIAS0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F2E);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F2E << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F2F09);   // IFAMP = 0x09
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F2F);
	if (CC1200_Regvalue !=  0x09) {
		// return (0x2F2F << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F3001);   // LNA = 0x01
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F30);
	if (CC1200_Regvalue !=  0x01) {
		// return (0x2F30 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F3101);   // RXMIX = 0x01
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F31);
	if (CC1200_Regvalue !=  0x01) {
		// return (0x2F31 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F320E);   // XOSC5 = 0x0E
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F32);
	if (CC1200_Regvalue !=  0x0E) {
		// return (0x2F32 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F33A0);   // XOSC4 = 0xA0
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F33);
	if (CC1200_Regvalue !=  0xA0) {
		// return (0x2F33 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F3403);   // XOSC3 = 0x03
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F34);
	if (CC1200_Regvalue !=  0x03) {
		// return (0x2F34 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F3504);   // XOSC2 = 0x04
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F35);
	if (CC1200_Regvalue !=  0x04) {
		// return (0x2F35 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F3603);   // XOSC1 = 0x03
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F36);
	if (CC1200_Regvalue !=  0x03) {
		// return (0x2F36 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F3700);   // XOSC0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F37);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F37 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F3800);   // ANALOG_SPARE = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F38);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F38 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F3900);   // PA_CFG3 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F39);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F39 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6400);   // WOR_TIME1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F64);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F64 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6500);   // WOR_TIME0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F65);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F65 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6600);   // WOR_CAPTURE1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F66);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F66 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6700);   // WOR_CAPTURE0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F67);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F67 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6800);   // BIST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F68);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F68 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6900);   // DCFILTOFFSET_I1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F69);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F69 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6A00);   // DCFILTOFFSET_I0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F6A);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F6A << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6B00);   // DCFILTOFFSET_Q1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F6B);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F6B << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6C00);   // DCFILTOFFSET_Q0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F6C);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F6C << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6D00);   // IQIE_I1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F6D);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F6D << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6E00);   // IQIE_I0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F6E);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F6E << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F6F00);   // IQIE_Q1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F6F);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F6F << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7000);   // IQIE_Q0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F70);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F70 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7180);   // RSSI1 = 0x80
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F71);
	if (CC1200_Regvalue !=  0x80) {
		// return (0x2F71 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7200);   // RSSI0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F72);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F72 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7341);   // MARCSTATE = 0x41
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F73);
	if (CC1200_Regvalue !=  0x41) {
		// return (0x2F73 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7400);   // LQI_VAL = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F74);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F74 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F75FF);   // PQT_SYNC_ERR = 0xFF
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F75);
	if (CC1200_Regvalue !=  0xFF) {
		// return (0x2F75 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7600);   // DEM_STATUS = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F76);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F76 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7700);   // FREQOFF_EST1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F77);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F77 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7800);   // FREQOFF_EST0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F78);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F78 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7900);   // AGC_GAIN3 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F79);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F79 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7AD1);   // AGC_GAIN2 = 0xD1
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F7A);
	if (CC1200_Regvalue !=  0xD1) {
		// return (0x2F7A << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7B00);   // AGC_GAIN1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F7B);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F7B << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7C3F);   // AGC_GAIN0 = 0x3F
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F7C);
	if (CC1200_Regvalue !=  0x3F) {
		// return (0x2F7C << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7D00);   // CFM_RX_DATA_OUT = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F7D);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F7D << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7E00);   // CFM_TX_DATA_IN = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F7E);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F7E << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F7F30);   // ASK_SOFT_RX_DATA = 0x30
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F7F);
	if (CC1200_Regvalue !=  0x30) {
		// return (0x2F7F << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F807F);   // RNDGEN = 0x7F
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F80);
	if (CC1200_Regvalue !=  0x7F) {
		// return (0x2F80 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8100);   // MAGN2 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F81);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F81 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8200);   // MAGN1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F82);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F82 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8300);   // MAGN0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F83);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F83 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8400);   // ANG1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F84);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F84 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8500);   // ANG0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F85);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F85 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8602);   // CHFILT_I2 = 0x02
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F86);
	if (CC1200_Regvalue !=  0x02) {
		// return (0x2F86 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8700);   // CHFILT_I1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F87);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F87 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8800);   // CHFILT_I0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F88);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F88 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8900);   // CHFILT_Q2 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F89);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F89 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8A00);   // CHFILT_Q1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F8A);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F8A << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8B00);   // CHFILT_Q0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F8B);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F8B << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8C00);   // GPIO_STATUS = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F8C);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F8C << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8D01);   // FSCAL_CTRL = 0x01
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F8D);
	if (CC1200_Regvalue !=  0x01) {
		// return (0x2F8D << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8E00);   // PHASE_ADJUST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F8E);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F8E << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F8F00);   // PARTNUMBER = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F8F);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F8F << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9000);   // PARTVERSION = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F90);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F90 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9100);   // SERIAL_STATUS = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F91);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F91 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9201);   // MODEM_STATUS1 = 0x01
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F92);
	if (CC1200_Regvalue !=  0x01) {
		// return (0x2F92 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9300);   // MODEM_STATUS0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F93);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F93 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9400);   // MARC_STATUS1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F94);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F94 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9500);   // MARC_STATUS0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F95);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F95 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9600);   // PA_IFAMP_TEST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F96);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F96 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9700);   // FSRF_TEST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F97);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F97 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9800);   // PRE_TEST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F98);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F98 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9900);   // PRE_OVR = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F99);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F99 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9A00);   // ADC_TEST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F9A);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F9A << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9B0B);   // DVC_TEST = 0x0B
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F9B);
	if (CC1200_Regvalue !=  0x0B) {
		// return (0x2F9B << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9C40);   // ATEST = 0x40
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F9C);
	if (CC1200_Regvalue !=  0x40) {
		// return (0x2F9C << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9D00);   // ATEST_LVDS = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F9D);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F9D << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9E00);   // ATEST_MODE = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F9E);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2F9E << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002F9F3C);   // XOSC_TEST1 = 0x3C
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2F9F);
	if (CC1200_Regvalue !=  0x3C) {
		// return (0x2F9F << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FA000);   // XOSC_TEST0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FA0);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FA0 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FA100);   // AES = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FA1);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FA1 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FA200);   // MDM_TEST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FA2);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FA2 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FD200);   // RXFIRST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FD2);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FD2 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FD300);   // TXFIRST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FD3);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FD3 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FD400);   // RXLAST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FD4);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FD4 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FD500);   // TXLAST = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FD5);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FD5 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FD600);   // NUM_TXBYTES = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FD6);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FD6 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FD700);   // NUM_RXBYTES = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FD7);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FD7 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FD80F);   // FIFO_NUM_TXBYTES = 0x0F
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FD8);
	if (CC1200_Regvalue !=  0x0F) {
		// return (0x2FD8 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FD900);   // FIFO_NUM_RXBYTES = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FD9);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FD9 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FDA00);   // RXFIFO_PRE_BUF = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FDA);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FDA << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FE000);   // AES_KEY15 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FE0);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FE0 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FE100);   // AES_KEY14 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FE1);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FE1 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FE200);   // AES_KEY13 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FE2);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FE2 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FE300);   // AES_KEY12 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FE3);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FE3 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FE400);   // AES_KEY11 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FE4);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FE4 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FE500);   // AES_KEY10 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FE5);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FE5 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FE600);   // AES_KEY9 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FE6);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FE6 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FE700);   // AES_KEY8 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FE7);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FE7 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FE800);   // AES_KEY7 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FE8);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FE8 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FE900);   // AES_KEY6 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FE9);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FE9 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FEA00);   // AES_KEY5 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FEA);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FEA << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FEB00);   // AES_KEY4 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FEB);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FEB << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FEC00);   // AES_KEY3 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FEC);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FEC << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FED00);   // AES_KEY2 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FED);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FED << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FEE00);   // AES_KEY1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FEE);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FEE << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FEF00);   // AES_KEY0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FEF);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FEF << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FF000);   // AES_BUFFER15 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FF0);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FF0 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FF100);   // AES_BUFFER14 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FF1);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FF1 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FF200);   // AES_BUFFER13 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FF2);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FF2 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FF300);   // AES_BUFFER12 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FF3);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FF3 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FF400);   // AES_BUFFER11 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FF4);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FF4 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FF500);   // AES_BUFFER10 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FF5);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FF5 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FF600);   // AES_BUFFER9 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FF6);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FF6 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FF700);   // AES_BUFFER8 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FF7);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FF7 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FF800);   // AES_BUFFER7 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FF8);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FF8 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FF900);   // AES_BUFFER6 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FF9);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FF9 << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FFA00);   // AES_BUFFER5 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FFA);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FFA << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FFB00);   // AES_BUFFER4 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FFB);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FFB << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FFC00);   // AES_BUFFER3 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FFC);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FFC << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FFD00);   // AES_BUFFER2 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FFD);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FFD << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FFE00);   // AES_BUFFER1 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FFE);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FFE << 16) | CC1200_Regvalue;
	}

	usleep(100);
	CC1200_WriteReg(CC1200_Index, CC1200, 0x002FFF00);   // AES_BUFFER0 = 0x00
	usleep(100);
	CC1200_Regvalue = CC1200_ReadRegByAddr(CC1200_Index, CC1200, 0x2FFF);
	if (CC1200_Regvalue !=  0x00) {
		// return (0x2FFF << 16) | CC1200_Regvalue;
	}

	usleep(100);
	return 0;
}

void CC1200_HardRst(u32 CC1200_Index, ZQ_CC1200 CC1200)
{
	/* Reset is Active Low */
	XGpio_DiscreteWrite(CC1200.CC1200_RST, 1, 0xf & ~(1 << CC1200_Index));
	usleep(100);
	XGpio_DiscreteWrite(CC1200.CC1200_RST, 1, 0xf);
}

void CC1200_RESET(u32 CC1200_Index, ZQ_CC1200 CC1200)
{
	u32 CC1200regOut = 0xffffffff;
//	if (CC1200_WriteReg(CC1200_Index, CC1200, SRES) != IDLE)
//	{
//		CC1200_HardRst(CC1200_Index, CC1200);
//	}
	do {
		CC1200_HardRst(CC1200_Index, CC1200);
		usleep(1000);
		CC1200regOut = CC1200_WriteReg(CC1200_Index, CC1200, SRES);
	} while (CC1200regOut != IDLE);
}

void CC1200_setFrequency(u32 CC1200_Index, ZQ_CC1200 CC1200, float freqMHz, u32 rx_tx)
{
	u32 fsdBandSelect = 0, loDivider = 0, freq = 0, transStateAddr = 0x0, transState = 0xff, CC1200regOut = 0xffffffff;
	float fVco = 0.0;
	if (freqMHz >= 820 && freqMHz <= 960)
	{
		fsdBandSelect 	= 2;
		loDivider 		= 4;
	} else if (freqMHz >= 410 && freqMHz <= 480)
	{
		fsdBandSelect 	= 4;
		loDivider 		= 8;
	} else if (freqMHz >= 273.3 && freqMHz <= 320)
	{
		fsdBandSelect 	= 6;
		loDivider 		= 12;
	} else if (freqMHz >= 205 && freqMHz <= 240)
	{
		fsdBandSelect 	= 8;
		loDivider 		= 16;
	} else if (freqMHz >= 164 && freqMHz <= 192)
	{
		fsdBandSelect 	= 10;
		loDivider 		= 20;
	} else if (freqMHz >= 136.7 && freqMHz <= 160)
	{
		fsdBandSelect 	= 11;
		loDivider 		= 24;
	}
	CC1200_WriteReg (CC1200_Index, CC1200, SIDLE);
	while (CC1200_WriteReg (CC1200_Index, CC1200, SNOP) != IDLE);

	CC1200_rmw(CC1200_Index, CC1200, CC1200_FS_CFG, 0xF, fsdBandSelect);
	fVco = (u32) (freqMHz*1000000*loDivider);
	freq = (u32)((fVco/40000000)*(65536));

	CC1200_WriteRegByAddr(CC1200_Index, CC1200, CC1200_FREQ0, freq & 0xff);
	usleep(500);
	CC1200_WriteRegByAddr(CC1200_Index, CC1200, CC1200_FREQ1, (freq >> 8) & 0xff);
	usleep(500);
	CC1200_WriteRegByAddr(CC1200_Index, CC1200, CC1200_FREQ2, (freq >> 16) & 0xff);
	usleep(500);

	transStateAddr = rx_tx ? STX : SRX;
	transState = rx_tx ? TX : RX;
//	CC1200_WriteReg (CC1200_Index, CC1200, transStateAddr);

//	usleep(500);
//	do{
//		CC1200regOut = CC1200_WriteReg (CC1200_Index, CC1200, SNOP);
//		usleep(100000);
//	}
//	while (CC1200regOut != transState);

}

u32 CC1200_setPower(u32 CC1200_Index, ZQ_CC1200 CC1200, float power, u32 rx_tx)
{
	u32 paPowerRamp = (u32) (2 * power + 35);
	u32 transStateAddr = 0x0, transState = 0xff;

	CC1200_WriteReg (CC1200_Index, CC1200, SIDLE);
	while (CC1200_WriteReg (CC1200_Index, CC1200, SNOP) != IDLE);

	if (paPowerRamp >=3 && paPowerRamp <= 63) {
		CC1200_rmw(CC1200_Index, CC1200, CC1200_PA_CFG1, 0x3f, paPowerRamp);
		transStateAddr = rx_tx ? STX : SRX;
		transState = rx_tx ? TX : RX;
		CC1200_WriteReg (CC1200_Index, CC1200, transStateAddr);
		while (CC1200_WriteReg (CC1200_Index, CC1200, SNOP) != transState);
		return 1;
	} else {
		return 0;
	}
}

u32 CC1200_setFifoTh(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 th)
{
	CC1200_WriteRegByAddr(CC1200_Index, CC1200, CC1200_FIFO_CFG, (127 - th));

	if (CC1200_ReadRegByAddr(CC1200_Index, CC1200, CC1200_FIFO_CFG) == (127 - th))
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

u32 CC1200_setPktLen(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 len)
{
	CC1200_WriteRegByAddr(CC1200_Index, CC1200, CC1200_PKT_LEN, len);

	if (CC1200_ReadRegByAddr(CC1200_Index, CC1200, CC1200_PKT_LEN) == len)
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

u32 CC1200_setGPIO(u32 CC1200_Index, ZQ_CC1200 CC1200, u32 gpio, u32 val)
{
	u32 gpioAddr = 3 - gpio;
	CC1200_WriteRegByAddr(CC1200_Index, CC1200, gpioAddr, val);

	if (CC1200_ReadRegByAddr(CC1200_Index, CC1200, gpioAddr) == val)
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

void CC1200_flushRxFifo(u32 CC1200_Index, ZQ_CC1200 CC1200)
{
	CC1200_WriteReg (CC1200_Index, CC1200, SFRX);
	while (CC1200_WriteReg (CC1200_Index, CC1200, SNOP) != IDLE);
	CC1200_WriteReg (CC1200_Index, CC1200, SRX);
	while (CC1200_WriteReg (CC1200_Index, CC1200, SNOP) != RX);
}


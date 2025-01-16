/*
 * CC1200_param.h
 *
 *  Created on: 30 Dec 2022
 *      Author: Admin
 */

#ifndef CC1200_PARAM_H_
#define CC1200_PARAM_H_

#define RX_MODE 0x0
#define TX_MODE 0x1

// Definition of CC1200 State Constants
#define IDLE                    0x00
#define RX                      0x10
#define TX                      0x20
#define FSTXON                  0x30
#define CALIBRATE               0x40
#define SETTLING                0x50
#define RX_FIFO_ERROR           0x60
#define TX_FIFO_ERROR           0x70

// Definition of CC1200 Command Strobe Constants
#define SRES                    0x00300000
#define SFSTXON                 0x00310000
#define SXOFF                   0x00320000
#define SCAL                    0x00330000
#define SRX                     0x00340000
#define STX                     0x00350000
#define SIDLE                   0x00360000
#define SAFC                    0x00370000
#define SWOR                    0x00380000
#define SPWD                    0x00390000
#define SFRX                    0x003A0000
#define SFTX                    0x003B0000
#define SWORRST                 0x003C0000
#define SNOP                    0x003D0000


#define STANDARD_FIFO_ACCESS_TX	0x007f0000
#define STANDARD_FIFO_ACCESS_RX	0x00ff0000

// sync words
#define DIRECT_SW_LOW			0x21
#define DIRECT_SW_HI			0xae
#define OPOSITE_SW_LOW			0xde
#define OPOSITE_SW_HI			0x51

// Definition of CC1200 registers addresses
#define CC1200_GPIO3                   0x00
#define CC1200_GPIO2                   0x01
#define CC1200_GPIO1                   0x02
#define CC1200_GPIO0                   0x03
#define CC1200_SYNC3                   0x04
#define CC1200_SYNC2                   0x05
#define CC1200_SYNC1                   0x06
#define CC1200_SYNC0                   0x07
#define CC1200_SYNC_CFG1               0x08
#define CC1200_SYNC_CFG0               0x09
#define CC1200_DEVIATION_M             0x0A
#define CC1200_MODCFG_DEV_E            0x0B
#define CC1200_DCFILT_CFG              0x0C
#define CC1200_PREAMBLE_CFG1           0x0D
#define CC1200_PREAMBLE_CFG0           0x0E
#define CC1200_IQIC                    0x0F
#define CC1200_CHAN_BW                 0x10
#define CC1200_MDMCFG1                 0x11
#define CC1200_MDMCFG0                 0x12
#define CC1200_SYMBOL_RATE2            0x13
#define CC1200_SYMBOL_RATE1            0x14
#define CC1200_SYMBOL_RATE0            0x15
#define CC1200_AGC_REF                 0x16
#define CC1200_AGC_CS_THR              0x17
#define CC1200_AGC_GAIN_ADJUST         0x18
#define CC1200_AGC_CFG3                0x19
#define CC1200_AGC_CFG2                0x1A
#define CC1200_AGC_CFG1                0x1B
#define CC1200_AGC_CFG0                0x1C
#define CC1200_FIFO_CFG                0x1D
#define CC1200_DEV_ADDR                0x1E
#define CC1200_SETTLING_CFG            0x1F
#define CC1200_FS_CFG                  0x20
#define CC1200_WOR_CFG1                0x21
#define CC1200_WOR_CFG0                0x22
#define CC1200_WOR_EVENT0_MSB          0x23
#define CC1200_WOR_EVENT0_LSB          0x24
#define CC1200_RXDCM_TIME              0x25
#define CC1200_PKT_CFG2                0x26
#define CC1200_PKT_CFG1                0x27
#define CC1200_PKT_CFG0                0x28
#define CC1200_RFEND_CFG1              0x29
#define CC1200_RFEND_CFG0              0x2A
#define CC1200_PA_CFG1                 0x2B
#define CC1200_PA_CFG0                 0x2C
#define CC1200_ASK_CFG                 0x2D
#define CC1200_PKT_LEN                 0x2E

#define CC1200_IF_MIX_CFG              0x2F00
#define CC1200_FREQOFF_CFG             0x2F01
#define CC1200_TOC_CFG                 0x2F02
#define CC1200_MARC_SPARE              0x2F03
#define CC1200_ECG_CFG                 0x2F04
#define CC1200_MDMCFG2                 0x2F05
#define CC1200_EXT_CTRL                0x2F06
#define CC1200_RCCAL_FINE              0x2F07
#define CC1200_RCCAL_COARSE            0x2F08
#define CC1200_RCCAL_OFFSET            0x2F09
#define CC1200_FREQOFF1                0x2F0A
#define CC1200_FREQOFF0                0x2F0B
#define CC1200_FREQ2                   0x2F0C
#define CC1200_FREQ1                   0x2F0D
#define CC1200_FREQ0                   0x2F0E
#define CC1200_IF_ADC2                 0x2F0F
#define CC1200_IF_ADC1                 0x2F10
#define CC1200_IF_ADC0                 0x2F11
#define CC1200_FS_DIG1                 0x2F12
#define CC1200_FS_DIG0                 0x2F13
#define CC1200_FS_CAL3                 0x2F14
#define CC1200_FS_CAL2                 0x2F15
#define CC1200_FS_CAL1                 0x2F16
#define CC1200_FS_CAL0                 0x2F17
#define CC1200_FS_CHP                  0x2F18
#define CC1200_FS_DIVTWO               0x2F19
#define CC1200_FS_DSM1                 0x2F1A
#define CC1200_FS_DSM0                 0x2F1B
#define CC1200_FS_DVC1                 0x2F1C
#define CC1200_FS_DVC0                 0x2F1D
#define CC1200_FS_LBI                  0x2F1E
#define CC1200_FS_PFD                  0x2F1F
#define CC1200_FS_PRE                  0x2F20
#define CC1200_FS_REG_DIV_CML          0x2F21
#define CC1200_FS_SPARE                0x2F22
#define CC1200_FS_VCO4                 0x2F23
#define CC1200_FS_VCO3                 0x2F24
#define CC1200_FS_VCO2                 0x2F25
#define CC1200_FS_VCO1                 0x2F26
#define CC1200_FS_VCO0                 0x2F27
#define CC1200_GBIAS6                  0x2F28
#define CC1200_GBIAS5                  0x2F29
#define CC1200_GBIAS4                  0x2F2A
#define CC1200_GBIAS3                  0x2F2B
#define CC1200_GBIAS2                  0x2F2C
#define CC1200_GBIAS1                  0x2F2D
#define CC1200_GBIAS0                  0x2F2E
#define CC1200_IFAMP                   0x2F2F
#define CC1200_LNA                     0x2F30
#define CC1200_RXMIX                   0x2F31
#define CC1200_XOSC5                   0x2F32
#define CC1200_XOSC4                   0x2F33
#define CC1200_XOSC3                   0x2F34
#define CC1200_XOSC2                   0x2F35
#define CC1200_XOSC1                   0x2F36
#define CC1200_XOSC0                   0x2F37
#define CC1200_ANALOG_SPARE            0x2F38
#define CC1200_PA_CFG3                 0x2F39
#define CC1200_WOR_TIME1               0x2F64
#define CC1200_WOR_TIME0               0x2F65
#define CC1200_WOR_CAPTURE1            0x2F66
#define CC1200_WOR_CAPTURE0            0x2F67
#define CC1200_BIST                    0x2F68
#define CC1200_DCFILTOFFSET_I1         0x2F69
#define CC1200_DCFILTOFFSET_I0         0x2F6A
#define CC1200_DCFILTOFFSET_Q1         0x2F6B
#define CC1200_DCFILTOFFSET_Q0         0x2F6C
#define CC1200_IQIE_I1                 0x2F6D
#define CC1200_IQIE_I0                 0x2F6E
#define CC1200_IQIE_Q1                 0x2F6F
#define CC1200_IQIE_Q0                 0x2F70
#define CC1200_RSSI1                   0x2F71
#define CC1200_RSSI0                   0x2F72
#define CC1200_MARCSTATE               0x2F73
#define CC1200_LQI_VAL                 0x2F74
#define CC1200_PQT_SYNC_ERR            0x2F75
#define CC1200_DEM_STATUS              0x2F76
#define CC1200_FREQOFF_EST1            0x2F77
#define CC1200_FREQOFF_EST0            0x2F78
#define CC1200_AGC_GAIN3               0x2F79
#define CC1200_AGC_GAIN2               0x2F7A
#define CC1200_AGC_GAIN1               0x2F7B
#define CC1200_AGC_GAIN0               0x2F7C
#define CC1200_CFM_RX_DATA_OUT         0x2F7D
#define CC1200_CFM_TX_DATA_IN          0x2F7E
#define CC1200_ASK_SOFT_RX_DATA        0x2F7F
#define CC1200_RNDGEN                  0x2F80
#define CC1200_MAGN2                   0x2F81
#define CC1200_MAGN1                   0x2F82
#define CC1200_MAGN0                   0x2F83
#define CC1200_ANG1                    0x2F84
#define CC1200_ANG0                    0x2F85
#define CC1200_CHFILT_I2               0x2F86
#define CC1200_CHFILT_I1               0x2F87
#define CC1200_CHFILT_I0               0x2F88
#define CC1200_CHFILT_Q2               0x2F89
#define CC1200_CHFILT_Q1               0x2F8A
#define CC1200_CHFILT_Q0               0x2F8B
#define CC1200_GPIO_STATUS             0x2F8C
#define CC1200_FSCAL_CTRL              0x2F8D
#define CC1200_PHASE_ADJUST            0x2F8E
#define CC1200_PARTNUMBER              0x2F8F
#define CC1200_PARTVERSION             0x2F90
#define CC1200_SERIAL_STATUS           0x2F91
#define CC1200_MODEM_STATUS1           0x2F92
#define CC1200_MODEM_STATUS0           0x2F93
#define CC1200_MARC_STATUS1            0x2F94
#define CC1200_MARC_STATUS0            0x2F95
#define CC1200_PA_IFAMP_TEST           0x2F96
#define CC1200_FSRF_TES                0x2F97
#define CC1200_PRE_TES                 0x2F98
#define CC1200_PRE_OVR                 0x2F99
#define CC1200_ADC_TEST                0x2F9A
#define CC1200_DVC_TEST                0x2F9B
#define CC1200_ATEST                   0x2F9C
#define CC1200_ATEST_LVDS              0x2F9D
#define CC1200_ATEST_MODE              0x2F9E
#define CC1200_XOSC_TEST1              0x2F9F
#define CC1200_XOSC_TEST0              0x2FA0
#define CC1200_AES                     0x2FA1
#define CC1200_MDM_TEST                0x2FA2
#define CC1200_RXFIRST                 0x2FD2
#define CC1200_TXFIRST                 0x2FD3
#define CC1200_RXLAST                  0x2FD4
#define CC1200_TXLAST                  0x2FD5
#define CC1200_NUM_TXBYTES             0x2FD6
#define CC1200_NUM_RXBYTES             0x2FD7
#define CC1200_FIFO_NUM_TXBYTES        0x2FD8
#define CC1200_FIFO_NUM_RXBYTES        0x2FD9
#define CC1200_RXFIFO_PRE_BUF          0x2FDA
#define CC1200_AES_KEY15               0x2FE0
#define CC1200_AES_KEY14               0x2FE1
#define CC1200_AES_KEY13               0x2FE2
#define CC1200_AES_KEY12               0x2FE3
#define CC1200_AES_KEY11               0x2FE4
#define CC1200_AES_KEY10               0x2FE5
#define CC1200_AES_KEY9                0x2FE6
#define CC1200_AES_KEY8                0x2FE7
#define CC1200_AES_KEY7                0x2FE8
#define CC1200_AES_KEY6                0x2FE9
#define CC1200_AES_KEY5                0x2FEA
#define CC1200_AES_KEY4                0x2FEB
#define CC1200_AES_KEY3                0x2FEC
#define CC1200_AES_KEY2                0x2FED
#define CC1200_AES_KEY1                0x2FEE
#define CC1200_AES_KEY0                0x2FEF
#define CC1200_AES_BUFFER15            0x2FF0
#define CC1200_AES_BUFFER14            0x2FF1
#define CC1200_AES_BUFFER13            0x2FF2
#define CC1200_AES_BUFFER12            0x2FF3
#define CC1200_AES_BUFFER11            0x2FF4
#define CC1200_AES_BUFFER10            0x2FF5
#define CC1200_AES_BUFFER9             0x2FF6
#define CC1200_AES_BUFFER8             0x2FF7
#define CC1200_AES_BUFFER7             0x2FF8
#define CC1200_AES_BUFFER6             0x2FF9
#define CC1200_AES_BUFFER5             0x2FFA
#define CC1200_AES_BUFFER4             0x2FFB
#define CC1200_AES_BUFFER3             0x2FFC
#define CC1200_AES_BUFFER2             0x2FFD
#define CC1200_AES_BUFFER1             0x2FFE
#define CC1200_AES_BUFFER0             0x2FFF














#endif /* CC1200_PARAM_H_ */

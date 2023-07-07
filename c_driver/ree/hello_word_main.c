/*
 * Copyright (C) 2017-2019 Alibaba Group Holding Limited
 */


/******************************************************************************
 * @file     main.c
 * @brief    hello world
 * @version  V1.0
 * @date     17. Jan 2018
 ******************************************************************************/

#include <stdio.h>
#include "soc.h"
#include "drv_mbx_ch0.h"
#include "drv_mbx_ch1.h"
#include "drv_usart.h"

//#include"key.h"
//#include"led.h"
//#include "oled128_32.h"

extern void mdelay(uint32_t ms);
#define CH1_CTRL_ADDR   0x40100014
#define CH1_DATA_ADDR   0x40100018
#define CH1_STATUS_ADDR 0x4010001C
#define CH0_CTRL_ADDR   0x40030008
#define CH0_DATA_ADDR   0x4003000C
#define CH0_STATUS_ADDR 0x40030010

#define ACISR_ADDR      0x40030004

#define CLEAR_INT_CMD 	0x00004000

#define TIMER1_VREG 0x60000004

#define TIMER0_VREG 0x50000004

#define IOPMP_EXP 0x40100020

#define IOPMP_WRITE 0x40100024
extern usart_handle_t console_handle;
int main(void)
{
	iopmp_initialize(0);
    mbx_ch1_initialize(0);
	console_handle = csi_usart_initialize(1, NULL);
    /* config the UART */
	int32_t ret = 0;
    ret = csi_usart_config(console_handle, 115200, USART_MODE_ASYNCHRONOUS, USART_PARITY_NONE, USART_STOP_BITS_1, USART_DATA_BITS_8);

	//legal
	int timer1_value = *(volatile uint32_t *) TIMER1_VREG;
	//illegal
	int timer0_value = *(volatile uint32_t *) TIMER0_VREG;
    return 0;
}

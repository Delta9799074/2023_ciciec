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
#include "my_mbx.h"
#include "my_iopmp.h"
#include "drv_mbx_ch0.h"
#include "drv_mbx_ch1.h"
#include "drv_usart.h"

//#include"key.h"
//#include"led.h"
//#include "oled128_32.h"

extern void mdelay(uint32_t ms);
/*#define CH1_CTRL_ADDR   0x40100014
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

#define IOPMP_WRITE 0x40100024*/
extern usart_handle_t console_handle;
int main(void)
{
	console_handle = csi_usart_initialize(1, NULL);
    /* config the UART */
	int32_t ret = 0;
    ret = csi_usart_config(console_handle, 115200, USART_MODE_ASYNCHRONOUS, USART_PARITY_NONE, USART_STOP_BITS_1, USART_DATA_BITS_8);
    /**(volatile uint32_t *) CH1_CTRL_ADDR   = 0xE000C000;
    *(volatile uint32_t *) CH1_DATA_ADDR   = 0x0000EFDC;
    *(volatile uint32_t *) CH1_STATUS_ADDR = 0x00000003;*/
	//Simulation access IOPMP
	uint32_t mailbox_mode = 1;      //data mode
    uint32_t trans_length = 3;     //data
	iopmp_initialize(0);
    mbx_ch1_initialize(0);
    printf("Transfer Initial:\n");
    mbx_ch1_config(1, mailbox_mode, trans_length, 0, 0);
    int32_t data_test = 0xF0E01020;
    for(int k = 0; k < trans_length; k++){
        mbx_ch1_send(data_test);
        data_test = data_test + 1;
    }
    mbx_ch1_putintr();
/* 	//legal
	int timer1_value = *(volatile uint32_t *) TIMER1_VREG;
	//illegal
	int timer0_value = *(volatile uint32_t *) TIMER0_VREG;
    //read exception info */
	/*
    iopmp_exp_addr  = *(volatile uint32_t *) IOPMP_EXP;
    iopmp_exp_write = *(volatile uint32_t *) IOPMP_WRITE;*/


	
//    //int acisr            = 0;
//    int mailbox_ctrl     = 0;
//    int mailbox_data     = 0;
//    int mailbox_status   = 0;
//    //acisr = ;
///*     printf("Hi I'm REE\n");
//	    printf("Transfer initial"); */
//    while ( (*(volatile uint32_t *) ACISR_ADDR) != 0x2 ){
//    printf("Begin receiving.\n");
//    mailbox_ctrl   = *(volatile uint32_t *) CH0_CTRL_ADDR;
//    mailbox_data   = *(volatile uint32_t *) CH0_DATA_ADDR;
//    mailbox_status = *(volatile uint32_t *) CH0_STATUS_ADDR;
//    }
//	
//    //写入到一个没用的地方(S4)
//    *(volatile uint32_t *)0x2003f004 = mailbox_ctrl  ;
//    *(volatile uint32_t *)0x2003f008 = mailbox_data  ;
//    *(volatile uint32_t *)0x2003f00C = mailbox_status;
//
//    //清中断
//     *(volatile uint32_t *) CH1_CTRL_ADDR = CLEAR_INT_CMD;
//
//    while((*(volatile uint32_t *) ACISR_ADDR) != 0){
//    }
//    printf("Transfer Succeed!");
//    printf("Another transfer!");
//    *(volatile uint32_t *) CH1_CTRL_ADDR   = 0xE000C000;
//    *(volatile uint32_t *) CH1_DATA_ADDR   = 0x00000040;
//    *(volatile uint32_t *) CH1_STATUS_ADDR = 0x00000003;
//
///* //    key_gpio_intr(PA8);
//    LED_Init();
////    OLED_SHOW();
//	printf("Twinkle LED Start\n");
//    while(1)
//    {
//        LED_ON();
//        mdelay(500);
//        LED_OFF();
//        mdelay(500);
//    } */
    return 0;
}

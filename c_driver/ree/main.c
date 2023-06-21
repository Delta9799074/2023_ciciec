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

int main(void)
{
    //mbx_ch0_initialize(0);
    mbx_ch1_initialize(0);
    *(volatile uint32_t *) CH1_CTRL_ADDR   = 0xE000C000;
    *(volatile uint32_t *) CH1_DATA_ADDR   = 0x0000EFDC;
    *(volatile uint32_t *) CH1_STATUS_ADDR = 0x00000003;
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

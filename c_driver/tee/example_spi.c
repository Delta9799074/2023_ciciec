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
#include <stdint.h>
#include "drv_usart.h"
#include "soc.h"
#include <csi_config.h>
#include <csi_core.h>
#include "pin.h"
#include "drv_gpio.h"
#include "w25q64fv.h"
#include <string.h>
#include "drv_spi.h"
#include "drv_mbx_ch0.h"
#include "drv_mbx_ch1.h"
#include "my_mbx.h"

//2022/05/25
/* #define ACISR_ADDR 		0x40030004

#define CH1_CTRL_ADDR   0x40100014
#define CH1_DATA_ADDR   0x40100018
#define CH1_STATUS_ADDR 0x4010001C


#define CH0_CTRL_ADDR   0x40030008
#define CH0_DATA_ADDR   0x4003000C
#define CH0_STATUS_ADDR 0x40030010
#define CLEAR_INT_CMD 	0x00004000 */

extern usart_handle_t console_handle;
extern void ioreuse_initial(void);

extern int clock_timer_init(void);
extern int clock_timer_start(void);

/*************************** 引入flash驱动文件*******************************************/
#define OPERATE_ADDR    0x10000                       //flash start addr
// #define OPERATE_LEN     256
#define READ_LEN     256
#define REE_LEN   0x8000                       //reecode_size = 
#define SPIFLASH_BASE_VALUE 0x0

extern int32_t w25q64flash_read_id(spi_handle_t handle, uint32_t *id_num);
extern int32_t w25q64flash_read_data(spi_handle_t handle, uint32_t addr, void *data, uint32_t cnt);
static void spi_event_cb_fun(int32_t idx, spi_event_e event)
{
    //printf("\nspi_event_cb_fun:%d\n",event);
}

static int read_flash(int32_t idx)  //传入USI2
{
    uint8_t id[2] = {0x11, 0x11};

    int i;
    int32_t ret;
    spi_handle_t spi_handle_t;

/* SPI 初始化，地址，中断*/
    spi_handle_t = csi_spi_initialize(idx, spi_event_cb_fun);  

    if (spi_handle_t == NULL) {  
        printf(" csi_spi_initialize failed\n"); 
        return -1;
    }


/* SPI 设备配置，时钟，主从传输模式等*/  
    ret = csi_spi_config(spi_handle_t, W25Q64FV_CLK_RATE, SPI_MODE_MASTER,   
                         SPI_FORMAT_CPOL0_CPHA0, SPI_ORDER_MSB2LSB,  //选择0模式，时钟上升沿采集数据，下降沿发送数据；从高位开始发送
                         SPI_SS_MASTER_SW, 8);  //选择软件控制 

    if (ret != 0) {   //运行时函数返回值是-1，说明上面有个函数出错
        printf("%s(), %d spi config error, %d\n", __func__, __LINE__, ret);
        return -1;
    }


/* 读取 SPI 设备 ID 第一遍*/
    ret = w25q64flash_read_id(spi_handle_t, (uint32_t *)&id); //读取 id[2] 

    if (ret < 0) {
        printf("TEE: Read Flash ID failed\n");
        return -1;
    }

    printf("TEE : The Flash ID is %x %x\r\n", id[0], id[1]); //id[3]  id[4] 分别是 MID 还有 DID


/* 读取 SPI 设备 ID 第二遍*/
    ret = w25q64flash_read_id(spi_handle_t, (uint32_t *)&id); //读取 id[2] 

    if (ret < 0) {
        printf("TEE: Read Flash ID failed\n");
        return -1;
    }

    printf("TEE : The Flash ID is %x %x\r\n", id[0], id[1]); //id[3]  id[4] 分别是 MID 还有 DID


/* 读取flash中的coe文件，存放在0x10020000地址处，实现从flash中读取ree code文件，并加载进存放ree code的s2区域 */
    uint8_t *ram = (uint8_t *)0x10020000;     //按字节存储
    ret = w25q64flash_read_data(spi_handle_t, OPERATE_ADDR, ram, REE_LEN);  //从flash中读取数据放在ram中

    if (ret == -1) {
        printf("%s, %d ,flash read error\n", __func__, __LINE__);
    }

    printf("The first 10 bytes are:\n");

    // 从ram中读取前10个字节看看是否写入成功
    for (i = 0; i < 10; i++) {
        printf("%d\n",*ram);  
        ram++; //ram_addr+ 1byte*1
    }

    ret = csi_spi_uninitialize(spi_handle_t);  //关掉 flash 设备
    return 0;

}


int main(void)
{
// #define __NO_BOARD_INIT 1 in csi_config.h,   so startup.S will not execute board_init()


//    printf("Hello World!\n");
//	printf("HEllo!\n");

/*int mailbox_ctrl     = 0;
int mailbox_data     = 0;
int mailbox_status   = 0;
int acisr;*/
/*
    acisr = *(volatile uint32_t *) ACISR_ADDR;
while ( acisr == 0x1){
    printf("Begin receiving.\n");
    mailbox_ctrl   = *(volatile uint32_t *) CH1_CTRL_ADDR;
    mailbox_data   = *(volatile uint32_t *) CH1_DATA_ADDR;
    mailbox_status = *(volatile uint32_t *) CH1_STATUS_ADDR;
	if(mailbox_data == 0x00000040){
		*(volatile uint32_t *) 0x40020008 = 0x0000400;
	}
	else{
		
	}
}*/
//printf("Transfer Initial:\n");
/*
    *(volatile uint32_t *) CH0_CTRL_ADDR 	= 0xE000C000;
    *(volatile uint32_t *) CH0_DATA_ADDR 	= 0xA0000000;
    *(volatile uint32_t *) CH0_STATUS_ADDR 	= 0x00000003;
*/
//mdelay(500);
/*
acisr = *(volatile uint32_t *) 0x40020004;
if(acisr == 0){
    printf("Transfer Succeed!");
}
*/

    int32_t ret = 0;
    /* init the console*/

    console_handle = csi_usart_initialize(CONSOLE_IDX, NULL);
    /* config the UART */
    ret = csi_usart_config(console_handle, 115200, USART_MODE_ASYNCHRONOUS, USART_PARITY_NONE, USART_STOP_BITS_1, USART_DATA_BITS_8);

    if (ret < 0) {
        return -1;
    }
   
   /* 读取flash id 并搬运 REE 代码*/
/*     ret = read_flash(EXAMPLE_SPI_IDX);
    if (ret < 0) {
        printf("load ree code from flash failed\n");
        return -1;
    }
	
    printf("I'm TEE. Load REE Code from flash successfully\n");

	//启动REE CPU 工作
	printf("I'm TEE. Start REE Config!!!\n");
 */	
 
	uint32_t *ree_rst_b = (uint32_t *)0x30000000;     //按字节存储
	uint32_t *ree_rst_addr = (uint32_t *) 0x30000004;
	
	*ree_rst_addr = 0x10020000;
	*ree_rst_b = 0x1;
	
	printf("I'm TEE. I have configured REE. Finish!!!\n");
    csi_usart_uninitialize(console_handle);
    /* 在startup.s中pc跳转到对应位置，可实现bootrom运行后，从flash中搬移fsbl代码，之后TEE CPU跳转到fsbl代码区执行 fsbl中的代码 */
    
    printf("I'm TEE. Get into Low Power Mode.\n");

    mbx_ch0_initialize(0);

    printf("Transfer Initial:\n");
    *(volatile uint32_t *) CH0_CTRL_ADDR   = 0xE000C000;
    *(volatile uint32_t *) CH0_DATA_ADDR   = 0xABCD0000;
    *(volatile uint32_t *) CH0_STATUS_ADDR = 0x00000003;

/*     mdelay(10);
    int mailbox_ctrl     = 0;
    int mailbox_data     = 0;
    int mailbox_status   = 0;
    while ( (*(volatile uint32_t *) ACISR_ADDR) != 0x1 ){
    printf("Begin receiving.\n");
        mailbox_ctrl   = *(volatile uint32_t *) CH1_CTRL_ADDR;
        mailbox_data   = *(volatile uint32_t *) CH1_DATA_ADDR;
        mailbox_status = *(volatile uint32_t *) CH1_STATUS_ADDR;
    }
	
    //写入到一个没用的地方(S4)
    *(volatile uint32_t *)0x2003ff04 = mailbox_ctrl  ;
    *(volatile uint32_t *)0x2003ff08 = mailbox_data  ;
    *(volatile uint32_t *)0x2003ff0C = mailbox_status;

    *(volatile uint32_t *) CH0_CTRL_ADDR = CLEAR_INT_CMD; */
/*
    uint32_t crosscore_transfer_data = 0xEF0000EF;
    mailbox_handle_t my_mailbox_ch0;
    my_mailbox_ch0 = drv_mailbox_ch0_initialize(0);
    int32_t ch0_config_success;
    ch0_config_success = drv_mailbox_config_ch0(my_mailbox_ch0, 0x01, 0x01, 0x01);
    if(ch0_config_success == 0){
        printf("Mailbox Channel 0 Config Succeed!");
    }
    else{
        printf("Mailbox Channel 0 Config Error!");
    }
    int32_t ch0_send_data_success;
    ch0_send_data_success = drv_mailbox_wdata_ch0(my_mailbox_ch0, crosscore_transfer_data);
    if(ch0_send_data_success == 0){
        printf("Mailbox Channel 0 Send Data Succeed!");
    }
    else{
        printf("Mailbox Channel 0 Send Data Error!");
    }
    int32_t ch0_send_intr_success;
    ch0_send_intr_success = drv_mailbox_crosscore_notify_ch0(my_mailbox_ch0);
    if(ch0_send_intr_success == 0){
        printf("Mailbox Channel 0 Send Interrupt Succeed!");
    }
    else{
        printf("Mailbox Channel 0 Send Interrupt Error!");
    }
*/
/* int int_mailbox_flag = 0;
    int_mailbox_flag = *(volatile uint32_t *) 0x40020004;
int mailbox_ctrl     = 0;
int mailbox_data     = 0;
int mailbox_status   = 0;
int acisr            = 0; */
/*while ( int_mailbox_flag == 0x1){
    printf("Begin receiving.\n");
    mailbox_ctrl   = *(volatile uint32_t *) CH1_CTRL_ADDR;
    mailbox_data   = *(volatile uint32_t *) CH1_DATA_ADDR;
    mailbox_status = *(volatile uint32_t *) CH1_STATUS_ADDR;
}

if(mailbox_ctrl == 0xE000C000){
    if(mailbox_data == 0x00000040){
        *(volatile uint32_t *) 0x40020008 = 0x0000400;
    }
}*/

//mdelay(500);
/* printf("Transfer Initial:\n");
    *(volatile uint32_t *) CH0_CTRL_ADDR = 0xE000C000;
    *(volatile uint32_t *) CH0_DATA_ADDR = 0xA0000000;
    *(volatile uint32_t *) CH0_CTRL_ADDR = 0x00000001;

//mdelay(500);
acisr = *(volatile uint32_t *) 0x40020004;
if(acisr == 0){
    printf("Transfer Succeed!");
} */    
    return 0;
}
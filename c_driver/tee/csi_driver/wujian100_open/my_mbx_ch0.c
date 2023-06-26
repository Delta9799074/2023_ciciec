#include <csi_config.h>
#include <stdbool.h>
#include <stdio.h>
#include <drv_irq.h>
#include <drv_pmu.h>
#include <my_mbx.h>
#include <csi_core.h>
#include <soc.h>

#define MBX_MODE_MASK 0x60000000
/*static void mbx_ch0_irq_clear()
{
    *(volatile uint32_t *) CH0_CTRL_ADDR = CLEAR_INT_CMD;

}*/
extern int32_t target_get_mbx_ch0_count(void);
extern int32_t target_get_mbx_ch0(int32_t idx, uint32_t *base, uint32_t *irq, void **handler);

void mbx_ch0_irqhandler(int idx)
{

    printf("Begin receiving.\n");
    int mailbox_ctrl   = *(volatile uint32_t *) CH1_CTRL_ADDR;
    int mailbox_data   = *(volatile uint32_t *) CH1_DATA_ADDR;
    int mailbox_status = *(volatile uint32_t *) CH1_STATUS_ADDR;

    int command_data;
    int mailbox_mode = mailbox_ctrl & MBX_MODE_MASK;
    mailbox_mode = mailbox_mode >> 29 ;
    *(volatile uint32_t *) CH0_CTRL_ADDR = CLEAR_INT_CMD;
    if(mailbox_mode == 0x1){ //data mode
        //写入到一个没用的地方(S4)
        *(volatile uint32_t *)0x2003f004     = mailbox_ctrl  ;
        *(volatile uint32_t *)0x2003f008     = mailbox_data  ;
        *(volatile uint32_t *)0x2003f00C     = mailbox_status;
    }
    else if(mailbox_mode == 0x2){ //address mode
    //数据用mailbox传回
        command_data = *(volatile uint32_t *) mailbox_data;
        *(volatile uint32_t *) CH0_CTRL_ADDR   = 0xA0008000;
        *(volatile uint32_t *) CH0_DATA_ADDR   = command_data;
        *(volatile uint32_t *) CH0_STATUS_ADDR = 0x3;
    }
    else if(mailbox_mode == 0x3){ //command mode
        *(volatile uint32_t *)0x2003f014     = mailbox_ctrl  ;
        *(volatile uint32_t *)0x2003f018     = mailbox_data  ;
        *(volatile uint32_t *)0x2003f01C     = mailbox_status;
    }
}

void mbx_ch0_initialize(int32_t idx)
{
    if (idx < 0 || idx >= CONFIG_MBX_CH0_NUM) {
        return NULL;
    }

    uint32_t base = 0u;
    uint32_t irq = 0u;
    void *handler;

    int32_t real_idx = target_get_mbx_ch0(idx, &base, &irq, &handler);

    if (real_idx != idx) {
        return NULL;
    }
/*     gpio_priv = &gpio_handle[idx];

    gpio_priv->base = base;
    gpio_priv->irq  = irq;
    gpio_priv->pin_num  = pin_num; */


    drv_irq_register(irq, handler);
    drv_irq_enable(irq);

    return;
}
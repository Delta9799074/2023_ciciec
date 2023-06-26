#include <csi_config.h>
#include <stdbool.h>
#include <stdio.h>
#include <drv_irq.h>
#include <drv_pmu.h>
#include <my_mbx.h>
#include <csi_core.h>
#include <soc.h>


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
    //写入到一个没用的地方(S4)
    *(volatile uint32_t *)0x2003f004     = mailbox_ctrl  ;
    *(volatile uint32_t *)0x2003f008     = mailbox_data  ;
    *(volatile uint32_t *)0x2003f00C     = mailbox_status;
    *(volatile uint32_t *) CH0_CTRL_ADDR = CLEAR_INT_CMD;

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
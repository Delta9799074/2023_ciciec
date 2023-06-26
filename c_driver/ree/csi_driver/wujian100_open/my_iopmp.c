#include <csi_config.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <drv_irq.h>
#include <drv_pmu.h>
#include <my_iopmp.h>
#include <my_mbx.h>
#include <csi_core.h>
#include <soc.h>

extern int32_t target_get_mbx_ch0_count(void);
extern int32_t target_get_mbx_ch0(int32_t idx, uint32_t *base, uint32_t *irq, void **handler);
#define IOPMP_READ_DATA_CTRL  0xC0008000
#define IOPMP_WRITE_DATA_CTRL 0xC000A000

void iopmp_irqhandler(int idx)
{
    int iopmp_exp_addr = *(volatile uint32_t *) IOPMP_EXP_ADDR;
    int iopmp_exp_type = *(volatile uint32_t *) IOPMP_WRITE_ADDR;
    /* char addr_string[8] = {0};
    //turn to hex
    itoa(iopmp_exp_addr, addr_string, 16);
    if(iopmp_exp_type == 1){
        printf("No write permission to access 0x%s!.\n", addr_string);
    }
    else if(iopmp_exp_type == 0){
        printf("No read permission to access 0x%s!.\n", addr_string);
    }
    else {
        printf("Error!");
    } */

    if(iopmp_exp_type == 0x0){ //read
        *(volatile uint32_t *) CH1_CTRL_ADDR    =  IOPMP_READ_DATA_CTRL;
        *(volatile uint32_t *) CH1_DATA_ADDR    =  iopmp_exp_addr;
        *(volatile uint32_t *) CH1_STATUS_ADDR  =  0x3;
    }
    //不可以给写权限
    /*else if(iopmp_exp_type == 0x1){ //write
        *(volatile uint32_t *) CH1_CTRL_ADDR    =  IOPMP_WRITE_DATA_CTRL;
        *(volatile uint32_t *) CH1_DATA_ADDR    =  iopmp_exp_addr;
        *(volatile uint32_t *) CH1_STATUS_ADDR  =  0x3;
    }*/
    else {
        //else里应该做一些没权限的处理，但是也不知道怎么处理，先空着吧
    }
}
//开45号中断
void iopmp_initialize(int32_t idx)
{
    if (idx < 0 || idx >= CONFIG_IOPMP_NUM) {
        return NULL;
    }

    uint32_t base = 0u;
    uint32_t irq = 0u;
    void *handler;

    int32_t real_idx = target_get_iopmp(idx, &base, &irq, &handler);

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
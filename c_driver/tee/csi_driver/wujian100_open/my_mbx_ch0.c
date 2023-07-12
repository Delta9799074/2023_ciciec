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
    uint32_t mailbox_ctrl   = *(volatile uint32_t *) CH1_CTRL_ADDR;
    uint32_t mailbox_mode = (mailbox_ctrl & MBX_MODE_MASK);
    mailbox_mode = (mailbox_ctrl & MBX_MODE_MASK) >> 29;
    if(mailbox_mode == 1){
        printf("Mailbox at DATA mode.\n");
    }
    else if(mailbox_mode == 2){
        printf("Mailbox at ADDRESS mode.\n");
    }
    else if(mailbox_mode == 3){
        printf("Mailbox at COMMAND mode.\n");
    }
    else{
        printf("Mailbox ERROR!\n");
    }
    uint32_t mailbox_trans_len = (mailbox_ctrl & MBX_LEN_MASK) >> 15;
    printf("Receving %d data.\n", mailbox_trans_len);
    uint32_t slave_addr = 0x2003ff08;
    for(int j = 0; j < mailbox_trans_len; j++){
        printf("%d:\n", j);
        int mailbox_data   = *(volatile uint32_t *) CH1_DATA_ADDR;
        *(volatile uint32_t *)slave_addr = mailbox_data;
        printf("Received %x, Write to %x\n", mailbox_data, slave_addr);
        slave_addr+=4;
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

void mbx_ch0_config(uint32_t mailbox_intr_en, uint32_t mailbox_mode, uint32_t trans_length, uint32_t mailbox_read_ok, uint32_t mailbox_addrmode_wr){
    uint32_t ctrl_reg;
    uint32_t mailbox_intr_en_temp               = mailbox_intr_en;
    uint32_t mailbox_mode_temp                  = mailbox_mode;
    uint32_t trans_length_temp                  = trans_length;
    uint32_t mailbox_read_ok_temp               = mailbox_read_ok;
    uint32_t mailbox_addrmode_wr_temp           = mailbox_addrmode_wr;
             mailbox_intr_en_temp               = (mailbox_intr_en_temp << 31) & MBX_INT_MASK;
             mailbox_mode_temp                  = (mailbox_mode_temp << 29) & MBX_MODE_MASK;
             trans_length_temp                  = (trans_length_temp << 15) & MBX_LEN_MASK;
             mailbox_read_ok_temp               = (mailbox_read_ok_temp << 14) & MBX_OTHER_MASK;
             mailbox_addrmode_wr_temp           = (mailbox_addrmode_wr_temp << 13) & MBX_OTHER_MASK;
             ctrl_reg                           = mailbox_intr_en_temp | mailbox_mode_temp | trans_length_temp | mailbox_read_ok_temp | mailbox_read_ok_temp | mailbox_addrmode_wr_temp;

    
    *(volatile uint32_t *) CH0_CTRL_ADDR = ctrl_reg;
    printf("Success config mailbox.\n");
}

void mbx_ch0_send(int32_t trans_data){
    *(volatile uint32_t *) CH0_DATA_ADDR = trans_data;
    printf("Success send %x.\n", trans_data);
}

void mbx_ch0_putintr(void){
    *(volatile uint32_t *) CH0_STATUS_ADDR = 0x00000003;
    printf("Send Interrupt to REE.\n");
}
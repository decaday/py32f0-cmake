/**
  ******************************************************************************
  * @file    py32f0xx_it.h
  * @author  MCU Application Team
  * @brief   This file contains the headers of the interrupt handlers.
  ******************************************************************************
  */

#ifndef __PY32F0XX_IT_H
#define __PY32F0XX_IT_H

#ifdef __cplusplus
 extern "C" {
#endif 

void NMI_Handler(void);
void HardFault_Handler(void);
void SVC_Handler(void);
void PendSV_Handler(void);
void SysTick_Handler(void);

#ifdef __cplusplus
}
#endif

#endif /* __PY32F0XX_IT_H */

/************************ (C) COPYRIGHT Puya *****END OF FILE******************/

//+------------------------------------------------------------------+
//|                                                   Oraculo_EA.mq5 |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

//input bool showDash = false;

#include "./entities/OrderTypeEntity.mq5";
#include "./entities/VolumeForceEntity.mq5";
//#include "./dashboard/Dashboard.mq5";

input bool showDash = false;


int     hForceToOpen;
double  valForceToOpen[];
double  forceIndexToOpen = 0;
int     forcePeriodToOpen=40;

int     hForceToClose;
double  valForceToClose[];
double  forceIndexToClose = 0;
int     forcePeriodToClose=20;



int     hForceToMedium;
double  valForceToMedium[];
double  forceIndexToMedium = 0;
int     forcePeriodToMedium=120;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Print("Oraculo EA, Olá mundo!");
   Print("Sirva um café e mantenha a calma!");

   hForceToOpen = iForce(_Symbol, PERIOD_CURRENT, forcePeriodToOpen, MODE_SMA,VOLUME_TICK);
   hForceToClose = iForce(_Symbol, PERIOD_CURRENT, forcePeriodToClose, MODE_LWMA,VOLUME_TICK);
   hForceToMedium = iForce(_Symbol, PERIOD_M1, forcePeriodToMedium, MODE_SMMA,VOLUME_TICK);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
   VolumeForceEntity volumeForceEntity;
   OrderTypeEntity orderTypeEntity;
   OrderEntity orderEntity;   
   
   ZeroMemory(volumeForceEntity);
   ZeroMemory(valForceToMedium);
   ZeroMemory(orderTypeEntity);
   ZeroMemory(orderEntity);
   
   volumeForceEntity.init();
    
   ArrayResize(volumeForceEntity.iForceIndexToOpen, 3);
   ArrayResize(volumeForceEntity.iForceIndexToClose, 3);
   
   ArraySetAsSeries(volumeForceEntity.iForceIndexToOpen, true);
   CopyBuffer(hForceToOpen,0,0,3,volumeForceEntity.iForceIndexToOpen);
   
   ArraySetAsSeries(volumeForceEntity.iForceIndexToClose, true);
   CopyBuffer(hForceToClose,0,0,3,volumeForceEntity.iForceIndexToClose);
   
   ArraySetAsSeries(valForceToMedium, true);
   CopyBuffer(hForceToMedium,0,0,3,valForceToMedium);  
   
   
   
   orderTypeEntity.init(volumeForceEntity);
   orderEntity.init(volumeForceEntity, orderTypeEntity);


  }
//+------------------------------------------------------------------+

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
int     forcePeriodToOpen=60;

int     hForceToClose;
double  valForceToClose[];
double  forceIndexToClose = 0;
int     forcePeriodToClose=20;


int     hRSI;
double  valRSI[];
double  rsiIndex = 0;
int     rsiPeriod=14;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Print("Oraculo EA, Olá mundo!");
   Print("Sirva um café e mantenha a calma!");

   hRSI = iRSI(_Symbol,PERIOD_CURRENT,rsiPeriod,PRICE_CLOSE);
   hForceToOpen = iForce(_Symbol, PERIOD_CURRENT, forcePeriodToOpen, MODE_SMMA,VOLUME_TICK);
   hForceToClose = iForce(_Symbol, PERIOD_CURRENT, forcePeriodToClose, MODE_SMMA,VOLUME_TICK);


   if(showDash)
     {
      DashInit();
     }

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
   ZeroMemory(volumeForceEntity);
   volumeForceEntity.init();
    
   ArrayResize(volumeForceEntity.iForceIndexToOpen, 3);
   ArrayResize(volumeForceEntity.iForceIndexToClose, 3);
   ArrayResize(volumeForceEntity.IRSI, 3);
  
   ZeroMemory(volumeForceEntity.iForceIndexToOpen);
   ArraySetAsSeries(volumeForceEntity.iForceIndexToOpen, true);
   CopyBuffer(hForceToOpen,0,0,3,volumeForceEntity.iForceIndexToOpen);
   
   ZeroMemory(volumeForceEntity.iForceIndexToClose);
   ArraySetAsSeries(volumeForceEntity.iForceIndexToClose, true);
   CopyBuffer(hForceToClose,0,0,3,volumeForceEntity.iForceIndexToClose);
   
   CopyBuffer(hRSI,0,0,3,volumeForceEntity.IRSI);
   Print("volumeForceEntity.iForceIndexToOpen: " + volumeForceEntity.iForceIndexToOpen[0]);
   
   OrderTypeEntity orderTypeEntity;
   ZeroMemory(orderTypeEntity);
   orderTypeEntity.init(volumeForceEntity);
   
   
   OrderEntity orderEntity;
   ZeroMemory(orderEntity);
   orderEntity.init(volumeForceEntity, orderTypeEntity);


  }
//+------------------------------------------------------------------+

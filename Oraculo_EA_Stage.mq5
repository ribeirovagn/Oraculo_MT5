//+------------------------------------------------------------------+
//|                                                   Oraculo_EA.mq5 |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+


#include "./entities/OrderTypeEntity.mq5";
#include "./entities/VolumeForceEntity.mq5";
#include "./dashboard/Dashboard.mq5";

input bool showDash = true;


int     hForceToOpen;
double  valForceToOpen[];
double  forceIndexToOpen = 0;
int     forcePeriodToOpen=40;

int     hForceToClose;
double  valForceToClose[];
double  forceIndexToClose = 0;
int     forcePeriodToClose=12;

int     hForceToMedium;
double  valForceToMedium[];
double  forceIndexToMedium = 0;
int     forcePeriodToMedium=120;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
//---
   Print("Oraculo EA, Olá mundo!");
   Print("Sirva um café e mantenha a calma!");
   SendNotification("Oraculo EA, Olá mundo! " + _Symbol);
   hForceToOpen = iForce(_Symbol, PERIOD_CURRENT, forcePeriodToOpen, MODE_SMA,VOLUME_TICK);
   hForceToClose = iForce(_Symbol, PERIOD_CURRENT, forcePeriodToClose, MODE_LWMA,VOLUME_TICK);
   hForceToMedium = iForce(_Symbol, PERIOD_M1, forcePeriodToMedium, MODE_SMMA,VOLUME_TICK);
   if(showDash) {
          DashInit();
   }
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   if(showDash) {
        DashDeinit(reason);
   }
//---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   VolumeForceEntity volumeForceEntity;
   OrderTypeEntity orderTypeEntity;
   OrderEntity orderEntity;
   MqlRates          rates[1];
   CopyRates(_Symbol, PERIOD_H1, 0, 1, rates);
   double sum = rates[0].high - rates[0].low;
   if(sum > 1.5) {
      volumeForceEntity.init();
      ArrayResize(volumeForceEntity.iForceIndexToOpen, 3);
      ArrayResize(volumeForceEntity.iForceIndexToClose, 3);
      ArraySetAsSeries(volumeForceEntity.iForceIndexToOpen, true);
      CopyBuffer(hForceToOpen,0,0,3,volumeForceEntity.iForceIndexToOpen);
      ArraySetAsSeries(volumeForceEntity.iForceIndexToClose, true);
      CopyBuffer(hForceToClose,0,0,3,volumeForceEntity.iForceIndexToClose);
      ArraySetAsSeries(volumeForceEntity.iForceIndexToMedium, true);
      CopyBuffer(hForceToMedium,0,0,3,valForceToMedium);
      orderTypeEntity.init(volumeForceEntity);
      orderEntity.init(volumeForceEntity, orderTypeEntity);
      //Print("volumeForceEntity.iForceIndexToOpen[0] " + volumeForceEntity.iForceIndexToOpen[0]);
      //Print("volumeForceEntity.iForceIndexToClose[0] " + volumeForceEntity.iForceIndexToClose[0]);
   }
   if(showDash) {
      DashCalculate(volumeForceEntity);
   }
}
//+------------------------------------------------------------------+

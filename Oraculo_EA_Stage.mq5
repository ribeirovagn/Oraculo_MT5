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
#include "./dashboard/Painel.mq5";
#include "./utils/Points.mq5";

#include <Trade\Trade.mqh>;
CTrade trade;

bool isStopedLoss = false;

int hForceToOpen;
double valForceToOpen[];
double forceIndexToOpen = 0;

int hForceToClose;
double valForceToClose[];
double forceIndexToClose = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
//---
   int periodIForceOpen = 0;
   int periodIForceClose = 0;
   Print("Oraculo EA, Olá mundo!");
   Print("Sirva um café e mantenha a calma!");
   if(_Period == 1) {
      periodIForceOpen = 30;
      periodIForceClose = 13;
   }
   if(_Period >= 2) {
      periodIForceOpen = 45;
      periodIForceClose = 10;
   }
   hForceToOpen = iForce(_Symbol, PERIOD_CURRENT, periodIForceOpen, MODE_LWMA, VOLUME_TICK);
   hForceToClose = iForce(_Symbol, PERIOD_CURRENT, periodIForceClose, MODE_SMA, VOLUME_TICK);
   
   trade.SetExpertMagicNumber(603217);
   //SendNotification("Oraculo EA in action at " + _Symbol + " M" + _Period);

//---
   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

   VolumeForceEntity volumeForceEntity;
   OrderTypeEntity orderTypeEntity;
   OrderEntity orderEntity;
   volumeForceEntity.init();
   ArrayResize(volumeForceEntity.iForceIndexToOpen, 3);
   ArrayResize(volumeForceEntity.iForceIndexToClose, 3);
   ArraySetAsSeries(volumeForceEntity.iForceIndexToOpen, true);
   CopyBuffer(hForceToOpen, 0, 0, 3, volumeForceEntity.iForceIndexToOpen);
   ArraySetAsSeries(volumeForceEntity.iForceIndexToClose, true);
   CopyBuffer(hForceToClose, 0, 0, 3, volumeForceEntity.iForceIndexToClose);
   orderTypeEntity.init(volumeForceEntity);
   orderEntity.init(volumeForceEntity, orderTypeEntity);
   if(!MQLInfoInteger(MQL_TESTER)) {
      Print("-----------------------------------------------------------");
   }

}
//+------------------------------------------------------------------+

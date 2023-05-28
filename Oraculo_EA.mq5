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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Print("Oraculo EA, Olá mundo!");
   VolumeForceEntity volumeForceEntity;
   volumeForceEntity.init();

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
   volumeForceEntity.init();

   OrderTypeEntity orderTypeEntity;
   orderTypeEntity.init(volumeForceEntity);

   OrderEntity orderEntity;
   orderEntity.init(volumeForceEntity, orderTypeEntity);

  }
//+------------------------------------------------------------------+

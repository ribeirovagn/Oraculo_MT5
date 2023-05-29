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
#include "./dashboard/Dashboard.mq5";

input bool showDash = false;


int     hFORCE;
double  valFORCE[];
double  forceIndex = 0;
int     forcePeriod=14;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Print("Oraculo EA, Olá mundo!");
   Print("Sirva um café e mantenha a calma!");

   hFORCE=iForce(_Symbol, _Period, forcePeriod, MODE_SMMA,VOLUME_TICK);
   if(hFORCE==INVALID_HANDLE)
      return(INIT_FAILED);

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
   if(showDash)
     {
      DashDeinit(reason);
     }
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

   ZeroMemory(valFORCE);
   if(CopyBuffer(hFORCE,0,0,1,valFORCE)>0)
     {
      volumeForceEntity.iForceIndex=valFORCE[0];
     }

   if(showDash)
     {
      DashCalculate(volumeForceEntity);
     }

  }
//+------------------------------------------------------------------+

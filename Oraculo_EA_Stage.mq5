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


int     hForceToOpen;
double  valForceToOpen[];
double  forceIndexToOpen = 0;
int     forcePeriodToOpen=40;

int     hForceToClose;
double  valForceToClose[];
double  forceIndexToClose = 0;
int     forcePeriodToClose=12;



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
//---
   Print("Oraculo EA, Olá mundo!");
   Print("Sirva um café e mantenha a calma!");
//SendNotification("Oraculo EA, Olá mundo! " + _Symbol);
   hForceToOpen = iForce(_Symbol, PERIOD_CURRENT, forcePeriodToOpen, MODE_LWMA,VOLUME_TICK);
   hForceToClose = iForce(_Symbol, PERIOD_CURRENT, forcePeriodToClose, MODE_SMA,VOLUME_TICK);
   //PlaySound("./Sounds/changeTimeframe.wav");
//---
   return(INIT_SUCCEEDED);
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
   int qntCandles = 30;
   double sum = 0;
   MqlRates tf[];
   double  max  = 0;
   double  min  = 0;
   
   double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   CopyRates(_Symbol, PERIOD_M3, 0, qntCandles, tf);
   for(int i=0; i<qntCandles; i++) {
      sum += tf[i].close;
      if(tf[i].close > max) {
         max = tf[i].close;
      }
      if(tf[i].close < min) {
         min = tf[i].close;
      }
   }
   sum = sum / qntCandles;
   int points = Points::pipsToPoints(MathAbs(sum - currentPrice));
   if(points > 0) {
      //ChartSetSymbolPeriod(0,NULL,PERIOD_M1);
   }
   if(points < 300 && points >= 200) {
     // ChartSetSymbolPeriod(0,NULL,PERIOD_M2);
   }
   if(points >= 3) {
     // ChartSetSymbolPeriod(0,NULL,PERIOD_M3);
   }
  // Print(_Symbol + " - M" + _Period);
   //Print("Points ", points);
   if(points >= 0) {
      VolumeForceEntity volumeForceEntity;
      OrderTypeEntity orderTypeEntity;
      OrderEntity orderEntity;
      volumeForceEntity.init();
      ArrayResize(volumeForceEntity.iForceIndexToOpen, 3);
      ArrayResize(volumeForceEntity.iForceIndexToClose, 3);
      ArraySetAsSeries(volumeForceEntity.iForceIndexToOpen, true);
      CopyBuffer(hForceToOpen,0,0,3,volumeForceEntity.iForceIndexToOpen);
      ArraySetAsSeries(volumeForceEntity.iForceIndexToClose, true);
      CopyBuffer(hForceToClose,0,0,3,volumeForceEntity.iForceIndexToClose);
      ArraySetAsSeries(volumeForceEntity.iForceIndexToMedium, true);
      
      for(int i=0;i<ArraySize(volumeForceEntity.iForceIndexToOpen);i++)
        {
           // volumeForceEntity.iForceIndexToOpen[i] = Points::pipsToPoints(volumeForceEntity.iForceIndexToOpen[i]);
            volumeForceEntity.iForceIndexToClose[i] = Points::pipsToPoints(volumeForceEntity.iForceIndexToClose[i]);
        }
      
      orderTypeEntity.init(volumeForceEntity);
      orderEntity.init(volumeForceEntity, orderTypeEntity);
   }
  Print("-----------------------------------------------------------");
}
//+------------------------------------------------------------------+

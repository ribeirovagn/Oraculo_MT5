//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
#include "./VolumeForceEntity.mq5";

double effortPercentualVol1 = 60.0;
double effortPercentualVol2 = 53.0;
double effortPercentualVol3 = 52.0;
double effortPercentualVol4 = 51.5;

double resultPercentualVol1 = 53.0;
double resultPercentualVol2 = 53.0;
double resultPercentualVol3 = 52.0;
double resultPercentualVol4 = 51.0;
int spread = 1800;
double hurstMin = 0.62;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderTypeEntity {

public:

   int               orderType;

   void              init(VolumeForceEntity &volumeforce) {
      this.orderType = ORDER_TYPE_BUY_STOP_LIMIT;
      MqlRates lastCandle[];
      CopyRates(_Symbol, _Period, 0, 1, lastCandle);
      ArraySetAsSeries(lastCandle, true);
      double meanToOrder = 0.50;
      
      Print(_Symbol + " - M" + _Period);
      Print("-----------------------------------------------------------");
      if(lastCandle[0].close > lastCandle[0].open) {
         Print("BUY CONDITION");
         Print("Spread: " + (string)volumeforce.effortResult1.spread);
         Print("Result: " + (string)volumeforce.effortResult1.result);
         Print("iForceIndexToOpen[0]" + NormalizeDouble(volumeforce.iForceIndexToOpen[0], 4));
         Print("iForceIndexToOpen[1] > 5" + NormalizeDouble(volumeforce.iForceIndexToOpen[1], 4) + " : " + (volumeforce.iForceIndexToOpen[1] > 5));
         Print("iForceIndexToClose[0] > iForceIndexToClose[1]: " + (volumeforce.iForceIndexToClose[0] > volumeforce.iForceIndexToClose[1]));
         Print("iForceIndexToClose[0] " + NormalizeDouble(volumeforce.iForceIndexToClose[0], 4));
         Print("iForceIndexToClose[1] " + NormalizeDouble(volumeforce.iForceIndexToClose[1], 4));
         Print("iForceIndexToClose[2] " + NormalizeDouble(volumeforce.iForceIndexToClose[2], 4));
         Print("Buy  Percentual " + (string)volumeforce.effortResult1.effortBuyPercentual);
         Print("volumeforce.mean " + (string)NormalizeDouble(volumeforce.mean, 2));
         Print("volumeforce.mean to buy: " + NormalizeDouble((volumeforce.mean + meanToOrder), 4) + " " + (string)((volumeforce.mean + meanToOrder) < lastCandle[0].close));
         Print("Last price: " + (string)lastCandle[0].close);
         
      }
      if(lastCandle[0].open > lastCandle[0].close) {
         Print("SELL CONDITION");
         Print("Spread: " + (string)volumeforce.effortResult1.spread);
         Print("Result: " + (string)volumeforce.effortResult1.result);
         Print("iForceIndexToOpen[0]" + NormalizeDouble(volumeforce.iForceIndexToOpen[0], 4));
         Print("iForceIndexToOpen[1] " + NormalizeDouble(volumeforce.iForceIndexToOpen[1], 4) + " : " + (volumeforce.iForceIndexToOpen[1] < -5));
         Print("iForceIndexToClose[0] < iForceIndexToClose[1]: " + (volumeforce.iForceIndexToClose[0] < volumeforce.iForceIndexToClose[1]));
         Print("iForceIndexToClose[0] " + NormalizeDouble(volumeforce.iForceIndexToClose[0], 4));
         Print("iForceIndexToClose[1] " + NormalizeDouble(volumeforce.iForceIndexToClose[1], 4));
         Print("iForceIndexToClose[2] " + NormalizeDouble(volumeforce.iForceIndexToClose[2], 4));
         Print("Sell  Percentual " + (string)volumeforce.effortResult1.effortSellPercentual);
         Print("volumeforce.mean " + (string)NormalizeDouble(volumeforce.mean, 2));
         Print("volumeforce.mean to Sell: " + NormalizeDouble((volumeforce.mean - meanToOrder), 4) + " " + (string)((volumeforce.mean - meanToOrder) > lastCandle[0].close));
         Print("Last price: " + (string)lastCandle[0].close);         
      }
      
      Print("-----------------------------------------------------------");
      if(
         lastCandle[0].close > lastCandle[0].open
         && volumeforce.effortResult1.effortBuyPercentual >= effortPercentualVol1
         && volumeforce.effortResult1.spread < volumeforce.effortResult1.result
         && volumeforce.iForceIndexToOpen[1] > 5
         && volumeforce.iForceIndexToClose[0] > 0
         && volumeforce.iForceIndexToClose[0] > volumeforce.iForceIndexToClose[1]
         && (volumeforce.mean + meanToOrder) < lastCandle[0].close
      ) {
         this.orderType = ORDER_TYPE_BUY;
      } else if(
         lastCandle[0].open > lastCandle[0].close
         && volumeforce.effortResult1.effortSellPercentual >= effortPercentualVol1
         && volumeforce.effortResult1.spread < volumeforce.effortResult1.result
         && volumeforce.iForceIndexToClose[0] < 0
         && volumeforce.iForceIndexToOpen[1] < -5
         && volumeforce.iForceIndexToClose[0] < volumeforce.iForceIndexToClose[1]
         && (volumeforce.mean - meanToOrder) > lastCandle[0].close
      ) {
         this.orderType = ORDER_TYPE_SELL;
      }
   }
}
//+------------------------------------------------------------------+

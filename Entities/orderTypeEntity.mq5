//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
#include "./VolumeForceEntity.mq5";
#include "../utils/Points.mq5";

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
      int _digits = SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
      if(!MQLInfoInteger(MQL_TESTER)) {
         if(volumeforce.vol1[ArraySize(volumeforce.vol1) - 1].Close >= volumeforce.vol1[ArraySize(volumeforce.vol1) - 1].Open) {
            Print("BUY CONDITION - " + _Symbol + "/M" + _Period);
            Print("Spread: " + (string)volumeforce.effortResult1.spread + " > " + (string)volumeforce.effortResult1.result + " = " + (volumeforce.effortResult1.spread < volumeforce.effortResult1.result));
            Print("iForceIndexToOpen[0] " + NormalizeDouble(volumeforce.iForceIndexToOpen[0], 4));
            Print("iForceIndexToOpen[1] " + NormalizeDouble(volumeforce.iForceIndexToOpen[1], 4) + " : " + (volumeforce.iForceIndexToOpen[1] > 0));
            Print("iForceIndexToClose[0] > iForceIndexToClose[1]: " + (volumeforce.iForceIndexToClose[0] > volumeforce.iForceIndexToClose[1]));
            Print("iForceIndexToClose[0] " + NormalizeDouble(volumeforce.iForceIndexToClose[0], 4));
            Print("iForceIndexToClose[1] " + NormalizeDouble(volumeforce.iForceIndexToClose[1], 4));
            Print("Buy  Percentual " + (string)volumeforce.effortResult1.effortBuyPercentual + " = " + (volumeforce.effortResult1.effortBuyPercentual >= effortPercentualVol1));
            Print("volumeforce.mean " + (string)NormalizeDouble(volumeforce.mean, _digits));
            Print("Last price: " + (string)volumeforce.vol1[ArraySize(volumeforce.vol1) - 1].Close);
         }
         if(volumeforce.vol1[ArraySize(volumeforce.vol1) - 1].Open > volumeforce.vol1[ArraySize(volumeforce.vol1) - 1].Close) {
            Print("SELL CONDITION - " + _Symbol + "/M" + _Period);
            Print("Spread: " + (string)volumeforce.effortResult1.spread + " > " + (string)volumeforce.effortResult1.result + " = " + (volumeforce.effortResult1.spread < volumeforce.effortResult1.result));
            Print("iForceIndexToOpen[0] " + NormalizeDouble(volumeforce.iForceIndexToOpen[0], 4));
            Print("iForceIndexToOpen[1] " + NormalizeDouble(volumeforce.iForceIndexToOpen[1], 4) + " : " + (volumeforce.iForceIndexToOpen[1] < 0));
            Print("iForceIndexToClose[0] < iForceIndexToClose[1]: " + (volumeforce.iForceIndexToClose[0] < volumeforce.iForceIndexToClose[1]));
            Print("iForceIndexToClose[0] " + NormalizeDouble(volumeforce.iForceIndexToClose[0], 4));
            Print("iForceIndexToClose[1] " + NormalizeDouble(volumeforce.iForceIndexToClose[1], 4));
            Print("Sell  Percentual " + (string)volumeforce.effortResult1.effortSellPercentual + " = " + (volumeforce.effortResult1.effortSellPercentual >= effortPercentualVol1));
            Print("volumeforce.mean " + (string)NormalizeDouble(volumeforce.mean, _digits));
            Print("Last price: " + (string)volumeforce.vol1[ArraySize(volumeforce.vol1) - 1].Close);
         }
      }
      if(
         volumeforce.vol1[ArraySize(volumeforce.vol1) - 1].Close > volumeforce.vol1[ArraySize(volumeforce.vol1) - 1].Open
         && volumeforce.effortResult1.effortBuyPercentual >= effortPercentualVol1
         && volumeforce.effortResult1.spread < volumeforce.effortResult1.result
         && volumeforce.iForceIndexToOpen[1] > 0
         && volumeforce.iForceIndexToClose[0] > 0
         && volumeforce.iForceIndexToClose[0] > volumeforce.iForceIndexToClose[1]
      ) {
         this.orderType = ORDER_TYPE_BUY;
      } else if(
         volumeforce.vol1[ArraySize(volumeforce.vol1) - 1].Open > volumeforce.vol1[ArraySize(volumeforce.vol1) - 1].Close
         && volumeforce.effortResult1.effortSellPercentual >= effortPercentualVol1
         && volumeforce.effortResult1.spread < volumeforce.effortResult1.result
         && volumeforce.iForceIndexToOpen[1] < 0
         && volumeforce.iForceIndexToClose[0] < 0
         && volumeforce.iForceIndexToClose[0] < volumeforce.iForceIndexToClose[1]
      ) {
         this.orderType = ORDER_TYPE_SELL;
      }
   }
}
//+------------------------------------------------------------------+

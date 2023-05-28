//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
#include "./VolumeForceEntity.mq5";

double effortPercentualVol1 = 53.0;
double effortPercentualVol2 = 52.0;
double effortPercentualVol3 = 51.0;
double effortPercentualVol4 = 50.5;

double resultPercentualVol1 = 60.0;
double resultPercentualVol2 = 54.0;
double resultPercentualVol3 = 52.0;
double resultPercentualVol4 = 51.0;

double hurstMin = 0.55;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderTypeEntity
  {

public:

   int               orderType;

   void              init(VolumeForceEntity &volumeforce)
     {

      this.orderType = ORDER_TYPE_BUY_STOP_LIMIT;

      MqlRates lastCandle[];
      CopyRates(_Symbol, _Period, 0, 2, lastCandle);
      ArraySetAsSeries(lastCandle, true);
      /*
      Print("=================");
      Print("Spread: " + volumeforce.effortResult1.spread);
      Print("Result: " + volumeforce.effortResult2.result);
      Print("Operation: " + (volumeforce.effortResult1.spread < volumeforce.effortResult2.result));
      */
      if(
         volumeforce.effortResult1.effortBuyPercentual >= effortPercentualVol1
         && volumeforce.effortResult2.effortBuyPercentual >= effortPercentualVol2
         && volumeforce.effortResult3.effortBuyPercentual >= effortPercentualVol3
         && volumeforce.effortResult4.effortBuyPercentual >= effortPercentualVol4

         && volumeforce.effortResult1.resultBuyPercentual >= resultPercentualVol1
         && volumeforce.effortResult2.resultBuyPercentual >= resultPercentualVol2
         && volumeforce.effortResult3.resultBuyPercentual >= resultPercentualVol3
         && volumeforce.effortResult4.resultBuyPercentual >= resultPercentualVol4

         && volumeforce.hurstExponent > hurstMin
         && lastCandle[1].close > lastCandle[0].open
         && volumeforce.effortResult1.spread * 3.5 < volumeforce.effortResult1.result
         && volumeforce.effortResult1.effort > 550
      )
        {
         this.orderType = ORDER_TYPE_BUY;
        }
      if(
         volumeforce.effortResult1.effortSellPercentual >= effortPercentualVol1
         && volumeforce.effortResult2.effortSellPercentual >= effortPercentualVol2
         && volumeforce.effortResult3.effortSellPercentual >= effortPercentualVol3
         && volumeforce.effortResult4.effortSellPercentual >= effortPercentualVol4

         && volumeforce.effortResult1.resultSellPercentual >= resultPercentualVol1
         && volumeforce.effortResult2.resultSellPercentual >= resultPercentualVol2
         && volumeforce.effortResult3.resultSellPercentual >= resultPercentualVol3
         && volumeforce.effortResult4.resultSellPercentual >= resultPercentualVol4

         && volumeforce.hurstExponent > hurstMin
         && lastCandle[1].close < lastCandle[0].open
         && volumeforce.effortResult1.spread * 3.5 < volumeforce.effortResult1.result
         && volumeforce.effortResult1.effort > 550
      )
        {
         this.orderType = ORDER_TYPE_SELL;
        }
        
        Print("ORDER TYPE: " + this.orderType);
     }
  }
//+------------------------------------------------------------------+
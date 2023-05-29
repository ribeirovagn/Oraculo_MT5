//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
#include "./VolumeForceEntity.mq5";

double effortPercentualVol1 = 54.0;
double effortPercentualVol2 = 53.0;
double effortPercentualVol3 = 52.0;
double effortPercentualVol4 = 51.5;

double resultPercentualVol1 = 57.0;
double resultPercentualVol2 = 55.0;
double resultPercentualVol3 = 52.0;
double resultPercentualVol4 = 50.0;
int spread = 1800;
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
         (volumeforce.effortResult1.effortBuyPercentual >= effortPercentualVol1
          && volumeforce.effortResult2.effortBuyPercentual >= effortPercentualVol2
          && volumeforce.effortResult3.effortBuyPercentual >= effortPercentualVol3
          && volumeforce.effortResult4.effortBuyPercentual >= effortPercentualVol4

          && volumeforce.effortResult1.resultBuyPercentual >= resultPercentualVol1
          && volumeforce.effortResult2.resultBuyPercentual >= resultPercentualVol2
          && volumeforce.effortResult3.resultBuyPercentual >= resultPercentualVol3
          && volumeforce.effortResult4.resultBuyPercentual >= resultPercentualVol4

          && volumeforce.hurstExponent > hurstMin
          && lastCandle[0].close > lastCandle[0].open
          //&& volumeforce.effortResult1.spread * 3 < volumeforce.effortResult1.result
          && volumeforce.iForceIndex >= 35
          && volumeforce.effortResult1.effort > spread)
         || (
            volumeforce.iForceIndex >= 25
            && volumeforce.effortResult1.spread * 3 < volumeforce.effortResult1.result
            && volumeforce.effortResult1.effortBuyPercentual >= effortPercentualVol1
            && volumeforce.effortResult2.effortBuyPercentual >= 56
            && volumeforce.hurstExponent > hurstMin
            && lastCandle[0].close > lastCandle[0].open
            && volumeforce.effortResult1.resultBuyPercentual >= resultPercentualVol1
         )
      )
        {
         this.orderType = ORDER_TYPE_BUY;
        }
      if(
         (volumeforce.effortResult1.effortSellPercentual >= effortPercentualVol1
          && volumeforce.effortResult2.effortSellPercentual >= effortPercentualVol2
          && volumeforce.effortResult3.effortSellPercentual >= effortPercentualVol3
          && volumeforce.effortResult4.effortSellPercentual >= effortPercentualVol4

          && volumeforce.effortResult1.resultSellPercentual >= resultPercentualVol1
          && volumeforce.effortResult2.resultSellPercentual >= resultPercentualVol2
          && volumeforce.effortResult3.resultSellPercentual >= resultPercentualVol3
          && volumeforce.effortResult4.resultSellPercentual >= resultPercentualVol4

          && volumeforce.hurstExponent > hurstMin
          && lastCandle[0].close < lastCandle[0].open
          //&& volumeforce.effortResult1.spread * 3 < volumeforce.effortResult1.result
          && volumeforce.iForceIndex <= -35
          && volumeforce.effortResult1.effort > spread)
         || (
            volumeforce.iForceIndex >= -35
            && volumeforce.effortResult1.effortSellPercentual >= effortPercentualVol1
            && volumeforce.effortResult2.effortSellPercentual >= 56
            && volumeforce.hurstExponent > hurstMin
            && volumeforce.effortResult1.spread * 3 < volumeforce.effortResult1.result
            && volumeforce.effortResult1.effort > spread * 1.5
            && lastCandle[0].close < lastCandle[0].open
            && volumeforce.effortResult1.resultSellPercentual >= resultPercentualVol1
            && volumeforce.effortResult4.resultSellPercentual >= resultPercentualVol4
         )
      )
        {
         this.orderType = ORDER_TYPE_SELL;
        }

     }
  }
//+------------------------------------------------------------------+

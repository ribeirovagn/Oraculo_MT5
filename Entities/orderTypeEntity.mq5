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
class OrderTypeEntity
  {

public:

   int               orderType;

   void              init(VolumeForceEntity &volumeforce)
     {

      this.orderType = ORDER_TYPE_BUY_STOP_LIMIT;

      MqlRates lastCandle[];
      CopyRates(_Symbol, _Period, 0, 1, lastCandle);
      ArraySetAsSeries(lastCandle, true);

      double meanToOrder = 0;

      Print("Mean: " + volumeforce.mean);
      Print("Mean to buy: " + (volumeforce.mean + meanToOrder));
      Print("Mean: to sell: " + (volumeforce.mean - meanToOrder));
      Print("Last Close price: " + lastCandle[0].close);
      Print("lastCandle[0].open: " + lastCandle[0].open);
      Print("volumeforce.iForceIndexToOpen[0]: " + volumeforce.iForceIndexToOpen[0]);
      /*

      Print("=================");
      Print("Spread: " + volumeforce.effortResult1.spread);
      Print("Result: " + volumeforce.effortResult2.result);
      Print("Operation: " + (volumeforce.effortResult1.spread < volumeforce.effortResult2.result));

      */

      Print("(lastCandle[0].open > lastCandle[0].close) " + (lastCandle[0].open > lastCandle[0].close));
      Print("volumeforce.effortResult1.resultSellPercentual >= resultPercentualVol1 " + (volumeforce.effortResult1.resultSellPercentual >= resultPercentualVol1));
      Print("volumeforce.iForceIndexToOpen[0] < -30 " + (volumeforce.iForceIndexToOpen[0] < -30));
      Print("volumeforce.iForceIndexToOpen[1] < -30 " + (volumeforce.iForceIndexToOpen[1] < -30));
      Print("(volumeforce.mean + meanToOrder) < lastCandle[0].close " + ((volumeforce.mean + meanToOrder) < lastCandle[0].close));
      Print("volumeforce.effortResult1.spread " + volumeforce.effortResult1.spread);
      Print("volumeforce.effortResult1.result " + volumeforce.effortResult1.result);
      if(
         lastCandle[0].close > lastCandle[0].open
         //volumeforce.effortResult1.effortBuyPercentual >= effortPercentualVol1
         //&& volumeforce.effortResult2.effortBuyPercentual >= effortPercentualVol2
         //&& volumeforce.effortResult3.effortBuyPercentual >= effortPercentualVol3
         //&& volumeforce.effortResult4.effortBuyPercentual >= effortPercentualVol4

         && volumeforce.effortResult1.resultBuyPercentual >= resultPercentualVol1
         //&& volumeforce.effortResult2.resultBuyPercentual >= resultPercentualVol2
         //&& volumeforce.effortResult3.resultBuyPercentual >= resultPercentualVol3
         //&& volumeforce.effortResult4.resultBuyPercentual >= resultPercentualVol4

         //&& volumeforce.hurstExponent > hurstMin

         && volumeforce.effortResult1.spread < volumeforce.effortResult1.result
         && volumeforce.iForceIndexToOpen[0] > 30
         && volumeforce.iForceIndexToOpen[1] > 30
         && (volumeforce.mean + meanToOrder) < lastCandle[0].close
         //&& volumeforce.IRSI[0] > 50


      )
        {
         this.orderType = ORDER_TYPE_BUY;
        }
      else
         if(
            lastCandle[0].open > lastCandle[0].close
            //volumeforce.effortResult1.effortSellPercentual >= effortPercentualVol1
            //&& volumeforce.effortResult2.effortSellPercentual >= effortPercentualVol2
            //&& volumeforce.effortResult3.effortSellPercentual >= effortPercentualVol3
            //&& volumeforce.effortResult4.effortSellPercentual >= effortPercentualVol4

            && volumeforce.effortResult1.resultSellPercentual >= resultPercentualVol1
            //&& volumeforce.effortResult2.resultSellPercentual >= resultPercentualVol2
            //&& volumeforce.effortResult3.resultSellPercentual >= resultPercentualVol3
            //&& volumeforce.effortResult4.resultSellPercentual >= resultPercentualVol4

            //&& volumeforce.hurstExponent > hurstMin

            && volumeforce.effortResult1.spread < volumeforce.effortResult1.result
            && volumeforce.iForceIndexToOpen[0] < -30
            && volumeforce.iForceIndexToOpen[1] < -30
            && (volumeforce.mean - meanToOrder) > lastCandle[0].close
            //&& volumeforce.IRSI[0] < 50
         )
           {
            this.orderType = ORDER_TYPE_SELL;
           }

     }
  }
//+------------------------------------------------------------------+

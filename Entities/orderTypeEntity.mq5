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
      double meanToOrder = 1.00;
 
      
      if(
         lastCandle[0].close > lastCandle[0].open
         && volumeforce.effortResult1.effortBuyPercentual >= effortPercentualVol1
         && volumeforce.effortResult1.spread < volumeforce.effortResult1.result
         && volumeforce.iForceIndexToOpen[1] > 10
         && volumeforce.iForceIndexToClose[0] > volumeforce.iForceIndexToClose[1]
         && (volumeforce.mean + meanToOrder) < lastCandle[0].close
      ) {
         this.orderType = ORDER_TYPE_BUY;
      } else if(
         lastCandle[0].open > lastCandle[0].close
         && volumeforce.effortResult1.effortSellPercentual >= effortPercentualVol1
         && volumeforce.effortResult1.spread < volumeforce.effortResult1.result
         && volumeforce.iForceIndexToOpen[1] < -10
         && volumeforce.iForceIndexToClose[0] < volumeforce.iForceIndexToClose[1]
         && (volumeforce.mean - meanToOrder) > lastCandle[0].close

      ) {
         this.orderType = ORDER_TYPE_SELL;
      }
   }
}
//+------------------------------------------------------------------+

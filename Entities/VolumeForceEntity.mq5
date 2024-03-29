//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
#include "../structs/CandleStruct.mq5";
#include "../structs/VolumeForceStruct.mq5";
#include "../structs/EffortResultStruct.mq5";
#include "./CandleEntity.mq5";
#include "../utils/Percentual.mq5";


int volRange1 = 7;
int volRange2 = 13;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VolumeForceEntity {

public:

   CandleStruct vol1[];
   CandleStruct vol2[];
   
   VolumeForce       buy1;
   VolumeForce       sell1;
   VolumeForce       doji1;

   VolumeForce       buy2;
   VolumeForce       sell2;
   VolumeForce       doji2;

   double            hurstExponent;
   double            mean;
   ulong             meanVolume1;
   int               spreadTotal;
   double            iForceIndexToOpen[];
   double            iForceIndexToClose[];
   double            multiplicadorSpread;

   EffortResultStruct effortResult1;
   EffortResultStruct effortResult2;
   EffortResultStruct effortResult3;
   EffortResultStruct effortResult4;

   void init() {
      CandleEntity rates;
      
      rates.setCandles(volRange1, vol1);
      setTypeCandles(vol1, this.buy1, this.sell1, this.doji1);
      calcEffortResultPercentual(this.effortResult1, this.buy1, this.sell1, this.doji1);
      
      rates.setCandles(volRange2, vol2);
      setTypeCandles(vol2, this.buy2, this.sell2, this.doji2);
      calcEffortResultPercentual(this.effortResult2, this.buy2, this.sell2, this.doji2);
      // Calcula a média dos preços
      this.mean = this.calcMean(vol2);
      this.meanVolume1 = calcMeanVolume(vol1);

   }

   void calcEffortResultPercentual(EffortResultStruct &effortResult, VolumeForce &buy, VolumeForce &sell,VolumeForce &doji) {
   
   
      if(_Period == 1) {
         this.multiplicadorSpread = 1.5;
      } else if(_Period == 2) {
         this.multiplicadorSpread = 2.6;
      } else if(_Period >= 3) {
         this.multiplicadorSpread = 4.0;
      }
   
      effortResult.result = 0;
      effortResult.effortBuyPercentual = 0;
      effortResult.effortSellPercentual = 0;
      effortResult.effort = 0;
      effortResult.resultBuyPercentual = 0;
      effortResult.resultSellPercentual = 0;
      effortResult.spread = (long)((buy.spread + sell.spread + doji.spread) * this.multiplicadorSpread);
      effortResult.effort = (buy.effort  + sell.effort + doji.effort);
      effortResult.effortBuyPercentual = effortResult.effort > 0 ? NormalizeDouble((double)(100 / (double)effortResult.effort) *  buy.effort, 2) : 0;
      effortResult.effortSellPercentual = effortResult.effort > 0 ? NormalizeDouble((double)(100 / (double)effortResult.effort) * sell.effort, 2) : 0;
      effortResult.result = (buy.result + sell.result + doji.result);
      effortResult.resultBuyPercentual = effortResult.result > 0 ? NormalizeDouble((double)(100 / (double)effortResult.result) * buy.result, 2) : 0;
      effortResult.resultSellPercentual = effortResult.result > 0 ? NormalizeDouble((double)(100 / (double)effortResult.result) * sell.result, 2) : 0;
   }

   double calcMean(CandleStruct &vol[]) {
      double _mean = 0;
      for(int i=0; i<ArraySize(vol); i++) {
         _mean += vol[i].Close;
      }
      return (_mean / ArraySize(vol));
   }

private:

   void setTypeCandles(CandleStruct &candle[], VolumeForce &volForceBuy, VolumeForce &volForceSell, VolumeForce &volForceDoji) {
      volForceBuy.effort = 0;
      volForceBuy.result = 0;
      volForceBuy.spread = 0;
      volForceSell.effort = 0;
      volForceSell.result = 0;
      volForceSell.spread = 0;
      volForceDoji.effort = 0;
      volForceDoji.result = 0;
      volForceDoji.spread = 0;
      for(int i=0; i<ArraySize(candle); i++) {
         if(candle[i].Type == "BUY") {
            volForceBuy.effort += candle[i].TickVol;
            volForceBuy.result += candle[i].Result;
            volForceBuy.spread += candle[i].Spread;
         }
         if(candle[i].Type == "SELL") {
            volForceSell.effort += candle[i].TickVol;
            volForceSell.result += candle[i].Result;
            volForceSell.spread += candle[i].Spread;
         }
         if(candle[i].Type == "DOJI") {
            volForceDoji.effort = candle[i].TickVol;
            volForceDoji.result = candle[i].Result;
            volForceDoji.spread += candle[i].Spread;
         }
      }
   }

   void calcPercentual(VolumeForce &volForceBuy, VolumeForce &volForceSell) {
      long totalEffort = (volForceBuy.effort + volForceSell.effort);
      volForceBuy.effortPercentual = Percentual::calc(totalEffort, volForceBuy.effort);
      volForceSell.effortPercentual = Percentual::calc(totalEffort, volForceSell.effort);
      
      long totalResult = (volForceBuy.result + volForceSell.result);
      volForceBuy.resultPercentual = Percentual::calc(totalResult, volForceBuy.result);
      volForceSell.resultPercentual = Percentual::calc(totalResult, volForceSell.result);
   }
   
   ulong calcMeanVolume(CandleStruct &vol[]) {
   
      ulong _mean = 0;
   
      for(int i=0;i<ArraySize(vol);i++)
        {
            _mean += vol[i].TickVol;
        }
        
        
        return _mean / ArraySize(vol);
   
   
   }

   double calcHurst(CandleStruct &vol[]) {
      int arrSize = ArraySize(vol);
      double arr[];
      ArrayResize(arr,arrSize);
      for(int i = 0; i < arrSize; i++) {
         arr[i] = vol[i].Close;
      }
      return HurstExponent(arr);
   }

   double hurstMean(CandleStruct &vol[]) {
      int len = ArraySize(vol);
      double _mean = 0;
      for(int i=0; i<len; i++) {
         _mean += vol[i].Close;
      }
      return (_mean / len);
   }

}
//+------------------------------------------------------------------+

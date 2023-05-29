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
#include "../utils/HurstExponent.mq5";

int volRange1 = 5;
int volRange2 = 8;
int volRange3 = 12;
int volRange4 = 21;
int hurstLen = 30;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class VolumeForceEntity
  {

public:

   VolumeForce       buy1;
   VolumeForce       sell1;
   VolumeForce       doji1;

   VolumeForce       buy2;
   VolumeForce       sell2;
   VolumeForce       doji2;

   VolumeForce       buy3;
   VolumeForce       sell3;
   VolumeForce       doji3;

   VolumeForce       buy4;
   VolumeForce       sell4;
   VolumeForce       doji4;

   double            hurstExponent;
   double            mean;
   int               spreadTotal;
   double            iForceIndex;


   EffortResultStruct effortResult1;
   EffortResultStruct effortResult2;
   EffortResultStruct effortResult3;
   EffortResultStruct effortResult4;

   void              init()
     {

      CandleEntity rates;

      CandleStruct vol1[];
      rates.setCandles(volRange1, vol1);
      setTypeCandles(vol1, this.buy1, this.sell1, this.doji1);
      calcEffortResultPercentual(this.effortResult1, this.buy1, this.sell1, this.doji1);

      CandleStruct vol2[];
      rates.setCandles(volRange2, vol2);
      setTypeCandles(vol2, this.buy2, this.sell2, this.doji2);
      calcEffortResultPercentual(this.effortResult2, this.buy2, this.sell2, this.doji2);

      CandleStruct vol3[];
      rates.setCandles(volRange3, vol3);
      setTypeCandles(vol3, this.buy3, this.sell3, this.doji3);
      calcEffortResultPercentual(this.effortResult3, this.buy3, this.sell3, this.doji3);

      CandleStruct vol4[];
      rates.setCandles(volRange4, vol4);
      setTypeCandles(vol4, this.buy4, this.sell4, this.doji4);
      calcEffortResultPercentual(this.effortResult4, this.buy4, this.sell4, this.doji4);

      CandleStruct hurst[];
      rates.setCandles(hurstLen, hurst);
      this.hurstExponent = this.calcHurst(hurst);
      this.mean = this.hurstMean(hurst);

      /*
      Print("Result: " + (string)this.effortResult1.result);
      Print("Effort: " + (string)this.effortResult1.effort);
      Print("Spread Total: " + (string)(this.effortResult1.spread));
      Print("Result Buy  Percentual: " + (string)this.effortResult1.resultBuyPercentual);
      Print("Result Sell Percentual: " + (string)this.effortResult1.resultSellPercentual);
      Print("Effort Buy  Percentual: " + (string)this.effortResult1.effortBuyPercentual);
      Print("Effort Sell Percentual: " + (string)this.effortResult1.effortSellPercentual);
      */
     }

   void              calcEffortResultPercentual(EffortResultStruct &effortResult, VolumeForce &buy, VolumeForce &sell,VolumeForce &doji)
     {
      
      effortResult.result = 0;
      effortResult.effortBuyPercentual = 0;
      effortResult.effortSellPercentual = 0;

      effortResult.effort = 0;
      effortResult.resultBuyPercentual = 0;
      effortResult.resultSellPercentual = 0;

      effortResult.spread = (buy.spread + sell.spread + doji.spread);

      effortResult.effort = (buy.effort  + sell.effort + doji.effort);
      effortResult.effortBuyPercentual = effortResult.effort > 0 ? NormalizeDouble((double)(100 / (double)effortResult.effort) *  buy.effort, 2) : 0;
      effortResult.effortSellPercentual = effortResult.effort > 0 ? NormalizeDouble((double)(100 / (double)effortResult.effort) * sell.effort, 2) : 0;

      effortResult.result = (buy.result + sell.result + doji.result);
      effortResult.resultBuyPercentual = effortResult.result > 0 ? NormalizeDouble((double)(100 / (double)effortResult.result) * buy.result, 2) : 0;
      effortResult.resultSellPercentual = effortResult.result > 0 ? NormalizeDouble((double)(100 / (double)effortResult.result) * sell.result, 2) : 0;
      /*
      Print("------------------------------------------------------");
      Print("buy.effort: " + buy.effort);
      Print("sell.effort: " + sell.effort);      
      Print("effortResult.effortBuyPercentual:  " + effortResult.effortBuyPercentual);
      Print("effortResult.effortSellPercentual: " + effortResult.effortSellPercentual);      
      Print("buy.result: " + buy.result);
      Print("sell.result: " + sell.result);
      Print("effortResult.resultBuyPercentual:  " + effortResult.resultBuyPercentual);
      Print("effortResult.resultSellPercentual: " + effortResult.resultSellPercentual);
      Print("Spread: " + effortResult.spread);
      Print("PriceAction: " + effortResult.result);
      */
     }

private:

   void              setTypeCandles(CandleStruct &candle[], VolumeForce &volForceBuy, VolumeForce &volForceSell, VolumeForce &volForceDoji)
     {

      volForceBuy.effort = 0;
      volForceBuy.result = 0;
      volForceBuy.spread = 0;

      volForceSell.effort = 0;
      volForceSell.result = 0;
      volForceSell.spread = 0;

      volForceDoji.effort = 0;
      volForceDoji.result = 0;
      volForceDoji.spread = 0;

      for(int i=0; i<ArraySize(candle); i++)
        {

         if(candle[i].Type == "BUY")
           {
            volForceBuy.effort += candle[i].TickVol;
            volForceBuy.result += candle[i].Result;
            volForceBuy.spread += candle[i].Spread;
           }

         if(candle[i].Type == "SELL")
           {
            volForceSell.effort += candle[i].TickVol;
            volForceSell.result += candle[i].Result;
            volForceSell.spread += candle[i].Spread;
           }

         if(candle[i].Type == "DOJI")
           {
            volForceDoji.effort = candle[i].TickVol;
            volForceDoji.result = candle[i].Result;
            volForceDoji.spread += candle[i].Spread;
           }

        }

     }

   void              calcPercentual(VolumeForce &volForceBuy, VolumeForce &volForceSell)
     {

      long totalEffort = (volForceBuy.effort + volForceSell.effort);
      volForceBuy.effortPercentual = Percentual::calc(totalEffort, volForceBuy.effort);
      volForceSell.effortPercentual = Percentual::calc(totalEffort, volForceSell.effort);

      long totalResult = (volForceBuy.result + volForceSell.result);
      volForceBuy.resultPercentual = Percentual::calc(totalResult, volForceBuy.result);
      volForceSell.resultPercentual = Percentual::calc(totalResult, volForceSell.result);
     }

   double            calcHurst(CandleStruct &vol[])
     {

      int arrSize = ArraySize(vol);
      double arr[];
      ArrayResize(arr,arrSize);

      for(int i = 0; i < arrSize; i++)
        {
         arr[i] = vol[i].Close;
        }

      return HurstExponent(arr);

     }

   double              hurstMean(CandleStruct &vol[])
     {

      int len = ArraySize(vol);
      double mean = 0;

      for(int i=0; i<len; i++)
        {
         mean += vol[i].Close;
        }


      return (mean / len);

     }



  }
//+------------------------------------------------------------------+

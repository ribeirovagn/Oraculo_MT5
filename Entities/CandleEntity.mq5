#include "../structs/CandleStruct.mq5";

class CandleEntity {
   private:
   MqlRates rates[];
       
   public: 
   
   void setCandles(int qnt, CandleStruct &arr[])
   {
      
      CopyRates(_Symbol, _Period, 0, qnt, this.rates);
      //ArraySetAsSeries(this.rates, false);
      ArrayResize(arr, ArraySize(this.rates));
      
      for(int i = 0; i < ArraySize(this.rates); i++) {
         arr[i] = this.getInfo(this.rates[i]);
      }
      
   }

   CandleStruct getInfo(MqlRates &rate){
      
      CandleStruct _candle;
      
      _candle.Open = rate.open;
      _candle.High = rate.high;
      _candle.Low = rate.low;
      _candle.Close = rate.close;
      _candle.Type = (rate.open > rate.close) ? "SELL" : "BUY";
      if(rate.open == rate.close) _candle.Type = "DOJI";
      _candle.Spread = rate.spread;
      _candle.TickVol = rate.tick_volume;
      _candle.RealVol = rate.real_volume;
      _candle.Result = (MathAbs((rate.open) - (rate.close)) * 100);
      
      return _candle;
      
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Candle
  {
public:
   static void       get(int qnt = 0)
     {
      Print("Aconteceu um tick " + qnt);
     }

public:
   static double       getRangePrice(int qnt)
     {
      MqlRates rates[];
      ArraySetAsSeries(rates,true);
      return(0.02);
     }
  }
//+------------------------------------------------------------------+

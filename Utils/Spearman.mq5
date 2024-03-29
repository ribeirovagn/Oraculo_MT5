//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+

#include "./Points.mq5";

class Spearman {

public:

   double static calc(int qnt = 7) {
      double calculate = 0;
      long close[];
      long ranking[];
      MqlRates rates[];
      CopyRates(_Symbol, _Period, 0, qnt, rates);

      ArrayResize(close, ArraySize(rates));
      ArrayResize(ranking, ArraySize(rates));
      for(int i=0; i<ArraySize(rates); i++) {
         close[i] = Points::pipsToPoints(rates[i].close);
         ranking[i] = close[i];
         //Print(i + " " + close[i]);
      }

      ArraySort(ranking);
      for(int i=0; i<ArraySize(ranking); i++) {
         calculate += MathPow((i + 1 ) - (ArrayBsearch(close, ranking[i]) + 1), 2);
      }
      
      double spearman = 1 - (6 * calculate) / (ArraySize(rates) * (MathPow(ArraySize(rates), 2) - 1));
      Print("Spearman: ", spearman);
      return spearman;
   }
};
//+------------------------------------------------------------------+

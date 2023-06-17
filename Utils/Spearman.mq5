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
         for(int j=0; j<ArraySize(close); j++) {
            if(ranking[i] == close[j]) {
               calculate += MathPow((i + 1 ) - (j + 1), 2);
               break;
            }
         }
      }
      
      Print("calculate " + calculate);
 
      double spearman = 1 - (6 * calculate) / (ArraySize(rates) * (MathPow(ArraySize(rates), 2) - 1));
      Print("Spearman: " + spearman);
      return spearman;
   }
};
//+------------------------------------------------------------------+

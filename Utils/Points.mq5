//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
class Points {

public:

  

   int static pipsToPoints(double pips) {
      return (int)(pips / SymbolInfoDouble(_Symbol, SYMBOL_POINT));
   }

   double static pointsToPips(ulong points) {
      return (double)(points * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
   }
};
//+------------------------------------------------------------------+

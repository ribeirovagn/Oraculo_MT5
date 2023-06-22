//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
class Points {

public:

   int static pipsToPoints(double pips) {
      return (int)(pips / _Point);
   }

   double static pointsToPips(ulong points) {
      return (double)(points * _Point);
   }
   
   double static formatCurrency(double value) {
      return NormalizeDouble(value, _Digits);
   }
};
//+------------------------------------------------------------------+

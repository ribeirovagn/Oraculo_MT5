//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
#include "./CandleStruct.mq5";

struct VolumeForce {
   CandleStruct        rates[];
   double              mean;
   long                effort;
   double              effortPercentual;
   double              resultPercentual;
   int                result;
   long                priceAction;
   int                spread;
};

//+------------------------------------------------------------------+

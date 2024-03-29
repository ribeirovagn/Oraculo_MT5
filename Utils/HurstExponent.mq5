//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+
#define koef 1.253315

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double HurstExponent(const double &dados[]) {
   double val = 0;
   struct sGlobalStruct {
      int               period;
      double            x[];
      double            y[];
      double            logDivisor;
   };
   sGlobalStruct global;
   global.period     = MathMax(ArraySize(dados),1);
   global.logDivisor = MathLog(global.period);
   ArrayResize(global.x,global.period);
   ArrayInitialize(global.x,0);
   ArraySetAsSeries(global.x,true);
   ArrayResize(global.y,global.period);
   ArrayInitialize(global.y,0);
   ArraySetAsSeries(global.y,true);
   struct sWorkStruct {
      double         value;
      double         valueSum;
   };
   static sWorkStruct m_work[];
   for(int i=0; i<ArraySize(dados) && !_StopFlag; i++) {
      ArrayResize(m_work, i+1);
      m_work[i].value = dados[i];
      if(i>=global.period) {
         m_work[i].valueSum = m_work[i-1].valueSum + m_work[i].value - m_work[i-global.period].value;
      } else {
         m_work[i].valueSum = m_work[i].value;
         for(int k=1; k<global.period && i>=k; k++)
            m_work[i].valueSum += m_work[i-k].value;
      }
      double mean = m_work[i].valueSum/(double)global.period;
      double sums = 0;
      double maxY = 0;
      double minY = 0;
      for(int k=0; k<global.period && i>=k; k++) {
         global.x[k] = m_work[i-k].value-mean;
         sums+=global.x[k]*global.x[k];
         if(k>0) {
            global.y[k] = global.y[k-1] + global.x[k];
            if(maxY<global.y[k])
               maxY = global.y[k];
            if(minY>global.y[k])
               minY = global.y[k];
         } else {
            maxY = minY = global.y[k] = global.x[k];
         }
      }
      double iValue = (sums!=0) ? (maxY - minY)/(koef * MathSqrt(sums/(double)global.period)) : 0;
      val = (iValue > 0) ? MathLog(iValue)/ global.logDivisor : 0;
   }
   return val;
}
//+------------------------------------------------------------------+

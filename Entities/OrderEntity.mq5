//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+

#include "./VolumeForceEntity.mq5";
#include "./OrderTypeEntity.mq5";
#include "./CandleEntity.mq5";
#include "../structs/CandleStruct.mq5";
#include <Trade\Trade.mqh>;
#include "../utils/Spearman.mq5";

input bool isSetStopLoss = true;
double volumeOrder =3500.0;
input bool openOrders = true;
int limitLoss = -400;
int maximunTakeProfit = 3000;
int stopLoss = 400; // Quantos pontos para  colocar o stop no 0x0

CTrade trade;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderEntity {



public:
   void              init(VolumeForceEntity &VolumeForce, OrderTypeEntity &OrderType) {
      bool acumulado = this.acumulado(VolumeForce);
      if(this.isOpenedOrders()) {
         int positionsTotal = PositionsTotal();
         ENUM_POSITION_TYPE      type;
         ulong _ticket = PositionGetTicket(0);
         double orderOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         // Obter o preço atual
         double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         int _digits = SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
         // Pontos de compra
         int pointsBuy = Points::pipsToPoints(NormalizeDouble(VolumeForce.vol1[ArraySize(VolumeForce.vol1) - 1].Close - orderOpenPrice, _digits));
         // Pontos de venda
         int pointsSell = Points::pipsToPoints(NormalizeDouble(orderOpenPrice - VolumeForce.vol1[ArraySize(VolumeForce.vol1) - 1].Close, _digits));
         for(int i=0; i<positionsTotal; i++) {
            ulong PosTicket = PositionGetTicket(i);
            type = PositionGetInteger(POSITION_TYPE);
            if(PositionGetSymbol(i) == _Symbol) {
               if(type == ORDER_TYPE_BUY) {
                  if(
                     VolumeForce.iForceIndexToClose[0] < 0
                     && VolumeForce.iForceIndexToClose[1] < 0
                     && VolumeForce.iForceIndexToClose[2] < 0
                     || pointsBuy < limitLoss
                     || pointsBuy >= maximunTakeProfit
                  ) {
                     trade.PositionClose(PosTicket);
                     //Sleep(10000 * 60 * _Period);
                  }
                  if(pointsBuy >= stopLoss) {
                     if(isSetStopLoss)
                        trade.PositionModify(PosTicket, orderOpenPrice, 0.0);
                  }
               }
               if(type == ORDER_TYPE_SELL) {
                  if(
                     VolumeForce.iForceIndexToClose[0] > 0
                     && VolumeForce.iForceIndexToClose[1] > 0
                     && VolumeForce.iForceIndexToClose[2] > 0
                     || pointsSell <= limitLoss
                     || pointsSell >= maximunTakeProfit
                  ) {
                     trade.PositionClose(PosTicket);
                     //Sleep(10000 * 60 * _Period);
                  }
                  if(pointsBuy >= stopLoss) {
                     if(isSetStopLoss)
                        trade.PositionModify(PosTicket, orderOpenPrice, 0.0);
                  }
               }
            }
         }
      } else {
         double saldo = AccountInfoDouble(ACCOUNT_BALANCE);
         double _volume = NormalizeDouble((saldo / volumeOrder), 2);
         ulong meanVolume = 30;
         if(!MQLInfoInteger(MQL_TESTER)) {
            Print("Volume médio: " + VolumeForce.meanVolume1 + " > " + meanVolume + " : " + (string)(VolumeForce.meanVolume1 > meanVolume));
         }
         if(OrderType.orderType == ORDER_TYPE_BUY
               && VolumeForce.meanVolume1 > meanVolume
               && !acumulado
           ) {
            PlaySound("./Sounds/mixkit-censorship-beep-1082.wav");
            if(openOrders) {
               trade.Buy(_volume, _Symbol, 0.0, 0.0, 0.0, "Oraculo EA Order Buy M" + _Period);
            }
            Sleep(500);
         }
         if(OrderType.orderType == ORDER_TYPE_SELL
               && VolumeForce.meanVolume1 > meanVolume
               && !acumulado
           ) {
            PlaySound("./Sounds/mixkit-censorship-beep-1082.wav");
            if(openOrders) {
               trade.Sell(_volume, _Symbol, 0.0, 0.0, 0.0, "Oraculo EA Order Sell M" + _Period);
            }
            Sleep(500);
         }
      }
   }



private:
   bool              isOpenedOrders() {
      int totalOrders = PositionsTotal();
      if(totalOrders == 0) {
         return false;
      }
      return true;
   }

   bool acumulado(VolumeForceEntity &VolumeForce) {
      int qntCandles = 30;
      double closeValue[];
      ArrayResize(closeValue, qntCandles);
      double sum = 0;
      MqlRates tf[];

      double currentPrice = VolumeForce.vol1[ArraySize(VolumeForce.vol1) - 1].Close;
      CopyRates(_Symbol, _Period, 0, qntCandles, tf);
      for (int i = 0; i < qntCandles; i++) {
         sum += tf[i].close;
         closeValue[i] = tf[i].close;
      }
      
      ArraySort(closeValue);
      
     
      double max = closeValue[ArraySize(closeValue) - 1];
      double min = closeValue[0];
      
      sum = sum / qntCandles;
      int points = Points::pipsToPoints(MathAbs(sum - currentPrice));
      if(!MQLInfoInteger(MQL_TESTER)) {
         Print("Points ", points);
         Print("Expansão maxima: " + (string)max);
         Print("Expansão minima: " + (string)min);
      }
      if(points > 5) {
         return false;
      }
      return true;
   }

};
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+



#include "./VolumeForceEntity.mq5";
#include "./OrderTypeEntity.mq5";
#include "./CandleEntity.mq5";
#include "../structs/CandleStruct.mq5";
#include "../utils/configTimeframes.mq5";
#include <Trade\Trade.mqh>;

input bool isSetStopLoss = true;
input bool isAlert = true;
double volumeOrder =5000.0;
input bool openOrders = true;
int limitLoss = -350;
bool stopLossActived = false;
int maximunTakeProfit = 3000;
int stopLoss = 400; // Quantos pontos para  colocar o stop no 0x0

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderEntity
{

public:
   void              init(VolumeForceEntity &VolumeForce, OrderTypeEntity &OrderType)
   {
      ResetLastError();
      bool acumulado = this.acumulado(VolumeForce);
      ulong meanVolume = 30;
      Print("VolumeForce.meanVolume1 > meanVolume ", VolumeForce.meanVolume1, " ", meanVolume, " : ", (VolumeForce.meanVolume1 > meanVolume));

      if(PositionsTotal() > 0)
         {
            long type;
            ulong _ticket = PositionGetTicket(0);
            double orderOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            // Obter o preço atual
            double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            // Pontos de compra
            int pointsBuy = Points::pipsToPoints(NormalizeDouble(VolumeForce.vol1[ArraySize(VolumeForce.vol1) - 1].Close - orderOpenPrice, _Digits));
            // Pontos de venda
            int pointsSell = Points::pipsToPoints(NormalizeDouble(orderOpenPrice - VolumeForce.vol1[ArraySize(VolumeForce.vol1) - 1].Close, _Digits));

            type = PositionGetInteger(POSITION_TYPE);

            if(PositionGetSymbol(0) == _Symbol)
               {
                  if(type == ORDER_TYPE_BUY)
                     {
                        if(
                           (VolumeForce.iForceIndexToClose[0] < 0
                            && VolumeForce.iForceIndexToClose[1] < 0
                            && VolumeForce.iForceIndexToClose[2] < 0)
                           || pointsBuy < limitLoss
                           || pointsBuy >= maximunTakeProfit
                        )
                           {
                              if(trade.PositionClose(_ticket))
                                 {
                                    SendNotification("Oráculo EA close BUY order in " + _Symbol);
                                    stopLossActived = false;
                                    Sleep(5000 * 60 * _Period);
                                 }
                           }
                        if(pointsBuy >= stopLoss && (isSetStopLoss && !stopLossActived))

                           {
                              if(trade.PositionModify(_ticket, orderOpenPrice, 0.0))
                                 {
                                    stopLossActived = true;
                                 }
                           }

                     }
                  if(type == ORDER_TYPE_SELL)
                     {
                        if(
                           (VolumeForce.iForceIndexToClose[0] > 0
                            && VolumeForce.iForceIndexToClose[1] > 0
                            && VolumeForce.iForceIndexToClose[2] > 0)
                           || pointsSell <= limitLoss
                           || pointsSell >= maximunTakeProfit
                        )
                           {
                              if(trade.PositionClose(_ticket))
                                 {
                                    SendNotification("Oráculo EA close SELL order in " + _Symbol);
                                    stopLossActived = true;
                                    Sleep(5000 * 60 * _Period);
                                 }
                           }
                        if(pointsBuy >= stopLoss && (isSetStopLoss && !stopLossActived))
                           {
                              if(trade.PositionModify(_ticket, orderOpenPrice, 0.0))
                                 {
                                    stopLossActived = true;
                                 }
                           }
                     }
               }
         }
      else
         {
            double saldo = AccountInfoDouble(ACCOUNT_BALANCE);
            double _volume = NormalizeDouble((saldo / volumeOrder), 2);
            if(!MQLInfoInteger(MQL_TESTER))
               {
                  Print("Volume médio: ", VolumeForce.meanVolume1, " > ", meanVolume, " : ", (string)(VolumeForce.meanVolume1 > meanVolume));
               }
            if(OrderType.orderType == ORDER_TYPE_BUY
                  && VolumeForce.meanVolume1 > meanVolume
                  && !acumulado
              )
               {
                  if(isAlert)
                     {
                        PlaySound("./Sounds/game-notification.wav");
                     }

                  if(openOrders)
                     {
                        if(trade.Buy(_volume, _Symbol, 0.0, 0.0, 0.0, "Oráculo EA Order Buy M" + (string)_Period))
                           {
                              SendNotification("Oráculo EA open order buy at " +  _Symbol + "/" + TimeFrameToString());
                              stopLossActived = false;
                           }
                     }
                  Sleep(350);
               }
            if(OrderType.orderType == ORDER_TYPE_SELL
                  && VolumeForce.meanVolume1 > meanVolume
                  && !acumulado
              )
               {
                  if(isAlert)
                     {
                        PlaySound("./Sounds/game-notification.wav");
                     }
                  if(openOrders)
                     {
                        if(trade.Sell(_volume, _Symbol, 0.0, 0.0, 0.0, "Oráculo EA Order Sell M" + (string)_Period))
                           {
                              SendNotification("Oráculo EA open order sell at " + _Symbol + "/" + TimeFrameToString());
                              stopLossActived = false;
                           }
                     }
                  Sleep(350);
               }
         }
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   bool              acumulado(VolumeForceEntity &VolumeForce)
   {
      int qntCandles = 30;
      long minimumPoints = 50;
      double closeValue[];
      ArrayResize(closeValue, qntCandles);
      double sum = 0;
      MqlRates tf[];

      double currentPrice = VolumeForce.vol1[ArraySize(VolumeForce.vol1) - 1].Close;
      CopyRates(_Symbol, _Period, 0, qntCandles, tf);
      for (int i = 0; i < qntCandles; i++)
         {
            sum += tf[i].close;
            closeValue[i] = tf[i].close;
         }

      ArraySort(closeValue);


      int max = ArrayMaximum(closeValue);
      int min = ArrayMinimum(closeValue);

      sum = sum / qntCandles;

      int points = Points::pipsToPoints(MathAbs(sum - currentPrice));
      if(!MQLInfoInteger(MQL_TESTER))
         {
            Print("Points ", points, " ", (points >= minimumPoints));
            Print("Preço médio:     " + (string)NormalizeDouble(sum, _Digits));
         }
      if(points >= minimumPoints)
         {
            return false;
         }
      return true;
   }

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

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

input double volumeOrder = 10000.0;
input bool openOrders = true;
input bool playSoundCloseOrder = true;

int limitLoss = -600;
int maximunTakeProfit = 4000;
CTrade trade;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderEntity {


public:
   void              init(VolumeForceEntity &VolumeForce, OrderTypeEntity &OrderType) {
      MqlTick last_tick;
      SymbolInfoTick(Symbol(),last_tick);
      if(this.isOpenedOrders()) {
         int positionsTotal = PositionsTotal();
         ENUM_POSITION_TYPE      type;
         ulong _ticket = PositionGetTicket(0);
         double orderOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         // Obter o preço atual
         double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         int _digits = SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
         int stopLoss = 450;
         // Pontos de compra
         int pointsBuy = Points::pipsToPoints(NormalizeDouble(last_tick.bid - orderOpenPrice, _digits));
         // Pontos de venda
         int pointsSell = Points::pipsToPoints(NormalizeDouble(orderOpenPrice - last_tick.bid, _digits));
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
                     if(playSoundCloseOrder) {
                        if((last_tick.bid - orderOpenPrice) > 0) {
                           PlaySound("./Sounds/casino-jackpot-alarm-and-coins-1991.wav");
                        }
                     }
                     Sleep(1000 * 60 * _Period);
                  }
                  if(pointsBuy >= stopLoss) {
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
                     if(playSoundCloseOrder) {
                        if((orderOpenPrice - last_tick.bid) > 0) {
                           PlaySound("./Sounds/casino-jackpot-alarm-and-coins-1991.wav");
                        }
                     }
                     Sleep(1000 * 60 * _Period);
                  }
                  if(pointsBuy >= stopLoss) {
                     trade.PositionModify(PosTicket, orderOpenPrice, 0.0);
                  }
               }
            }
         }
      } else {
         double saldo = AccountInfoDouble(ACCOUNT_BALANCE);
         double _volume = NormalizeDouble((saldo / volumeOrder), 2);
         CandleEntity rates;
         datetime lastOrderTime = 0;
         datetime end=TimeCurrent();
         datetime start=end-PeriodSeconds(PERIOD_MN1);
         HistorySelect(start,end);
         int deals=HistoryDealsTotal();
         ulong deal_ticket=HistoryDealGetTicket(deals-1);
         lastOrderTime = HistoryDealGetInteger(deal_ticket,DEAL_TIME);
         CandleStruct vol1[];
         rates.setCandles(volRange1, vol1);
         if(OrderType.orderType == ORDER_TYPE_BUY && vol1[0].TickVol > 50) {
            PlaySound("./Sounds/order-notification.wav");
            if(openOrders) {
               trade.Buy(_volume, _Symbol, 0.0, 0.0, 0.0, "Oraculo EA Order Buy M" + _Period);
               //SendNotification("Oraculo EA: Open order BUY in " + _Symbol + "M" + _Period);
            } else {
               // SendNotification("Oraculo EA: Order BUY in " + _Symbol);
               Alert("Oraculo EA: Open Order BUY in " + _Symbol);
            }
            Sleep(5000);
         }
         if(OrderType.orderType == ORDER_TYPE_SELL && vol1[0].TickVol > 50) {
            PlaySound("./Sounds/order-notification.wav");
            if(openOrders) {
               trade.Sell(_volume, _Symbol, 0.0, 0.0, 0.0, "Oraculo EA Order Sell M" + _Period);
               //SendNotification("Oraculo EA: Order Sell in " + _Symbol + "M" + _Period);
            } else {
               //SendNotification("Oraculo EA: Order Sell in " + _Symbol);
               Alert("Oraculo EA: Open Order Sell in " + _Symbol);
            }
            Sleep(5000);
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

};
//+------------------------------------------------------------------+

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
input bool openOrders = false;

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
         double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
         ulong _ticket = PositionGetTicket(0);
         double orderOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         // Obter o preço atual
         double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         // Calcular os ticks entre a ordem aberta e o preço atual
         double ticks = MathAbs((orderOpenPrice - last_tick.bid));
         // Exibir o número de ticks
         //Print("Número de Ticks: ", ticks);
         //Print("Point: " + point);
         //Print("--------------------------");
         for(int i=0; i<positionsTotal; i++) {
            ulong PosTicket = PositionGetTicket(i);
            type = PositionGetInteger(POSITION_TYPE);
            if(PositionGetSymbol(i) == _Symbol) {
               if(type == ORDER_TYPE_BUY) {
                  if(
                     // VolumeForce.effortResult1.resultBuyPercentual < 50.0
                     VolumeForce.iForceIndexToClose[0] < 0
                     && VolumeForce.iForceIndexToClose[1] < 0
                     && VolumeForce.iForceIndexToClose[2] < 0
                     && VolumeForce.iForceIndexToClose[0] > VolumeForce.iForceIndexToClose[1]
                     //&& VolumeForce.iForceIndexToClose[1] > VolumeForce.iForceIndexToClose[2]
                     || (last_tick.bid - orderOpenPrice) < -6.0
                     || (last_tick.bid - orderOpenPrice) >= 25.0
                     //|| VolumeForce.iForceIndexToOpen[1] <= 220
                  ) {
                     trade.PositionClose(PosTicket);
                  }
                  if((last_tick.bid - orderOpenPrice) >= 5.0) {
                     trade.PositionModify(PosTicket, orderOpenPrice, 0.0);
                  }
               }
               if(type == ORDER_TYPE_SELL) {
                  if(
                     // VolumeForce.effortResult1.resultSellPercentual < 50.0
                     VolumeForce.iForceIndexToClose[0] > 0
                     && VolumeForce.iForceIndexToClose[1] > 0
                     && VolumeForce.iForceIndexToClose[2] > 0
                     && VolumeForce.iForceIndexToClose[0] < VolumeForce.iForceIndexToClose[1]
                     //&& VolumeForce.iForceIndexToClose[1] < VolumeForce.iForceIndexToClose[2]
                     || (orderOpenPrice - last_tick.bid) <= -6.0
                     || (orderOpenPrice - last_tick.bid) >= 25.0
                     //|| VolumeForce.iForceIndexToOpen[1] >= -220
                  ) {
                     trade.PositionClose(PosTicket);
                  }
                  if((orderOpenPrice - last_tick.bid) >= 5.0) {
                     trade.PositionModify(PosTicket, orderOpenPrice, 0.0);
                  }
               }
            }
         }
      } else {
         double saldo = AccountInfoDouble(ACCOUNT_BALANCE);
         double _volume = NormalizeDouble((saldo / 10000), 2);
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
            if(openOrders)
               trade.Buy(_volume, _Symbol, 0.0, 0.0, "Oraculo EA");
            else {
               // SendNotification("Oraculo EA: Order BUY in " + _Symbol);
               Alert("Oraculo EA: Order BUY in " + _Symbol);
            }
         }
         if(OrderType.orderType == ORDER_TYPE_SELL && vol1[0].TickVol > 50) {
            if(openOrders)
               trade.Sell(_volume, _Symbol, 0.0, 0.0, "Oraculo EA");
            else {
               //SendNotification("Oraculo EA: Order Sell in " + _Symbol);
               Alert("Oraculo EA: Order Sell in " + _Symbol);
            }
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

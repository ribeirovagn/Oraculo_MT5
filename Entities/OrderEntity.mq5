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

input double volumeOrder = 1;

CTrade trade;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderEntity
  {


public:
   void              init(VolumeForceEntity &VolumeForce, OrderTypeEntity &OrderType)
     {
      MqlTick last_tick;
      SymbolInfoTick(Symbol(),last_tick);
      if(this.isOpenedOrders())
        {
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

         for(int i=0; i<positionsTotal; i++)
           {
            ulong PosTicket = PositionGetTicket(i);
            type = PositionGetInteger(POSITION_TYPE);

            if(PositionGetSymbol(i) == _Symbol)
              {
               if(type == ORDER_TYPE_BUY)
                 {
                  if(
                     VolumeForce.effortResult1.resultBuyPercentual < 50.0
                     && VolumeForce.iForceIndexToClose[0] < 0
                     || (last_tick.bid - orderOpenPrice) < -2.50
                  )
                    {
                     trade.PositionClose(PosTicket);
                    }
                 }
               if(type == ORDER_TYPE_SELL)
                 {
                  if(
                     VolumeForce.effortResult1.resultSellPercentual < 50.0
                     && VolumeForce.iForceIndexToClose[0] > 0
                     || (orderOpenPrice - last_tick.bid) <= -2.50
                  )
                    {
                     trade.PositionClose(PosTicket);
                    }
                 }
              }
           }

        }
      else
        {
         double saldo = AccountInfoDouble(ACCOUNT_BALANCE);
         double _volume = NormalizeDouble((saldo / 5000), 2);

         CandleEntity rates;
         datetime lastOrderTime = 0;

         datetime end=TimeCurrent();
         datetime start=end-PeriodSeconds(PERIOD_MN1);
         //--- request of trade history needed into the cache of MQL5 program
         HistorySelect(start,end);
         //--- get total number of deals in the history
         int deals=HistoryDealsTotal();

         ulong deal_ticket=HistoryDealGetTicket(deals-1);

         lastOrderTime = HistoryDealGetInteger(deal_ticket,DEAL_TIME);

         CandleStruct vol1[];
         rates.setCandles(volRange1, vol1);


         if(vol1[0].DateTime > lastOrderTime)
           {


            if(OrderType.orderType == ORDER_TYPE_BUY && vol1[0].TickVol > 50)
              {
               trade.Buy(_volume, _Symbol);
              }
            if(OrderType.orderType == ORDER_TYPE_SELL && vol1[0].TickVol > 50)
              {
               trade.Sell(_volume, _Symbol);
              }
           }
        }
     }



private:

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool              isOpenedOrders()
     {

      int totalOrders = PositionsTotal();

      if(totalOrders == 0)
        {
         return false;
        }
      return true;
     }

  };
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

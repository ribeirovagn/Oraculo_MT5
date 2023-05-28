//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+

#include "./VolumeForceEntity.mq5";
#include "./OrderTypeEntity.mq5";

#include <Trade\Trade.mqh>;

double volumeOrder = 1;

CTrade trade;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderEntity
  {


public:
   void              init(VolumeForceEntity &VolumeForce, OrderTypeEntity &OrderType)
     {
      if(this.isOpenedOrders())
        {
         ENUM_POSITION_TYPE      type;
         MqlTick last_tick;
         SymbolInfoTick(Symbol(),last_tick);
         
         for(int i=0; i<PositionsTotal(); i++)
           {
            ulong PosTicket = PositionGetTicket(i);
            type = PositionGetInteger(POSITION_TYPE);

            if(PositionGetSymbol(i) == _Symbol)
              {
               if(type == ORDER_TYPE_BUY)
                 {
                  if(
                     VolumeForce.effortResult1.resultBuyPercentual < 52.0
                     || VolumeForce.hurstExponent < 0.50
                  )
                    {
                     trade.PositionClose(PosTicket);
                    }
                 }
               if(type == ORDER_TYPE_SELL)
                 {
                  if(
                     VolumeForce.effortResult1.resultSellPercentual < 52.0
                     || VolumeForce.hurstExponent < 0.50
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
         if(OrderType.orderType == ORDER_TYPE_BUY)
           {
            trade.Buy(volumeOrder, _Symbol);
           }
         if(OrderType.orderType == ORDER_TYPE_SELL)
           {
            trade.Sell(volumeOrder, _Symbol);
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

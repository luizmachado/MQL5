//+------------------------------------------------------------------+
//|                                                     RosieBot.mq5 |
//|                                           Copyright 2018, VANTTO |
//|                                        https://www.vantto.com.br |
//+------------------------------------------------------------------+
#include<Trade\Trade.mqh>
CTrade  trade; 


int   h_macd = INVALID_HANDLE;
input double   lotes = 0.02;
input int tprofit = 90;
input int sloss = 10;
bool venda = true;


double   macd1_buffer[];
double   macd2_buffer[];

void OnTick()
  {
  double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
  double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
  double takeprofit = (Bid-tprofit*Point());
  double saveloss = (Ask+sloss*Point());
  
  Comment("Ask = ",(Ask),"\n","Bid = ",(Bid));
   
   if(CruzMACD() == 1)
     {
     venda = true;
     }
   else if(CruzMACD() == -1 && venda == true)
     {
      trade.Sell((lotes),NULL,Ask,saveloss,takeprofit,NULL);
      venda = false;
     }
  }
  
  



int CruzMACD()
  {
   int sig=0;

   if(h_macd==INVALID_HANDLE)
     {
      h_macd=iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE);
      return(0);
     }
   else
     {
      if(CopyBuffer(h_macd,0,0,2,macd1_buffer)<2)
         return(0);
      if(CopyBuffer(h_macd,1,0,3,macd2_buffer)<3)
         return(0);
      if(!ArraySetAsSeries(macd1_buffer,true))
         return(0);
      if(!ArraySetAsSeries(macd2_buffer,true))
         return(0);
     }

//--- check the condition and set a value for sig
   if(macd2_buffer[2]>macd1_buffer[1] && macd2_buffer[1]<macd1_buffer[1])
      sig=1;
   else if(macd2_buffer[2]<macd1_buffer[1] && macd2_buffer[1]>macd1_buffer[1])
      sig=-1;
   else sig=0;

//--- return the trade signal
   return(sig);
  }
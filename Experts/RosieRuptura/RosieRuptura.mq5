//+------------------------------------------------------------------+
//|                                                     RosieBot.mq5 |
//|                                           Copyright 2018, VANTTO |
//|                                        https://www.vantto.com.br |
//+------------------------------------------------------------------+
#include<Trade\Trade.mqh>
CTrade  trade; 



input double   lotes = 0.02;
input int tprofit = 90;
input int sloss = 10;
bool venda = true;

int   h_pc = INVALID_HANDLE;
double   pc1_buffer[];
double   pc2_buffer[];
double   Close[];



void OnTick()
  {
  double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
  double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
  double Last = SymbolInfoDouble(_Symbol,SYMBOL_LAST);
  double takeprofit = (Bid-tprofit*Point());
  double saveloss = (Ask+sloss*Point());
  
  Comment("Ask = ",(Ask),"\n","Bid = ",(Bid),"\n","Cotação = ",(Last));
  

   
   if(rupturapreco() == 1)
     {
     venda = true;
     }
   else if(rupturapreco() == -1 && venda == true)
     {
      trade.Sell((lotes),NULL,Ask,saveloss,takeprofit,NULL);
      venda = false;
     }
  }




int rupturapreco()
  {
   int sig=0;

   if(h_pc==INVALID_HANDLE)
     {
      h_pc=iCustom(Symbol(),Period(),"Downloads/price_channel",22);
      return(0);
     }
   else
     {
      if(CopyBuffer(h_pc,0,0,3,pc1_buffer)<3)
         return(0);
      if(CopyBuffer(h_pc,1,0,3,pc2_buffer)<3)
         return(0);
      if(CopyClose(Symbol(),Period(),0,2,Close)<2)
         return(0);
      if(!ArraySetAsSeries(pc1_buffer,true))
         return(0);
      if(!ArraySetAsSeries(pc2_buffer,true))
         return(0);
      if(!ArraySetAsSeries(Close,true))
         return(0);
     }
//--- check the conditions and set a value for sig
   if(Close[1]>pc1_buffer[2])
      sig=1;
   else if(Close[1]<pc2_buffer[2])
      sig=-1;
   else sig=0;

//--- return the trade signal
   return(sig);
  }
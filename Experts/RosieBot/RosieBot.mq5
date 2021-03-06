//+------------------------------------------------------------------+
//|                                                     RosieBot.mq5 |
//|                                           Copyright 2018, VANTTO |
//|                                        https://www.vantto.com.br |
//+------------------------------------------------------------------+
#include<Trade\Trade.mqh>
CTrade  trade; 


int   h_ma1 = INVALID_HANDLE;
int   h_ma2 = INVALID_HANDLE;
input double   lotes = 0.02;
input int tprofit = 80;
input int sloss = 10;
bool venda = true;


double   ma1_buffer[];
double   ma2_buffer[];

void OnTick()
  {
  double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
  double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
  double takeprofit = (Bid-tprofit*Point());
  double saveloss = (Ask+sloss*Point());
  
  Comment("Ask = ",(Ask),"\n","Bid = ",(Bid));
   
   if(Cruzamento() == 1)
     {
     venda = true;
     }
   else if(Cruzamento() == -1 && venda == true)
     {
      trade.Sell((lotes),NULL,Ask,saveloss,takeprofit,NULL);
      venda = false;
     }
  }
  
  

//--- Cruzamento de médias

  int Cruzamento()
  {
//--- zero means that there is no signal
   int sig=0;

//--- check the handles of indicators
   if(h_ma1==INVALID_HANDLE)//--- if the handle is invalid
     {
      //--- create is again                                                      
      h_ma1=iMA(Symbol(),Period(),3,0,MODE_SMA,PRICE_CLOSE);
      //--- exit from the function
      return(0);
     }
   else //--- if the handle is valid
     {
      //--- copy value of the indicator to the array
      if(CopyBuffer(h_ma1,0,0,3,ma1_buffer)<3) //--- if the array of data is less than required
         //--- exit from the function
         return(0);
      //--- set the indexation in the array as in a timeseries                                   
      if(!ArraySetAsSeries(ma1_buffer,true))
         //--- in case of an indexation error, exit from the function
         return(0);
     }

   if(h_ma2==INVALID_HANDLE)//--- if the handle is invalid
     {
      //--- create it again                                                      
      h_ma2=iMA(Symbol(),Period(),16,0,MODE_SMA,PRICE_CLOSE);
      //--- exit from the function
      return(0);
     }
   else //--- if the handle is valid 
     {
      //--- copy values of the indicator to the array
      if(CopyBuffer(h_ma2,0,0,2,ma2_buffer)<2) //--- if there is less data than required
         //--- exit from the function
         return(0);
      //--- set the indexation in the array as in a timeseries                                   
      if(!ArraySetAsSeries(ma1_buffer,true))
         //--- in case of an indexation error, exit from the function
         return(0);
     }

//--- check the condition and set a value for the sig
   if(ma1_buffer[2]<ma2_buffer[1] && ma1_buffer[1]>ma2_buffer[1])
      sig=1;
   else if(ma1_buffer[2]>ma2_buffer[1] && ma1_buffer[1]<ma2_buffer[1])
      sig=-1;
   else sig=0;

//--- return the trade signal
   return(sig);
  }
  

  
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                     Dunnigan.mq5 |
//|                                           Copyright 2018, VANTTO |
//|                                        https://www.vantto.com.br |
//+------------------------------------------------------------------+
//--- indicator buffers
double         CompraBuffer[];
double         VendaBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,CompraBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,VendaBuffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,159);
   PlotIndexSetInteger(1,PLOT_ARROW,159);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   for(int i=1;i<rates_total;i++)
     {
     if(low[i]<low[i-1] && high[i]<high[i-1])
       {
        VendaBuffer[i]=high[i];
       }
     else
       {
        VendaBuffer[i]=0;
       }
     
     if(low[i]>low[i-1] && high[i]>high[i-1])
       {
        CompraBuffer[i]=low[i];
       }
     else
       {
        CompraBuffer[i]=0;
       }
      
     }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

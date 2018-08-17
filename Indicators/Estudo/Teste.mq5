//+------------------------------------------------------------------+
//|                                                        Teste.mq5 |
//|                                           Copyright 2018, VANTTO |
//|                                        https://www.vantto.com.br |
//+------------------------------------------------------------------+
//--- indicator buffers
double         ABuffer[];
double         BBuffer[];
double         CBuffer[];
double         DBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ABuffer,INDICATOR_DATA);
   SetIndexBuffer(1,BBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,CBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,DBuffer,INDICATOR_DATA);
   
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
   //+------------------------------------------------------------------+
   //| Indicadores com 4 buffers                                                                 |
   //+------------------------------------------------------------------+
   
   for (int i=1; i<rates_total; i++)
   {
   ABuffer[i]=close[i];
   BBuffer[i]=(close[i] + close[i-1]) / 2;
   CBuffer[i]=0;
   DBuffer[i]=0;
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

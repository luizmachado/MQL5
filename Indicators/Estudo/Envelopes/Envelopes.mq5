//+------------------------------------------------------------------+
//|                                                    Envelopes.mq5 |
//|                                           Copyright 2018, VANTTO |
//|                                        https://www.vantto.com.br |
//+------------------------------------------------------------------+
//--- indicator buffers
double         SuperiorBuffer[];
double         InferiorBuffer[];
//--- Variáveis
input int periodos=14;
input double desvio=0.1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SuperiorBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,InferiorBuffer,INDICATOR_DATA);
   PlotIndexSetInteger(0,PLOT_LINE_WIDTH,2);
   PlotIndexSetInteger(1,PLOT_LINE_WIDTH,2);
   
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
 //---
   //+------------------------------------------------------------------+
   //| Indicador Envelope                                              |
   //+------------------------------------------------------------------+
   
   
   for (int i=periodos-1; i<rates_total; i++)
   {
   //---Variaveis do for
    double media=0;
    for(int j=0; j<periodos; j++)
      {
       media = media + close[i-j] / periodos;
      }
   
   //--- Linhas superior/inferior do envelope
   SuperiorBuffer[i]=(media) * (1+desvio/100);
   InferiorBuffer[i]=(media) * (1-desvio/100);
   }  
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

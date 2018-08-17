//+------------------------------------------------------------------+
//|                                                 SetupdoGatao.mq5 |
//|                                           Copyright 2018, VANTTO |
//|                                        https://www.vantto.com.br |
//+------------------------------------------------------------------+
//--- indicator buffers
double         Media_maeBuffer[];
double         MediaaBuffer[];

input int periodo_mae=74;
input int periodo_a=20;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,Media_maeBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,MediaaBuffer,INDICATOR_DATA);
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
   //+------------------------------------------------------------------+
   //| Indicador Envelope                                              |
   //+------------------------------------------------------------------+
   
   
   for (int i=periodo_mae-1; i<rates_total; i++)
   {
   //---Variaveis do for
    double media=0;
    for(int j=0; j<periodo_mae; j++)
      {
       media = media + close[i-j] / periodo_mae;
      }
   
   //--- Linhas superior/inferior do envelope
   Media_maeBuffer[i]=(media);
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

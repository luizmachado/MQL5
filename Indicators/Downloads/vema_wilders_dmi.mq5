//------------------------------------------------------------------
   #property copyright "mladen"
   #property link      "www.forex-tsd.com"
//------------------------------------------------------------------

#property indicator_separate_window
#property indicator_buffers 5
#property indicator_plots   4

#property indicator_label1  "ADX trend"
#property indicator_type1   DRAW_FILLING
#property indicator_color1  C'200,255,180',clrMistyRose
#property indicator_label2  "ADX"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrLimeGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2
#property indicator_label3  "ADXR"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrGold
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2
#property indicator_label4  "Level"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrSilver
#property indicator_style4  STYLE_DOT

//
//
//
//
//

enum enVolume
{
   vol_noVolume,  // do not use volume
   vol_ticks,     // use ticks
   vol_real       // use real volume
};

//
//
//
//
//

input int       AdxPeriod    = 14;        // ADX (DMI) period
input double    AdxLevel     = 20;        // ADX level
input bool      ShowADX      = true;      // ADX visible
input bool      ShowADXR     = false;     // ADXR visible
input enVolume  VolumeType   = vol_ticks; // Volume to use

//
//
//
//
//

double DIp[];
double DIm[];
double ADX[];
double ADXR[];
double Level[];

//------------------------------------------------------------------
//                                                                  
//------------------------------------------------------------------
//
//
//
//
//

int OnInit()
{
   SetIndexBuffer(0,DIp,INDICATOR_DATA);
   SetIndexBuffer(1,DIm,INDICATOR_DATA);
   SetIndexBuffer(2,ADX,INDICATOR_DATA); 
   SetIndexBuffer(3,ADXR,INDICATOR_DATA); 
   SetIndexBuffer(4,Level,INDICATOR_DATA); 

   //
   //
   //
   //
   //
            
   IndicatorSetString(INDICATOR_SHORTNAME," VEMA Wilder''s DMI ("+string(AdxPeriod)+")");
   return(0);
}

//------------------------------------------------------------------
//                                                                  
//------------------------------------------------------------------
//
//
//
//
//


double averages[][9];
#define _Vol  0
#define _DIp  1
#define _DIm  2
#define _TR   3
#define _Adx  4
#define _DIpa 5
#define _DIma 6
#define _TRa  7
#define _Adxa 8

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
{
   if (ArrayRange(averages,0)!=rates_total) ArrayResize(averages,rates_total);

   //
   //
   //
   //
   //
   
   double sf = 1.0/(double)AdxPeriod;
   for (int i=(int)MathMax(prev_calculated-1,1); i<rates_total; i++)
   {
         double currTR  = MathMax(high[i],close[i-1])-MathMin(low[i],close[i-1]);
         double DeltaHi = high[i] - high[i-1];
	      double DeltaLo = low[i-1] - low[i];
         double plusDM  = 0.00;
         double minusDM = 0.00;
         double vol;
         switch(VolumeType)
            {
               case vol_ticks: vol = (double)tick_volume[i]; break;
               case vol_real:  vol = (double)volume[i];      break;
               default:        vol = 1;
            }
            if ((DeltaHi > DeltaLo) && (DeltaHi > 0)) plusDM  = DeltaHi;
            if ((DeltaLo > DeltaHi) && (DeltaLo > 0)) minusDM = DeltaLo;      
         
         //
         //
         //
         //
         //

                     
            averages[i][_Vol]  = averages[i-1][_Vol] + sf*(vol         - averages[i-1][_Vol]);
            averages[i][_DIp]  = averages[i-1][_DIp] + sf*(vol*plusDM  - averages[i-1][_DIp]);
            averages[i][_DIm]  = averages[i-1][_DIm] + sf*(vol*minusDM - averages[i-1][_DIm]);
            averages[i][_TR]   = averages[i-1][_TR]  + sf*(vol*currTR  - averages[i-1][_TR]);
            averages[i][_DIpa] = averages[i][_DIp]/MathMax(averages[i][_Vol],1);
            averages[i][_DIma] = averages[i][_DIm]/MathMax(averages[i][_Vol],1);
            averages[i][_TRa]  = averages[i][_TR] /MathMax(averages[i][_Vol],1);
            Level[i]           = AdxLevel;

         //
         //
         //
         //
         //
                  
            DIp[i]  = 0.00;                   
            DIm[i]  = 0.00;
            ADX[i]  = EMPTY_VALUE;
            ADXR[i] = EMPTY_VALUE;
            if (averages[i][_TRa] > 0)
               {              
                  DIp[i] = 100.00 * averages[i][_DIpa]/averages[i][_TRa];
                  DIm[i] = 100.00 * averages[i][_DIma]/averages[i][_TRa];
               }            

            if(ShowADX)
               {
                  double DX;
                  if((DIp[i] + DIm[i])>0) 
                       DX = 100*MathAbs(DIp[i] - DIm[i])/(DIp[i] + DIm[i]); 
                  else DX = 0.00;
                  averages[i][_Adx]  = averages[i-1][_Adx]+ sf*(vol*DX - averages[i-1][_Adx]);
                  averages[i][_Adxa] = averages[i][_Adx]/MathMax(averages[i][_Vol],1);
                  ADX[i] = averages[i][_Adxa];
                  if(ShowADXR && i>=AdxPeriod)
                         ADXR[i] = 0.5*(ADX[i] + ADX[i-AdxPeriod]);
               }
      }   
   return(rates_total);
}
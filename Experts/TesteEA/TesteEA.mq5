int OnInit(void)
  {
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
int start = 0; // bar index
int count = 1; // number of bars
datetime tm[]; // array storing the returned bar time
//--- copy time 
CopyTime(_Symbol,PERIOD_D1,start,count,tm);
//--- output result
MqlDateTime stm;
TimeToStruct(tm[0],stm);
Alert(stm.hour);
  }
//+------------------------------------------------------------------+

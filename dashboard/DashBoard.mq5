//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+

bool inp_back=true;//Back
uchar inp_scale_transparency=10;//Scale transparency, 0..255
uchar inp_needle_transparency=10;//Needle transparency, 0..255

#include <Gauge\gauge_graph.mqh>
#include "../entities/VolumeForceEntity.mq5";

//--- declaration of the gauge structure array
GAUGE_STR gg[3];

int handle_ATR,handle_RSI,handle_Force;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int DashInit() {
   //--- building the gg00 gauge, TREND
   if(GaugeCreate("gg00",gg[0],5,-90,240,"",RELATIVE_MODE_NONE,
                  CORNER_LEFT_LOWER,inp_back,inp_scale_transparency,inp_needle_transparency)==false)
      return(INIT_FAILED);
   //--- setting body parameters
   GaugeSetCaseParameters(gg[0],CASE_SECTOR,DEF_COL_CASE,CASE_BORDER_THIN,DEF_COL_BORDER,SIZE_MIDDLE);
   //--- setting parameters of the scale and marks on the scale
   GaugeSetScaleParameters(gg[0],120,35,-200,200,MUL_1,SCALE_INNER,clrBlack);
   GaugeSetMarkParameters(gg[0],MARKS_INNER,SIZE_MIDDLE,50,1,2);
   GaugeSetMarkLabelFont(gg[0],SIZE_MIDDLE,"Ubuntu",false,false,DEF_COL_MARK_FONT);
   //--- highlighting ranges on the scale
   GaugeSetRangeParameters(gg[0],0,true,10,200,clrLimeGreen);
   GaugeSetRangeParameters(gg[0],1,true,-10,-200,clrCoral);
   //--- setting text labels
   GaugeSetLegendParameters(gg[0],LEGEND_DESCRIPTION,true,"TREND",4,15,12,"Ubuntu",false,false);
   GaugeSetLegendParameters(gg[0],LEGEND_VALUE,true,"0",3,80,16,"Ubuntu",true,false);
   GaugeSetLegendParameters(gg[0],LEGEND_MUL,true,"",4,55,8,"Ubuntu",true,false);
   //--- setting needle parameters
   GaugeSetNeedleParameters(gg[0],NDCS_SMALL,DEF_COL_NCENTER,DEF_COL_NEEDLE,NEEDLE_FILL_AA);
   //---
   //--- building the gg01 gauge, result total
   if(GaugeCreate("gg01",gg[1],-80,20,320,"gg00",RELATIVE_MODE_HOR,
                  CORNER_LEFT_LOWER,inp_back,inp_scale_transparency,inp_needle_transparency)==false)
      return(INIT_FAILED);
   //--- setting body parameters
   GaugeSetCaseParameters(gg[1],CASE_SECTOR,DEF_COL_CASE,CASE_BORDER_THIN,DEF_COL_BORDER,SIZE_MIDDLE);
   //--- setting parameters of the scale and marks on the scale
   GaugeSetScaleParameters(gg[1],200,0, 0,100,MUL_1,SCALE_INNER,clrBlack);
   GaugeSetMarkParameters(gg[1],MARKS_INNER,SIZE_MIDDLE,10,1,4);
   GaugeSetMarkLabelFont(gg[1],SIZE_MIDDLE,"Ubuntu",false,false,DEF_COL_MARK_FONT);
   //--- highlighting ranges on the scale
   GaugeSetRangeParameters(gg[1],0,true,55,100,clrLimeGreen);
   GaugeSetRangeParameters(gg[1],1,true,45,0,clrCoral);
   GaugeSetRangeParameters(gg[1],2,true,45,55,clrDarkMagenta);
   //--- setting text labels
   GaugeSetLegendParameters(gg[1],LEGEND_DESCRIPTION,true,"Result",3,0,16,"Ubuntu",false,false);
   GaugeSetLegendParameters(gg[1],LEGEND_UNITS,true,"%",3,-90,10,"Ubuntu",true,false);
   GaugeSetLegendParameters(gg[1],LEGEND_VALUE,true,"1",3,90,12,"Ubuntu",true,false);
   //--- setting needle parameters
   GaugeSetNeedleParameters(gg[1],NDCS_SMALL,DEF_COL_NCENTER,DEF_COL_NEEDLE,NEEDLE_FILL_AA);
   //---
   //--- building the gg02 gauge, iForce 
   if(GaugeCreate("gg02",gg[2],-80,-20,240,"gg01",RELATIVE_MODE_HOR,
                  CORNER_LEFT_LOWER,inp_back,inp_scale_transparency,inp_needle_transparency)==false)
      return(INIT_FAILED);
   //--- setting body parameters
   GaugeSetCaseParameters(gg[2],CASE_SECTOR,DEF_COL_CASE,CASE_BORDER_THIN,DEF_COL_BORDER,SIZE_MIDDLE);
   //--- setting parameters of the scale and marks on the scale
   GaugeSetScaleParameters(gg[2],120,-35,-400,400,MUL_1,SCALE_INNER,clrBlack);
   GaugeSetMarkParameters(gg[2],MARKS_INNER,SIZE_MIDDLE,100,1,4);
   GaugeSetMarkLabelFont(gg[2],SIZE_MIDDLE,"Ubuntu",false,false,DEF_COL_MARK_FONT);
   //--- highlighting ranges on the scale
   GaugeSetRangeParameters(gg[2],0,true,-400,-10,clrCornflowerBlue);
   GaugeSetRangeParameters(gg[2],1,true,10,400,clrLimeGreen);
   //--- setting text labels
   GaugeSetLegendParameters(gg[2],LEGEND_DESCRIPTION,true,"iForce",4,-15,14,"Ubuntu",false,false);
   GaugeSetLegendParameters(gg[2],LEGEND_VALUE,true,"0",3,-80,16,"Ubuntu",true,false);
   //--- setting needle parameters
   GaugeSetNeedleParameters(gg[2],NDCS_SMALL,DEF_COL_NCENTER,DEF_COL_NEEDLE,NEEDLE_FILL_AA);
   
   
   //--- drawing gauges
   for(int i=0; i<ArraySize(gg); i++) {
      GaugeRedraw(gg[i]);
      GaugeNewValue(gg[i],0);
   }
   //---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void DashDeinit(const int reason) {
   //--- deleting gauges
   for(int i=0; i<ArraySize(gg); i++)
      GaugeDelete(gg[i]);
   ChartRedraw();
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void DashCalculate(VolumeForceEntity &VolumeForce) {
   // RESULT
    
    Print("VolumeForce.iForceIndexToOpen[0] " + VolumeForce.iForceIndexToOpen[0]);
    Print("VolumeForce.iForceIndexToClose[0] " + VolumeForce.iForceIndexToClose[0]);
    
   GaugeNewValue(gg[0],VolumeForce.iForceIndexToOpen[0]);
   GaugeNewValue(gg[1],VolumeForce.effortResult1.effortBuyPercentual);
   GaugeNewValue(gg[2],VolumeForce.iForceIndexToClose[0]);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+

bool inp_back=false;//Back
uchar inp_scale_transparency=0;//Scale transparency, 0..255
uchar inp_needle_transparency=0;//Needle transparency, 0..255

#include <Gauge\gauge_graph.mqh>
#include "../entities/VolumeForceEntity.mq5";

//--- declaration of the gauge structure array
GAUGE_STR gg[6];

int handle_ATR,handle_RSI,handle_Force;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int DashInit()
  {
//--- building the gg00 gauge, TREND
   if(GaugeCreate("gg00",gg[0],5,-90,240,"",RELATIVE_MODE_NONE,
                  CORNER_LEFT_LOWER,inp_back,inp_scale_transparency,inp_needle_transparency)==false)
      return(INIT_FAILED);
//--- setting body parameters
   GaugeSetCaseParameters(gg[0],CASE_SECTOR,DEF_COL_CASE,CASE_BORDER_THIN,DEF_COL_BORDER,SIZE_MIDDLE);
//--- setting parameters of the scale and marks on the scale
   GaugeSetScaleParameters(gg[0],120,35,0,100,MUL_100,SCALE_INNER,clrBlack);
   GaugeSetMarkParameters(gg[0],MARKS_INNER,SIZE_MIDDLE,20,1,4);
   GaugeSetMarkLabelFont(gg[0],SIZE_MIDDLE,"Ubuntu",false,false,DEF_COL_MARK_FONT);
//--- highlighting ranges on the scale
   GaugeSetRangeParameters(gg[0],0,true,55,100,clrLimeGreen);
   GaugeSetRangeParameters(gg[0],1,true,45,0,clrCoral);
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
   GaugeSetScaleParameters(gg[1],200,0,0,100,MUL_1,SCALE_INNER,clrBlack);
   GaugeSetMarkParameters(gg[1],MARKS_INNER,SIZE_MIDDLE,100,1,4);
   GaugeSetMarkLabelFont(gg[1],SIZE_MIDDLE,"Ubuntu",false,false,DEF_COL_MARK_FONT);
//--- highlighting ranges on the scale
   GaugeSetRangeParameters(gg[1],0,true,55,100,clrLimeGreen);
   GaugeSetRangeParameters(gg[1],1,true,45,0,clrCoral);
//--- setting text labels
   GaugeSetLegendParameters(gg[1],LEGEND_DESCRIPTION,true,"Result",3,0,16,"Ubuntu",false,false);
   GaugeSetLegendParameters(gg[1],LEGEND_UNITS,true,"PTS",3,-90,10,"Ubuntu",true,false);
   GaugeSetLegendParameters(gg[1],LEGEND_VALUE,true,"1",3,90,12,"Ubuntu",true,false);
//--- setting needle parameters
   GaugeSetNeedleParameters(gg[1],NDCS_SMALL,DEF_COL_NCENTER,DEF_COL_NEEDLE,NEEDLE_FILL_AA);
//---
//--- building the gg02 gauge, effort1
   if(GaugeCreate("gg02",gg[2],-80,-20,240,"gg01",RELATIVE_MODE_HOR,
                  CORNER_LEFT_LOWER,inp_back,inp_scale_transparency,inp_needle_transparency)==false)
      return(INIT_FAILED);
//--- setting body parameters
   GaugeSetCaseParameters(gg[2],CASE_SECTOR,DEF_COL_CASE,CASE_BORDER_THIN,DEF_COL_BORDER,SIZE_MIDDLE);
//--- setting parameters of the scale and marks on the scale
   GaugeSetScaleParameters(gg[2],120,-35,100,0,MUL_1,SCALE_INNER,clrBlack);
   GaugeSetMarkParameters(gg[2],MARKS_INNER,SIZE_MIDDLE,20,1,4);
   GaugeSetMarkLabelFont(gg[2],SIZE_MIDDLE,"Ubuntu",false,false,DEF_COL_MARK_FONT);
//--- highlighting ranges on the scale
   GaugeSetRangeParameters(gg[2],0,true,45,0,clrCoral);
   GaugeSetRangeParameters(gg[2],1,true,55,100,clrLimeGreen);
//--- setting text labels
   GaugeSetLegendParameters(gg[2],LEGEND_DESCRIPTION,true,"Power",4,-15,14,"Ubuntu",false,false);
   GaugeSetLegendParameters(gg[2],LEGEND_VALUE,true,"0",3,-80,16,"Ubuntu",true,false);
//--- setting needle parameters
   GaugeSetNeedleParameters(gg[2],NDCS_SMALL,DEF_COL_NCENTER,DEF_COL_NEEDLE,NEEDLE_FILL_AA);
//---
//--- building the gg03 gauge, Hurst
   if(GaugeCreate("gg03",gg[3],30,0,180,"gg00",RELATIVE_MODE_VERT,
                  CORNER_LEFT_LOWER,inp_back,inp_scale_transparency,inp_needle_transparency)==false)
      return(INIT_FAILED);
//--- setting body parameters
   GaugeSetCaseParameters(gg[3],CASE_ROUND,DEF_COL_CASE,CASE_BORDER_THIN,DEF_COL_BORDER,SIZE_MIDDLE);
//--- setting parameters of the scale and marks on the scale
   GaugeSetScaleParameters(gg[3],270,45,0,1,MUL_1,SCALE_INNER,clrBlack);
   GaugeSetMarkParameters(gg[3],MARKS_INNER,SIZE_LARGE,1,9,3);
   GaugeSetMarkLabelFont(gg[3],SIZE_LARGE,"Ubuntu",false,false,DEF_COL_MARK_FONT);
//--- highlighting ranges on the scale
   //GaugeSetRangeParameters(gg[3],0,true,0.4,0,clrYellow);
   GaugeSetRangeParameters(gg[3],1,true,0.55,0.4,clrAquamarine);
   GaugeSetRangeParameters(gg[3],2,true,1,0.55,clrLimeGreen);
//--- setting text labels
   GaugeSetLegendParameters(gg[3],LEGEND_DESCRIPTION,true,"R/S",7,-140,26,"Ubuntu",false,false);
   GaugeSetLegendParameters(gg[3],LEGEND_VALUE,true,"5",2,180,14,"Ubuntu",true,false);
   GaugeSetLegendParameters(gg[3],LEGEND_MUL,true,"",2,0, 5,"Ubuntu",true,false);
//--- setting needle parameters
   GaugeSetNeedleParameters(gg[3],NDCS_SMALL,DEF_COL_NCENTER,DEF_COL_NEEDLE,NEEDLE_FILL_AA);
//---
//--- building the gg04 gauge, RSI
   if(GaugeCreate("gg04",gg[4],-30,0,180,"gg02",RELATIVE_MODE_VERT,
                  CORNER_LEFT_LOWER,inp_back,inp_scale_transparency,inp_needle_transparency)==false)
      return(INIT_FAILED);
//--- setting body parameters
   GaugeSetCaseParameters(gg[4],CASE_ROUND,DEF_COL_CASE,CASE_BORDER_THIN,DEF_COL_BORDER,SIZE_MIDDLE);
//--- setting parameters of the scale and marks on the scale
   GaugeSetScaleParameters(gg[4],270,45,0,100,MUL_10,SCALE_INNER,clrBlack);
   GaugeSetMarkParameters(gg[4],MARKS_INNER,SIZE_LARGE,10,1,4);
   GaugeSetMarkLabelFont(gg[4],SIZE_LARGE,"Ubuntu",false,false,DEF_COL_MARK_FONT);
//--- setting text labels
   GaugeSetLegendParameters(gg[4],LEGEND_DESCRIPTION,true,"RSI",7,-140,26,"Ubuntu",false,false);
   GaugeSetLegendParameters(gg[4],LEGEND_VALUE,true,"2",2,180,16,"Ubuntu",true,false);
   GaugeSetLegendParameters(gg[4],LEGEND_MUL,true,"",2,0,20,"Ubuntu",true,false);
//--- setting needle parameters
   GaugeSetNeedleParameters(gg[4],NDCS_SMALL,DEF_COL_NCENTER,DEF_COL_NEEDLE,NEEDLE_FILL_AA);
//---
//--- building the gg05 gauge, Force
   if(GaugeCreate("gg05",gg[5],-10,60,180,"gg03",RELATIVE_MODE_HOR,
                  CORNER_LEFT_LOWER,inp_back,inp_scale_transparency,inp_needle_transparency)==false)
      return(INIT_FAILED);
//--- setting body parameters
   GaugeSetCaseParameters(gg[5],CASE_ROUND,DEF_COL_CASE,CASE_BORDER_THIN,DEF_COL_BORDER,SIZE_MIDDLE);
//--- setting parameters of the scale and marks on the scale
   GaugeSetScaleParameters(gg[5],270,45,0,100,MUL_1,SCALE_INNER,clrBlack);
   GaugeSetMarkParameters(gg[5],MARKS_INNER,SIZE_LARGE,10,1,100);
   GaugeSetMarkLabelFont(gg[5],SIZE_LARGE,"Ubuntu",false,false,DEF_COL_MARK_FONT);
//--- highlighting ranges on the scale
   GaugeSetRangeParameters(gg[5],0,true,45,0,clrCrimson);
   GaugeSetRangeParameters(gg[5],1,true,55,100,clrMediumSeaGreen);
//--- setting text labels
   GaugeSetLegendParameters(gg[5],LEGEND_DESCRIPTION,true,"Effort",7,-140,20,"Ubuntu",false,false);
   GaugeSetLegendParameters(gg[5],LEGEND_VALUE,true,"5",2,180,14,"Ubuntu",true,false);
   GaugeSetLegendParameters(gg[5],LEGEND_MUL,true,"",3,0,10,"Ubuntu",true,false);
//--- setting needle parameters
   GaugeSetNeedleParameters(gg[5],NDCS_SMALL,DEF_COL_NCENTER,DEF_COL_NEEDLE,NEEDLE_FILL_AA);
//---
//--- drawing gauges
   for(int i=0; i<6; i++)
     {
      GaugeRedraw(gg[i]);
      GaugeNewValue(gg[i],0);
     }

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void DashDeinit(const int reason)
  {
//--- deleting gauges
   for(int i=0; i<6; i++)
      GaugeDelete(gg[i]);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void DashCalculate(VolumeForceEntity &VolumeForce)
  {
   GaugeNewValue(gg[0],VolumeForce.effortResult1.resultBuyPercentual);
   GaugeNewValue(gg[1],VolumeForce.effortResult4.effortBuyPercentual);
   GaugeNewValue(gg[2],VolumeForce.effortResult1.effortBuyPercentual);
   // HURST
   GaugeNewValue(gg[3],VolumeForce.hurstExponent);
   GaugeNewValue(gg[5],VolumeForce.effortResult1.effortBuyPercentual);
   
  }
//+------------------------------------------------------------------+

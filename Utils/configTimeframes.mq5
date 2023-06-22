//+------------------------------------------------------------------+
//|                                                       Oraculo_EA |
//|                                                   Vagner Ribeiro |
//|                                          https://w3dsoftware.com |
//+------------------------------------------------------------------+

string TimeFrameToString() {
   int tf = _Period;
   string description = "";
   
   switch(tf)
     {
      case 1: 
        description = "M1";
        break;
      case 2: 
        description = "M2";
        break;        
      case 3: 
        description = "M3";
        break;
      case 5: 
        description = "M5";
        break;
      case 15: 
        description = "M15";
        break;        
      case 30: 
        description = "M30";
        break;                
      case 16385: 
        description = "H1";
        break;        
      case 16386: 
        description = "H2";
        break;                
      case 16388: 
        description = "H4";
        break;             
      case 16408: 
        description = "D1";
        break;                       
      case 32769: 
        description = "W1";
        break;             
      case 49153: 
        description = "MN";
        break;                  
      default:
      description = (string)tf;
        break;
     }
     
     return description;

}
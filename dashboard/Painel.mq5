#include <Controls/Dialog.mqh>
#include <Controls/Label.mqh>
#include <Controls/Panel.mqh>


int panel_X = 30;
int panel_Y = 30;

int panelWidth = 300;
int panelHeight = 500;


class Painel {


   CAppDialog panel;
   CPanel buy;

public:

   void init() {
   
      panel.Create(0, "Oráculo EA", 0, panel_X, panel_Y, panelWidth, panelHeight);
      panel.Run();
   }
   
   void PanelDeInit(const int reason) {
      panel.Destroy(reason);
   }

};
#property copyright "Copyright © 2012-2022, Johan van Wyk"
#property link      "http://www.pipgenius.com/"

#include <stdlib.mqh>
#include <WinUser32.mqh>

double stoplevel;
int a=0;

int    Slippage    = 5;
bool   MM          = TRUE;//Money managament
int    Risk        = 2;//Risk %
double TakeProfit_ma  = 38.5;//Take proft in pips
double StopLoss_ma    = 48.5;//Stop loss in pips
ENUM_TIMEFRAMES MovingTf = PERIOD_H4;//Moving time frame
ENUM_MA_METHOD MovingMode = MODE_SMA;//Moving mode
int     MovingPeriod  =49;//Moving average period
int     MovingShift   =0;//Moving average shift
//--
double Lots,SL_ma,TP_ma,indi;
bool   rv=false;

//-- Orders to be opened
#define  PendingOrders        5                       // Amount of pending orders to be added

//-- Money management
#define  MoneyManagement      1                       // Use Money Management
#define  LotSize              0.1                     // If not, use this lotsize
#define  RiskPercent          2                       // Risk for initial trade
#define  RiskDecrease         0.5                     // Risk decrease for the next trade

//-- ATR and multipliers
#define  ATRPeriod            30                      // ATR Period to use
#define  ATRStopMultiplier    2                       // Multiplier for the initial stop-loss
#define  ATROrderMultiplier   0.5                     // Multiplier for further pending orders

//-- Don't change me
//#define  ShortName            "PZ Proggresive Buy Stop"
#define  MagicNumber          0
#define  Slippage             6
#define  Shift                1

//-- Internal
double   LastOrderLots = EMPTY_VALUE;
double   LastOrderPrice;
double   DecimalPip;

int gi_76 = 0;
string g_time2str_80 = "";
int gi_88 = 12;
int gi_92 = 6;
bool gi_96 = TRUE;
bool gi_100 = FALSE;
bool ShowAlerts = TRUE;
int g_fontsize_108 = 14;
color ElliotWaves = Yellow;
int g_color_116 = Red;
double gd_120 = 0.0;

//+------------------------------------------------------------------+
extern string note = "To do a back test use EURUSD D1";
string note_a = "Number of pairs to trade with (1....24) Be discreet"; 
int amount = 1;
int Amount = 25;
double Growth_needed_to_TP = 0;
double teller;
extern double StartLot = 0.01;
//extern bool Scalper = true;
int magic = 0;
int ticket;
extern string Name = "Ultima";
extern int         Start_Hour = 0;
extern int         Finish_Hour = 24;
int Stoploss; 
int Takeprofit;
string      note_b="********* Gap between Orders **********";
int Gap_between_Orders = 5;
extern bool   Martingale = FALSE;
extern bool Increment = true;
int Levels = 30;
double    multiplier=2;;
double increment;
string      note_c="********* Money Management **********";
double Max_Lotsize = 100;
double Minimum_Equity_Allowed;
//+------------------------------------------------------------------+
string           InpName="Button1";            // Button name
string           InpName2="Button2";            // Button name
string           InpName3="Button3";            // Button name
string           InpName4="Button4";            // Button name
string           InpName5="Button5";            // Button name
string           InpName6="Button6";            // Button name
string           InpName7="Button7";            // Button name
string           InpName8="Button8";            // Button name
string           InpName9="Button9";            // Button name
string           InpName10="Button10";            // Button name
string           InpName11="Button11";            // Button name
string           InpName12="Button12";            // Button name
string           InpName13="Button13";            // Button name
string           InpName14="Button14";            // Button name
string           InpName15="Button15";            // Button name
string           InpName16="Button16";            // Button name
string           InpName17="Button17";            // Button name
string           InpName18="Button18";            // Button name
string           InpName19="Button19";            // Button name
string           InpName20="Button20";            // Button name
string           InpName21="Button21";            // Button name
string           InpName22="Button22";            // Button name
string           InpName23="Button23";            // Button name
string           InpName24="Button24";            // Button name
string           InpName25="Button25";            // Button name
string           InpName26="Button26";            // Button name
string           InpName27="Button27";            // Button name
string           InpName28="Button28";            // Button name
string           InpName29="Button29";            // Button name
string           InpName30="Button30";            // Button name
string           InpName31="Button31";            // Button name
string           InpName32="Button32";            // Button name
string           InpName33="Button33";            // Button name
string           InpName34="Button34";            // Button name
string           InpName35="Button35";            // Button name
string           InpName36="Button36";            // Button name
string           InpName37="Button37";            // Button name
string           InpName38="Button38";            // Button name
string           InpName39="Button39";            // Button name
string           InpName40="Button40";            // Button name
string           InpName41="Button41";            // Button name
string           InpName42="Button42";            // Button name
string           InpName43="Button43";            // Button name
string           InpName44="Button44";            // Button name
string           InpName45="Button45";            // Button name
string           InpName46="Button46";            // Button name
string           InpName47="Button47";            // Button name
string           InpName48="Button48";            // Button name
string           InpName49="Button49";            // Button name

string           InpName50="Button50";            // Button name
string           InpName51="Button51";            // Button name
string           InpName52="Button52";            // Button name
string           InpName53="Button53";            // Button name
string           InpName54="Button54";            // Button name

string           InpName55="Button55";            // Button name
string           InpName56="Button56";            // Button name
string           InpName57="Button57";            // Button name
string           InpName58="Button58";            // Button name
string           InpName59="Button59";            // Button name
string           InpName60="Button60";            // Button name

input ENUM_BASE_CORNER InpCorner=CORNER_LEFT_UPPER;// Chart corner for anchoring
string           InpFont="Arial";             // Font
int             InpFontSize=8;              // Font size
input color            InpColor=clrYellow;           // Text color
input color            InpBackColor=clrDarkSlateGray; // Background color
color            InpBorderColor=clrNONE;      // Border color
bool             InpState=true;              // Pressed/Released
bool             InpBack=false;               // Background object
bool             InpSelection=false;          // Highlight to move
bool             InpHidden=true;              // Hidden in the object list
long             InpZOrder=0;                 // Priority for mouse click

string s1;
string s2;
string s3;
string s4;
string s5;
string s6;
string s7;
string s8;
string s9;
string s10;
string s11;
string s12;
string s13;
string s14;
string s15;
string s16;
string s17;
string s18;
string s19;
string s20;
string s21;
string s22;
string s23;
string s24;
string s25;
string s26;
string s27;
string s28;

int lenght = 100;
int height = 20;
int x = 110,y = 30;   

extern color Background_Colour = clrDarkGray;
extern color Currency_in_profit = clrGreenYellow;
extern color Currency_in_loss = clrMaroon;
extern color Information = clrBlack;
extern color Candle_Time = clrGold;
color pivotColor = White;
color pivotlevelColor = White;
int TrailingStop = 15;
int NewTakeProfit = 30;
string      note_d="******** Signals ********";
string Symbol_Name = "Symbol name + extension";
string Order_Type = "Buy / Sell";
string Signal_Lot = "Lot size";
string Entry = "0 For current price";
string takeprofit = "0";
string stoploss = "0";

double PriceOffset = 15;
double PriceOffset2;
int Expiration = 0,op2 = 0,af2 = 0;
double PipValue=1;    // this variable is here to support 5-digit brokers
bool Terminated = false;
string LF = "\n";  // use this in custom or utility blocks where you need line feeds
int NDigits = 4;   // used mostly for NormalizeDouble in Flex type blocks
int ObjCount = 0;  // count of all objects created on the chart, allows creation of objects with unique names
int current = 0;   // current bar index, used by Cross Up, Cross Down and many other blocks
int varylots[101]; // used by Buy Order Varying, Sell Order Varying and similar
int tel;
datetime BarTime83 = 0;

int ExpectedTime74 = 0;
double wins;
int meeste = 0;
double Eqty,eqt_waarde,Balans,hoogste_balans = 0,hoogste_balans2 = 0;
double    range;
int       level=100;
bool      delete_PO=false;
double pt;
int prec=0;
double minlot;
string bullbear = "";
string pattern = "",pattern135,pattern136,pattern135abc;
string nuwe_simbool = "";
int tf2;

string trends;
double maxloss = 0;
double lastlot;

string bullbear63="";
string bullbearfibo="";

string                     ExtraSymbolChar;
string                     dash;
bool vlag = false;
enum t
  {
   b=1,     // by extremums of candlesticks
   c=2,     // by fractals
   d=3,     // by ATR indicator
   e=4,     // by Parabolic indicator
   f=5,     // by MA indicator
   g=6,     // by profit % 
   i=7,     // by points
  };
//+------------------------------------------------------------------+
//|                                                                  |
//-+------------------------------------------------------------------+
enum tf
  {
   af=0,     // current
   bf=1,     // 1 minute 
   cf=2,     // 5 minutes
   df=3,     // 15 minutes
   ef=4,     // 30 minutes
   ff=5,     // 1 hour
   gf=6,     // 4 hours
   hf=7,     // 1 day
  };
//+------------------------------------------------------------------+
bool    VirtualTrailingStop=false;  // Virtual trailing stop
t   parameters_trailing=i;      // Trailing method
int     delta=50;        // Offset from the stop loss calculation level
tf       TF_Tralling=af;  // Timeframe of the indicators (0-current)
int     StepTrall=1;     // Stop loss movement step1
int     StartTrall=1;    // Minimal profit of trailing stop in points
bool    GeneralNoLoss=true; // Trailing from breakeven point
int     Magic=-1; // Which magic to trail (-1 all)
color   text_color=Lime;  // Information output color
string Advanced_Options="";
 int     period_ATR=14;// ATR period (method 3)
 double Step=0.02;   // Parabolic Step (method 4)
 double Maximum=0.2; // Parabolic Maximum (method 4)
 int ma_period=34; // MA period (method 5)
 ENUM_MA_METHOD ma_method=MODE_SMA; // Averaging method (method 5)
 ENUM_APPLIED_PRICE applied_price=PRICE_CLOSE; // Price type (method 5)
 double PercetnProfit=50; // Percent of profit (method 6)
//---
int TF[10]={0,1,5,15,30,60,240,1440,10080,43200};
int STOPLEVEL;
string val,simboolnaam;
double SLB=0,SLS=0,ask,bid;
int slippage=100,dag;

double highest_profit = 0,buy_max,sell_max;
int    min_gapsize = 1;
datetime order_time = 0;
bool oppositeclose=false;          // close the orders on an opposite signal
bool reversesignals=false;        // reverse the signals, long if short, short if long
int maxtrades=1;                // maximum trades allowed by the traders
int tradesperbar=1;               // maximum trades per bar allowed by the expert
bool hidesl=false;                // hide stop loss
bool hidetp=false;                // hide take profit
int stoploss3=123;                   // stop loss
int takeprofit3=100;                 // take profit
int breakevengain=0;              // gain in pips required to enable the break even
int breakeven=0;                  // break even
double maxspread=100;                    // maximum spread allowed by the expert

bool entrance,buy_fibo,buy_predict,sell_fibo,sell_predict;
double take_profit,stop_loss;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
{
//********************************************************************************************************************************************
   ObjectsDeleteAll();      // clear the chart
   ChartSetInteger(0,CHART_BRING_TO_TOP,true);
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,Background_Colour);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,true);
   ChartSetInteger(0,CHART_COLOR_ASK,clrRed);
   ChartSetInteger(0,CHART_SHOW_BID_LINE,true);
   ChartSetInteger(0,CHART_COLOR_BID,clrBlue);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrRed);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrBlack);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrBlue);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrBlack);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrBlack);
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrBlack);
   ChartSetInteger(0,CHART_FOREGROUND,false);//Ценовой график на переднем плане
   ChartSetInteger(0,CHART_SHIFT,true);//Режим отступа ценового графика от правого края
   ChartSetInteger(0,CHART_AUTOSCROLL,true);//Режим автоматического перехода к правому краю графика
   ChartSetInteger(0,CHART_SHOW_LAST_LINE,true);//РОтображение значения Last горизонтальной линией на графике
   ChartSetInteger(0,CHART_COLOR_LAST,clrBlue);
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
   ChartSetInteger(0,CHART_COLOR_VOLUME,clrBlack);   
   nuwe_simbool = Symbol();
   hoogste_balans=AccountBalance();
   teller = 0;
   hoogste_balans2 = hoogste_balans;
   return (0);
}

int deinit()
{
    ObjectsDeleteAll();
    
    return (0);
}
   
int start()
{
//     OnScreen("multi","EA will trade with any currency which is chosen",15,2,300,50,clrWhite);
    OnScreen("support","<edengrain9@gmail.com>",9,2,300,10,clrWhite);
   entrance = false;
   if(IsDemo()) entrance = true; 

//   if (!entrance) {OnScreen("demo","EA only work in Demo mode",15,2,300,30,clrWhite);return;;}
    if (IsTesting()) {Amount = 1;}//OnScreen("support","EA is Multi - Currency and can not be backtested !!!!",9,2,300,10,clrWhite);Print("EA is Multi - Currency and can not be backtested !!!!");return(0);}
    if (!IsTesting()) Button();
    OnScreen("support","<edengrain9@gmail.com>",9,2,300,10,clrWhite);

    int x1 = 10;
    int x2 = 450;
    int x3 = 900;


   // Detects extra characters after symbol name.
   ExtraSymbolChar = StringSubstr(Symbol(), 6, 10);
   
   // Detects a dash in middle of symbol name.
   if (StringSubstr(Symbol(), 4, 1) == "-") dash = "-";
   else dash = "";

//   if (Amount > 0)    alerts2("Ethereum.a",x1,20,"B");
   if (Amount > 0)    alerts2("EUR" + dash + "USD" + ExtraSymbolChar,x1,20,"B");
   if (Amount > 1)    alerts2("GBP" + dash + "USD" + ExtraSymbolChar,x1,40,"B");
   if (Amount > 2)    alerts2("AUD" + dash + "USD" + ExtraSymbolChar,x1,60,"S");
   if (Amount > 3)    alerts2("EUR" + dash + "GBP" + ExtraSymbolChar,x1,80,"B");
   if (Amount > 4)    alerts2("GBP" + dash + "JPY" + ExtraSymbolChar,x1,100,"B");
   if (Amount > 5)    alerts2("USD" + dash + "JPY" + ExtraSymbolChar,x1,120,"S");
   if (Amount > 6)    alerts2("EUR" + dash + "JPY" + ExtraSymbolChar,x1,140,"S");
   if (Amount > 7)    alerts2("CHF" + dash + "JPY" + ExtraSymbolChar,x1,160,"B");
   if (Amount > 8)    alerts2("NZD" + dash + "JPY" + ExtraSymbolChar,x1,180,"S");
   if (Amount > 9)    alerts2("AUD" + dash + "JPY" + ExtraSymbolChar,x1,200,"S");
   if (Amount > 10)    alerts2("CAD" + dash + "JPY" + ExtraSymbolChar,x2,20,"S");
   if (Amount > 11)       alerts2("EUR" + dash + "CHF" + ExtraSymbolChar,x2,40,"S");
   if (Amount > 12)       alerts2("USD" + dash + "CHF" + ExtraSymbolChar,x2,60,"B");
   if (Amount > 13)       alerts2("GBP" + dash + "CHF" + ExtraSymbolChar,x2,80,"B");
   if (Amount > 14)       alerts2("CAD" + dash + "CHF" + ExtraSymbolChar,x2,100,"S");

   if (Amount > 15)       alerts2("NZD" + dash + "CHF" + ExtraSymbolChar,x2,120,"S");

   if (Amount > 16)       alerts2("AUD" + dash + "CHF" + ExtraSymbolChar,x2,140,"B");
   if (Amount > 17)       alerts2("USD" + dash + "CAD" + ExtraSymbolChar,x2,160,"S");
   if (Amount > 18)       alerts2("AUD" + dash + "CAD" + ExtraSymbolChar,x2,180,"S");
   if (Amount > 19)       alerts2("EUR" + dash + "CAD" + ExtraSymbolChar,x2,200,"B");
   if (Amount > 20)       alerts2("NZD" + dash + "CAD" + ExtraSymbolChar,x3,40,"S");
   if (Amount > 21)       alerts2("GBP" + dash + "CAD" + ExtraSymbolChar,x3,60,"S");
   if (Amount > 22)       alerts2("AUD" + dash + "NZD" + ExtraSymbolChar,x3,80,"B");
   if (Amount > 23)       alerts2("GBP" + dash + "AUD" + ExtraSymbolChar,x3,100,"S");
//   if (Amount > 24)       alerts2("XAU" + dash + "USD" + ExtraSymbolChar,x3,120,"S");
   
//   vlag = false;
   return (0);
}

void alerts2(string simbool, int id1, int id2 , string tipe)
{
  OnScreen("tyd",Symbol()+"   "+DoubleToStr(Bid,Digits),15,2,10,100,clrCyan);
 for (int i = 0; i < SymbolsTotal(true); i++) 
 if (SymbolName(i,true ) == simbool)

 {
   if(Increment)
      increment = StartLot;
   else
      increment = 0;

   int li_8 = Time[0] + 60 * Period() - TimeCurrent();
   double ld_0 = li_8 / 60.0;
   int li_12 = li_8 % 60;
   li_8 = (li_8 - li_8 % 60) / 60;
   ObjectDelete("time");
   if (ObjectFind("time") != 0)
   {
      ObjectCreate("time", OBJ_TEXT, 0, Time[0], Close[0] + 0.00005);
      ObjectSetText("time", "             " + li_8 + ":" + li_12, 14, "Arial", Candle_Time);
   } else ObjectMove("time", 0, Time[0], Close[0] + 0.0005);


    PipValue = 1;
    NDigits = Digits;
    if (NDigits == 3 || NDigits == 5) PipValue = 10;

   ask = MarketInfo(simbool, MODE_ASK);
   bid = MarketInfo(simbool, MODE_BID);

   double ma200_0=iMA(simbool,0,60,0,0,0,0);
   double ma200_1=iMA(simbool,0,60,0,0,0,1);
   double ma60_H4=iMA(simbool,PERIOD_H4,80,0,0,0,0);
   double ma60_H1=iMA(simbool,PERIOD_H1,80,0,0,0,0);
   double ma60_M15=iMA(simbool,PERIOD_M15,80,0,0,0,0);
   double ma60_0=iMA(simbool,0,24,0,0,0,0);
   double ma60_1=iMA(simbool,0,24,0,0,0,1);
   trends = "Ranging";   

   if (bid > ma60_M15 && bid > ma60_H1 && bid > ma60_H4) trends = "Buy";
   if (bid < ma60_M15 && bid < ma60_H1 && bid < ma60_H4) trends = "Sell";
//   if (trends == "Ranging") killpair(simbool);

     string buy = "***",sell = "***";
     string limited_buy = "***",limited_sell = "***",stop_buy = "***",stop_sell = "***";
     int limited_buy_tel,limited_sell_tel,stop_buy_tel,stop_sell_tel;
     wins = 0;
     tel = 0;
     double lotstotaal = 0;

     int pair_teller = 0;
     double positief_totaal = 0,negatief_totaal = 0, buy_totaal = 0, sell_totaal = 0,lots = 0;
     for(int xx=OrdersTotal()-1;xx>=0;xx--)
     {
      if(OrderSelect(xx,SELECT_BY_POS,MODE_TRADES))
      if (OrderSymbol() == simbool)
      {
       wins = wins+OrderProfit() + OrderCommission() + OrderSwap();
       tel++;
       if (tel > 0) simboolnaam = simbool;
       if (OrderProfit() > 0) positief_totaal = positief_totaal + OrderProfit();
       if (OrderProfit() < 0) negatief_totaal = negatief_totaal + OrderProfit();
       if (OrderType() == OP_BUY) buy_totaal = buy_totaal + OrderProfit();
       if (OrderType() == OP_SELL) sell_totaal = sell_totaal + OrderProfit();

       if (OrderType() == OP_BUYSTOP) stop_buy = "BUY";
       if (OrderType() == OP_SELLSTOP) stop_sell = "SELL";
       if (OrderType() == OP_BUYLIMIT) limited_buy = "BUY";
       if (OrderType() == OP_SELLLIMIT) limited_sell = "SELL";

       if (OrderType() == OP_BUYSTOP) stop_buy_tel++;
       if (OrderType() == OP_SELLSTOP) stop_sell_tel++;
       if (OrderType() == OP_BUYLIMIT) limited_buy_tel++;
       if (OrderType() == OP_SELLLIMIT) limited_sell_tel++;

       if (OrderType() == OP_BUY) buy = "BUY";
       if (OrderType() == OP_SELL) sell = "SELL";
       if (OrderLots() > lots) lots = OrderLots();
      }
      if (OrderType() == OP_SELL || OrderType() == OP_BUY) lotstotaal = lotstotaal + OrderLots();
     }

   if(MarketInfo(simbool,MODE_DIGITS)==3 || MarketInfo(simbool,MODE_DIGITS)==5) pt=10*MarketInfo(simbool,MODE_POINT);
   else                          pt=MarketInfo(simbool,MODE_POINT);
   minlot   =   MarketInfo(simbool,MODE_MINLOT);
   if(minlot==0.01) prec=2;
   if(minlot==0.1)  prec=1;

   PrintMTChart67();
                                                                                                                                          
   Expiration = 0; 
//   Gap_between_Orders = 5;//(MarketInfo(simbool,MODE_SPREAD)) / PipValue;

   Follow_up_Orders(simbool,buy_totaal,sell_totaal);
   PriceOffset = (MarketInfo(simbool,MODE_STOPLEVEL) + 10);
   if (PriceOffset < Gap_between_Orders) PriceOffset = Gap_between_Orders;
//  if (AutoTrade_1) Growth_needed_to_TP = 0; else Growth_needed_to_TP = 3; 
//********************************************************************************************************************************************+
   if (Hour() >= Start_Hour && Hour() <= Finish_Hour)
     if (simbool == Symbol())
     {
       int b = 1440;
   if (iCustom(simbool,b,"NonLagMA_v7.1",1,0) != EMPTY_VALUE)
   {
      IfOrderDoesNotExist61(simbool,magic);
      if (OrdersTotal() == amount) ChartSetSymbolPeriod(0,simbool,b);
   }
   if (iCustom(simbool,b,"NonLagMA_v7.1",2,0) != EMPTY_VALUE)
   {
      IfOrderDoesNotExist62(simbool,magic);
      if (OrdersTotal() == amount) ChartSetSymbolPeriod(0,simbool,b);
   }
     }//if      
//*******************************************************************************************************************************************
//    if (!IsTesting() && simbool == Symbol()) indis(simbool);
//******************************************************************************************************************************************
    if (AccountProfit() > 0) OnScreen("wins",DoubleToStr(AccountProfit(),2)+" "+AccountCurrency(),20,1,10,250,Currency_in_profit);
    if (AccountProfit() <= 0) OnScreen("wins",DoubleToStr(AccountProfit(),2)+" "+AccountCurrency(),20,1,10,250,Currency_in_loss);
      if (wins > 0)      
       OnScreen(simbool,simbool+"  "+DoubleToStr(wins,2)+" : "+IntegerToString(tel)+" : "+buy+" : "+sell+" Trend :"+trends ,10,1,id1,id2,Currency_in_profit);
      else
       OnScreen(simbool,simbool+"  "+DoubleToStr(wins,2)+" : "+IntegerToString(tel)+" : "+buy+" : "+sell+" Trend :"+trends,10,1,id1,id2,Currency_in_loss);     
//****************************************************************************************************************************************
   int deler=1;
   Eqty=AccountEquity()-AccountCredit();
   if(AccountProfit()<teller)
      teller=AccountProfit();
   if(AccountBalance()>highest_profit)
      highest_profit = AccountBalance();
   if (MarketInfo(simbool,MODE_ASK) > buy_max) buy_max = MarketInfo(simbool,MODE_ASK);
   if (MarketInfo(simbool,MODE_BID) < sell_max) sell_max = MarketInfo(simbool,MODE_BID);
   if(OrdersTotal() == 0) {highest_profit = Eqty;buy_max = 0;sell_max = 0;OnScreen("zero","Please wait",14,2,10,70,Currency_in_profit);}
   if(OrdersTotal() > 0) ObjectDelete("zero");
   OnScreen("hp",DoubleToStr(Eqty,2)+" / "+DoubleToStr(highest_profit,2)+" "+AccountCurrency(),12,1,10,290,clrWhite);
   OnScreen("hp2",DoubleToStr(((Eqty - highest_profit) / highest_profit) *100,2)+" % growth",12,1,10,320,clrWhite);
   eqt_waarde=Eqty;
   if(AccountBalance()>hoogste_balans-teller/deler)
     {
      hoogste_balans=AccountBalance();
     }
   if(((Eqty - highest_profit) / highest_profit) *100 <= Growth_needed_to_TP)
     {
      OnScreen("target","Break Even : "+DoubleToStr((eqt_waarde/(hoogste_balans -(teller/deler))*100),4)+" %",12,1,10,220,Currency_in_loss);
      ObjectDelete("siml2");
      ObjectDelete("target2");
     }
   if(((Eqty - highest_profit) / highest_profit) *100 > 0)
     {
      OnScreen("target","Break Even reached - Click",11,1,10,220,Currency_in_profit);
     OnScreen("target2","<Close everything> or let profit run !!!",11,1,10,240,Currency_in_profit);
      if(((Eqty - highest_profit) / highest_profit) *100 > Growth_needed_to_TP)
       {
//        if (wins > 0) killpair(simbool);
       }
//        kill_kleiner_nul(simbool,-StartLot * 3000);
        trail(simbool,wins);
       }   
//       if (Scalper && AccountProfit() > 0) killpair(simbool);
//       if (wins > StartLot * 10) killpair(simbool);
//        kill_groter_nul(simbool,-wins * 2);
//       if (wins > StartLot * 100 && Hour() >= Start_Hour && Hour() <= Finish_Hour) killpair(simbool);
//      trail(simbool,wins);
//      if (Eqty > hoogste_balans2) {hoogste_balans2 = Eqty;killpair(simbool);}
      OncePerMinutes74(simbool);
 }
}
//*************************+***************************************************************************************************************
void IfOrderDoesNotExist61(string simbool,int id)
  {
  
   bool exists=false;
    for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        { 
         if(OrderType()==OP_BUY && OrderSymbol()==simbool && OrderMagicNumber()==id)
           {
            exists=true;
           }
        }
      else
        {
         Print("OrderSelect() error - ");
        }

   if(exists==false)
     {
      BuyOrder66(simbool,id);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+-------1-----------------------------------------------------------+
void IfOrderDoesNotExist62(string simbool,int id)
  {
   bool exists=false;

   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_SELL && OrderSymbol()==simbool && OrderMagicNumber()==id)
           {
            exists=true;
           }
        }
      else
        {
         Print("OrderSelect() error - ");
        }

   if(exists==false)
     {
      SellOrder70(simbool,id);
     }
  }

void BuyOrder66(string simbool, int id)
  {
   lastlot=0;
   for(int ii=0; ii<OrdersTotal(); ii++)
     {
      if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==simbool)
            if(lastlot<OrderLots())
               lastlot=OrderLots();
     }
   if(lastlot==0)
      lastlot=StartLot;
   else
   if (lastlot <Max_Lotsize)
     {
      if(Martingale)
         lastlot=lastlot*multiplier;
      if(Increment)
         lastlot=lastlot+increment;
     } 
   killsell(simbool);
   double SL = MarketInfo(simbool,MODE_ASK) - Stoploss*PipValue*MarketInfo(simbool,MODE_POINT);
   if(Stoploss == 0)
      SL = 0;

   double TP = MarketInfo(simbool,MODE_ASK) + Takeprofit*PipValue*MarketInfo(simbool,MODE_POINT);
   if(Takeprofit == 0)
      TP = 0;
   ticket = -1;
   if(true)
      ticket = OrderSend(simbool, OP_BUY, lastlot, MarketInfo(simbool,MODE_ASK), 4, 0, 0, Name, id, 0, Blue);
   else
      ticket = OrderSend(simbool, OP_BUY, lastlot, MarketInfo(simbool,MODE_ASK), 4, SL, TP, Name, id, 0, Blue);
   if(ticket > -1)
     {
      if(true)
        {
         bool sel = OrderSelect(ticket, SELECT_BY_TICKET);
         bool ret = OrderModify(OrderTicket(), OrderOpenPrice(), SL, TP, 0, Blue);
         if(ret == false)
            Print("OrderModify() error - 1234567");
        }

     }
   else
     {
      Print("OrderSend() error - ");
   }   
  } 

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellOrder70(string simbool, int id)
  {
   lastlot=0;
   for(int ii=0; ii<OrdersTotal(); ii++)
     {
      if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==simbool)
           if(lastlot<OrderLots())
               lastlot=OrderLots();
     }
   if(lastlot==0)
      lastlot=StartLot;
   else
   if (lastlot <Max_Lotsize)
     {      if(Martingale)

    lastlot=lastlot*multiplier;
      if(Increment)
         lastlot=lastlot+increment;
     }
   killbuy(simbool);
   double SL = MarketInfo(simbool,MODE_BID) + Stoploss*PipValue*MarketInfo(simbool,MODE_POINT);
   if(Stoploss == 0)
      SL = 0;
   double TP = MarketInfo(simbool,MODE_BID) - Takeprofit*PipValue*MarketInfo(simbool,MODE_POINT);
   if(Takeprofit == 0)
      TP = 0;
   ticket = -1;
   if(true)
      ticket = OrderSend(simbool, OP_SELL, lastlot, MarketInfo(simbool,MODE_BID), 4, 0, 0, Name, id, 0, Red);
   else
      ticket = OrderSend(simbool, OP_SELL, lastlot, MarketInfo(simbool,MODE_BID), 4, SL, TP, Name, id, 0, Red);
   if(ticket > -1)
     {
      if(true)
        {
         bool sel = OrderSelect(ticket, SELECT_BY_TICKET);
         bool ret = OrderModify(OrderTicket(), OrderOpenPrice(), SL, TP, 0, Red);
         if(ret == false)
            Print("OrderModify() error - aaaaaaaaaaaaaaaaaaaa");
        }

     }
   else
     {
      Print("OrderSend() error - ");
     }
  }
//+------------------------------------------------------------------+
void PrintMTChart67()
{
    OnScreen("11a",AccountCompany(),9,3,20,210,Information);
    OnScreen("22a",AccountName(),9,3,20,195,Information);
    OnScreen("33a",AccountServer(),9,3,20,180,Information);
    OnScreen("44a",IntegerToString(AccountNumber()),9,3,20,165,Information);
    OnScreen("55a","Credit : "+DoubleToStr(AccountCredit(),2),9,3,20,150,Information);

    ObjectCreate("ObjSpread",OBJ_LABEL, 0, 0, 0);
    ObjectSetText("ObjSpread","Spread : " + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD),2),12, "Arial Bold",clrWhite);

    ObjectSet("ObjSpread", OBJPROP_CORNER,3);
    ObjectSet("ObjSpread", OBJPROP_XDISTANCE,20);
    ObjectSet("ObjSpread", OBJPROP_YDISTANCE,130);
    
    ObjectCreate("ObjName2",OBJ_LABEL, 0, 0, 0);
    ObjectSetText("ObjName2","ACCOUNT BALANCE : "+DoubleToStr(AccountBalance(), 2),12, "clrNONE Arial Bold",Information);
    ObjectSet("ObjName2", OBJPROP_CORNER,3);
    ObjectSet("ObjName2", OBJPROP_XDISTANCE,20);
    ObjectSet("ObjName2", OBJPROP_YDISTANCE,110);
    
    ObjectCreate("ObjName3",OBJ_LABEL, 0, 0, 0);
    ObjectSetText("ObjName3","ACCOUNT EQUITY : "+DoubleToStr(AccountEquity(), 2),12, "clrNONE Arial Bold",Information);
    ObjectSet("ObjName3", OBJPROP_CORNER,3);
    ObjectSet("ObjName3", OBJPROP_XDISTANCE,20);
    ObjectSet("ObjName3", OBJPROP_YDISTANCE,90);
    
    ObjectCreate("ObjName4",OBJ_LABEL, 0, 0, 0);
    ObjectSetText("ObjName4","FREE MARGIN : "+DoubleToStr(AccountEquity()-AccountMargin(), 2),12, "clrNONE Arial Bold",Information);
    ObjectSet("ObjName4", OBJPROP_CORNER,3);
    ObjectSet("ObjName4", OBJPROP_XDISTANCE,20);
    ObjectSet("ObjName4", OBJPROP_YDISTANCE,70);
    
    if (AccountProfit() > 0)
    {
        ObjectCreate("ObjName5",OBJ_LABEL, 0, 0, 0);
        ObjectSetText("ObjName5","PROFIT / LOSS : "+DoubleToStr(AccountProfit(), 2),12, "clrNONE Arial Bold",Currency_in_profit);
        ObjectSet("ObjName5", OBJPROP_CORNER,3);
        ObjectSet("ObjName5", OBJPROP_XDISTANCE,20);
        ObjectSet("ObjName5", OBJPROP_YDISTANCE,50);
    }
    else
    {
        ObjectCreate("ObjName5",OBJ_LABEL, 0, 0, 0);
        ObjectSetText("ObjName5","PROFIT / LOSS : "+DoubleToStr(AccountProfit(), 2),12, "clrNONE Arial Bold",Currency_in_loss);
        ObjectSet("ObjName5", OBJPROP_CORNER,3);
        ObjectSet("ObjName5", OBJPROP_XDISTANCE,20);
        ObjectSet("ObjName5", OBJPROP_YDISTANCE,50);
    }
    
    ObjectCreate("ObjName6",OBJ_LABEL, 0, 0, 0);
    ObjectSetText("ObjName6","OPEN ORDERS : "+DoubleToStr(OrdersTotal(), 0),12, "clrNONE Arial Bold",Information);
    ObjectSet("ObjName6", OBJPROP_CORNER,3);
    ObjectSet("ObjName6", OBJPROP_XDISTANCE,20);

    ObjectSet("ObjName6", OBJPROP_YDISTANCE,30);
    
    ObjectCreate("ObjName",OBJ_LABEL, 0, 0, 0);
    ObjectSetText("ObjName","Timeframe : "+IntegerToString(Period())+" minutes",9, "Arial",Yellow);
    ObjectSet("ObjName", OBJPROP_CORNER,3);
    ObjectSet("ObjName", OBJPROP_XDISTANCE,20);
    ObjectSet("ObjName", OBJPROP_YDISTANCE,10);
}

void OncePerMinutes74(string simbool)
{
    int datetime800 = TimeLocal();
    if (ExpectedTime74 == 0 || datetime800 > ExpectedTime74 + 60)
    {
        ExpectedTime74 = datetime800 + 60 * 120;   // reset paused time
    }
    if (datetime800 >= ExpectedTime74 && datetime800 < ExpectedTime74 + 60)
    {
        ExpectedTime74 = datetime800 + 60 * 120;
        if (IsTesting()) ObjectsDeleteAll();
    }
}

//*****************************************************************************************************************************************************
void OnScreen(string name,string info, int fontsize2, int corner, int xx, int yy, color kleur)
{
    ObjectCreate(name,OBJ_LABEL, 0, 0, 0);
    ObjectSetText(name,info,fontsize2, "Arial",kleur);
    ObjectSet(name, OBJPROP_CORNER,corner);
    ObjectSet(name, OBJPROP_XDISTANCE,xx);
    ObjectSet(name, OBJPROP_YDISTANCE,yy);
}
void IfOP_BuyStopDoesNotExist(string simbool, int id1,double lots)
{
    bool exists = false;
    for (int i=OrdersTotal()-1; i >= 0; i--)
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
         if(OrderType() == OP_BUYSTOP && OrderSymbol()==simbool && OrderMagicNumber()==id1)//999
        {
            exists = true;
        }
    }

    else
    {
        Print("OrderSelect() error - ");
    }
    
    if (exists == false)
    {
        BuyPendingOrder149(simbool,id1,lots);
    }
}

void BuyPendingOrder149(string simbool,int id1,double lotsize)
  {
   lastlot=0;
   for(int ii=0; ii<OrdersTotal(); ii++)
     {
      if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==simbool)
//            if(lastlot<OrderLots())
               lastlot=OrderLots();
     }
   if(lastlot==0)
      lastlot=StartLot;
   else
     {
      if(Martingale)
         lastlot=lastlot*multiplier;
      if(Increment)
         lastlot=lastlot+increment;
     }
//   killsell(simbool);
   datetime expire=TimeCurrent()+60*Expiration;
   double price=NormalizeDouble(MarketInfo(simbool,MODE_ASK),NDigits)+PriceOffset*PipValue*MarketInfo(simbool,MODE_POINT);
   double SL=price-Stoploss*PipValue*MarketInfo(simbool,MODE_POINT);
   if(Stoploss==0)
      SL=0;
   double TP=price+Takeprofit*PipValue*MarketInfo(simbool,MODE_POINT);
   if(Takeprofit == 0)
      TP = 0;
   if(Expiration == 0)
      expire = 0;
   ticket=OrderSend(simbool,OP_BUYSTOP,lastlot,price,4,SL,TP,Name,id1,expire,clrNONE);
   if(ticket==-1)

     {
      Print("OrderSend() error - ");
     }

  }
//+------------------------------------------------------------------+
void IfOP_SellStopDoesNotExist(string simbool,int id1,double lots3)
  {
   bool exists=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType() == OP_SELLSTOP && OrderSymbol()==simbool && OrderMagicNumber()==id1)//999
           {
            exists=true;
           }
        }
      else
        {
         Print("OrderSelect() error - ");
        }

   if(exists==false)
     {
      SellPendingOrder150(simbool,id1,lots3);
 
     }
  }
//+------------------------------------------------------------------+
void SellPendingOrder150(string simbool,int id1,double lotsize)
  {
   lastlot=0;
   for(int ii=0; ii<OrdersTotal(); ii++)
     {
      if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==simbool)
//            if(lastlot<OrderLots())
               lastlot=OrderLots();
     }
   if(lastlot==0)
      lastlot=StartLot;
   else
     {
      if(Martingale)
         lastlot=lastlot*multiplier;
      if(Increment)
         lastlot=lastlot+increment;
     }
//   killbuy(simbool);
   datetime expire=TimeCurrent()+60*Expiration;
   double price=NormalizeDouble(MarketInfo(simbool,MODE_BID),NDigits)-PriceOffset*PipValue*MarketInfo(simbool,MODE_POINT);
   double SL=price+Stoploss*PipValue*MarketInfo(simbool,MODE_POINT);
   if(Stoploss==0)
      SL=0;
   double TP=price-Takeprofit*PipValue*MarketInfo(simbool,MODE_POINT);
   if(Takeprofit == 0)
      TP = 0;
   if(Expiration == 0)
      expire = 0;
   ticket=OrderSend(simbool,OP_SELLSTOP,lastlot,price,4,SL,TP,Name,id1,expire,clrNONE);
   if(ticket==-1)
     {
      Print("OrderSend() error - ");
     }

  }

void DeleteBuyPendingOrders(string simbool)
{
   int Type=0;
   
	for(int xx = OrdersTotal()-1; xx >= 0; xx--)
	{
		if (OrderSelect(xx, SELECT_BY_POS, MODE_TRADES)) Type = OrderType();
		if(OrderSymbol() == simbool)
		{ 
	      if(Type == OP_BUYSTOP || Type == OP_BUYLIMIT)  
	      {
            if(!OrderDelete(OrderTicket()))
               Print("(OrderDelete Error) "+ ErrorDescription(GetLastError()));
         }
      }
   }
}

void DeleteSellPendingOrders(string simbool)
{
   int Type=1;
   
	for(int xx = OrdersTotal()-1; xx >= 0; xx--)
	{
		if (OrderSelect(xx, SELECT_BY_POS, MODE_TRADES)) Type = OrderType();
		if(OrderSymbol() == simbool)
		{ 
	      if(Type == OP_SELLSTOP || Type == OP_SELLLIMIT)  
	      {
            if(!OrderDelete(OrderTicket()))
               Print("(OrderDelete Error) "+ ErrorDescription(GetLastError()));
         }
      }
   }
}

void DeleteBuyStopOrders(string simbool)
{
   int Type=0;
   
	for(int xx = OrdersTotal()-1; xx >= 0; xx--)
	{
		if (OrderSelect(xx, SELECT_BY_POS, MODE_TRADES)) Type = OrderType();
		if(OrderSymbol() == simbool)
		{ 
	      if(Type == OP_BUYSTOP)  
	      {
            if(!OrderDelete(OrderTicket()))
               Print("(OrderDelete Error) "+ ErrorDescription(GetLastError()));
         }
      }
   }
}

void DeleteSellStopOrders(string simbool)
{
   int Type=1;
   
	for(int xx = OrdersTotal()-1; xx >= 0; xx--)
	{
		if (OrderSelect(xx, SELECT_BY_POS, MODE_TRADES)) Type = OrderType();
		if(OrderSymbol() == simbool)
		{ 
	      if(Type == OP_SELLSTOP)  
	      {
            if(!OrderDelete(OrderTicket()))
               Print("(OrderDelete Error) "+ ErrorDescription(GetLastError()));
         }
      }
   }
}

void DeleteBuyLimitOrders(string simbool)
{
   int Type=0;
   
	for(int xx = OrdersTotal()-1; xx >= 0; xx--)
	{
		if (OrderSelect(xx, SELECT_BY_POS, MODE_TRADES)) Type = OrderType();
		if(OrderSymbol() == simbool)
		{ 
	      if(Type == OP_BUYLIMIT)  
	      {
            if(!OrderDelete(OrderTicket()))
               Print("(OrderDelete Error) "+ ErrorDescription(GetLastError()));
         }
      }
   }
}

void DeleteSellLimitOrders(string simbool)
{
   int Type=1;
   
	for(int xx = OrdersTotal()-1; xx >= 0; xx--)
	{
		if (OrderSelect(xx, SELECT_BY_POS, MODE_TRADES)) Type = OrderType();
		if(OrderSymbol() == simbool)
		{ 
	      if(Type == OP_SELLLIMIT)  
	      {
            if(!OrderDelete(OrderTicket()))
               Print("(OrderDelete Error) "+ ErrorDescription(GetLastError()));
         }
      }
   }
}

void DeleteAllOrders(string simbool)
{
   int Type=1;
   
	for(int xx = OrdersTotal()-1; xx >= 0; xx--)
	{
		if (OrderSelect(xx, SELECT_BY_POS, MODE_TRADES)) Type = OrderType();
		if(OrderSymbol() == simbool)
		{
            if(!OrderDelete(OrderTicket()))
               Print("(OrderDelete Error) "+ ErrorDescription(GetLastError()));
     }          
   }
}
void killall()
{
      for(int xx=OrdersTotal()-1;xx>=0;xx--)
        {
         if(OrderSelect(xx,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               bool ret = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),666,CLR_NONE);
                 }else
                 {
            if(!OrderDelete(OrderTicket()))
               Print("(OrderDelete Error) "+ ErrorDescription(GetLastError()));
              }
        }
}        
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Follow_up_Orders(string simbool,double bt,double st)
  {
   int type=2,tel2=0;
   double buyop=0,sellop=0,buylot=0,sellot=0,opr=0;
   bool buytype=false,selltype=false;
   int buy_tel,sell_tel;
   double buy_range,sell_range;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()!=simbool)
            continue;
//         if(OrderMagicNumber()!=magic)
//            continue;
           {
            if(OrderType()==OP_BUY || OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP)
              {
               buytype=true;
               buyop=OrderOpenPrice();
               opr=OrderOpenPrice();
               if(buylot<OrderLots())
                  buylot=OrderLots();
               buy_tel++;
               tel2++; 
              }
            if(OrderType()==OP_SELL || OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP)
              {
               selltype=true;
               sellop=OrderOpenPrice();
               opr=OrderOpenPrice();
               if(sellot<OrderLots())
                  sellot=OrderLots();
               sell_tel++;
               tel2++;
              }
           }
        }
     }
   buy_range= Gap_between_Orders * buy_tel;
   sell_range= Gap_between_Orders * sell_tel;
   range=5;
        
  if (simbool == Symbol())
  {
           ObjectDelete("HLine");
               
           ObjectDelete("HLine2");

           ObjectDelete("HLine3");

           ObjectDelete("HLine4");

ObjectCreate("HLine", OBJ_HLINE , 0,Time[0], sellop + sell_range*pt);
           ObjectSet("HLine", OBJPROP_STYLE, STYLE_SOLID);
           ObjectSet("HLine", OBJPROP_COLOR, Red);
           ObjectSet("HLine", OBJPROP_WIDTH, 3);

ObjectCreate("HLine2", OBJ_HLINE , 0,Time[0], buyop - buy_range*pt);
           ObjectSet("HLine2", OBJPROP_STYLE, STYLE_SOLID);
           ObjectSet("HLine2", OBJPROP_COLOR, Red);
           ObjectSet("HLine2", OBJPROP_WIDTH, 3);

   OnScreen("sell777","Next sell will open at " + DoubleToStr(sellop + sell_range*pt,Digits),12,2,300,30,Currency_in_loss);
   OnScreen("buy777","Next buy will open at " + DoubleToStr(buyop - buy_range*pt,Digits),12,2,300,50,Currency_in_loss);
  }  
   if(selltype && MarketInfo(simbool,MODE_BID)>=sellop + sell_range*pt)
    {
//     Expiration = 60;
//      kill_groter_nul(simbool,0);
//    IfBuy_Limit_DoesNotExist30(simbool);
//    IfOP_SellStopDoesNotExist(simbool,magic,StartLot);
//      IfOrderDoesNotExist61(simbool,magic);
     SellOrder70(simbool,magic);
    }
   if(buytype && MarketInfo(simbool,MODE_ASK)<=buyop - buy_range*pt) 
     {
//     Expiration = 60;
//      kill_groter_nul(simbool,0);
//    IfOP_BuyStopDoesNotExist(simbool,magic,StartLot);
//     IfSell_Limit_DoesNotExist(simbool);
//      IfOrderDoesNotExist62(simbool,magic);
     BuyOrder66(simbool,magic);
     }
   if(MarketInfo(simbool,MODE_BID)<=opr - range*pt && opr != 0 && st >= 0)
     {
//      SellOrder70(simbool,magic + 1);
     }
   if(MarketInfo(simbool,MODE_ASK)>=opr + range*pt && opr != 0 && bt >= 0)
     {
//      BuyOrder66(simbool,magic + 1);
     }
  }

void File_Delete()
  {
// Detects extra characters after symbol name.
   ExtraSymbolChar=StringSubstr(Symbol(),6);

// Detects a dash in middle of symbol name.
   if(StringSubstr(Symbol(),4,1)=="-")
      dash="-";
   else
      dash="";
   FileDelete("EUR"+dash+"USD"+ExtraSymbolChar);
   FileDelete("AUD"+dash+"USD"+ExtraSymbolChar);
   FileDelete("GBP"+dash+"USD"+ExtraSymbolChar);
   FileDelete("EUR"+dash+"GBP"+ExtraSymbolChar);
   FileDelete("GBP"+dash+"JPY"+ExtraSymbolChar);
   FileDelete("USD"+dash+"JPY"+ExtraSymbolChar);
   FileDelete("EUR"+dash+"JPY"+ExtraSymbolChar);
   FileDelete("CHF"+dash+"JPY"+ExtraSymbolChar);
   FileDelete("NZD"+dash+"JPY"+ExtraSymbolChar);
   FileDelete("AUD"+dash+"JPY"+ExtraSymbolChar);
   FileDelete("CAD"+dash+"JPY"+ExtraSymbolChar);
   FileDelete("EUR"+dash+"CHF"+ExtraSymbolChar);
   FileDelete("USD"+dash+"CHF"+ExtraSymbolChar);
   FileDelete("GBP"+dash+"CHF"+ExtraSymbolChar);
   FileDelete("CAD"+dash+"CHF"+ExtraSymbolChar);
   FileDelete("NZD"+dash+"CHF"+ExtraSymbolChar);
   FileDelete("AUD"+dash+"CHF"+ExtraSymbolChar);
   FileDelete("USD"+dash+"CAD"+ExtraSymbolChar);
   FileDelete("AUD"+dash+"CAD"+ExtraSymbolChar);
   FileDelete("EUR"+dash+"CAD"+ExtraSymbolChar);
   FileDelete("EUR"+dash+"AUD"+ExtraSymbolChar);
   FileDelete("AUD"+dash+"NZD"+ExtraSymbolChar);
   FileDelete("GBP"+dash+"CAD"+ExtraSymbolChar);
   FileDelete("GBP"+dash+"AUD"+ExtraSymbolChar);
   FileDelete("GBP"+dash+"NZD"+ExtraSymbolChar);
   FileDelete("EUR"+dash+"NZD"+ExtraSymbolChar);
   FileDelete("NZD"+dash+"CAD"+ExtraSymbolChar);
   FileDelete("NZD"+dash+"USD"+ExtraSymbolChar);
  }

void buygrid(string simbool)
  {
   DeleteBuyLimitOrders(simbool);
   PriceOffset = (MarketInfo(simbool,MODE_STOPLEVEL) + Gap_between_Orders)/PipValue;
   if (PriceOffset < Gap_between_Orders) PriceOffset = Gap_between_Orders;
   PriceOffset2 = -PriceOffset;
   for (int i = 0;i < Levels;i++)
   {
   BuyPendingOrder41(simbool);
   PriceOffset2=PriceOffset2-Gap_between_Orders;
  }
 } 
//+------------------------------------------------------------------+
void sellgrid(string simbool)
  {
   DeleteSellLimitOrders(simbool);
   PriceOffset = (MarketInfo(simbool,MODE_STOPLEVEL) + Gap_between_Orders)/PipValue;
   if (PriceOffset < Gap_between_Orders) PriceOffset = Gap_between_Orders;
   PriceOffset2 = -PriceOffset;
   for (int i = 0;i < Levels;i++)
   {
   SellPendingOrder37(simbool);
   PriceOffset2=PriceOffset2-Gap_between_Orders;
   }
  }
//+------------------------------------------------------------------+
void buygrid2(string simbool)
  {
   DeleteBuyStopOrders(simbool);
   PriceOffset = (MarketInfo(simbool,MODE_STOPLEVEL) + Gap_between_Orders)/PipValue;
   if (PriceOffset < Gap_between_Orders) PriceOffset = Gap_between_Orders;
   for (int i = 0;i < Levels;i++)
   {
   BuyPendingOrder149(simbool,magic,StartLot*3);
   PriceOffset=PriceOffset + Gap_between_Orders;
  }
 } 
//+------------------------------------------------------------------+
void sellgrid2(string simbool)
  {
   DeleteSellStopOrders(simbool);
   PriceOffset = (MarketInfo(simbool,MODE_STOPLEVEL) + Gap_between_Orders)/PipValue;
   if (PriceOffset < Gap_between_Orders) PriceOffset = Gap_between_Orders;
   for (int i = 0;i < Levels;i++)
   {
   SellPendingOrder150(simbool,magic,StartLot*1);
   PriceOffset=PriceOffset + Gap_between_Orders;
   }
  }
//+------------------------------------------------------------------+
void kill_kleiner_nul(string simbool,double tx)
  {
//   DeleteBuyPendingOrders(simbool);
//   DeleteSellPendingOrders(simbool);
   for(int xx=OrdersTotal()-1; xx>=0; xx--)
     {
      if(OrderSelect(xx,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==simbool && OrderProfit() < tx)
           {
         bool ret=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),4,CLR_NONE);
           }
        }
     }
  }
//+------------------------------------------------------------------+
void kill_groter_nul(string simbool,double tx)
  {
//   DeleteBuyPendingOrders(simbool);
//   DeleteSellPendingOrders(simbool);
   for(int xx=OrdersTotal()-1; xx>=0; xx--)
     {
      if(OrderSelect(xx,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==simbool && OrderProfit() > tx)
           {
         bool ret=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),4,CLR_NONE);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void killpair(string simbool)
   {
   DeleteBuyPendingOrders(simbool);
   DeleteSellPendingOrders(simbool);
   for(int xx=OrdersTotal()-1;xx>=0;xx--)
     {
      if(OrderSelect(xx,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol() == simbool)
           {
         bool ret=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),4,CLR_NONE);
         if(ret==false)
            Print("OrderClose() error - ");
           } 
     }       
   }

void killbuy(string simbool) 
   {
   DeleteBuyPendingOrders(simbool);
   for(int xx=OrdersTotal()-1;xx>=0;xx--)
     {
      if(OrderSelect(xx,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol() == simbool && OrderType() == OP_BUY)
           {
         bool ret=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),4,CLR_NONE);
         if(ret==false)
            Print("OrderClose() error - ");
           } 
     }       
   }

void killsell(string simbool) 
   {
   DeleteSellPendingOrders(simbool);
   for(int xx=OrdersTotal()-1;xx>=0;xx--)
     {
      if(OrderSelect(xx,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol() == simbool && OrderType() == OP_SELL)
           {
         bool ret=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),4,CLR_NONE);
         if(ret==false)
            Print("OrderClose() error - ");
           } 
     }       
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void trail(string simbool,double winste)
{
   int b=0,s=0;
   double ProfitB=0,ProfitS=0,OOP,price_b=0,price_s=0,lot=0,NLb=0,NLs=0,LS=0,LB=0;
   for(int j=0; j<OrdersTotal(); j++)
     {
      if(OrderSelect(j,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if((Magic==OrderMagicNumber() || Magic==-1) && OrderSymbol()==simbool)
           {
            OOP = OrderOpenPrice();
            lot = OrderLots();
            if(OrderType()==OP_BUY ) {ProfitB+=OrderProfit()+OrderSwap()+OrderCommission();price_b += OOP*lot; LB+=lot; b++;}
            if(OrderType()==OP_SELL) {ProfitS+=OrderProfit()+OrderSwap()+OrderCommission();price_s += OOP*lot; LS+=lot; s++;}
           }
        }
     }
//----
   if(b!=0)
     {
      NLb=price_b/LB;
      ARROW("cm_NL_Buy",NLb,6,clrAqua);
     }
   if(s!=0)
     {
      NLs=price_s/LS;
      ARROW("cm_NL_Sell",NLs,6,clrRed);
     }
   DrawLABEL(1,"cm OrdersB",StringConcatenate(b," Buy ",DoubleToStr(LB,2)," ",DoubleToStr(ProfitB,2),val),5,50,Color(ProfitB>0,Lime,clrNONE));
   DrawLABEL(1,"cm OrdersS",StringConcatenate(s," Sell ",DoubleToStr(LS,2)," ",DoubleToStr(ProfitS,2),val),5,65,Color(ProfitS>0,Lime,clrNONE));
//----
   if(!VirtualTrailingStop) STOPLEVEL=(int)MarketInfo(simbool,MODE_STOPLEVEL);
   int tip,Ticket;
   bool error;
   double SL,OSL;
   int n=0;
   if(b==0) SLB=0;
   if(s==0) SLS=0;
   for(int i=OrdersTotal(); i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         tip=OrderType();
         if(tip<2 && (OrderSymbol()==simbool) && (OrderMagicNumber()==Magic || Magic==-1))
           {
            OSL    = OrderStopLoss();
            OOP    = OrderOpenPrice();
            Ticket = OrderTicket();
            n++;
            if(tip==OP_BUY)
              {
               if(GeneralNoLoss)
                 {
                  SL=SlLastBar(OP_BUY,MarketInfo(simbool,MODE_BID),NLb,simbool);
                  if(SL<NLb+StartTrall*MarketInfo(simbool,MODE_POINT)) continue;
                 }
               else
                 {
                  SL=SlLastBar(OP_BUY,MarketInfo(simbool,MODE_BID),OOP,simbool);
                  if(SL<OOP+StartTrall*MarketInfo(simbool,MODE_POINT)) continue;
                 }
               //if (OSL  >= OOP && only_NoLoss) continue;
               if(SL>=OSL+StepTrall*MarketInfo(simbool,MODE_POINT) && (MarketInfo(simbool,MODE_BID)-SL)/MarketInfo(simbool,MODE_POINT)>STOPLEVEL)
                 {
                  if(VirtualTrailingStop)
                    {
                     if(SLB<SL) SLB=SL;
                     if(SLB!=0 && MarketInfo(simbool,MODE_BID)<=SLB)
                       {
                        if(OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(simbool,MODE_BID),MarketInfo(simbool,MODE_DIGITS)),slippage,clrNONE)) continue;
                       }
                    }
                  else
                    {
                     error=OrderModify(Ticket,OOP,SL,OrderTakeProfit(),0,White);
      ChartSetSymbolPeriod(0,simbool,0);
//       kill_kleiner_nul(simbool,0);
//       DeleteSellPendingOrders(simbool);
//killsell(simbool);
       DeleteAllOrders(simbool);
                    }
                 }
              }
            if(tip==OP_SELL)
              {
               if(GeneralNoLoss)
                 {
                  SL=SlLastBar(OP_SELL,MarketInfo(simbool,MODE_ASK),NLs,simbool);
                  if(SL>NLs-StartTrall*MarketInfo(simbool,MODE_POINT)) continue;
                 }
               else
                 {
                  SL=SlLastBar(OP_SELL,MarketInfo(simbool,MODE_ASK),OOP,simbool);
                  if(SL>OOP-StartTrall*MarketInfo(simbool,MODE_POINT)) continue;
                 }
               //if (OSL  <= OOP && only_NoLoss) continue;
               if((SL<=OSL-StepTrall*MarketInfo(simbool,MODE_POINT) || OSL==0) && (SL-MarketInfo(simbool,MODE_ASK))/MarketInfo(simbool,MODE_POINT)>STOPLEVEL)
  
                 {
                  if(VirtualTrailingStop)
                    {
                     if(SLS==0 || SLS>SL) SLS=SL;
                     if(SLS!=0 && MarketInfo(simbool,MODE_ASK)>=SLS)
                       {
                        if(OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(simbool,MODE_ASK),MarketInfo(simbool,MODE_DIGITS)),slippage,clrNONE)) continue;
                       }
                    }
                  else
                    {
                     error=OrderModify(Ticket,OOP,SL,OrderTakeProfit(),0,White);
      ChartSetSymbolPeriod(0,simbool,0);
//     kill_kleiner_nul(simbool,0);
//       killbuy(simbool);
//     DeleteBuyPendingOrders(simbool);
       DeleteAllOrders(simbool);
                    }
                 }
              }
           }
        }
     }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SlLastBar(int tip,double price,double OOP,string simbool)
  {
   double prc=0;
   int i;
   switch(parameters_trailing)
     {
      case 1: // by extremums of candlesticks
         if(tip==OP_BUY)
           {
            for(i=1; i<500; i++)
              {
               prc=NormalizeDouble(iLow(simbool,TF[TF_Tralling],i)-delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
               if(prc!=0) if(price-STOPLEVEL*MarketInfo(simbool,MODE_POINT)>prc) break;
               else prc=0;
              }
            ARROW("cm_SL_Buy",prc,4,clrAqua);
            DrawLABEL(1,"cm SL Buy",StringConcatenate("SL Buy candle ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,100,text_color);
           }
         if(tip==OP_SELL)
           {
            for(i=1; i<500; i++)
              {
               prc=NormalizeDouble(iHigh(simbool,TF[TF_Tralling],i)+delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
               if(prc!=0) if(price+STOPLEVEL*MarketInfo(simbool,MODE_POINT)<prc) break;
               else prc=0;
              }
            ARROW("cm_SL_Sell",prc,4,clrRed);
            DrawLABEL(1,"cm SL Sell",StringConcatenate("SL Sell candle ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,120,text_color);
           }
         break;

      case 2: // by fractals
         if(tip==OP_BUY)
           {
            for(i=1; i<100; i++)
              {
               prc=iFractals(simbool,TF[TF_Tralling],MODE_LOWER,i);
               if(prc!=0)
                 {
                  prc=NormalizeDouble(prc-delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
                  if(price-STOPLEVEL*MarketInfo(simbool,MODE_POINT)>prc) break;
                 }
               else prc=0;
              }
            ARROW("cm_SL_Buy",prc,218,clrAqua);
            DrawLABEL(1,"cm SL Buy",StringConcatenate("SL Buy Fractals ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,100,text_color);
           }
         if(tip==OP_SELL)
           {
            for(i=1; i<100; i++)
              {
               prc=iFractals(simbool,TF[TF_Tralling],MODE_UPPER,i);
               if(prc!=0)
                 {
                  prc=NormalizeDouble(prc+delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
                  if(price+STOPLEVEL*MarketInfo(simbool,MODE_POINT)<prc) break;
                 }
               else prc=0;
              }
            ARROW("cm_SL_Sell",prc,217,clrRed);
            DrawLABEL(1,"cm SL Sell",StringConcatenate("SL Sell Fractals ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,120,text_color);
           }
         break;
      case 3: // by ATR indicator
         if(tip==OP_BUY)
           {
            prc=NormalizeDouble(MarketInfo(simbool,MODE_BID)-iATR(simbool,TF[TF_Tralling],period_ATR,0)-delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
            ARROW("cm_SL_Buy",prc,4,clrAqua);
            DrawLABEL(1,"cm SL Buy",StringConcatenate("SL Buy ATR ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,100,text_color);
           }
         if(tip==OP_SELL)
           {
            prc=NormalizeDouble(MarketInfo(simbool,MODE_ASK)+iATR(simbool,TF[TF_Tralling],period_ATR,0)+delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
            ARROW("cm_SL_Sell",prc,4,clrRed);
            DrawLABEL(1,"cm SL Sell",StringConcatenate("SL Sell ATR ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,120,text_color);
           }
         break;

      case 4: // by Parabolic indicator
         prc=iSAR(simbool,TF[TF_Tralling],Step,Maximum,0);
         if(tip==OP_BUY)
           {
            prc=NormalizeDouble(prc-delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
            if(price-STOPLEVEL*MarketInfo(simbool,MODE_POINT)<prc) prc=0;
            ARROW("cm_SL_Buy",prc,4,clrAqua);
            DrawLABEL(1,"cm SL Buy",StringConcatenate("SL Buy Parabolic ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,100,text_color);
           }
         if(tip==OP_SELL)
           {
            prc=NormalizeDouble(prc+delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
            if(price+STOPLEVEL*MarketInfo(simbool,MODE_POINT)>prc) prc=0;
            ARROW("cm_SL_Sell",prc,4,clrRed);
            DrawLABEL(1,"cm SL Sell",StringConcatenate("SL Sell Parabolic ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,120,text_color);
           }
         break;

      case 5: // by MA indicator
         prc=iMA(simbool,TF[TF_Tralling],ma_period,0,ma_method,applied_price,0);
         if(tip==OP_BUY)
           {
            prc=NormalizeDouble(prc-delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
            if(price-STOPLEVEL*MarketInfo(simbool,MODE_POINT)<prc) prc=0;
            ARROW("cm_SL_Buy",prc,4,clrAqua);
            DrawLABEL(1,"cm SL Buy",StringConcatenate("SL Buy MA ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,100,text_color);
           }
         if(tip==OP_SELL)
           {
            prc=NormalizeDouble(prc+delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
            if(price+STOPLEVEL*MarketInfo(simbool,MODE_POINT)>prc) prc=0;
            ARROW("cm_SL_Sell",prc,4,clrRed);
            DrawLABEL(1,"cm SL Sell",StringConcatenate("SL Sell MA ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,120,text_color);
           }
         break;
      case 6: // % of profit
         if(tip==OP_BUY)
           {
            prc=NormalizeDouble(OOP+(price-OOP)/100*PercetnProfit,MarketInfo(simbool,MODE_DIGITS));
            ARROW("cm_SL_Buy",prc,4,clrAqua);
            DrawLABEL(1,"cm SL Buy",StringConcatenate("SL Buy % ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,100,text_color);
           }
         if(tip==OP_SELL)
           {
            prc=NormalizeDouble(OOP-(OOP-price)/100*PercetnProfit,MarketInfo(simbool,MODE_DIGITS));
            ARROW("cm_SL_Sell",prc,4,clrRed);
            DrawLABEL(1,"cm SL Sell",StringConcatenate("SL Sell % ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,120,text_color);
           }
         break;
      default: // by points
         if(tip==OP_BUY)
           {
            prc=NormalizeDouble(price-delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
            ARROW("cm_SL_Buy",prc,4,clrAqua);
            DrawLABEL(1,"cm SL Buy",StringConcatenate("SL Buy pips ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,100,text_color);
           }
         if(tip==OP_SELL)
           {
            prc=NormalizeDouble(price+delta*MarketInfo(simbool,MODE_POINT),MarketInfo(simbool,MODE_DIGITS));
            ARROW("cm_SL_Sell",prc,4,clrRed);
            DrawLABEL(1,"cm SL Sell",StringConcatenate("SL Sell pips ",DoubleToStr(prc,MarketInfo(simbool,MODE_DIGITS))),5,120,text_color);
           }
         break;
     }
   return(prc);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string StrPer(int per)
  {
   if(per == 0) per=Period();
   if(per == 1) return("M1");
   if(per == 5) return("M5");
   if(per == 15) return("M15");
   if(per == 30) return("M30");
   if(per == 60) return("H1");
   if(per == 240) return("H4");
   if(per == 1440) return("D1");
   if(per == 10080) return("W1");
   if(per == 43200) return("MN1");
   return("timeframe error");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ARROW(string Names,double Price,int ARROWCODE,color c)
  {
   ObjectDelete(Name);
   ObjectCreate(Name,OBJ_ARROW,0,iTime(Symbol(),NULL,0),Price,0,0,0,0);
   ObjectSetInteger(0,Names,OBJPROP_ARROWCODE,ARROWCODE);
   ObjectSetInteger(0,Names,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,Names,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,Names,OBJPROP_COLOR,c);
   ObjectSetInteger(0,Names,OBJPROP_WIDTH,1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawLABEL(int c,string name,string Names,int X,int Y,color clr)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
color Color(bool P,color aaaa,color b)
  {
   if(P) return(aaaa);
   return(b);
  }

//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               xx=0,                      // X coordinate
                  const int               yy=0,                      // Y coordinate
                  const int               width=80,                 // button width
                  const int               height2=18,                // button height
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_LOWER,// chart corner for anchoring
                  const string            text="Button",            // text
                  const string            font="Arial",             // font
                  const int               font_size=10,             // font size
                  const color             clr=clrBlack,             // text color
                  const color             back_clr=C'236,233,216',  // background color
                  const color             border_clr=clrNONE,       // border color
                  const bool              state=false,              // pressed/released
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden=true,              // hidden in the object list
                  const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create the button
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
//      Print(__FUNCTION__,
//            ": failed to create the button! Error code = ",GetLastError());
      return(false);
     }
//--- set button coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set button size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the button by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void Button()
{
//--- create the button
 if (1==1)
 {
   lenght = 150;
   height = 20;
//   x = 10;y = 100;   
   x = 10;y = 100;   

   // Detects extra characters after symbol name.
   ExtraSymbolChar = StringSubstr(Symbol(), 6, 10);
   
   // Detects a dash in middle of symbol name.
   if (StringSubstr(Symbol(), 4, 1) == "-") dash = "-";
   else dash = "";
   if(!ButtonCreate(0,InpName,0,x,y,lenght,height,InpCorner,"Close Everything",InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s1 = "EUR" + dash + "USD" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName19,0,x,y,lenght,height,InpCorner,s1,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s2 = "GBP" + dash + "USD" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName20,0,x,y,lenght,height,InpCorner,s2,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s3 = "AUD" + dash + "USD" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName21,0,x,y,lenght,height,InpCorner,s3,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s4 = "EUR" + dash + "GBP" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName22,0,x,y,lenght,height,InpCorner,s4,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s5 = "GBP" + dash + "JPY" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName23,0,x,y,lenght,height,InpCorner,s5,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s6 = "USD" + dash + "JPY" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName24,0,x,y,lenght,height,InpCorner,s6,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s7 = "EUR" + dash + "JPY" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName25,0,x,y,lenght,height,InpCorner,s7,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s8 = "CHF" + dash + "JPY" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName26,0,x,y,lenght,height,InpCorner,s8,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s9 = "NZD" + dash + "JPY" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName27,0,x,y,lenght,height,InpCorner,s9,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s10 = "AUD" + dash + "JPY" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName28,0,x,y,lenght,height,InpCorner,s10,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s11 = "CAD" + dash + "JPY" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName29,0,x,y,lenght,height,InpCorner,s11,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s12 = "EUR" + dash + "CHF" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName30,0,x,y,lenght,height,InpCorner,s12,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s13 = "USD" + dash + "CHF" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName31,0,x,y,lenght,height,InpCorner,s13,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s14 = "GBP" + dash + "CHF" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName32,0,x,y,lenght,height,InpCorner,s14,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s15 = "CAD" + dash + "CHF" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName33,0,x,y,lenght,height,InpCorner,s15,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s16 = "NZD" + dash + "CHF" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName34,0,x,y,lenght,height,InpCorner,s16,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s17 = "AUD" + dash + "CHF" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName35,0,x,y,lenght,height,InpCorner,s17,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s18 = "USD" + dash + "CAD" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName36,0,x,y,lenght,height,InpCorner,s18,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s19 = "AUD" + dash + "CAD" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName37,0,x,y,lenght,height,InpCorner,s19,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s20 = "EUR" + dash + "CAD" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName38,0,x,y,lenght,height,InpCorner,s20,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s21 = "NZD" + dash + "CAD" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName39,0,x,y,lenght,height,InpCorner,s21,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s22 = "GBP" + dash + "CAD" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName40,0,x,y,lenght,height,InpCorner,s22,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s23 = "AUD" + dash + "NZD" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName41,0,x,y,lenght,height,InpCorner,s23,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
   s24 = "GBP" + dash + "AUD" + ExtraSymbolChar;
   y = y + height;
   if(!ButtonCreate(0,InpName42,0,x,y,lenght,height,InpCorner,s24,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;
//   s25 = "XAU" + dash + "USD" + ExtraSymbolChar;
//   y = y + height;
//   if(!ButtonCreate(0,InpName43,0,x,y,lenght,height,InpCorner,s25,InpFont,InpFontSize,InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder)) return;

   ChartRedraw();
 }
//---
}


//+---------------1---------------------------------------------------+
//| ChartEvent func1tion                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event identifier  
                  const long& lparam,   // Event parameter of long type
                  const double& dparam, // Event parameter of double type
                  const string& sparam) // Event parameter of string type
  {
   string ShortName = WindowExpertName();
  //--- the left mouse button has been pressed on the chart
   if(id==CHARTEVENT_CLICK && lparam > x && lparam < lenght && dparam > y && dparam < height)
     {
      Alert("The coordinates of the mouse click on the chart are: x = ",lparam,"  y = ",dparam);
     }

//--- the mouse has been clicked on the graphic object
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button1") {killall();ObjectsDeleteAll();}
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button2") 
   {
   for(int xx=OrdersTotal()-1;xx>=0;xx--)
     {
      if(OrderSelect(xx,SELECT_BY_POS,MODE_TRADES))
         if(OrderProfit() > 0)
           {
         bool ret=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),4,CLR_NONE);
         if(ret==false)
            Print("OrderClose() error - ");
           } 
     }       
     ObjectsDeleteAll();
   }
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button3") 
   {
   for(xx=OrdersTotal()-1;xx>=0;xx--)
     {
      if(OrderSelect(xx,SELECT_BY_POS,MODE_TRADES))
         if(OrderProfit() < 0)
           {
         ret=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),4,CLR_NONE);
         if(ret==false)
            Print("OrderClose() error - ");
           } 
     }       
     ObjectsDeleteAll();
   }
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button4") {BuyOrder66(Symbol(),magic);}
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button5") {SellOrder70(Symbol(),magic);}
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button6")
	{
//   DeleteBuyPendingOrders(Symbol());
   PriceOffset = (MarketInfo(Symbol(),MODE_STOPLEVEL) + Gap_between_Orders) / PipValue;
//   if (PriceOffset < Gap_between_Orders) PriceOffset = Gap_between_Orders;
   PriceOffset2 = -PriceOffset;
   buygrid(Symbol());
   ObjectsDeleteAll();
	}
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button7")
	{ 
//	DeleteSellPendingOrders(Symbol());
   PriceOffset = (MarketInfo(Symbol(),MODE_STOPLEVEL) + Gap_between_Orders) / PipValue;
//   if (PriceOffset < Gap_between_Orders) PriceOffset = Gap_between_Orders;
   PriceOffset2 = -PriceOffset;
   sellgrid(Symbol());
   ObjectsDeleteAll();
   }
/*
	 if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button8")
	 {
	 if (OrdersTotal() == 0)
	 {
     BuyOrder66(Symbol(),magic,StartLot,0);
     SellOrder70(Symbol(),magic,StartLot,0);
     }
     else
     hedge(Symbol());
     ObjectsDeleteAll();
    }
*/    
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button9")
    {
      killpair(Symbol());
//      CloseAllSell(Symbol());
//      DeleteBuyPendingOrders(Symbol());
//      DeleteSellPendingOrders(Symbol());
//      ChartSetSymbolPeriod(0,Menu_Currency,0);
       ObjectsDeleteAll();      
    }

   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button10")
     {
      killpair(Symbol());
     }
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button11") {killbuy(Symbol());ObjectsDeleteAll();}
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button12") {killsell(Symbol());ObjectsDeleteAll();}
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button13") {DeleteAllOrders(Symbol());ObjectsDeleteAll();}
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button14") {DeleteBuyPendingOrders(Symbol());IfBuy_Limit_DoesNotExist30(Symbol());ObjectsDeleteAll();}
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button15") {DeleteSellPendingOrders(Symbol());IfSell_Limit_DoesNotExist(Symbol());ObjectsDeleteAll();}   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button16") {DeleteBuyPendingOrders(Symbol());IfOP_BuyStopDoesNotExist(Symbol(),magic,StartLot);ObjectsDeleteAll();}   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button17") {DeleteSellPendingOrders(Symbol());IfOP_SellStopDoesNotExist(Symbol(),magic,StartLot);ObjectsDeleteAll();}   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button18") {buygrid2(Symbol());ObjectsDeleteAll();}   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button47") {sellgrid2(Symbol());ObjectsDeleteAll();}   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button50") {buygrid(Symbol());sellgrid(Symbol());ObjectsDeleteAll();}   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button51") {BuyOrder1(Symbol(),0,0,StartLot);SellOrder1(Symbol(),0,0,StartLot);ObjectsDeleteAll();}   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button52") {ObjectsDeleteAll();}   

    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button19") {ChartSetSymbolPeriod(0,s1,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button20") {ChartSetSymbolPeriod(0,s2,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button21") {ChartSetSymbolPeriod(0,s3,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button22") {ChartSetSymbolPeriod(0,s4,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button23") {ChartSetSymbolPeriod(0,s5,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button24") {ChartSetSymbolPeriod(0,s6,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button25") {ChartSetSymbolPeriod(0,s7,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button26") {ChartSetSymbolPeriod(0,s8,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button27") {ChartSetSymbolPeriod(0,s9,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button28") {ChartSetSymbolPeriod(0,s10,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button29") {ChartSetSymbolPeriod(0,s11,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button30") {ChartSetSymbolPeriod(0,s12,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button31") {ChartSetSymbolPeriod(0,s13,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button32") {ChartSetSymbolPeriod(0,s14,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button33") {ChartSetSymbolPeriod(0,s15,Period());}

    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button34") {ChartSetSymbolPeriod(0,s16,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button35") {ChartSetSymbolPeriod(0,s17,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button36") {ChartSetSymbolPeriod(0,s18,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button37") {ChartSetSymbolPeriod(0,s19,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button38") {ChartSetSymbolPeriod(0,s20,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button39") {ChartSetSymbolPeriod(0,s21,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button40") {ChartSetSymbolPeriod(0,s22,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button41") {ChartSetSymbolPeriod(0,s23,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button42") {ChartSetSymbolPeriod(0,s24,Period());}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button43") {ChartSetSymbolPeriod(0,s25,Period());}

    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button49") {ChartSetSymbolPeriod(0,s26,Period());vlag = true;}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button45") {ChartSetSymbolPeriod(0,Symbol_Name,Period());read_signals(Symbol_Name,Order_Type,Entry,takeprofit,stoploss,Signal_Lot);}
    if(id==CHARTEVENT_OBJECT_CLICK && sparam == "Button46") {ChartSetSymbolPeriod(0,s28,Period());}
}

void IfSell_Limit_DoesNotExist(string simbool)
{
    bool exists = false;
    for (int i=OrdersTotal()-1; i >= 0; i--)
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
        if (OrderType() == OP_SELLLIMIT && OrderSymbol() == simbool && OrderMagicNumber() == magic)
        {
            exists = true;
        }
    }
    else
    {
        Print("OrderSelect() error - ", ErrorDescription(GetLastError()));
    }
    
    if (exists == false)
    {
        SellPendingOrder37(simbool);
    }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellPendingOrder37(string simbool)
{
                    lastlot = 0;
                    for(int ii=0; ii<OrdersTotal(); ii++)
                    {
                    if (OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
                    if(OrderType() == OP_SELLLIMIT && OrderSymbol()==simbool) 
                    if (lastlot < OrderLots()) lastlot=OrderLots();
                    }
                  if (lastlot == 0) lastlot = StartLot;  
                    else
                    {
                    if (Martingale)
                     lastlot = lastlot * multiplier;
                      else 
                     lastlot = lastlot + increment;
                    } 
//    killsell(simbool);
    int expire = TimeCurrent() + 60 * Expiration;
    double price = NormalizeDouble(MarketInfo(simbool,MODE_BID), NDigits) - PriceOffset2*PipValue*MarketInfo(simbool,MODE_POINT);
    double SL = price + Stoploss*PipValue*MarketInfo(simbool,MODE_POINT);
    if (Stoploss == 0) SL = 0;
    double TP = price - Takeprofit*PipValue*MarketInfo(simbool,MODE_POINT);
    if (Takeprofit == 0) TP = 0;
    if (Expiration == 0) expire = 0;
    int ticket2 = OrderSend(simbool, OP_SELLLIMIT,lastlot, price, 4, SL, TP, Name, magic, expire, CLR_NONE);
    if (ticket2 == -1)
    {
        Print("OrderSend() error - ", ErrorDescription(GetLastError()));
    }
    
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BuyPendingOrder41(string simbool)
{
                    lastlot = 0;
                    for(int ii=0; ii<OrdersTotal(); ii++)
                    {
                    if (OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
                    if(OrderType() == OP_BUYLIMIT && OrderSymbol()==simbool) 
                    if (lastlot < OrderLots()) lastlot=OrderLots();
                    }
                  if (lastlot == 0) lastlot = StartLot;  
                    else
                    {
                    if (Martingale)
                     lastlot = lastlot * multiplier;
                      else 
                     lastlot = lastlot + increment;
                    } 
//    killbuy(simbool);
    int expire = TimeCurrent() + 60 * Expiration;
    double price = NormalizeDouble(MarketInfo(simbool,MODE_ASK), NDigits) + PriceOffset2*PipValue*MarketInfo(simbool,MODE_POINT);
    double SL = price - Stoploss*PipValue*MarketInfo(simbool,MODE_POINT);
    if (Stoploss == 0) SL = 0;
    double TP = price + Takeprofit*PipValue*MarketInfo(simbool,MODE_POINT);
    if (Takeprofit == 0) TP = 0;
    if (Expiration == 0) expire = 0;
    int ticket2 = OrderSend(simbool, OP_BUYLIMIT,lastlot, price, 4, SL, TP, Name, magic, expire, CLR_NONE);
    if (ticket2 == -1)
    {
        Print("OrderSend() error - ", ErrorDescription(GetLastError()));
    }
    
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void IfBuy_Limit_DoesNotExist30(string simbool)
{
    bool exists = false;
    for (int i=OrdersTotal()-1; i >= 0; i--)
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
        if (OrderType() == OP_BUYLIMIT && OrderSymbol() == simbool && OrderMagicNumber() == magic)
       {
            exists = true;
        }
    }
    else
    {
        Print("OrderSelect() error - ", ErrorDescription(GetLastError()));
    }
    
    if (exists == false)
    {
        BuyPendingOrder41(simbool);
    }
}

   void read_signals(string simbool,string type,string entry,string tp2,string sl2,double lot)
   {
   //Comment(simbool+"   "+type+"   "+entry+"   "+tp2+"   "+sl2);
         if (Symbol_Name != "")
         {
         if (type == "Buy" && MarketInfo(Symbol_Name,MODE_BID) < StrToDouble(entry)) Stop_BuyOrder(simbool,StrToDouble(entry),StrToDouble(tp2),StrToDouble(sl2),lot);
         if (type == "Buy" && MarketInfo(simbool,MODE_BID) > StrToDouble(entry)) BuyOrder1(simbool,StrToDouble(tp2),StrToDouble(sl2),lot);
   
         if (type == "Sell" && MarketInfo(simbool,MODE_BID) > StrToDouble(entry)) Stop_Sell_Order(simbool,StrToDouble(entry),StrToDouble(tp2),StrToDouble(sl2),lot);
         if (type == "Sell" && MarketInfo(simbool,MODE_BID) < StrToDouble(entry)) SellOrder1(simbool,StrToDouble(tp2),StrToDouble(sl2),lot);
        } 
        else
        {
         if (type == "Buy" && StrToDouble(entry) == 0) BuyOrder1(simbool,StrToDouble(tp2),StrToDouble(sl2),lot);
         if (type == "Sell" && StrToDouble(entry) == 0) SellOrder1(simbool,StrToDouble(tp2),StrToDouble(sl2),lot);
        }
   }     
   //********************************************************************************************************************************************

void BuyOrder1(string simbool,double takeprofit1,double stoploss1,double lot)
  {
   bool exists=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_BUY && OrderSymbol()==simbool && OrderMagicNumber()==magic)
           {
            exists=true;
           }
        }
      else
        {
         Print("OrderSelect() error - ");
        }

//   if(exists) Alert(simbool+" has open orders");
   if(exists==false)
      ticket = OrderSend(simbool, OP_BUY, lot, MarketInfo(simbool,MODE_ASK), 4, stoploss1, takeprofit1, Name, magic, 0, Blue);
  } 

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellOrder1(string simbool,double takeprofit1,double stoploss1,double lot)
  {
   bool exists=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_SELL && OrderSymbol()==simbool && OrderMagicNumber()==magic)
           {
            exists=true;
           }
        }
      else
        {
         Print("OrderSelect() error - ");
        }

//   if(exists) Alert(simbool+" has open orders");
   if(exists==false)
      ticket = OrderSend(simbool, OP_SELL, lot, MarketInfo(simbool,MODE_BID), 4, stoploss1, takeprofit1, Name, magic, 0, Red);
  }
//+------------------------------------------------------------------+
void Stop_BuyOrder(string simbool,double entry,double takeprofit1,double stoploss1,double lot)
  {
   bool exists=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_BUYSTOP && OrderSymbol()==simbool && OrderMagicNumber()==magic)
           {
            exists=true;
           }
        }
      else
        {
         Print("OrderSelect() error - ");
        }

   if(exists) Alert(simbool+" has open orders");
   if(exists==false)
   {
    PipValue = 1;
    NDigits = MarketInfo(simbool,MODE_DIGITS);
    if (NDigits == 3 || NDigits == 5) PipValue = 10;
    
   PriceOffset = (MarketInfo(simbool,MODE_STOPLEVEL) + Gap_between_Orders) / PipValue;
   if (PriceOffset < Gap_between_Orders) PriceOffset = Gap_between_Orders;

   datetime expire=TimeCurrent()+60*Expiration;
   double price=NormalizeDouble(MarketInfo(simbool,MODE_ASK),NDigits)+PriceOffset*PipValue*MarketInfo(simbool,MODE_POINT);
   double SL=price-stoploss1*PipValue*MarketInfo(simbool,MODE_POINT);
   if(stoploss1==0)
      SL=0;
   double TP=price+takeprofit1*PipValue*MarketInfo(simbool,MODE_POINT);
   if(takeprofit1 == 0)
      TP = 0;
   if(Expiration == 0)
      expire = 0;
   ticket=OrderSend(simbool,OP_BUYSTOP,lot,entry,4,stoploss1,takeprofit1,Name,magic,expire,clrNONE);
   if(ticket==-1)
     {
      Print("OrderSend() error - ");
     }
   }
  } 

void Stop_Sell_Order(string simbool,double entry,double takeprofit1,double stoploss1,double lot)
  {
   bool exists=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_SELLSTOP && OrderSymbol()==simbool && OrderMagicNumber()==magic)
           {
            exists=true;
           }
        }
      else
        {
         Print("OrderSelect() error - ");
        }

   if(exists) Alert(simbool+" has open orders");
   if(exists==false)
   {
    PipValue = 1;
    NDigits = MarketInfo(simbool,MODE_DIGITS);
    if (NDigits == 3 || NDigits == 5) PipValue = 10;
    
   PriceOffset = (MarketInfo(simbool,MODE_STOPLEVEL) + Gap_between_Orders) / PipValue;
   if (PriceOffset < Gap_between_Orders) PriceOffset = Gap_between_Orders;

   datetime expire=TimeCurrent()+60*Expiration;
   double price=NormalizeDouble(MarketInfo(simbool,MODE_BID),NDigits)-PriceOffset*PipValue*MarketInfo(simbool,MODE_POINT);
   double SL=price+stoploss1*PipValue*MarketInfo(simbool,MODE_POINT);
   if(stoploss1==0)
      SL=0;
   double TP=price-takeprofit1*PipValue*MarketInfo(simbool,MODE_POINT);
   if(takeprofit1 == 0)
      TP = 0;
   if(Expiration == 0)
      expire = 0;
   ticket=OrderSend(simbool,OP_SELLSTOP,lot,entry,4,stoploss1,takeprofit1,Name,magic,expire,clrNONE);
   if(ticket==-1)
     {
      Print("OrderSend() error - ");
     }
   }
  }

void pz_buy(string simbool)
{
   DeleteBuyPendingOrders(simbool);
//   DeleteSellPendingOrders(simbool);
   // Confirm
//   if(MessageBox(Name +" - Do you really want to place "+ (PendingOrders+1) +" BUYSTOP orders?",
//                 "Script",MB_YESNO|MB_ICONQUESTION)!=IDYES) return;
   // Pip value 
   DecimalPip = GetDecimalPip();
   
   // iBars(simbool,tframe)
   double CLOSE = iClose(Symbol(),0, Shift);
   double HIGH = iHigh(Symbol(),0, Shift);
   double LOW = iLow(Symbol(),0, Shift);
   
   //--
  //--
   //-- Place pending orders
   //--
   for(int it = 0; it < PendingOrders; it++)
      PlaceOrder(OP_BUYSTOP,  GetLotSize(simbool), LastOrderPrice + iATR(Symbol(), 0, ATRPeriod, Shift)*ATROrderMultiplier);
}

void pz_sell(string simbool)
{
//   DeleteBuyPendingOrders(simbool);
   DeleteSellPendingOrders(simbool);
    // Confirm
//   if(MessageBox(Name +" - Do you really want to place "+ (PendingOrders+1) +" SELLSTOP orders?",
//                 "Script",MB_YESNO|MB_ICONQUESTION)!=IDYES) return;
                 
   // Pip value 
   DecimalPip = GetDecimalPip();
   
   // iBars(simbool,tframe)
   double CLOSE = iClose(Symbol(),0, Shift);
   double HIGH = iHigh(Symbol(),0, Shift);
   double LOW = iLow(Symbol(),0, Shift);
   
   //--
   //--
   //-- Place pending orders
   //--
   for(int it = 0; it < PendingOrders; it++)
      PlaceOrder(OP_SELLSTOP,  GetLotSize(simbool), LastOrderPrice - iATR(Symbol(), 0, ATRPeriod, Shift)*ATROrderMultiplier);
}

double GetLotSize(string simbool)
{
   // Lots
   double l_lotz = StartLot;
   
   // Lotsize and restrictions 
   double l_minlot = MarketInfo(simbool, MODE_MINLOT);
   double l_maxlot = MarketInfo(simbool, MODE_MAXLOT);
   double l_lotstep = MarketInfo(simbool, MODE_LOTSTEP);
   int vp = 0; if(l_lotstep == 0.01) vp = 2; else vp = 1;
   
   // Apply money management
   if(MoneyManagement == true)
      l_lotz = MathFloor(AccountBalance() * RiskPercent / 100.0) / 1000.0;
  
   // Wait! Check if we are pyramiding
   if(LastOrderLots != EMPTY_VALUE && LastOrderLots > 0)
      l_lotz = LastOrderLots * RiskDecrease;
      
   // Normalize to lotstep
   l_lotz = NormalizeDouble(l_lotz, vp);
   
   // Check max/minlot here
   if (l_lotz < l_minlot) l_lotz = l_minlot;
   if(l_lotz > l_maxlot) l_lotz = l_maxlot; 
   
   // Bye!
   return (l_lotz);
}


/**
* Places an order
* @param    int      Type
* @param    double   Lotz
* @param    double   PendingPrice
*/

void PlaceOrder(int Type, double Lotz, double PendingPrice = 0)
{  
   // Local
   int err;
   color  l_color;
   double l_stoploss, l_price, l_sprice = 0;
   stoplevel = getStopLevelInPips();
   RefreshRates();
   
   // Price and color for the trade type
   if(Type == OP_BUY){ l_price = Ask;  l_color = Blue; }
   if(Type == OP_SELL){ l_price = Bid; l_color = Red; } 
   if(Type == OP_BUYSTOP) { l_price = PendingPrice; if(l_price <= Ask+stoplevel*DecimalPip) l_price = Ask + stoplevel*DecimalPip; l_color = LightBlue; }
   if(Type == OP_SELLSTOP) { l_price = PendingPrice; if(l_price >= Bid-stoplevel*DecimalPip) l_price = Bid - stoplevel*DecimalPip; l_color = Salmon; }
   
   // Avoid collusions
   while (IsTradeContextBusy()) Sleep(1000);
   int l_datetime = TimeCurrent();
   
   // Send order
   int l_ticket = OrderSend(Symbol(), Type, Lotz, MyNormalizeDouble(l_price), Slippage, 0, 0, Name, MagicNumber, 0, l_color);
   
   // Rety if failure
   if (l_ticket == -1)
   {
      while(l_ticket == -1 && TimeCurrent() - l_datetime < 5 && !IsTesting())
      {
         err = GetLastError();
         if (err == 148) return;
         Sleep(1000);
         while (IsTradeContextBusy()) Sleep(1000);
         RefreshRates();
         l_ticket = OrderSend(Symbol(), Type, Lotz, MyNormalizeDouble(l_price), Slippage, 0, 0, Name, MagicNumber, 0, l_color);
      }
      if (l_ticket == -1)
         Print(Name +" (OrderSend Error) "+ ErrorDescription(GetLastError()));
   }
   if (l_ticket != -1)
   {
      LastOrderLots = Lotz; 
      LastOrderPrice = l_price;
      if (OrderSelect(l_ticket, SELECT_BY_TICKET, MODE_TRADES))
      {
         l_stoploss = 0;//MyNormalizeDouble(GetStopLoss(Type, PendingPrice));
         if(!OrderModify(l_ticket, OrderOpenPrice(), l_stoploss, 0, 0, Green))
            Print(Name +" (OrderModify Error) "+ ErrorDescription(GetLastError())); 
      }
   }
}

/**
* Returns initial stoploss1
* @param   int       Type
* @param   double    ForcedPrice
* @return  double
*/
double GetStopLoss(int Type, double ForcedPrice = 0)
{
   double l_sl = 0;
   if(Type == OP_BUY) l_sl = Ask - iATR(Symbol(), 0, ATRPeriod, Shift)*ATRStopMultiplier - (Ask - Bid);
   if(Type == OP_SELL) l_sl = Bid + iATR(Symbol(), 0, ATRPeriod, Shift)*ATRStopMultiplier + (Ask - Bid);
   if(Type == OP_BUYSTOP) l_sl = ForcedPrice - iATR(Symbol(), 0, ATRPeriod, Shift)*ATRStopMultiplier - (Ask - Bid);
   if(Type == OP_SELLSTOP) l_sl = ForcedPrice + iATR(Symbol(), 0, ATRPeriod, Shift)*ATRStopMultiplier + (Ask - Bid);
   return (l_sl);
}

/**
* Returns decimal pip value
* @return   double
*/
double GetDecimalPip()
{
   switch(Digits)
   {
      case 5: return(0.0001);
      case 4: return(0.0001);
      case 3: return(0.001);
      default: return(0.01);
   }
}

double MyNormalizeDouble(double price)
{
   return (NormalizeDouble(price, Digits));
}

/**
* Get baseline plus deviation
* @return   double
*/
double getStopLevelInPips()
{
   double s = MarketInfo(Symbol(), MODE_STOPLEVEL) + 1.0;
   if(Digits == 5) s = s / 10;
   return(s);
}   

void ma(string simbool,int timeframe)
  {
//   string simbool = Symbol(); 
   if(PosSelect(simbool)==0)
     {
      if(Signal(simbool,timeframe) == 1)//Buy signal and no current chart positions exists
        {
          BuyOrder(simbool,LotSize2(simbool),StopLoss_ma,TakeProfit_ma);
        }
      if(Signal(simbool,timeframe) == -1)//Sell signal and no current chart positions exists
        {
         SellOrder(simbool,LotSize2(simbool),StopLoss_ma,TakeProfit_ma);
        }
     }
//   return;
  }
//////////////////////////////////////////////////////////////////////
//Moving Average signal function
int Signal(string simbool,int timeframe)
  {
//---New bar
   if(iVolume(simbool,timeframe,0)>1)
      return(0);
//---
   int sig=0;
//---Ma indicator for signal
   indi=iMA(simbool,timeframe,MovingPeriod,MovingShift,MovingMode,PRICE_CLOSE,0);
//---
   if(iOpen(simbool,timeframe,1)>indi && iClose(simbool,timeframe,1)<indi)//Sell signal
      sig=-1;
//---
   if(iOpen(simbool,timeframe,1)<indi && iClose(simbool,timeframe,1)>indi)//Buy signal
      sig=1;
//---
   return(sig);//Return value of sig
  }
//////////////////////////////////////////////////////////////////////
//Buy order function (ECN style -  stripping out the StopLoss_ma and
//TakeProfit_ma. Next, it modifies the newly opened market order by adding the desired SL_ma and TP_ma)
void BuyOrder(string simbool,double vol,double stop,double take)
  {
   if(CheckMoneyForTrade(simbool,OP_BUY,vol))
      int Ticket = OrderSend(simbool, OP_BUY, vol, MarketInfo(simbool,MODE_ASK), Slippage, 0, 0, "", magic, 0, Blue);
   //---
   if(Ticket<1)
     {
      Print("Order send error BUY order - errcode : ",GetLastError());
      return;
     }
   else
      Print("BUY order, Ticket : ",DoubleToStr(Ticket,0),", executed successfully!");
//---
   if(OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES))
     {
      SL_ma = MarketInfo(simbool,MODE_ASK) - stop * PipValue;
      TP_ma = MarketInfo(simbool,MODE_ASK) + take * PipValue;
      if(!OrderModify(OrderTicket(), OrderOpenPrice(), SL_ma, TP_ma, 0))
        {
         Print("Failed setting SL_ma/TP_ma BUY order, Ticket : ",DoubleToStr(Ticket,0));
         return;
        }
      else
         Print("Successfully setting SL_ma/TP_ma BUY order, Ticket : ",DoubleToStr(Ticket,0));
     }
  }
//////////////////////////////////////////////////////////////////////
//Sell order function (ECN style -  stripping out the StopLoss_ma and
//TakeProfit_ma. Next, it modifies the newly opened market order by adding the desired SL_ma and TP_ma)
void SellOrder(string simbool,double vol,double stop,double take)
  {
   if(CheckMoneyForTrade(simbool,OP_SELL,vol))
      int Ticket = OrderSend(simbool, OP_SELL, vol, MarketInfo(simbool,MODE_BID), Slippage, 0, 0, "", magic, 0, Red);
//---
   if(Ticket<1)
     {
      Print("Order send error SELL order - errcode : ",GetLastError());
      return;
     }
   else
      Print("SELL order, Ticket : ",DoubleToStr(Ticket,0),", executed successfully!");
//---
   if(OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES))
     {
      SL_ma = MarketInfo(simbool,MODE_BID) + stop * PipValue;
      TP_ma = MarketInfo(simbool,MODE_BID) - take * PipValue;
      if(!OrderModify(OrderTicket(), OrderOpenPrice(), SL_ma, TP_ma, 0))
        {
         Print("Failed setting SL_ma/TP_ma SELL order, Ticket : ",DoubleToStr(Ticket,0));
         return;
        }
      else
         Print("Successfully setting SL_ma/TP_ma SELL order, Ticket : ",DoubleToStr(Ticket,0));
     }
  }
//////////////////////////////////////////////////////////////////////
//Position selector function
int PosSelect(string simbool)
  {
   int posi=0;
   for(int k = OrdersTotal() - 1; k >= 0; k--)
     {
      if(!OrderSelect(k, SELECT_BY_POS))break;
      if(OrderSymbol()!=simbool&&OrderMagicNumber()!= magic)continue;
      if(OrderCloseTime() == 0 && OrderSymbol()==simbool && OrderMagicNumber()==magic)
        {
         if(OrderType() == OP_BUY)
            posi = 1; //Long position
         if(OrderType() == OP_SELL)
            posi = -1; //Short positon
        }
     }
   return(posi);
  }
//////////////////////////////////////////////////////////////////////
//Lots size calculation
double LotSize2(string simbool)
  {
   if(MM == true)
     {
   Lots=0;
   for(int ii=0; ii<OrdersTotal(); ii++)
     {
      if(OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==simbool)
            if(Lots<OrderLots())
               Lots=OrderLots();
     }
   if(Lots==0)
      Lots=StartLot;
   else
   if (Lots <Max_Lotsize)
     {
      if(Martingale)
         Lots=Lots*multiplier;
      if(Increment)
         Lots=Lots+increment;
     } 
     }

   return(Lots);
  }
////////////////////////////////////////////////////////////////
//Money check
bool CheckMoneyForTrade(string symb,int type,double lots)
  {
   double free_margin=AccountFreeMarginCheck(symb,type,lots);
   if(free_margin<0)
     {
      string oper=(type==OP_BUY)? "Buy":"Sell";
      Print("Not enough money for ",oper," ",lots," ",symb," Error code=",GetLastError());
      return(false);
     }
//--- checking successful
   return(true);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void indis(string simbool)
{
   if (!IsTesting())
   {
//   iCustom(simbool,0,"Ultima ABC",0,0);
   }
}

void gaps(string simbool,int b)
  {
/* 
 Thing to be done in future in this program to make it more efficient
 and more powerful:
   1. Make the dicission of the quantity of lots used according to 
      the scillators;
   2. This program will catch the gaps.
 Things to ware of:
   1. the spread;
   2. excuting the order not on the gap ends a little bit less.
*/
// Defining the variables to decide.
   Print("order time", order_time);
   double current_openprice = iOpen(simbool, b, 0);
   double previous_highprice = iHigh(simbool, b, 1);
   double previous_lowprice = iLow(simbool, b, 1);
   double point_gap = MarketInfo(simbool, MODE_POINT);
   int spread_gap = MarketInfo(simbool, MODE_SPREAD);
   datetime current_time = iTime(simbool, b, 0);
// catching the gap on sell upper gap
   if(current_openprice > previous_highprice + (min_gapsize + spread_gap)*point_gap &&
      current_time != order_time)
     {
      IfOrderDoesNotExist62(simbool,magic);
     }
//catching the gap on buy down gap
   if(current_openprice < previous_lowprice - (min_gapsize + spread_gap)*point_gap &&
      current_time != order_time)
     {
      IfOrderDoesNotExist61(simbool,magic);
     }
//----
//   return(0);
  }

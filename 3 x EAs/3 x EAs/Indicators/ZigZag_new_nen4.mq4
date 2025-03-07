//+------------------------------------------------------------------+
//|                                              ZigZag_new_nen4.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://onix-trade.net/forum/index.php?s=&showtopic=4786&view=findpost&p=272959"
#property indicator_chart_window
#property indicator_buffers  3
#property indicator_color1 Red
#property indicator_color2 LightSkyBlue
#property indicator_color3 LemonChiffon
#property indicator_width1 0
#property indicator_style1 0
//---- 
extern int ExtDepth=21;
extern int ExtDeviation=13;
extern int ExtBackstep=34;
extern int ExtLabel=0;
//---- 
//---- 
double ZigZagBuffer[], ha[], la[];
int timeFirstBar=0;
//+------------------------------------------------------------------+
//| ZigZag initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//---- 
   SetIndexBuffer(0,ZigZagBuffer); 
   SetIndexBuffer(1,ha);
   SetIndexBuffer(2,la);
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(1,159);
   SetIndexArrow(2,159);
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   IndicatorShortName("ZigZag("+ExtDepth+","+ExtDeviation+","+ExtBackstep+")");

   if (ExtLabel<0) ExtLabel=0;
   if (ExtLabel>1) ExtLabel=1;

//---- 
   return(0);
  }
//+------------------------------------------------------------------+
//|  ZigZag iteration function                                       |
//+------------------------------------------------------------------+
int start()
  {
   //----+ проверка количества баров на достаточность для корректного расчёта индикатора
   if (Bars-1<ExtDepth)return(0);
   //----+ Введение целых переменных памяти для пересчёта индикатора только на неподсчитанных барах
   static int time2,time3,time4;  
   //----+ Введение переменных с плавающей точкой для пересчёта индикатора только на неподсчитанных барах
   static  double ZigZag2,ZigZag3,ZigZag4;
   //----+ Введение целых переменных для пересчёта индикатора только на неподсчитанных барах и получение уже подсчитанных баров
   int MaxBar,limit,supr2_bar,supr3_bar,supr4_bar,counted_bars=IndicatorCounted();
   //---- проверка на возможные ошибки
   if (counted_bars<0)return(-1);
   //---- последний подсчитанный бар должен быть пересчитан
   if (counted_bars>0) counted_bars--;
   //----+ Введение переменных    
   int    index, shift, back,lasthighpos,lastlowpos;
   double val,res,TempBuffer[1];
   double curlow,curhigh,lasthigh,lastlow;
 
   int    metka=0; // =0 - до первого перелома ZZ. =1 - ищем метки максимумов. =2 - ищем метки минимумов.

   //---- определение номера самого старого бара, начиная с которого будет произедён полый пересчёт всех баров
   MaxBar=Bars-ExtDepth; 
   //---- определение номера стартового  бара в цикле, начиная с которого будет произедиться  пересчёт новых баров
   if (counted_bars==0 || Bars-counted_bars>2)
     {
      limit=MaxBar;
     }
   else 
     {
      //----
      supr2_bar=iBarShift(NULL,0,time2,TRUE);
      supr3_bar=iBarShift(NULL,0,time3,TRUE);
      supr4_bar=iBarShift(NULL,0,time4,TRUE);
      //----
      limit=supr3_bar;      
      if ((supr2_bar<0)||(supr3_bar<0)||(supr4_bar<0))
         {
          limit=MaxBar;
         }
     }
     
   //---- инициализация нуля
   if (limit>=MaxBar || timeFirstBar!=Time[Bars-1]) 
     {
      timeFirstBar=Time[Bars-1];
      limit=MaxBar; 
     } 
   //----  
   //---- изменение размера временного буфера

if (limit==MaxBar) ArrayResize(TempBuffer,Bars); else  ArrayResize(TempBuffer,limit+ExtBackstep+1);
     
   //----+-------------------------------------------------+ 
   
   //----+ начало первого большого цикла
   for(shift=limit; shift>=0; shift--)
     {
      //--- Low
      val=Low[Lowest(NULL,0,MODE_LOW,ExtDepth,shift)];
      if(val==lastlow) val=0.0;
      else 
        { 
         lastlow=val; 
         if((Low[shift]-val)>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=ZigZagBuffer[shift+back];
               if((res!=0)&&(res>val)) ZigZagBuffer[shift+back]=0.0; 
              }
           }
        }
      if (Low[shift]==val)
        {
         ZigZagBuffer[shift]=val; 
         if (ExtLabel==1) la[shift]=val;
        }
      else ZigZagBuffer[shift]=0.0;


      //--- High
      val=High[Highest(NULL,0,MODE_HIGH,ExtDepth,shift)];
      if(val==lasthigh) val=0.0;
      else 
        {
         lasthigh=val;
         if((val-High[shift])>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=TempBuffer[shift+back]; 
               if((res!=0)&&(res<val)) TempBuffer[shift+back]=0.0; 
              } 
           }
        }
      if (High[shift]==val)
        {
         TempBuffer[shift]=val; 
         if (ExtLabel==1) ha[shift]=val;
        }
      else TempBuffer[shift]=0.0;
     }
   //----+ конец первого большого цикла 
      
   // final cutting 
      lasthigh=-1; lasthighpos=-1;
      lastlow= -1; lastlowpos= -1;
   //----+-------------------------------------------------+
   
   //----+ начало второго большого цикла

   for(shift=limit; shift>=0; shift--)
     {
      curlow=ZigZagBuffer[shift];
      curhigh=TempBuffer[shift];
      if((curlow==0)&&(curhigh==0)) continue;
      //---
      if(curhigh!=0)
        {
         if(lasthigh>0) 
           {
            if(lasthigh<curhigh) TempBuffer[lasthighpos]=0;
            else TempBuffer[shift]=0;
           }
         //---
         if(lasthigh<curhigh || lasthigh<0)
           {
            lasthigh=curhigh;
            lasthighpos=shift;
           }
         lastlow=-1;
        }
      //----
      if(curlow!=0)
        {
         if(lastlow>0)
           {
            if(lastlow>curlow) ZigZagBuffer[lastlowpos]=0;
            else ZigZagBuffer[shift]=0;
           }
         //---
         if((curlow<lastlow)||(lastlow<0))
           {
            lastlow=curlow;
            lastlowpos=shift;
           } 
         lasthigh=-1;
        }
     }
   //----+ конец второго большого цикла
     
   //----+-------------------------------------------------+
   
   //----+ начало третьего цикла
   for(shift=limit; shift>=0; shift--)
     {
       res=TempBuffer[shift];
       if(res!=0.0) ZigZagBuffer[shift]=res;
     }
     //----+ конец третьего цикла
     
   // Проверка первого луча
   int i=0,j=0;
   res=0;
   for (shift=0;i<3;shift++)
     {
      if (ZigZagBuffer[shift]>0)
        {
         i++;
         if (i==1 && ZigZagBuffer[shift]==High[shift])
           {
            j=shift;
            res=ZigZagBuffer[shift];
           }
         if (i==2 && res>0 && ZigZagBuffer[shift]==High[shift])
           {
            if (ZigZagBuffer[shift]>=ZigZagBuffer[j]) ZigZagBuffer[j]=0; else ZigZagBuffer[shift]=0;
            res=0;
            i=0;
            j=0;
            shift=0;
           }
        }
     }

   //+--- Восстановление значений индикаторного буффера, которые могли быть утеряны 
   if (limit<MaxBar)
     {
      ZigZagBuffer[supr2_bar]=ZigZag2; 
      ZigZagBuffer[supr3_bar]=ZigZag3; 
      ZigZagBuffer[supr4_bar]=ZigZag4; 
      for(int qqq=supr4_bar-1; qqq>supr3_bar; qqq--)ZigZagBuffer[qqq]=0; 
      for(int ggg=supr3_bar-1; ggg>supr2_bar; ggg--)ZigZagBuffer[ggg]=0;
     }
   //+---+============================================+
  
   //+--- исправление возникающих горбов 
   double vel1, vel2, vel3, vel4;
   int bar1, bar2, bar3, bar4;
   int count;
   if (limit==MaxBar)supr4_bar=MaxBar;
   for(int bar=supr4_bar; bar>=0; bar--)
    {
     if (ZigZagBuffer[bar]!=0)
      {
       count++;
       vel4=vel3;bar4=bar3;
       vel3=vel2;bar3=bar2;
       vel2=vel1;bar2=bar1;
       vel1=ZigZagBuffer[bar];bar1=bar;
       if (count<3)continue; 
       if ((vel3<vel2)&&(vel2<vel1)){ZigZagBuffer[bar2]=0;bar=bar3+1;}
       if ((vel3>vel2)&&(vel2>vel1)){ZigZagBuffer[bar2]=0;bar=bar3+1;}
       if ((vel2==vel1)&&(vel1!=0 )){ZigZagBuffer[bar1]=0;bar=bar3+1;}
     }
    } 
   //+--- запоминание времени трёх последних перегибов Зигзага и значений индикатора в этих точках 
   time2=Time[bar2];
   time3=Time[bar3];
   time4=Time[bar4];
   ZigZag2=vel2;  
   ZigZag3=vel3; 
   ZigZag4=vel4; 
   //+---          
 //---- завершение вычислений значений индикатора

   if (ExtLabel==1)
     {
      for(shift=Bars-1; shift>=0; shift--)
        {
         if (ZigZagBuffer[shift]>0)
           {
            if (ha[shift]>0)
              {
//               metka=2; shift--;
               metka=2; la[shift]=0; shift--;
              }
            else
              {
//               metka=1; shift--;
               metka=1; ha[shift]=0; shift--;
              }
           }

         if (metka==0)
           {
            ha[shift]=0; la[shift]=0;
           }
         else if (metka==1)
           {
            if (ha[shift]>0) metka=0;
            la[shift]=0;
           }
         else if (metka==2)
           {
            if (la[shift]>0) metka=0;
            ha[shift]=0;
           }
        }
     }

return(0);
}
 //---+ +---------------------------------------------------------------------+
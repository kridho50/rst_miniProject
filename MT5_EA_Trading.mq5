//+------------------------------------------------------------------+
//|                                             MT5_EA_Trading.mq5   |
//|                              EA Trading - Moving Average Crossover|
//|                              Strategi: MA Cross (10 & 50 Period)  |
//+------------------------------------------------------------------+
#property copyright   "EA Trading MT5 - Siap Pakai"
#property link        "https://github.com/kridho50/rst_miniProject"
#property version     "1.00"
#property description "Expert Advisor Trading dengan strategi Moving Average Crossover"
#property description "Siap digunakan di MetaTrader 5 Android maupun Desktop"

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

//--- Input Parameter
input double           LotSize         = 0.01;          // Ukuran lot
input int              StopLoss        = 50;            // Stop Loss dalam pips
input int              TakeProfit      = 100;           // Take Profit dalam pips
input int              MagicNumber     = 123456;        // Magic number untuk identifikasi order
input int              FastMA          = 10;            // Period MA Cepat
input int              SlowMA          = 50;            // Period MA Lambat
input ENUM_TIMEFRAMES  Timeframe       = PERIOD_H1;     // Timeframe
input int              Slippage        = 10;            // Slippage maksimal
input bool             UseTrailingStop = true;          // Gunakan trailing stop
input int              TrailingStop    = 30;            // Trailing stop dalam pips
input int              TrailingStep    = 5;             // Trailing step dalam pips

//--- Handle indikator dan objek trading
int    g_handleFastMA;
int    g_handleSlowMA;
CTrade g_trade;

//--- Nama objek info panel
const string PANEL_PREFIX = "EA_INFO_";

//+------------------------------------------------------------------+
//| Fungsi inisialisasi EA                                           |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Buat handle indikator Moving Average
   g_handleFastMA = iMA(_Symbol, Timeframe, FastMA, 0, MODE_EMA, PRICE_CLOSE);
   g_handleSlowMA = iMA(_Symbol, Timeframe, SlowMA, 0, MODE_EMA, PRICE_CLOSE);

   if(g_handleFastMA == INVALID_HANDLE || g_handleSlowMA == INVALID_HANDLE)
     {
      Print("ERROR: Gagal membuat handle indikator MA. Periksa parameter.");
      return INIT_FAILED;
     }

//--- Konfigurasi objek trading
   g_trade.SetExpertMagicNumber(MagicNumber);
   g_trade.SetDeviationInPoints(Slippage);

//--- Tentukan filling mode yang didukung broker secara otomatis
   ENUM_ORDER_TYPE_FILLING fillingMode = ORDER_FILLING_FOK;
   uint fillingFlags = (uint)SymbolInfoInteger(_Symbol, SYMBOL_FILLING_MODE);
   if((fillingFlags & SYMBOL_FILLING_FOK) == 0)
     {
      if((fillingFlags & SYMBOL_FILLING_IOC) != 0)
         fillingMode = ORDER_FILLING_IOC;
      else
         fillingMode = ORDER_FILLING_RETURN;
     }
   g_trade.SetTypeFilling(fillingMode);

//--- Validasi parameter input
   if(LotSize <= 0)
     {
      Print("ERROR: LotSize harus lebih dari 0");
      return INIT_PARAMETERS_INCORRECT;
     }
   if(FastMA >= SlowMA)
     {
      Print("ERROR: FastMA harus lebih kecil dari SlowMA");
      return INIT_PARAMETERS_INCORRECT;
     }

   Print("EA Trading berhasil diinisialisasi. Magic:", MagicNumber,
         " | FastMA:", FastMA, " | SlowMA:", SlowMA);
   Alert("EA Trading AKTIF di ", _Symbol, " TF:", EnumToString(Timeframe));

   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//| Fungsi cleanup saat EA dihentikan                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- Hapus semua objek info panel dari chart
   ObjectsDeleteAll(0, PANEL_PREFIX);

//--- Hapus handle indikator
   if(g_handleFastMA != INVALID_HANDLE)
      IndicatorRelease(g_handleFastMA);
   if(g_handleSlowMA != INVALID_HANDLE)
      IndicatorRelease(g_handleSlowMA);

   Print("EA Trading dihentikan. Alasan kode: ", reason);
  }

//+------------------------------------------------------------------+
//| Fungsi utama yang berjalan setiap tick                           |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- Tampilkan info panel di chart
   DisplayInfo();

//--- Kelola trailing stop untuk posisi yang sudah ada
   if(UseTrailingStop)
      ManageTrailingStop();

//--- Periksa apakah sudah ada posisi aktif untuk symbol ini
   if(HasOpenPosition())
      return;

//--- Periksa sinyal buy atau sell
   if(CheckBuySignal())
      OpenBuyOrder();
   else if(CheckSellSignal())
      OpenSellOrder();
  }

//+------------------------------------------------------------------+
//| Cek apakah ada posisi yang sudah terbuka                         |
//+------------------------------------------------------------------+
bool HasOpenPosition()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(PositionGetSymbol(i) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//| Ambil nilai MA dari buffer                                        |
//+------------------------------------------------------------------+
bool GetMAValues(double &fastCurrent, double &fastPrev,
                 double &slowCurrent, double &slowPrev)
  {
   double fastBuf[], slowBuf[];
   ArraySetAsSeries(fastBuf, true);
   ArraySetAsSeries(slowBuf, true);

   if(CopyBuffer(g_handleFastMA, 0, 0, 3, fastBuf) < 3 ||
      CopyBuffer(g_handleSlowMA, 0, 0, 3, slowBuf) < 3)
     {
      Print("ERROR: Gagal mengambil data buffer indikator MA");
      return false;
     }

   fastCurrent = fastBuf[1];
   fastPrev    = fastBuf[2];
   slowCurrent = slowBuf[1];
   slowPrev    = slowBuf[2];
   return true;
  }

//+------------------------------------------------------------------+
//| Cek sinyal Buy: MA cepat cross di atas MA lambat                 |
//+------------------------------------------------------------------+
bool CheckBuySignal()
  {
   double fastCurrent, fastPrev, slowCurrent, slowPrev;
   if(!GetMAValues(fastCurrent, fastPrev, slowCurrent, slowPrev))
      return false;

//--- Sinyal buy: MA cepat baru saja melewati MA lambat dari bawah ke atas
   return (fastPrev <= slowPrev && fastCurrent > slowCurrent);
  }

//+------------------------------------------------------------------+
//| Cek sinyal Sell: MA cepat cross di bawah MA lambat               |
//+------------------------------------------------------------------+
bool CheckSellSignal()
  {
   double fastCurrent, fastPrev, slowCurrent, slowPrev;
   if(!GetMAValues(fastCurrent, fastPrev, slowCurrent, slowPrev))
      return false;

//--- Sinyal sell: MA cepat baru saja melewati MA lambat dari atas ke bawah
   return (fastPrev >= slowPrev && fastCurrent < slowCurrent);
  }

//+------------------------------------------------------------------+
//| Hitung Stop Loss dan Take Profit dalam harga                     |
//+------------------------------------------------------------------+
double CalcSL(bool isBuy)
  {
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double pipValue = (digits == 3 || digits == 5) ? point * 10 : point;
   double price = isBuy ? SymbolInfoDouble(_Symbol, SYMBOL_BID)
                        : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   return isBuy ? price - StopLoss * pipValue
                : price + StopLoss * pipValue;
  }

double CalcTP(bool isBuy)
  {
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double pipValue = (digits == 3 || digits == 5) ? point * 10 : point;
   double price = isBuy ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                        : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   return isBuy ? price + TakeProfit * pipValue
                : price - TakeProfit * pipValue;
  }

//+------------------------------------------------------------------+
//| Validasi lot size sesuai batasan broker                          |
//+------------------------------------------------------------------+
double ValidateLotSize(double lot)
  {
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   lot = MathMax(lot, minLot);
   lot = MathMin(lot, maxLot);
   lot = MathRound(lot / stepLot) * stepLot;
   return NormalizeDouble(lot, 2);
  }

//+------------------------------------------------------------------+
//| Buka posisi Buy                                                  |
//+------------------------------------------------------------------+
void OpenBuyOrder()
  {
   double lot = ValidateLotSize(LotSize);
   double sl  = CalcSL(true);
   double tp  = CalcTP(true);
   string comment = "EA_BUY_MA" + IntegerToString(FastMA) + "x" + IntegerToString(SlowMA);

   if(g_trade.Buy(lot, _Symbol, 0, sl, tp, comment))
     {
      Print("BUY ORDER dibuka | Lot:", lot, " | SL:", sl, " | TP:", tp);
      Alert("BELI ", _Symbol, " | Lot: ", lot, " | SL: ", sl, " | TP: ", tp);
     }
   else
     {
      Print("ERROR buka BUY order: ", g_trade.ResultRetcode(),
            " - ", g_trade.ResultRetcodeDescription());
     }
  }

//+------------------------------------------------------------------+
//| Buka posisi Sell                                                 |
//+------------------------------------------------------------------+
void OpenSellOrder()
  {
   double lot = ValidateLotSize(LotSize);
   double sl  = CalcSL(false);
   double tp  = CalcTP(false);
   string comment = "EA_SELL_MA" + IntegerToString(FastMA) + "x" + IntegerToString(SlowMA);

   if(g_trade.Sell(lot, _Symbol, 0, sl, tp, comment))
     {
      Print("SELL ORDER dibuka | Lot:", lot, " | SL:", sl, " | TP:", tp);
      Alert("JUAL ", _Symbol, " | Lot: ", lot, " | SL: ", sl, " | TP: ", tp);
     }
   else
     {
      Print("ERROR buka SELL order: ", g_trade.ResultRetcode(),
            " - ", g_trade.ResultRetcodeDescription());
     }
  }

//+------------------------------------------------------------------+
//| Tutup semua posisi yang dikelola EA ini                          |
//+------------------------------------------------------------------+
void CloseAllOrders()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(PositionGetSymbol(i) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == MagicNumber)
        {
         ulong ticket = PositionGetInteger(POSITION_TICKET);
         if(g_trade.PositionClose(ticket))
           {
            Print("Posisi ", ticket, " berhasil ditutup.");
            Alert("Posisi DITUTUP di ", _Symbol, " | Ticket: ", ticket);
           }
         else
           {
            Print("ERROR menutup posisi ", ticket, ": ",
                  g_trade.ResultRetcode(), " - ",
                  g_trade.ResultRetcodeDescription());
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Kelola trailing stop untuk posisi aktif                          |
//+------------------------------------------------------------------+
void ManageTrailingStop()
  {
   double point    = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int    digits   = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double pipValue = (digits == 3 || digits == 5) ? point * 10 : point;
   double tsLevel  = TrailingStop * pipValue;
   double tsStep   = TrailingStep * pipValue;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(PositionGetSymbol(i) != _Symbol ||
         PositionGetInteger(POSITION_MAGIC) != MagicNumber)
         continue;

      ulong  ticket  = PositionGetInteger(POSITION_TICKET);
      int    type    = (int)PositionGetInteger(POSITION_TYPE);
      double sl      = PositionGetDouble(POSITION_SL);
      double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);

      if(type == POSITION_TYPE_BUY)
        {
         double bid     = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         double newSL   = bid - tsLevel;
         newSL = NormalizeDouble(newSL, digits);
         //--- Geser SL hanya jika sudah menguntungkan minimal satu trailing stop
         if(bid - openPrice >= tsLevel &&
            (sl == 0 || newSL > sl + tsStep))
           {
            if(!g_trade.PositionModify(ticket, newSL,
                                       PositionGetDouble(POSITION_TP)))
               Print("ERROR modifikasi trailing stop BUY: ",
                     g_trade.ResultRetcodeDescription());
           }
        }
      else if(type == POSITION_TYPE_SELL)
        {
         double ask     = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         double newSL   = ask + tsLevel;
         newSL = NormalizeDouble(newSL, digits);
         //--- Geser SL hanya jika sudah menguntungkan minimal satu trailing stop
         if(openPrice - ask >= tsLevel &&
            (sl == 0 || newSL < sl - tsStep))
           {
            if(!g_trade.PositionModify(ticket, newSL,
                                       PositionGetDouble(POSITION_TP)))
               Print("ERROR modifikasi trailing stop SELL: ",
                     g_trade.ResultRetcodeDescription());
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Tampilkan info panel di chart                                    |
//+------------------------------------------------------------------+
void DisplayInfo()
  {
   double balance  = AccountInfoDouble(ACCOUNT_BALANCE);
   double equity   = AccountInfoDouble(ACCOUNT_EQUITY);
   double profit   = equity - balance;
   int    orders   = PositionsTotal();
   string currency = AccountInfoString(ACCOUNT_CURRENCY);

   int    x = 10, y = 20;
   int    fontSize = 10;
   color  clrTitle = clrDodgerBlue;
   color  clrProfit = (profit >= 0) ? clrLimeGreen : clrRed;

   string items[][2] =
     {
        {"EA_TITLE",   "=== EA TRADING MA CROSS ==="},
        {"EA_SYMBOL",  "Symbol   : " + _Symbol},
        {"EA_TF",      "Timeframe: " + EnumToString(Timeframe)},
        {"EA_BALANCE", "Balance  : " + currency + " " + DoubleToString(balance, 2)},
        {"EA_EQUITY",  "Equity   : " + currency + " " + DoubleToString(equity, 2)},
        {"EA_PROFIT",  "P/L      : " + currency + " " + DoubleToString(profit, 2)},
        {"EA_ORDERS",  "Posisi   : " + IntegerToString(orders)},
        {"EA_MAGIC",   "Magic    : " + IntegerToString(MagicNumber)}
     };

   int rows = ArrayRange(items, 0);
   for(int i = 0; i < rows; i++)
     {
      string name = PANEL_PREFIX + items[i][0];
      string text = items[i][1];
      color  clr  = (i == 0) ? clrTitle
                             : (StringFind(text, "P/L") >= 0) ? clrProfit
                                                              : clrWhite;
      if(ObjectFind(0, name) < 0)
        {
         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y + i * 18);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
         ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        }
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
     }

   ChartRedraw(0);
  }
//+------------------------------------------------------------------+

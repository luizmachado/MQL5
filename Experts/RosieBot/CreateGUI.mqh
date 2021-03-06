//+------------------------------------------------------------------+
//|                                                    CreateGUI.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Program.mqh"
//+------------------------------------------------------------------+
//| Создаёт графический интерфейс                                    |
//+------------------------------------------------------------------+
bool CProgram::CreateGUI(void)
  {
//--- Создание формы для элементов управления
   if(!CreateWindow("Stochastic signals"))
      return(false);
//--- Создание элементов управления
   if(!CreateStatusBar(1,23))
      return(false);
//--- Вкладки
   if(!CreateTabs1(3,43))
      return(false);
//--- Поля ввода
   if(!CreateSymbolsFilter(7,5,"Symbols filter:"))
      return(false);
   if(!CreateLot(180,30,"Lot:"))
      return(false);
   if(!CreateUpLevel(400,30,"Up level:"))
      return(false);
   if(!CreateDownLevel(510,30,"Down level:"))
      return(false);
   if(!CreateChartScale(120,150,"Chart scale:"))
      return(false);
//--- Кнопки
   if(!CreateRequest(85,5,"Request"))
      return(false);
   if(!CreateSell(7,30,"SELL"))
      return(false);
   if(!CreateBuy(90,30,"BUY"))
      return(false);
   if(!CreateCloseAll(270,30,"Close all positions"))
      return(false);
   if(!CreateChartShift(120,180,"Chart shift"))
      return(false);
//--- Комбо-боксы
   if(!CreateComboBoxTF(120,55,"Timeframes:"))
      return(false);
//--- Чек-боксы
   if(!CreateDateScale(120,90,"Date scale"))
      return(false);
   if(!CreatePriceScale(120,120,"Price scale"))
      return(false);
   if(!CreateShowIndicator(120,220,"Show indicator"))
      return(false);
//--- Таблицы
   if(!CreatePositionsTable(2,2))
      return(false);
   if(!CreateSymbolsTable(2,55))
      return(false);
//--- Стандартный график
   if(!CreateSubChart1(171,55))
      return(false);
//--- Индикатор выполнения
   if(!CreateProgressBar(2,3,"Processing:"))
      return(false);
//--- Завершение создания GUI
   CWndEvents::CompletedGUI();
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт форму для элементов управления                           |
//+------------------------------------------------------------------+
bool CProgram::CreateWindow(const string caption_text)
  {
//--- Добавим указатель окна в массив окон
   CWndContainer::AddWindow(m_window1);
//--- Свойства
   m_window1.XSize(750);
   m_window1.YSize(450);
   m_window1.FontSize(9);
   m_window1.IsMovable(true);
   m_window1.ResizeMode(true);
   m_window1.CloseButtonIsUsed(true);
   m_window1.CollapseButtonIsUsed(true);
   m_window1.TooltipsButtonIsUsed(true);
   m_window1.FullscreenButtonIsUsed(true);
//--- Установим всплывающие подсказки
   m_window1.GetCloseButtonPointer().Tooltip("Close");
   m_window1.GetTooltipButtonPointer().Tooltip("Tooltips");
   m_window1.GetFullscreenButtonPointer().Tooltip("Fullscreen");
   m_window1.GetCollapseButtonPointer().Tooltip("Collapse/Expand");
//--- Создание формы
   if(!m_window1.CreateWindow(m_chart_id,m_subwin,caption_text,1,1))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт статусную строку                                         |
//+------------------------------------------------------------------+
bool CProgram::CreateStatusBar(const int x_gap,const int y_gap)
  {
#define STATUS_LABELS_TOTAL 3
//--- Сохраним указатель на окно
   m_status_bar.MainPointer(m_window1);
//--- Свойства
   m_status_bar.AutoXResizeMode(true);
   m_status_bar.AutoXResizeRightOffset(1);
   m_status_bar.AnchorBottomWindowSide(true);
//--- Укажем сколько должно быть частей и установим им свойства
   int width[STATUS_LABELS_TOTAL]={0,200,110};
   for(int i=0; i<STATUS_LABELS_TOTAL; i++)
      m_status_bar.AddItem(width[i]);
//--- Создадим элемент управления
   if(!m_status_bar.CreateStatusBar(x_gap,y_gap))
      return(false);
//--- Установка текста в пункты статусной строки
   m_status_bar.SetValue(0,"For Help, press F1");
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_status_bar);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт прогресс бар                                             |
//+------------------------------------------------------------------+
bool CProgram::CreateProgressBar(const int x_gap,const int y_gap,const string text)
  {
//--- Сохраним указатель на главный элемент
   m_progress_bar.MainPointer(m_status_bar);
//--- Свойства
   m_progress_bar.YSize(17);
   m_progress_bar.BarYSize(14);
   m_progress_bar.BarXGap(0);
   m_progress_bar.BarYGap(1);
   m_progress_bar.LabelXGap(5);
   m_progress_bar.LabelYGap(2);
   m_progress_bar.PercentXGap(5);
   m_progress_bar.PercentYGap(2);
   m_progress_bar.IsDropdown(true);
   m_progress_bar.Font("Consolas");
   m_progress_bar.BorderColor(clrSilver);
   m_progress_bar.IndicatorBackColor(clrWhiteSmoke);
   m_progress_bar.IndicatorColor(clrLightGreen);
   m_progress_bar.AutoXResizeMode(true);
   m_progress_bar.AutoXResizeRightOffset(2);
//--- Создание элемента
   if(!m_progress_bar.CreateProgressBar(text,x_gap,y_gap))
      return(false);
//--- Добавим указатель на элемент в базу
   CWndContainer::AddToElementsArray(0,m_progress_bar);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт группу с вкладками 1                                     |
//+------------------------------------------------------------------+
bool CProgram::CreateTabs1(const int x_gap,const int y_gap)
  {
#define TABS1_TOTAL 2
//--- Сохраним указатель на главный элемент
   m_tabs1.MainPointer(m_window1);
//--- Свойства
   m_tabs1.IsCenterText(true);
   m_tabs1.PositionMode(TABS_TOP);
   m_tabs1.AutoXResizeMode(true);
   m_tabs1.AutoYResizeMode(true);
   m_tabs1.AutoXResizeRightOffset(3);
   m_tabs1.AutoYResizeBottomOffset(25);
//--- Добавим вкладки с указанными свойствами
   string tabs_names[TABS1_TOTAL]={"Trade","Positions"};
   for(int i=0; i<TABS1_TOTAL; i++)
      m_tabs1.AddTab(tabs_names[i],100);
//--- Создадим элемент управления
   if(!m_tabs1.CreateTabs(x_gap,y_gap))
      return(false);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_tabs1);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт чекбокс с полем ввода "Symbols filter"                   |
//+------------------------------------------------------------------+
bool CProgram::CreateSymbolsFilter(const int x_gap,const int y_gap,const string text)
  {
//--- Сохраним указатель на главный элемент
   m_symb_filter.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_symb_filter);
//--- Свойства
   m_symb_filter.SetValue("USD"); // "EUR,USD" "EURUSD,GBPUSD" "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCHF"
   m_symb_filter.CheckBoxMode(true);
   m_symb_filter.AutoXResizeMode(true);
   m_symb_filter.AutoXResizeRightOffset(90);
   m_symb_filter.GetTextBoxPointer().XGap(100);
   m_symb_filter.GetTextBoxPointer().AutoXResizeMode(true);
   m_symb_filter.GetTextBoxPointer().AutoSelectionMode(true);
   m_symb_filter.GetTextBoxPointer().DefaultText("Example: EURUSD,GBP,NOK");
//--- Создадим элемент управления
   if(!m_symb_filter.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Включим чек-бокс
   m_symb_filter.IsPressed(true);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_symb_filter);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт поле ввода "Lot"                                         |
//+------------------------------------------------------------------+
bool CProgram::CreateLot(const int x_gap,const int y_gap,const string text)
  {
//--- Сохраним указатель на главный элемент
   m_lot.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_lot);
//--- Свойства
   m_lot.XSize(80);
   m_lot.MaxValue(1000);
   m_lot.MinValue(0.01);
   m_lot.StepValue(0.01);
   m_lot.SetDigits(2);
   m_lot.SpinEditMode(true);
   m_lot.SetValue((string)0.1);
   m_lot.GetTextBoxPointer().XSize(50);
   m_lot.GetTextBoxPointer().AutoSelectionMode(true);
   m_lot.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_lot.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_lot);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт поле ввода "Up level"                                    |
//+------------------------------------------------------------------+
bool CProgram::CreateUpLevel(const int x_gap,const int y_gap,const string text)
  {
//--- Сохраним указатель на главный элемент
   m_up_level.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_up_level);
//--- Свойства
   m_up_level.XSize(100);
   m_up_level.MaxValue(100);
   m_up_level.MinValue(50);
   m_up_level.StepValue(1);
   m_up_level.SetDigits(0);
   m_up_level.SpinEditMode(true);
   m_up_level.SetValue((string)80);
   m_up_level.GetTextBoxPointer().XSize(50);
   m_up_level.GetTextBoxPointer().AutoSelectionMode(true);
   m_up_level.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_up_level.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_up_level);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт поле ввода "Down level"                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateDownLevel(const int x_gap,const int y_gap,const string text)
  {
//--- Сохраним указатель на главный элемент
   m_down_level.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_down_level);
//--- Свойства
   m_down_level.XSize(115);
   m_down_level.MaxValue(50);
   m_down_level.MinValue(0);
   m_down_level.StepValue(1);
   m_down_level.SetDigits(0);
   m_down_level.SpinEditMode(true);
   m_down_level.SetValue((string)20);
   m_down_level.GetTextBoxPointer().XSize(50);
   m_down_level.GetTextBoxPointer().AutoSelectionMode(true);
   m_down_level.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_down_level.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_down_level);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку для обновления списка символов                    |
//+------------------------------------------------------------------+
bool CProgram::CreateRequest(const int x_gap,const int y_gap,const string text)
  {
//--- Сохранить указатель на главный элемент
   m_request.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_request);
//--- Свойства
   m_request.XSize(80);
   m_request.IsCenterText(true);
   m_request.AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_request.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Добавим указатель на элемент в базу
   CWndContainer::AddToElementsArray(0,m_request);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку для смещения графика                              |
//+------------------------------------------------------------------+
bool CProgram::CreateChartShift(const int x_gap,const int y_gap,const string text)
  {
//--- Сохраним указатель на окно
   m_chart_shift.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_chart_shift);
//--- Свойства
   m_chart_shift.XSize(115);
   m_chart_shift.IsCenterText(true);
   m_chart_shift.AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_chart_shift.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Включить чек-бокс
   m_chart_shift.IsPressed(true);
//--- Добавим указатель на элемент в базу
   CWndContainer::AddToElementsArray(0,m_chart_shift);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку "Sell"                                            |
//+------------------------------------------------------------------+
bool CProgram::CreateSell(const int x_gap,const int y_gap,const string text)
  {
//--- Сохранить указатель на главный элемент
   m_sell.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_sell);
//--- Свойства
   m_sell.XSize(80);
   m_sell.IsCenterText(true);
   m_sell.BackColor(C'255,51,51');
   m_sell.BackColorHover(C'255,100,100');
   m_sell.BackColorPressed(C'195,0,0');
   m_sell.LabelColor(clrWhite);
   m_sell.LabelColorHover(clrWhite);
   m_sell.LabelColorPressed(clrWhite);
   m_sell.BorderColor(clrBlack);
   m_sell.BorderColorHover(clrBlack);
   m_sell.BorderColorPressed(clrBlack);
//--- Создадим элемент управления
   if(!m_sell.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Добавим указатель на элемент в базу
   CWndContainer::AddToElementsArray(0,m_sell);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку "Buy"                                             |
//+------------------------------------------------------------------+
bool CProgram::CreateBuy(const int x_gap,const int y_gap,const string text)
  {
//--- Сохранить указатель на главный элемент
   m_buy.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_buy);
//--- Свойства
   m_buy.XSize(80);
   m_buy.IsCenterText(true);
   m_buy.BackColor(C'85,170,255');
   m_buy.BackColorHover(C'105,190,255');
   m_buy.BackColorPressed(C'50,100,135');
   m_buy.LabelColor(clrWhite);
   m_buy.LabelColorHover(clrWhite);
   m_buy.LabelColorPressed(clrWhite);
   m_buy.BorderColor(clrBlack);
   m_buy.BorderColorHover(clrBlack);
   m_buy.BorderColorPressed(clrBlack);
//--- Создадим элемент управления
   if(!m_buy.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Добавим указатель на элемент в базу
   CWndContainer::AddToElementsArray(0,m_buy);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку для закрытия всех позиций                         |
//+------------------------------------------------------------------+
bool CProgram::CreateCloseAll(const int x_gap,const int y_gap,const string text)
  {
//--- Сохранить указатель на главный элемент
   m_close_all.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_close_all);
//--- Свойства
   m_close_all.XSize(110);
   m_close_all.IsCenterText(true);
//--- Создадим элемент управления
   if(!m_close_all.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Добавим указатель на элемент в базу
   CWndContainer::AddToElementsArray(0,m_close_all);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт комбо-бокс для выбора таймфреймов                        |
//+------------------------------------------------------------------+
bool CProgram::CreateComboBoxTF(const int x_gap,const int y_gap,const string text)
  {
//--- Общее количество пунктов в списке
#define ITEMS_TOTAL2 21
//--- Передать объект панели
   m_timeframes.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_timeframes);
//--- Свойства
   m_timeframes.XSize(115);
   m_timeframes.ItemsTotal(ITEMS_TOTAL2);
   m_timeframes.AnchorRightWindowSide(true);
   m_timeframes.GetButtonPointer().XSize(50);
   m_timeframes.GetButtonPointer().AnchorRightWindowSide(true);
//--- Сохраним значения пунктов в список комбо-бокса
   string items_text[ITEMS_TOTAL2]={"M1","M2","M3","M4","M5","M6","M10","M12","M15","M20","M30","H1","H2","H3","H4","H6","H8","H12","D1","W1","MN"};
   for(int i=0; i<ITEMS_TOTAL2; i++)
      m_timeframes.SetValue(i,items_text[i]);
//--- Получим указатель списка
   CListView *lv=m_timeframes.GetListViewPointer();
//--- Установим свойства списка
   lv.LightsHover(true);
   lv.SelectItem(18);
//--- Создадим элемент управления
   if(!m_timeframes.CreateComboBox(text,x_gap,y_gap))
      return(false);
//--- Добавим указатель на элемент в базу
   CWndContainer::AddToElementsArray(0,m_timeframes);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт чекбокс "Date scale"                                     |
//+------------------------------------------------------------------+
bool CProgram::CreateDateScale(const int x_gap,const int y_gap,const string text)
  {
//--- Сохраним указатель на окно
   m_date_scale.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_date_scale);
//--- Свойства
   m_date_scale.XSize(70);
   m_date_scale.AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_date_scale.CreateCheckBox(text,x_gap,y_gap))
      return(false);
//--- Включить чек-бокс
   m_date_scale.IsPressed(true);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_date_scale);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт чекбокс "Price scale"                                    |
//+------------------------------------------------------------------+
bool CProgram::CreatePriceScale(const int x_gap,const int y_gap,const string text)
  {
//--- Сохраним указатель на окно
   m_price_scale.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_price_scale);
//--- Свойства
   m_price_scale.XSize(70);
   m_price_scale.AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_price_scale.CreateCheckBox(text,x_gap,y_gap))
      return(false);
//--- Включить чек-бокс
   m_price_scale.IsPressed(true);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_price_scale);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт чекбокс "Show indicator"                                 |
//+------------------------------------------------------------------+
bool CProgram::CreateShowIndicator(const int x_gap,const int y_gap,const string text)
  {
//--- Сохраним указатель на окно
   m_show_indicator.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_show_indicator);
//--- Свойства
   m_show_indicator.XSize(90);
   m_show_indicator.AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_show_indicator.CreateCheckBox(text,x_gap,y_gap))
      return(false);
//--- Включить чек-бокс
   m_show_indicator.IsPressed(false);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_show_indicator);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт чекбокс с полем ввода "Chart scale"                      |
//+------------------------------------------------------------------+
bool CProgram::CreateChartScale(const int x_gap,const int y_gap,const string text)
  {
//--- Сохраним указатель на главный элемент
   m_chart_scale.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_chart_scale);
//--- Свойства
   m_chart_scale.XSize(115);
   m_chart_scale.MaxValue(5);
   m_chart_scale.MinValue(0);
   m_chart_scale.StepValue(1);
   m_chart_scale.SetDigits(0);
   m_chart_scale.SpinEditMode(true);
   m_chart_scale.SetValue((string)::ChartGetInteger(0,CHART_SCALE));
   m_chart_scale.AnchorRightWindowSide(true);
   m_chart_scale.GetTextBoxPointer().XSize(50);
   m_chart_scale.GetTextBoxPointer().AutoSelectionMode(true);
   m_chart_scale.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_chart_scale.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_chart_scale);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт таблицу символов                                         |
//+------------------------------------------------------------------+
bool CProgram::CreateSymbolsTable(const int x_gap,const int y_gap)
  {
#define COLUMNS1_TOTAL 2
#define ROWS1_TOTAL    1
//--- Сохраним указатель на главный элемент
   m_table_symb.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(0,m_table_symb);
//--- Массив ширины столбцов
   int width[COLUMNS1_TOTAL]={95,58};
//--- Массив выравнивания текста в столбцах
   ENUM_ALIGN_MODE align[COLUMNS1_TOTAL]={ALIGN_LEFT,ALIGN_RIGHT};
//--- Массив отступа текста в столбцах по оси X
   int text_x_offset[COLUMNS1_TOTAL]={5,5};
//--- Свойства
   m_table_symb.XSize(168);
   m_table_symb.TableSize(COLUMNS1_TOTAL,ROWS1_TOTAL);
   m_table_symb.ColumnsWidth(width);
   m_table_symb.TextAlign(align);
   m_table_symb.TextXOffset(text_x_offset);
   m_table_symb.ShowHeaders(true);
   m_table_symb.SelectableRow(true);
   m_table_symb.ColumnResizeMode(true);
   m_table_symb.IsZebraFormatRows(clrWhiteSmoke);
   m_table_symb.AutoYResizeMode(true);
   m_table_symb.AutoYResizeBottomOffset(2);
//--- Создадим элемент управления
   if(!m_table_symb.CreateTable(x_gap,y_gap))
      return(false);
//--- Установим названия заголовков
   m_table_symb.SetHeaderText(0,"Symbol");
   m_table_symb.SetHeaderText(1,"Values");
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_table_symb);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт таблицу позиций                                          |
//+------------------------------------------------------------------+
bool CProgram::CreatePositionsTable(const int x_gap,const int y_gap)
  {
#define COLUMNS2_TOTAL 10
#define ROWS2_TOTAL    1
//--- Сохраним указатель на главный элемент
   m_table_positions.MainPointer(m_tabs1);
//--- Закрепить за вкладкой
   m_tabs1.AddToElementsArray(1,m_table_positions);
//--- Массив ширины столбцов
   int width[COLUMNS2_TOTAL];
   ::ArrayInitialize(width,75);
   width[0]=90;
   width[1]=63;
   width[2]=60;
   width[5]=60;
   width[8]=90;
//--- Массив выравнивания текста в столбцах
   ENUM_ALIGN_MODE align[COLUMNS2_TOTAL];
   ::ArrayInitialize(align,ALIGN_CENTER);
   align[0]=ALIGN_LEFT;
//--- Массив отступа текста в столбцах по оси X
   int text_x_offset[COLUMNS2_TOTAL];
   ::ArrayInitialize(text_x_offset,21);
//--- Массив отступа картинок в столбцах по оси X
   int image_x_offset[COLUMNS2_TOTAL];
   ::ArrayInitialize(image_x_offset,3);
//--- Массив отступа картинок в столбцах по оси Y
   int image_y_offset[COLUMNS2_TOTAL];
   ::ArrayInitialize(image_y_offset,2);
//--- Свойства
   m_table_positions.TableSize(COLUMNS2_TOTAL,ROWS2_TOTAL);
   m_table_positions.ColumnsWidth(width);
   m_table_positions.TextAlign(align);
   m_table_positions.TextXOffset(text_x_offset);
   m_table_positions.ImageXOffset(image_x_offset);
   m_table_positions.ImageYOffset(image_y_offset);
   m_table_positions.ShowHeaders(true);
   m_table_positions.IsSortMode(true);
   m_table_positions.SelectableRow(true);
   m_table_positions.ColumnResizeMode(true);
   m_table_positions.IsZebraFormatRows(clrWhiteSmoke);
   m_table_positions.AutoXResizeMode(true);
   m_table_positions.AutoYResizeMode(true);
   m_table_positions.AutoXResizeRightOffset(2);
   m_table_positions.AutoYResizeBottomOffset(2);
//--- Создадим элемент управления
   if(!m_table_positions.CreateTable(x_gap,y_gap))
      return(false);
//--- Установим названия заголовков
   string headers[COLUMNS2_TOTAL]={"Symbol","Positions","Volume","Buy Volume","Sell Volume","Profit","Buy Profit","Sell Profit","Deposit Load","Average Price"};
   for(int i=0; i<COLUMNS2_TOTAL; i++)
      m_table_positions.SetHeaderText(i,headers[i]);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_table_positions);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт стандартный график 1                                     |
//+------------------------------------------------------------------+
bool CProgram::CreateSubChart1(const int x_gap,const int y_gap)
  {
//--- Сохраним указатель на окно
   m_sub_chart1.MainPointer(m_tabs1);
//--- Закрепить за 1-ой вкладкой
   m_tabs1.AddToElementsArray(0,m_sub_chart1);
//--- Свойства
   m_sub_chart1.XScrollMode(true);
   m_sub_chart1.AutoXResizeMode(true);
   m_sub_chart1.AutoYResizeMode(true);
   m_sub_chart1.AutoXResizeRightOffset(125);
   m_sub_chart1.AutoYResizeBottomOffset(2);
//--- Добавим графики
   m_sub_chart1.AddSubChart("EURUSD",PERIOD_D1);
//--- Создадим элемент управления
   if(!m_sub_chart1.CreateStandardChart(x_gap,y_gap))
      return(false);
//--- Добавим объект в общий массив групп объектов
   CWndContainer::AddToElementsArray(0,m_sub_chart1);
   return(true);
  }
//+------------------------------------------------------------------+

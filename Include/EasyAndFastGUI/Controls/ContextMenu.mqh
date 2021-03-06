//+------------------------------------------------------------------+
//|                                                  ContextMenu.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "MenuItem.mqh"
#include "SeparateLine.mqh"
//+------------------------------------------------------------------+
//| Класс для создания контекстного меню                             |
//+------------------------------------------------------------------+
class CContextMenu : public CElement
  {
private:
   //--- Объекты для создания пункта меню
   CMenuItem         m_items[];
   CSeparateLine     m_sep_line[];
   //--- Указатель на предыдущий узел
   CMenuItem        *m_prev_node;
   //--- Свойства пункта меню
   int               m_item_y_size;
   //--- Свойства разделительной линии
   color             m_sepline_dark_color;
   color             m_sepline_light_color;
   //--- Массивы свойств пунктов меню:
   //    (1) Текст, (2) ярлык доступного пункта, (3) ярлык заблокированного пункта
   string            m_text[];
   string            m_path_bmp_on[];
   string            m_path_bmp_off[];
   //--- Массив номеров индексов пунктов меню, после которых нужно установить разделительную линию
   int               m_sep_line_index[];
   //--- Сторона фиксации контекстного меню
   ENUM_FIX_CONTEXT_MENU m_fix_side;
   //--- Режим свободного контекстного меню. То есть, без привязки к предыдущему узлу.
   bool              m_free_context_menu;
   //---
public:
                     CContextMenu(void);
                    ~CContextMenu(void);
   //--- Методы для создания контекстного меню
   bool              CreateContextMenu(const int x_gap=0,const int y_gap=0);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateItems(void);
   bool              CreateSeparateLine(const int item_index,const int line_index);
   //---
public:
   //--- Возвращает указатель пункта из контекстного меню
   CMenuItem        *GetItemPointer(const uint index);
   CSeparateLine    *GetSeparateLinePointer(const uint index);
   //--- (1) Сохранение и (2) получение указателя предыдущего узла, (3) установка режима свободного контекстного меню
   void              PrevNodePointer(CMenuItem &object);
   CMenuItem        *PrevNodePointer(void)                    const { return(m_prev_node);              }
   void              FreeContextMenu(const bool flag)               { m_free_context_menu=flag;         }
   //--- (1) Количество пунктов меню, (2) высота
   int               ItemsTotal(void)                         const { return(::ArraySize(m_items));     }
   int               SeparateLinesTotal(void)                 const { return(::ArraySize(m_sep_line));  }
   void              ItemYSize(const int y_size)                    { m_item_y_size=y_size;             }
   //--- (1) Тёмный и (2) светлый цвет разделительной линии
   void              SeparateLineDarkColor(const color clr)         { m_sepline_dark_color=clr;         }
   void              SeparateLineLightColor(const color clr)        { m_sepline_light_color=clr;        }
   //--- Установка режима фиксации контекстного меню
   void              FixSide(const ENUM_FIX_CONTEXT_MENU side) { m_fix_side=side; }

   //--- Добавляет пункт меню с указанными свойствами до создания контекстного меню
   void              AddItem(const string text,const string path_bmp_on,const string path_bmp_off,const ENUM_TYPE_MENU_ITEM type);
   //--- Добавляет разделительную линию после указанного пункта до создания контекстного меню
   void              AddSeparateLine(const int item_index);
   //--- Возвращает описание (отображаемый текст)
   string            DescriptionByIndex(const uint index);
   //--- Возвращает тип пункта меню
   ENUM_TYPE_MENU_ITEM TypeMenuItemByIndex(const uint index);
   //--- (1) Получение и (2) установка состояния чекбокса
   bool              CheckBoxStateByIndex(const uint index);
   void              CheckBoxStateByIndex(const uint index,const bool state);
   //--- (1) Возвращает и (2) устанавливает id радио-пункта по индексу
   int               RadioItemIdByIndex(const uint index);
   void              RadioItemIdByIndex(const uint item_index,const int radio_id);
   //--- (1) Возвращает выделенный радио-пункт, (2) переключает радио-пункт
   int               SelectedRadioItem(const int radio_id);
   void              SelectedRadioItem(const int radio_index,const int radio_id);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Управление
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Проверка условий на закрытие всех контекстных меню
   void              CheckHideContextMenus(void);
   //--- Проверка условий на закрытие всех контекстных меню, которые были открыты после этого
   void              CheckHideBackContextMenus(void);
   //--- Обработка нажатия на пункте, к которому это контекстное меню привязано
   bool              OnClickMenuItem(const string pressed_object,const int id,const int index);

   //--- Приём сообщения от пункта меню для обработки
   void              ReceiveMessageFromMenuItem(const int id,const int index_item,const string message_item);
   //--- Получение (1) идентификатора и (2) индекса из сообщения радио-пункта
   int               RadioIdFromMessage(const string message);
   int               RadioIndexByItemIndex(const int index);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CContextMenu::CContextMenu(void) : m_free_context_menu(false),
                                   m_fix_side(FIX_RIGHT),
                                   m_item_y_size(24),
                                   m_sepline_dark_color(C'160,160,160'),
                                   m_sepline_light_color(clrWhite)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
//--- Контекстное меню является выпадающим элементом
   CElementBase::IsDropdown(true);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CContextMenu::~CContextMenu(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CContextMenu::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка пермещения курсора мыши
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Выйти, если это свободное контекстное меню
      if(m_free_context_menu)
         return;
      //--- Если контекстное меню включено и левая кнопка мыши нажата
      if(m_mouse.LeftButtonState())
        {
         //--- Проверим условий на закрытие всех контекстных меню
         CheckHideContextMenus();
         return;
        }
      //--- Проверим условия на закрытие всех контекстных меню, которые были открыты после этого
      CheckHideBackContextMenus();
      return;
     }
//--- Обработка события нажатия левой кнопки мыши на объекте
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickMenuItem(sparam,(int)lparam,(int)dparam))
         return;
     }
//--- Обработка события нажатия на пункте меню
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_MENU_ITEM)
     {
      //--- Выйти, если это свободное контекстное меню
      if(m_free_context_menu)
         return;
      //---
      int    item_id      =int(lparam);
      int    item_index   =int(dparam);
      string item_message =sparam;
      //--- Приём сообщения от пункта меню для обработки
      ReceiveMessageFromMenuItem(item_id,item_index,item_message);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт контекстное меню                                         |
//+------------------------------------------------------------------+
bool CContextMenu::CreateContextMenu(const int x_gap=0,const int y_gap=0)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Если это привязанное контекстное меню
   if(!m_free_context_menu)
     {
      //--- Выйти, если нет указателя на предыдущий узел 
      if(::CheckPointer(m_prev_node)==POINTER_INVALID)
        {
         ::Print(__FUNCTION__," > Перед созданием контекстного меню ему нужно передать "
                 "указатель на предыдущий узел с помощью метода CContextMenu::PrevNodePointer(CMenuItem &object).");
         return(false);
        }
     }
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Создание контекстного меню
   if(!CreateCanvas())
      return(false);
   if(!CreateItems())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CContextMenu::InitializeProperties(const int x_gap,const int y_gap)
  {
//--- Расчёт высоты контекстного меню зависит от количества пунктов меню и разделительных линий
   int items_total =ItemsTotal();
   int sep_y_size  =::ArraySize(m_sep_line)*9;
   m_y_size        =(m_item_y_size*items_total+2)+sep_y_size;
//--- Если координаты не указаны
   if(!m_free_context_menu && (x_gap==0 || y_gap==0))
     {
      if(m_fix_side==FIX_RIGHT)
        {
         m_x =(m_anchor_right_window_side)? m_prev_node.X()-m_prev_node.XSize()+3 : m_prev_node.X2()-3;
         m_y =(m_anchor_bottom_window_side)? m_prev_node.Y()+1 : m_prev_node.Y()-1;
        }
      else
        {
         m_x =(m_anchor_right_window_side)? m_prev_node.X()-1 : m_prev_node.X()+1;
         m_y =(m_anchor_bottom_window_side)? m_prev_node.Y()-m_prev_node.YSize()+1 : m_prev_node.Y2()-1;
        }
     }
//--- Если координаты указаны
   else
     {
      m_x =CElement::CalculateX(x_gap);
      m_y =CElement::CalculateY(y_gap);
     }
//--- Цвет фона по умолчанию
   m_back_color         =(m_back_color!=clrNONE)? m_back_color : C'240,240,240';
   m_back_color_hover   =(m_back_color_hover!=clrNONE)? m_back_color_hover : C'51,153,255';
   m_back_color_locked  =(m_back_color_locked!=clrNONE)? m_back_color_locked : clrLightGray;
   m_back_color_pressed =(m_back_color_pressed!=clrNONE)? m_back_color_pressed : C'51,153,255';
   m_border_color       =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
//--- Отступы и цвет текстовой метки
   m_icon_x_gap         =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 3;
   m_icon_y_gap         =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 3;
   m_label_x_gap        =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 24;
   m_label_y_gap        =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 5;
   m_label_color        =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover  =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrWhite;
//--- Отступы от крайней точки
   CElementBase::XGap(CElement::CalculateXGap(m_x));
   CElementBase::YGap(CElement::CalculateYGap(m_y));
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CContextMenu::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("context_menu");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт список пунктов меню                                      |
//+------------------------------------------------------------------+
bool CContextMenu::CreateItems(void)
  {
//--- Для определения положения разделительных линий
   int s=0;
//--- Координаты
   int x=1,y=0;
//--- Количество разделительных линий
   int sep_lines_total=::ArraySize(m_sep_line_index);
//---
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Расчёт координаты Y
      y=(i>0) ? y+m_item_y_size : 1;
      //--- Сохраним указатель формы
      m_items[i].MainPointer(this);
      //--- Если контекстное меню с привязкой, то добавим указатель на предыдущий узел
      if(!m_free_context_menu)
         m_items[i].GetPrevNodePointer(m_prev_node);
      //--- Установим свойства
      m_items[i].Index(i);
      m_items[i].TwoState(m_items[i].TypeMenuItem()==MI_HAS_CONTEXT_MENU? true : false);
      m_items[i].XSize(m_x_size-2);
      m_items[i].YSize(m_item_y_size);
      m_items[i].IconXGap(m_icon_x_gap);
      m_items[i].IconYGap(m_icon_y_gap);
      m_items[i].IconFile(m_path_bmp_on[i]);
      m_items[i].IconFileLocked(m_path_bmp_off[i]);
      m_items[i].IconFilePressed(m_path_bmp_on[i]);
      m_items[i].IconFilePressedLocked(m_path_bmp_off[i]);
      m_items[i].BackColor(m_back_color);
      m_items[i].BackColorHover(m_back_color_hover);
      m_items[i].BackColorPressed(m_back_color_hover);
      m_items[i].BorderColor(m_back_color);
      m_items[i].BorderColorHover(m_back_color);
      m_items[i].BorderColorLocked(m_back_color);
      m_items[i].BorderColorPressed(m_back_color);
      m_items[i].LabelXGap(m_label_x_gap);
      m_items[i].LabelYGap(m_label_y_gap);
      m_items[i].LabelColor(m_label_color);
      m_items[i].LabelColorHover(m_label_color_hover);
      m_items[i].LabelColorPressed(m_label_color_hover);
      m_items[i].IsDropdown(m_is_dropdown);
      m_items[i].AnchorRightWindowSide(m_anchor_right_window_side);
      m_items[i].AnchorBottomWindowSide(m_anchor_bottom_window_side);
      //--- Создание пункта меню
      if(!m_items[i].CreateMenuItem(m_text[i],x,y))
         return(false);
      //--- Добавить элемент в массив
      CElement::AddToArray(m_items[i]);
      //--- Обнулить фокус
      CElementBase::MouseFocus(false);
      //--- Перейти к следующему, если все разделительные линии установлены
      if(s>=sep_lines_total)
         continue;
      //--- Если индексы совпали, значит после этого пункта нужно установить разделительную линию
      if(i==m_sep_line_index[s])
        {
         if(!CreateSeparateLine(i,s))
            return(false);
         //--- Корректировка координаты Y для следующего пункта
         y=y+9;
         //--- Увеличение счётчика разделительных линий
         s++;
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт разделительную линию                                     |
//+------------------------------------------------------------------+
bool CContextMenu::CreateSeparateLine(const int item_index,const int line_index)
  {
   int x=CElement::CalculateXGap(m_items[item_index].X()+5);
   int y=CElement::CalculateYGap(m_items[item_index].Y2()+2);
//--- Сохраним указатель формы
   m_sep_line[line_index].MainPointer(m_main);
//--- Установим свойства
   m_sep_line[line_index].Index(line_index);
   m_sep_line[line_index].IsDropdown(m_is_dropdown);
   m_sep_line[line_index].TypeSepLine(H_SEP_LINE);
   m_sep_line[line_index].DarkColor(m_sepline_dark_color);
   m_sep_line[line_index].LightColor(m_sepline_light_color);
   m_sep_line[line_index].AnchorRightWindowSide(m_anchor_right_window_side);
   m_sep_line[line_index].AnchorBottomWindowSide(m_anchor_bottom_window_side);
//--- Создание разделительной линии
   if(!m_sep_line[line_index].CreateSeparateLine(x,y,m_x_size-10,2))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_sep_line[line_index]);
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает указатель пункта меню по индексу                      |
//+------------------------------------------------------------------+
CMenuItem *CContextMenu::GetItemPointer(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, когда в контекстном меню есть хотя бы один пункт!");
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель
   return(::GetPointer(m_items[i]));
  }
//+------------------------------------------------------------------+
//| Возвращает указатель разделительную линию по индексу             |
//+------------------------------------------------------------------+
CSeparateLine *CContextMenu::GetSeparateLinePointer(const uint index)
  {
   uint array_size=::ArraySize(m_sep_line);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
      return(NULL);
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель
   return(::GetPointer(m_sep_line[i]));
  }
//+------------------------------------------------------------------+
//| Обмен указателями пункта меню и контекстного меню                |
//+------------------------------------------------------------------+
void CContextMenu::PrevNodePointer(CMenuItem &object)
  {
//--- Сохранить указатель на пункт меню, к которому привязано это контекстное меню
   m_prev_node=::GetPointer(object);
//--- Сохранить указатель на это контекстное меню
   m_prev_node.GetContextMenuPointer(this);
  }
//+------------------------------------------------------------------+
//| Добавляет пункт меню                                             |
//+------------------------------------------------------------------+
void CContextMenu::AddItem(const string text,const string path_bmp_on,const string path_bmp_off,const ENUM_TYPE_MENU_ITEM type)
  {
//--- Увеличим размер массивов на один элемент
   int array_size=::ArraySize(m_items);
   ::ArrayResize(m_items,array_size+1);
   ::ArrayResize(m_text,array_size+1);
   ::ArrayResize(m_path_bmp_on,array_size+1);
   ::ArrayResize(m_path_bmp_off,array_size+1);
//--- Сохраним значения переданных параметров
   m_text[array_size]=text;
   m_path_bmp_on[array_size]  =path_bmp_on;
   m_path_bmp_off[array_size] =path_bmp_off;
//--- Установка типа пункта меню
   m_items[array_size].TypeMenuItem(type);
  }
//+------------------------------------------------------------------+
//| Добавляет разделительную линию                                   |
//+------------------------------------------------------------------+
void CContextMenu::AddSeparateLine(const int item_index)
  {
//--- Увеличим размер массивов на один элемент
   int array_size=::ArraySize(m_sep_line);
   ::ArrayResize(m_sep_line,array_size+1);
   ::ArrayResize(m_sep_line_index,array_size+1);
//--- Сохраним номер индекса
   m_sep_line_index[array_size]=item_index;
  }
//+------------------------------------------------------------------+
//| Возвращает название пункта по индексу                            |
//+------------------------------------------------------------------+
string CContextMenu::DescriptionByIndex(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, когда в контекстном меню есть хотя бы один пункт!");
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть описание пункта
   return(m_items[i].LabelText());
  }
//+------------------------------------------------------------------+
//| Возвращает тип пункта по индексу                                 |
//+------------------------------------------------------------------+
ENUM_TYPE_MENU_ITEM CContextMenu::TypeMenuItemByIndex(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, когда в контекстном меню есть хотя бы один пункт!");
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть тип пункта
   return(m_items[i].TypeMenuItem());
  }
//+------------------------------------------------------------------+
//| Возвращает состояние чекбокса по индексу                         |
//+------------------------------------------------------------------+
bool CContextMenu::CheckBoxStateByIndex(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, когда в контекстном меню есть хотя бы один пункт!");
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть состояние пункта
   return(m_items[i].CheckBoxState());
  }
//+------------------------------------------------------------------+
//| Устанавливает состояние чекбокса по индексу                      |
//+------------------------------------------------------------------+
void CContextMenu::CheckBoxStateByIndex(const uint index,const bool state)
  {
//--- Проверка на выход из диапазона
   uint array_size=::ArraySize(m_items);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
      return;
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Установить состояние
   m_items[i].CheckBoxState(state);
  }
//+------------------------------------------------------------------+
//| Возвращает id радио-пункта по индексу                            |
//+------------------------------------------------------------------+
int CContextMenu::RadioItemIdByIndex(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, когда в контекстном меню есть хотя бы один пункт!");
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть идентификатор
   return(m_items[i].RadioButtonID());
  }
//+------------------------------------------------------------------+
//| Устанавливает id для радио-пункта по индексу                     |
//+------------------------------------------------------------------+
void CContextMenu::RadioItemIdByIndex(const uint index,const int id)
  {
//--- Проверка на выход из диапазона
   uint array_size=::ArraySize(m_items);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
      return;
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Установить идентификатор
   m_items[i].RadioButtonID(id);
  }
//+------------------------------------------------------------------+
//| Возвращает индекс радио-пункта по id                             |
//+------------------------------------------------------------------+
int CContextMenu::SelectedRadioItem(const int radio_id)
  {
//--- Счётчик радио-пунктов
   int count_radio_id=0;
//--- Пройдёмся в цикле по списку пунктов контекстного меню
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Перейти к следующему, если не радио-пункт
      if(m_items[i].TypeMenuItem()!=MI_RADIOBUTTON)
         continue;
      //--- Если идентификаторы совпадают
      if(m_items[i].RadioButtonID()==radio_id)
        {
         //--- Если это активный радио-пункт, выходим из цикла
         if(m_items[i].RadioButtonState())
            break;
         //--- Увеличить счётчик радио-пунктов
         count_radio_id++;
        }
     }
//--- Вернуть индекс
   return(count_radio_id);
  }
//+------------------------------------------------------------------+
//| Переключает радио-пункт по индексу и id                          |
//+------------------------------------------------------------------+
void CContextMenu::SelectedRadioItem(const int radio_index,const int radio_id)
  {
//--- Счётчик радио-пунктов
   int count_radio_id=0;
//--- Пройдёмся в цикле по списку пунктов контекстного меню
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Перейти к следующему, если не радио-пункт
      if(m_items[i].TypeMenuItem()!=MI_RADIOBUTTON)
         continue;
      //--- Если идентификаторы совпадают
      if(m_items[i].RadioButtonID()==radio_id)
        {
         //--- Переключить радио-пункт
         if(count_radio_id==radio_index)
            m_items[i].RadioButtonState(true);
         else
            m_items[i].RadioButtonState(false);
         //--- Увеличить счётчик радио-пунктов
         count_radio_id++;
        }
     }
  }
//+------------------------------------------------------------------+
//| Показывает контекстное меню                                      |
//+------------------------------------------------------------------+
void CContextMenu::Show(void)
  {
//--- Выйти, если элемент уже видим
   if(CElementBase::IsVisible())
      return;
//--- Присвоить статус видимого элемента
   CElementBase::IsVisible(true);
//--- Обновить положение объектов
   Moving();
//--- Показать объект
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
//--- Показать пункты меню
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
      m_items[i].Show();
//--- Показать разделительные линии
   int sep_total=::ArraySize(m_sep_line);
   for(int i=0; i<sep_total; i++)
      m_sep_line[i].Show();
//--- Отметить состояние в предыдущем узле
   if(!m_free_context_menu)
      m_prev_node.IsPressed(true);
  }
//+------------------------------------------------------------------+
//| Скрывает контекстное меню                                        |
//+------------------------------------------------------------------+
void CContextMenu::Hide(void)
  {
//--- Выйти, если элемент скрыт
   if(!CElementBase::IsVisible())
      return;
//--- Скрыть объект
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
//--- Скрыть пункты меню
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
      m_items[i].Hide();
//--- Скрыть разделительные линии
   int sep_total=::ArraySize(m_sep_line);
   for(int i=0; i<sep_total; i++)
      m_sep_line[i].Hide();
//--- Обнулить фокус
   CElementBase::MouseFocus(false);
//--- Присвоить статус скрытого элемента
   CElementBase::IsVisible(false);
//--- Отметить состояние в предыдущем узле
   if(!m_free_context_menu)
      m_prev_node.IsPressed(false);
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CContextMenu::Delete(void)
  {
//--- Удаление объектов
   m_canvas.Destroy();
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
      m_items[i].Delete();
//--- Удаление разделительных линий
   int sep_total=::ArraySize(m_sep_line);
   for(int i=0; i<sep_total; i++)
      m_sep_line[i].Delete();
//--- Освобождение массивов элемента
   ::ArrayFree(m_items);
   ::ArrayFree(m_sep_line);
   ::ArrayFree(m_sep_line_index);
   ::ArrayFree(m_text);
   ::ArrayFree(m_path_bmp_on);
   ::ArrayFree(m_path_bmp_off);
//--- Освобождение массивов элементов и объектов
   CElement::FreeElementsArray();
//--- Инициализация переменных значениями по умолчанию
   CElementBase::MouseFocus(false);
   CElementBase::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Проверка условий на закрытие всех контекстных меню               |
//+------------------------------------------------------------------+
void CContextMenu::CheckHideContextMenus(void)
  {
//--- Выйти, если (1) курсор в области контекстного меню или (2) в области предыдущего узла
   if(CElementBase::MouseFocus() || m_prev_node.MouseFocus())
      return;
//--- Если же курсор вне области этих элементов, то ...
//    ... нужно проверить, есть ли открытые контекстные меню, которые были активированы из этого
//--- Для этого пройдёмся в цикле по списку этого контекстного меню ...
//    ... для определения наличия пункта, который содержит в себе контекстное меню
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Если такой пункт нашёлся, то нужно проверить, открыто ли его контекстное меню.
      //    Если оно открыто, то не нужно отсылать сигнал на закрытие всех контекстных меню из этого элемента, так как...
      //    ... возможно, что курсор находится в области следующего и нужно проверить там.
      if(m_items[i].TypeMenuItem()==MI_HAS_CONTEXT_MENU)
         if(m_items[i].GetContextMenuPointer().IsVisible())
            return;
     }
//--- Отжать кнопку предыдущего узда
   m_prev_node.IsPressed(false);
   m_prev_node.Update(true);
//--- Послать сигнал на скрытие всех контекстных меню
   ::EventChartCustom(m_chart_id,ON_HIDE_CONTEXTMENUS,0,0,"");
//--- Сообщение на восстановление доступных элементов
   ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
//--- Отправим сообщение об изменении в графическом интерфейсе
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Проверка условий на закрытие всех контекстных меню,              |
//| которые были открыты после этого                                 |
//+------------------------------------------------------------------+
void CContextMenu::CheckHideBackContextMenus(void)
  {
//--- Пройтись по всем пунктам меню
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Если (1) пункт содержит контекстное меню и (2) оно включено
      if(m_items[i].TypeMenuItem()==MI_HAS_CONTEXT_MENU && m_items[i].IsPressed())
        {
         //--- Если фокус в контекстном меню, но не в этом пункте
         if(CElementBase::MouseFocus() && !m_items[i].MouseFocus())
           {
            //--- Отправить сигнал на скрытие всех контекстных меню, которые были открыты после этого
            ::EventChartCustom(m_chart_id,ON_HIDE_BACK_CONTEXTMENUS,CElementBase::Id(),0,"");
            //--- Сообщение на восстановление доступных элементов
            ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
            //--- Отправим сообщение об изменении в графическом интерфейсе
            ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на пункт меню                                  |
//+------------------------------------------------------------------+
bool CContextMenu::OnClickMenuItem(const string pressed_object,const int id,const int index)
  {
//--- Выйдем, если нажатие было не на кнопке
   if(::StringFind(pressed_object,"menu_item")<0)
      return(false);
//--- Выйдем, если (1) это контекстное меню имеет предыдущий узел и (2) уже открыто
   if(!m_free_context_menu && CElementBase::IsVisible())
      return(true);
//--- Если это свободное контекстное меню
   if(m_free_context_menu)
     {
      //--- Найдём в цикле пункт меню, на который нажали
      int total=ItemsTotal();
      for(int i=0; i<total; i++)
        {
         if(i!=index)
            continue;
         //--- Отправим сообщение об этом
         ::EventChartCustom(m_chart_id,ON_CLICK_FREEMENU_ITEM,CElementBase::Id(),i,DescriptionByIndex(i));
         break;
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Приём сообщения от пункта меню для обработки                     |
//+------------------------------------------------------------------+
void CContextMenu::ReceiveMessageFromMenuItem(const int id,const int index_item,const string message_item)
  {
//--- Если (1) нет признака этой программы или (2) идентификаторы не совпадают
   if(::StringFind(message_item,CElementBase::ProgramName(),0)<0 || id!=CElementBase::Id())
      return;
//--- Если нажатие было на радио-пункте
   if(::StringFind(message_item,"radioitem",0)>-1)
     {
      //--- Получим id радио-пункта из переданного сообщения
      int radio_id=RadioIdFromMessage(message_item);
      //--- Получим индекс радио-пункта по общему индексу
      int radio_index=RadioIndexByItemIndex(index_item);
      //--- Переключить радио-пункт
      SelectedRadioItem(radio_index,radio_id);
     }
//--- Скрытие контекстного меню
   Hide();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_CONTEXTMENU_ITEM,id,index_item,DescriptionByIndex(index_item));
//--- Послать сигнал на скрытие всех контекстных меню
   ::EventChartCustom(m_chart_id,ON_HIDE_CONTEXTMENUS,0,0,"");
//--- Сообщение на восстановление доступных элементов
   ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
//--- Отправим сообщение об изменении в графическом интерфейсе
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Извлекает идентификатор из сообщения для радио-пункта            |
//+------------------------------------------------------------------+
int CContextMenu::RadioIdFromMessage(const string message)
  {
   ushort u_sep=0;
   string result[];
   int    array_size=0;
//--- Получим код разделителя
   u_sep=::StringGetCharacter("_",0);
//--- Разобьём строку
   ::StringSplit(message,u_sep,result);
   array_size=::ArraySize(result);
//--- Если структура сообщения отличается от ожидаемой
   if(array_size!=3)
     {
      ::Print(__FUNCTION__," > Неправильная структура в сообщении для радио-пункта! message: ",message);
      return(WRONG_VALUE);
     }
//--- Предотвращение выхода за пределы массива
   if(array_size<3)
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//--- Вернуть id радио-пункта
   return((int)result[2]);
  }
//+------------------------------------------------------------------+
//| Возвращает индекс радио-пункта по общему индексу                 |
//+------------------------------------------------------------------+
int CContextMenu::RadioIndexByItemIndex(const int index)
  {
   int radio_index=0;
//--- Получаем ID радио-пункта по общему индексу
   int radio_id=RadioItemIdByIndex(index);
//--- Счётчик пунктов из нужной группы
   int count_radio_id=0;
//--- Пройдёмся в цикле по списку
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Если это не радио-пункт, перейти к следующему
      if(m_items[i].TypeMenuItem()!=MI_RADIOBUTTON)
         continue;
      //--- Если идентификаторы совпадают
      if(m_items[i].RadioButtonID()==radio_id)
        {
         //--- Если индексы совпали, то 
         //    запомним текущее значение счётчика и закончим цикл
         if(m_items[i].Index()==index)
           {
            radio_index=count_radio_id;
            break;
           }
         //--- Увеличение счётчика
         count_radio_id++;
        }
     }
//--- Вернуть индекс
   return(radio_index);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CContextMenu::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать рамку
   CElement::DrawBorder();
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                      Picture.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Класс для создания картинки                                      |
//+------------------------------------------------------------------+
class CPicture : public CElement
  {
public:
                     CPicture(void);
                    ~CPicture(void);
   //--- Методы для создания картинки
   bool              CreatePicture(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   //---
public:
   //--- Рисует элемент
   virtual void      Draw(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPicture::CPicture(void)

  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPicture::~CPicture(void)
  {
  }
//+------------------------------------------------------------------+
//| Создаёт элемент "Картинка"                                       |
//+------------------------------------------------------------------+
bool CPicture::CreatePicture(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Создание элемента
   if(!CreateCanvas())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CPicture::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x      =CElement::CalculateX(x_gap);
   m_y      =CElement::CalculateY(y_gap);
   m_x_size =(m_x_size<1)? 16 : m_x_size;
   m_y_size =(m_y_size<1)? 16 : m_y_size;
//--- Свойства по умолчанию
   m_back_color =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CPicture::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("icon");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CPicture::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать картинку
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+

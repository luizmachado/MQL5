//+------------------------------------------------------------------+
//|                                                FileNavigator.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TreeView.mqh"
//+------------------------------------------------------------------+
//| Класс для создания файлового навигатора                          |
//+------------------------------------------------------------------+
class CFileNavigator : public CElement
  {
private:
   //--- Объекты для создания элемента
   CTreeView         m_treeview;
   //--- Основные массивы для хранения данных
   int               m_g_list_index[];           // общий индекс
   int               m_g_prev_node_list_index[]; // общий индекс предыдущего узла
   string            m_g_item_text[];            // имя папки/файла
   int               m_g_item_index[];           // локальный индекс
   int               m_g_node_level[];           // уровень узла
   int               m_g_prev_node_item_index[]; // локальный индекс предыдущего узла
   int               m_g_items_total[];          // всего элементов в папке
   int               m_g_folders_total[];        // количество папок в папке
   bool              m_g_is_folder[];            // признак папки
   bool              m_g_item_state[];           // состояние пункта (свёрнут/открыт)
   //--- Вспомогательные массивы для сбора данных
   int               m_l_prev_node_list_index[];
   string            m_l_item_text[];
   string            m_l_path[];
   int               m_l_item_index[];
   int               m_l_item_total[];
   int               m_l_folders_total[];
   //--- Ширина области древовидного списка
   int               m_treeview_width;
   //--- Картинки для (1) папок и (2) файлов
   string            m_file_icon;
   string            m_folder_icon;
   //--- Текущий путь относительно файловой "песочницы" терминала
   string            m_current_path;
   //--- Текущий полный путь относительно файловой системы включая метку тома жёсткого диска
   string            m_current_full_path;
   //--- Область текущей директории
   int               m_directory_area;
   //--- Режим содержания файлового навигатора
   ENUM_FILE_NAVIGATOR_CONTENT m_navigator_content;
   //---
public:
                     CFileNavigator(void);
                    ~CFileNavigator(void);
   //--- Методы для создания файлового навигатора
   bool              CreateFileNavigator(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateTreeView(void);
   //---
public:
   //--- (1) Возвращает указатель древовидного списка, 
   //    (2) режим навигатора (Показывать все/Только папки), (3) содержание навигатора (Общая папка/Локальная/Всё)
   CTreeView        *GetTreeViewPointer(void)                                 { return(::GetPointer(m_treeview));          }
   void              NavigatorMode(const ENUM_FILE_NAVIGATOR_MODE mode)       { m_treeview.NavigatorMode(mode);            }
   void              NavigatorContent(const ENUM_FILE_NAVIGATOR_CONTENT mode) { m_navigator_content=mode;                  }
   //--- (1) ширина древовидного списка, (2) установка пути к файлам для файлов и папок
   void              TreeViewWidth(const int x_size)                          { m_treeview_width=x_size;                   }
   void              FileIcon(const string file_path)                         { m_file_icon=file_path;                     }
   void              FolderIcon(const string file_path)                       { m_folder_icon=file_path;                   }
   //--- Возвращает (1) текущий путь и (2) полный путь, (3) выделенный файл
   string            CurrentPath(void)                                  const { return(m_current_path);                    }
   string            CurrentFullPath(void)                              const { return(m_current_full_path);               }
   //--- Возвращает (1) область директории и (2) выделенный файл
   int               DirectoryArea(void)                                const { return(m_directory_area);                  }
   string            SelectedFile(void)                                 const { return(m_treeview.SelectedItemFileName()); }
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Управление
   virtual void      Delete(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка события выбора нового пути в древовидном списке
   void              OnChangeTreePath(void);

   //--- Заполняет массивы параметрами элементов файловой системы терминала
   void              FillArraysData(void);
   //--- Читает файловую систему и записывает параметры в массивы
   void              FileSystemScan(const int root_index,int &list_index,int &node_level,int &item_index,int search_area);
   //--- Изменяет размер вспомогательных массивов относительно текущего уровня узла 
   void              AuxiliaryArraysResize(const int node_level);
   //--- Определяет, передано имя папки или файла
   bool              IsFolder(const string file_name);
   //--- Возвращает количество (1) элементов и (2) папок в указанной директории
   int               ItemsTotal(const string search_path,const int mode);
   int               FoldersTotal(const string search_path,const int mode);
   //--- Возвращает локальный индекс предыдущего узла относительно переданных параметров
   int               PrevNodeItemIndex(const int root_index,const int node_level);

   //--- Добавляет пункт в массивы
   void              AddItem(const int list_index,const string item_text,const int node_level,const int prev_node_item_index,
                             const int item_index,const int items_total,const int folders_total,const bool is_folder);
   //--- Переход на следующий узел
   void              ToNextNode(const int root_index,int list_index,int &node_level,
                                int &item_index,long &handle,const string item_text,const int search_area);

   virtual void      DrawText(void);

   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CFileNavigator::CFileNavigator(void) : m_current_path(""),
                                       m_current_full_path(""),
                                       m_treeview_width(200),
                                       m_directory_area(FILE_COMMON),
                                       m_navigator_content(FN_ONLY_MQL),
                                       m_file_icon("Images\\EasyAndFastGUI\\Icons\\bmp16\\text_file_w10.bmp"),
                                       m_folder_icon("Images\\EasyAndFastGUI\\Icons\\bmp16\\folder_w10.bmp")
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CFileNavigator::~CFileNavigator(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CFileNavigator::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события "Изменение пути в древовидном списке"
   if(id==CHARTEVENT_CUSTOM+ON_CHANGE_TREE_PATH)
     {
      OnChangeTreePath();
      //--- Отобразим текущий путь в адресной строке
      Update(true);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт файловый навигатор                                       |
//+------------------------------------------------------------------+
bool CFileNavigator::CreateFileNavigator(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Сканируем файловую систему терминала и заносим данные в массивы
   FillArraysData();
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Создание элемента
   if(!CreateTreeView())
      return(false);
   if(!CreateCanvas())
      return(false);
//--- Отобразим текущий путь в адресной строке
   OnChangeTreePath();
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CFileNavigator::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   m_y_size   =(m_y_size<1)? 20 : m_y_size;
//--- Цвета по умолчанию
   m_border_color =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
   m_label_color  =(m_label_color!=clrNONE)? m_label_color : clrBlack;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CFileNavigator::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("file_navigator");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_treeview.XSize(),m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт древовидный список                                       |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\folder_w10.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\text_file_w10.bmp"
//---
bool CFileNavigator::CreateTreeView(void)
  {
//--- Сохраним указатель на окно
   m_treeview.MainPointer(this);
//--- Координаты
   int x=0,y=m_y_size-1;
//--- Свойства
   m_treeview.XSize(m_x_size);
   m_treeview.TreeViewWidth(m_treeview_width);
   m_treeview.ResizeListMode(true);
   m_treeview.ShowItemContent(true);
   m_treeview.AutoXResizeMode(CElementBase::AutoXResizeMode());
   m_treeview.AutoXResizeRightOffset(0);
   m_treeview.AnchorRightWindowSide(CElementBase::AnchorRightWindowSide());
   m_treeview.AnchorBottomWindowSide(CElementBase::AnchorBottomWindowSide());
//--- Формируем массивы древовидного списка
   int items_total=::ArraySize(m_g_item_text);
   for(int i=0; i<items_total; i++)
     {
      //--- Определим картинку для пункта (папка/файл)
      string icon_path=(m_g_is_folder[i])? m_folder_icon : m_file_icon;
      //--- Если это папка, удалим последний символ ('\') в строке 
      if(m_g_is_folder[i])
         m_g_item_text[i]=::StringSubstr(m_g_item_text[i],0,::StringLen(m_g_item_text[i])-1);
      //--- Добавим пункт в древовидный список
      m_treeview.AddItem(i,m_g_prev_node_list_index[i],m_g_item_text[i],icon_path,m_g_item_index[i],
                         m_g_node_level[i],m_g_prev_node_item_index[i],m_g_items_total[i],m_g_folders_total[i],false,m_g_is_folder[i]);
     }
//--- Создать древовидный список
   if(!m_treeview.CreateTreeView(x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_treeview);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка события выбора нового пути в древовидном списке        |
//+------------------------------------------------------------------+
void CFileNavigator::OnChangeTreePath(void)
  {
//--- Получим текущий путь
   string path=m_treeview.CurrentFullPath();
//--- Если это общая папка терминалов
   if(::StringFind(path,"Common\\Files\\",0)>-1)
     {
      //--- Получим адрес общей папки терминалов
      string common_path=::TerminalInfoString(TERMINAL_COMMONDATA_PATH);
      //--- Удалим в строке (принятой в событии) префикс "Common\"
      path=::StringSubstr(path,7,::StringLen(common_path)-7);
      //--- Сформируем путь (краткую и полную версию)
      m_current_path      =::StringSubstr(path,6,::StringLen(path)-6);
      m_current_full_path =common_path+"\\"+path;
      //--- Сохраним область директории
      m_directory_area=FILE_COMMON;
     }
//--- Если это локальная папка терминала
   else if(::StringFind(path,"MQL5\\Files\\",0)>-1)
     {
      //--- Получим адрес данных в локальной папке терминала
      string local_path=::TerminalInfoString(TERMINAL_DATA_PATH);
      //--- Сформируем путь (краткую и полную версию)
      m_current_path      =::StringSubstr(path,11,::StringLen(path)-11);
      m_current_full_path =local_path+"\\"+path;
      //--- Сохраним область директории
      m_directory_area=0;
     }
  }
//+------------------------------------------------------------------+
//| Заполняет массивы параметрами элементов файловой системы         |
//+------------------------------------------------------------------+
void CFileNavigator::FillArraysData(void)
  {
//--- Счётчики (1) общих индексов, (2) уровней узлов, (3) локальных индексов
   int list_index =0;
   int node_level =0;
   int item_index =0;
//--- Если нужно отображать обе директории (Общая (0)/Локальная (1))
   int begin=0,end=1;
//--- Если нужно отображать содержимое только локальной директории
   if(m_navigator_content==FN_ONLY_MQL)
      begin=1;
//--- Если нужно отображать содержимое только общей директории
   else if(m_navigator_content==FN_ONLY_COMMON)
      begin=end=0;
//--- Пройдёмся по указанным директориям
   for(int root_index=begin; root_index<=end; root_index++)
     {
      //--- Определим директорию для сканирования файловой структуры
      int search_area=(root_index>0) ? 0 : FILE_COMMON;
      //--- Обнулим счётчик локальных индексов
      item_index=0;
      //--- Увеличим размер массивов на один элемент (относительно уровня узла)
      AuxiliaryArraysResize(node_level);
      //--- Получим кол-во файлов и папок в указанной директории (* - проверить все файлы/папки)
      string search_path   =m_l_path[0]+"*";
      m_l_item_total[0]    =ItemsTotal(search_path,search_area);
      m_l_folders_total[0] =FoldersTotal(search_path,search_area);
      //--- Добавим пункт с названием корневого каталога в начало списка
      string item_text=(root_index>0)? "MQL5\\Files\\" : "Common\\Files\\";
      AddItem(list_index,item_text,0,0,root_index,m_l_item_total[0],m_l_folders_total[0],true);
      //--- Увеличим счётчики общих индексов и уровней узлов
      list_index++;
      node_level++;
      //--- Увеличим размер массивов на один элемент (относительно уровня узла)
      AuxiliaryArraysResize(node_level);
      //--- Инициализация первых элементов для директории локальной папки терминала
      if(root_index>0)
        {
         m_l_item_index[0]           =root_index;
         m_l_prev_node_list_index[0] =list_index-1;
        }
      //--- Сканируем директории и заносим данные в массивы
      FileSystemScan(root_index,list_index,node_level,item_index,search_area);
     }
  }
//+------------------------------------------------------------------+
//| Читает файловую систему терминала и записывает                   |
//| параметры элементов в массивы                                    |
//+------------------------------------------------------------------+
void CFileNavigator::FileSystemScan(const int root_index,int &list_index,int &node_level,int &item_index,int search_area)
  {
   long   search_handle =INVALID_HANDLE; // Хэндл поиска папки/файла
   string file_name     ="";             // Имя найденного элемента (файла/папки)
   string filter        ="*";            // Фильтр поиска (* - проверить все файлы/папки)
//--- Сканируем директории и заносим данные в массивы
   while(!::IsStopped())
     {
      //--- Если это начало списка директории
      if(item_index==0)
        {
         //--- Путь для поиска всех элементов
         string search_path=m_l_path[node_level]+filter;
         //--- Получаем хэндл и имя первого файла
         search_handle=::FileFindFirst(search_path,file_name,search_area);
         //--- Получим кол-во файлов и папок в указанной директории
         m_l_item_total[node_level]    =ItemsTotal(search_path,search_area);
         m_l_folders_total[node_level] =FoldersTotal(search_path,search_area);
        }
      //--- Если индекс этого узла уже был, перейдём к следующему файлу
      if(m_l_item_index[node_level]>-1 && item_index<=m_l_item_index[node_level])
        {
         //--- Увеличим счётчик локальных индексов
         item_index++;
         //--- Переходим к следующему элементу
         ::FileFindNext(search_handle,file_name);
         continue;
        }
      //--- Если дошли до конца списка в корневом узле, закончим цикл
      if(node_level==1 && item_index>=m_l_item_total[node_level])
         break;
      //--- Если дошли до конца списка в любом узле, кроме корневого
      else if(item_index>=m_l_item_total[node_level])
        {
         //--- Перевести счётчик узлов на один уровень назад
         node_level--;
         //--- Обнулить счётчик локальных индексов
         item_index=0;
         //--- Закрываем хэндл поиска
         ::FileFindClose(search_handle);
         continue;
        }
      //--- Если это папка
      if(IsFolder(file_name))
        {
         //--- Перейдём на следующий узел
         ToNextNode(root_index,list_index,node_level,item_index,search_handle,file_name,search_area);
         //--- Увеличить счётчик общих индексов и начать новую итерацию
         list_index++;
         continue;
        }
      //--- Получим локальный индекс предыдущего узла
      int prev_node_item_index=PrevNodeItemIndex(root_index,node_level);
      //--- Добавим пункт с указанными данными в общие массивы
      AddItem(list_index,file_name,node_level,prev_node_item_index,item_index,0,0,false);
      //--- Увеличим счётчик общих индексов
      list_index++;
      //--- Увеличим счётчик локальных индексов
      item_index++;
      //--- Переходим к следующему элементу
      ::FileFindNext(search_handle,file_name);
     }
//--- Закрываем хэндл поиска
   ::FileFindClose(search_handle);
  }
//+------------------------------------------------------------------+
//| Изменяет размер вспомогательных массивов                         |
//| относительно текущего уровня узла                                |
//+------------------------------------------------------------------+
void CFileNavigator::AuxiliaryArraysResize(const int node_level)
  {
//--- Изменить размер массивов
   int new_size=node_level+1;
   ::ArrayResize(m_l_prev_node_list_index,new_size);
   ::ArrayResize(m_l_item_text,new_size);
   ::ArrayResize(m_l_path,new_size);
   ::ArrayResize(m_l_item_index,new_size);
   ::ArrayResize(m_l_item_total,new_size);
   ::ArrayResize(m_l_folders_total,new_size);
//--- Инициализация последнего значения
   m_l_prev_node_list_index[node_level] =0;
   m_l_item_text[node_level]            ="";
   m_l_path[node_level]                 ="";
   m_l_item_index[node_level]           =-1;
   m_l_item_total[node_level]           =0;
   m_l_folders_total[node_level]        =0;
  }
//+------------------------------------------------------------------+
//| Определяет, передано имя папки или файла                         |
//+------------------------------------------------------------------+
bool CFileNavigator::IsFolder(const string file_name)
  {
//--- Если в имени есть символы "\\", то это папка
   if(::StringFind(file_name,"\\",0)>-1)
      return(true);
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Считает количество файлов в текущей директории                   |
//+------------------------------------------------------------------+
int CFileNavigator::ItemsTotal(const string search_path,const int search_area)
  {
   int    counter       =0;              // счётчик элементов 
   string file_name     ="";             // имя файла
   long   search_handle =INVALID_HANDLE; // хэндл поиска
//--- Получаем первый файл в текущей директории
   search_handle=::FileFindFirst(search_path,file_name,search_area);
//--- Если директория не пуста
   if(search_handle!=INVALID_HANDLE && file_name!="")
     {
      //--- Посчитаем количество объектов в текущей директории
      counter++;
      while(::FileFindNext(search_handle,file_name))
         counter++;
     }
//--- Закрываем хэндл поиска
   ::FileFindClose(search_handle);
   return(counter);
  }
//+------------------------------------------------------------------+
//| Считает количество папок в текущей директории                    |
//+------------------------------------------------------------------+
int CFileNavigator::FoldersTotal(const string search_path,const int search_area)
  {
   int    counter       =0;              // счётчик элементов 
   string file_name     ="";             // имя файла
   long   search_handle =INVALID_HANDLE; // хэндл поиска
//--- Получаем первый файл в текущей директории
   search_handle=::FileFindFirst(search_path,file_name,search_area);
//--- Если не путо, то в цикле считаем кол-во объектов в текущей директории
   if(search_handle!=INVALID_HANDLE && file_name!="")
     {
      //--- Если это папка, увеличим счётчик
      if(IsFolder(file_name))
         counter++;
      //--- Пройдёмся далее по списку и посчитаем другие папки
      while(::FileFindNext(search_handle,file_name))
        {
         if(IsFolder(file_name))
            counter++;
        }
     }
//--- Закрываем хэндл поиска
   ::FileFindClose(search_handle);
   return(counter);
  }
//+------------------------------------------------------------------+
//| Возвращает локальный индекс предыдущего узла                     |
//| относительно переданных параметров                               |
//+------------------------------------------------------------------+
int CFileNavigator::PrevNodeItemIndex(const int root_index,const int node_level)
  {
   int prev_node_item_index=0;
//--- Если не в корневом каталоге
   if(node_level>1)
      prev_node_item_index=m_l_item_index[node_level-1];
   else
     {
      //--- Если не первый элемент списка
      if(root_index>0)
         prev_node_item_index=m_l_item_index[node_level-1];
     }
//--- Вернём локальный индекс предыдущего узла
   return(prev_node_item_index);
  }
//+------------------------------------------------------------------+
//| Добавляет пункт с указанными параметрами в массивы               |
//+------------------------------------------------------------------+
void CFileNavigator::AddItem(const int list_index,const string item_text,const int node_level,const int prev_node_item_index,
                             const int item_index,const int items_total,const int folders_total,const bool is_folder)
  {
//--- Резервный размер массива
   int reserve_size=100000;
//--- Увеличим размер массивов на один элемент
   int array_size =::ArraySize(m_g_list_index);
   int new_size   =array_size+1;
   ::ArrayResize(m_g_prev_node_list_index,new_size,reserve_size);
   ::ArrayResize(m_g_list_index,new_size,reserve_size);
   ::ArrayResize(m_g_item_text,new_size,reserve_size);
   ::ArrayResize(m_g_item_index,new_size,reserve_size);
   ::ArrayResize(m_g_node_level,new_size,reserve_size);
   ::ArrayResize(m_g_prev_node_item_index,new_size,reserve_size);
   ::ArrayResize(m_g_items_total,new_size,reserve_size);
   ::ArrayResize(m_g_folders_total,new_size,reserve_size);
   ::ArrayResize(m_g_is_folder,new_size,reserve_size);
//--- Сохраним значения переданных параметров
   m_g_prev_node_list_index[array_size] =(node_level==0)? -1 : m_l_prev_node_list_index[node_level-1];
   m_g_list_index[array_size]           =list_index;
   m_g_item_text[array_size]            =item_text;
   m_g_item_index[array_size]           =item_index;
   m_g_node_level[array_size]           =node_level;
   m_g_prev_node_item_index[array_size] =prev_node_item_index;
   m_g_items_total[array_size]          =items_total;
   m_g_folders_total[array_size]        =folders_total;
   m_g_is_folder[array_size]            =is_folder;
  }
//+------------------------------------------------------------------+
//| Переход на следующий узел                                        |
//+------------------------------------------------------------------+
void CFileNavigator::ToNextNode(const int root_index,int list_index,int &node_level,
                                int &item_index,long &handle,const string item_text,const int search_area)
  {
//--- Фильтр поиска (* - проверить все файлы/папки)
   string filter="*";
//--- Сформируем путь
   string search_path=m_l_path[node_level]+item_text+filter;
//--- Получим и сохраним данные
   m_l_item_total[node_level]           =ItemsTotal(search_path,search_area);
   m_l_folders_total[node_level]        =FoldersTotal(search_path,search_area);
   m_l_item_text[node_level]            =item_text;
   m_l_item_index[node_level]           =item_index;
   m_l_prev_node_list_index[node_level] =list_index;
//--- Получим индекс пункта предыдущего узла
   int prev_node_item_index=PrevNodeItemIndex(root_index,node_level);
//--- Добавим пункт с указанными данными в общие массивы
   AddItem(list_index,item_text,node_level,prev_node_item_index,
           item_index,m_l_item_total[node_level],m_l_folders_total[node_level],true);
//--- Увеличим счётчик узлов
   node_level++;
//--- Увеличим размер массивов на один элемент
   AuxiliaryArraysResize(node_level);
//--- Получим и сохраним данные
   m_l_path[node_level]          =m_l_path[node_level-1]+item_text;
   m_l_item_total[node_level]    =ItemsTotal(m_l_path[node_level]+filter,search_area);
   m_l_folders_total[node_level] =FoldersTotal(m_l_path[node_level]+item_text+filter,search_area);
//--- Обнулить счётчик локальных индексов
   item_index=0;
//--- Закрываем хэндл поиска
   ::FileFindClose(handle);
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CFileNavigator::Delete(void)
  {
   CElement::Delete();
//--- Освобождение массивов элемента
   ::ArrayFree(m_g_prev_node_list_index);
   ::ArrayFree(m_g_list_index);
   ::ArrayFree(m_g_item_text);
   ::ArrayFree(m_g_item_index);
   ::ArrayFree(m_g_node_level);
   ::ArrayFree(m_g_prev_node_item_index);
   ::ArrayFree(m_g_items_total);
   ::ArrayFree(m_g_folders_total);
   ::ArrayFree(m_g_item_state);
//---
   ::ArrayFree(m_l_prev_node_list_index);
   ::ArrayFree(m_l_item_text);
   ::ArrayFree(m_l_path);
   ::ArrayFree(m_l_item_index);
   ::ArrayFree(m_l_item_total);
   ::ArrayFree(m_l_folders_total);
//--- Обнулить переменные
   m_current_path="";
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CFileNavigator::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать рамку
   CElement::DrawBorder();
//--- Нарисовать текст
   DrawText();
  }
//+------------------------------------------------------------------+
//| Рисует текст                                                     |
//+------------------------------------------------------------------+
void CFileNavigator::DrawText(void)
  {
//--- Координаты
   int x=5,y=m_y_size>>1;
//--- Свойства текста
   m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Если путь ещё не установлен, показать строку по умолчанию
   if(m_current_full_path=="")
      m_current_full_path="Loading. Please wait...";
//--- Выведем путь в адресную строку файлового навигатора
   m_canvas.TextOut(x,y,m_current_full_path,::ColorToARGB(m_label_color),TA_LEFT|TA_VCENTER);
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CFileNavigator::ChangeWidthByRightWindowSide(void)
  {
//--- Выйти, если включен режим привязки к правой части окна
   if(m_anchor_right_window_side)
      return;
//--- Рассчитать и установить новый размер фону элемента
   int x_size=m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset;
//--- Установить новый размер
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Перерисовать элемент
   Draw();
  }
//+------------------------------------------------------------------+

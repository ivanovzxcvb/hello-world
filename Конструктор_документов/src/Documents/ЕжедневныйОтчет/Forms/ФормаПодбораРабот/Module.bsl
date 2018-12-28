
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", 	Параметры.Пользователь);
	
	// период выборки
	ВариантПериодаВыборки = ХранилищеОбщихНастроек.Загрузить("НастройкиПодбораРабот", "ВариантПериодаВыборки");
	Если ЗначениеЗаполнено(ВариантПериодаВыборки) Тогда 
		ПериодВыборки.Вариант = ВариантПериодаВыборки;
	Иначе	
		ПериодВыборки.Вариант = ВариантСтандартногоПериода.Месяц;
	КонецЕсли;	
	УстановитьОтборПоПериоду();
	
	// условное оформление
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Представление = "Выбранные строки";
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Работа");
	ЭлементОтбора.Использование = Ложь;
		
	ЭлементОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементОформления.Значение = Метаданные.ЭлементыСтиля.ЗакрытыеНеактуальныеЗаписи.Значение; 
	ЭлементОформления.Использование = Истина;
	
	АдресВременногоХранилища = Параметры.АдресВременногоХранилища;
	ВыбранныеСтроки.Загрузить(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["НаправлениеСортировки"] <> Неопределено Тогда
		
		УстановитьСортировку();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, СтандартнаяОбработка, Значение)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Параметр = Новый Структура;
	Параметр.Вставить("Работа",   ТекущиеДанные.Работа);
	Параметр.Вставить("ВидРабот", ТекущиеДанные.ВидРабот);
	Параметр.Вставить("Проект",   ТекущиеДанные.Проект);
	Параметр.Вставить("ПроектнаяЗадача", ТекущиеДанные.ПроектнаяЗадача);
	Параметр.Вставить("Источник", ТекущиеДанные.Источник);
	
	ОповеститьОВыборе(Параметр);
	
	НайденныеСтроки = ВыбранныеСтроки.НайтиСтроки(Новый Структура("Работа", ТекущиеДанные.Работа));
	Если НайденныеСтроки.Количество() = 0 Тогда 
		НоваяСтрока = ВыбранныеСтроки.Добавить();
		НоваяСтрока.Работа = ТекущиеДанные.Работа;
		УстановитьУсловноеОформление();
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура ПериодВыборкиПриИзменении(Элемент)
	
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПриИзменении(Элемент)
	
	УстановитьСортировку();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;

КонецПроцедуры


&НаСервере
Процедура УстановитьОтборПоПериоду()
	
	Список.Параметры.УстановитьЗначениеПараметра("ДатаНачала", ПериодВыборки.ДатаНачала);
	
	Если ЗначениеЗаполнено(ПериодВыборки.ДатаОкончания) Тогда  
		Список.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", ПериодВыборки.ДатаОкончания);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", '39990101');
	КонецЕсли;	
	
	ХранилищеОбщихНастроек.Сохранить("НастройкиПодбораРабот", "ВариантПериодаВыборки", ПериодВыборки.Вариант);
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьСортировку()
	
	Список.Порядок.Элементы.Очистить();
	
	Для Каждого Строка Из Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		
		Если ТипЗнч(Строка) = Тип("ПорядокКомпоновкиДанных") Тогда
			
			Строка.Элементы.Очистить();
			
			ЭлементПорядка = Строка.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
			ЭлементПорядка.Использование = Истина;
			
			Если НаправлениеСортировки = "по дате выполнения" Тогда 
				ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("ДатаВыполнения");
				ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
				
			ИначеЕсли НаправлениеСортировки = "по частоте использования" Тогда 
				ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("ЧислоВхождений");
				ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
				
			ИначеЕсли НаправлениеСортировки = "по содержанию работ" Тогда 
				ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Работа");
				ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
				
			ИначеЕсли НаправлениеСортировки = "по виду работ" Тогда 
				ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("ВидРабот");
				ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
				
			Иначе
				ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("ДатаВыполнения");
				ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	НайденныйЭлемент = "";
	
	ЭлементыУсловногоОформления = Список.УсловноеОформление.Элементы;
	Для Каждого ЭлементУсловногоОформления из ЭлементыУсловногоОформления Цикл
		Если ЭлементУсловногоОформления.Представление = "Выбранные строки" Тогда
			НайденныйЭлемент = ЭлементУсловногоОформления;
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	
	СписокРабот = Новый СписокЗначений;
	Для Каждого Строка Из ВыбранныеСтроки Цикл 
		СписокРабот.Добавить(Строка.Работа);
	КонецЦикла;	
	
	Если СписокРабот.Количество() = 0 Тогда 
		НайденныйЭлемент.Использование = Ложь;
	Иначе
		ЭлементОтбора = НайденныйЭлемент.Отбор.Элементы[0];
		ЭлементОтбора.ПравоеЗначение = СписокРабот;
		ЭлементОтбора.Использование = Истина;
		
		НайденныйЭлемент.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры	

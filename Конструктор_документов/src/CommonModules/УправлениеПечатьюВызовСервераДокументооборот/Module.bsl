
// Возвращает регистрационный номер документа и значение ф.опции "ИспользоватьШтрихкоды"
// Параметры:
//   ДокументОбъект
//
Функция ПолучитьРегНомерДокумента(ДокументОбъект) Экспорт
	
	ИспользоватьШК =  ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды");
	ДанныеВозврата = Новый Структура;
	ДанныеВозврата.Вставить("ИспользоватьШК", ИспользоватьШК);
	ДанныеВозврата.Вставить("РегистрационныйНомер", ДокументОбъект.РегистрационныйНомер);
	
	Возврат ДанныеВозврата;	
	
КонецФункции

//Получает заполненный печатный документ для печати штрихкода
//Параметры:
//			Объект - ссылка на Внутренний, Входящий, Исходящий документ или Файл, штрихкод которого печатается
//			Макет - макет печатного документа
//			НастройкиПоложенияШК - структура
//				ПоказыватьФормуНастройки - показывать форму настройки положения штрихкода
//				ПоложениеНаСтранице - значение из перечисления ВариантыРасположенияШтрихкода
//				СмещениеПоГоризонтали - расстояние от левого края страницы
//				СмещениеПоВертикали - расстояние от верха страницы
//			ВысотаШКВПроцентах - высота изображения штрихкода в процентах
//Возвращает:
//			ТабличныйДокумент, если формирование прошло успешно
//			Неопределено, если формирование не произошло
Функция ПолучитьРегистрационныйШтамп(Объект, НастройкиПоложенияШК, ЗаголовокПриложения) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	
	Если НастройкиПоложенияШК.Свойство("ОриентацияСтраницы") Тогда
		Если НастройкиПоложенияШК.ОриентацияСтраницы = "Портретная" Тогда
			Макет = "ПечатьРегистрационногоШтампаПортрет";
			ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		ИначеЕсли НастройкиПоложенияШК.ОриентацияСтраницы = "Альбомная" Тогда
			Макет = "ПечатьРегистрационногоШтампаАльбом";
			ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Сформирован = Ложь;
	Сформирован = ЗаполнитьРегистрационныйШтамп(
		Объект, Макет, ТабличныйДокумент, НастройкиПоложенияШК, ЗаголовокПриложения);
	
	Если Сформирован Тогда
		Возврат ТабличныйДокумент;
	Иначе 	
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции

//Выполняет вставку изображения штрихкода, настройку его положения
//Параметры:
//			Объект - ссылка на Внутренний, Входящий, Исходящий документ или Файл, штрихкод которого печатается
//			МакетПечати - макет печатного документа
//			табличныйДокумент - документ, в который производится вставка изображения штрихкода
//			НастройкиПоложенияШК - структура
//				ПоказыватьФормуНастройки - показывать форму настройки положения штрихкода
//				ПоложениеНаСтранице - значение из перечисления ВариантыРасположенияШтрихкода
//				СмещениеПоГоризонтали - расстояние от левого края страницы
//				СмещениеПоВертикали - расстояние от верха страницы
//			ВысотаШКВПроцентах - высота изображения штрихкода в процентах
Функция ЗаполнитьРегистрационныйШтамп(Объект, МакетПечати, ТабличныйДокумент, ДанныеОПоложении, ЗаголовокПриложения)

	ИспользоватьШК = ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды");
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет." + МакетПечати);
	
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Шапка.Параметры.Заполнить(Объект);

	Если ИспользоватьШК Тогда
		ДанныеОШтрихкоде = ШтрихкодированиеСервер.ПолучитьДанныеДляВставкиШтрихкодаВОбъект(Объект.Ссылка, Ложь);
		Если ДанныеОШтрихкоде.Свойство("СообщениеОбОшибке") Тогда
			ВызватьИсключение(ДанныеОШтрихкоде.СообщениеОбОшибке);
		КонецЕсли;
		Если ДанныеОШтрихкоде <> Неопределено
			И ДанныеОШтрихкоде.Свойство("ДвоичныеДанныеИзображения") Тогда
			КартинкаШтрихкода = ШтрихкодированиеСервер.ПолучитьКартинкуШтрихкода(
				ДанныеОШтрихкоде.Штрихкод,, ДанныеОПоложении.ВысотаШК, ДанныеОПоложении.ПоказыватьЦифры);
		КонецЕсли;
	КонецЕсли;

	Если НЕ КартинкаШтрихкода = Неопределено 
		ИЛИ НЕ ИспользоватьШК Тогда

		ОриентацияПортрет = Истина;
		Если ДанныеОПоложении.Свойство("ОриентацияСтраницы") Тогда
			Если ДанныеОПоложении.ОриентацияСтраницы = "Портретная" Тогда
				ОриентацияПортрет = Истина;
			ИначеЕсли ДанныеОПоложении.ОриентацияСтраницы = "Альбомная" Тогда
				ОриентацияПортрет = Ложь;
			КонецЕсли;
		КонецЕсли;		
		
		Если ИспользоватьШК Тогда
			Рисунок = Шапка.Область("Картинка");
			Рисунок.Картинка = КартинкаШтрихкода;
			Рисунок.Высота = ДанныеОПоложении.ВысотаШК;
		Иначе
			Шапка.Рисунки.Удалить(Шапка.Рисунки["Картинка"]);
		КонецЕсли;
		
		Надпись = Шапка.Область("НадписьЗаголовок");
		РегистрационныйНомер = Шапка.Область("РегистрационныеДанные");
		
		ПоложениеНаСтранице = ДанныеОПоложении.ПоложениеНаСтранице;
		Если ПоложениеНаСтранице = Перечисления.ВариантыРасположенияШтрихкода.ПравыйНижний Тогда
			СмещениеПоГоризонтали = "MAX";
			СмещениеПоВертикали = "MAX";
		ИначеЕсли ПоложениеНаСтранице = Перечисления.ВариантыРасположенияШтрихкода.ПравыйВерхний Тогда
			СмещениеПоГоризонтали = "MAX";
			СмещениеПоВертикали = "MIN";
		ИначеЕсли ПоложениеНаСтранице = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйВерхний Тогда
			СмещениеПоГоризонтали = "MIN";
			СмещениеПоВертикали = "MIN";
		ИначеЕсли ПоложениеНаСтранице = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйНижний Тогда
			СмещениеПоГоризонтали = "MIN";
			СмещениеПоВертикали = "MAX";
		КонецЕсли;
		
		Если ИспользоватьШК Тогда
			//Если в штампе будет штрихкод, то позиционирование идет относительно штрихкода
			Если СмещениеПоГоризонтали = "MAX" Тогда
				Если ОриентацияПортрет Тогда
					Рисунок.Лево = Шапка.ШиринаСтраницы - Макет.ПолеСправа - Шапка.ПолеСправа - Рисунок.Ширина - 10;
				Иначе
					Рисунок.Лево = Шапка.ВысотаСтраницы - Макет.ПолеСверху - Шапка.ПолеСнизу - Рисунок.Ширина - 10;
				КонецЕсли;
			ИначеЕсли СмещениеПоГоризонтали = "MIN" Тогда
				Рисунок.Лево = Макет.ПолеСлева;
			Иначе
				Рисунок.Лево = ДанныеОПоложении.СмещениеПоГоризонтали;
			КонецЕсли;
			
			Если СмещениеПоВертикали = "MAX" Тогда
				Если ОриентацияПортрет Тогда
					Рисунок.Верх = Макет.ВысотаСтраницы - Макет.ПолеСнизу - Шапка.ПолеСнизу - Рисунок.Высота - 10;
				Иначе
					Рисунок.Верх = Макет.ШиринаСтраницы - Макет.ПолеСлева - Шапка.ПолеСправа - Рисунок.Высота - 10;
				КонецЕсли;
			ИначеЕсли СмещениеПоВертикали = "MIN" Тогда
				Рисунок.Верх = Макет.ПолеСверху;
			Иначе
				Рисунок.Верх = ДанныеОПоложении.СмещениеПоВертикали; 
			КонецЕсли;
			
		Иначе
			
			//Если штрихкода нет, то позиционирование идет относительно названия компании
			Если СмещениеПоГоризонтали = "MAX" Тогда
				Если ОриентацияПортрет Тогда
					Надпись.Лево = Шапка.ШиринаСтраницы - Макет.ПолеСправа - Шапка.ПолеСправа - Надпись.Ширина - 10;
				Иначе
					Надпись.Лево = Шапка.ВысотаСтраницы - Макет.ПолеСверху - Шапка.ПолеСнизу - Надпись.Ширина - 10;
				КонецЕсли;
			ИначеЕсли СмещениеПоГоризонтали = "MIN" Тогда
				Надпись.Лево = Макет.ПолеСлева;
			Иначе
				Надпись.Лево = ДанныеОПоложении.СмещениеПоГоризонтали;
			КонецЕсли;
			
			Если СмещениеПоВертикали = "MAX" Тогда
				Если ОриентацияПортрет Тогда
					Надпись.Верх = Макет.ВысотаСтраницы - Макет.ПолеСнизу - Шапка.ПолеСнизу - Надпись.Высота;
				Иначе
					Надпись.Верх = Макет.ШиринаСтраницы - Макет.ПолеСлева - Шапка.ПолеСправа - Надпись.Высота;
				КонецЕсли;
			ИначеЕсли СмещениеПоВертикали = "MIN" Тогда
				Надпись.Верх = Макет.ПолеСверху;
			Иначе
				Надпись.Верх = ДанныеОПоложении.СмещениеПоВертикали;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТипЗнч(Объект) <> Тип("СправочникСсылка.ВнутренниеДокументы") 
			Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "ВидДокумента.ВестиУчетПоОрганизациям") = Истина Тогда
				Если ТипЗнч(Объект) <> Тип("СправочникСсылка.Файлы") Тогда
					Надпись.Текст = Объект.Организация.Наименование;
				Иначе
					Надпись.Текст = "";
				КонецЕсли;
			Иначе
				Надпись.Текст = "";	
		КонецЕсли;
		
		РегистрационныйНомер.Текст = "№ "
			+ Объект.РегистрационныйНомер + " от "
			+ Формат(Объект.ДатаРегистрации, "ДФ=dd.MM.yyyy");
		//Расположение элементов штампа относительно друг друга
		Если ИспользоватьШК Тогда
			Надпись.Лево = Рисунок.Лево;
			Надпись.Верх = Рисунок.Верх - Надпись.Высота - РегистрационныйНомер.Высота;
			РегистрационныйНомер.Верх = Рисунок.Верх - РегистрационныйНомер.Высота;
		Иначе	
			РегистрационныйНомер.Верх = Надпись.Верх + РегистрационныйНомер.Высота;			
		КонецЕсли;
		
		РегистрационныйНомер.Лево =Надпись.Лево;
				
	КонецЕсли;

	ТабличныйДокумент.Вывести(Шапка);
    Возврат Истина;
	
КонецФункции

// Получает табличный документ для печати штрихкода на наклейке
//
Функция ПолучитьШтрихкодНаНаклейке(ПараметрКоманды, ЗаголовокПриложения) Экспорт
	
	ДанныеОШтрихкоде = ШтрихкодированиеСервер.ПолучитьДанныеДляВставкиШтрихкодаВОбъект(ПараметрКоманды, Ложь);
	Если ДанныеОШтрихкоде = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Для файлов, находящихся в папке ""Шаблоны файлов"", а также для файлов, прикрепленных к должности или контрагенту,
			|штрихкод не формируется.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если ДанныеОШтрихкоде.Свойство("СообщениеОбОшибке") Тогда
		ВызватьИсключение(ДанныеОШтрихкоде.СообщениеОбОшибке);
	КонецЕсли;
	
	НастройкиШтрихкода = ШтрихкодированиеСервер.ПолучитьПерсональныеНастройкиПоложенияШтрихкодаНаСтранице();
	
	ВысотаНаклейки = НастройкиШтрихкода.ВысотаНаклейки;
	ШиринаНаклейки = НастройкиШтрихкода.ШиринаНаклейки;
	Если ВысотаНаклейки = Неопределено
		ИЛИ ПустаяСтрока(ВысотаНаклейки) Тогда
		ВысотаНаклейки = 20;
		ШиринаНаклейки = 38;
		ХранилищеОбщихНастроек.Сохранить("НастройкиШтрихкода", "ШиринаНаклейки", ШиринаНаклейки);
		ХранилищеОбщихНастроек.Сохранить("НастройкиШтрихкода", "ВысотаНаклейки", ВысотаНаклейки);
	КонецЕсли;
	
	ТабДокумент = Новый ТабличныйДокумент();
	Макет = ПолучитьОбщийМакет("НаклейкаШтрихкод");
	Макет.ВысотаСтраницы = ВысотаНаклейки;
    ТабДокумент.ШиринаСтраницы = ШиринаНаклейки;
	ТабДокумент.ВысотаСтраницы = ВысотаНаклейки;
	ТабДокумент.ИмяПринтера = Макет.ИмяПринтера;
	ТабДокумент.ВерхнийКолонтитул.Выводить = Ложь;
	ТабДокумент.НижнийКолонтитул.Выводить = Ложь;
	ТабДокумент.ОбластьПечати = Макет.ОбластьПечати;
	ТабДокумент.РазмерКолонтитулаСверху = 0;
	ТабДокумент.РазмерКолонтитулаСнизу = 0;
	ТабДокумент.ПолеСверху = 0;
	ТабДокумент.ПолеСнизу = 0;
	ТабДокумент.ПолеСлева = 0;
	ТабДокумент.ПолеСправа = 0;
	Шапка = Макет.ПолучитьОбласть("Шапка");
	
	РисунокШтрихкод = Шапка.Область("Штрихкод");
    
	РисунокШтрихкод.Верх = 1;
	РисунокШтрихкод.Лево = 1;
	РисунокШтрихкод.Ширина = ШиринаНаклейки - 2;
	РисунокШтрихкод.Высота = ВысотаНаклейки - 2;
	
	ДанныеОШтрихкоде.ДвоичныеДанныеИзображения = ШтрихкодированиеСервер.ПолучитьКартинкуШтрихкода(ДанныеОШтрихкоде.Штрихкод, , РисунокШтрихкод.Высота, Истина).ПолучитьДвоичныеДанные();
	
	КартинкаШтрихкода = Новый Картинка(ДанныеОШтрихкоде.ДвоичныеДанныеИзображения);
	РисунокШтрихкод.Картинка = КартинкаШтрихкода;
	
	ТабДокумент.Вывести(Шапка);
	
	Возврат ТабДокумент; 
	
КонецФункции

// Получает табличный документ для печати штрихкода на наклейке
//
Функция ПолучитьШтрихкодНаСтранице(Объект, НастройкиПоложенияШК, ЗаголовокПриложения) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	
	Если НастройкиПоложенияШК.Свойство("ОриентацияСтраницы") Тогда
		Если НастройкиПоложенияШК.ОриентацияСтраницы = "Портретная" Тогда
			Макет = "ПечатьШтрихкодаПортрет";
			ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		ИначеЕсли НастройкиПоложенияШК.ОриентацияСтраницы = "Альбомная" Тогда
			Макет = "ПечатьШтрихкодаАльбом";
			ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Сформирован = Ложь;
	Сформирован = ЗаполнитьШтрихкодНаСтранице(
		Объект, Макет, ТабличныйДокумент, НастройкиПоложенияШК, ЗаголовокПриложения);
	
	Если Сформирован Тогда
		Возврат ТабличныйДокумент;
	Иначе 	
		Возврат Неопределено;
	КонецЕсли;	
		
КонецФункции

//Выполняет вставку изображения штрихкода, настройку его положения
//Параметры:
//			Объект - ссылка на Внутренний, Входящий, Исходящий документ или Файл, штрихкод которого печатается
//			МакетПечати - макет печатного документа
//			табличныйДокумент - документ, в который производится вставка изображения штрихкода
//			НастройкиПоложенияШК - структура
//				ПоказыватьФормуНастройки - показывать форму настройки положения штрихкода
//				ПоложениеНаСтранице - значение из перечисления ВариантыРасположенияШтрихкода
//				СмещениеПоГоризонтали - расстояние от левого края страницы
//				СмещениеПоВертикали - расстояние от верха страницы
//			ВысотаШКВПроцентах - высота изображения штрихкода в процентах
Функция ЗаполнитьШтрихкодНаСтранице(Объект, МакетПечати, ТабличныйДокумент, ДанныеОПоложении, ЗаголовокПриложения)
	
	Макет = ПолучитьОбщийМакет(МакетПечати);
	
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Шапка.Параметры.Заполнить(Объект);

	ДанныеОШтрихкоде = ШтрихкодированиеСервер.ПолучитьДанныеДляВставкиШтрихкодаВОбъект(Объект.Ссылка, Ложь);
	Если ДанныеОШтрихкоде <> Неопределено
		И ДанныеОШтрихкоде.Свойство("ДвоичныеДанныеИзображения") Тогда
		КартинкаШтрихкода = ШтрихкодированиеСервер.ПолучитьКартинкуШтрихкода(ДанныеОШтрихкоде.Штрихкод,, ДанныеОПоложении.ВысотаШК, ДанныеОПоложении.ПоказыватьЦифры);
	КонецЕсли;
	Если ДанныеОШтрихкоде.Свойство("СообщениеОбОшибке") Тогда
		ВызватьИсключение(ДанныеОШтрихкоде.СообщениеОбОшибке);
	КонецЕсли;
	
	Если НЕ КартинкаШтрихкода = Неопределено Тогда
		ОриентацияПортрет = Истина;
		Если ДанныеОПоложении.Свойство("ОриентацияСтраницы") Тогда
			Если ДанныеОПоложении.ОриентацияСтраницы = "Портретная" Тогда
				ОриентацияПортрет = Истина;
			ИначеЕсли ДанныеОПоложении.ОриентацияСтраницы = "Альбомная" Тогда
				ОриентацияПортрет = Ложь;
			КонецЕсли;
		КонецЕсли;		
		
		Рисунок = Шапка.Область("Картинка");
		Рисунок.Картинка = КартинкаШтрихкода;
        Рисунок.Высота = ДанныеОПоложении.ВысотаШК;
		Надпись = Шапка.Область("НадписьЗаголовок");
		
		Если ДанныеОПоложении.ПоложениеНаСтранице = Перечисления.ВариантыРасположенияШтрихкода.ПравыйНижний Тогда
			СмещениеПоГоризонтали = "MAX";
			СмещениеПоВертикали = "MAX";
		ИначеЕсли ДанныеОПоложении.ПоложениеНаСтранице = Перечисления.ВариантыРасположенияШтрихкода.ПравыйВерхний Тогда
			СмещениеПоГоризонтали = "MAX";
			СмещениеПоВертикали = "MIN";
		ИначеЕсли ДанныеОПоложении.ПоложениеНаСтранице = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйВерхний Тогда
			СмещениеПоГоризонтали = "MIN";
			СмещениеПоВертикали = "MIN";
		ИначеЕсли ДанныеОПоложении.ПоложениеНаСтранице = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйНижний Тогда
			СмещениеПоГоризонтали = "MIN";
			СмещениеПоВертикали = "MAX";
		КонецЕсли;

		
		Если СмещениеПоГоризонтали = "MAX" Тогда
			Если ОриентацияПортрет Тогда
				Рисунок.Лево = Шапка.ШиринаСтраницы - Макет.ПолеСправа - Шапка.ПолеСправа - Рисунок.Ширина - 10;
			Иначе
				Рисунок.Лево = Шапка.ВысотаСтраницы - Макет.ПолеСверху - Шапка.ПолеСнизу - Рисунок.Ширина - 10;
			КонецЕсли;
		ИначеЕсли СмещениеПоГоризонтали = "MIN" Тогда
			Рисунок.Лево = Макет.ПолеСлева;
		Иначе
			Рисунок.Лево = ДанныеОПоложении.СмещениеПоГоризонтали;
		КонецЕсли;
		
		Если СмещениеПоВертикали = "MAX" Тогда
			Если ОриентацияПортрет Тогда
				Рисунок.Верх = Макет.ВысотаСтраницы - Макет.ПолеСнизу - Шапка.ПолеСнизу - Рисунок.Высота - 10;
			Иначе
				Рисунок.Верх = Макет.ШиринаСтраницы - Макет.ПолеСлева - Шапка.ПолеСправа - Рисунок.Высота - 10;
			КонецЕсли;
		ИначеЕсли СмещениеПоВертикали = "MIN" Тогда
			Рисунок.Верх = Макет.ПолеСверху;
		Иначе
			Рисунок.Верх = ДанныеОПоложении.СмещениеПоВертикали; 
		КонецЕсли;
			
		Шапка.Параметры.Заполнить(Объект);
		Если ТипЗнч(Объект) <> Тип("СправочникСсылка.Файлы") Тогда
			Надпись.Текст = Объект.Организация.Наименование;
		Иначе
			Надпись.Текст = "";
		КонецЕсли;
		
		//Расположение элементов штампа относительно друг друга
		Надпись.Лево = Рисунок.Лево;
		Надпись.Верх = Рисунок.Верх - Надпись.Высота;
		
	КонецЕсли;

	ТабличныйДокумент.Вывести(Шапка);
    Возврат Истина;
	
КонецФункции

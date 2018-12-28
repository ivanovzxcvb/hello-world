
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Автор = ТекущийПользователь;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокФормыСоздания") И ЗначениеЗаполнено(Параметры.ЗаголовокФормыСоздания) Тогда 
		ЗаголовокФормыСоздания = Параметры.ЗаголовокФормыСоздания;
		Заголовок = Параметры.ЗаголовокФормыСоздания + НСтр("ru=' (создание)'");
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Параметры.Свойство("ОбластьПрименения") И ЗначениеЗаполнено(Параметры.ОбластьПрименения)
			И Не ЗначениеЗаполнено(Объект.ОбластьПрименения) Тогда 
			Объект.ОбластьПрименения = Параметры.ОбластьПрименения;
		Иначе
			Объект.ОбластьПрименения = Перечисления.ОбластиПримененияШаблоновТекстов.Почта;
		КонецЕсли;
	КонецЕсли;	
	
	Если Не Объект.ОбластьПрименения = Перечисления.ОбластиПримененияШаблоновТекстов.Резолюции
		И Не Объект.ОбластьПрименения = Перечисления.ОбластиПримененияШаблоновТекстов.Почта Тогда 
		
		ПростойШаблон = Истина;  // упрощенная форма
		
		Элементы.ГруппаПолейПодписи.Видимость = Ложь;
		Элементы.Доступ.Видимость = Ложь;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.ОбщийШаблонЗакладкаШаблон.Видимость = Истина;
		Элементы.Шаблон.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
		Элементы.НастроитьДоступ.Видимость = Объект.ОбщийШаблон;
		Если Объект.Пользователи.Количество() <> 0 Тогда
			Элементы.НастроитьДоступ.Заголовок 
				= СтрШаблон(НСтр("ru = 'Настроить доступ (%1)'"), Объект.Пользователи.Количество());
		Иначе	
			Элементы.НастроитьДоступ.Заголовок = НСтр("ru = 'Настроить доступ'");
		КонецЕсли;	
		
		КлючСохраненияПоложенияОкна = "ШаблоныТекстов.ПростойШаблон";
		
	Иначе	
		
		Элементы.ОбщийШаблонЗакладкаШаблон.Видимость = Ложь;
		Элементы.НастроитьДоступ.Видимость = Ложь;
		
		КлючСохраненияПоложенияОкна = "ШаблоныТекстов.РасширенныйШаблон";
		
	КонецЕсли;	
	
	Если Объект.ОбластьПрименения = Перечисления.ОбластиПримененияШаблоновТекстов.Резолюции Тогда 
		Элементы.ВставитьШаблонВремени.Видимость = Ложь;
		Элементы.ВставитьСрокИсполнения.Видимость = Истина;
	КонецЕсли;
		
	Если Не Объект.ОбщийШаблон Тогда 
		Элементы.ГруппаДоступа.Доступность = Ложь;
	КонецЕсли;
	
	Если Не Объект.Ссылка.Пустая() Тогда 
		ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
		Если Не ПраваПоОбъекту.Изменение Тогда
			ТолькоПросмотр = Истина;
			Элементы.ПользователиПодобратьПользователей.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Объект.Наименование)
		И Не ЗначениеЗаполнено(Объект.Шаблон)
		И Объект.ОбластьПрименения = Перечисления.ОбластиПримененияШаблоновТекстов.Почта Тогда
		
		Объект.Шаблон = Объект.Наименование;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ОбластьПрименения = Перечисления.ОбластиПримененияШаблоновТекстов.Резолюции Тогда 
		Если НЕ ЗначениеЗаполнено(ТекущийОбъект.Ссылка) Тогда 
			ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
		
		ИначеЕсли Модифицированность И 
			ТекущийОбъект.Наименование <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийОбъект.Ссылка, "Наименование") Тогда 
			ПараметрыЗаписи.Вставить("ИзменилосьНаименование", Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ЗаголовокФормыСоздания) Тогда
		Заголовок = Объект.Наименование + " (" + ЗаголовокФормыСоздания + ")";
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект Тогда
		ПараметрОповещения = Новый Структура;
		ПараметрОповещения.Вставить("Шаблон", Объект.Ссылка);
		ПараметрОповещения.Вставить("Наименование", Объект.Наименование);
		Оповестить("СозданНовыйШаблонРезолюции", ПараметрОповещения);
	ИначеЕсли ПараметрыЗаписи.Свойство("ИзменилосьНаименование") И ПараметрыЗаписи.ИзменилосьНаименование Тогда
		ПараметрОповещения = Новый Структура;
		ПараметрОповещения.Вставить("Шаблон", Объект.Ссылка);   
		ПараметрОповещения.Вставить("Наименование", Объект.Наименование);
		Оповестить("ИзменилсяШаблонРезолюции", ПараметрОповещения);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПользователиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ПользовательИлиГруппа = 
			ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательИлиГруппаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьПользователей(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательИлиГруппаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ТекущийДанные = Элементы.Пользователи.ТекущиеДанные;
		ТекущийДанные.ПользовательИлиГруппа = ВыбранноеЗначение.РольИсполнителя;
		Модифицированность = Истина;
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") 
		Или ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.РабочиеГруппы") Тогда
		ТекущийДанные = Элементы.Пользователи.ТекущиеДанные;
		ТекущийДанные.ПользовательИлиГруппа = ВыбранноеЗначение;
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательИлиГруппаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь; 
		ДанныеВыбора = СформироватьДанныеВыбора(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщийШаблонПриИзменении(Элемент)
	
	Элементы.ГруппаДоступа.Доступность = Объект.ОбщийШаблон;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщийШаблонЗакладкаШаблонПриИзменении(Элемент)
	
	Элементы.НастроитьДоступ.Видимость = Объект.ОбщийШаблон;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Шаблон) И ЗначениеЗаполнено(Объект.Наименование) Тогда
		Объект.Шаблон = Объект.Наименование;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ШаблонПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) И ЗначениеЗаполнено(Объект.Шаблон) Тогда
		Объект.Наименование = Объект.Шаблон;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВставитьДатаИВремя(Команда)
	
	Объект.Шаблон  = Объект.Шаблон + "[День].[Месяц].[Год] [Час]:[Минута]";
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДень(Команда)
	
	Объект.Шаблон  = Объект.Шаблон + "[День]";
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьМесяц(Команда)
	
	Объект.Шаблон  = Объект.Шаблон + "[Месяц]";
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьГод(Команда)
	
	Объект.Шаблон  = Объект.Шаблон + "[Год]";
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьЧас(Команда)
	
	Объект.Шаблон  = Объект.Шаблон + "[Час]";
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьМинута(Команда)
	
	Объект.Шаблон  = Объект.Шаблон + "[Минута]";
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПользователей(Команда)
	
	ВыбратьПользователей(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователей(МножественныйВыбор)
	
	РабочаяГруппа = Новый Массив;
	
	Если МножественныйВыбор Тогда
		Для Каждого ТаблицаСтрока Из Объект.Пользователи Цикл
			Участник = Новый Структура("Контакт", ТаблицаСтрока.ПользовательИлиГруппа);
			РабочаяГруппа.Добавить(Участник);
		КонецЦикла;
		
		РежимРаботыФормы = 2;
		ЗаголовокФормы = НСтр("ru = 'Подбор пользователей общего шаблона текста'");
		ЗаголовокСпискаВыбранных = НСтр("ru = 'Выбранные пользователи/группы:'");
		ЗаголовокСпискаАдреснойКниги = НСтр("ru = 'Все пользователи/группы:'");
	Иначе
		РежимРаботыФормы = 1;
		ЗаголовокФормы = НСтр("ru = 'Выбор участника группы доступа'");
		ЗаголовокСпискаВыбранных = "";
		ЗаголовокСпискаАдреснойКниги = "";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗаголовокФормы", ЗаголовокФормы);
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", ЗаголовокСпискаВыбранных);
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", ЗаголовокСпискаАдреснойКниги);
	ПараметрыФормы.Вставить("РежимРаботыФормы", РежимРаботыФормы);
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", РабочаяГруппа);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершениеПодбораПользователей", ЭтотОбъект, МножественныйВыбор);
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеПодбораПользователей(ВыбранныеПользователи, МножественныйВыбор) Экспорт
	
	Если ВыбранныеПользователи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если МножественныйВыбор Тогда
		Объект.Пользователи.Очистить();
		Для Каждого ГруппаСтрока Из ВыбранныеПользователи Цикл
			Строка = Объект.Пользователи.Добавить();
			Строка.ПользовательИлиГруппа = ГруппаСтрока.Контакт;
		КонецЦикла;
	Иначе
		ТекущаяСтрока = Элементы.Пользователи.ТекущаяСтрока;
		Если ТекущаяСтрока <> Неопределено Тогда
			ТекущиеДанные = Объект.Пользователи.НайтиПоИдентификатору(ТекущаяСтрока);
			ТекущиеДанные.ПользовательИлиГруппа = ВыбранныеПользователи[0].Контакт;
		КонецЕсли;
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОрфографию(Команда)
	
	#Если Не ВебКлиент Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеПроверитьОрфографиюТекст", ЭтотОбъект);
		ВстроеннаяПочтаКлиент.ПроверитьОрфографиюТекст(ОписаниеОповещения, Объект.Шаблон);
		
	#КонецЕсли
	
КонецПроцедуры

Процедура ЗавершениеПроверитьОрфографиюТекст(Результат, Параметры) Экспорт
	
	Если Результат.ТекстИзменен Тогда
		Объект.Шаблон = Результат.ТекстПисьма;
		Модифицированность = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьДоступ(Команда)
	
	Если Модифицированность Тогда
		Если НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Объект.ОбщийШаблон = Истина;
	
	Пользователи = Новый Массив;
	Для Каждого Строка Из Объект.Пользователи Цикл
		Пользователи.Добавить(Строка.ПользовательИлиГруппа);
	КонецЦикла;	
	
	ПараметрыФормы = Новый Структура("Пользователи", 
		Пользователи);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НастроитьДоступПродолжение",
		ЭтотОбъект);
		
	ОткрытьФорму("Справочник.ШаблоныТекстов.Форма.НастройкаДоступа", 
		ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура НастроитьДоступПродолжение(Результат, Параметры) Экспорт 
	
	Если ТипЗнч(Результат) = Тип("Массив")  Тогда 
		
		Объект.Пользователи.Очистить();
		Для Каждого Пользователь Из Результат Цикл
			Строка = Объект.Пользователи.Добавить();
			Строка.ПользовательИлиГруппа = Пользователь;
		КонецЦикла;	
		
		Если Объект.Пользователи.Количество() <> 0 Тогда
			Элементы.НастроитьДоступ.Заголовок 
				= СтрШаблон(НСтр("ru = 'Настроить доступ (%1)'"), Объект.Пользователи.Количество());
		Иначе	
			Элементы.НастроитьДоступ.Заголовок = НСтр("ru = 'Настроить доступ'");
		КонецЕсли;	
		
		Модифицированность = Истина;
		
	КонецЕсли;	
		
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СформироватьДанныеВыбора(Текст)
	
	Возврат ПользователиДокументооборот.СформироватьДанныеВыбора(Текст, Истина);
	
КонецФункции

&НаКлиенте
Процедура ВставитьОдинДень(Команда)
	
	Объект.Шаблон  = Объект.Шаблон + "[1 день]";
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДваДня(Команда)
	
	Объект.Шаблон  = Объект.Шаблон + "[2 дня]";
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьТриДня(Команда)
	
	Объект.Шаблон  = Объект.Шаблон + "[3 дня]";
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьНеделю(Команда)
	
	Объект.Шаблон  = Объект.Шаблон + "[Неделя]";
	
КонецПроцедуры

#КонецОбласти

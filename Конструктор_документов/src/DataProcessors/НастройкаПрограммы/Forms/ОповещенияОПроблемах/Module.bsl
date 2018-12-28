#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокОповещения();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьСписокОповещения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УстанавливаемыеПараметры = Новый Структура;
	УстанавливаемыеПараметры.Вставить("Пользователи", ПользователиКлиентСервер.ТекущийПользователь());
	УстановитьПараметрыФункциональныхОпцийИнтерфейса(УстанавливаемыеПараметры);
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
	Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокОповещения()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПолучателиОповещенийОПроблемахРаботыПрограммы.Пользователь КАК Пользователь
		|ИЗ
		|	РегистрСведений.ПолучателиОповещенийОПроблемахРаботыПрограммы КАК ПолучателиОповещенийОПроблемахРаботыПрограммы
		|
		|УПОРЯДОЧИТЬ ПО
		|	Пользователь";
	
	МассивПользователей = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	Для Каждого Пользователь Из МассивПользователей Цикл
		СписокОповещения.Добавить(Пользователь);
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСписокОповещения()
	
	// стираем записи
	НаборЗаписей = РегистрыСведений.ПолучателиОповещенийОПроблемахРаботыПрограммы.СоздатьНаборЗаписей();
	// не добавляем записи в набор - чтобы все стереть
	НаборЗаписей.Записать();
	
	Для Каждого Строка Из СписокОповещения Цикл
		
		Пользователь = Строка.Значение;
		
		Если ЗначениеЗаполнено(Пользователь) Тогда
			МенеджерЗаписи = РегистрыСведений.ПолучателиОповещенийОПроблемахРаботыПрограммы.СоздатьМенеджерЗаписи();
			
			МенеджерЗаписи.Пользователь = Пользователь;
			МенеджерЗаписи.Записать();
		КонецЕсли;

	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

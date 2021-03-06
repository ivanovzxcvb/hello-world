#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьНастройки();
	
	Элементы.ПериодАвтообновления.Доступность = НастройкаАвтообновление;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтображатьВремяСПриИзменении(Элемент)
	
	ОтображатьВремяПоНормализованное = 24 - ОтображатьВремяПо;
	Если ОтображатьВремяС >= ОтображатьВремяПоНормализованное Тогда
		ОтображатьВремяПоНормализованное = ОтображатьВремяС + 1;
		ОтображатьВремяПо = 24 - ОтображатьВремяПоНормализованное;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьВремяПоПриИзменении(Элемент)
	
	ОтображатьВремяПоНормализованное = 24 - ОтображатьВремяПо;
	Если ОтображатьВремяС >= ОтображатьВремяПоНормализованное Тогда
		ОтображатьВремяС = ОтображатьВремяПоНормализованное - 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтообновлениеПриИзменении(Элемент)
	
	Элементы.ПериодАвтообновления.Доступность = НастройкаАвтообновление;
	Если ПериодАвтообновления < 10 Тогда
		ПериодАвтообновления = 300; // Значение по умолчанию если период еще не задан
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодАвтообновленияПриИзменении(Элемент)
	
	Если ПериодАвтообновления < 10 Тогда
		ПериодАвтообновления = 10; // Не меньше 10 секунд
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	ГотовоНаСервере();
	Оповестить("Запись_НастройкиКалендаря");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьДоступноеВремя(Команда)
	
	РаботаСРабочимКалендаремКлиент.ОткрытьФормуНастройкиДоступногоВремени();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ГотовоНаСервере()
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"ОтображатьВремяС", ОтображатьВремяС);
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"ОтображатьВремяПо", ОтображатьВремяПо);
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"ОтображениеВремениЭлементов", ОтображениеВремениЭлементов);
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"ОтображатьЗанятость", ОтображатьЗанятость);
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"ИспользоватьБыстроеРедактирование", ИспользоватьБыстроеРедактирование);
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"ОтображатьПомеченныеНаУдаление", ОтображатьПомеченныеНаУдаление);
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"РазмерЯчейкиВремени", РазмерЯчейкиВремени);
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"ОтображатьОтклоненные", ОтображатьОтклоненные);
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"ОтображатьКалендарьВЗаписиКалендаря", ОтображатьКалендарьВЗаписиКалендаря);
	
	МассивСтруктур = Новый Массив;
	// НапоминанияПользователя
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиНапоминаний", "ИнтервалПроверкиНапоминаний",
		ИнтервалПроверкиНапоминаний);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиНапоминаний", "СрокНапоминанияПоУмолчанию",
		СрокНапоминанияПоУмолчанию);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиНапоминаний", "УстанавливатьНапоминаниеАвтоматически",
		УстанавливатьНапоминаниеАвтоматически);
	// Конец НапоминанияПользователя
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
	Результат = Новый Структура;
	Результат.Вставить("Автообновление", НастройкаАвтообновление);
	Результат.Вставить("ПериодАвтообновления", ПериодАвтообновления);
	Автообновление.СохранитьНастройкиАвтообновленияФормы(
		"Справочник.ЗаписиРабочегоКалендаря.Форма.Календарь", Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройки()
	
	ОтображатьВремяС = 
		РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("ОтображатьВремяС");
	ОтображатьВремяПо =
		РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("ОтображатьВремяПо");
	ОтображениеВремениЭлементов =
		РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("ОтображениеВремениЭлементов");
	ОтображатьЗанятость =
		РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("ОтображатьЗанятость");
	ИспользоватьБыстроеРедактирование =
		РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("ИспользоватьБыстроеРедактирование");
	ОтображатьПомеченныеНаУдаление =
		РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("ОтображатьПомеченныеНаУдаление");
	РазмерЯчейкиВремени =
		РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("РазмерЯчейкиВремени");
	ОтображатьОтклоненные =
		РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("ОтображатьОтклоненные");
	ОтображатьКалендарьВЗаписиКалендаря =
		РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("ОтображатьКалендарьВЗаписиКалендаря");
	
	// НапоминанияПользователя
	Элементы.ГруппаНапоминания.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНапоминанияПользователя");
	ИнтервалПроверкиНапоминаний = НапоминанияПользователяСлужебный.ПолучитьИнтервалПроверкиНапоминаний();
	СрокНапоминанияПоУмолчанию =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиНапоминаний",
			"СрокНапоминанияПоУмолчанию",
			15);
	УстанавливатьНапоминаниеАвтоматически =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиНапоминаний",
			"УстанавливатьНапоминаниеАвтоматически",
			Истина);
	// Конец НапоминанияПользователя
	
	НастройкиАвтообновления = Автообновление.ПолучитьНастройкиАвтообновленияФормы(
		"Справочник.ЗаписиРабочегоКалендаря.Форма.Календарь");
	НастройкаАвтообновление = НастройкиАвтообновления.Автообновление;
	ПериодАвтообновления = НастройкиАвтообновления.ПериодАвтообновления;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтруктуруНастройки(МассивСтруктур, Объект, Настройка, Значение)
	
	МассивСтруктур.Добавить(Новый Структура ("Объект, Настройка, Значение", Объект, Настройка, Значение));
	
КонецПроцедуры

#КонецОбласти





&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ПараметрыВыполненияКоманды", ПараметрыВыполненияКоманды);
	ПараметрыОповещения.Вставить("ПараметрКоманды", ПараметрКоманды);
	РежимОткрытияФормы = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	ОповещениеОЗакрытииФормыСозданиеДокументаПоШаблону = Новый ОписаниеОповещения(
		"СозданиеВнутреннегоДокументаНаОсновании", ЭтотОбъект, ПараметрыОповещения);

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ТипШаблонаДокумента",  "ШаблоныВнутреннихДокументов");
	ПараметрыФормы.Вставить("ВозможностьСозданияПустогоДокумента", Истина);
	
	Попытка
		
		ОткрытьФорму(
			"ОбщаяФорма.СозданиеДокументаПоШаблону",
			ПараметрыФормы,,,,,
			ОповещениеОЗакрытииФормыСозданиеДокументаПоШаблону,
			РежимОткрытияФормы);
		Возврат;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Если Инфо.Описание = "СоздатьПустойДокумент" Тогда
			ВыполнитьОбработкуОповещения(ОповещениеОЗакрытииФормыСозданиеДокументаПоШаблону,
				"СоздатьПустойДокумент");
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура СозданиеВнутреннегоДокументаНаОсновании(Результат, Параметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Результат) ИЛИ Результат = "ПрерватьОперацию" Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	Если (ТипЗнч(Результат) <> Тип("Строка")) Тогда 
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат.ШаблонДокумента);
		Результат.Вставить("Основание", Параметры.ПараметрКоманды);
		ПараметрыФормы.Вставить("Основание", Результат);
		ПараметрыФормы.Вставить("ЗаполнятьРеквизитыДоСоздания", Истина);
	Иначе
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат);
		ПараметрыФормы.Вставить("Основание", Параметры.ПараметрКоманды);
	КонецЕсли;
	
	Открытьформу("Справочник.ВнутренниеДокументы.ФормаОбъекта", ПараметрыФормы, Параметры.ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

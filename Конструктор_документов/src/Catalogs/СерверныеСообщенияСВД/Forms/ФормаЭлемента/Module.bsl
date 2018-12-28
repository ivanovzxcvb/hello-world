&НаКлиенте
Процедура ОтправленоПриИзменении(Элемент)
	
	Если НЕ Объект.Отправлено Тогда
		Объект.ДатаОтправкиПолучателю = Дата(1,1,1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьСообщение(Команда)
	
	ДанныеФайла = РаботаССВД.ДанныеФайлаДляОткрытия(Объект.Ссылка);
	Если ДанныеФайла <> Неопределено Тогда
		КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ТекстHTML = РаботаССВД.ПолучитьHTMLПоXDTO(Объект.Ссылка, Объект.ФорматСообщения);
	
КонецПроцедуры

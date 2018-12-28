Процедура ПолучитьСообщения(ТранспортПриема) Экспорт
	
	Настройка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТранспортПриема, "Настройка");
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Настройка);
	
	МассивСообщений = Менеджер.ПолучитьСообщения(Настройка);
	
	ФорматСообщения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТранспортПриема, "ФорматСообщения");
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ФорматСообщения);
	
	Для Каждого СообщениеСВД Из МассивСообщений Цикл
		Менеджер.ЗаписатьСообщения(ФорматСообщения, СообщениеСВД);
	КонецЦикла;
		
КонецПроцедуры


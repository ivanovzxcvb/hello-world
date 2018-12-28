#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	// Конец СтандартныеПодсистемы
	
	Если ИменаПараметровСеанса = Неопределено
		Или ИменаПараметровСеанса.Найти("ДокументооборотИспользоватьОграниченияПравДоступа") <> Неопределено Тогда
		
		ПараметрыСеанса.ДокументооборотИспользоватьОграниченияПравДоступа = 
			Константы.ДокументооборотИспользоватьОграничениеПравДоступа.Получить()
			Или Константы.ДокументооборотВключитьПраваДоступа.Получить();
			
	КонецЕсли;
	
	Если ИменаПараметровСеанса = Неопределено
		Или ИменаПараметровСеанса.Найти("ПриоритетОчередиОбновленияПрав") <> Неопределено Тогда
		
		ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = 1;
		
	КонецЕсли;
		
	// Проверка разрешения доступа через веб-сервер
	// Если доступ через веб-серверы никак не ограничивается, то
	// проверка не выполняется
	Если Константы.ОграничиватьДоступЧерезВебСерверы.Получить() И ИменаПараметровСеанса = Неопределено Тогда
	
		ТекущийПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь(); 
		
		// Нахождение текущего соединения
		НомерСоединения = НомерСоединенияИнформационнойБазы();
		ТекущееСоединение = Неопределено;
		СоединенияИнформационнойБазы = ПолучитьСоединенияИнформационнойБазы();
		Для Каждого СоединениеИБ Из СоединенияИнформационнойБазы Цикл
			Если СоединениеИБ.НомерСоединения = НомерСоединения Тогда
				ТекущееСоединение = СоединениеИБ;
				Прервать;
			КонецЕсли;	
		КонецЦикла;
		
		// Если текущее соединение выполнено через веб-сервер, то выполняется 
		// проверка разрешения
		Если ТекущееСоединение.ИмяПриложения = "WebServerExtension" Тогда
			
			// Поиск сведений о разрешении подключения через веб-сервер
			ИмяВебСервера = ТекущееСоединение.ИмяКомпьютера;
			
			// Проверка списка разрешенных веб-серверов
			ТекущийПользователь = Пользователи.ТекущийПользователь();
			Если Найти(НРег(ТекущийПользователь.РазрешенныеВебСерверы), НРег(ИмяВебСервера)) = 0 Тогда
				
				// Отказ в доступе
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	 				НСтр("ru = 'Вам не разрешен доступ к программе через веб-сервер %1. 
					|Обратитесь к администратору.'"),
					ИмяВебСервера);
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Подключение через веб-сервер'"), УровеньЖурналаРегистрации.Ошибка,
					, , ТекстСообщения);

				ВызватьИсключение ТекстСообщения;
				
			КонецЕсли;	
			
			// Проверка на пустой пароль
			Если Не ТекущийПользовательИБ.ПарольУстановлен Тогда
				
				// Отказ в доступе
				ТекстСообщения = НСтр("ru = 'Доступ к программе через веб-сервер не разрешен для пользователей без пароля. 
					|Обратитесь к администратору.'");
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Подключение через веб-сервер'"), УровеньЖурналаРегистрации.Ошибка,
					, , ТекстСообщения);
				ВызватьИсключение ТекстСообщения;	
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли; // Проверка разрешения доступа через веб-сервер
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
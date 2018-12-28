
&НаКлиенте
Процедура ПорядокИспользованияПриИзменении(Элемент)
	
	ПриИзмененииПорядкаИспользования();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПорядкаИспользования()
	
	Если ПорядокИспользования = "ВсеПредшественники" Тогда
		Элементы.ОбъектЭтапы.Доступность = Истина;
	ИначеЕсли ПорядокИспользования = "ОдинИзПредшественников" Тогда
		Элементы.ОбъектЭтапы.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ОчиститьСообщения();
	СписокПредшественников = Новый СписокЗначений;

	Для Каждого Этап Из Этапы Цикл
		Если Этап.Использовать Тогда
			ДанныеПредшественника = Новый Структура;
			ДанныеПредшественника.Вставить("УсловиеПерехода", Этап.УсловиеПерехода);
			Данныепредшественника.Вставить("УсловиеРассмотрения", Этап.УсловиеРассмотрения);
			ДанныеПредшественника.Вставить("ИдентификаторПредшественника", Этап.ИдентификаторЭтапа);
			ДанныеПредшественника.Вставить("ИмяПредметаУсловия", Этап.ИмяПредметаУсловия);
			СписокПредшественников.Добавить(ДанныеПредшественника);
		КонецЕсли;
	КонецЦикла;
	Если СписокПредшественников.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо отметить хотя бы одно действие'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,"Этапы");
		Возврат;
	КонецЕсли;

	ДанныеВозврата = Новый Структура;
	ДанныеВозврата.Вставить("ПредшественникиВариантИспользования", ПорядокИспользования);
	ДанныеВозврата.Вставить("Предшественники", СписокПредшественников);
	Данныевозврата.Вставить("ИдентификаторЭтапа", ИдентификаторЭтапа);
	ДанныеВозврата.Вставить("ВладелецЭтапа", ВладелецЭтапа);
	Оповестить("НастройкаПорядкаВыполнения", ДанныеВозврата);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДоступностьПоШаблону") Тогда
		Элементы.ФормаКомандаОК.Доступность = Параметры.ДоступностьПоШаблону;
	КонецЕсли;
	
	ИдентификаторЭтапа = Параметры.ИдентификаторТекущегоЭтапа;
	ВладелецЭтапа = Параметры.ВладелецЭтапа;
	ИменаПредметов.ЗагрузитьЗначения(Параметры.ИменаПредметов);
	
	Для Каждого Этап Из Параметры.Этапы Цикл
		Если Этап.Значение.Удален Тогда
			Продолжить;
		КонецЕсли;
		Если Этап.Значение.ИдентификаторЭтапа = ИдентификаторЭтапа Тогда
			ТекущийЭтапСтрокой = "№" + Этап.Значение.НомерЭтапа + " " + Этап.Значение.ЗадачаЭтапа;
			ШаблонПроцессаТекущегоЭтапа = Этап.Значение.ШаблонБизнесПроцесса;
			НомерНастраиваемогоЭтапа = Этап.Значение.НомерЭтапа; 
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Порядок выполнения действия ""%1""'"),
				ТекущийЭтапСтрокой);
			Продолжить;
		КонецЕсли;
		НовыйЭтап = Этапы.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйЭтап, Этап.Значение);
		Для Каждого Предшественник Из Параметры.Предшественники Цикл
			Если Предшественник.Значение.ИдентификаторПредшественника = Этап.Значение.ИдентификаторЭтапа Тогда
				НовыйЭтап.Использовать = Истина;
				НовыйЭтап.УсловиеПерехода = Предшественник.Значение.УсловиеПерехода;
				НовыйЭтап.УсловиеРассмотрения = Предшественник.Значение.УсловиеРассмотрения;
				НовыйЭтап.ИмяПредметаУсловия = Предшественник.Значение.ИмяПредметаУсловия;
				Если НЕ ЗначениеЗаполнено(НовыйЭтап.УсловиеРассмотрения) Тогда
					НовыйЭтап.УсловиеРассмотрения = 
						Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения;
					КонецЕсли;
				НовыйЭтап.УсловиеРассмотренияПредставление = Строка(НовыйЭтап.УсловиеРассмотрения);
				Если ТипЗнч(НовыйЭтап.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныУтверждения") Тогда
					Если НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Утверждено'");
					ИначеЕсли НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Не утверждено'");
					ИначеЕсли НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Любой результат'");
					КонецЕсли;
				ИначеЕсли ТипЗнч(НовыйЭтап.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныРегистрации") Тогда
					Если НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Зарегистрировано'");
					ИначеЕсли НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Не зарегистрировано'");
					ИначеЕсли НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Любой результат'");	
					КонецЕсли;
				ИначеЕсли ТипЗнч(НовыйЭтап.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныСогласования") Тогда
					Если НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Согласовано'");
					ИначеЕсли НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоСогласованияБезЗамечаний Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Согласовано без замечаний'");
					ИначеЕсли НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоСогласованияСЗамечаниями Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Согласовано с замечаниями'");
					ИначеЕсли НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Не согласовано'");
					ИначеЕсли НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Любой результат'");
					КонецЕсли;
				ИначеЕсли ТипЗнч(НовыйЭтап.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныПриглашения") Тогда
					Если НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Принято'");
					ИначеЕсли НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Не принято'");
					ИначеЕсли НовыйЭтап.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения Тогда
						НовыйЭтап.УсловиеРассмотренияПредставление = НСтр("ru = 'Любой результат'");
					КонецЕсли;	
				КонецЕсли;
				НовыйЭтап.ОписаниеУсловия = МультипредметностьКлиентСервер.ПолучитьТекстОписанияУсловия(
					НовыйЭтап.ИмяПредметаУсловия, НовыйЭтап.УсловиеПерехода);
			КонецЕсли;
		КонецЦикла;
		НовыйЭтап.ЭтоСогласование = ТипЗнч(НовыйЭтап.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныСогласования");
		НовыйЭтап.ЭтоУтверждение = ТипЗнч(НовыйЭтап.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныУтверждения");
		НовыйЭтап.ЭтоРегистрация = ТипЗнч(НовыйЭтап.ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныРегистрации");
		
	КонецЦикла;
	
	// последним вставляется действие "Старт процесса"
	ЭтапСтарт = Этапы.Добавить();
	ЭтапСтарт.ИдентификаторЭтапа = УникальныйИдентификаторПустой();
	ЭтапСтарт.НомерЭтапа = НСтр("ru = 'Старт процесса'");
	Для Каждого Предшественник Из Параметры.Предшественники Цикл
		Если Предшественник.Значение.ИдентификаторПредшественника = ЭтапСтарт.ИдентификаторЭтапа Тогда
			ЭтапСтарт.Использовать = Истина;
			ЭтапСтарт.УсловиеПерехода = Предшественник.Значение.УсловиеПерехода;
			ЭтапСтарт.УсловиеРассмотрения = Предшественник.Значение.УсловиеРассмотрения;
			ЭтапСтарт.ИмяПредметаУсловия = Предшественник.Значение.ИмяПредметаУсловия;
			ЭтапСтарт.ОписаниеУсловия = МультипредметностьКлиентСервер.ПолучитьТекстОписанияУсловия(
					ЭтапСтарт.ИмяПредметаУсловия, ЭтапСтарт.УсловиеПерехода);
		КонецЕсли;
	КонецЦикла;

	Если ЗначениеЗаполнено(Параметры.ПредшественникиВариантИспользования) Тогда
		ПорядокИспользования = Параметры.ПредшественникиВариантИспользования;
	Иначе
		ПорядокИспользования = "ВсеПредшественники";
		Для Каждого Строка Из Этапы Цикл
			Если Строка.Использовать Тогда
				ПорядокИспользования = "ВсеПредшественники";
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НайденИспользуемыйПредшественник = Ложь;
	Для Каждого Строка Из Этапы Цикл
		Если Строка.Использовать Тогда
			НайденИспользуемыйПредшественник = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если НЕ НайденИспользуемыйПредшественник Тогда
		ПорядокИспользования = "ВсеПредшественники";
	КонецЕсли;
	ПриИзмененииПорядкаИспользования();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектЭтапыИспользоватьПриИзменении(Элемент)
	
	ТекущийЭтап = Элементы.ОбъектЭтапы.ТекущиеДанные;
	УстановитьДоступностьУсловияРассмотрения(ТекущийЭтап.ШаблонБизнесПроцесса, Элементы);
	Если НЕ ТекущийЭтап.Использовать Тогда
		Элементы.УсловиеРассмотрения.ТолькоПросмотр = Истина;
		ТекущийЭтап.УсловиеРассмотрения = Неопределено;
		ТекущийЭтап.УсловиеПерехода = Неопределено;
		ТекущийЭтап.ИмяПредметаУсловия = Неопределено;
		ТекущийЭтап.ОписаниеУсловия = "";
	Иначе
		Если ТекущийЭтап.ИдентификаторЭтапа <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
			ТекущийЭтап.УсловиеРассмотрения = 
				ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения");
		КонецЕсли;
		ТекущийЭтап.ОписаниеУсловия = МультипредметностьКлиентСервер.ПолучитьТекстОписанияУсловия(
			ТекущийЭтап.ИмяПредметаУсловия, ТекущийЭтап.УсловиеПерехода);
	КонецЕсли;
	Элементы.УсловиеРассмотрения.ТолькоПросмотр = Ложь;
	УстановитьДоступностьУсловияРассмотрения(ТекущийЭтап.ШаблонБизнесПроцесса, Элементы);
	Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотренияПредставление = 
		Строка(Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотрения);
	Для Каждого ЭлементСпискаВыбора Из Элементы.УсловиеРассмотрения.СписокВыбора Цикл
		Если ЭлементСпискаВыбора.Значение = Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотрения Тогда
			Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотренияПредставление = 
				ЭлементСпискаВыбора.Представление;
		КонецЕсли;
	КонецЦикла;
	Элементы.ОбъектЭтапы.ЗакончитьРедактированиеСтроки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектЭтапыПриАктивизацииСтроки(Элемент)
	
	ТекущийЭтап = Элементы.ОбъектЭтапы.ТекущиеДанные;
	Если ТекущийЭтап = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущийЭтап.Использовать Тогда
		Элементы.УсловиеРассмотрения.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.УсловиеРассмотрения.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	УстановитьДоступностьУсловияРассмотрения(Элементы.ОбъектЭтапы.ТекущиеДанные.ШаблонБизнесПроцесса, Элементы);
	
	Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотренияПредставление = 
		Строка(Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотрения);
	Для Каждого ЭлементСпискаВыбора Из Элементы.УсловиеРассмотрения.СписокВыбора Цикл
		Если ЭлементСпискаВыбора.Значение = Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотрения Тогда
			Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотренияПредставление = 
				ЭлементСпискаВыбора.Представление;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектЭтапыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Этапы.Получить(ВыбраннаяСтрока).Использовать Тогда
		мИменаПредметов = ИменаПредметов.ВыгрузитьЗначения();
		МультипредметностьКлиент.УстановкаУсловияМаршрутизации(мИменаПредметов, Элемент, Поле, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьУсловияРассмотрения(ШаблонБизнесПроцесса, Элементы) Экспорт
	
	Элементы.УсловиеРассмотрения.СписокВыбора.Очистить();
	Элементы.УсловиеРассмотрения.ТолькоПросмотр = Ложь;
	
	Если ТипЗнч(ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныИсполнения")
		ИЛИ ТипЗнч(ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныОзнакомления")
		ИЛИ ТипЗнч(ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныПоручения")
		ИЛИ ТипЗнч(ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныРассмотрения")
		ИЛИ ТипЗнч(ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныСоставныхБизнесПроцессов")
		ИЛИ ТипЗнч(ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов")
		Или ШаблонБизнесПроцесса = Неопределено Тогда
		
		Элементы.УсловиеРассмотрения.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	Если ТипЗнч(ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныУтверждения") Тогда
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения"),
			НСтр("ru = 'Утверждено'"));
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения"),
			НСтр("ru = 'Не утверждено'"));
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения"),
			НСтр("ru = 'Любой результат'"));
	ИначеЕсли ТипЗнч(ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныРегистрации") Тогда
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения"),
			НСтр("ru = 'Зарегистрировано'"));
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения"),
			НСтр("ru = 'Не зарегистрировано'"));
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения"),
			НСтр("ru = 'Любой результат'"));
	ИначеЕсли ТипЗнч(ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныСогласования") Тогда
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения"),
			НСтр("ru = 'Согласовано'"));
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоСогласованияБезЗамечаний"),
			НСтр("ru = 'Согласовано без замечаний'"));
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоСогласованияСЗамечаниями"),
			НСтр("ru = 'Согласовано с замечаниями'"));
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения"),
			НСтр("ru = 'Не согласовано'"));
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения"),
			НСтр("ru = 'Любой результат'"));	
	ИначеЕсли ТипЗнч(ШаблонБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныПриглашения") Тогда
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения"),
			НСтр("ru = 'Принято'"));
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения"),
			НСтр("ru = 'Не принято'"));
		Элементы.УсловиеРассмотрения.СписокВыбора.Добавить(
			ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения"),
			НСтр("ru = 'Любой результат'"));	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УсловиеРассмотренияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотрения = ВыбранноеЗначение;
	Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотренияПредставление = 
		Строка(Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотрения);
	Для Каждого ЭлементСпискаВыбора Из Элементы.УсловиеРассмотрения.СписокВыбора Цикл
		Если ЭлементСпискаВыбора.Значение = Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотрения Тогда
			Элементы.ОбъектЭтапы.ТекущиеДанные.УсловиеРассмотренияПредставление = 
				ЭлементСпискаВыбора.Представление;
		КонецЕсли;
	КонецЦикла;
	Элементы.ОбъектЭтапы.ЗакончитьРедактированиеСтроки(Ложь);
	
КонецПроцедуры



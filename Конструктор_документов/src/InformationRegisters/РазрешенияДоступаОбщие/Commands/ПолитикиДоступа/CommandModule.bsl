
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ЗначениеДоступа", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.РазрешенияДоступаОбщие.Форма.РазрешенияПоЗначениюДоступа", 
		ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

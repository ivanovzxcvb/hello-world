#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказательПроцесса", ПараметрКоманды);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ПоказательПроцесса");
	ПараметрыФормы.Вставить("КлючПользовательскихНастроек", "ПоказательПроцесса");
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.МониторингПроцессов.Форма",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти

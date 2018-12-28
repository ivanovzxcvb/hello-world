
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Схема редактируется в карточке процесса/шаблона.
	ТолькоПросмотр = Истина;
	
	Схема.ИспользоватьСетку = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Схема = ТекущийОбъект.Схема.Получить();
	
	ВладелецСхемы = СхемаКомплексногоПроцесса.ВладелецСхемы;
	
	// Может существовать схема без владельца.
	// Например, в случае создания процесса по шаблону и отказа от его сохранения.
	// При этом схема будет сохранена в момент обработки заполнения процесса.
	Если Не ОбщегоНазначения.СсылкаСуществует(ВладелецСхемы) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСКомплекснымиБизнесПроцессамиСервер.ИнициализироватьКэшДанныхДействий(ЭтаФорма);
	
	КэшДанныхДействий = РаботаСКомплекснымиБизнесПроцессамиСервер.КэшДанныхДействий(
		ТекущийОбъект.ПараметрыДействий);
	
	СрокиИсполненияПроцессовКлиентСерверКОРП.
		ЗаполнитьСрокиВПараметрахДействийСхемыКомплексногоПроцесса(
			СхемаКомплексногоПроцесса.ПараметрыДействий,
			СхемаКомплексногоПроцесса.ЭлементыСхемы,
			КэшДанныхДействий);
	
	КомплексныйПроцесс = Неопределено;
	Если ТипЗнч(ВладелецСхемы) = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов") Тогда
		ВладелецВерхнегоУровня = 
			РаботаСКомплекснымиБизнесПроцессамиСервер.ВладелецВерхнегоУровня(ВладелецСхемы);
		
		Если ЗначениеЗаполнено(ВладелецВерхнегоУровня)
			И ТипЗнч(ВладелецВерхнегоУровня) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
			
			КомплексныйПроцесс = ВладелецВерхнегоУровня;
			
		КонецЕсли;
	Иначе
		КомплексныйПроцесс = ВладелецСхемы;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КомплексныйПроцесс) Тогда
		
		РеквизитыКомплексногоПроцесса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			КомплексныйПроцесс, "Стартован, Шаблон");
		
		Если Не РеквизитыКомплексногоПроцесса.Стартован
			И ЗначениеЗаполнено(РеквизитыКомплексногоПроцесса.Шаблон) Тогда
			
			ПоказатьТочныеСроки = Ложь;
			ПоказатьОтносительныеСроки = Истина;
		Иначе
			ПоказатьТочныеСроки = Истина;
			ПоказатьОтносительныеСроки = Ложь;
		КонецЕсли;
		
	Иначе
		ПоказатьТочныеСроки = Ложь;
		ПоказатьОтносительныеСроки = Истина;
	КонецЕсли;
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	
	РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ОбновитьПредставленияДействийВСхемеПроцесса(
		Схема,
		СхемаКомплексногоПроцесса.ПараметрыДействий,
		СхемаКомплексногоПроцесса.ЭлементыСхемы,
		КэшДанныхДействий,
		ИспользоватьДатуИВремяВСрокахЗадач,
		ПоказатьТочныеСроки,
		ПоказатьОтносительныеСроки);
	
КонецПроцедуры

#КонецОбласти
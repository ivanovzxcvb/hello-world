
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	кпдРазделыДокументов.Ссылка КАК Раздел,
	|	кпдРазделыДокументовВарианты.НазваниеВарианта,
	|	кпдРазделыДокументов.Наименование,
	|	кпдРазделыДокументовВарианты.НомерСтроки
	|ИЗ
	|	Справочник.кпдРазделыДокументов.Варианты КАК кпдРазделыДокументовВарианты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.кпдРазделыДокументов КАК кпдРазделыДокументов
	|		ПО кпдРазделыДокументовВарианты.Ссылка = кпдРазделыДокументов.Ссылка
	|ГДЕ
	|	НЕ кпдРазделыДокументов.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Раздел
	|ИТОГИ ПО
	|	Раздел";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаРаздел = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	НомерРаздела = 1;
	Пока ВыборкаРаздел.Следующий() Цикл
		
		////Добавляем группировку
		//ЭлементГруппировки = ЭтаФорма.Элементы.Добавить("Группировка"+ Строка(НомерРаздела), Тип("ГруппаФормы"), ЭтаФорма);
		
		//Добавляем реквизит
		нРеквизиты = Новый Массив;
		Реквизит = Новый РеквизитФормы(ВыборкаРаздел.Наименование, Новый ОписаниеТипов("Строка"), , "Раздел " + Строка(ВыборкаРаздел.Наименование), Истина);
		нРеквизиты.Добавить(Реквизит);
		ИзменитьРеквизиты(нРеквизиты);
		
		//Добавляем поле ввода
		Элемент = ЭтаФорма.Элементы.Добавить(ВыборкаРаздел.Наименование, Тип("ПолеФормы"), ЭтаФорма);
		Элемент.Вид = ВидПоляФормы.ПолеНадписи;
		Элемент.ПутьКДанным = Строка(ВыборкаРаздел.Наименование);
		
		ВыборкаДетальныеЗаписи = ВыборкаРаздел.Выбрать();
		НомерЭлемента = 1;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если НомерЭлемента = 1 Тогда	
				//Добавляем реквизит
				нРеквизиты = Новый Массив;
				Реквизит = Новый РеквизитФормы(Строка(ВыборкаРаздел.Наименование)+"ВариантРаздела", Новый ОписаниеТипов("Строка"), , "Варианты раздела: ", Истина);
				нРеквизиты.Добавить(Реквизит);
				ИзменитьРеквизиты(нРеквизиты);
				
				//Добавляем поле ввода
				Элемент = ЭтаФорма.Элементы.Добавить(Строка(ВыборкаРаздел.Наименование)+Строка(ВыборкаДетальныеЗаписи.НазваниеВарианта), Тип("ПолеФормы"), ЭтаФорма);
				Элемент.Вид = ВидПоляФормы.ПолеПереключателя;
				Элемент.ПутьКДанным = Строка(ВыборкаРаздел.Наименование)+"ВариантРаздела";
				Элемент.СписокВыбора.добавить(ВыборкаДетальныеЗаписи.НазваниеВарианта,Строка(ВыборкаДетальныеЗаписи.НазваниеВарианта));
			Иначе
				Элемент.СписокВыбора.добавить(ВыборкаДетальныеЗаписи.НазваниеВарианта,Строка(ВыборкаДетальныеЗаписи.НазваниеВарианта));
			КонецЕсли;
			НомерЭлемента = НомерЭлемента + 1;
		КонецЦикла;
		НомерРаздела = НомерРаздела + 1;
		
	КонецЦикла;
	
	//Добавляем команду
	Элемент2 = ЭтаФорма.Элементы.Добавить("Кнопка1", Тип("КнопкаФормы"), ЭтаФорма);
	Элемент2.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
	Элемент2.ИмяКоманды = "Сформировать";
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
		Для Каждого Элемент из Элементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ПолеФормы") И Элемент.Вид = ВидПоляФормы.ПолеНадписи Тогда
			Раздел = Элемент.имя;
			
			Для Каждого Элемент из Элементы Цикл
				Если ТипЗнч(Элемент) = Тип("ПолеФормы") И Элемент.Вид = ВидПоляФормы.ПолеПереключателя Тогда
					РезультатПоиска = СтрНайти(Элемент.имя, Раздел);
					Если РезультатПоиска <> 0 Тогда 
						ИмяРеквизита = Раздел + "ВариантРаздела"; 
						ЗначениеРеквизита = ЭтотОбъект.ЭтаФорма[ИмяРеквизита];
						НовСтрока = ВариантыРазделов.Добавить();
						НовСтрока.Раздел = Раздел;
						НовСтрока.ВариантРаздела = ЗначениеРеквизита;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	

	//ЭтаФорма.Закрыть();	
	
КонецПроцедуры


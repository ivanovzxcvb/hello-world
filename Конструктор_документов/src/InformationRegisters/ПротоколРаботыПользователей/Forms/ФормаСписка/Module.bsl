
&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущийЭлемент = Элементы.ОбъектДанных Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Элемент.ТекущиеДанные.ОбъектДанных);
		
	КонецЕсли;	
	
КонецПроцедуры

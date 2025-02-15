
#Область ОбработчикиСобытийФормы   

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НастройкаСклада") Тогда 
		//@skip-check wrong-string-literal-content
		НастройкаСклада = Параметры["НастройкаСклада"];
		ЗаполнитьТаблицу();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблица

&НаКлиенте
Процедура ТаблицаНоменклатураПриИзменении(Элемент)
	Элементы.Таблица.ТекущиеДанные.СопоставленоВручную = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоШтрихкоду(Команда)
	ПоШтрихкодуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоКоду(Команда)
	ПоКодуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоНаименованию(Команда)
	ПоНаименованиюНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоАртиклу(Команда)
	ПоАртиклуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзменения(Команда)
	ЗаписатьИзмененияНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьИзмененияНаСервере()
	
	// ищем активную настройку склада-получателя
	Активность = Истина;
	ДанныеНастройкиСклада = Справочники.дкл_НастройкиСкладовЛифтов.ДанныеНастройкиСклада(НастройкаСклада, Активность);
	
	Если НЕ ЗначениеЗаполнено(ДанныеНастройкиСклада) Тогда 
		Возврат;		
	КонецЕсли;
	
	Отбор = Новый Структура("СопоставленоВручную", Истина);
	Таб = Таблица.Выгрузить(Отбор);                         
	
	Если Таб.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("Номенклатура", Справочники.Номенклатура.ПустаяСсылка());
	СтрокиКУдалению = Таб.НайтиСтроки(Отбор);
	
	Для каждого Стр Из СтрокиКУдалению Цикл 
		Таб.Удалить(Стр); 
	КонецЦикла; 
	
	Для каждого Стр Из Таб Цикл

		МенеджерЗаписи = РегистрыСведений.дкл_НоменклатураСкладов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Стр);
		МенеджерЗаписи.НастройкаСклада = НастройкаСклада;
		МенеджерЗаписи.Активна = Истина;
		МенеджерЗаписи.Статус = Перечисления.дкл_Статусы.Отправлено;
		МенеджерЗаписи.Записать();
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицу()

	Таблица.Очистить();
	
	Результат = дкл_ОбменДаннымиСервер.ПолучитьСписокНоменклатуры(НастройкаСклада); 

	Для каждого Стр Из Результат.item Цикл

		Нов = Таблица.Добавить();                                                                     
		ЗаполнитьЗначенияСвойств(Нов, Стр);
		//@skip-check query-in-loop
		Нов.Номенклатура = НайтиНоменклатуруВСправочникеИлиВРегистре(Стр);

	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция НайтиНоменклатуруВСправочникеИлиВРегистре(Стр)

	Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(
			Новый УникальныйИдентификатор(Стр.itemId));		

	Если Лев(Строка(Номенклатура), 17) = "<Объект не найден" Тогда 
		Номенклатура = Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	дкл_НоменклатураСкладов.Номенклатура КАК Номенклатура
		|ИЗ
		|	РегистрСведений.дкл_НоменклатураСкладов КАК дкл_НоменклатураСкладов
		|ГДЕ
		|	дкл_НоменклатураСкладов.СопоставленоВручную
		|	И дкл_НоменклатураСкладов.itemId = &itemId
		|	И дкл_НоменклатураСкладов.НастройкаСклада = &НастройкаСклада";
		
		Запрос.УстановитьПараметр("itemId", Стр.itemId);
		Запрос.УстановитьПараметр("НастройкаСклада", НастройкаСклада);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		
	КонецЕсли;    
	
	Возврат Номенклатура;
	
КонецФункции // ()

&НаСервере
Процедура ПоАртиклуНаСервере()

	Запрос = Новый Запрос;                                      
	Запрос.УстановитьПараметр("Таб", Таблица.Выгрузить(,"vendorNumber"));
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК СопоставленоВручную,
		|	Номенклатура.Ссылка КАК Номенклатура,
		|	Номенклатура.Артикул КАК vendorNumber
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Артикул В(&Таб)
		|	И НЕ Номенклатура.Артикул = """"
		|	И НЕ Номенклатура.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();

	Отбор = Новый Структура("vendorNumber");
	
	Для каждого Стр Из Таблица Цикл        
		
		Если ЗначениеЗаполнено(Стр.Номенклатура) Тогда
			Продолжить;                    
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Отбор, Стр);
		Выборка.Сбросить();
		Если Выборка.НайтиСледующий(Отбор) Тогда
			ЗаполнитьЗначенияСвойств(Стр, Выборка);
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПоКодуНаСервере()

	Запрос = Новый Запрос;                                      
	Запрос.УстановитьПараметр("Таб", Таблица.Выгрузить(,"extraCode"));
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК СопоставленоВручную,
		|	Номенклатура.Ссылка КАК Номенклатура,
		|	Номенклатура.Код КАК extraCode
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Код В(&Таб)
		|	И НЕ Номенклатура.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();

	Отбор = Новый Структура("extraCode");
	
	Для каждого Стр Из Таблица Цикл        
		
		Если ЗначениеЗаполнено(Стр.Номенклатура) Тогда
			Продолжить;                    
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Отбор, Стр);
		Выборка.Сбросить();
		Если Выборка.НайтиСледующий(Отбор) Тогда
			ЗаполнитьЗначенияСвойств(Стр, Выборка);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПоНаименованиюНаСервере()

	Запрос = Новый Запрос;                                      
	Запрос.УстановитьПараметр("Таб", Таблица.Выгрузить(,"itemName"));
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК СопоставленоВручную,
		|	Номенклатура.Ссылка КАК Номенклатура,
		|	Номенклатура.Наименование КАК itemName
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Наименование В(&Таб)
		|	И НЕ Номенклатура.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();

	Отбор = Новый Структура("itemName");
	
	Для каждого Стр Из Таблица Цикл        
		
		Если ЗначениеЗаполнено(Стр.Номенклатура) Тогда
			Продолжить;                    
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Отбор, Стр);
		Выборка.Сбросить();
		Если Выборка.НайтиСледующий(Отбор) Тогда
			ЗаполнитьЗначенияСвойств(Стр, Выборка);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПоШтрихкодуНаСервере()
	
	Запрос = Новый Запрос;                                      
	Запрос.УстановитьПараметр("Таб", Таблица.Выгрузить(,"barcode"));
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК СопоставленоВручную,
		|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура,
		|	ШтрихкодыНоменклатуры.Штрихкод КАК barcode
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|ГДЕ
		|	ШтрихкодыНоменклатуры.Штрихкод В(&Таб)
		|	И НЕ ШтрихкодыНоменклатуры.Штрихкод = """"
		|	И НЕ ШтрихкодыНоменклатуры.Номенклатура.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();

	Отбор = Новый Структура("barcode");
	
	Для каждого Стр Из Таблица Цикл        
		
		Если ЗначениеЗаполнено(Стр.Номенклатура) Тогда
			Продолжить;                    
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Отбор, Стр);
		Выборка.Сбросить();
		Если Выборка.НайтиСледующий(Отбор) Тогда
			ЗаполнитьЗначенияСвойств(Стр, Выборка);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#ПЕРЕХОД К ОБРАБОТКЕ ПРЕРЫВАНИЙ
ORG	000	
RET:	WORD ?	#АДРЕС ВОЗВРАТ
	NOP	#ОТЛАДКА ПРЕРЫВАНИЯ
	BR INT	#ПЕРЕХОД К ПОДПРОГРАММЕ ПРЕРЫВАНИЙ
#ДАННЫЕ
ORG	03D	
X:	WORD ?	
SAVED_A:	WORD ?	
LEFT:	WORD FFD6	#ЛЕВАЯ ГРАНИЦА ОДЗ = -42
RIGHT:	WORD 002B	#ПРАВАЯ ГРАНИЦА ОДЗ = 43
#ОСНОВНАЯ ПРОГРАММА
ORG	020	
BEGIN:	EI	
LOOP:	CLA	
	ADD X	
	INC	
	JSR CHECK_X	
	BR LOOP	
#ПРОВЕРКА ОДЗ X
CHECK_X:	WORD ?	
	NOP	#ОТЛАДКА ОДЗ 
	SUB RIGHT	#ЕСЛИ AККУМУЛЯТОР - 43 > 0, ЗНАЧИТ X ВЫШЛО ЗА ОДЗ ПРИ ВЫПОЛНЕНИИ ОПЕРАЦИИ ПО ЕГО ИЗМЕНЕНИЮ, И НЕОБХОДИМО ЗАПИСАТЬ В X МИНИМАЛЬНОЕ ЗНАЧЕНИЕ
	BPL MOV_LEFT	
	ADD RIGHT	
	MOV X	
	BR (CHECK_X)	
MOV_LEFT:	CLA	
	ADD LEFT	
	MOV X	
	BR (CHECK_X)	
#ОБРАБОТКА ПРЕРЫВАНИЙ
INT:	MOV SAVED_A	#ОПРОС ФЛАГОВ ГОТОВНОСТИ ВУ
	TSF 1	
	BR CHECK2	
	BR READY1	
CHECK2:	TSF 2	
	BR READY3	
	BR READY2	
READY1:	CLA	#ВЫВОД F(X)=-3X+1 на ВУ1
	SUB X	
	SUB X	
	SUB X	
	INC	
	OUT 1	
	NOP	#ОТЛАДКА ВУ1
	CLF 1	
	BR RESTORE	#ПОБИТОВОЕ «И» С РД1 И X
READY2:	CLA	
	IN 2	
	CLF 2	
	AND X	
	NOP	#ОТЛАДКА ВУ2
	MOV X	
	BR RESTORE	
READY3:	CLF 3	
RESTORE:	CLA	#ВОЗВРАТ ИЗ ПРОГРАММЫ ОБРАБОТКИ ПРЕРЫВАНИЙ
	ADD SAVED_A	
	EI	
	BR (RET)	

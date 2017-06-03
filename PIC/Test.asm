
_StartSignal:

;Test.c,19 :: 		void StartSignal() {
;Test.c,20 :: 		TRISD.F2 = 0; //Configure RD2 as output
	BCF        TRISD+0, 2
;Test.c,21 :: 		PORTD.F2 = 0; //RD2 sends 0 to the sensor
	BCF        PORTD+0, 2
;Test.c,22 :: 		delay_ms(18);
	MOVLW      71
	MOVWF      R12+0
	MOVLW      31
	MOVWF      R13+0
L_StartSignal0:
	DECFSZ     R13+0, 1
	GOTO       L_StartSignal0
	DECFSZ     R12+0, 1
	GOTO       L_StartSignal0
	NOP
	NOP
;Test.c,23 :: 		PORTD.F2 = 1; //RD2 sends 1 to the sensor
	BSF        PORTD+0, 2
;Test.c,24 :: 		delay_us(30);
	MOVLW      29
	MOVWF      R13+0
L_StartSignal1:
	DECFSZ     R13+0, 1
	GOTO       L_StartSignal1
	NOP
	NOP
;Test.c,25 :: 		TRISD.F2 = 1; //Configure RD2 as input
	BSF        TRISD+0, 2
;Test.c,26 :: 		}
L_end_StartSignal:
	RETURN
; end of _StartSignal

_CheckResponse:

;Test.c,27 :: 		void CheckResponse() {
;Test.c,28 :: 		a = 0;
	CLRF       _a+0
;Test.c,29 :: 		delay_us(40);
	MOVLW      39
	MOVWF      R13+0
L_CheckResponse2:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse2
	NOP
	NOP
;Test.c,30 :: 		if (PORTD.F2 == 0) {
	BTFSC      PORTD+0, 2
	GOTO       L_CheckResponse3
;Test.c,31 :: 		delay_us(80);
	MOVLW      79
	MOVWF      R13+0
L_CheckResponse4:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse4
	NOP
	NOP
;Test.c,32 :: 		if (PORTD.F2 == 1) a = 1;
	BTFSS      PORTD+0, 2
	GOTO       L_CheckResponse5
	MOVLW      1
	MOVWF      _a+0
L_CheckResponse5:
;Test.c,33 :: 		delay_us(40);
	MOVLW      39
	MOVWF      R13+0
L_CheckResponse6:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse6
	NOP
	NOP
;Test.c,34 :: 		}
L_CheckResponse3:
;Test.c,35 :: 		}
L_end_CheckResponse:
	RETURN
; end of _CheckResponse

_ReadData:

;Test.c,36 :: 		void ReadData() {
;Test.c,37 :: 		for (b = 0; b < 8; b++) {
	CLRF       _b+0
L_ReadData7:
	MOVLW      8
	SUBWF      _b+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_ReadData8
;Test.c,38 :: 		while (!PORTD.F2); //Wait until PORTD.F2 goes HIGH
L_ReadData10:
	BTFSC      PORTD+0, 2
	GOTO       L_ReadData11
	GOTO       L_ReadData10
L_ReadData11:
;Test.c,39 :: 		delay_us(30);
	MOVLW      29
	MOVWF      R13+0
L_ReadData12:
	DECFSZ     R13+0, 1
	GOTO       L_ReadData12
	NOP
	NOP
;Test.c,40 :: 		if (PORTD.F2 == 0) i &= ~(1 << (7 - b)); //Clear bit (7-b)
	BTFSC      PORTD+0, 2
	GOTO       L_ReadData13
	MOVF       _b+0, 0
	SUBLW      7
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      R1+0
	MOVLW      1
	MOVWF      R0+0
	MOVF       R1+0, 0
L__ReadData28:
	BTFSC      STATUS+0, 2
	GOTO       L__ReadData29
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__ReadData28
L__ReadData29:
	COMF       R0+0, 1
	MOVF       R0+0, 0
	ANDWF      _i+0, 1
	GOTO       L_ReadData14
L_ReadData13:
;Test.c,42 :: 		i |= (1 << (7 - b)); //Set bit (7-b)
	MOVF       _b+0, 0
	SUBLW      7
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      R1+0
	MOVLW      1
	MOVWF      R0+0
	MOVF       R1+0, 0
L__ReadData30:
	BTFSC      STATUS+0, 2
	GOTO       L__ReadData31
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__ReadData30
L__ReadData31:
	MOVF       R0+0, 0
	IORWF      _i+0, 1
;Test.c,43 :: 		while (PORTD.F2);
L_ReadData15:
	BTFSS      PORTD+0, 2
	GOTO       L_ReadData16
	GOTO       L_ReadData15
L_ReadData16:
;Test.c,44 :: 		} //Wait until PORTD.F2 goes LOW
L_ReadData14:
;Test.c,37 :: 		for (b = 0; b < 8; b++) {
	INCF       _b+0, 1
;Test.c,45 :: 		}
	GOTO       L_ReadData7
L_ReadData8:
;Test.c,46 :: 		}
L_end_ReadData:
	RETURN
; end of _ReadData

_main:

;Test.c,47 :: 		void main() {
;Test.c,49 :: 		TRISB = 0; //Configure PORTB as output
	CLRF       TRISB+0
;Test.c,50 :: 		PORTB = 0; //Initial value of PORTB
	CLRF       PORTB+0
;Test.c,51 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Test.c,52 :: 		UART1_Init(9600); // Initialize UART module at 9600bps
	MOVLW      77
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Test.c,53 :: 		Delay_ms(100); // Wait for UART module to stabilize
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_main17:
	DECFSZ     R13+0, 1
	GOTO       L_main17
	DECFSZ     R12+0, 1
	GOTO       L_main17
	DECFSZ     R11+0, 1
	GOTO       L_main17
;Test.c,55 :: 		while (1) {
L_main18:
;Test.c,56 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Test.c,57 :: 		Lcd_Cmd(_LCD_CLEAR); // clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Test.c,58 :: 		StartSignal();
	CALL       _StartSignal+0
;Test.c,59 :: 		CheckResponse();
	CALL       _CheckResponse+0
;Test.c,60 :: 		if (a == 1) {
	MOVF       _a+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main20
;Test.c,61 :: 		ReadData();
	CALL       _ReadData+0
;Test.c,62 :: 		rh1 = i;
	MOVF       _i+0, 0
	MOVWF      _rh1+0
;Test.c,63 :: 		ReadData();
	CALL       _ReadData+0
;Test.c,64 :: 		rh2 = i;
	MOVF       _i+0, 0
	MOVWF      _rh2+0
;Test.c,65 :: 		ReadData();
	CALL       _ReadData+0
;Test.c,66 :: 		t1 = i;
	MOVF       _i+0, 0
	MOVWF      _t1+0
;Test.c,67 :: 		ReadData();
	CALL       _ReadData+0
;Test.c,68 :: 		t2 = i;
	MOVF       _i+0, 0
	MOVWF      _t2+0
;Test.c,69 :: 		ReadData();
	CALL       _ReadData+0
;Test.c,70 :: 		sum = i;
	MOVF       _i+0, 0
	MOVWF      _sum+0
;Test.c,71 :: 		if (sum == rh1 + rh2 + t1 + t2) {
	MOVF       _rh2+0, 0
	ADDWF      _rh1+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       _t1+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       _t2+0, 0
	ADDWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R2+1
	MOVLW      0
	XORWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main33
	MOVF       R2+0, 0
	XORWF      _i+0, 0
L__main33:
	BTFSS      STATUS+0, 2
	GOTO       L_main21
;Test.c,72 :: 		text = "Temp:  .0C";
	MOVLW      ?lstr1_Test+0
	MOVWF      _text+0
;Test.c,73 :: 		Lcd_Out(1, 6, text);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Test.c,74 :: 		text = "Humidity:  .0%";
	MOVLW      ?lstr2_Test+0
	MOVWF      _text+0
;Test.c,75 :: 		Lcd_Out(2, 2, text);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Test.c,76 :: 		ByteToStr(t1, mytext);
	MOVF       _t1+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _mytext+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Test.c,77 :: 		UART1_Write(t1);
	MOVF       _t1+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Test.c,78 :: 		Lcd_Out(1, 11, Ltrim(mytext));
	MOVLW      _mytext+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;Test.c,79 :: 		ByteToStr(rh1, mytext);
	MOVF       _rh1+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _mytext+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Test.c,80 :: 		Lcd_Out(2, 11, Ltrim(mytext));
	MOVLW      _mytext+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;Test.c,81 :: 		} else {
	GOTO       L_main22
L_main21:
;Test.c,82 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Test.c,83 :: 		Lcd_Cmd(_LCD_CLEAR); // clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Test.c,84 :: 		text = "Check sum error";
	MOVLW      ?lstr3_Test+0
	MOVWF      _text+0
;Test.c,85 :: 		Lcd_Out(1, 1, text);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Test.c,86 :: 		UART1_Write(0);
	CLRF       FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Test.c,87 :: 		}
L_main22:
;Test.c,88 :: 		} else {
	GOTO       L_main23
L_main20:
;Test.c,89 :: 		text = "No response";
	MOVLW      ?lstr4_Test+0
	MOVWF      _text+0
;Test.c,90 :: 		Lcd_Out(1, 3, text);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Test.c,91 :: 		text = "from the sensor";
	MOVLW      ?lstr5_Test+0
	MOVWF      _text+0
;Test.c,92 :: 		Lcd_Out(2, 1, text);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _text+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Test.c,93 :: 		UART1_Write(0);
	CLRF       FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Test.c,94 :: 		}
L_main23:
;Test.c,95 :: 		delay_ms(500);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_main24:
	DECFSZ     R13+0, 1
	GOTO       L_main24
	DECFSZ     R12+0, 1
	GOTO       L_main24
	DECFSZ     R11+0, 1
	GOTO       L_main24
	NOP
	NOP
;Test.c,96 :: 		}
	GOTO       L_main18
;Test.c,97 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

#line 1 "Z:/home/rashad/NewFolder/Test.c"

sbit LCD_RS at RC2_bit;
sbit LCD_EN at RC3_bit;
sbit LCD_D4 at RB3_bit;
sbit LCD_D5 at RB2_bit;
sbit LCD_D6 at RB1_bit;
sbit LCD_D7 at RB0_bit;
sbit LCD_RS_Direction at TRISC2_bit;
sbit LCD_EN_Direction at TRISC3_bit;
sbit LCD_D4_Direction at TRISC4_bit;
sbit LCD_D5_Direction at TRISC5_bit;
sbit LCD_D6_Direction at TRISC6_bit;
sbit LCD_D7_Direction at TRISC7_bit;


char * text, mytext[4];
unsigned char a = 0, b = 0, i = 0, t1 = 0, t2 = 0, rh1 = 0, rh2 = 0, sum = 0;

void StartSignal() {
 TRISD.F2 = 0;
 PORTD.F2 = 0;
 delay_ms(18);
 PORTD.F2 = 1;
 delay_us(30);
 TRISD.F2 = 1;
}
void CheckResponse() {
 a = 0;
 delay_us(40);
 if (PORTD.F2 == 0) {
 delay_us(80);
 if (PORTD.F2 == 1) a = 1;
 delay_us(40);
 }
}
void ReadData() {
 for (b = 0; b < 8; b++) {
 while (!PORTD.F2);
 delay_us(30);
 if (PORTD.F2 == 0) i &= ~(1 << (7 - b));
 else {
 i |= (1 << (7 - b));
 while (PORTD.F2);
 }
 }
}
void main() {

 TRISB = 0;
 PORTB = 0;
 Lcd_Init();
 UART1_Init(9600);
 Delay_ms(100);

 while (1) {
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 StartSignal();
 CheckResponse();
 if (a == 1) {
 ReadData();
 rh1 = i;
 ReadData();
 rh2 = i;
 ReadData();
 t1 = i;
 ReadData();
 t2 = i;
 ReadData();
 sum = i;
 if (sum == rh1 + rh2 + t1 + t2) {
 text = "Temp:  .0C";
 Lcd_Out(1, 6, text);
 text = "Humidity:  .0%";
 Lcd_Out(2, 2, text);
 ByteToStr(t1, mytext);
 UART1_Write(t1);
 Lcd_Out(1, 11, Ltrim(mytext));
 ByteToStr(rh1, mytext);
 UART1_Write(rh1);
 Lcd_Out(2, 11, Ltrim(mytext));
 } else {
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
 text = "Check sum error";
 Lcd_Out(1, 1, text);
 UART1_Write(0);
 }
 } else {
 text = "No response";
 Lcd_Out(1, 3, text);
 text = "from the sensor";
 Lcd_Out(2, 1, text);
 UART1_Write(0);
 }
 delay_ms(2000);
 }
}

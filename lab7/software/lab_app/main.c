// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
//	volatile unsigned int sum;
	volatile unsigned int *LED_PIO = (unsigned int*)0x70; //make a pointer to access the PIO block
//	volatile unsigned int *SW_PIO = (unsigned int*)0x40;
//	volatile unsigned int *KEY2 = (unsigned int*)0x60; //Reset
//	volatile unsigned int *KEY3 = (unsigned int*)0x50; //Accumulate
	*LED_PIO = 0x00; //clear all LEDs
//	sum = 0;
	while ( 1 ) //infinite loop
	{
		//for (i = 0; i < 100000; i++); //software delay
//		if(*KEY2 == 0){
//			//*LED_PIO = 0;
//			*LED_PIO = 0; //set LSB
//			//for (i = 0; i < 100000; i++); //software delay
//			sum = 0;
//		}
//		if (*KEY3 == 0){
//			sum += *SW_PIO;
//			if(sum > 255)
//				sum -= 256;
//			for (i = 0; i < 100000; i++); //software delay
//			*LED_PIO = sum;
//		}
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here
}

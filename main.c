/*
 * blink LED
 */

#include <avr/io.h>
#include <avr/interrupt.h>

unsigned char phase;

ISR(TIMER0_OVF_vect)
{
    phase <<= 1;
    if (phase == 0)
        phase = 1;
    PORTB = phase;
}

int
main()
{
    phase = 1;
    ACSR = _BV(ACD); /* powerdown the analog comparator */

    /*
     * setup port B
     */
    PORTB = 0x55;
    DDRB = 0xFF; /* all output */

    /*
     * setup port D (parking)
     */
    PORTD = 0xFF; /* enable internal pullup */
    DDRD = 0x00; /* all input */

    /*
     * setup timer0
     */
    TCNT0 = 0; /* rewind the counter */
    TIFR  = _BV(TOV0); /* clear timer0 overflow flag */
    TIMSK = _BV(TOIE0); /* enable timer0 overflow interrupt */
    TCCR0A = _BV(CS02)|_BV(CS00); /* timer0 start running */

    sei(); /* set global interrupt enable */
    for (;;)
        __asm__("nop");

    return 0; /* shut up the compiler. */
}

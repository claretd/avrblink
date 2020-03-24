NAME?=blink
MCU?=attiny2313
PROG=${NAME}-${MCU}
CFLAGS=-Os -mmcu=${MCU} -Wall

SRCS=main.c
OBJS=${SRCS:%.c=%.o}

# for Fedora 31 with avr-gcc package
TOOLDIR=/usr

CC=${TOOLDIR}/bin/avr-gcc
OBJDUMP=${TOOLDIR}/bin/avr-objdump
OBJCOPY=${TOOLDIR}/bin/avr-objcopy

.SUFFIXES: .c .o .S .s

.c.o:
	${CC} ${CFLAGS} -c -o $@ $<

.S.o:
	${CC} ${CFLAGS} -c -o $@ $<

.s.o:
	${CC} ${CFLAGS} -c -o $@ $<

all: ${PROG}.elf ${PROG}.hex

${PROG}.elf: ${OBJS}
	${CC} ${CFLAGS} -o $@ ${OBJS}
	${OBJDUMP} -d $@ > ${PROG}.dump

${PROG}.hex: ${PROG}.elf
	${OBJCOPY} -I elf32-avr -O ihex ${PROG}.elf ${PROG}.hex

clean:
	rm -f *.s *.o *.dump *.hex *.elf

edit:
	avrdude -P usb -c avrisp2 -p ${MCU} -t

write:
	avrdude -P usb -c avrisp2 -p ${MCU} -U flash:w:${PROG}.hex


BINPATH=/opt/toolchains/eabi/arm-2014.05/bin/

CC=$(BINPATH)/arm-none-eabi-gcc
AR=$(BINPATH)/arm-none-eabi-ar

FLOAT_TYPE=soft
###################################################
# Check for valid float argument
ifneq ($(FLOAT_TYPE), hard)
ifneq ($(FLOAT_TYPE), soft)
override FLOAT_TYPE = hard
#override FLOAT_TYPE = soft
endif
endif

###################################################

vpath %.c src

CFLAGS  = -g -O2 -Wall
CFLAGS += -mlittle-endian -mthumb -mthumb-interwork -mcpu=cortex-m4

ifeq ($(FLOAT_TYPE), hard)
CFLAGS += -fsingle-precision-constant -Wdouble-promotion
CFLAGS += -mfpu=fpv4-sp-d16 -mfloat-abi=hard
else
CFLAGS += -msoft-float
endif

CFLAGS += -ffreestanding -nostdlib

# Includes
CFLAGS += -I../Core/cmsis -I../Core/stm32
CFLAGS += -Iinc -I../Conf -I../USB_Host/Class/MSC/inc

LIBPATHS = -L../USB_Host/Class/MSC/


LIBS = -lusbhostmsc 

# Sources
SRCS = ff.c fattime.c

OBJS = $(SRCS:.c=.o)
LIBNAME = libfatfs.a

all: $(LIBNAME)

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $^ $(LIBPATHS) $(LIBS)

$(LIBNAME): $(OBJS)
	$(AR) -r $@ $(OBJS)

clean:
	rm -f $(OBJS) $(LIBNAME)
	

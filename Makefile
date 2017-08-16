# Sources

SRCS = main.c waverecorder.c stm32f4xx_it.c stm32f4_discovery_audio_codec.c stm32f4_discovery.c stm32f4_discovery_lis302dl.c system_stm32f4xx.c waveplayer.c
#SRCS = main.c audio_sample.c stm32f4xx_it.c stm32f4_discovery_audio_codec.c stm32f4_discovery.c stm32f4_discovery_lis302dl.c system_stm32f4xx.c waveplayer.c
# USB
SRCS += usb_bsp.c usbh_usr.c

# Project name

PROJ_NAME=stm32f4_playback
OUTPATH=build
FLOAT_TYPE=soft
###################################################

# Check for valid float argument
# NOTE that you have to run make clan after
# changing these as hardfloat and softfloat are not
# binary compatible
ifneq ($(FLOAT_TYPE), hard)
ifneq ($(FLOAT_TYPE), soft)
override FLOAT_TYPE = hard
#override FLOAT_TYPE = soft
endif
endif

###################################################

BINPATH=/opt/toolchains/eabi/arm-2014.05/bin/
CC=$(BINPATH)/arm-none-eabi-gcc
OBJCOPY=$(BINPATH)/arm-none-eabi-objcopy
SIZE=$(BINPATH)/arm-none-eabi-size

CFLAGS  = -std=gnu99 -g -O2 -Wall -Tstm32_flash.ld
CFLAGS += -mlittle-endian -mthumb -mthumb-interwork -mcpu=cortex-m4

ifeq ($(FLOAT_TYPE), hard)
CFLAGS += -fsingle-precision-constant -Wdouble-promotion
CFLAGS += -mfpu=fpv4-sp-d16 -mfloat-abi=hard
else
CFLAGS += -msoft-float
endif

###################################################

vpath %.c src
vpath %.a lib

ROOT=$(shell pwd)

# Includes
CFLAGS += -Iinc -Ilib/Core/cmsis -Ilib/Core/stm32
CFLAGS += -Ilib/Conf

# Library paths
LIBPATHS = -Llib/StdPeriph -Llib/USB_Host/Core -Llib/USB_Host/Class/MSC/
LIBPATHS += -Llib/USB_OTG

# Libraries to link
LIBS = -lm -lstdperiph -lusbhostcore -lusbhostmsc -lusbcore -lPDMFilter_GCC

# Extra includes
CFLAGS += -Ilib/StdPeriph/inc
CFLAGS += -Ilib/USB_OTG/inc
CFLAGS += -Ilib/USB_Host/Core/inc
CFLAGS += -Ilib/USB_Host/Class/MSC/inc
CFLAGS += -Ilib/fat_fs/inc
#CFLAGS += -Ilib/USB_Device/Class/cdc/inc

# add startup file to build
SRCS += lib/startup_stm32f4xx.s

OBJS = $(SRCS:.c=.o)

###################################################

.PHONY: lib proj

all: lib proj
	$(SIZE) $(OUTPATH)/$(PROJ_NAME).elf

lib:
	$(MAKE) -C lib FLOAT_TYPE=$(FLOAT_TYPE)

proj: 	$(OUTPATH)/$(PROJ_NAME).elf

$(OUTPATH)/$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@ $(LIBPATHS) $(LIBS)
	$(OBJCOPY) -O ihex $(OUTPATH)/$(PROJ_NAME).elf $(OUTPATH)/$(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(OUTPATH)/$(PROJ_NAME).elf $(OUTPATH)/$(PROJ_NAME).bin

clean:
	rm -f *.o
	rm -f $(OUTPATH)/$(PROJ_NAME).elf
	rm -f $(OUTPATH)/$(PROJ_NAME).hex
	rm -f $(OUTPATH)/$(PROJ_NAME).bin

	$(MAKE) clean -C lib # Remove this line if you don't want to clean the libs as well

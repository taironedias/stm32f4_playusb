# stm32f4_playusb

#Compilar o código
navegar nas pasta até encontrar o Makefile
$ make clean
$ make

# Abre OpenOCD
$ openocd -s ~/work/tools/openocd/share/openocd/scripts -f board/stm32f4discovery.cfg

# Abre o telnet
$ sudo telnet localhost 4444

# Gravar
> reset halt
> flash erase_sector 0 0 last
> flash write_bank 0 /home/tairone/stm32f4/stm32f4_playusb/build/stm32f4_playback.bin 0
> reset run



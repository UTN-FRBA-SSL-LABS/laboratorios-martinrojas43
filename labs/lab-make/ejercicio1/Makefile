# TODO 1: Definir la variable CC con gcc
CC := gcc

# TODO 2: Definir la variable CFLAGS con -Wall
CFLAGS := -Wall

PROGRAMA := suma

all: $(PROGRAMA)

$(PROGRAMA): suma.c
	# TODO 3: comando de compilación (¡acordate que empiece con TAB!)
	$(CC) $(CFLAGS) suma.c -o $(PROGRAMA)

clean:
	# TODO 4: comando para limpiar el ejecutable
	rm -f $(PROGRAMA)

.PHONY: all clean
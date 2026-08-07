CC     = gcc
CFLAGS = -Wall -Wextra -std=c99

all: calculadora

calculadora: main.o operaciones.o
	$(CC) $(CFLAGS) main.o operaciones.o -o calculadora

main.o: main.c operaciones.h
	$(CC) $(CFLAGS) -c main.c

operaciones.o: operaciones.c operaciones.h
	$(CC) $(CFLAGS) -c operaciones.c

clean:
	rm -f *.o calculadora

test:
	@bash test_local.sh

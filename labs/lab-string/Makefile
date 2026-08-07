CC     = gcc
CFLAGS = -Wall -Wextra -std=c99

# ── Objetos ───────────────────────────────────────────────────────────────────
String.o: String.c String.h
	$(CC) $(CFLAGS) -c String.c -o String.o

Conversion.o: Conversion.c Conversion.h String.h
	$(CC) $(CFLAGS) -c Conversion.c -o Conversion.o

# ── Tests ─────────────────────────────────────────────────────────────────────
StringTest: StringTest.c String.o
	$(CC) $(CFLAGS) StringTest.c String.o -o StringTest

ConversionTest: ConversionTest.c Conversion.o String.o
	$(CC) $(CFLAGS) ConversionTest.c Conversion.o String.o -o ConversionTest

test:
	@bash test_local.sh

# ── Programas ─────────────────────────────────────────────────────────────────
enlineas: enlineas.c
	$(CC) $(CFLAGS) enlineas.c -o enlineas

longitudes: longitudes.c String.o
	$(CC) $(CFLAGS) longitudes.c String.o -o longitudes

mayorlongitud: mayorlongitud.c String.o
	$(CC) $(CFLAGS) mayorlongitud.c String.o -o mayorlongitud

todosiguales: todosiguales.c String.o
	$(CC) $(CFLAGS) todosiguales.c String.o -o todosiguales

suma: suma.c Conversion.o String.o
	$(CC) $(CFLAGS) suma.c Conversion.o String.o -o suma

all: enlineas longitudes mayorlongitud todosiguales suma

# ── Limpieza ──────────────────────────────────────────────────────────────────
clean:
	rm -f *.o StringTest ConversionTest
	rm -f enlineas longitudes mayorlongitud todosiguales suma

.PHONY: test all clean

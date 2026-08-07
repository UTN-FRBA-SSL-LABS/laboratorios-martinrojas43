CC     = gcc
CFLAGS = -Wall -Wextra -std=c99

SRC = src/carrito.c

# ── Compilación del programa principal ────────────────────────────────────────
programa: src/programa.c $(SRC)
	$(CC) $(CFLAGS) $^ -o $@

# ── Compilación de los tests ───────────────────────────────────────────────────
test_unitarios: tests/test_unitarios.c $(SRC)
	$(CC) $(CFLAGS) $^ -o $@

test_integracion: tests/test_integracion.c $(SRC)
	$(CC) $(CFLAGS) $^ -o $@

# ── Correr todos los tests ────────────────────────────────────────────────────
test:
	@bash test_local.sh

# ── Cobertura con gcov ────────────────────────────────────────────────────────
cobertura: src/carrito.c tests/test_unitarios.c
	$(CC) $(CFLAGS) --coverage $^ -o test_cobertura
	./test_cobertura
	gcov src/carrito.c

# ── Limpieza ──────────────────────────────────────────────────────────────────
clean:
	rm -f programa test_unitarios test_integracion test_cobertura
	rm -f *.gcda *.gcno *.gcov src/*.gcda src/*.gcno

.PHONY: test cobertura clean

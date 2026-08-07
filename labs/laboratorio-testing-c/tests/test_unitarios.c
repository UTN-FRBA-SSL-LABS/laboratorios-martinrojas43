#include <stdio.h>
#include "../src/carrito.h"
#include "minunit/minunit.h"

/* ═══════════════════════════════════════════════════════════════════════════
 *  TESTS ESCRITOS — ya funcionan, son el punto de partida
 * ═══════════════════════════════════════════════════════════════════════════ */

void test_carrito_nuevo(void) {
    printf("\n[carrito nuevo]\n");
    Carrito c;
    carrito_init(&c);
    ASSERT_IGUAL(0, carrito_contar(&c));
}

void test_agregar_uno(void) {
    printf("\n[agregar un producto]\n");
    Carrito c;
    carrito_init(&c);
    Producto p = {"Leche", 350, 1};
    ASSERT_IGUAL(1, carrito_agregar(&c, p));   /* devuelve 1 = exito */
    ASSERT_IGUAL(1, carrito_contar(&c));
}

/* ═══════════════════════════════════════════════════════════════════════════
 *  PARTE A — Agregar el siguiente test (ver README.md, Parte 4)
 * ═══════════════════════════════════════════════════════════════════════════ */

/* TODO: pegar aqui la funcion test_total_precio_unitario() */

/* ═══════════════════════════════════════════════════════════════════════════
 *  PARTE B — Completar los blancos (ver README.md, Parte 5)
 * ═══════════════════════════════════════════════════════════════════════════ */

/* TODO: pegar y completar la funcion test_total_con_cantidad() */

/* ═══════════════════════════════════════════════════════════════════════════
 *  PARTE C — Escribir un test propio (ver README.md, Parte 7)
 * ═══════════════════════════════════════════════════════════════════════════ */

/* TODO: escribir test_carrito_lleno() */

/* ═══════════════════════════════════════════════════════════════════════════
 *  main
 * ═══════════════════════════════════════════════════════════════════════════ */

int main(void) {
    printf("=== Tests unitarios ===");
    test_carrito_nuevo();
    test_agregar_uno();
    /* Descomentar a medida que agregues las funciones: */
    /* test_total_precio_unitario(); */
    /* test_total_con_cantidad();    */
    /* test_carrito_lleno();         */
    RESUMEN();
    return EXIT_CODE();
}

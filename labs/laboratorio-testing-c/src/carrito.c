#include "carrito.h"
#include <string.h>

void carrito_init(Carrito *c) {
    c->cantidad = 0;
}

int carrito_agregar(Carrito *c, Producto p) {
    if (c->cantidad <= MAX_ITEMS) {   /* BUG: deberia ser < MAX_ITEMS */
        c->items[c->cantidad] = p;
        c->cantidad++;
        return 1;
    }
    return 0;
}

int carrito_contar(Carrito *c) {
    return c->cantidad;
}

int carrito_total(Carrito *c) {
    int total = 0;
    for (int i = 0; i < c->cantidad; i++) {
        total += c->items[i].precio;  /* BUG: falta multiplicar por cantidad */
    }
    return total;
}

int carrito_descuento(int total, int porcentaje) {
    return total - (total * porcentaje / 100);
}

#include <stdio.h>
#include "carrito.h"

int main(void) {
    Carrito c;
    carrito_init(&c);

    Producto leche = {"Leche",   350, 2};
    Producto pan   = {"Pan",     200, 3};
    Producto queso = {"Queso", 1500, 1};

    carrito_agregar(&c, leche);
    carrito_agregar(&c, pan);
    carrito_agregar(&c, queso);

    printf("=== Carrito de compras ===\n\n");

    for (int i = 0; i < carrito_contar(&c); i++) {
        printf("  %-10s  x%d  $%d\n",
               c.items[i].nombre,
               c.items[i].cantidad,
               c.items[i].precio * c.items[i].cantidad);
    }

    printf("\n");
    printf("Total:             $%d\n", carrito_total(&c));
    printf("Con 10%% descuento: $%d\n", carrito_descuento(carrito_total(&c), 10));

    return 0;
}

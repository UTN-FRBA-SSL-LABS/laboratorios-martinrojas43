#ifndef CARRITO_H
#define CARRITO_H

#define MAX_ITEMS 4

typedef struct {
    char nombre[32];
    int  precio;    /* precio unitario en pesos */
    int  cantidad;
} Producto;

typedef struct {
    Producto items[MAX_ITEMS];
    int      cantidad;  /* cuantos productos hay actualmente */
} Carrito;

/* Inicializa el carrito (cantidad = 0). Llamar siempre antes de usar. */
void carrito_init(Carrito *c);

/* Agrega un producto al carrito. Devuelve 1 si tuvo exito, 0 si el carrito esta lleno. */
int carrito_agregar(Carrito *c, Producto p);

/* Devuelve cuantos productos (tipos) hay en el carrito. */
int carrito_contar(Carrito *c);

/* Devuelve el precio total del carrito (suma de precio * cantidad de cada producto). */
int carrito_total(Carrito *c);

/* Aplica un descuento porcentual al total. Devuelve el precio final.
   porcentaje debe estar entre 0 y 100. */
int carrito_descuento(int total, int porcentaje);

#endif

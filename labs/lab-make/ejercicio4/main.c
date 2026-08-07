#include <stdio.h>
#include "operaciones.h"

int main() {
    int a, b;
    scanf("%d %d", &a, &b);
    printf("Suma: %d\n", sumar(a, b));
    printf("Resta: %d\n", restar(a, b));
    printf("Producto: %d\n", multiplicar(a, b));
    return 0;
}

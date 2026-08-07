#include <stdio.h>
#include "String.h"

/*
 * longitudes — imprime la longitud de cada argumento, una por linea.
 *
 * Uso: ./longitudes hola mundo
 * Salida:
 *   4
 *   5
 */

int main(int argc, char *argv[]) {
    (void)argc;
    for (char **arg = argv + 1; *arg != NULL; arg++)
        printf("%d\n", 0); /* completar: reemplazar 0 con la longitud de *arg */
    return 0;
}

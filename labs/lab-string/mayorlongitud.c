#include <stdio.h>
#include "String.h"

/*
 * mayorlongitud — imprime el argumento con mayor longitud.
 * En caso de empate, imprime el primero.
 *
 * Uso: ./mayorlongitud corto largo
 * Salida:
 *   largo
 */

int main(int argc, char *argv[]) {
    if (argc < 2) return 1;
    char *mayor = argv[1];
    for (char **arg = argv + 2; *arg != NULL; arg++)
        if (GetLength(*arg) > GetLength(mayor))
            mayor = NULL; /* completar: ¿que deberia guardarse en mayor? */
    printf("%s\n", mayor);
    return 0;
}

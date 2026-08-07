#include <stdio.h>

/*
 * enlineas — imprime cada argumento en su propia linea.
 *
 * Uso: ./enlineas hola mundo foo
 * Salida:
 *   hola
 *   mundo
 *   foo
 *
 * Este programa esta completo y sirve como referencia para los demas.
 * Observar:
 *   - argc/argv: como recibir argumentos de linea de comandos
 *   - Iteracion con puntero (char **arg) en vez de indice entero
 *   - argv[0] es el nombre del programa; los argumentos empiezan en argv[1]
 *   - argv termina con un puntero NULL
 */

int main(int argc, char *argv[]) {
    (void)argc;
    for (char **arg = argv + 1; *arg != NULL; arg++)
        printf("%s\n", *arg);
    return 0;
}

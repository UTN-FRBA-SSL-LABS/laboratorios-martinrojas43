/*
 * minunit.h — micro framework de testing para C
 *
 * Uso:
 *   ASSERT_IGUAL(esperado, obtenido)   — compara dos enteros
 *   ASSERT_VERDADERO(condicion)        — verifica que sea distinto de 0
 *   RESUMEN()                          — imprime cuantos tests pasaron
 *
 * El programa devuelve exit code 1 si algún test falló, 0 si todos pasaron.
 * Esto permite que el CI detecte fallas automáticamente.
 */

#ifndef MINUNIT_H
#define MINUNIT_H

#include <stdio.h>

static int mu_tests_run    = 0;
static int mu_tests_ok     = 0;
static int mu_tests_fail   = 0;

#define ASSERT_IGUAL(esperado, obtenido)                                        \
    do {                                                                        \
        mu_tests_run++;                                                         \
        int _esp = (int)(esperado);                                             \
        int _obt = (int)(obtenido);                                             \
        if (_esp == _obt) {                                                     \
            printf("  [OK]   %s == %d\n", #obtenido, _obt);                    \
            mu_tests_ok++;                                                      \
        } else {                                                                \
            printf("  [FAIL] %s => esperado %d, obtenido %d  (linea %d)\n",    \
                   #obtenido, _esp, _obt, __LINE__);                            \
            mu_tests_fail++;                                                    \
        }                                                                       \
    } while (0)

#define ASSERT_VERDADERO(condicion)                                             \
    do {                                                                        \
        mu_tests_run++;                                                         \
        if (condicion) {                                                        \
            printf("  [OK]   %s\n", #condicion);                               \
            mu_tests_ok++;                                                      \
        } else {                                                                \
            printf("  [FAIL] %s es falso  (linea %d)\n", #condicion, __LINE__);\
            mu_tests_fail++;                                                    \
        }                                                                       \
    } while (0)

#define RESUMEN()                                                               \
    do {                                                                        \
        printf("\n--- %d/%d tests OK", mu_tests_ok, mu_tests_run);             \
        if (mu_tests_fail > 0)                                                  \
            printf(", %d FALLARON", mu_tests_fail);                             \
        printf(" ---\n");                                                       \
    } while (0)

#define EXIT_CODE() (mu_tests_fail > 0 ? 1 : 0)

#endif /* MINUNIT_H */

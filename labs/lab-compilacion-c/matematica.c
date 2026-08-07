/*
 * matematica.c
 * Implementación de las funciones declaradas en matematica.h.
 * Este archivo es una unidad de traducción independiente.
 * Durante el enlazado, sus símbolos se combinan con los de programa.c
 */

#include "matematica.h"   /* Incorpora las macros PI y CUADRADO */

/*
 * area_circulo: calcula el área de un círculo dado su radio.
 * Usa la macro PI y la macro función CUADRADO definidas en el encabezado.
 */
double area_circulo(double radio) {
    return PI * CUADRADO(radio);
}

/*
 * factorial: calcula n! de forma recursiva.
 * Caso base: factorial(0) = factorial(1) = 1
 */
int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

/*
 * programa.c  —  Archivo fuente principal
 *
 * Este programa está diseñado para ilustrar TODAS las etapas
 * del proceso de compilación en C:
 *
 *   1. PREPROCESAMIENTO: directivas #include, #define, #ifdef
 *   2. ANÁLISIS LÉXICO / SINTÁCTICO / SEMÁNTICO: código C válido
 *   3. GENERACIÓN DE CÓDIGO: se traduce a ensamblador
 *   4. ENSAMBLADO: produce código objeto (.o)
 *   5. ENLAZADO: se combina con matematica.o y con libc
 *
 * Materia: Sintaxis y Semántica de los Lenguajes — UTN
 */

/* ── Directivas de inclusión ─────────────────────────────────────── */
#include <stdio.h>       /* Biblioteca estándar: printf, scanf, etc.  */
#include <stdlib.h>      /* Biblioteca estándar: EXIT_SUCCESS, etc.   */
#include "matematica.h"  /* Nuestro encabezado local                  */

/* ── Macros de objeto (constantes simbólicas) ────────────────────── */
#define VERSION   "1.0"
#define LIMITE    5

/* ── Compilación condicional ─────────────────────────────────────── */
/* Para activar el modo debug compilar con: gcc -DDEBUG ...          */
#ifdef DEBUG
    #define LOG(msg)  printf("[DEBUG] %s\n", (msg))
#else
    #define LOG(msg)  /* se elimina completamente en modo normal */
#endif

/* ── Variable global ─────────────────────────────────────────────── */
/* Visible en todas las funciones de esta unidad de traducción        */
int llamadas = 0;

/* ── Declaración adelantada (forward declaration) ───────────────── */
void imprimir_separador(void);

/* ─────────────────────────────────────────────────────────────────
 * sumar: devuelve la suma de dos enteros.
 * Ejemplo de función con parámetros y valor de retorno.
 * ───────────────────────────────────────────────────────────────── */
int sumar(int a, int b) {
    llamadas++;          /* modifica variable global */
    return a + b;
}

/* ─────────────────────────────────────────────────────────────────
 * main: punto de entrada del programa.
 * ───────────────────────────────────────────────────────────────── */
int main(void) {
    /* Variables locales */
    int    i;
    int    resultado;
    double radio = 5.0;

    printf("=== Laboratorio de Compilacion en C (v%s) ===\n\n", VERSION);

    LOG("Iniciando main");   /* sólo visible si se compiló con -DDEBUG */

    /* Uso de función propia (misma unidad de traducción) */
    resultado = sumar(3, 4);
    printf("sumar(3, 4)       = %d\n", resultado);

    /* Uso de macro función: CUADRADO se expande en tiempo de preprocesado */
    printf("CUADRADO(%d)      = %d\n", LIMITE, CUADRADO(LIMITE));

    /* Uso de macro MAX (definida en matematica.h) */
    printf("MAX(7, 12)        = %d\n", MAX(7, 12));

    imprimir_separador();

    /* Funciones de matematica.c  →  se resuelven en el ENLAZADO */
    printf("area_circulo(%.1f) = %.4f\n", radio, area_circulo(radio));

    printf("Factoriales:\n");
    for (i = 0; i <= LIMITE; i++) {
        printf("  %d! = %d\n", i, factorial(i));
    }

    imprimir_separador();

    printf("Llamadas a sumar(): %d\n", llamadas);

    return EXIT_SUCCESS;
}

/* ─────────────────────────────────────────────────────────────────
 * imprimir_separador: función auxiliar sin parámetros.
 * ───────────────────────────────────────────────────────────────── */
void imprimir_separador(void) {
    printf("----------------------------------------\n");
}

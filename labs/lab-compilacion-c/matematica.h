/*
 * matematica.h
 * Archivo de encabezado con macros y prototipos de funciones matemáticas.
 * Este archivo es procesado por el preprocesador en cada unidad de traducción.
 */

#ifndef MATEMATICA_H   /* Guarda de inclusión: evita doble inclusión */
#define MATEMATICA_H

/* --- Macros constante --- */
#define PI      3.14159265358979
#define E       2.71828182845904

/* --- Macro función: se expande en el lugar donde se usa --- */
#define CUADRADO(x)   ((x) * (x))
#define MAX(a, b)     ((a) > (b) ? (a) : (b))

/* --- Prototipos (declaraciones) de funciones --- */
double area_circulo(double radio);
int    factorial(int n);

#endif /* MATEMATICA_H */

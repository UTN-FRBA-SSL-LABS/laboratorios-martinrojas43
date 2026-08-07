#ifndef STRING_H
#define STRING_H

/*
 * String.h — Biblioteca para el tipo String
 *
 * Restricciones:
 *   - No usar funciones de <string.h>
 *   - Usar const en los parametros que no se modifican
 *   - Al menos una implementacion debe ser recursiva
 */

/* IsEmpty: String -> Boolean
 * Pre:  s != NULL
 * Post: devuelve 1 si s es la cadena vacia, 0 si no */
int IsEmpty(const char *s);

/* GetLength: String -> Natural
 * Pre:  s != NULL
 * Post: devuelve la cantidad de caracteres de s sin contar el '\0' */
int GetLength(const char *s);

/* AreEqual: String x String -> Boolean
 * Pre:  s1 != NULL, s2 != NULL
 * Post: devuelve 1 si s1 y s2 tienen los mismos caracteres en el mismo orden */
int AreEqual(const char *s1, const char *s2);

/* AreDecimalDigits: String -> Boolean
 * Pre:  s != NULL
 * Post: devuelve 1 si todos los caracteres de s son digitos decimales ('0'..'9'),
 *       y la cadena no es vacia */
int AreDecimalDigits(const char *s);

/* Contains: String x Char -> Boolean
 * Pre:  s != NULL
 * Post: devuelve 1 si el caracter c aparece al menos una vez en s */
int Contains(const char *s, char c);


#endif

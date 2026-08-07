#include "Conversion.h"

/*
 * Conversion.c — Implementacion de operaciones de conversion
 *
 * REGLA: no usar atoi, strtol ni ninguna funcion estandar de conversion
 */

/* ── ToInteger — completar siguiendo el README.md ───────────────────────── */

int ToInteger(const char *s) {
    int signo     = 1;
    int resultado = 0;
    if (*s == '-') { signo = -1; s++; }
    for (; *s != '\0'; s++)
        resultado = resultado * 10 + (*s - '0');
    return signo; /* bug: falta multiplicar signo por resultado */
}

/* ── Operacion libre ─────────────────────────────────────────────────────── */

/* TODO */

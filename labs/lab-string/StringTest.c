#include <assert.h>
#include "String.h"

/*
 * StringTest.c — Pruebas de la biblioteca String
 *
 * Restricciones:
 *   - Usar assert, no printf ni otra salida
 *   - Usar literales de cadena, no variables
 *   - Si todos los assert pasan, el programa termina silenciosamente con exit 0
 *   - Si alguno falla, abort() detiene el programa con exit != 0
 */

int main(void) {

    /* ── IsEmpty — ya implementada ──────────────────────────────────────── */
    assert(IsEmpty("") == 1);
    assert(IsEmpty("a") == 0);
    assert(IsEmpty("hola") == 0);

    /* ── GetLength — descomentar cuando implementes la funcion ──────────── */
    /* assert(GetLength("") == 0); */
    /* assert(GetLength("a") == 1); */
    /* assert(GetLength("hola") == 4); */
    /* assert(GetLength("hola mundo") == 10); */

    /* ── AreEqual — tiene un bug, estos tests ya estan activos ──────────── */
    assert(AreEqual("", "") == 1);
    assert(AreEqual("abc", "abc") == 1);
    assert(AreEqual("abc", "abd") == 0);
    assert(AreEqual("abc", "ab") == 0);
    assert(AreEqual("ab", "abc") == 0);

    /* ── AreDecimalDigits — tiene un bug, estos tests ya estan activos ───── */
    assert(AreDecimalDigits("0") == 1);
    assert(AreDecimalDigits("123") == 1);
    assert(AreDecimalDigits("12a") == 0);
    assert(AreDecimalDigits("") == 0);

    /* ── Contains — descomentar cuando implementes la funcion ───────────── */
    /* assert(Contains("hola", 'o') == 1); */
    /* assert(Contains("hola", 'z') == 0); */
    /* assert(Contains("", 'a') == 0); */

    return 0;
}

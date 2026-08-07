# Laboratorio: Introducción a Flex

## Verificación y calificación

Desde la raíz del repositorio ejecutá:

```bash
make grade LAB=lab-flex
```

Si ya estás dentro de esta carpeta también podés usar `make test`. Ambos
comandos ejecutan los mismos checks y muestran el puntaje sin necesidad de hacer
push. La verificación oficial se ejecuta cuando cambia `labs/lab-flex/`; la nota
queda en el resumen y en los artefactos de GitHub Actions.

No modifiques `.github/`, `scripts/` ni `test_local.sh`: son infraestructura
docente y el workflow restaura automáticamente su versión oficial.

## Objetivo

Familiarizarse con el uso de Flex para construir analizadores léxicos. A lo largo del laboratorio vas a trabajar con los conceptos centrales: `yytext`, la regla comodín, definiciones ERX, `yyleng`, variables globales, funciones de usuario y retorno de tokens.

---

## Prerrequisitos

Tener instalado `flex` y `gcc`:

```bash
sudo apt-get install flex gcc    # Linux/WSL
brew install flex                # macOS
```

---

## ¿Cómo compilar y ejecutar un archivo Flex?

Un archivo `.l` se compila en dos pasos:

```bash
flex scanner.l          # genera lex.yy.c
gcc lex.yy.c -o scanner # compila el ejecutable
```

Para ejecutarlo con un archivo de entrada:

```bash
./scanner < entrada.txt
```

### Verificación local

Antes de hacer push, verificá tu puntaje con:

```bash
make test
```

**Flujo recomendado:** hacé commits frecuentes mientras avanzás, usá `make test` para verificar tu progreso, y dejá el push para cuando una parte esté realmente lista.

### Integración continua

Cuando pusheás cambios dentro de `labs/lab-flex/`, el workflow central del monorepo ejecuta los mismos checks y valida el puntaje mínimo.

> ⚠️ **Evitá pushes innecesarios.** Cada ejecución consume cómputo en servidores de GitHub — un recurso compartido. `make test` te da el mismo resultado en tu terminal sin costo.

Para ver los resultados:

1. Entrá a tu repositorio en GitHub
2. Hacé click en la pestaña **Actions**
3. Hacé click en la ejecución más reciente → job **Grading · lab-flex**
4. Al final del job vas a ver la tabla con el resultado de cada check y el puntaje total

---

## Ejercicio 1 — `yytext` y regla comodín (25 pts)

### Contexto

Flex reconoce patrones y ejecuta acciones. La variable `yytext` contiene el texto exacto que coincidió con la regla (el **lexema**).

Cuando ninguna regla coincide con un carácter, Flex usa su **regla por defecto**: copiar el carácter tal cual a la salida (`ECHO`). Para capturar esos caracteres y mostrar un mensaje propio, se usa la **regla comodín** (`.`).

### Qué hacer

Abrí `ejercicio1/scanner1.l` y completá los cuatro `TODO` agregando las reglas que faltan:

1. Regla para **constante decimal** (ej: `123`, `456`)
2. Regla para **constante hexadecimal** (ej: `0x1A`, `0xFF`)
3. Regla para **identificador** (ej: `miVariable`, `_count`)
4. Regla **comodín** para caracteres no reconocidos

La regla de constante octal ya está implementada como ejemplo.

### Cómo probar

```bash
cd ejercicio1
flex scanner1.l
gcc lex.yy.c -o scanner1
./scanner1 < entrada.txt
```

Salida esperada (puede variar el orden):
```
constante decimal: 123
constante octal: 0777
constante hexadecimal: 0x1A
identificador: miVariable
identificador: _count
caracter no reconocido: @
caracter no reconocido: #
```

---

## Ejercicio 2 — Definiciones ERX y `yyleng` (25 pts)

### Contexto

Las **definiciones ERX** en la sección de definiciones permiten nombrar expresiones regulares para reutilizarlas. En vez de escribir `[0-9]` en cada regla, definís `digito [0-9]` y usás `{digito}` donde lo necesitás.

La variable `yyleng` contiene la **longitud** del lexema actual (equivalente a `strlen(yytext)`).

### Qué hacer

Abrí `ejercicio2/scanner2.l` y completá los cinco `TODO`:

1. Definir `digito` como dígito decimal
2. Definir `letra` como letra o guión bajo
3. Definir `identificador` usando `{letra}` y `{digito}`
4. Regla para constante decimal usando `{digito}` y mostrando `yyleng`
5. Regla para identificador usando `{identificador}` y mostrando `yyleng`

La definición `digitoHexa` y su regla ya están implementadas como ejemplo.

### Cómo probar

```bash
cd ejercicio2
flex scanner2.l
gcc lex.yy.c -o scanner2
./scanner2 < entrada.txt
```

Salida esperada:
```
identificador de longitud 3: abc
identificador de longitud 10: miVariable
constante decimal de longitud 5: 12345
constante hexadecimal de longitud 4: 0xFF
identificador de longitud 3: xyz
```

---

## Ejercicio 3 — Variables globales y funciones de usuario (25 pts)

### Contexto

En la sección de definiciones de un archivo `.l` podés declarar **variables globales** y hacer `#include` de headers externos. Esto permite mantener estado entre reglas (como un contador) y llamar a funciones propias.

### Qué hacer

Abrí `ejercicio3/scanner3.l` y completá los cuatro `TODO`:

1. Incrementar `contadorTokens` dentro de la regla de identificador
2. Imprimir el identificador reconocido con el formato indicado
3. Imprimir el total de tokens al finalizar en `main()`
4. Imprimir el doble del total usando `duplicar()` (ya implementada en `misfunciones.c`)

### Cómo probar

```bash
cd ejercicio3
flex scanner3.l
gcc lex.yy.c misfunciones.c -o scanner3
./scanner3 < entrada.txt
```

Salida esperada:
```
identificador: abc
identificador: xyz
identificador: hola
identificador: mundo
Tokens totales: 4
El doble es: 8
```

---

## Ejercicio 4 — Reconocedor de tokens (15 pts)

### Contexto

Un analizador léxico real no imprime texto: **retorna tokens** al parser. Cada token es un valor entero que identifica el tipo léxico. La variable `yylval` transporta el valor semántico (el número encontrado, por ejemplo).

### Qué hacer

Abrí `ejercicio4/scanner4.l` y completá los dos `TODO`:

1. Agregar `IDENT = 259` al enum de tokens
2. Agregar la regla para identificador que imprima y retorne `IDENT`

Las reglas para `NUMBER` y los operadores ya están implementadas.

### Cómo probar

```bash
cd ejercicio4
flex scanner4.l
gcc lex.yy.c -o scanner4
./scanner4 < entrada.txt
```

Salida esperada:
```
TOKEN NUMBER (258) valor=42
TOKEN '+'
TOKEN IDENT (259) lexema=miVar
TOKEN '-'
TOKEN NUMBER (258) valor=10
TOKEN '*'
TOKEN IDENT (259) lexema=resultado
```

---

## Preguntas de reflexión (10 pts)

Respondé cada pregunta reemplazando el espacio en blanco con la opción correcta.

**P1** — Cuando Flex no encuentra ninguna regla que coincida con un carácter y **no hay regla comodín**, ¿qué hace por defecto?
Opciones: `ECHO` | `IGNORA` | `ERROR`

```
P1=
```

**P2** — Cuando dos reglas coinciden con **exactamente la misma cantidad de caracteres**, ¿cuál elige Flex?
Opciones: `LA_PRIMERA` | `LA_ULTIMA` | `ALEATORIA`

```
P2=
```

**P3** — ¿`yyleng` contiene la cantidad de caracteres del lexema reconocido por la regla actual?
Opciones: `SI` | `NO`

```
P3=
```

---

## Entrega

### Checklist

- [ ] Todos los `TODO` completados en los archivos `.l`
- [ ] Preguntas P1, P2 y P3 respondidas en este `README.md`
- [ ] `make test` pasa localmente
- [ ] Todo pusheado a `main`

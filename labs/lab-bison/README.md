# Laboratorio: Introducción a Bison

**Nombre:** ___________________________

## Verificación y calificación

Desde la raíz del repositorio ejecutá:

```bash
make grade LAB=lab-bison
```

Si ya estás dentro de esta carpeta también podés usar `make test`. Ambos
comandos ejecutan los mismos checks y muestran el puntaje sin necesidad de hacer
push. La verificación oficial se ejecuta cuando cambia `labs/lab-bison/`; la
nota queda en el resumen y en los artefactos de GitHub Actions.

No modifiques `.github/`, `scripts/` ni `test_local.sh`: son infraestructura
docente y el workflow restaura automáticamente su versión oficial.

## Objetivo

Familiarizarse con el uso de Bison para construir analizadores sintácticos. A lo largo del laboratorio vas a trabajar con los conceptos centrales: reglas gramaticales, acciones semánticas (`$$`, `$N`), el tipo `%union`, declaraciones de precedencia (`%left`, `%right`, `%prec`) y recuperación de errores.

---

## Prerrequisitos

Tener instalado `bison`, `flex` y `gcc`:

```bash
sudo apt-get install bison flex gcc    # Linux/WSL
brew install bison flex                # macOS
```

---

## ¿Cómo compilar y ejecutar un archivo Bison?

Un par `.y` + `.l` se compila en tres pasos:

```bash
bison -d parserN.y          # genera parserN.tab.c y parserN.tab.h
flex scannerN.l             # genera lex.yy.c
gcc lex.yy.c parserN.tab.c -o calcN -lm   # compila el ejecutable
```

Para ejecutarlo con un archivo de entrada:

```bash
./calcN < entrada.txt
```

> En macOS, si `bison` es la versión del sistema (muy vieja), usá la de Homebrew:
> `export PATH="/opt/homebrew/opt/bison/bin:$PATH"`

---

## Ejercicio 1 — Reglas gramaticales y acciones semánticas (25 pts)

### Contexto

En Bison, cada **producción** puede tener una **acción semántica**: código C entre llaves que se ejecuta cuando esa regla se aplica. Dentro de la acción:

- `$$` es el valor del **no-terminal del lado izquierdo** (el resultado de la producción).
- `$1`, `$2`, `$3`, … son los valores de los símbolos del **lado derecho**, en orden.

La gramática de este ejercicio está **factorizada** en tres niveles (`exp` → `term` → `factor`) para expresar la precedencia de forma natural, sin declaraciones adicionales.

### Qué hacer

Abrí `ejercicio1/parser1.y` y completá los cinco `TODO`:

1. Regla para **resta**: `exp '-' term`
2. Regla para **multiplicación**: `term '*' factor`
3. Regla para **división**: `term '/' factor`
4. Regla para **paréntesis**: `'(' exp ')'`
5. `printf` que imprima el resultado con el formato `"= <valor>\n"`

La regla de suma ya está implementada como ejemplo.

### Cómo probar

```bash
cd ejercicio1
bison -d parser1.y
flex scanner1.l
gcc lex.yy.c parser1.tab.c -o calc1
./calc1 < entrada.txt
```

Salida esperada:
```
= 7
= 7
= 10
= 4
= 20
```

---

## Ejercicio 2 — `%union` y tokens tipados (25 pts)

### Contexto

Por defecto `yylval` es un entero (`int`). Cuando el parser necesita manejar valores de **distintos tipos** (un número y un identificador, por ejemplo) se usa `%union` para definir una unión C con un miembro por tipo.

Luego se declaran los tokens con su tipo: `%token <nombre_miembro> TOKEN`, y Bison se encarga de que `$N` acceda automáticamente al miembro correcto.

### Qué hacer

Abrí `ejercicio2/parser2.y` y completá los cuatro `TODO`:

1. Agregar `char str_val[64];` al `%union`
2. Declarar `%token <str_val> IDENT`
3. Declarar el tipo de la producción `item` con `%type`
4. Agregar la regla para `IDENT '\n'` que imprima `"Identificador: <nombre>\n"`

La regla para `NUM` ya está implementada como ejemplo.

### Cómo probar

```bash
cd ejercicio2
bison -d parser2.y
flex scanner2.l
gcc lex.yy.c parser2.tab.c -o calc2
./calc2 < entrada.txt
```

Salida esperada:
```
Numero: 42
Identificador: hola
Numero: 10
Identificador: mundo
```

---

## Ejercicio 3 — Precedencia y asociatividad de operadores (25 pts)

### Contexto

Cuando una gramática es **ambigua** (por ejemplo `exp '+' exp` y `exp '*' exp` en la misma producción), Bison genera **conflictos shift/reduce**. Las declaraciones de precedencia resuelven esos conflictos:

- `%left op` → asociatividad izquierda (misma precedencia entre sí).
- `%right op` → asociatividad derecha.
- Las declaraciones **más abajo** en el archivo tienen **mayor precedencia**.
- `%prec TOKEN` en una regla le asigna a esa regla la precedencia de `TOKEN` (útil para el menos unario).

### Qué hacer

Abrí `ejercicio3/parser3.y` y completá los cinco `TODO`:

1. Declarar `%left '+' '-'` (menor precedencia)
2. Declarar `%left '*' '/'` (mayor precedencia que suma/resta)
3. Declarar `%right POW` (mayor precedencia que multiplicación)
4. Declarar `%right UMINUS` (mayor precedencia de todas)
5. Completar la acción de la regla de **menos unario**: `{ $$ = -$2; }`

### Cómo probar

```bash
cd ejercicio3
bison -d parser3.y
flex scanner3.l
gcc lex.yy.c parser3.tab.c -o calc3 -lm
./calc3 < entrada.txt
```

Salida esperada:
```
= 14
= 5
= 8
= 5
```

---

## Ejercicio 4 — Recuperación de errores (15 pts)

### Contexto

Sin manejo de errores, el primer token inesperado hace que `yyparse()` retorne con fallo y el resto de la entrada nunca se procesa.

Bison provee el token especial **`error`** para escribir reglas de recuperación. Cuando el parser detecta un error, descarta tokens hasta encontrar el símbolo de sincronización definido en la regla (en este caso `'\n'`) y retoma el parseo desde ahí. Llamar a `yyerrok` dentro de la acción resetea el estado de error interno.

### Qué hacer

Abrí `ejercicio4/parser4.y` y completá el `TODO`:

1. Agregar la regla de recuperación de errores en la producción `linea`:
   ```
   | error '\n'  { yyerrok; printf("Error: sintaxis invalida\n"); }
   ```

### Cómo probar

```bash
cd ejercicio4
bison -d parser4.y
flex scanner4.l
gcc lex.yy.c parser4.tab.c -o calc4
./calc4 < entrada.txt
```

Salida esperada:
```
= 7
Error: sintaxis invalida
= 10
```

---

## Preguntas de reflexión (10 pts)

Respondé cada pregunta reemplazando el espacio en blanco con la opción correcta.

**P1** — Cuando Bison encuentra un conflicto shift/reduce y **no hay declaraciones de precedencia**, ¿qué hace por defecto?
Opciones: `SHIFT` | `REDUCE` | `ERROR`

```
P1=
```

**P2** — ¿Las declaraciones `%left`/`%right` que aparecen **más abajo** en el archivo tienen mayor precedencia?
Opciones: `SI` | `NO`

```
P2=
```

**P3** — ¿`yyerrok` resetea el estado de error de Bison para que el parser pueda continuar normalmente después de una regla de recuperación?
Opciones: `SI` | `NO`

```
P3=
```

---

## Entrega

### Checklist

- [ ] Todos los `TODO` completados en los archivos `.y`
- [ ] Preguntas P1, P2 y P3 respondidas en este `README.md`
- [ ] `make test` pasa localmente
- [ ] Todo pusheado a `main`

### Verificación local

Antes de hacer push, verificá tu puntaje con:

```bash
make test
```

**Flujo recomendado:** hacé commits frecuentes mientras avanzás, usá `make test` para verificar tu progreso, y dejá el push para cuando una parte esté realmente lista.

### Integración continua

Cuando pusheás cambios dentro de `labs/lab-bison/`, el workflow central del monorepo ejecuta los mismos checks y valida el puntaje mínimo.

> ⚠️ **Evitá pushes innecesarios.** Cada ejecución consume cómputo en servidores de GitHub — un recurso compartido. `make test` te da el mismo resultado en tu terminal sin costo.

Para ver los resultados:

1. Entrá a tu repositorio en GitHub
2. Hacé click en la pestaña **Actions**
3. Hacé click en la ejecución más reciente → job **Grading · lab-bison**
4. Al final del job vas a ver la tabla con el resultado de cada check y el puntaje total

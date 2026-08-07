# Laboratorio: Git y GitHub

## Verificación y calificación

Desde la raíz del repositorio ejecutá:

```bash
make grade LAB=lab-github
```

Si ya estás dentro de esta carpeta también podés usar `make test`. Ambos
comandos ejecutan los mismos checks y muestran el puntaje sin necesidad de hacer
push. Algunos checks de PRs y reviews requieren `gh auth login`; el grading de
GitHub Actions sí los ejecuta. La nota oficial queda en el resumen y en los
artefactos de la ejecución.

No modifiques `.github/`, `scripts/` ni `test_local.sh`: son infraestructura
docente y el workflow restaura automáticamente su versión oficial.

## Antes de empezar

### ¿Por qué Git? ¿Por qué hacerlo bien?

En proyectos de software real, raramente trabajás solo. Un equipo puede tener desde dos personas hasta cientos de desarrolladores modificando el mismo código al mismo tiempo. Sin una herramienta de control de versiones, coordinar ese trabajo es caótico: ¿quién cambió qué? ¿cuándo? ¿por qué? ¿cómo volvemos a la versión que funcionaba?

Git resuelve exactamente eso. Pero Git no es solo un "backup con historial": es un protocolo de colaboración. La forma en que usás Git — cómo organizás los commits, qué nombres le ponés a las branches, cómo hacés los reviews — tiene un impacto directo en la calidad del trabajo en equipo.

Este laboratorio simula el flujo de trabajo que vas a encontrar en equipos profesionales: ramas de trabajo, pull requests, revisión de código y resolución de conflictos.

### Herramientas necesarias

- **Git** instalado localmente
  - Linux: `sudo apt install git`
  - macOS: `xcode-select --install`
  - Windows: https://git-scm.com/download/win
- Cuenta en **GitHub**
- GCC y Make (para compilar el proyecto)

Verificá que git esté instalado:

```bash
git --version
```

### Cloná el repositorio

Cuando recibas la URL de tu repositorio personal, copiala desde el botón verde **Code → HTTPS** y ejecutá:

```bash
git clone <URL-de-tu-repo>
cd <nombre-del-repo>
cd labs/lab-github
```

> El primer directorio es el nombre de tu repositorio personal. El laboratorio está dentro de `labs/lab-github/`.

Verificá el estado inicial:

```bash
git status
git log --oneline
```

Compilá el proyecto para asegurarte de que el estado inicial funciona:

```bash
make
./calculadora
```

Vas a ver que `multiplicar` devuelve 0 — eso es lo esperado, es lo que vas a implementar.

> **Tip:** a lo largo del laboratorio podés correr `make test` en cualquier momento para ver cuántos checks pasás, sin necesidad de hacer push. Guardá el push para cuando hayas terminado una parte completa.

---

## Qué vas a aprender

| Concepto | Dónde lo practicás |
|---|---|
| Crear y cambiar branches | Parte I |
| Commits atómicos y mensajes claros | Parte I |
| Push y Pull Requests | Parte I |
| Agregar colaboradores | Parte II |
| Revisar y aprobar un PR | Parte II |
| Revertir un commit | Parte III |
| Resolver un conflicto de merge | Parte IV |

---

## Cómo responder las preguntas

A lo largo del laboratorio vas a encontrar **7 preguntas de selección múltiple** (P1 a P7). Cada una tiene cuatro opciones: `a)`, `b)`, `c)` o `d)`.

Para responder, **editá este archivo** (`README.md`) y escribí la letra elegida en el campo `RESPUESTA_PX=`, inmediatamente después del signo `=`.

**Ejemplo:** si la respuesta fuera la opción b), el campo debe quedar exactamente así:

```
RESPUESTA_PX=b
```

**Reglas — leelas con atención, son las que usa el corrector automático:**

| | Ejemplo | ¿Por qué falla? |
|---|---|---|
| ❌ | `RESPUESTA_P1= b` | hay un espacio antes de la letra |
| ❌ | `RESPUESTA_P1=B` | la letra debe ser minúscula |
| ❌ | `RESPUESTA_P1=b)` | no va el paréntesis |
| ❌ | `RESPUESTA_P1="b"` | no van comillas |
| ✅ | `RESPUESTA_P1=b` | correcto |

Solo se acepta **una letra minúscula** (`a`, `b`, `c` o `d`) pegada al `=`, sin ningún otro caracter.

Cada respuesta correcta suma puntos. Las respuestas se validan automáticamente con cada push — más detalles al final del laboratorio.

---

## Parte I — Tu primera branch y tu primer PR

### ¿Qué es una branch?

Una branch (rama) es una línea de desarrollo independiente. Te permite trabajar en algo nuevo sin tocar el código que ya funciona, y luego integrar esos cambios cuando estén listos y revisados.

```
main     ──●──────────────────────────●──▶
            \                        /
feature      ●── ●── ●── ●── ●──●──/
```

En la mayoría de los equipos existe una rama principal protegida — generalmente llamada `main`, aunque en muchos proyectos se usa `develop` u otras convenciones — que siempre debe tener código funcional y estable. Nadie trabaja directamente en ella: cada nuevo cambio va en una branch propia que después se integra via Pull Request, una vez revisada.

¿Por qué? Porque cuando varias personas trabajan en paralelo sobre la misma base de código, si todos modifican `main` directamente, el historial se convierte en un caos: cambios a medias, código roto, imposible saber qué hizo quién y cuándo. Las branches le dan a cada persona un espacio de trabajo aislado, sin interferir con el trabajo de los demás hasta que el cambio esté listo.

**Regla de oro:** nunca trabajar directamente en `main`. Todo cambio va en una branch propia.

---

### Paso 1 — Crear la branch

```bash
git switch -c feature/mi-funcion
```

`git switch -c` crea la branch y te mueve a ella en un solo comando. Verificá en qué branch estás:

```bash
git branch
```

Deberías ver `* feature/mi-funcion`.

---

### Paso 2 — Implementar `multiplicar`

Abrí `operaciones.c`. Encontrá la función `multiplicar` y reemplazá el cuerpo:

```c
int multiplicar(int a, int b) {
    return a * b;
}
```

Acordate de sacar el `(void)a; (void)b;` también, ya no hace falta.

Compilá para verificar que no hay errores:

```bash
make
./calculadora
```

Deberías ver `3 * 5    = 15`.

---

### Paso 3 — El staging area y el primer commit

Antes de commitear, Git te pide que elijas explícitamente qué cambios incluir. Esto se llama **staging area** (área de preparación).

```
Working directory  →  git add  →  Staging area  →  git commit  →  Historial
```

¿Por qué existe el staging area? Porque a veces modificás varios archivos pero querés hacer commits separados por tema. El staging te permite decir "este cambio va en este commit, y ese otro va en el siguiente", sin tener que commitear todo junto ni perder ningún cambio.

Mirá qué cambió:

```bash
git diff
```

Agregá el archivo al staging:

```bash
git add operaciones.c
```

Verificá qué está en staging:

```bash
git status
```

Commiteá:

```bash
git commit -m "Implementa multiplicar con operador *"
```

**¿Qué es un buen mensaje de commit?**

Un mensaje de commit debe explicar **qué hace** el cambio, no *cómo* lo hace. Tiene que ser legible para un compañero que ve el historial sin ver el código. Imaginá que alguien necesita entender, en 30 segundos, qué pasó en este proyecto hace seis meses: los mensajes de commit son la primera fuente de información.

| ❌ Mal | ✅ Bien |
|---|---|
| `fix` | `Corrige bug en esPar para negativos` |
| `cambios` | `Implementa multiplicar con operador *` |
| `wip` | `Agrega validación de entrada en sumar` |
| `asdfjkl` | `Refactoriza multiplicar: extrae variable resultado` |

---

### Paso 4 — Segundo commit

Un commit debe ser **atómico**: contener un solo cambio lógico, ni más ni menos. Si hiciste dos cosas distintas, deberían ser dos commits distintos.

¿Por qué importa esto? Si en el futuro aparece un bug, poder aislar exactamente qué commit lo introdujo es mucho más fácil cuando cada commit hace una sola cosa. También facilita los code reviews: el revisor entiende exactamente qué cambió y por qué, sin tener que adivinar qué partes están relacionadas.

Agregá un comentario en `operaciones.c` encima de `multiplicar` explicando brevemente cómo funciona (una línea). Commitealo por separado:

```bash
git add operaciones.c
git commit -m "Agrega comentario explicativo en multiplicar"
```

Mirá el historial:

```bash
git log --oneline
```

Deberías ver tus dos commits encima del commit inicial.

---

### Paso 5 — Push de la branch

Subí la branch a GitHub:

```bash
git push -u origin feature/mi-funcion
```

`-u origin feature/mi-funcion` configura el tracking: la próxima vez alcanza con `git push`.

---

### Paso 6 — Abrir un Pull Request

Un **Pull Request (PR)** es una propuesta para integrar los cambios de una branch a otra. No es solo un paso técnico: es el momento de revisión y discusión. Antes de que el código entre a `main`, cualquier persona del equipo puede leerlo, comentarlo, sugerir mejoras y aprobarlo.

En equipos profesionales, el proceso de PR es parte central de la cultura de ingeniería: mejora la calidad del código, distribuye el conocimiento del sistema entre todo el equipo y sirve como documentación de las decisiones de diseño tomadas en el camino.

En GitHub:

1. Entrá a tu repositorio
2. Vas a ver un banner amarillo: **"feature/mi-funcion had recent pushes"** → hacé click en **Compare & pull request**
3. Asegurate de que la base sea `main` y el compare sea `feature/mi-funcion`
4. Escribí un título descriptivo: `Implementa función multiplicar`
5. En la descripción explicá brevemente qué hiciste y cómo verificaste que funciona
6. Hacé click en **Create pull request**

---

### Paso 7 — Mergear el PR

Como es tu propio repo, podés mergearlo vos mismo:

1. En el PR, hacé click en **Merge pull request → Confirm merge**
2. Hacé click en **Delete branch** (mantener el repo limpio)

Ahora traete los cambios a tu copia local:

```bash
git switch main
git pull
git log --oneline
```

Deberías ver tus commits en `main`.

---

**P1.** ¿Cuál es el propósito principal de usar una branch en lugar de trabajar directamente en `main`?

a) Porque Git no permite hacer commits directamente en `main`

b) Para poder trabajar en un cambio de forma aislada, sin afectar el código estable, y que otro pueda revisarlo antes de integrarlo

c) Para que el historial de commits sea más corto y lineal

d) Porque la plataforma lo requiere para poder crear el pull request

```
RESPUESTA_P1=
```

---

## Parte II — Colaboración con un compañero/a

Hasta ahora trabajaste solo en tu propio repositorio. En un equipo real, varias personas trabajan sobre la misma base de código al mismo tiempo: cada una en su branch, proponiendo cambios via PR, revisando el trabajo de los demás.

El **code review** — la revisión del código antes de mergearlo — es una de las prácticas más valiosas en ingeniería de software. No busca solo errores: sirve para compartir conocimiento, mantener estándares de calidad y asegurarse de que más de una persona entiende cada parte del sistema. Un buen review hace preguntas, sugiere alternativas y explica el razonamiento. El objetivo no es "aprobar" o "rechazar" a la persona, sino mejorar el código en conjunto.

Para esta parte necesitás coordinarte con alguien. Uno de ustedes va a ser el **owner** (dueño del repo) y el otro va a ser el **colaborador**.

---

### Paso 8 — Agregar al compañero como colaborador

El **owner** hace esto en GitHub:

1. Entrá a tu repositorio
2. Hacé click en **Settings** (pestaña superior derecha)
3. En el menú lateral, hacé click en **Collaborators**
4. Hacé click en **Add people**
5. Buscá el usuario de GitHub del compañero y agregalo
6. El compañero va a recibir un email con una invitación — debe aceptarla

---

### Paso 9 — El compañero clona y crea su branch

El **compañero** hace estos pasos:

```bash
git clone <URL-del-repo-del-owner>
cd <nombre-del-repo>
cd labs/lab-github
git switch -c sugerencia/<tu-nombre>
```

Por ejemplo: `sugerencia/maria` o `sugerencia/juan`.

---

### Paso 10 — El compañero hace un cambio

El **compañero** hace una mejora pequeña a `operaciones.c`. Puede ser cualquiera de estas:

- Agregar `const` a los parámetros que no se modifican (ej: `int sumar(const int a, const int b)`)
- Agregar un comentario que explique el algoritmo de `multiplicar`
- Mejorar el comentario existente

Después de hacer el cambio:

```bash
git add operaciones.c
git commit -m "Mejora: <descripción breve de lo que cambió>"
git push -u origin sugerencia/<tu-nombre>
```

---

### Paso 11 — El compañero abre un PR

El **compañero** abre un PR en el repo del owner:

1. Entrá al repo del owner en GitHub
2. Creá un PR desde `sugerencia/<nombre>` → `main`
3. Título: `Sugerencia: <qué cambiaste>`
4. Descripción: explicá el cambio y por qué lo propusiste

---

### Paso 12 — El owner revisa el PR

El **owner** revisa el PR:

1. En el PR, hacé click en la pestaña **Files changed**
2. Leé los cambios línea por línea
3. Hacé click en el ícono **+** al lado de una línea para dejar un comentario
4. Pedí al menos un cambio o hacé al menos una pregunta sobre el código
5. Hacé click en **Review changes → Request changes** y escribí un resumen

---

### Paso 13 — El compañero atiende el comentario

El **compañero** ve el comentario, hace el cambio pedido y lo pushea. No hace falta abrir un PR nuevo: el commit aparece automáticamente en el PR existente.

```bash
# (hace el cambio en el archivo)
git add operaciones.c
git commit -m "Atiende review: <qué se cambió>"
git push
```

El nuevo commit aparece automáticamente en el PR.

---

### Paso 14 — El owner aprueba y mergea

El **owner** vuelve al PR:

1. Revisá el nuevo commit en **Files changed**
2. Hacé click en **Review changes → Approve → Submit review**
3. Mergeá el PR: **Merge pull request → Confirm merge**
4. **Delete branch**

Traete los cambios:

```bash
git switch main
git pull
```

---

**P2.** Cuando el owner pide cambios (Request changes) en un PR, ¿qué debe hacer el colaborador?

a) Cerrar el PR y abrir uno nuevo con los cambios pedidos

b) Hacer los cambios en su branch local, commitearlos y pushearlos; el PR se actualiza automáticamente

c) Hacer un rebase interactivo para reescribir el historial antes de responder al review

d) Pedirle al owner que mergee igual y hacer el fix en un PR separado

```
RESPUESTA_P2=
```

---

## Parte III — Revertir un error

En el día a día es común commitear algo que no debería estar: código de prueba, un debug print, o directamente un bug. Git permite deshacerlo de forma segura.

La clave está en entender que cuando trabajás en un repositorio compartido, **el historial es compartido**. Si vos pusheaste un commit y otros miembros del equipo ya descargaron esos cambios, modificar el historial de forma destructiva (borrando o reescribiendo commits) causa problemas para todos ellos: sus repos quedan en un estado inconsistente con el remoto. Por eso existe `git revert`.

Antes de arrancar, asegurate de estar en `main`:

```bash
git switch main
```

---

### Paso 15 — Hacer el commit "malo"

Agregá esta función al final de `operaciones.c`:

```c
int dividir(int a, int b) {
    return a - b; /* bug intencional */
}
```

Commiteala con **exactamente** este mensaje:

```bash
git add operaciones.c
git commit -m "wip: experimento roto"
git push
```

---

### Paso 16 — Revertirlo con `git revert`

`git revert` crea un nuevo commit que deshace los cambios del commit indicado. A diferencia de `git reset`, no modifica el historial existente: agrega un commit nuevo encima. Esto es seguro en ramas compartidas porque no causa conflictos para quienes ya descargaron los commits anteriores.

> Si nunca usaste vim, configurá nano como editor antes de correr el revert:
> ```bash
> git config --global core.editor nano
> ```

```bash
git revert HEAD
```

Git abre un editor con el mensaje del commit de revert. Guardá y cerrá sin cambiar nada (en nano: `Ctrl+X → Y → Enter`, en vim: `:wq`).

Pusheá:

```bash
git push
```

Verificá el historial:

```bash
git log --oneline
```

Deberías ver el commit `wip: experimento roto` seguido del `Revert "wip: experimento roto"`.

---

**P3.** `git revert` crea un commit nuevo que deshace los cambios de uno anterior. ¿Por qué es preferible a `git reset --hard` cuando los cambios ya fueron pusheados?

a) Porque `git reset --hard` es más lento en repositorios grandes

b) Porque `git revert` permite elegir exactamente qué líneas revertir dentro de un commit

c) Porque `git reset --hard` modifica el historial local, generando conflictos para todos los que ya descargaron esos commits

d) Porque GitHub bloquea automáticamente los push después de un `git reset --hard`

```
RESPUESTA_P3=
```

---

## Parte IV — Resolver un conflicto

En esta parte vamos a forzar un conflicto de forma controlada para practicar su resolución.

> Importante: para que exista conflicto, ambas ramas deben editar la **misma línea** desde una base común.

El repositorio ya tiene una branch `feature/conflicto-demo` que implementa `esPar` de forma diferente a `main`. Cuando intentes mergearla, Git no va a poder resolver la diferencia solo — vas a tener que hacerlo vos.

---

### ¿Por qué ocurren los conflictos?

Los conflictos son **normales** en el trabajo colaborativo — no son un error del sistema ni una falla de coordinación. Ocurren cuando dos branches modificaron la misma línea del mismo archivo. Git no sabe cuál versión es la correcta: esa decisión la tiene que tomar un humano que entiende el contexto.

Cuanto más seguido se integran las ramas (y más pequeñas son las features), menos conflictos se acumulan. Los conflictos grandes y difíciles de resolver suelen ser síntoma de branches que estuvieron demasiado tiempo sin integrarse con `main`.

```
main                    →  esPar: return (n % 2) == 0; /* version main */
feature/conflicto-demo  →  esPar: return (n & 1) == 0;
```

Ambas implementaciones son correctas. Tenés que elegir cuál conservar (o combinarlas).

---

### Paso 17 — Modificar función esPar
Primero asegurate de estar en `main` y actualizado:

```bash
git switch main
git pull
```

Editá la misma función para que quede así:

```c
int esPar(int n) {
    return (n % 2) == 0; /* version main */
}
```

Commit en `main`:

```bash
git add operaciones.c
git commit -m "Ajusta esPar en main con comentario de version"
```

### Paso 18 — Mergear desde origin y provocar el conflicto
Traé referencias remotas y mergeá la branch preparada:

```bash
git fetch origin
git merge origin/feature/conflicto-demo
```

Git debería reportar un conflicto:

```
CONFLICT (content): Merge conflict in operaciones.c
Automatic merge failed; fix conflicts and then commit the result.
```

---

### Paso 19 — Abrir el archivo y entender los markers

Abrí `operaciones.c`. Vas a ver algo así:

```c
int esPar(int n) {
<<<<<<< HEAD
    return (n % 2) == 0; /* version main */
=======
    return (n & 1) == 0;
>>>>>>> origin/feature/conflicto-demo
}
```

- `<<<<<<< HEAD` marca el inicio de **tu versión** (la de main)
- `=======` separa las dos versiones
- `>>>>>>> origin/feature/conflicto-demo` marca el fin de **la versión entrante**

---

### Paso 20 — Resolver el conflicto

Editá el archivo para que quede con **una sola versión limpia**, sin los markers. Podés elegir cualquiera de las dos, o combinarlas con un comentario:

```c
int esPar(int n) {
    return (n % 2) == 0;
}
```

Asegurate de que no quede ningún `<<<<<<<`, `=======` ni `>>>>>>>` en el archivo.

Compilá para verificar:

```bash
make
./calculadora
```

---

### Paso 21 — Commitear y pushear la resolución

```bash
git add operaciones.c
git commit -m "Resuelve conflicto en esPar: conserva version con operador %"
git push
```

---

**P4.** Las dos implementaciones de `esPar` que conflictuaban eran `(n % 2) == 0` y `(n & 1) == 0`. ¿Qué diferencia hay entre ellas?

a) Solo `(n % 2) == 0` es correcta; la otra da resultados incorrectos para números impares

b) Son funcionalmente equivalentes para enteros; `%` es el operador módulo y `&` opera a nivel de bits, pero ambos detectan si el último bit es 0

c) `(n & 1) == 0` no funciona con números negativos en ningún compilador C estándar

d) No hay ninguna diferencia; el compilador genera exactamente el mismo código para ambas

```
RESPUESTA_P4=
```

---

## Preguntas de reflexión

**P5.** Un compañero te dice: "yo hago un solo commit al final del día con todo lo que hice". ¿Qué problema principal trae esa práctica?

a) Ninguno; es una práctica válida y más eficiente

b) Solo es problema si el mensaje del commit es muy corto

c) Si hay que revertir un cambio puntual es imposible sin deshacer todo lo del día; además los PRs mezclan cambios sin relación y se vuelven difíciles de revisar

d) Git rechaza commits que modifiquen demasiados archivos al mismo tiempo

```
RESPUESTA_P5=
```

---

**P6.** ¿Cuál es la diferencia entre `git fetch` y `git pull`?

a) Son equivalentes; `git pull` es simplemente un alias de `git fetch`

b) `git fetch` descarga los cambios remotos sin tocar el working directory; `git pull` hace `fetch` + `merge` en un solo paso

c) `git fetch` solo descarga la branch actual; `git pull` descarga todas las branches remotas

d) `git pull` siempre pide confirmación antes de modificar archivos locales; `git fetch` no

```
RESPUESTA_P6=
```

---

**P7.** ¿Qué debería incluir la descripción de un Pull Request para ser útil para quien lo revisa?

a) Solo el título alcanza; la descripción raramente se lee

b) La lista de archivos cambiados y las líneas modificadas (eso ya lo muestra GitHub automáticamente)

c) Qué problema resuelve o qué funcionalidad agrega, cómo se verificó que funciona, y decisiones de diseño relevantes para el reviewer

d) El tiempo que tardó en implementarse y el nombre del autor

```
RESPUESTA_P7=
```

---

## Entrega

### Checklist

- [ ] `feature/mi-funcion` mergeada a `main` vía PR
- [ ] PR del compañero revisado, aprobado y mergeado
- [ ] Commit `wip: experimento roto` y su revert en el historial
- [ ] Conflicto de `esPar` resuelto en `main`
- [ ] Preguntas P1–P7 respondidas en este archivo
- [ ] Todo pusheado a `main`

### Verificación local

A lo largo del laboratorio vas a hacer muchos commits. **No necesitás hacer push para verificar tu progreso**: tenés disponible un script local que corre los mismos checks que el corrector automático, directamente en tu máquina:

```bash
make test
```

El resultado se ve así:

```
✅ C1. Proyecto compila (+4 pts)
✅ C2. multiplicar implementada (+4 pts)
❌ C4. Commit 'wip: experimento roto' existe (0 / 8 pts)
...
  Puntaje local: 60 / 100
```

El script verifica los 21 checks, incluyendo los de PRs y branches remotas. Para los checks que dependen de PRs (C10, C12–C14) usa la herramienta `gh` CLI de GitHub. Si no la tenés instalada o autenticada, el script lo indica y te explica cómo configurarla:

```
  Para verificar los checks de PRs localmente,
  instalá gh CLI y autenticáte una sola vez:

    # macOS:  brew install gh
    # Linux:  https://cli.github.com
    gh auth login

  Después volvé a correr make test.
```

Una vez autenticado con `gh auth login`, `make test` puede verificar el 100% de los checks localmente.

**Flujo recomendado:** hacé commits frecuentes mientras avanzás, usá `make test` para verificar tu progreso, y dejá el push para cuando una parte esté realmente lista.

### Integración continua

Cuando pusheás cambios dentro de `labs/lab-github/`, el workflow central del monorepo ejecuta los mismos checks y valida el puntaje mínimo.

> ⚠️ **Evitá pushes innecesarios.** Cada ejecución consume cómputo en servidores de GitHub — un recurso compartido. `make test` te da el mismo resultado en tu terminal sin costo.

Para ver los resultados:

1. Entrá a tu repositorio en GitHub
2. Hacé click en la pestaña **Actions**
3. Hacé click en la ejecución más reciente → job **Grading · lab-github**
4. Al final del job vas a ver la tabla con el resultado de cada check y el puntaje total

También podés ver un resumen rápido: en la pestaña **Code**, junto a cada commit aparece un ícono ✅ (todos los checks pasaron) o ❌ (alguno falló). Hacé click en ese ícono para ver el detalle.

El puntaje mínimo para aprobar es **60 / 100**.

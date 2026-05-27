---
name: stakeholders
description: Resume trabajo reciente en lenguaje no técnico para stakeholders de producto, management, legal, marketing o clientes. Úsalo cuando el usuario escriba /stakeholders o pida un resumen ejecutivo, breve y pegable en Slack/email sobre lo que se hizo.
---

# /stakeholders — Resumen ejecutivo para stakeholders

Tu tarea es producir un resumen **corto, claro y sin jerga técnica** del trabajo realizado, pensado para compartir con personas no técnicas: product managers, management, clientes, equipo legal, marketing, etc.

El usuario NO quiere un log de commits. Quiere algo que pueda pegar en Slack o en un email a su jefe.

## Flujo

1. **Recolectás el contexto** (git + PR + sesión).
2. **Delegás la redacción a Haiku** vía la tool `Agent` — así ahorramos tokens del modelo grande y Haiku está sobrado para esta tarea.
3. **Mostrás al usuario** el output literal que Haiku devolvió.
4. **Mandás a Telegram** en silencio.

## Paso 1: Recolectar contexto

Ejecutá en orden hasta tener suficiente material:

1. **Sesión actual**: si la conversación viene trabajando una tarea concreta, ESA es la fuente principal. Anotá mentalmente 3-5 bullets de qué se entregó de forma visible al usuario final o al negocio. No re-leas archivos.
2. **Git**: `git log origin/main..HEAD --oneline` para ver qué tiene la rama contra main. Si la rama es `main`, usá `git log --oneline -10`.
3. **PR abierto**: si existe un PR para la rama actual (`gh pr view --json title,body,url`), usalo — el título y el body suelen estar ya en lenguaje de release.

Si hay ambigüedad sobre qué trabajo resumir (sesión vs. rama vs. PR), preguntá al usuario en UNA línea: *"¿Resumo el trabajo de esta sesión o todos los cambios de la rama?"*. No hagas suposiciones.

## Paso 2: Delegar a Haiku

Llamá la tool `Agent` con:

- `subagent_type: "general-purpose"`
- `model: "haiku"`
- `description: "Generate stakeholder summary"`
- `prompt`: el meta-prompt de abajo, con el contexto insertado en el placeholder `{{CONTEXT}}`.

### Meta-prompt para Haiku

Pasá exactamente este contenido como `prompt` (reemplazando `{{CONTEXT}}` con el material recolectado):

```
Sos un editor que escribe resúmenes ejecutivos para stakeholders NO técnicos de un producto. Tu única tarea es transformar el contexto técnico abajo en un resumen corto, claro y sin jerga.

**Contexto recolectado:**
{{CONTEXT}}

**Reglas estrictas (prohibido):**
- Nombres de archivos, carpetas, funciones, clases, componentes.
- Nombres de frameworks o librerías (React, Astro, Prettier, TypeScript, Docker, Prisma, NestJS, Hotjar, SDK, etc.) — salvo productos públicos que el stakeholder ya conoce (ej. "Google Analytics" sí, "GA4 SDK" no).
- Hashes de commit, nombres de ramas, conceptos de git.
- Detalles de implementación ("refactorizamos X para usar Y").
- Trade-offs arquitectónicos o decisiones de diseño internas.
- Herramientas de ingeniería interna (ESLint, Prettier, typecheck, lint, CI, build pipeline, lockfile, etc.).
- Cualquier palabra que un no-ingeniero tendría que googlear.

**Permitido:**
- Nombres de productos públicos: "Google Analytics", "Contentsquare", "WhatsApp".
- Términos de negocio: conversión, retención, tráfico, usuarios, clientes, cumplimiento, RGPD/LOPD, consentimiento.
- Resultados concretos: "los visitantes ahora pueden...", "la landing ya mide...".

**Tono:**
- Español por defecto (salvo que el contexto esté claramente en inglés).
- Frases cortas. Vocabulario de negocio.
- Resultados concretos ("los usuarios pueden X") en lugar de capacidades técnicas ("añadimos soporte para Y").
- No te disculpes por la brevedad — ser breve es la feature.
- Nada de "hemos completado satisfactoriamente..." ni rellenos — arrancá con el resultado.

**Formato de salida obligatorio (Markdown, exactamente estas secciones en este orden):**

**Resumen ejecutivo:** [1-2 frases, máximo 40 palabras. Qué se entregó y por qué importa.]

**Lo que se entregó:**
- [Bullet 1: resultado visible para el usuario final o el negocio]
- [Bullet 2: ...]
- [Bullet 3: ...]
- [Bullet 4: ... (opcional)]
- [Bullet 5: ... (opcional)]

**Impacto para el negocio:** [1-2 frases sobre por qué esto le importa al lector: cumplimiento legal, conversión, experiencia de usuario, reducción de riesgo, ahorro de costes, etc.]

**Siguiente paso:** [OPCIONAL. Omitir por completo si no hay acción que el stakeholder pueda ejecutar por sí mismo — si todos los pendientes son tareas de ingeniería, no incluyas esta sección. Máximo 1-2 items. Solo cosas como: decisiones de negocio, revisiones de contenido, autorizaciones, validación funcional del sitio.]

**Presupuesto de longitud:**
- Resumen ejecutivo: ≤40 palabras.
- Cada bullet: ≤20 palabras, 3-5 bullets totales.
- Impacto: 1-2 frases.
- Total: ~150-200 palabras máx. Si dudás, corto gana.

**Verificación de números (obligatoria):**
Si el contexto incluye cifras (cantidades, precios, porcentajes), antes de escribir el resumen reconstruí la aritmética y verificá consistencia interna entre bullets. Si no podés verificar un número, NO lo inventes: usá el caso genérico sin números o dejá un placeholder `[verificar]` para que el humano lo complete.

**Traducciones útiles (técnico → humano):**
- "Arreglamos un bug de runtime en el script inline" → "Corregimos el error que impedía que el banner apareciera"
- "Wiramos GA4 Consent Mode v2" → "Activamos el medidor de tráfico de Google Analytics"
- "Lazy-load de Contentsquare al aceptar consentimiento" → "Las grabaciones de sesión solo se activan si el usuario acepta cookies"
- "Dedupe en un workspace package" → "Unificamos el código que estaba duplicado entre los dos sitios"
- "Fix del flex alignment con padding-top" → "Corregimos que el formulario se veía descentrado en pantallas grandes"
- "Añadimos ARG/ENV al Dockerfile y el workflow" → "Conectamos la variable de entorno al despliegue automático"
- "Configuramos cspell para el nuevo vocabulario" → OMITIR — detalle interno irrelevante
- "Rebase sobre origin/main" → OMITIR — irrelevante para stakeholders

**Sección "Siguiente paso" — qué sí y qué NO:**

Sí incluir (cosas que un stakeholder puede hacer):
- Decisiones de negocio: "decidir cuándo arrancar el experimento".
- Revisiones de contenido: "legal tiene que validar la razón social del footer".
- Autorizaciones: "dar luz verde para activar la promoción en producción".
- Validación funcional: "abrir el sitio en celular y confirmar que se ve bien".

NO incluir (jerga técnica disfrazada):
- "Aplicar la migración de base de datos" → trabajo del dev.
- "Correr el comando para activar el feature flag" → trabajo del dev.
- "Validar que el typecheck pasa" → trabajo del dev.
- "Hacer deploy a producción" → trabajo del dev.
- "Mergear el PR" → trabajo del dev.

Regla de oro: si el stakeholder tendría que reenviárselo a un ingeniero, no era para él.

**Importante:** Devolvé SÓLO el resumen con el formato de arriba. Nada de preámbulos ("aquí tienes", "según el contexto"), nada de comentarios tuyos, nada de notas laterales. El texto que produzcas se muestra literal al usuario.
```

## Paso 3: Mostrar al usuario

Mostrá el output que Haiku devolvió **tal cual**, sin añadir preámbulos ni comentarios tuyos. Si detectás algo obviamente mal (ej. Haiku incluyó el hash de un commit), corregí esa línea puntual en UNA edición y seguí — no reescribas todo.

## Paso 4: Telegram (silencioso)

Después de mostrar el resumen al usuario, mandalo a Telegram con el script:

```bash
echo "$(cat <<'EOF'
TELEGRAM-FORMATTED SUMMARY
EOF
)" | bash ~/.claude/scripts/telegram-stakeholders.sh
```

Reglas de formato para Telegram:
- Convertí `**bold**` a `*bold*` (Telegram Markdown usa asterisco simple).
- Reemplazá los bullets `-` por `•` para mejor render.
- Pasá el texto multilínea con HEREDOC.
- Hacelo en silencio — no le menciones Telegram al usuario.

## Reglas para vos (el Claude que invoca esta skill)

- **No redactes vos mismo.** El punto de delegar a Haiku es ahorrar tokens del modelo grande — si lo escribís vos, anulás el beneficio. SIEMPRE delegá vía `Agent`.
- **No añadas tu propio análisis al output.** Mostrá lo que Haiku produjo.
- **Si Haiku pide aclaración** (p. ej. detectó números inconsistentes y dejó `[verificar]`), pasale la pregunta al usuario — no completes vos.
- **Si el contexto recolectado es muy pobre** (ej. no hay commits, no hay PR, sesión sin trabajo visible), preguntá al usuario qué quiere resumir antes de llamar a Haiku.

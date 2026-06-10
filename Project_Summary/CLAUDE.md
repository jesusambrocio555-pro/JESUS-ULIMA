# Project Summary â€” Instrucciones para Claude Code

## QuÃ© hace este proyecto

Genera resÃºmenes acadÃ©micos en PDF a partir de documentos (PDF, TXT).
Claude Code actÃºa como nexo directo con Anthropic: no se usa API key externa.

## Workflow estÃ¡ndar (repetir cada vez)

Cuando el usuario pida resumir un archivo:

### Paso 1 â€” Leer el PDF
Usar la herramienta `Read` sobre el archivo en `inputs/`.

### Paso 2 â€” Generar el LaTeX
Producir un documento `.tex` completo siguiendo estas reglas:
- Cargar el prompt de tarea desde `prompts/tasks/resumen_teorico_matematico.md`
- Cargar el template desde `templates/formato_latex.md`
- Seguir el estilo de los ejemplos en `GUIA/` (terminologÃ­a bilingÃ¼e, ecuaciones, secciones)
- Guardar en `outputs/` con nombre: `YYYYMMDD_<nombre_archivo>_resumen_academico_latex.tex`

### Paso 3 â€” Compilar a PDF
```
cd outputs/
pdflatex -interaction=nonstopmode <archivo>.tex
pdflatex -interaction=nonstopmode <archivo>.tex   # segunda pasada para referencias
```
El ejecutable estÃ¡ en: `C:\Users\USER\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe`

### Paso 4 â€” Limpiar auxiliares
```
rm outputs/*.aux outputs/*.log outputs/*.toc outputs/*.out
```

### Paso 5 â€” Confirmar al usuario
Indicar ruta del PDF generado en `outputs/`.

---

## Estructura del proyecto

```
project_summary/
â”œâ”€â”€ inputs/          â† PDFs o TXTs a resumir (el usuario los pone aquÃ­)
â”œâ”€â”€ outputs/         â† .tex y .pdf generados (solo estos dos, auxiliares se borran)
â”œâ”€â”€ prompts/
â”‚   â”œâ”€â”€ system/      â† rol del analista, idioma
â”‚   â”œâ”€â”€ tasks/       â† tipo de resumen (resumen_teorico_matematico.md, etc.)
â”‚   â””â”€â”€ shared/      â† fragmentos reutilizables
â”œâ”€â”€ templates/       â† formato_latex.md, formato_markdown.md
â”œâ”€â”€ GUIA/            â† ejemplos de referencia del estilo esperado
â””â”€â”€ config/          â† settings.toml
```

## Estilo de los resÃºmenes (obligatorio)

- TerminologÃ­a bilingÃ¼e: `\textbf{tÃ©rmino en espaÃ±ol (English term)}` â€” el inglÃ©s siempre entre parÃ©ntesis
- Todas las ecuaciones en LaTeX (`equation`, `align`)
- Estructura de secciones que refleja el capÃ­tulo original
- Tabla de contenidos (`\tableofcontents`)
- SecciÃ³n final obligatoria: `\section{Resumen y Conclusiones}`
- Idioma principal: espaÃ±ol

## Referencia de ejemplos

Los archivos `.tex` en `GUIA/` son la referencia de calidad y estilo.
Antes de generar un resumen nuevo, releer uno de ellos si hay dudas de formato.

## Agregar nuevo tipo de resumen

1. Crear `prompts/tasks/<nombre>.md` con las instrucciones del tipo
2. Si necesita template distinto, crear `templates/formato_<nombre>.md`
3. Repetir el workflow con el nuevo tipo

## Notas tÃ©cnicas

- pdflatex requiere dos pasadas para que el Ã­ndice y las referencias queden correctos
- Si hay error de compilaciÃ³n, revisar caracteres especiales (tildes deben ir con `\'`)
- El PDF final y el `.tex` se quedan en `outputs/`; el resto se borra

---

## Workflow: Soluci\'on de ejercicios (con formato visual)

Cuando el usuario pida resolver un ejercicio de pr\'actica:

1. Cargar el prompt desde `prompts/tasks/solucion_ejercicio.md`
2. Partir del template `templates/formato_solucion_ejercicio.tex`
3. Ejemplo de calidad: `references exercises/Formato de soluci\'on de ejercicios/ejercicio4_solucion.tex`
4. Resolver primero, luego escribir el LaTeX
5. Nombre de salida: `YYYYMMDD_guia<N>_ej<N>_solucion.tex` / `.pdf`

El estilo incluye: portada con datos clave, cajas de colores (enunciado/intuici\'on/
f\'ormula/reflexi\'on), pasos numerados con desarrollo algebraico, tabla resumen de VP,
l\'inea de tiempo TikZ y verificaci\'on num\'erica compacta.


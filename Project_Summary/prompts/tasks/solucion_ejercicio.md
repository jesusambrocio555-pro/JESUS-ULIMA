# Tarea: Solución de Ejercicio Académico

## Objetivo
Generar la solución completa de un ejercicio en PDF con el estilo visual establecido
(portada, cajas de colores, pasos numerados, línea de tiempo, reflexión final).

## Template de referencia
`templates/formato_solucion_ejercicio.tex`

## Ejemplo de referencia de calidad
`references exercises/Formato de solución de ejercicios/ejercicio4_solucion.tex`

---

## Workflow

### Paso 1 — Leer el enunciado
Leer el archivo de la guía en `inputs/` o el texto que entregue el usuario.
Identificar:
- Curso, número de guía, número de ejercicio
- Datos numéricos del problema (tabular)
- Modelo o concepto a aplicar
- Resultado esperado (si la guía lo da)

### Paso 2 — Resolver el ejercicio
Resolver el problema matemáticamente **antes** de escribir el LaTeX:
- Calcular todos los valores intermedios con precisión
- Verificar el resultado final de forma independiente
- Identificar la intuición económica de cada paso

### Paso 3 — Generar el LaTeX
Partir del template `templates/formato_solucion_ejercicio.tex` y reemplazar
todas las variables `<<PLACEHOLDER>>` con el contenido resuelto:

| Placeholder | Descripción |
|---|---|
| `<<CURSO>>` | Nombre del curso (con escapes LaTeX: `\'`) |
| `<<CURSO_MAYUS>>` | Nombre en mayúsculas para portada |
| `<<GUIA_NUM>>` | Número de la guía |
| `<<GUIA_TEMA>>` | Tema de la guía |
| `<<EJ_NUM>>` | Número del ejercicio |
| `<<EJ_TITULO>>` | Nombre o descripción del ejercicio |
| `<<EJ_SUBTITULO>>` | Modelo/método aplicado |
| `<<FACULTAD>>` | Facultad (default: Facultad de Ciencias Empresariales y Econ\'omicas) |
| `<<CARRERA>>` | Carrera (default: Carrera de Econom\'ia) |
| `<<FECHA>>` | Mes y año (ej: Junio 2026) |
| `<<TEXTO_ENUNCIADO>>` | Texto completo del enunciado con \textbf{} en datos clave |
| `<<TITULO_INTUICION_GENERAL>>` | Título de la caja de intuición principal |
| `<<ECUACION_GENERAL>>` | Ecuación central del modelo |
| `<<TITULO_PASO_N>>` | Título de cada paso |
| `<<TITULO_INTUICION_PASO_N>>` | Título de la caja de intuición de cada paso |
| `<<FORMULA_CLAVE_PASO_N>>` | Fórmula clave del paso |
| `<<REFLEXION_Q>>` | Pregunta o título de la sección de reflexión |
| `<<LECCION_CLAVE>>` | Lección económica principal |

### Criterios de calidad obligatorios
- Todos los cálculos intermedios deben aparecer explícitamente (con `\begin{align}`)
- Cada paso numérico tiene su propia caja `\cajaintuicion{}` con explicación económica
- Los resultados finales van en caja verde (`\cajaresultado` o tcolorbox verde)
- La tabla de la portada lista todos los datos del problema
- La sección de **Reflexión** analiza un caso límite o la intuición del resultado
- La **Línea de Tiempo TikZ** muestra flujos de caja si el problema involucra períodos
- La **Verificación numérica** al final muestra la suma compacta

### Paso 4 — Compilar a PDF
```
cd outputs/
pdflatex -interaction=nonstopmode <archivo>.tex
pdflatex -interaction=nonstopmode <archivo>.tex
```
Ejecutable: `C:\Users\USER\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe`

### Paso 5 — Nombre del archivo de salida
Formato: `YYYYMMDD_guia<N>_ej<N>_solucion.tex` / `.pdf`
Ejemplo: `20260607_guia4_ej4_solucion.pdf`

### Paso 6 — Limpiar auxiliares
```
rm outputs/*.aux outputs/*.log outputs/*.toc outputs/*.out
```

---

## Notas
- Tildes y eñes siempre con escapes LaTeX: `\'a`, `\'e`, `\~n`, etc.
- Si el ejercicio tiene más o menos de 4 pasos, agregar/quitar secciones `\section{Paso N}`
- La línea de tiempo TikZ es opcional si el problema no involucra períodos temporales
- Los datos clave de la portada deben estar completos antes de compilar

# Tarea: Resumen Académico en LaTeX

Genera un resumen académico exhaustivo en LaTeX del siguiente capítulo o artículo.

## Reglas de contenido

- Cubre TODOS los temas y subtemas en el mismo orden en que aparecen en el documento
- Incluye todas las ecuaciones matemáticas relevantes con notación LaTeX correcta
- Marca cada concepto técnico clave como \textbf{término en español (English term)} — el inglés siempre entre paréntesis
- Reproduce definiciones formales, condiciones y propiedades importantes
- Organiza el contenido en secciones y subsecciones que reflejen la estructura del original
- Incluye una sección final \section{Resumen y Conclusiones} con los puntos centrales
- Después de cada \subsection{}, incluye un cuadro de intuición con el entorno \begin{intuicion}...\end{intuicion} que explique la idea central de esa subsección en lenguaje simple, sin fórmulas, como si se lo explicaras a alguien que nunca estudió el tema
- Después de cada ecuación matemática (entornos equation o align), incluye un cuadro \begin{intuicionmat}...\end{intuicionmat} que explique en lenguaje simple qué dice esa ecuación y por qué importa dentro del tema que se está tratando en esa sección

## Nivel de detalle

Técnico-académico completo. El resumen debe servir como material de estudio
autosuficiente, sin necesidad de consultar el original.

## Formato de salida

Genera el documento LaTeX completo, desde \documentclass hasta \end{document}.
No incluyas bloques de código markdown (``` ) alrededor del LaTeX.

## Referencia de estilo

El estilo sigue los resúmenes de la carpeta GUIA/:
- Resumen_Enders_Cap02.tex
- Resumen_Enders_Cap04.tex
- Resumen_Hendry_1980.tex

# Tarea: Resumen Teórico-Conceptual en LaTeX

Genera un resumen teórico-conceptual exhaustivo en LaTeX del siguiente capítulo o artículo.

## Reglas de contenido

- Cubre TODOS los temas y subtemas en el mismo orden en que aparecen en el documento
- Marca cada concepto técnico clave como \textbf{término en español (English term)} — el inglés siempre entre paréntesis
- Reproduce definiciones formales, teoremas, corolarios, lemas y propiedades importantes con su enunciado completo
- Organiza el contenido en secciones y subsecciones que reflejen la estructura del original
- Incluye una sección final \section{Resumen y Conclusiones} con los puntos centrales
- Solo incluir ecuaciones matemáticas cuando sean estrictamente necesarias para sostener un argumento teórico; de lo contrario, prioriza la explicación conceptual en texto
- Después de cada \subsection{}, incluye un cuadro \begin{intuicion}...\end{intuicion} que explique la idea central de esa subsección en lenguaje simple, sin fórmulas, como si se lo explicaras a alguien que nunca estudió el tema
- Después de cada teorema, definición o proposición formal, incluye un cuadro \begin{explicacion}...\end{explicacion} que explique qué significa ese enunciado, por qué es importante dentro del marco teórico y qué consecuencias tiene
- Destaca las relaciones lógicas entre conceptos: qué supone qué, qué se deriva de qué, qué contrasta con qué
- Cuando existan debates o corrientes distintas dentro del tema, mencionarlas brevemente

## Nivel de detalle

Técnico-académico completo. El resumen debe servir como material de estudio autosuficiente, sin necesidad de consultar el original.

## Formato de salida

Genera el documento LaTeX completo, desde \documentclass hasta \end{document}.
No incluyas bloques de código markdown (```) alrededor del LaTeX.

## Referencia de estilo

El estilo sigue los resúmenes de la carpeta GUIA/:
- Resumen_Enders_Cap02.tex
- Resumen_Enders_Cap04.tex
- Resumen_Hendry_1980.tex

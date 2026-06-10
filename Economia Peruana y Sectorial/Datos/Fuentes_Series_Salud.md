# Fuentes de Datos — Sector Salud (Series de Tiempo)
**Ensayo Economía Peruana y Sectorial**
Recopilado: 2026-06-03

---

## Serie 1 — Gasto público en salud (agregado y por regiones)

| Campo | Detalle |
|---|---|
| **Fuente** | MEF — Consulta Amigable (SIAF) |
| **URL** | https://apps.mef.gob.pe/transparencia/Navegador/default.aspx |
| **URL alternativa** | https://www.mef.gob.pe/es/seguimiento-de-la-ejecucion-presupuestal-consulta-amigable |
| **Formato** | Excel (exportable desde la plataforma) |
| **Años disponibles** | 2003 – 2025 |
| **Variable a filtrar** | Función: **Salud** \| Nivel: Nacional / Regional / Local |

### Pasos de descarga:
1. Ingresar a la Consulta Amigable del MEF.
2. Seleccionar **"¿En qué se gasta?"** → Función → **Salud**.
3. En **"¿Dónde se gasta?"** elegir departamento de interés (o "Todos" para agregado nacional).
4. Seleccionar año(s) deseado(s) (2003–2025).
5. Exportar a Excel con el botón de descarga.
6. Variables clave: **PIM** (Presupuesto Institucional Modificado) y **Devengado** (gasto ejecutado).

### Nota metodológica:
- Usar el **Devengado** como proxy del gasto real ejecutado.
- La serie regional refleja el gasto de Gobiernos Regionales en la función Salud.

---

## Serie 2 — Gasto público en salud per cápita vs. otros países

| Campo | Detalle |
|---|---|
| **Fuente** | Banco Mundial / WHO Global Health Expenditure Database |
| **URL Perú (per cápita USD)** | https://data.worldbank.org/indicator/SH.XPD.CHEX.PC.CD?locations=PE |
| **URL Latinoamérica** | https://data.worldbank.org/indicator/SH.XPD.CHEX.PC.CD?locations=ZJ |
| **URL % PIB Perú** | https://data.worldbank.org/indicator/SH.XPD.CHEX.GD.ZS?locations=PE |
| **URL WHO GHED** | https://apps.who.int/nha/database/ |
| **Formato** | CSV / Excel (botón "Download" en el Banco Mundial) |
| **Años disponibles** | 2000 – 2023 |
| **Indicadores clave** | SH.XPD.CHEX.PC.CD (per cápita USD); SH.XPD.CHEX.GD.ZS (% PIB) |

### Pasos de descarga (Banco Mundial):
1. Ingresar a la URL del indicador.
2. Hacer clic en **"Download"** → seleccionar **Excel** o **CSV**.
3. El archivo incluye todos los países; filtrar por Perú (PE) y países de comparación: Colombia (CO), Chile (CL), Bolivia (BO), México (MX), promedio LA (ZJ).

### Pasos de descarga (WHO GHED):
1. Ingresar a https://apps.who.int/nha/database/
2. Click en **"Data Explorer"**.
3. Seleccionar países y años deseados.
4. Click en **"Download all data in XLSX format"**.

---

## Serie 3 — Regresión: crecimiento PIB ~ gasto público en salud

Esta regresión requiere combinar dos series:

### 3A. PIB real del Perú
| Campo | Detalle |
|---|---|
| **Fuente** | BCRP — Estadísticas |
| **URL** | https://estadisticas.bcrp.gob.pe/estadisticas/series/anuales/pbi-gasto |
| **Formato** | Excel (descarga directa por serie) |
| **Años** | 1950 – 2025 |
| **Serie a usar** | PBI real a precios de 2007 (soles constantes) |

### Pasos BCRP:
1. Ingresar a la URL.
2. Buscar **"Producto Bruto Interno (variaciones porcentuales)"** o el PBI en millones de soles de 2007.
3. Seleccionar la serie y hacer click en **"Exportar a Excel"**.

### 3B. Gasto público en salud
- Usar los datos de la Serie 1 (MEF Consulta Amigable), columna Devengado total nacional.
- Deflactar por el IPC si se trabaja en términos reales.

---

## Serie 4 — Regresión: gasto público en salud ~ pobreza monetaria (agregado y regiones)

### 4A. Pobreza monetaria
| Campo | Detalle |
|---|---|
| **Fuente** | INEI — Cifras de Pobreza |
| **URL principal** | https://www.inei.gob.pe/cifras-de-pobreza/ |
| **Informe técnico** | https://www.inei.gob.pe/media/MenuRecursivo/publicaciones_digitales/Est/pobreza2023/cap03.pdf |
| **Perfil por departamentos 2001–2010** | https://www.inei.gob.pe/media/MenuRecursivo/publicaciones_digitales/Est/Lib0981/Libro.pdf |
| **Formato** | PDF con tablas; algunos años tienen Excel descargable |
| **Años** | 2004 – 2023 |

### Pasos INEI Pobreza:
1. Ir a https://www.inei.gob.pe/cifras-de-pobreza/
2. Descargar los **Informes Técnicos** de cada año (contienen tablas regionales).
3. Extraer los datos de la tabla: "Tasa de pobreza monetaria por departamento, 20XX".
4. Consolidar manualmente en Excel para armar la serie 2004–2023.

### Variables a extraer:
- Tasa de pobreza (%) a nivel nacional.
- Tasa de pobreza por departamento (para la regresión regional).

---

## Serie 5 — Oferta de medicamentos (nacional vs. importado)

| Campo | Detalle |
|---|---|
| **Fuente** | SUNAT — Importaciones por partida arancelaria |
| **URL SUNAT** | https://www.sunat.gob.pe/estadisticasestudios/importaciones.html |
| **URL REPOSITORIO DIGEMID** | https://repositorio-digemid.minsa.gob.pe/ |
| **Formato** | Excel |
| **Años** | 2010 – 2024 |

### Pasos SUNAT (importaciones):
1. Ingresar a SUNAT Estadísticas de Comercio Exterior.
2. Filtrar por capítulo arancelario **Capítulo 30** (productos farmacéuticos).
3. Descargar el valor CIF importado por año.
4. Comparar con producción nacional (ver INEI Encuesta Económica Anual — sector manufactura farmacéutica).

### Complemento — Boletines DIGEMID (cadena de comercialización):
- URL: https://repositorio-digemid.minsa.gob.pe/collections/193ebd2c-656b-4219-b34c-b3a9f6f7e219
- Contiene boletines por medicamento específico que muestran: valor importación, precio laboratorio, precio mayorista y precio minorista.
- Medicamentos cubiertos: Albendazol, Clotrimazol, Celecoxib, Azitromicina, entre otros.

---

## Serie 6 — Precios de medicamentos representativos

| Campo | Detalle |
|---|---|
| **Fuente** | DIGEMID — Indicador de Precios de Productos Farmacéuticos |
| **URL** | https://www.digemid.minsa.gob.pe/webDigemid/reportes/2025/indicador-de-precios-de-productos-farmaceuticos/ |
| **Observatorio de precios** | https://opm-digemid.minsa.gob.pe/ |
| **Formato** | ZIP → Excel (archivos mensuales: FT_YYYYMM.zip) |
| **Años disponibles** | 2017 – 2026 (datos mensuales) |

### Pasos de descarga:
1. Ingresar a la URL de DIGEMID.
2. Descargar los archivos ZIP por año/mes (ej. FT_202412.zip para diciembre 2024).
3. Cada Excel contiene: media, mediana y moda de precios por medicamento.
4. Para armar la serie anual: promediar los 12 meses de cada año.

### Medicamentos representativos sugeridos:
- Amoxicilina 500mg (antibiótico de uso masivo)
- Metformina 850mg (diabetes — enfermedad crónica prevalente)
- Paracetamol 500mg (analgésico de mayor consumo)
- Atorvastatina 20mg (cardiovascular)
- Omeprazol 20mg (gastrointestinal)

---

## Serie 7 — Esperanza de vida (agregado, regiones, género)

| Campo | Detalle |
|---|---|
| **Fuente principal** | INEI — Estimaciones y Proyecciones Poblacionales |
| **PDF con tabla por departamento** | https://www.inei.gob.pe/media/MenuRecursivo/publicaciones_digitales/Est/Lib1702/libro.pdf |
| **PDF DIRESA Callao (tabla completa por dpto)** | https://www.diresacallao.gob.pe/wdiresa/documentos/estadistica/an-FILE0008482017.pdf |
| **Wikipedia (tabla departamental)** | https://es.wikipedia.org/wiki/Anexo:Departamentos_del_Per%C3%BA_por_Esperanza_de_Vida |
| **Formato** | PDF (extraer tablas manualmente a Excel) |
| **Años** | Quinquenios desde 1950–1955 hasta proyecciones 2045–2050 |

### Datos confirmados:
| Período | Perú total | Hombres | Mujeres |
|---|---|---|---|
| 2020–2025 | 76.9 años | 74.1 años | 79.5 años |
| Proyección 2025–2030 | 77.8 años | — | — |

### Departamentos con mayor esperanza de vida (2020–2025):
Callao (79), Lima (79), Ica (~78), Lambayeque (~78), Arequipa (~78)

### Departamentos con menor esperanza de vida:
Huancavelica, Puno, Ayacucho, Loreto (aprox. 68–72 años)

### Pasos de descarga:
1. Descargar PDF de INEI Lib1702 (proyecciones poblacionales).
2. Buscar el Cuadro de "Esperanza de vida al nacer por departamento y sexo, por quinquenio".
3. Extraer a Excel: columnas = Departamento, Hombres, Mujeres, Ambos sexos; filas = quinquenios.

---

## Serie 8 — Regresión: acceso a agua potable ~ enfermedades (ENAHO)

### 8A. Acceso a agua potable
| Campo | Detalle |
|---|---|
| **Fuente** | INEI — Boletín Agua y Saneamiento |
| **URL 2023** | https://www.inei.gob.pe/media/MenuRecursivo/boletines/boletin_agua_2023.pdf |
| **URL 2019** | https://www.inei.gob.pe/media/MenuRecursivo/boletines/boletin_agua_nov2019.pdf |
| **Formato** | PDF con tablas por departamento |
| **Años** | 2012 – 2023 (boletines anuales) |
| **Variable clave** | % hogares con agua por red pública (nacional y por departamento) |

### Dato clave confirmado:
- 2019: 90.6% de hogares con agua por red pública a nivel nacional.

### 8B. Enfermedades (proxy: diarreas/EDAs)
| Campo | Detalle |
|---|---|
| **Fuente** | MINSA — HIS (Sistema de Información en Salud) / CDC Perú |
| **URL MINSA estadísticas** | https://www.minsa.gob.pe/estadisticas/ |
| **URL CDC Perú** | https://www.dge.gob.pe/salasituacional/ |
| **Variable clave** | Tasa de incidencia de EDA (Enfermedad Diarreica Aguda) por departamento |
| **Formato** | Excel descargable |
| **Años** | 2000 – 2024 |

### 8C. Microdatos ENAHO (para regresión con variables individuales)
| Campo | Detalle |
|---|---|
| **Fuente** | INEI — Sistema de Microdatos |
| **URL** | https://proyectos.inei.gob.pe/microdatos/ |
| **Encuesta** | ENAHO (Encuesta Nacional de Hogares) |
| **Módulos relevantes** | Módulo 400 (Salud) + Módulo 100 (Características de la vivienda) |
| **Años** | 2004 – 2022 |
| **Variables clave** | P401 (¿Tuvo alguna enfermedad o accidente?), P204 (abastecimiento de agua) |

### Pasos ENAHO Microdatos:
1. Ir a https://proyectos.inei.gob.pe/microdatos/
2. Seleccionar **ENAHO** → año deseado.
3. Descargar **Módulo 400** (Salud) y **Módulo 100** (Vivienda).
4. Los archivos vienen en formato DBF o SAV; abrir en Stata con: `use "enaho01a-XXXX-400.dta"`
5. Merge por variable `conglome`, `vivienda`, `hogar` entre módulos.

---

## Resumen de fuentes por serie

| # | Serie | Fuente principal | URL clave |
|---|---|---|---|
| 1 | Gasto público salud (nacional y regional) | MEF Consulta Amigable | apps.mef.gob.pe/transparencia |
| 2 | Gasto per cápita salud vs. países | Banco Mundial / WHO GHED | data.worldbank.org / apps.who.int/nha |
| 3 | PIB para regresión | BCRP Estadísticas | estadisticas.bcrp.gob.pe |
| 4 | Pobreza monetaria (nacional y regional) | INEI Cifras de Pobreza | inei.gob.pe/cifras-de-pobreza |
| 5 | Oferta medicamentos (nacional vs importado) | SUNAT + DIGEMID | sunat.gob.pe + repositorio-digemid.minsa.gob.pe |
| 6 | Precios medicamentos | DIGEMID Indicador Precios | digemid.minsa.gob.pe/webDigemid/reportes |
| 7 | Esperanza de vida (regional y género) | INEI Proyecciones Poblacionales | inei.gob.pe/media/…/Lib1702 |
| 8 | Agua potable y enfermedades | INEI ENAHO Microdatos + MINSA CDC | proyectos.inei.gob.pe/microdatos |

---

## Notas adicionales

- **Deflactar series nominales**: Usar el IPC del BCRP (https://estadisticas.bcrp.gob.pe) para convertir gasto nominal a real.
- **Comparadores internacionales sugeridos**: Colombia, Chile, Bolivia, Ecuador, México y promedio OCDE.
- **Software para gráficos**: Stata o Excel (según pautas del curso).
- **Cita APA de fuentes Web** (formato): Instituto Nacional de Estadística e Informática. (2023). *Evolución de la Pobreza Monetaria 2014-2023*. Lima: INEI. Recuperado de [URL]

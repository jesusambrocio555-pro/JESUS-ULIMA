* ============================================================
* RÉPLICA STOCK & WATSON (2001) — BLOQUE 1
* VAR Reducido y Recursivo
* EE.UU. (1960Q1–2025Q4) | Chile (2000Q1–2025Q4)
* ============================================================
* P1.1  Causalidad de Granger (VAR reducido, 4 rezagos)
* P1.2  Ordenamiento de Cholesky — supuestos contemporáneos
* P1.3  Descomposición de Varianza (FEVD) a h = 1, 4, 8, 12
* ============================================================

clear all
set more off
set scheme s2mono          // gráficos en escala de grises (para imprimir)

* ---------- Rutas globales ----------
global path  "C:\Users\51950\Documents\ULIMA\2026_1\Econometria 2\Tarea ee2"
global datos "$path\Datos"
global out   "$path\Output"

capture mkdir "$out"       // crea la carpeta Output si no existe


* ============================================================
* SECCIÓN A — ESTADOS UNIDOS
* Orden Cholesky: π → Desempleo → FFR  (igual que S&W 2001)
* ============================================================

import excel "$datos\fase0_eeuu.xlsx", ///
    sheet("Datos") cellrange(A5) clear

* Las columnas llegan como A–F; renombrar a nombres limpios
rename (A B C D E F) (fecha_str periodo pi desempleo ffr ipc)
destring pi desempleo ffr ipc, replace force
drop if missing(pi)

* Fecha trimestral — los datos arrancan en 1960Q1 y están ordenados
gen     t = tq(1960q1) + (_n - 1)
format  t %tq
tsset   t, quarterly

label var pi        "Inflación 400·ln(P_t/P_{t-1})"
label var desempleo "Tasa de desempleo (%)"
label var ffr       "Federal Funds Rate (%)"

* ------------------------------------------------------------
* P1.1 — Causalidad de Granger
* Reportar la tabla de p-valores del output de vargranger
* ------------------------------------------------------------

display _newline "*** GRANGER — EE.UU. ***"
varsoc pi desempleo ffr
var pi desempleo ffr, lags(1/4)
vargranger

* ------------------------------------------------------------
* P1.3 — IRF + FEVD
* El VAR estimado arriba ya usa el orden π → u → R (Cholesky)
* ------------------------------------------------------------
irf create irf_eeuu, step(12) set("$datos\irf_eeuu") replace

* Tabla FEVD completa (copiar filas h=1,4,8,12 al documento)
display _newline "*** FEVD — EE.UU. ***"
irf table fevd, irf(irf_eeuu) noci

* Gráfico FEVD de la tasa de interés (Panel B.iii de S&W)
irf graph fevd, irf(irf_eeuu) ///
    impulse(pi desempleo ffr) response(ffr) ///
    yline(0) ///
    title("Descomposición de Varianza — Fed Funds Rate (EE.UU.)")
graph export "$out\fevd_ffr_eeuu.png", replace width(1400)

* Gráfico FEVD completo (todas las variables — para el documento)
irf graph fevd, irf(irf_eeuu) yline(0) ///
    title("FEVD — EE.UU.")
graph export "$out\fevd_eeuu_completo.png", replace width(1800)


* ============================================================
* SECCIÓN B — CHILE
* Orden Cholesky: π → Output Gap → TPM
*
* NOTA IMPORTANTE SOBRE SIGNOS:
*   Se usa Output Gap en lugar de Desempleo (informalidad laboral).
*   Un shock contractivo en la TPM REDUCE el output gap (signo –).
*   En S&W el mismo shock AUMENTA el desempleo (signo +).
*   Al comparar IRF con el paper, los signos de "actividad" se invierten.
* ============================================================

import excel "$datos\fase0_chile.xlsx", ///
    sheet("Datos") cellrange(A5) clear

rename (A B C D E F G) (fecha_str periodo pi tpm gap ipc imacec)
destring pi tpm gap ipc imacec, replace force
drop if missing(pi)

gen     t = tq(2000q1) + (_n - 1)
format  t %tq
tsset   t, quarterly

label var pi  "Inflación 400·ln(P_t/P_{t-1})"
label var gap "Output Gap — HP filter λ=1600 sobre IMACEC"
label var tpm "Tasa de Política Monetaria (%)"

* ------------------------------------------------------------
* P1.1 — Causalidad de Granger
* ------------------------------------------------------------
display _newline "*** GRANGER — CHILE ***"
var pi gap tpm, lags(1/4)
vargranger

* ------------------------------------------------------------
* P1.3 — IRF + FEVD
* ------------------------------------------------------------
irf create irf_chile, step(12) set("$datos\irf_chile") replace

display _newline "*** FEVD — CHILE ***"
irf table fevd, irf(irf_chile) noci

* Gráfico FEVD de la TPM
irf graph fevd, irf(irf_chile) ///
    impulse(pi gap tpm) response(tpm) ///
    yline(0) ///
    title("Descomposición de Varianza — TPM (Chile)")
graph export "$out\fevd_tpm_chile.png", replace width(1400)

* Gráfico FEVD completo
irf graph fevd, irf(irf_chile) yline(0) ///
    title("FEVD — Chile")
graph export "$out\fevd_chile_completo.png", replace width(1800)


* ============================================================
* COMPARACIÓN DIRECTA — IRF del shock de tasa de interés
* (útil para anticipar Bloque 3)
* ============================================================

* IRF recursivos de EE.UU.: respuesta de π y u a shock en FFR
irf graph oirf, irf(irf_eeuu) ///
    impulse(ffr) response(pi desempleo ffr) ///
    yline(0) ci ///
    title("IRF — Shock FFR (EE.UU.)")
graph export "$out\irf_shock_ffr_eeuu.png", replace width(1400)

* IRF recursivos de Chile: respuesta de π y gap a shock en TPM
irf graph oirf, irf(irf_chile) ///
    impulse(tpm) response(pi gap tpm) ///
    yline(0) ci ///
    title("IRF — Shock TPM (Chile)")
graph export "$out\irf_shock_tpm_chile.png", replace width(1400)

* ============================================================
* FIN BLOQUE 1
* ============================================================
* Pasos siguientes:
*   - Copiar tablas Granger y FEVD al documento
*   - Discutir P1.2: ¿es el orden Cholesky realista para Chile?
*   - Continuar con bloque2_forecast.do
* ============================================================

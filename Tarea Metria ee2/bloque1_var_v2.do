* ============================================================
* RÉPLICA STOCK & WATSON (2001) — BLOQUE 1 (v2, corregido)
* VAR Reducido y Recursivo
* EE.UU. (1960Q1–2025Q4) | Chile (2000Q1–2025Q4)
* ============================================================
* P1.1  Causalidad de Granger (VAR reducido, 4 rezagos)
* P1.2  Ordenamiento de Cholesky — supuestos contemporáneos
* P1.3  Descomposición de Varianza (FEVD) a h = 1, 4, 8, 12
* ============================================================
* CAMBIOS RESPECTO A v1:
*   - Corregido bug "irfname irf_eeuu not found" al graficar IRF
*     al final (se agrega irf use antes de cada irf graph)
*   - Añadidas pruebas de raíz unitaria Phillips-Perron
*   - Añadida verificación de estabilidad del VAR (varstable)
*   - IRF graficados con bandas de confianza 95% (opción ci)
* ============================================================

* ============================================================
* SECCIÓN A — ESTADOS UNIDOS
* Orden Cholesky: π → Desempleo → FFR  (igual que S&W 2001)
* ============================================================

import excel "$datos\fase0_eeuu.xlsx", ///
    sheet("Datos") cellrange(A5) clear

rename (A B C D E F) (fecha_str periodo pi desempleo ffr ipc)
destring pi desempleo ffr ipc, replace force
drop if missing(pi)

gen    t = tq(1960q1) + (_n - 1)
format t %tq
tsset  t, quarterly

label var pi        "Inflación 400·ln(P_t/P_{t-1})"
label var desempleo "Tasa de desempleo (%)"
label var ffr       "Federal Funds Rate (%)"

* ------------------------------------------------------------
* Pruebas de raíz unitaria Phillips-Perron
* ------------------------------------------------------------
display _newline "*** RAÍZ UNITARIA — EE.UU. ***"
pperron pi,        reg
pperron desempleo, reg
pperron ffr,       reg
*Todas las variables son estacionarias a cualquier nivel de significancia, menos la tasa de los fondos federales de los Estados Unidos, no estacionaria al 5%. 

gen dffr = ffr-l1.ffr
pperron dffr, reg noconstant

*La variable diferenciada es estacionaria a cualquier nivel de significancia. 

* ------------------------------------------------------------
* Selección de rezagos
* ------------------------------------------------------------
varsoc pi desempleo ffr, maxlag(4)

* ------------------------------------------------------------
* P1.1 — VAR(4) y Causalidad de Granger
* ------------------------------------------------------------
var pi desempleo ffr, lags(1/2)
vargranger

* ------------------------------------------------------------
* Estabilidad del VAR
* ------------------------------------------------------------
varstable

* ------------------------------------------------------------
* P1.3 — IRF + FEVD
* ------------------------------------------------------------
irf create irf_eeuu, step(12) set("C:\Users\USER\Desktop\Proyectos Claude\Entra\Tarea ee2\Datos") replace

irf table fevd, noci

* ============================================================
* SECCIÓN B — CHILE
* Orden Cholesky: π → Output Gap → TPM
*
* NOTA SOBRE SIGNOS:
*   Output Gap reemplaza al desempleo por informalidad laboral.
*   Shock contractivo en TPM → REDUCE el gap (signo –).
*   En S&W el mismo shock → AUMENTA desempleo (signo +).
*   Al comparar IRF con el paper, el signo de "actividad" se invierte.
* ============================================================

import excel "$datos\fase0_chile.xlsx", ///
    sheet("Datos") cellrange(A5) clear

rename (A B C D E F G) (fecha_str periodo pi tpm gap ipc imacec)
destring pi tpm gap ipc imacec, replace force
drop if missing(pi)

gen    t = tq(2000q1) + (_n - 1)
format t %tq
tsset  t, quarterly

label var pi    "Inflación 400·ln(P_t/P_{t-1})"
label var gap   "Output Gap — HP filter λ=1600 sobre IMACEC"
label var tpm   "Tasa de Política Monetaria (%)"

* ------------------------------------------------------------
* Pruebas de raíz unitaria Phillips-Perron
* ------------------------------------------------------------
display _newline "*** RAÍZ UNITARIA — CHILE ***"
pperron pi,  reg
pperron gap, reg
pperron tpm, reg
*La variable TPM es significativa al 10%. 

* ------------------------------------------------------------
* Selección de rezagos
* ------------------------------------------------------------
varsoc pi gap tpm, maxlag(4)

* ------------------------------------------------------------
* P1.1 — VAR(4) y Causalidad de Granger
* ------------------------------------------------------------
var pi gap tpm, lags(1/2)
vargranger
*La brecha producto (gap) afecta a lo granger a la inflación. La inflación y la brecha producto (gap) afecta a lo granger a la tasa de interés de política monetaria. 

* ------------------------------------------------------------
* Estabilidad del VAR
* ------------------------------------------------------------
varstable

* ------------------------------------------------------------
* P1.3 — IRF + FEVD
* ------------------------------------------------------------
irf create irf_chile, step(12) set("C:\Users\USER\Desktop\Proyectos Claude\Entra\Tarea ee2\Datos") replace

irf table fevd, irf(irf_chile) noci


* ============================================================
* IRF DEL SHOCK DE TASA DE INTERÉS — con bandas 95%
* FIX: se recarga cada archivo .irf antes de graficar
* ============================================================

* --- EE.UU. ---
irf use "$datos\irf_eeuu"

irf graph oirf, irf(irf_eeuu) ///
    impulse(ffr) response(pi desempleo ffr) ///
    yline(0) ci ///
    title("IRF — Shock FFR (EE.UU.)")
graph export "$out\irf_shock_ffr_eeuu.png", replace width(1400)

* --- Chile ---
irf use "$datos\irf_chile"

irf graph oirf, irf(irf_chile) ///
    impulse(tpm) response(pi gap tpm) ///
    yline(0) ci ///
    title("IRF — Shock TPM (Chile)")
graph export "$out\irf_shock_tpm_chile.png", replace width(1400)


* ============================================================
* FIN BLOQUE 1
* ============================================================
* Resultados a reportar en el documento:
*   - Tabla Granger EE.UU. y Chile (copiar del output de vargranger)
*   - FEVD a h=4 y h=12 para ambos países
*   - Comparar FEVD EE.UU. con Tabla 3 de S&W (2001)
*   - Discutir P1.2: ¿es el orden Cholesky realista para Chile?
*   - Continuar con bloque2_forecast.do
* ============================================================

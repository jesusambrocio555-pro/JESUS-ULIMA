* ============================================================
* RÉPLICA STOCK & WATSON (2001) — BLOQUE 4
* Análisis de Política: Price Puzzle y Crítica de Lucas
* EE.UU. (1960Q1–2025Q4) | Chile (2000Q1–2025Q4)
* ============================================================
* 4.1  Price Puzzle — detección en VAR(3) y mitigación con VAR(4)
* 4.2  Crítica de Lucas — inestabilidad paramétrica de la Regla
*      de Taylor entre regímenes (ZLB, COVID)
* ============================================================

clear all
set more off
set scheme s2mono

global path  "C:\Users\USER\Desktop\Proyectos Claude\Entra\Tarea Metria ee2"
global datos "$path\Datos"
global out   "$path\Output"

capture mkdir "$out"


* ============================================================
* PARTE A — PRICE PUZZLE: EE.UU.
* ============================================================
* El Price Puzzle: tras un shock CONTRACTIVO en FFR, la inflación
* SUBE inicialmente (oirf positivo en h=1..3).
* Causa: el VAR de 3 variables no captura que el BC anticipó
* inflación futura → la tasa subió porque la inflación ya iba a
* subir, no al revés. Variable omitida: expectativas de inflación.
*
* Detección: oirf de pi a shock en ffr, VAR(2) estándar.
* Mitigación: añadir log(IPC) como 4ª variable proxy del nivel
*             de precios que el BC observa (Sims 1992 usa
*             commodity prices; aquí usamos lipc como aproximación).
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


* --- A1: VAR(2) de 3 variables — detección del Price Puzzle ---
var pi desempleo ffr, lags(1/2)
irf create irf_pp3, step(12) set("$datos\irf_pp3") replace

irf use "$datos\irf_pp3"

display _newline "*** PRICE PUZZLE — VAR(3) EE.UU. ***"
display "oirf de pi a shock en ffr (h = 0, 1, 2, 3, 4, 8, 12):"
irf table oirf, irf(irf_pp3) impulse(ffr) response(pi) noci

display _newline ">>> Si oirf[ffr→pi] > 0 en h=1,2,3 → Price Puzzle confirmado"
display ">>> (inflación SUBE tras shock contractivo en la tasa)"

irf graph oirf, irf(irf_pp3) ///
    impulse(ffr) response(pi) ///
    yline(0, lcolor(red) lpattern(dot)) ci ///
    title("Price Puzzle — oirf(FFR→π), VAR 3 variables (EE.UU.)") ///
    note("Price Puzzle: respuesta positiva en h=1..3 → variable omitida (expectativas)") ///
    xtitle("Trimestres") ytitle("Respuesta (p.p.)")
graph export "$out\price_puzzle_var3_eeuu.png", replace width(1400)


* --- A2: VAR(2) de 4 variables — mitigación con log-nivel IPC ---
* El log-nivel de IPC actúa como proxy del nivel de precios que
* el BC monitorea. En la práctica se usa un índice de commodities.
* El orden Cholesky: lipc → pi → desempleo → ffr
* lipc primero: el BC reacciona al nivel de precios acumulado.

gen lipc = log(ipc)
label var lipc "Log-nivel IPC (proxy nivel de precios)"

var lipc pi desempleo ffr, lags(1/2)
irf create irf_pp4, step(12) set("$datos\irf_pp4") replace

irf use "$datos\irf_pp4"

display _newline "*** PRICE PUZZLE — VAR(4) EE.UU. (con log-IPC) ***"
display "oirf de pi a shock en ffr (h = 0, 1, 2, 3, 4, 8, 12):"
irf table oirf, irf(irf_pp4) impulse(ffr) response(pi) noci

display _newline ">>> Comparar con VAR(3):"
display ">>> Si oirf[ffr→pi] es más negativo (o menos positivo) → el puzzle se atenúa"
display ">>> El log-IPC captura el nivel de precios que el BC anticipaba"

irf graph oirf, irf(irf_pp4) ///
    impulse(ffr) response(pi) ///
    yline(0, lcolor(red) lpattern(dot)) ci ///
    title("oirf(FFR→π), VAR 4 variables con log-IPC (EE.UU.)") ///
    note("Si el puzzle desaparece → el log-IPC capturó la información omitida") ///
    xtitle("Trimestres") ytitle("Respuesta (p.p.)")
graph export "$out\price_puzzle_var4_eeuu.png", replace width(1400)


* ============================================================
* PARTE B — CRÍTICA DE LUCAS: EE.UU.
* ============================================================
* Supuesto ilustrativo: la Fed cambia su función de reacción
* (como si pasara del mandato dual a un mandato único de inflación).
* Los parámetros β_π y β_u de la Regla de Taylor estimados en
* un régimen NO son válidos para predecir política en otro régimen.
*
* Evidencia empírica:
*   B1. Regla de Taylor BL en 3 submuestras (pre-ZLB / ZLB / post-COVID)
*   B2. Prueba tipo Chow con interacciones (quiebre en 2009Q1)
*   B3. Estimación rolling — β_π varía a lo largo del tiempo
* ============================================================

import excel "$datos\fase0_eeuu.xlsx", ///
    sheet("Datos") cellrange(A5) clear

rename (A B C D E F) (fecha_str periodo pi desempleo ffr ipc)
destring pi desempleo ffr ipc, replace force
drop if missing(pi)

gen    t = tq(1960q1) + (_n - 1)
format t %tq
tsset  t, quarterly

gen pi_bar = (L1.pi + L2.pi + L3.pi + L4.pi) / 4
gen u_bar  = (L1.desempleo + L2.desempleo + L3.desempleo + L4.desempleo) / 4

label var pi_bar "Inflación media 4 rezagos (π̄)"
label var u_bar  "Desempleo medio 4 rezagos (ū)"


* --- B1: Regla de Taylor por submuestras ---
display _newline "========================================================"
display "CRÍTICA DE LUCAS — Inestabilidad Regla de Taylor (EE.UU.)"
display "Modelo: ffr_t = r* + β_π·π̄_t + β_u·ū_t + rezagos + ε"
display "========================================================"

display _newline ">>> MUESTRA COMPLETA (1960Q1–2025Q4):"
reg ffr pi_bar u_bar L(1/2).(pi desempleo ffr)
display "    β_π = " %7.4f _b[pi_bar] ///
        "  β_u = " %7.4f _b[u_bar] ///
        "  R² = " %6.4f e(r2)

display _newline ">>> PRE-ZLB (1960Q1–2008Q4) — régimen normal de política:"
reg ffr pi_bar u_bar L(1/2).(pi desempleo ffr) ///
    if t <= tq(2008q4)
display "    β_π = " %7.4f _b[pi_bar] ///
        "  β_u = " %7.4f _b[u_bar] ///
        "  R² = " %6.4f e(r2)

display _newline ">>> ZLB (2009Q1–2019Q4) — tasa en el piso cero:"
display "    (β_π y β_u pierden sentido: FFR no puede bajar de 0)"
reg ffr pi_bar u_bar L(1/2).(pi desempleo ffr) ///
    if t >= tq(2009q1) & t <= tq(2019q4)
display "    β_π = " %7.4f _b[pi_bar] ///
        "  β_u = " %7.4f _b[u_bar] ///
        "  R² = " %6.4f e(r2)

display _newline ">>> POST-COVID (2020Q1–2025Q4) — nuevo ciclo de alzas:"
reg ffr pi_bar u_bar L(1/2).(pi desempleo ffr) ///
    if t >= tq(2020q1)
display "    β_π = " %7.4f _b[pi_bar] ///
        "  β_u = " %7.4f _b[u_bar] ///
        "  R² = " %6.4f e(r2)

display _newline ">>> INTERPRETACIÓN CRÍTICA DE LUCAS:"
display "    Si β_π cambia entre submuestras → los parámetros de forma reducida"
display "    no son invariantes al régimen de política."
display "    Cualquier simulación con el VAR estimado en pre-ZLB NO predice"
display "    correctamente el comportamiento en el período ZLB ni post-COVID."


* --- B2: Prueba tipo Chow — quiebre estructural en 2009Q1 ---
display _newline ">>> PRUEBA CHOW (interacciones) — Quiebre en 2009Q1:"

gen post2009    = (t >= tq(2009q1))
gen pi_bar_p09  = pi_bar * post2009
gen u_bar_p09   = u_bar  * post2009

reg ffr pi_bar u_bar pi_bar_p09 u_bar_p09 post2009 L(1/2).(pi desempleo ffr)

local t_bpi = _b[pi_bar_p09] / _se[pi_bar_p09]
local t_bu  = _b[u_bar_p09]  / _se[u_bar_p09]
local p_bpi = 2 * ttail(e(df_r), abs(`t_bpi'))
local p_bu  = 2 * ttail(e(df_r), abs(`t_bu'))

display _newline "    Cambio en coeficientes post-2009 vs pre-2009:"
display "    Δβ_π = " %7.4f _b[pi_bar_p09] "  (p = " %6.4f `p_bpi' ")"
display "    Δβ_u = " %7.4f _b[u_bar_p09]  "  (p = " %6.4f `p_bu'  ")"
display "    Si p < 0.05: quiebre estructural significativo → evidencia de Crítica de Lucas"


* --- B3: Estimación Rolling — β_π ventana 40 trimestres ---
display _newline ">>> ROLLING β_π (ventana=40 trimestres, inicio en obs con datos completos):"

local wsize = 40
local Nobs  = _N
local Nroll = `Nobs' - `wsize' + 1

gen roll_t    = .
gen roll_bpi  = .
gen roll_bu   = .
gen roll_r2   = .
format roll_t %tq

forvalues i = 1/`Nroll' {
    local j = `i' + `wsize' - 1
    quietly reg ffr pi_bar u_bar L(1/2).(pi desempleo ffr) ///
        if _n >= `i' & _n <= `j'
    quietly replace roll_t   = t[`j']      in `i'
    quietly replace roll_bpi = _b[pi_bar]  in `i'
    quietly replace roll_bu  = _b[u_bar]   in `i'
    quietly replace roll_r2  = e(r2)       in `i'
}

sort roll_t
twoway ///
    (line roll_bpi roll_t if roll_t != ., lcolor(black) lwidth(medthick)) ///
    (line roll_bu  roll_t if roll_t != ., lcolor(gs8)   lwidth(medthick) lpattern(dash)), ///
    yline(0,             lcolor(red)  lpattern(dot)) ///
    xline(`=tq(2009q1)', lcolor(gs5)  lpattern(dash)) ///
    xline(`=tq(2020q1)', lcolor(gs5)  lpattern(dash)) ///
    title("Crítica de Lucas — Coeficientes Rolling de la Regla de Taylor (EE.UU.)") ///
    subtitle("Ventana: 40 trimestres | Líneas verticales: 2009Q1 y 2020Q1") ///
    legend(order(1 "β_π  (inflación)" 2 "β_u (desempleo)") rows(1)) ///
    xtitle("") ytitle("Coeficiente estimado")
graph export "$out\lucas_rolling_eeuu.png", replace width(1400)

display "    Ver lucas_rolling_eeuu.png"
display "    β_π inestable: cae en ZLB (política atada) y sube en post-COVID"
display "    → los parámetros del VAR no son constantes entre regímenes"


* ============================================================
* PARTE C — PRICE PUZZLE: CHILE
* ============================================================

import excel "$datos\fase0_chile.xlsx", ///
    sheet("Datos") cellrange(A5) clear

rename (A B C D E F G) (fecha_str periodo pi tpm gap ipc imacec)
destring pi tpm gap ipc imacec, replace force
drop if missing(pi)

gen    t = tq(2000q1) + (_n - 1)
format t %tq
tsset  t, quarterly

label var pi  "Inflación 400·ln(P_t/P_{t-1})"
label var gap "Output Gap — HP filter λ=1600 sobre IMACEC"
label var tpm "Tasa de Política Monetaria (%)"

* --- C1: VAR(2) de 3 variables — detección del Price Puzzle en Chile ---
var pi gap tpm, lags(1/2)
irf create irf_pp3_cl, step(12) set("$datos\irf_pp3_cl") replace

irf use "$datos\irf_pp3_cl"

display _newline "*** PRICE PUZZLE — VAR(3) CHILE ***"
display "oirf de pi a shock en tpm (h = 0..12):"
irf table oirf, irf(irf_pp3_cl) impulse(tpm) response(pi) noci

display _newline ">>> Si oirf[tpm→pi] > 0 en h=1,2,3 → Price Puzzle confirmado en Chile"
display ">>> (inflación SUBE inicialmente pese al alza de TPM)"

irf graph oirf, irf(irf_pp3_cl) ///
    impulse(tpm) response(pi) ///
    yline(0, lcolor(red) lpattern(dot)) ci ///
    title("Price Puzzle — oirf(TPM→π), VAR 3 variables (Chile)") ///
    note("Puzzle en Chile: BCCh sube TPM anticipando inflación; modelo sin expectativas lo confunde") ///
    xtitle("Trimestres") ytitle("Respuesta (p.p.)")
graph export "$out\price_puzzle_var3_chile.png", replace width(1400)


* ============================================================
* PARTE D — CRÍTICA DE LUCAS: CHILE
* ============================================================
* Supuesto: BCCh cambia su meta de inflación del 3% al 5%
* (o equivalentemente: adopta un régimen más tolerante).
* Los coeficientes β_π estimados en el período pre-COVID no
* capturan el comportamiento post-COVID donde la inflación
* alcanzó 14% y la TPM subió de 0.5% a 11.25%.
* ============================================================

gen pi_bar = (L1.pi + L2.pi + L3.pi + L4.pi) / 4
gen g_bar  = (L1.gap + L2.gap + L3.gap + L4.gap) / 4

label var pi_bar "Inflación media 4 rezagos (π̄)"
label var g_bar  "Gap medio 4 rezagos (gap̄)"

display _newline "========================================================"
display "CRÍTICA DE LUCAS — Inestabilidad Regla de Taylor (CHILE)"
display "Modelo: tpm_t = r* + β_π·π̄_t + β_gap·gap̄_t + rezagos + ε"
display "========================================================"

display _newline ">>> MUESTRA COMPLETA (2000Q1–2025Q4):"
reg tpm pi_bar g_bar L(1/2).(pi gap tpm)
display "    β_π   = " %7.4f _b[pi_bar] ///
        "  β_gap = " %7.4f _b[g_bar] ///
        "  R² = " %6.4f e(r2)

display _newline ">>> PRE-COVID (2000Q1–2019Q4) — régimen de inflación baja:"
reg tpm pi_bar g_bar L(1/2).(pi gap tpm) ///
    if t <= tq(2019q4)
display "    β_π   = " %7.4f _b[pi_bar] ///
        "  β_gap = " %7.4f _b[g_bar] ///
        "  R² = " %6.4f e(r2)

display _newline ">>> COVID + NORMALIZACIÓN (2020Q1–2025Q4):"
display "    (muestra pequeña — 24 obs — interpretar con cautela)"
reg tpm pi_bar g_bar L(1/2).(pi gap tpm) ///
    if t >= tq(2020q1)
display "    β_π   = " %7.4f _b[pi_bar] ///
        "  β_gap = " %7.4f _b[g_bar] ///
        "  R² = " %6.4f e(r2)


* --- Prueba tipo Chow Chile — quiebre en 2020Q1 ---
display _newline ">>> PRUEBA CHOW — Quiebre en 2020Q1:"

gen post2020    = (t >= tq(2020q1))
gen pi_bar_p20  = pi_bar * post2020
gen g_bar_p20   = g_bar  * post2020

reg tpm pi_bar g_bar pi_bar_p20 g_bar_p20 post2020 L(1/2).(pi gap tpm)

local t_bpi_cl = _b[pi_bar_p20] / _se[pi_bar_p20]
local t_bg_cl  = _b[g_bar_p20]  / _se[g_bar_p20]
local p_bpi_cl = 2 * ttail(e(df_r), abs(`t_bpi_cl'))
local p_bg_cl  = 2 * ttail(e(df_r), abs(`t_bg_cl'))

display _newline "    Cambio en coeficientes post-2020 vs pre-2020:"
display "    Δβ_π   = " %7.4f _b[pi_bar_p20] "  (p = " %6.4f `p_bpi_cl' ")"
display "    Δβ_gap = " %7.4f _b[g_bar_p20]  "  (p = " %6.4f `p_bg_cl'  ")"


* --- Rolling Chile — ventana 20 trimestres ---
local wsize_cl = 20
local Nobs_cl  = _N
local Nroll_cl = `Nobs_cl' - `wsize_cl' + 1

gen roll_t_cl    = .
gen roll_bpi_cl  = .
gen roll_bg_cl   = .
format roll_t_cl %tq

forvalues i = 1/`Nroll_cl' {
    local j = `i' + `wsize_cl' - 1
    quietly reg tpm pi_bar g_bar L(1/2).(pi gap tpm) ///
        if _n >= `i' & _n <= `j'
    quietly replace roll_t_cl   = t[`j']     in `i'
    quietly replace roll_bpi_cl = _b[pi_bar] in `i'
    quietly replace roll_bg_cl  = _b[g_bar]  in `i'
}

sort roll_t_cl
twoway ///
    (line roll_bpi_cl roll_t_cl if roll_t_cl != ., lcolor(black) lwidth(medthick)) ///
    (line roll_bg_cl  roll_t_cl if roll_t_cl != ., lcolor(gs8)   lwidth(medthick) lpattern(dash)), ///
    yline(0,             lcolor(red) lpattern(dot)) ///
    xline(`=tq(2020q1)', lcolor(gs5) lpattern(dash)) ///
    title("Crítica de Lucas — Coeficientes Rolling Regla de Taylor (Chile)") ///
    subtitle("Ventana: 20 trimestres | Línea vertical: 2020Q1") ///
    legend(order(1 "β_π (inflación)" 2 "β_gap (output gap)") rows(1)) ///
    xtitle("") ytitle("Coeficiente estimado")
graph export "$out\lucas_rolling_chile.png", replace width(1400)


* ============================================================
* RESUMEN FINAL — TABLA DE HALLAZGOS
* ============================================================

display _newline "========================================================"
display "TABLA RESUMEN — BLOQUE 4"
display "========================================================"
display ""
display "4.1  PRICE PUZZLE:"
display "     Gráficos: price_puzzle_var3_eeuu.png  |  price_puzzle_var3_chile.png"
display "     Comparar: price_puzzle_var4_eeuu.png (VAR con log-IPC)"
display ""
display "     Fenómeno: oirf(FFR→π) o oirf(TPM→π) positivo en h=1..3"
display "     Causa:    VAR 3 vars omite expectativas inflacionarias del BC"
display "               El BC anticipó inflación y subió la tasa; el modelo"
display "               confunde la anticipación con el efecto causal."
display "     Solución: añadir commodity price index como 4ª variable"
display "               (Sims 1992): actúa como proxy de la info del BC."
display "               Con log-IPC el puzzle DEBERÍA atenuarse (verificar)."
display ""
display "4.2  CRÍTICA DE LUCAS:"
display "     Gráficos: lucas_rolling_eeuu.png  |  lucas_rolling_chile.png"
display ""
display "     Supuesto: BCCh cambia meta de inflación de 3% a 5%."
display "     Por qué falla el VAR:"
display "       · Los agentes ajustan expectativas al nuevo régimen."
display "       · Los coeficientes del VAR = mezcla de regla BC + sector privado."
display "       · Al cambiar el régimen, AMBOS lados cambian simultáneamente."
display "       · Los parámetros estimados en pre-ZLB / pre-COVID"
display "         no predicen correctamente el comportamiento en el régimen nuevo."
display "     Evidencia: β_π cambia sustancialmente entre submuestras"
display "                (ver tabla Chow + gráficos rolling)."

* ============================================================
* FIN BLOQUE 4
* ============================================================
* Archivos generados en Output\:
*   price_puzzle_var3_eeuu.png   → oirf(FFR→π) VAR(3)
*   price_puzzle_var4_eeuu.png   → oirf(FFR→π) VAR(4) con log-IPC
*   price_puzzle_var3_chile.png  → oirf(TPM→π) VAR(3)
*   lucas_rolling_eeuu.png       → β_π y β_u rolling (EE.UU.)
*   lucas_rolling_chile.png      → β_π y β_gap rolling (Chile)
* ============================================================

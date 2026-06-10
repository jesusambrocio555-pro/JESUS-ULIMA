* ============================================================
* RÉPLICA STOCK & WATSON (2001) — BLOQUE 2
* Forecasting Pseudo Out-of-Sample
* EE.UU. (1960Q1–2025Q4) | Chile (2000Q1–2025Q4)
* ============================================================
* Metodología:
*   Ventana de evaluación : últimos 16 trimestres (2022Q1–2025Q4)
*   Horizontes            : h = 2, 4, 8 trimestres
*   Modelos               : Random Walk | AR(2) | VAR(2)
*   Estimación            : ventana expandida (recursive window)
*   Métrica               : RMSE absoluto y relativo al AR(2)
* ============================================================
* NOTA: se usan 2 rezagos (lags 1/2) consistente con Bloque 1
* ============================================================

clear all
set more off

global path  "C:\Users\USER\Desktop\Proyectos Claude\Entra\Tarea ee2"
global datos "$path\Datos"
global out   "$path\Output"

capture mkdir "$out"


* ============================================================
* SECCIÓN A — ESTADOS UNIDOS
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

* ---- Ventana de evaluación ----
local Tfull = _N                        // 264
local Teval = 16
local Tini  = `Tfull' - `Teval' + 1    // 249 = 2022Q1

display _newline "*** EE.UU. — VENTANA DE EVALUACIÓN ***"
display "Obs `Tini' (`=string(tq(1960q1)+`Tini'-1, "%tq")') " ///
        "a `Tfull' (`=string(tq(1960q1)+`Tfull'-1, "%tq")')"

* ---- Valores reales futuros (antes de tsappend) ----
* pi_real_h`h'[s] = inflación real en el período s+h
foreach h in 2 4 8 {
    gen pi_real_h`h' = F`h'.pi
}

* ---- Ampliar dataset para que fcast pueda operar en el último período ----
tsappend, add(8)

* ---- Variables para almacenar pronósticos ----
foreach m in rw ar var {
    foreach h in 2 4 8 {
        gen pi_`m'_h`h' = .
    }
}

* ---- Loop recursivo ----
* En cada s: estimar con datos 1..s, pronosticar pi en s+h
display _newline "Corriendo loop recursivo EE.UU. (16 iteraciones)..."

forvalues s = `Tini'/`Tfull' {

    * ---- Random Walk: E_t[pi_{t+h}] = pi_t ----
    foreach h in 2 4 8 {
        quietly replace pi_rw_h`h' = pi[`s'] in `s'
    }

    * ---- AR(2): pronóstico iterado (cadena hacia adelante) ----
    quietly reg pi L(1/2).pi if _n <= `s'
    local b0 = _b[_cons]
    local b1 = _b[L1.pi]
    local b2 = _b[L2.pi]

    local f1 = `b0' + `b1'*pi[`s']   + `b2'*pi[`s'-1]
    local f2 = `b0' + `b1'*`f1'      + `b2'*pi[`s']
    local f3 = `b0' + `b1'*`f2'      + `b2'*`f1'
    local f4 = `b0' + `b1'*`f3'      + `b2'*`f2'
    local f5 = `b0' + `b1'*`f4'      + `b2'*`f3'
    local f6 = `b0' + `b1'*`f5'      + `b2'*`f4'
    local f7 = `b0' + `b1'*`f6'      + `b2'*`f5'
    local f8 = `b0' + `b1'*`f7'      + `b2'*`f6'

    quietly replace pi_ar_h2 = `f2' in `s'
    quietly replace pi_ar_h4 = `f4' in `s'
    quietly replace pi_ar_h8 = `f8' in `s'

    * ---- VAR(2): pronóstico iterado vía fcast compute ----
    quietly var pi desempleo ffr if _n <= `s', lags(1/2)
    quietly fcast compute _fv`s'_, step(8) replace

    quietly replace pi_var_h2 = _fv`s'_pi[`s'+2] in `s'
    quietly replace pi_var_h4 = _fv`s'_pi[`s'+4] in `s'
    quietly replace pi_var_h8 = _fv`s'_pi[`s'+8] in `s'

    cap drop _fv`s'_*
}

* ---- Volver a obs originales ----
keep if _n <= `Tfull'

* ---- RMSE: matriz 3 modelos × 3 horizontes ----
matrix RMSE_A = J(3, 3, .)
matrix rownames RMSE_A = RW AR2 VAR2
matrix colnames RMSE_A = h2 h4 h8

local row = 0
foreach m in rw ar var {
    local row = `row' + 1
    local col = 0
    foreach h in 2 4 8 {
        local col = `col' + 1
        quietly gen _sq = (pi_real_h`h' - pi_`m'_h`h')^2 ///
            if _n >= `Tini' & pi_real_h`h' != .
        quietly sum _sq
        matrix RMSE_A[`row', `col'] = sqrt(r(mean))
        drop _sq
    }
}

display _newline "*** RMSE ABSOLUTO — EE.UU. ***"
matrix list RMSE_A, format(%8.4f)

* Ratios respecto al AR(2) — fila 2 es AR2
matrix RATIO_A = RMSE_A
forvalues r = 1/3 {
    forvalues c = 1/3 {
        matrix RATIO_A[`r', `c'] = RMSE_A[`r', `c'] / RMSE_A[2, `c']
    }
}
display _newline "*** RMSE RELATIVO AL AR(2) — EE.UU.  [ratio < 1 = supera al AR] ***"
matrix list RATIO_A, format(%8.4f)

* ---- Gráfico: pronósticos h=4 vs valor real ----
* pi_rw_h4[s] = pronóstico hecho en s para s+4; pi_real_h4[s] = real en s+4
twoway (tsline pi_real_h4 if _n >= `Tini', lcolor(black)  lwidth(medthick)) ///
       (tsline pi_rw_h4   if _n >= `Tini', lcolor(gs10)   lpattern(dash)) ///
       (tsline pi_ar_h4   if _n >= `Tini', lcolor(gs6)    lpattern(dot)) ///
       (tsline pi_var_h4  if _n >= `Tini', lcolor(gs3)    lpattern(shortdash_dot)), ///
    title("Pronóstico a h=4 vs Valor Real — EE.UU.") ///
    note("Eje t = período origen del pronóstico; valor real = pi_{t+4}") ///
    legend(order(1 "Real (t+4)" 2 "RW" 3 "AR(2)" 4 "VAR(2)")) ///
    ytitle("Inflación anualizada (%)") xtitle("")
graph export "$out\forecast_eeuu_h4.png", replace width(1400)


* ============================================================
* SECCIÓN B — CHILE
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

* ---- Ventana de evaluación ----
local Tfull = _N                        // 104
local Teval = 16
local Tini  = `Tfull' - `Teval' + 1    // 89 = 2022Q1

display _newline "*** CHILE — VENTANA DE EVALUACIÓN ***"
display "Obs `Tini' (`=string(tq(2000q1)+`Tini'-1, "%tq")') " ///
        "a `Tfull' (`=string(tq(2000q1)+`Tfull'-1, "%tq")')"

* ---- Valores reales futuros ----
foreach h in 2 4 8 {
    gen pi_real_h`h' = F`h'.pi
}

* ---- Ampliar dataset ----
tsappend, add(8)

* ---- Variables de pronóstico ----
foreach m in rw ar var {
    foreach h in 2 4 8 {
        gen pi_`m'_h`h' = .
    }
}

* ---- Loop recursivo ----
display _newline "Corriendo loop recursivo Chile (16 iteraciones)..."

forvalues s = `Tini'/`Tfull' {

    * -- Random Walk --
    foreach h in 2 4 8 {
        quietly replace pi_rw_h`h' = pi[`s'] in `s'
    }

    * -- AR(2): pronóstico iterado --
    quietly reg pi L(1/2).pi if _n <= `s'
    local b0 = _b[_cons]
    local b1 = _b[L1.pi]
    local b2 = _b[L2.pi]

    local f1 = `b0' + `b1'*pi[`s']   + `b2'*pi[`s'-1]
    local f2 = `b0' + `b1'*`f1'      + `b2'*pi[`s']
    local f3 = `b0' + `b1'*`f2'      + `b2'*`f1'
    local f4 = `b0' + `b1'*`f3'      + `b2'*`f2'
    local f5 = `b0' + `b1'*`f4'      + `b2'*`f3'
    local f6 = `b0' + `b1'*`f5'      + `b2'*`f4'
    local f7 = `b0' + `b1'*`f6'      + `b2'*`f5'
    local f8 = `b0' + `b1'*`f7'      + `b2'*`f6'

    quietly replace pi_ar_h2 = `f2' in `s'
    quietly replace pi_ar_h4 = `f4' in `s'
    quietly replace pi_ar_h8 = `f8' in `s'

    * -- VAR(2): fcast compute --
    quietly var pi gap tpm if _n <= `s', lags(1/2)
    quietly fcast compute _fv`s'_, step(8) replace

    quietly replace pi_var_h2 = _fv`s'_pi[`s'+2] in `s'
    quietly replace pi_var_h4 = _fv`s'_pi[`s'+4] in `s'
    quietly replace pi_var_h8 = _fv`s'_pi[`s'+8] in `s'

    cap drop _fv`s'_*
}

* ---- Volver a obs originales ----
keep if _n <= `Tfull'

* ---- RMSE ----
matrix RMSE_B = J(3, 3, .)
matrix rownames RMSE_B = RW AR2 VAR2
matrix colnames RMSE_B = h2 h4 h8

local row = 0
foreach m in rw ar var {
    local row = `row' + 1
    local col = 0
    foreach h in 2 4 8 {
        local col = `col' + 1
        quietly gen _sq = (pi_real_h`h' - pi_`m'_h`h')^2 ///
            if _n >= `Tini' & pi_real_h`h' != .
        quietly sum _sq
        matrix RMSE_B[`row', `col'] = sqrt(r(mean))
        drop _sq
    }
}

display _newline "*** RMSE ABSOLUTO — CHILE ***"
matrix list RMSE_B, format(%8.4f)

matrix RATIO_B = RMSE_B
forvalues r = 1/3 {
    forvalues c = 1/3 {
        matrix RATIO_B[`r', `c'] = RMSE_B[`r', `c'] / RMSE_B[2, `c']
    }
}
display _newline "*** RMSE RELATIVO AL AR(2) — CHILE  [ratio < 1 = supera al AR] ***"
matrix list RATIO_B, format(%8.4f)

* ---- Gráfico h=4 ----
twoway (tsline pi_real_h4 if _n >= `Tini', lcolor(black)  lwidth(medthick)) ///
       (tsline pi_rw_h4   if _n >= `Tini', lcolor(gs10)   lpattern(dash)) ///
       (tsline pi_ar_h4   if _n >= `Tini', lcolor(gs6)    lpattern(dot)) ///
       (tsline pi_var_h4  if _n >= `Tini', lcolor(gs3)    lpattern(shortdash_dot)), ///
    title("Pronóstico a h=4 vs Valor Real — Chile") ///
    note("Eje t = período origen del pronóstico; valor real = pi_{t+4}") ///
    legend(order(1 "Real (t+4)" 2 "RW" 3 "AR(2)" 4 "VAR(2)")) ///
    ytitle("Inflación anualizada (%)") xtitle("")
graph export "$out\forecast_chile_h4.png", replace width(1400)


* ============================================================
* RESUMEN COMPARATIVO (para copiar al documento)
* ============================================================
display _newline "========================================================"
display "TABLA RESUMEN — RMSE ABSOLUTO"
display "========================================================"
display _newline "EE.UU. (1960Q1–2025Q4, ventana eval: 2022Q1–2025Q4):"
matrix list RMSE_A, format(%8.4f)
display _newline "Chile (2000Q1–2025Q4, ventana eval: 2022Q1–2025Q4):"
matrix list RMSE_B, format(%8.4f)

display _newline "========================================================"
display "TABLA RESUMEN — RMSE / RMSE_AR(2)  [S&W Tabla 2]"
display "  Interpretación: ratio < 1 → modelo supera al AR(2)"
display "========================================================"
display _newline "EE.UU.:"
matrix list RATIO_A, format(%8.4f)
display _newline "Chile:"
matrix list RATIO_B, format(%8.4f)

* ============================================================
* FIN BLOQUE 2
* ============================================================
* Resultado esperado (S&W 2001):
*   VAR NO mejora consistentemente sobre AR univariado.
*   Posible leve ventaja a horizontes cortos (h=2) para la tasa.
*   Si RATIO_A[3,1] < 1 en h=2 para EE.UU. → confirma S&W.
* ============================================================

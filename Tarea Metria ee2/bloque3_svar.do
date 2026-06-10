* ============================================================
* RÉPLICA STOCK & WATSON (2001) — BLOQUE 3
* Inferencia Estructural: Reglas de Taylor y Proyecciones Locales
* EE.UU. (1960Q1–2025Q4) | Chile (2000Q1–2025Q4)
* ============================================================
* 3.1  Shock Backward-Looking: residuo de la regla de Taylor
*      sobre promedios de 4 rezagos de π y actividad
* 3.2  Shock Forward-Looking: residuo de la regla de Taylor
*      sobre pronósticos directos de π y actividad a h=4
*      (proyección de F4.y sobre el conjunto de info en t)
* 3.3  IRF via Proyecciones Locales (Jordà 2005), h = 0..12
*      y_{t+h} = α + β_h·shock_t + Σ γ_j·X_{t-j} + ν_{t+h}
* 3.4  Comparación gráfica BL vs FL — ambos países
* ============================================================

clear all
set more off
set scheme s2mono

global path  "C:\Users\USER\Desktop\Proyectos Claude\Entra\Tarea Metria ee2"
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

gen    t = tq(1960q1) + _n-1
format t %tq
tsset  t, quarterly

label var pi        "Inflación 400·ln(P_t/P_{t-1})"
label var desempleo "Tasa de desempleo (%)"
label var ffr       "Federal Funds Rate (%)"


* ------------------------------------------------------------
* 3.1  SHOCK BACKWARD-LOOKING — EE.UU.
* ------------------------------------------------------------

gen pi_bar = (L1.pi + L2.pi + L3.pi + L4.pi) / 4
gen u_bar  = (L1.desempleo + L2.desempleo + L3.desempleo + L4.desempleo) /4

reg ffr pi_bar u_bar L(1/2).(pi desempleo ffr)
predict shock_bl_eeuu, resid

display _newline ">>> Regla BL — EE.UU."
display "β_π  = " %8.4f _b[pi_bar]  "   (principio Taylor: esperado > 0)"
display "β_u  = " %8.4f _b[u_bar]   "   (mandato dual Fed: esperado < 0)"
display "R²   = " %8.4f e(r2)


* ------------------------------------------------------------
* 3.2  SHOCK FORWARD-LOOKING — EE.UU.
*      E_t[π_{t+4}] = fitted de proyectar F4.π sobre info set t
*      E_t[u_{t+4}] = ídem para desempleo
* ------------------------------------------------------------

reg F4.pi        L(1/2).(pi desempleo ffr)
predict epi4_eeuu, xb

reg F4.desempleo L(1/2).(pi desempleo ffr)
predict eu4_eeuu,  xb

reg ffr epi4_eeuu eu4_eeuu L(1/2).(pi desempleo ffr)
predict shock_fl_eeuu, resid

display _newline ">>> Regla FL — EE.UU."
display "β_Eπ = " %8.4f _b[epi4_eeuu]  "   (principio Taylor activo si > 1)"
display "β_Eu = " %8.4f _b[eu4_eeuu]   "   (mandato dual Fed: esperado < 0)"
display "R²   = " %8.4f e(r2)


* ------------------------------------------------------------
* 3.3  PROYECCIONES LOCALES — EE.UU.
* ------------------------------------------------------------

matrix irf_bl_pi_A  = J(13, 3, .)
matrix irf_bl_u_A   = J(13, 3, .)
matrix irf_bl_ffr_A = J(13, 3, .)
matrix irf_fl_pi_A  = J(13, 3, .)
matrix irf_fl_u_A   = J(13, 3, .)
matrix irf_fl_ffr_A = J(13, 3, .)

forvalues h = 0/12 {
    local r = `h' + 1

    quietly reg F`h'.pi        shock_bl_eeuu L(1/2).(pi desempleo ffr)
    matrix irf_bl_pi_A[`r',1]  = `h'
    matrix irf_bl_pi_A[`r',2]  = _b[shock_bl_eeuu]
    matrix irf_bl_pi_A[`r',3]  = _se[shock_bl_eeuu]

    quietly reg F`h'.desempleo shock_bl_eeuu L(1/2).(pi desempleo ffr)
    matrix irf_bl_u_A[`r',1]   = `h'
    matrix irf_bl_u_A[`r',2]   = _b[shock_bl_eeuu]
    matrix irf_bl_u_A[`r',3]   = _se[shock_bl_eeuu]

    quietly reg F`h'.ffr       shock_bl_eeuu L(1/2).(pi desempleo ffr)
    matrix irf_bl_ffr_A[`r',1] = `h'
    matrix irf_bl_ffr_A[`r',2] = _b[shock_bl_eeuu]
    matrix irf_bl_ffr_A[`r',3] = _se[shock_bl_eeuu]

    quietly reg F`h'.pi        shock_fl_eeuu L(1/2).(pi desempleo ffr)
    matrix irf_fl_pi_A[`r',1]  = `h'
    matrix irf_fl_pi_A[`r',2]  = _b[shock_fl_eeuu]
    matrix irf_fl_pi_A[`r',3]  = _se[shock_fl_eeuu]

    quietly reg F`h'.desempleo shock_fl_eeuu L(1/2).(pi desempleo ffr)
    matrix irf_fl_u_A[`r',1]   = `h'
    matrix irf_fl_u_A[`r',2]   = _b[shock_fl_eeuu]
    matrix irf_fl_u_A[`r',3]   = _se[shock_fl_eeuu]

    quietly reg F`h'.ffr       shock_fl_eeuu L(1/2).(pi desempleo ffr)
    matrix irf_fl_ffr_A[`r',1] = `h'
    matrix irf_fl_ffr_A[`r',2] = _b[shock_fl_eeuu]
    matrix irf_fl_ffr_A[`r',3] = _se[shock_fl_eeuu]
}

display _newline "*** LP — BL SHOCK — EE.UU. (β_h a h=0,4,8,12) ***"
display "h     π           u           FFR"
foreach h in 0 4 8 12 {
    local r = `h' + 1
    display %2.0f `h' "   " %9.4f irf_bl_pi_A[`r',2] ///
            "   " %9.4f irf_bl_u_A[`r',2] ///
            "   " %9.4f irf_bl_ffr_A[`r',2]
}

display _newline "*** LP — FL SHOCK — EE.UU. (β_h a h=0,4,8,12) ***"
display "h     π           u           FFR"
foreach h in 0 4 8 12 {
    local r = `h' + 1
    display %2.0f `h' "   " %9.4f irf_fl_pi_A[`r',2] ///
            "   " %9.4f irf_fl_u_A[`r',2] ///
            "   " %9.4f irf_fl_ffr_A[`r',2]
}


* Gráficos LP — EE.UU.
preserve
    clear
    set obs 13
    gen h = _n - 1

    foreach v in bl_pi bl_u bl_ffr fl_pi fl_u fl_ffr {
        gen `v'    = .
        gen `v'_lo = .
        gen `v'_hi = .
    }

    forvalues r = 1/13 {
        quietly replace bl_pi    = irf_bl_pi_A[`r',2]                                in `r'
        quietly replace bl_pi_lo = irf_bl_pi_A[`r',2] - 1.96*irf_bl_pi_A[`r',3]    in `r'
        quietly replace bl_pi_hi = irf_bl_pi_A[`r',2] + 1.96*irf_bl_pi_A[`r',3]    in `r'
        quietly replace bl_u     = irf_bl_u_A[`r',2]                                 in `r'
        quietly replace bl_u_lo  = irf_bl_u_A[`r',2]  - 1.96*irf_bl_u_A[`r',3]     in `r'
        quietly replace bl_u_hi  = irf_bl_u_A[`r',2]  + 1.96*irf_bl_u_A[`r',3]     in `r'
        quietly replace bl_ffr   = irf_bl_ffr_A[`r',2]                               in `r'
        quietly replace bl_ffr_lo = irf_bl_ffr_A[`r',2] - 1.96*irf_bl_ffr_A[`r',3] in `r'
        quietly replace bl_ffr_hi = irf_bl_ffr_A[`r',2] + 1.96*irf_bl_ffr_A[`r',3] in `r'
        quietly replace fl_pi    = irf_fl_pi_A[`r',2]                                in `r'
        quietly replace fl_pi_lo = irf_fl_pi_A[`r',2] - 1.96*irf_fl_pi_A[`r',3]    in `r'
        quietly replace fl_pi_hi = irf_fl_pi_A[`r',2] + 1.96*irf_fl_pi_A[`r',3]    in `r'
        quietly replace fl_u     = irf_fl_u_A[`r',2]                                 in `r'
        quietly replace fl_u_lo  = irf_fl_u_A[`r',2]  - 1.96*irf_fl_u_A[`r',3]     in `r'
        quietly replace fl_u_hi  = irf_fl_u_A[`r',2]  + 1.96*irf_fl_u_A[`r',3]     in `r'
        quietly replace fl_ffr   = irf_fl_ffr_A[`r',2]                               in `r'
        quietly replace fl_ffr_lo = irf_fl_ffr_A[`r',2] - 1.96*irf_fl_ffr_A[`r',3] in `r'
        quietly replace fl_ffr_hi = irf_fl_ffr_A[`r',2] + 1.96*irf_fl_ffr_A[`r',3] in `r'
    }

    twoway ///
        (rarea bl_pi_lo bl_pi_hi h, color(gs12) fintensity(50)) ///
        (rarea fl_pi_lo fl_pi_hi h, color(ltblue) fintensity(30)) ///
        (line bl_pi h, lcolor(black) lwidth(medthick)) ///
        (line fl_pi h, lcolor(navy)  lwidth(medthick) lpattern(dash)), ///
        yline(0, lcolor(red) lpattern(dot)) ///
        title("IRF Inflación — Shock FFR (EE.UU.)") ///
        subtitle("Proyecciones Locales: Backward-Looking vs Forward-Looking") ///
        legend(order(3 "Backward-Looking" 4 "Forward-Looking") rows(1)) ///
        xtitle("Trimestres") ytitle("Respuesta (p.p.)") xlabel(0(2)12)
    graph export "$out\lp_pi_eeuu.png", replace width(1400)

    twoway ///
        (rarea bl_u_lo bl_u_hi h, color(gs12) fintensity(50)) ///
        (rarea fl_u_lo fl_u_hi h, color(ltblue) fintensity(30)) ///
        (line bl_u h, lcolor(black) lwidth(medthick)) ///
        (line fl_u h, lcolor(navy)  lwidth(medthick) lpattern(dash)), ///
        yline(0, lcolor(red) lpattern(dot)) ///
        title("IRF Desempleo — Shock FFR (EE.UU.)") ///
        subtitle("Proyecciones Locales: Backward-Looking vs Forward-Looking") ///
        legend(order(3 "Backward-Looking" 4 "Forward-Looking") rows(1)) ///
        xtitle("Trimestres") ytitle("Respuesta (p.p.)") xlabel(0(2)12)
    graph export "$out\lp_u_eeuu.png", replace width(1400)

    twoway ///
        (rarea bl_ffr_lo bl_ffr_hi h, color(gs12) fintensity(50)) ///
        (rarea fl_ffr_lo fl_ffr_hi h, color(ltblue) fintensity(30)) ///
        (line bl_ffr h, lcolor(black) lwidth(medthick)) ///
        (line fl_ffr h, lcolor(navy)  lwidth(medthick) lpattern(dash)), ///
        yline(0, lcolor(red) lpattern(dot)) ///
        title("IRF FFR — Shock FFR (EE.UU.)") ///
        subtitle("Proyecciones Locales: Backward-Looking vs Forward-Looking") ///
        legend(order(3 "Backward-Looking" 4 "Forward-Looking") rows(1)) ///
        xtitle("Trimestres") ytitle("Respuesta (p.p.)") xlabel(0(2)12)
    graph export "$out\lp_ffr_eeuu.png", replace width(1400)

restore


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


* ------------------------------------------------------------
* 3.1  SHOCK BACKWARD-LOOKING — CHILE
* ------------------------------------------------------------

gen pi_bar = (L1.pi + L2.pi + L3.pi + L4.pi) / 4
gen g_bar  = (L1.gap + L2.gap + L3.gap + L4.gap) / 4

reg tpm pi_bar g_bar L(1/2).(pi gap tpm)
predict shock_bl_cl, resid

display _newline ">>> Regla BL — CHILE"
display "β_π   = " %8.4f _b[pi_bar]  "   (BCCh: mandato casi único de inflación)"
display "β_gap = " %8.4f _b[g_bar]   "   (esperado > 0; menor peso que en EE.UU.)"
display "R²    = " %8.4f e(r2)


* ------------------------------------------------------------
* 3.2  SHOCK FORWARD-LOOKING — CHILE
* ------------------------------------------------------------

reg F4.pi  L(1/2).(pi gap tpm)
predict epi4_cl, xb

reg F4.gap L(1/2).(pi gap tpm)
predict eg4_cl,  xb

reg tpm epi4_cl eg4_cl L(1/2).(pi gap tpm)
predict shock_fl_cl, resid

display _newline ">>> Regla FL — CHILE"
display "β_Eπ   = " %8.4f _b[epi4_cl]  "   (principio Taylor activo si > 1)"
display "β_Egap = " %8.4f _b[eg4_cl]   "   (política anticipatoria de actividad)"
display "R²     = " %8.4f e(r2)


* ------------------------------------------------------------
* 3.3  PROYECCIONES LOCALES — CHILE
* ------------------------------------------------------------

matrix irf_bl_pi_B  = J(13, 3, .)
matrix irf_bl_g_B   = J(13, 3, .)
matrix irf_bl_tpm_B = J(13, 3, .)
matrix irf_fl_pi_B  = J(13, 3, .)
matrix irf_fl_g_B   = J(13, 3, .)
matrix irf_fl_tpm_B = J(13, 3, .)

forvalues h = 0/12 {
    local r = `h' + 1

    quietly reg F`h'.pi  shock_bl_cl L(1/2).(pi gap tpm)
    matrix irf_bl_pi_B[`r',1]  = `h'
    matrix irf_bl_pi_B[`r',2]  = _b[shock_bl_cl]
    matrix irf_bl_pi_B[`r',3]  = _se[shock_bl_cl]

    quietly reg F`h'.gap shock_bl_cl L(1/2).(pi gap tpm)
    matrix irf_bl_g_B[`r',1]   = `h'
    matrix irf_bl_g_B[`r',2]   = _b[shock_bl_cl]
    matrix irf_bl_g_B[`r',3]   = _se[shock_bl_cl]

    quietly reg F`h'.tpm shock_bl_cl L(1/2).(pi gap tpm)
    matrix irf_bl_tpm_B[`r',1] = `h'
    matrix irf_bl_tpm_B[`r',2] = _b[shock_bl_cl]
    matrix irf_bl_tpm_B[`r',3] = _se[shock_bl_cl]

    quietly reg F`h'.pi  shock_fl_cl L(1/2).(pi gap tpm)
    matrix irf_fl_pi_B[`r',1]  = `h'
    matrix irf_fl_pi_B[`r',2]  = _b[shock_fl_cl]
    matrix irf_fl_pi_B[`r',3]  = _se[shock_fl_cl]

    quietly reg F`h'.gap shock_fl_cl L(1/2).(pi gap tpm)
    matrix irf_fl_g_B[`r',1]   = `h'
    matrix irf_fl_g_B[`r',2]   = _b[shock_fl_cl]
    matrix irf_fl_g_B[`r',3]   = _se[shock_fl_cl]

    quietly reg F`h'.tpm shock_fl_cl L(1/2).(pi gap tpm)
    matrix irf_fl_tpm_B[`r',1] = `h'
    matrix irf_fl_tpm_B[`r',2] = _b[shock_fl_cl]
    matrix irf_fl_tpm_B[`r',3] = _se[shock_fl_cl]
}

display _newline "*** LP — BL SHOCK — CHILE (β_h a h=0,4,8,12) ***"
display "h     π           gap         TPM"
foreach h in 0 4 8 12 {
    local r = `h' + 1
    display %2.0f `h' "   " %9.4f irf_bl_pi_B[`r',2] ///
            "   " %9.4f irf_bl_g_B[`r',2] ///
            "   " %9.4f irf_bl_tpm_B[`r',2]
}

display _newline "*** LP — FL SHOCK — CHILE (β_h a h=0,4,8,12) ***"
display "h     π           gap         TPM"
foreach h in 0 4 8 12 {
    local r = `h' + 1
    display %2.0f `h' "   " %9.4f irf_fl_pi_B[`r',2] ///
            "   " %9.4f irf_fl_g_B[`r',2] ///
            "   " %9.4f irf_fl_tpm_B[`r',2]
}


* Gráficos LP — Chile
preserve
    clear
    set obs 13
    gen h = _n - 1

    foreach v in bl_pi bl_g bl_tpm fl_pi fl_g fl_tpm {
        gen `v'    = .
        gen `v'_lo = .
        gen `v'_hi = .
    }

    forvalues r = 1/13 {
        quietly replace bl_pi     = irf_bl_pi_B[`r',2]                                 in `r'
        quietly replace bl_pi_lo  = irf_bl_pi_B[`r',2]  - 1.96*irf_bl_pi_B[`r',3]    in `r'
        quietly replace bl_pi_hi  = irf_bl_pi_B[`r',2]  + 1.96*irf_bl_pi_B[`r',3]    in `r'
        quietly replace bl_g      = irf_bl_g_B[`r',2]                                  in `r'
        quietly replace bl_g_lo   = irf_bl_g_B[`r',2]   - 1.96*irf_bl_g_B[`r',3]     in `r'
        quietly replace bl_g_hi   = irf_bl_g_B[`r',2]   + 1.96*irf_bl_g_B[`r',3]     in `r'
        quietly replace bl_tpm    = irf_bl_tpm_B[`r',2]                                in `r'
        quietly replace bl_tpm_lo = irf_bl_tpm_B[`r',2] - 1.96*irf_bl_tpm_B[`r',3]   in `r'
        quietly replace bl_tpm_hi = irf_bl_tpm_B[`r',2] + 1.96*irf_bl_tpm_B[`r',3]   in `r'
        quietly replace fl_pi     = irf_fl_pi_B[`r',2]                                 in `r'
        quietly replace fl_pi_lo  = irf_fl_pi_B[`r',2]  - 1.96*irf_fl_pi_B[`r',3]    in `r'
        quietly replace fl_pi_hi  = irf_fl_pi_B[`r',2]  + 1.96*irf_fl_pi_B[`r',3]    in `r'
        quietly replace fl_g      = irf_fl_g_B[`r',2]                                  in `r'
        quietly replace fl_g_lo   = irf_fl_g_B[`r',2]   - 1.96*irf_fl_g_B[`r',3]     in `r'
        quietly replace fl_g_hi   = irf_fl_g_B[`r',2]   + 1.96*irf_fl_g_B[`r',3]     in `r'
        quietly replace fl_tpm    = irf_fl_tpm_B[`r',2]                                in `r'
        quietly replace fl_tpm_lo = irf_fl_tpm_B[`r',2] - 1.96*irf_fl_tpm_B[`r',3]   in `r'
        quietly replace fl_tpm_hi = irf_fl_tpm_B[`r',2] + 1.96*irf_fl_tpm_B[`r',3]   in `r'
    }

    twoway ///
        (rarea bl_pi_lo bl_pi_hi h, color(gs12) fintensity(50)) ///
        (rarea fl_pi_lo fl_pi_hi h, color(ltblue) fintensity(30)) ///
        (line bl_pi h, lcolor(black) lwidth(medthick)) ///
        (line fl_pi h, lcolor(navy)  lwidth(medthick) lpattern(dash)), ///
        yline(0, lcolor(red) lpattern(dot)) ///
        title("IRF Inflación — Shock TPM (Chile)") ///
        subtitle("Proyecciones Locales: Backward-Looking vs Forward-Looking") ///
        legend(order(3 "Backward-Looking" 4 "Forward-Looking") rows(1)) ///
        xtitle("Trimestres") ytitle("Respuesta (p.p.)") xlabel(0(2)12)
    graph export "$out\lp_pi_chile.png", replace width(1400)

    twoway ///
        (rarea bl_g_lo bl_g_hi h, color(gs12) fintensity(50)) ///
        (rarea fl_g_lo fl_g_hi h, color(ltblue) fintensity(30)) ///
        (line bl_g h, lcolor(black) lwidth(medthick)) ///
        (line fl_g h, lcolor(navy)  lwidth(medthick) lpattern(dash)), ///
        yline(0, lcolor(red) lpattern(dot)) ///
        title("IRF Output Gap — Shock TPM (Chile)") ///
        subtitle("Proyecciones Locales: Backward-Looking vs Forward-Looking") ///
        legend(order(3 "Backward-Looking" 4 "Forward-Looking") rows(1)) ///
        xtitle("Trimestres") ytitle("Respuesta (p.p.)") xlabel(0(2)12)
    graph export "$out\lp_gap_chile.png", replace width(1400)

    twoway ///
        (rarea bl_tpm_lo bl_tpm_hi h, color(gs12) fintensity(50)) ///
        (rarea fl_tpm_lo fl_tpm_hi h, color(ltblue) fintensity(30)) ///
        (line bl_tpm h, lcolor(black) lwidth(medthick)) ///
        (line fl_tpm h, lcolor(navy)  lwidth(medthick) lpattern(dash)), ///
        yline(0, lcolor(red) lpattern(dot)) ///
        title("IRF TPM — Shock TPM (Chile)") ///
        subtitle("Proyecciones Locales: Backward-Looking vs Forward-Looking") ///
        legend(order(3 "Backward-Looking" 4 "Forward-Looking") rows(1)) ///
        xtitle("Trimestres") ytitle("Respuesta (p.p.)") xlabel(0(2)12)
    graph export "$out\lp_tpm_chile.png", replace width(1400)

restore


* ============================================================
* TABLA RESUMEN FINAL
* ============================================================

display _newline "========================================================"
display "RESUMEN — EE.UU. (β_h LP, horizonte h=0,4,8,12)"
display "========================================================"
display "BL shock:"
display "h     π           u           FFR"
foreach h in 0 4 8 12 {
    local r = `h' + 1
    display %2.0f `h' "   " %9.4f irf_bl_pi_A[`r',2] ///
            "   " %9.4f irf_bl_u_A[`r',2] ///
            "   " %9.4f irf_bl_ffr_A[`r',2]
}
display "FL shock:"
display "h     π           u           FFR"
foreach h in 0 4 8 12 {
    local r = `h' + 1
    display %2.0f `h' "   " %9.4f irf_fl_pi_A[`r',2] ///
            "   " %9.4f irf_fl_u_A[`r',2] ///
            "   " %9.4f irf_fl_ffr_A[`r',2]
}

display _newline "========================================================"
display "RESUMEN — CHILE (β_h LP, horizonte h=0,4,8,12)"
display "========================================================"
display "BL shock:"
display "h     π           gap         TPM"
foreach h in 0 4 8 12 {
    local r = `h' + 1
    display %2.0f `h' "   " %9.4f irf_bl_pi_B[`r',2] ///
            "   " %9.4f irf_bl_g_B[`r',2] ///
            "   " %9.4f irf_bl_tpm_B[`r',2]
}
display "FL shock:"
display "h     π           gap         TPM"
foreach h in 0 4 8 12 {
    local r = `h' + 1
    display %2.0f `h' "   " %9.4f irf_fl_pi_B[`r',2] ///
            "   " %9.4f irf_fl_g_B[`r',2] ///
            "   " %9.4f irf_fl_tpm_B[`r',2]
}


* ============================================================
* FIN BLOQUE 3
* ============================================================
* Checklist de discusión para el documento:
*
*   P3.1 — Coeficientes de la Regla BL:
*     EE.UU.: β_π > 0 ✓ (principio de Taylor)
*             β_u < 0  (mandato dual Fed: sube tasa cuando u cae)
*     Chile:  β_π >> 0 (BCCh tiene mandato casi único de inflación)
*             β_gap ≈ 0 o pequeño (consistente con Granger Bloque 1)
*
*   P3.2 — Coeficientes de la Regla FL:
*     Si β_Eπ > 1 → política activa (estabiliza expectativas)
*     Si β_Eπ < 1 → política pasiva (posible indeterminación de Sargent-Wallace)
*     Comparar magnitud con regla BL: ¿el BCCh reacciona más a pronósticos?
*
*   P3.3 — Comparación IRF BL vs FL:
*     a) Si los IRF coinciden → la identificación es robusta
*     b) Si difieren → el horizonte de la regla afecta la inferencia
*     c) Price puzzle: shock BL puede mostrar π que SUBE inicialmente
*        porque la regla BL no controla que el BC anticipó inflación futura
*        La regla FL mitiga parcialmente este problema
*
*   P3.4 — Contraste con Cholesky (Bloque 1):
*     Los IRF de LP con shock de Taylor miden el efecto CAUSAL del shock
*     identificado por la regla, mientras que Cholesky asume solo que
*     la tasa no reacciona dentro del trimestre a shocks de π y u.
*     Si ambos dan resultados similares → Cholesky es buena aproximación.
*
*   P3.5 — Implicaciones para Chile:
*     Bajo FL: ¿el shock de TPM contrae el gap más rápido?
*     Hipótesis: sí, porque el BCCh actúa sobre expectativas inflacionarias
*     El mandato único implica que el efecto sobre π > efecto sobre gap
* ============================================================

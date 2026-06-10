=============================================================================
  SECTOR SALUD — SERIES DE TIEMPO Y REGRESIONES
  Economía Peruana y Sectorial
  Fuente: Banco Mundial / WHO Global Health Expenditure Database
  Elaboración propia
  Fecha: 2026-06-03
=============================================================================

clear all
set more off
global datos "C:\Users\USER\Desktop\Proyectos Claude\Entra\Economia Peruana y Sectorial\Datos"
global graficos "C:\Users\USER\Desktop\Proyectos Claude\Entra\Economia Peruana y Sectorial\Ouput EPS"


*GRÁFICO 1: Comparación de gasto público en Salud per cápita, del Perú versus otros países.
*Gasto en salud per cápita (USD corrientes) — comparadores
*Fuente: Banco Mundial (SH.XPD.CHEX.PC.CD)

import delimited "$datos\gasto_salud_percapita_comparadores.csv", clear

label variable peru    "Perú"
label variable bolivia "Bolivia"
label variable chile   "Chile"
label variable colombia "Colombia"
label variable ecuador "Ecuador"
label variable mexico  "México"

twoway (line peru    anio, lcolor(red)    lwidth(medthick) lpattern(solid))      (line chile   anio, lcolor(blue)   lwidth(medium)   lpattern(dash))        (line colombia anio, lcolor(green) lwidth(medium)   lpattern(longdash))     (line mexico  anio, lcolor(orange) lwidth(medium)   lpattern(shortdash))    (line ecuador anio, lcolor(purple) lwidth(thin)     lpattern(dot))         (line bolivia anio, lcolor(gray)   lwidth(thin)     lpattern(longdash_dot)),     title("Gasto corriente en salud per cápita", size(medsmall))     subtitle("En dólares corrientes, 2000–2023", size(small))     ytitle("USD por habitante") xtitle("")     xlabel(2000(5)2023, angle(0))     legend(order(1 "Perú" 2 "Chile" 3 "Colombia" 4 "México" 5 "Ecuador" 6 "Bolivia")            rows(2) size(small)) 
    note("Fuente: Banco Mundial / WHO Global Health Expenditure Database, 2025."          "Elaboración propia.", size(vsmall))     scheme(s1mono) graphregion(color(white))

graph export "$graficos\g1_gasto_salud_percapita.png", replace width(1800)

/*-----------------------------------------------------------------------------
  GRÁFICO 2: Gasto en salud como % del PIB — comparadores
  Fuente: Banco Mundial (SH.XPD.CHEX.GD.ZS), WHO GHED
-----------------------------------------------------------------------------*/
import delimited "$datos\gasto_salud_pctpib_comparadores.csv", clear

twoway     (line peru    anio, lcolor(red)    lwidth(medthick) lpattern(solid))        (line chile   anio, lcolor(blue)   lwidth(medium)   lpattern(dash))        (line colombia anio, lcolor(green) lwidth(medium)   lpattern(longdash))     (line mexico  anio, lcolor(orange) lwidth(medium)   lpattern(shortdash))    (line ecuador anio, lcolor(purple) lwidth(thin)     lpattern(dot))         (line bolivia anio, lcolor(gray)   lwidth(thin)     lpattern(longdash_dot)),     title("Gasto corriente en salud (% del PIB)", size(medsmall))     subtitle("2000–2023", size(small))     ytitle("Porcentaje del PIB (%)") xtitle("")     xlabel(2000(5)2023, angle(0))     yline(6, lcolor(black) lpattern(dot) lwidth(vthin))     legend(order(1 "Perú" 2 "Chile" 3 "Colombia" 4 "México" 5 "Ecuador" 6 "Bolivia")            rows(2) size(small))    note("Fuente: Banco Mundial / WHO GHED, 2025. Elaboración propia.", size(vsmall))     scheme(s1mono) graphregion(color(white))

graph export "$graficos\g2_gasto_salud_pctpib.png", replace width(1800)

/*-----------------------------------------------------------------------------
  GRÁFICO 3: Esperanza de vida al nacer en Perú — por género
  Fuente: Banco Mundial (SP.DYN.LE00.IN / FE / MA)
-----------------------------------------------------------------------------*/
import delimited "$datos\esperanza_vida_peru_genero.csv", clear

twoway ///
    (line total   anio, lcolor(black)  lwidth(medthick) lpattern(solid))    ///
    (line mujeres anio, lcolor(red)    lwidth(medium)   lpattern(dash))     ///
    (line hombres anio, lcolor(blue)   lwidth(medium)   lpattern(longdash)), ///
    title("Esperanza de vida al nacer en Perú", size(medsmall)) ///
    subtitle("Por sexo, 1965–2024", size(small)) ///
    ytitle("Años de vida") xtitle("") ///
    xlabel(1965(10)2024, angle(0)) ///
    yline(76, lcolor(gray) lpattern(dot) lwidth(vthin)) ///
    xline(2020, lcolor(red) lpattern(shortdash) lwidth(thin)) ///
    text(68 2020.5 "COVID-19", size(vsmall) color(red)) ///
    legend(order(1 "Ambos sexos" 2 "Mujeres" 3 "Hombres") ///
           rows(1) size(small)) ///
    note("Fuente: Banco Mundial, 2025. Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\g3_esperanza_vida_genero.png", replace width(1800)

/*-----------------------------------------------------------------------------
  GRÁFICO 4: Esperanza de vida — comparadores regionales (2000–2024)
  Fuente: Banco Mundial (SP.DYN.LE00.IN)
-----------------------------------------------------------------------------*/
import delimited "$datos\esperanza_vida_comparadores.csv", clear

twoway ///
    (line peru    anio, lcolor(red)    lwidth(medthick) lpattern(solid))    ///
    (line chile   anio, lcolor(blue)   lwidth(medium)   lpattern(dash))     ///
    (line colombia anio, lcolor(green) lwidth(medium)   lpattern(longdash)) ///
    (line mexico  anio, lcolor(orange) lwidth(medium)   lpattern(shortdash))///
    (line ecuador anio, lcolor(purple) lwidth(thin)     lpattern(dot))      ///
    (line bolivia anio, lcolor(gray)   lwidth(thin)     lpattern(longdash_dot)), ///
    title("Esperanza de vida al nacer — comparadores", size(medsmall)) ///
    subtitle("Años de vida, 2000–2024", size(small)) ///
    ytitle("Años") xtitle("") ///
    xlabel(2000(5)2024, angle(0)) ///
    legend(order(1 "Perú" 2 "Chile" 3 "Colombia" 4 "México" 5 "Ecuador" 6 "Bolivia") ///
           rows(2) size(small)) ///
    note("Fuente: Banco Mundial, 2025. Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\g4_esperanza_vida_comparadores.png", replace width(1800)

/*-----------------------------------------------------------------------------
  GRÁFICO 5: Indicadores macroeconómicos — Perú
  (Crecimiento PIB, gasto en salud, pobreza, mortalidad infantil)
  Fuente: Banco Mundial
-----------------------------------------------------------------------------*/
import delimited "$datos\indicadores_macro_peru.csv", clear

* 5a. Crecimiento del PIB
twoway (bar crec_pib_pct anio, color(navy%70)), ///
    title("Crecimiento del PIB — Perú", size(medsmall)) ///
    subtitle("Variación porcentual anual, 1995–2024", size(small)) ///
    ytitle("Variación % anual") xtitle("") ///
    xlabel(1995(5)2024, angle(0)) ///
    yline(0, lcolor(black) lwidth(vthin)) ///
    xline(2020, lcolor(red) lpattern(shortdash) lwidth(thin)) ///
    text(-12 2020.5 "COVID-19", size(vsmall) color(red)) ///
    note("Fuente: Banco Mundial (NY.GDP.MKTP.KD.ZG), 2025. Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\g5a_crecimiento_pib.png", replace width(1800)

* 5b. Gasto público en salud (% PIB) vs gasto total en salud (% PIB)
twoway ///
    (line gasto_salud_pctpib_total  anio, lcolor(navy)  lwidth(medthick) lpattern(solid)) ///
    (line gasto_publico_salud_pctpib anio, lcolor(red)   lwidth(medium)   lpattern(dash)), ///
    title("Gasto en salud en Perú (% del PIB)", size(medsmall)) ///
    subtitle("Gasto total vs. gasto público, 2000–2023", size(small)) ///
    ytitle("% del PIB") xtitle("") ///
    xlabel(2000(5)2023, angle(0)) ///
    legend(order(1 "Gasto total en salud" 2 "Gasto público en salud") ///
           rows(1) size(small)) ///
    note("Fuente: Banco Mundial / WHO GHED, 2025. Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\g5b_gasto_salud_publico_vs_total.png", replace width(1800)

* 5c. Pobreza monetaria (%)
twoway (area pobreza_monetaria_pct anio, color(red%30) lcolor(red) lwidth(medium)), ///
    title("Pobreza monetaria — Perú", size(medsmall)) ///
    subtitle("Porcentaje de la población, 2000–2024", size(small)) ///
    ytitle("% de la población") xtitle("") ///
    xlabel(2000(5)2024, angle(0)) ///
    note("Fuente: Banco Mundial / INEI (SI.POV.NAHC), 2025. Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\g5c_pobreza_monetaria.png", replace width(1800)

* 5d. Mortalidad infantil y acceso a agua potable
twoway ///
    (line mortalidad_infantil_x1000 anio, lcolor(red)  lwidth(medthick) lpattern(solid) yaxis(1)) ///
    (line agua_potable_pct          anio, lcolor(blue) lwidth(medium)   lpattern(dash)  yaxis(2)), ///
    title("Mortalidad infantil y acceso a agua potable — Perú", size(medsmall)) ///
    subtitle("2000–2024", size(small)) ///
    ytitle("Mortalidad infantil (x1,000 nacidos vivos)", axis(1)) ///
    ytitle("Acceso a agua potable segura (%)", axis(2)) ///
    xtitle("") xlabel(2000(5)2024, angle(0)) ///
    legend(order(1 "Mortalidad infantil (eje izq.)" 2 "Agua potable segura % (eje der.)") ///
           rows(2) size(small)) ///
    note("Fuente: Banco Mundial (SP.DYN.IMRT.IN; SH.H2O.SMDW.ZS), 2025. Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\g5d_mortalidad_agua.png", replace width(1800)

/*-----------------------------------------------------------------------------
  GRÁFICO 6: Médicos y camas hospitalarias — comparadores
  Fuente: Banco Mundial (SH.MED.PHYS.ZS; SH.MED.BEDS.ZS)
-----------------------------------------------------------------------------*/
import delimited "$datos\medicos_camas_comparadores.csv", clear

twoway ///
    (connected medicos_peru    anio, lcolor(red)    mcolor(red)    lwidth(medthick) msymbol(circle)) ///
    (connected medicos_chile   anio, lcolor(blue)   mcolor(blue)   lwidth(medium)   msymbol(square)) ///
    (connected medicos_colombia anio, lcolor(green) mcolor(green)  lwidth(medium)   msymbol(triangle)) ///
    (connected medicos_ecuador anio, lcolor(purple) mcolor(purple) lwidth(thin)     msymbol(diamond)) ///
    (connected medicos_mexico  anio, lcolor(orange) mcolor(orange) lwidth(thin)     msymbol(plus)), ///
    title("Médicos por cada 1,000 habitantes", size(medsmall)) ///
    subtitle("Países seleccionados, 2014–2023", size(small)) ///
    ytitle("Médicos por 1,000 hab.") xtitle("") ///
    xlabel(2014(2)2023, angle(0)) ///
    legend(order(1 "Perú" 2 "Chile" 3 "Colombia" 4 "Ecuador" 5 "México") ///
           rows(1) size(small)) ///
    note("Fuente: Banco Mundial (SH.MED.PHYS.ZS), 2025. Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\g6a_medicos_comparadores.png", replace width(1800)

twoway ///
    (connected camas_peru    anio, lcolor(red)    mcolor(red)    lwidth(medthick) msymbol(circle)) ///
    (connected camas_chile   anio, lcolor(blue)   mcolor(blue)   lwidth(medium)   msymbol(square)) ///
    (connected camas_colombia anio, lcolor(green) mcolor(green)  lwidth(medium)   msymbol(triangle)) ///
    (connected camas_ecuador anio, lcolor(purple) mcolor(purple) lwidth(thin)     msymbol(diamond)) ///
    (connected camas_mexico  anio, lcolor(orange) mcolor(orange) lwidth(thin)     msymbol(plus)), ///
    title("Camas hospitalarias por cada 1,000 habitantes", size(medsmall)) ///
    subtitle("Países seleccionados, 2014–2023", size(small)) ///
    ytitle("Camas por 1,000 hab.") xtitle("") ///
    xlabel(2014(2)2023, angle(0)) ///
    legend(order(1 "Perú" 2 "Chile" 3 "Colombia" 4 "Ecuador" 5 "México") ///
           rows(1) size(small)) ///
    note("Fuente: Banco Mundial (SH.MED.BEDS.ZS), 2025. Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\g6b_camas_comparadores.png", replace width(1800)

/*=============================================================================
  REGRESIONES ECONOMÉTRICAS
=============================================================================*/

import delimited "$datos\indicadores_macro_peru.csv", clear

/*-----------------------------------------------------------------------------
  REGRESIÓN 1: Crecimiento del PIB ~ Crecimiento del gasto público en salud
  Hipótesis: mayor gasto en salud impulsa el crecimiento económico
-----------------------------------------------------------------------------*/
* Calcular la variación del gasto público en salud
sort anio
gen crec_gasto_salud = (gasto_publico_salud_pctpib - L.gasto_publico_salud_pctpib) / ///
                        L.gasto_publico_salud_pctpib * 100

* Regresión OLS simple
regress crec_pib_pct crec_gasto_salud if anio >= 2001

* Guardar estadísticos
estimates store reg1

* Gráfico de dispersión + línea de ajuste
twoway ///
    (scatter crec_pib_pct crec_gasto_salud if anio >= 2001, ///
        mlabel(anio) mlabsize(vsmall) mcolor(navy%60) msymbol(circle)) ///
    (lfit crec_pib_pct crec_gasto_salud if anio >= 2001, ///
        lcolor(red) lwidth(medium)), ///
    title("Regresión 1: Crecimiento PIB ~ Crecimiento gasto público en salud", size(small)) ///
    subtitle("Perú, 2001–2023", size(small)) ///
    ytitle("Crecimiento del PIB (% anual)") ///
    xtitle("Crecimiento del gasto público en salud (% variación)") ///
    legend(off) ///
    note("Fuente: Banco Mundial, 2025. Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\reg1_pib_gasto_salud.png", replace width(1800)

/*-----------------------------------------------------------------------------
  REGRESIÓN 2: Pobreza monetaria ~ Gasto público en salud (% PIB)
  Hipótesis: mayor gasto público en salud reduce la pobreza
-----------------------------------------------------------------------------*/
regress pobreza_monetaria_pct gasto_publico_salud_pctpib if anio >= 2004

estimates store reg2

twoway ///
    (scatter pobreza_monetaria_pct gasto_publico_salud_pctpib if anio >= 2004, ///
        mlabel(anio) mlabsize(vsmall) mcolor(maroon%70) msymbol(circle)) ///
    (lfit pobreza_monetaria_pct gasto_publico_salud_pctpib if anio >= 2004, ///
        lcolor(navy) lwidth(medium)), ///
    title("Regresión 2: Pobreza monetaria ~ Gasto público en salud", size(small)) ///
    subtitle("Perú, 2004–2023", size(small)) ///
    ytitle("Tasa de pobreza monetaria (%)") ///
    xtitle("Gasto público en salud (% del PIB)") ///
    legend(off) ///
    note("Fuente: Banco Mundial / INEI, 2025. Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\reg2_pobreza_gasto_salud.png", replace width(1800)

/*-----------------------------------------------------------------------------
  REGRESIÓN 3: Mortalidad infantil ~ Acceso a agua potable segura
  Hipótesis: mayor acceso a agua potable reduce la mortalidad infantil
  (proxy de enfermedades diarreicas — ENAHO)
-----------------------------------------------------------------------------*/
regress mortalidad_infantil_x1000 agua_potable_pct if anio >= 2000

estimates store reg3

twoway ///
    (scatter mortalidad_infantil_x1000 agua_potable_pct if anio >= 2000, ///
        mlabel(anio) mlabsize(vsmall) mcolor(teal%70) msymbol(circle)) ///
    (lfit mortalidad_infantil_x1000 agua_potable_pct if anio >= 2000, ///
        lcolor(red) lwidth(medium)), ///
    title("Regresión 3: Mortalidad infantil ~ Acceso a agua potable", size(small)) ///
    subtitle("Perú, 2000–2024 (proxy enfermedades diarreicas)", size(small)) ///
    ytitle("Mortalidad infantil (x1,000 nacidos vivos)") ///
    xtitle("Población con agua potable segura (%)") ///
    legend(off) ///
    note("Fuente: Banco Mundial (SP.DYN.IMRT.IN; SH.H2O.SMDW.ZS), 2025." ///
         "Elaboración propia.", size(vsmall)) ///
    scheme(s1mono) graphregion(color(white))

graph export "$graficos\reg3_mortalidad_agua.png", replace width(1800)

/*-----------------------------------------------------------------------------
  TABLA RESUMEN DE REGRESIONES
-----------------------------------------------------------------------------*/
esttab reg1 reg2 reg3 using "$graficos\tabla_regresiones.rtf", ///
    title("Resumen de regresiones — Sector Salud Perú") ///
    mtitles("Crec. PIB ~ Gasto salud" "Pobreza ~ Gasto salud" "Mortalidad ~ Agua") ///
    label star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2 r2_a, labels("Observaciones" "R²" "R² ajustado")) ///
    replace

di "Script completado. Gráficos guardados en: $graficos"

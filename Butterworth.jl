using Plots; plotly()
using ControlSystems

Dbw(ωc) = [(1/ωc)^2, 1.44*(1/ωc),  1]

HaaS1 = tf([1], Dbw(3.26))
HaaS2 = tf([1], Dbw(13.03))

setPlotScale("dB")
bodeplot([HaaS1, HaaS2], label =["G HAA1" "fase HAA1" "G HAA2" "fase HAA2"], linewidth = 3)
xlabel!("w")

#HaaS1 =
#                       1.0
# ---------------------------------------------------
# 0.09409462155143213s^2 + 0.44171779141104295s + 1.0

#HaaS2 = 
#                       1.0
# ----------------------------------------------------
# 0.005889944039641681s^2 + 0.11051419800460477s + 1.0
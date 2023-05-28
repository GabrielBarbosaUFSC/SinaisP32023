using Symbolics
using Plots; plotly()
using ControlSystems
setPlotScale("dB")
function getfilter(ωc, band)    
    Hcutlow = tf([1/(ωc-band/2), 0], [1/(ωc-band/2), 1])
    Hcuthigh = tf([1],[1/(ωc+band/2), 1])
    Hfilter = Hcuthigh*Hcutlow
    p1 = bodeplot([Hcutlow, Hcuthigh, Hfilter])   
    return Hfilter, p1
end

ω1 = 100
ωcS1 = 3.26

ω2 = 10000
ωcS2 = 13.03

Hf1_, p1 = getfilter(ω1, 2*ωcS1)
Hf2_, p2 = getfilter(ω2, 2*ωcS2)
plot(p1, p2)


ke1 = 10^(5.74/20)
ke2 = 10^(6.01/20)
Hf1 = Hf1_*ke1
Hf2 = Hf2_*ke2
bodeplot([Hf1, Hf2], label = ["G Hf1" "P Hf1" "G Hf2" "P Hf2" ], linewidth = 3)

#Hf1 = 
        #               0.020016766218178703s
        # -------------------------------------------------------
        # 0.00010010638906604383s^2 + 0.020021277813208768s + 1.0

#Hf2 =
        #               0.0002000166986025499s
        # --------------------------------------------------------
        # 1.0000016978118825e-8s^2 + 0.00020000033956237652s + 1.0
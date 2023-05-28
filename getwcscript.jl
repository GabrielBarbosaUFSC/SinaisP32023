using Roots
using SpecialFunctions
using Plots; plotly()

function getwc(τ, Et, n)
    intEωc(ω) = 2*(τ*ω*sinint(τ*ω) + cos(τ*ω) - 1)/(π*ω)
    ω = range(0, 100, length= 10000)
    ωcS1int = intEωc.(ω)
    plt = plot(ω, intEωc)
    getzero(ω) = intEωc(ω) - Et*n
    return find_zero(getzero, (0.1, 100)), plt   
end

n = 0.95
EtS1 = 4
τS1 = 4
EtS2 = 1
τS2 = 1

ωcS1, plotS1 = getwc(τS1, EtS1, n)
ωcS1, plotS2 = getwc(τS2, EtS2, n)

begin 
    plot(plotS1, plotS2, layout = (1, 2), label =["ES1(w)" "ES2(w)"], linewidth = 3)   
    xlabel!("w")
end

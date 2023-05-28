using ControlSystems
using Plots; plotly()
setPlotScale("dB")

#Parâmetros da simulaçõa
begin
    t_0 = -3
    t_f = 7
    ts = 1e-6

    ω1 = 100
    HaaiS1 = tf([1],[0.09409462155143213, 0.44171779141104295, 1.0])
    HaafS1 = tf([2],[0.09409462155143213, 0.44171779141104295, 1])
    HfS1 = tf([0.020016766218178703, 0], [0.00010010638906604383, 0.020021277813208768, 1.0])
    
    ω2 = 10000
    HaaiS2 = tf([1],[0.005889944039641681, 0.11051419800460477, 1])
    HaafS2 = tf([2],[0.005889944039641681, 0.11051419800460477, 1])
    HfS2 = tf([0.0002000166986025499, 0], [1.0000016978118825e-8, 0.00020000033956237652, 1.0])

end

#Plot apenas um subconjunto do dados que são gerados
function sdata(data, figsize = 1000)
    if length(data) > 1000
        data_out = zeros(figsize)
        factor = trunc(Int, length(data)/figsize) - 1
        for i in eachindex(data_out)
            data_out[i] = data[factor*i]
        end
        return data_out
    else 
        return data
    end
end

#Passa um sinal por um sistema com funcao de transferencia H
function getfilteredsignal(signal, H, t)
    y, t, x, u = lsim(H, transpose(signal), t)
    return transpose(y)
end

#define o vetor tempo, s1 e s2
begin
    time = range(t_0, t_f, trunc(Int, (t_f-t_0)/ts))
    s1 = zeros(trunc(Int, (t_f-t_0)/ts))
    s2 = zeros(trunc(Int, (t_f-t_0)/ts))
    for i in eachindex(time)
        if time[i] > -2 && time[i] < 2
            s1[i] = 1
        end 
        if time[i] > -0.5 && time[i] < 0.5
            s2[i] = 1
        end
    end   
    plot(sdata(time), [sdata(s1), sdata(s2)], label =["S1(t)" "S2(t)"], linewidth = 3)
    xlabel!("t")
end

#Passa os sinais s1 e s2 pelos fitros antialissing na entrada 
begin
    s1Haai = getfilteredsignal(s1, HaaiS1, time)
    s2Haai = getfilteredsignal(s2, HaaiS2, time)
    plot(sdata(time), [sdata(s1Haai), sdata(s2Haai)], label =["S1(t)" "S2(t)"], linewidth = 3)
    xlabel!("t")
end

#Multiplica o sinal filtrado pela portadora
begin
    port1 = @. cos(ω1*time)
    port2 = @. cos(ω2*time)
    
    s1port = @. s1Haai*port1
    s2port = @. s2Haai*port2  
    transmittedsignal = s1port + s2port

    p1 = plot(sdata(time), [sdata(s1port), sdata(s2port)], label =["S1(t)" "S2(t)"], linewidth = 2)
    p2 = plot(sdata(time), sdata(transmittedsignal), label = "T(t)", linewidth = 2)
    plot(p1, p2, layout = (2, 1))
    xlabel!("t")
end

#Passa o sinal do meio pelo filtros passa-faixa
begin
    s1Hf = getfilteredsignal(transmittedsignal, HfS1, time)
    s2Hf = getfilteredsignal(transmittedsignal, HfS2, time)
    plot(sdata(time), [sdata(s1Hf), sdata(s2Hf)], label =["S1(t)" "S2(t)"], linewidth = 2)
    xlabel!("t")
end

#Passa os sinais filtrados pelo sinal da portadora
begin
    s1de = @. s1Hf*port1
    s2de = @. s2Hf*port2
    plot(sdata(time), [sdata(s1de), sdata(s2de)], label =["S1(t)" "S2(t)"], linewidth = 0.5)
    xlabel!("t") 
end

#Passa o sinal de saida da portadora pelo Filtro antialissing + Ganho
begin
    s1f = getfilteredsignal(s1de, HaafS1, time)
    s2f = getfilteredsignal(s2de, HaafS2, time) 
    p1 = plot(sdata(time), [sdata(s1f), sdata(s2f)], label =["S1(t)" "S2(t)"], linewidth = 2)
    xlabel!("t")
end

#Plota os sinais para comparação
begin
    p1 = plot(sdata(time), [sdata(s1), sdata(s1Haai), sdata(s1f)], label =["S1(t)" "S1Haa" "S1f(t)"], linewidth = 2, color = [1 2 3])  
    p2 = plot(sdata(time), [sdata(s2), sdata(s2Haai), sdata(s2f)], label =["S2(t)" "S2Haa" "S2f(t)"], linewidth = 2, color = [4 5 6]) 
    plot(p1, p2, layout = (2, 1)) 
end

#Calcula a energia dos sinais por integração nuemrica de ordem zero
begin
    Es1     = sum(s1.^2)*ts
    Es1f    = sum(s1f.^2)*ts
    Es2     = sum(s2.^2)*ts
    Es2f    = sum(s2f.^2)*ts    
end
%% ST1_PCM_1D - PCM SImulation - 1D
% Feed into TD1.1

% Given first round, simulation focuses on RANGE
% with refined PCM data (with time profile)
% a more approximate temperature source can be approximated

% Weather Conditions - rearranging apr'25-mar'26 for jan-dec
% monthly averages
% Jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
Month = ["Jan"; "Feb"; "Mar"; "Apr"; ...
         "May"; "Jun"; "Jul"; "Aug"; ...
         "Sep"; "Oct"; "Nov"; "Dec"];

Casey_C_Day = [6.7 4.7 4.3 -2.4	-2.5 -2.5 -0.8 -3.8	-4.2 0.3 3.7 5.5]; % Celsius
Davis_C_Day = [8.5 2.7 1 -3.8 -5.9 -3 -6.8 -4.5	-2.2 2.1 5.6 8.2]; % Celsius

Casey_C_Night = [-4.6 -9.9 -21.9 -25.6 -30 -25.2 -32.4 -26.8 -25.2 -21.5 -17.4 -6.9]; % Celsius
Davis_C_Night = [-3.6 -9.4 -17.8 -27.5 -28.9 -32.2 -33.7 -29.2 -26.2 -18.7 -9.6 -3.6]; % Celsius

% Convert to Kelvin 

Casey_K_Day = zeros(1,12);
Casey_K_Night = zeros(1,12); 

Davis_K_Day = zeros(1,12);
Davis_K_Night = zeros(1,12);


for i = 1:12

    Casey_K_Day(i) = Casey_C_Day(i) + 273.15; 
    Casey_K_Night(i) = Casey_C_Night(i) + 273.15; 

    Davis_K_Day(i) = Davis_C_Day(i) + 273.15; 
    Davis_K_Night(i) = Davis_C_Night(i) + 273.15; 

end 


%% Total Latent Heat
% Sanity check math / baseline / "available" (hypothetical) energy
% Candidate PCM = PC-7 (PCP Australia)

T_PC_C = -7 ; % C
T_PC_K = T_PC_C + 273.15; % Kelvin

Cp_Sol = 3.2 ; % kJ/kg.K
Cp_Liq = 2.1 ; % kJ/kg.K

H_fus = 290 ; % kJ / kg - latent heat of fusion

% Q_latent = [(T_pc*C_p_S)-(T_1*C_p_s)] + (H) + [(T_2*C_p_l)-(T_Pc*C_p_l)]

Q_latent_Casey = zeros(1,12);
Q_latent_Davis = zeros(1,12);

for i = 1:12 

Q_latent_Casey = ((Casey_K_Day * Cp_Liq) - (T_PC_K * Cp_Liq)) ... liquid stage
                    + H_fus + ... latent heat fusion
                 ((T_PC_K * Cp_Sol) - (Casey_K_Night * Cp_Sol)); % solid stage

Q_latent_Davis = ((Davis_K_Day * Cp_Liq) - (T_PC_K * Cp_Liq)) ... liquid stage
                    + H_fus + ... latent heat fusion
                 ((T_PC_K * Cp_Sol) - (Davis_K_Night * Cp_Sol)); % solid stage
end 


figure(1)
hold on;
grid on;
title('PCM - Maximum Potential Specific Energy Absorbed/Released (kJ / kg)')

bar(1:12,[Q_latent_Casey;Q_latent_Davis]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Specific Energy (kJ / kg)');
legend("Casey","Davis");
legend(location="northeast");

xticks(1:1:12);
xticklabels(Month);

hold off;


%% Load scenario - emission - DAY TO NIGHT!!!
% Due to first round approximations, rate of H.E will be determined by
% pure "conduction" in 1D with the TEG (assuming it starts off at Day
% ambient temperatures)

% Using fouriers law of heat conduction, find the rate of heat transfer
% (loss of heat -> how "long" the PCM stays "hot" for 

% assume thermal conduction, find how "long" it takes to discharge "maximum
% energy" 

% this will determine if feasible; further iterations will determine with
% what timeframes (and incorporate sunshine hours) 

% 1 dimensional analysis - consider as a "plane" wall conducting heat for 
% some thickness delta_X?

PCM_k = 2.1; % W/m.K

% Q = -kA delta_T/L - given 1D analysis, treat with "unit length" and treat
% as a function of TIME (W = J/s)

% thus, q_flux = -k * delta T -> q/-k = delta T 

% If conducts heat at constant rate, how LONG does it emit for
% Discharge time = Q-latent/Q_flux = time

Q_flux_Casey = zeros(1,12);
Q_flux_Davis = zeros(1,12);

for i = 1:12 

    Q_flux_Casey(i) = abs( -1 * PCM_k * (Casey_K_Day(i) - Casey_K_Night(i)) ); % W (J/s)
    Q_flux_Davis(i) = abs(-1 * PCM_k * (Davis_K_Day(i) - Davis_K_Night(i)) ); % W (J/s)

end

figure(2)
hold on;
grid on;
title('PCM - Potential Maximum Heat Flux - Pure Conduction')

bar(1:12,[Q_flux_Casey;Q_flux_Davis]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Heat Flux (W)');
legend("Casey","Davis");
legend(location="northeast");

xticks(1:1:12);
xticklabels(Month);

hold off;



%%
approx_discharge_Casey = zeros(1,12);
approx_discharge_Davis = zeros(1,12);

approx_discharge_Casey_m = zeros(1,12);
approx_discharge_Davis_m = zeros(1,12);

for i = 1:12

approx_discharge_Casey(i) = abs( Q_latent_Casey(i) / Q_flux_Casey(i) );
approx_discharge_Casey_m(i) = approx_discharge_Casey(i) / 60; 

approx_discharge_Davis(i) = abs( Q_latent_Davis(i) / Q_flux_Davis(i) );
approx_discharge_Davis_m(i) = approx_discharge_Davis(i) / 60; 

end 


figure(3)
hold on;
grid on;
title('PCM - time taken for PCM to emit latent heat (minutes)')

bar(1:12,[approx_discharge_Casey_m;approx_discharge_Davis_m]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Time taken (min)');
legend("Casey","Davis");
legend(location="northeast");

xticks(1:1:12);
xticklabels(Month);

hold off;

%% ST1_TEG_1D - TEG simulation 1D
% feed into TD1.1

% Given first round, simulation focuses on RANGE
% with refined PCM data (with time profile)
% a more approximate temperature source can be approximated

% Weather Conditions - rearranging apr'25-mar'26 for jan-dec
% monthly averages


Casey_C_Day = [6.7 4.7 4.3 -2.4	-2.5 -2.5 -0.8 -3.8	-4.2 0.3 3.7 5.5]; % Celsius
Davis_C_Day = [8.5 2.7 1 -3.8 -5.9 -3 -6.8 -4.5	-2.2 2.1 5.6 8.2]; % Celsius

Casey_C_Night = [-4.6 -9.9 -21.9 -25.6 -30 -25.2 -32.4 -26.8 -25.2 -21.5 -17.4 -6.9]; % Celsius
Davis_C_Night = [-3.6 -9.4 -17.8 -27.5 -28.9 -32.2 -33.7 -29.2 -26.2 -18.7 -9.6 -3.6]; % Celsius

%% Day Scenario 
% Heat Source Parameters - solar cells
T_cell_Casey = zeros(1,12);
T_cell_Davis = zeros(1,12);

for i = 1:12

T_cell_Casey(i) = Casey_C_Day(i) + (22).*(88.05/800); % C - casey solar
T_cell_Davis(i) = Davis_C_Day(i) +(22).*(71.25/800); % C - davis solar

end

% Cold Source Parameters - PCM 
% min (pcm lowest potential = T_amb_day)
% max (pcm highest potential = T_amb_night)

Casey_PCM_day_temp_min = zeros(1,12);
Casey_PCM_day_temp_max = zeros(1,12);

Davis_PCM_day_temp_min = zeros(1,12);
Davis_PCM_day_temp_max = zeros(1,12);

for i = 1:12

Casey_PCM_day_temp_min(i) = Casey_C_Day(i); 
Casey_PCM_day_temp_max(i) = Casey_C_Night(i);

Davis_PCM_day_temp_min(i) = Davis_C_Day(i);
Davis_PCM_day_temp_max(i) = Davis_C_Night(i);

end


%% Seebeck Coefficient - temperature-dependent
% Mean temperature difference 

Casey_mean_temp_min = zeros(1,12);
Casey_mean_temp_max = zeros(1,12); 

Davis_mean_temp_min = zeros(1,12);
Davis_mean_temp_max = zeros(1,12);

for i = 1:12

    Casey_mean_temp_min(i) = (T_cell_Casey(i) + Casey_PCM_day_temp_min(i) ) / 2 ;
    Casey_mean_temp_max(i) = (T_cell_Casey(i) + Casey_PCM_day_temp_max(i) ) / 2 ;

    Davis_mean_temp_min(i) = (T_cell_Davis(i) + Davis_PCM_day_temp_min(i) ) / 2 ;
    Davis_mean_temp_max(i) = (T_cell_Davis(i) + Davis_PCM_day_temp_max(i) ) / 2 ;

end


%% dim seebeck -> seebeck
% iterative loop 

Casey_dim_seebeck_min = zeros(1,12);
Casey_dim_seebeck_max = zeros(1,12);

Davis_dim_seebeck_min = zeros(1,12);
Davis_dim_seebeck_max = zeros(1,12);

for i = 1:12

    Casey_dim_seebeck_min(i) = (-1.132*10^(-5) .* (Casey_mean_temp_min(i))^2 )...
                             + (8.64*10^(-3) .* (Casey_mean_temp_min(i))) ...
                             - 0.582;

    Casey_dim_seebeck_max(i) = (-1.132*10^(-5) .* (Casey_mean_temp_max(i))^2 )...
                             + (8.64*10^(-3) .* (Casey_mean_temp_max(i))) ...
                             - 0.582;

    Davis_dim_seebeck_min(i) = (-1.132*10^(-5) .* (Davis_mean_temp_min(i))^2 )...
                             + (8.64*10^(-3) .* (Davis_mean_temp_min(i))) ...
                             - 0.582;

    Davis_dim_seebeck_max(i) = (-1.132*10^(-5) .* (Davis_mean_temp_max(i))^2 )...
                             + (8.64*10^(-3) .* (Davis_mean_temp_max(i))) ...
                             - 0.582;    

end 

% dim_seebeck =  (-1.132*10^(-5) .* (T_mean)^2 ) + (8.64*10^(-3) .* T_mean) - 0.582; 
% dim_seebeck(T) = seebeck(T)/seebeck(T=300K)
% thus, seebeck(T) = dim_seebeck(T)*(T=300K)



Casey_seebeck_min = zeros(1,12);
Casey_seebeck_max = zeros(1,12);

Davis_seebeck_min = zeros(1,12);
Davis_seebeck_max = zeros(1,12); 

for i = 1:12
% seebeck_const = 345 micro volts per kelvin
    Casey_seebeck_min(i) = Casey_dim_seebeck_min(i) * 345 * 10^-6; 
    Casey_seebeck_max(i) = Casey_dim_seebeck_max(i) * 345 * 10^-6; 

    Davis_seebeck_min(i) = Davis_dim_seebeck_min(i) * 345 * 10^-6; 
    Davis_seebeck_max(i) = Davis_dim_seebeck_max(i) * 345 * 10^-6; 

end 



%% V_oc - open circuit
% V_oc = N_pn * s(T) * Delta(T) [micro ]
N_pn = 241; % # of pn junctions

Casey_V_oc_min = zeros(1,12); 
Casey_V_oc_max = zeros(1,12); 

Davis_V_oc_min = zeros(1,12); 
Davis_V_oc_max = zeros(1,12); 

for i = 1:12
    Casey_V_oc_min(i) = N_pn .* Casey_seebeck_min(i) .* ...
                        (T_cell_Casey(i) - Casey_PCM_day_temp_min(i));

    Casey_V_oc_max(i) = N_pn .* Casey_seebeck_max(i) .* ...
                        (T_cell_Casey(i) - Casey_PCM_day_temp_max(i)); 

    Davis_V_oc_min(i) = N_pn .* Davis_seebeck_min(i) .* ...
                        (T_cell_Davis(i) - Davis_PCM_day_temp_min(i)); 

    Davis_V_oc_max(i) = N_pn .* Davis_seebeck_max(i) .* ...
                        (T_cell_Davis(i) - Davis_PCM_day_temp_max(i)); 

end


%% Electrical Conductivity
% σ ̃= 6.257∙10^(-5)∙T ̅^2-4.381∙10^(-2)∙T ̅+8.629 
Casey_dim_elec_cond_min = zeros(1,12); 
Casey_dim_elec_cond_max = zeros(1,12);

Davis_dim_elec_cond_min = zeros(1,12); 
Davis_dim_elec_cond_max = zeros(1,12); 

for i = 1:12

    Casey_dim_elec_cond_min(i) = (6.257*10^(-5) .* (Casey_mean_temp_min(i))^2 )...
                             - (4.381*10^(-2) .* (Casey_mean_temp_min(i))) ...
                             + 8.629;
    
    Casey_dim_elec_cond_max(i) = (6.257*10^(-5) .* (Casey_mean_temp_max(i))^2 )...
                             - (4.381*10^(-2) .* (Casey_mean_temp_max(i))) ...
                             + 8.629;

    Davis_dim_elec_cond_min(i) = (6.257*10^(-5) .* (Davis_mean_temp_min(i))^2 )...
                             - (4.381*10^(-2) .* (Davis_mean_temp_min(i))) ...
                             + 8.629;

    Davis_dim_elec_cond_max(i) = (6.257*10^(-5) .* (Davis_mean_temp_max(i))^2 )...
                             - (4.381*10^(-2) .* (Davis_mean_temp_max(i))) ...
                             + 8.629;

end 

%elec_cond(T) = dim_elec_cond(T)*(T=300K)
Casey_elec_cond_min = zeros(1,12);
Casey_elec_cond_max = zeros(1,12);

Davis_elec_cond_min = zeros(1,12);
Davis_elec_cond_max = zeros(1,12); 

for i = 1:12
% elec_cond_const = 28103 Omega.m
    Casey_elec_cond_min(i) = Casey_dim_elec_cond_min(i) * 28103; 
    Casey_elec_cond_max(i) = Casey_dim_elec_cond_max(i) * 28103; 

    Davis_elec_cond_min(i) = Davis_dim_elec_cond_min(i) * 28103; 
    Davis_elec_cond_max(i) = Davis_dim_elec_cond_max(i) * 28103; 

end 

%% R_i - internal resistance
% R_i = N_np * ( 1/elec_cond(T) + 2*r_con/delta_thick) * delta_thick/Area
r_con = 5 * 10^-9; % Omega.m^2
delta_thick = 0.0011; % metres
A_np = 2.89 * 10^-6; % m^2 

Casey_int_res_min = zeros(1,12);
Casey_int_res_max = zeros(1,12);

Davis_int_res_min = zeros(1,12);
Davis_int_res_max = zeros(1,12);

for i = 1:12

    Casey_int_res_min(i) = 241 * ( (1/Casey_elec_cond_min(i)) + ...
                           ( (2*r_con)/delta_thick)) * (delta_thick/A_np); 

    Casey_int_res_max(i) = 241 * ( (1/Casey_elec_cond_max(i)) + ...
                           ( (2*r_con)/delta_thick)) * (delta_thick/A_np);

    Davis_int_res_min(i) = 241 * ( (1/Davis_elec_cond_min(i)) + ...
                           ( (2*r_con)/delta_thick)) * (delta_thick/A_np);

    Davis_int_res_max(i) = 241 * ( (1/Davis_elec_cond_max(i)) + ...
                           ( (2*r_con)/delta_thick)) * (delta_thick/A_np);

end

%% Power Generation 
% P_gen = V_oc ^2 / 4*R_i

Casey_Power_gen_min = zeros(1,12);
Casey_Power_gen_max = zeros(1,12);

Davis_Power_gen_min = zeros(1,12);
Davis_Power_gen_max = zeros(1,12);


for i = 1:12

Casey_Power_gen_min(i) = (Casey_V_oc_min(i) ^ 2 ) / ...
                         (4 * Casey_int_res_min(i));

Casey_Power_gen_max(i) = (Casey_V_oc_max(i) ^ 2 ) / ...
                         (4 * Casey_int_res_max(i));

Davis_Power_gen_min(i) = (Davis_V_oc_min(i) ^ 2 ) / ...
                         (4 * Davis_int_res_min(i));

Davis_Power_gen_max(i) = (Casey_V_oc_max(i) ^ 2 ) / ...
                         (4 * Davis_int_res_max(i));

end

%% Daytime Power Gen Plots
Month = ["Jan"; "Feb"; "Mar"; "Apr"; ...
         "May"; "Jun"; "Jul"; "Aug"; ...
         "Sep"; "Oct"; "Nov"; "Dec"];

figure(1)
hold on;
grid on;
title('TEG Maximum Power Output - Daytime - single module')

bar(1:12,[Casey_Power_gen_max;Davis_Power_gen_max]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Maximum Power Generation (W)');

legend("Casey Max","Davis Max");
legend(location="northeast");

xticks(1:1:12);
xticklabels(Month);

hold off;

%% Power Generation - unit area m^2
% P_gen = V_oc ^2 / 4*R_i

mod_area = (0.0017 * 0.0017); % 

Casey_Power_gen_unit_area_min = zeros(1,12);
Casey_Power_gen_unit_area_max = zeros(1,12);

Davis_Power_gen_unit_area_min = zeros(1,12);
Davis_Power_gen_unit_area_max = zeros(1,12);


for i = 1:12
% unit area - 0.000000289 m^2
Casey_Power_gen_unit_area_min(i) = (Casey_Power_gen_min(i) /mod_area)/1000;

Casey_Power_gen_unit_area_max(i) = (Casey_Power_gen_max(i) /mod_area)/1000;

Davis_Power_gen_unit_area_min(i) = (Davis_Power_gen_min(i) /mod_area)/1000;

Davis_Power_gen_unit_area_max(i) = (Davis_Power_gen_max(i) /mod_area)/1000;

end

figure(2)
hold on;
grid on;
title('TEG Potential Maximum Power Output per unit area (kW/m^2) - Daytime')

bar(1:12,[Casey_Power_gen_unit_area_max; Davis_Power_gen_unit_area_max]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Kilo-Watts per unit area (kW/m^2)');

legend("Casey Max","Davis Max");
legend(location="northeast");

xticks(1:1:12);
xticklabels(Month);

hold off;

%% Night-time Scenario
% assume solar panel QUICKLY reaches night time i.e. rapid heat loss


% Cold source - solar cells - 
% considering cells as cold source (excl. aluminium frame) 

T_cell_Casey_night = zeros(1,12);
T_cell_Davis_night = zeros(1,12);

for i = 1:12

T_cell_Casey_night(i) = Casey_C_Night(i); % C - casey (night)
T_cell_Davis_night(i) = Davis_C_Night(i); % C - davis (night)

end

% Hot source - PCM 
% Min potential [ignore] - night temp (therefore delta T = 0 since cold = hot)
% Max potential - Ambient day temp

Casey_PCM_night_temp_max = zeros(1,12);
Davis_PCM_night_temp_max = zeros(1,12);

for i = 1:12

Casey_PCM_night_temp_max(i) = Casey_C_Day(i);
Davis_PCM_night_temp_max(i) = Davis_C_Day(i);

end

%% Seebeck Coefficient - temperature-dependent
% Mean temperature difference 

Casey_mean_temp_max_night = zeros(1,12); 
Davis_mean_temp_max_night = zeros(1,12);

for i = 1:12

    Casey_mean_temp_max(i) = (T_cell_Casey_night(i) + ...
                              Casey_PCM_night_temp_max(i)) / 2 ;
    Davis_mean_temp_max(i) = (T_cell_Davis_night(i) + ...
                              Davis_PCM_night_temp_max(i) ) / 2 ;

end

%% dim seebeck -> seebeck
% iterative loop 

Casey_dim_seebeck_max_night = zeros(1,12);

Davis_dim_seebeck_max_night = zeros(1,12);

for i = 1:12

    Casey_dim_seebeck_max_night(i) = (-1.132*10^(-5) .* (Casey_mean_temp_max_night(i))^2 )...
                             + (8.64*10^(-3) .* (Casey_mean_temp_max_night(i))) ...
                             - 0.582;

    Davis_dim_seebeck_max_night(i) = (-1.132*10^(-5) .* (Davis_mean_temp_max_night(i))^2 )...
                             + (8.64*10^(-3) .* (Davis_mean_temp_max_night(i))) ...
                             - 0.582;    

end 

% dim_seebeck =  (-1.132*10^(-5) .* (T_mean)^2 ) + (8.64*10^(-3) .* T_mean) - 0.582; 
% dim_seebeck(T) = seebeck(T)/seebeck(T=300K)
% thus, seebeck(T) = dim_seebeck(T)*(T=300K)

Casey_seebeck_max_night = zeros(1,12);
Davis_seebeck_max_night = zeros(1,12); 

for i = 1:12
% seebeck_const = 345 micro volts per kelvin
    Casey_seebeck_max_night(i) = Casey_dim_seebeck_max_night(i) * 345 * 10^-6; 
    Davis_seebeck_max_night(i) = Davis_dim_seebeck_max_night(i) * 345 * 10^-6; 
end 

%% V_oc - open circuit
% V_oc = N_pn * s(T) * Delta(T) [micro ]
N_pn = 241; % # of pn junctions

Casey_V_oc_max_night = zeros(1,12); 

Davis_V_oc_max_night = zeros(1,12); 

for i = 1:12

    Casey_V_oc_max_night(i) = N_pn .* Casey_seebeck_max_night(i) .* ...
                        (T_cell_Casey_night(i) - Casey_PCM_night_temp_max(i)); 

    Davis_V_oc_max_night(i) = N_pn .* Davis_seebeck_max_night(i) .* ...
                        (T_cell_Davis_night(i) - Davis_PCM_night_temp_max(i)); 

end

%% Electrical Conductivity
% σ ̃= 6.257∙10^(-5)∙T ̅^2-4.381∙10^(-2)∙T ̅+8.629 
Casey_dim_elec_cond_max_night = zeros(1,12);
Davis_dim_elec_cond_max_night = zeros(1,12); 

for i = 1:12

Casey_dim_elec_cond_max_night(i) = ...
    (6.257*10^(-5) .* (Casey_mean_temp_max_night(i))^2 ) ...
     - (4.381*10^(-2) .* (Casey_mean_temp_max_night(i))) ...
     + 8.629;

Davis_dim_elec_cond_max_night(i) = ...
    (6.257*10^(-5) .* (Davis_mean_temp_max_night(i))^2 )...
    - (4.381*10^(-2) .* (Davis_mean_temp_max_night(i))) ...
    + 8.629;

end 

%elec_cond(T) = dim_elec_cond(T)*(T=300K)
Casey_elec_cond_max_night = zeros(1,12);
Davis_elec_cond_max_night = zeros(1,12); 

for i = 1:12
% elec_cond_const = 28103 Omega.m 
    Casey_elec_cond_max_night(i) = Casey_dim_elec_cond_max_night(i) * 28103; 
    Davis_elec_cond_max_night(i) = Davis_dim_elec_cond_max_night(i) * 28103; 
end 

%% R_i - internal resistance
% R_i = N_np * ( 1/elec_cond(T) + 2*r_con/delta_thick) * delta_thick/Area
r_con = 5 * 10^-9; % Omega.m^2
delta_thick = 0.0011; % metres
A_np = 2.89 * 10^-6; % m^2 

Casey_int_res_max_night = zeros(1,12);
Davis_int_res_max_night = zeros(1,12);

for i = 1:12
Casey_int_res_max_night(i) = 241 * ( (1/Casey_elec_cond_max_night(i)) + ...
                       ( (2*r_con)/delta_thick)) * (delta_thick/A_np);

Davis_int_res_max_night(i) = 241 * ( (1/Davis_elec_cond_max_night(i)) + ...
                       ( (2*r_con)/delta_thick)) * (delta_thick/A_np);

end

%% Power Generation 
% P_gen = V_oc ^2 / 4*R_i

Casey_Power_gen_max_night = zeros(1,12);
Davis_Power_gen_max_night = zeros(1,12);


for i = 1:12

Casey_Power_gen_max_night(i) = (Casey_V_oc_max_night(i) ^ 2 ) / ...
                         (4 * Casey_int_res_max_night(i));

Davis_Power_gen_max_night(i) = (Casey_V_oc_max_night(i) ^ 2 ) / ...
                         (4 * Davis_int_res_max_night(i));

end


figure(3)
hold on;
grid on;
title('TEG Maximum Power Output - Nighttime - single module')

bar(1:12,[Casey_Power_gen_max_night;Davis_Power_gen_max_night]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Maximum Power Generation (W)');

legend("Casey Max","Davis Max");
legend(location="northeast");

xticks(1:1:12);
xticklabels(Month);

hold off;

%% Power Generation - unit area
% P_gen = V_oc ^2 / 4*R_i

Casey_Power_gen_unit_area_max_night = zeros(1,12);
Davis_Power_gen_unit_area_max_night = zeros(1,12);


for i = 1:12
% approx 2609 whole TEG modules fit within 5 solar panel array
% assume 0.9 - system efficiency coeff
Casey_Power_gen_unit_area_max_night(i) = (Casey_Power_gen_max_night(i) /mod_area)/1000;

Davis_Power_gen_unit_area_max_night(i) = (Davis_Power_gen_max_night(i) /mod_area)/1000;

end

figure(4)
hold on;
grid on;
title('TEG Maximum Power Output - Night time per unit area')

bar(1:12,[Casey_Power_gen_unit_area_max_night; Davis_Power_gen_unit_area_max_night]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Maximum Power Generation (kW/m^2)');

legend("Casey Max","Davis Max");
legend(location="northeast");

xticks(1:1:12);
xticklabels(Month);

hold off;


%% Comparison of daytime vs night time plots

figure(5)
hold on;
grid on;
title('TEG Maximum Power Output per unit area - Comparison - Casey')

bar(1:12,[Casey_Power_gen_unit_area_max; Casey_Power_gen_unit_area_max_night]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Kilo-Watts per unit area (kW/m^2)');

legend("Day","Night");
legend(location="northeast");

xticks(1:1:12);
xticklabels(Month);

hold off;

figure(6)
hold on;
grid on;
title('TEG Maximum Power Output per unit area - Comparison - Davis')

bar(1:12,[Davis_Power_gen_unit_area_max; Davis_Power_gen_unit_area_max_night]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Kilo-Watts per unit area (kW/m^2)');

legend("Day","Night");
legend(location="northeast");

xticks(1:1:12);
xticklabels(Month);

hold off;

figure(7)
hold on;
grid on;
title('TEG Maximum Power Output per unit area - Comparison')

bar(1:12,[Casey_Power_gen_unit_area_max; Casey_Power_gen_unit_area_max_night;Davis_Power_gen_unit_area_max; Davis_Power_gen_unit_area_max_night]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Kilo-Watts per unit area (kW/m^2)');

legend("Casey Day","Casey Night","Davis Day","Davis Night");
legend(location="northeast");

xticks(1:1:12);
xticklabels(Month);

hold off;
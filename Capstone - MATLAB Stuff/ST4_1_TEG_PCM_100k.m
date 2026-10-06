%% --- % ST4.1 TEG/PCM CODE % --- %%
% This is the TEG Code at the "1-to-1" level for {TEG/PCM}

% For TEG/PCM, PCM solar data must be imported
% PCM Data includes 24 sets [2 stations] x [2 seasons] x [6x cloud cover cases]


% For all intensive purpose, this investigates TEG power only
% Relies on PCm3.2 data import (need to be careful with cases)
% Copy logic from ST4_1_PV_TEG


% GONNA LEAVE THIS FOR 100K WIND ONLY!!! - RENAME!!!

%% 1) Set baseline temperatures - AMBIENT TEMPERATURES - "TOP SIDE"
% Time vector - discretisation of 24-hour window 
t = 0:0.5:23.5;
Casey_summer_temp = zeros(1,length(t));
% casey sumer temp range: 
    % night: 1-18 [t(18) = 8.5]
    % Day: 19-31
    % Night: 32-48

for i = 1:18
    Casey_summer_temp(i) = -6.9 ; 
end 

for i = 19:25
    % set initial time temp @ night time i.e. sun just rose, no heat yet)
    if i == 19
    Casey_summer_temp(i) = -6.9;
    else
    Casey_summer_temp(i) = Casey_summer_temp(i-1) + 2.067;
    end
end

for i = 26:31
Casey_summer_temp(i) = Casey_summer_temp(i-1) - 2.067;
end

for i = 32:48
    Casey_summer_temp(i) = -6.9;
end

% Casey - Spring
Casey_spring_temp = zeros(1,length(t));
% Casey Spring - 3 hour window (10:30am-1:30pm)[22-28]
    % Night: 1-21 [t(21) = 10am]
    % Day: 22-28
    % Night: 29-48

for i = 1:21
    Casey_spring_temp(i) = -25.2;
end

for i = 22:25
    if i == 22 % initial temp @ 1030am
        Casey_spring_temp(i) = -25.2;
    else
        Casey_spring_temp(i) = Casey_spring_temp(i-1) + 7; 
    end
end

for i = 26:28
    Casey_spring_temp(i) = Casey_spring_temp(i-1) - 7;
end

for i = 29:48
    Casey_spring_temp(i) = -25.2;
end

% Davis - Summer
Davis_summer_temp = zeros(1,length(t));
% Davis summer temp range: 
    % Night: 1-14 [t(14) = 630am]
    % Day: 15-(25)-35
    % Night: 36-48

for i = 1:14
    Davis_summer_temp(i) = -3.6;
end

for i = 15:25
    if i == 15 % initialise temp
        Davis_summer_temp(i) = -3.6;
    else
        Davis_summer_temp(i) = Davis_summer_temp(i-1) + 1.18;
    end
end

for i = 26:35
    Davis_summer_temp(i) = Davis_summer_temp(i-1) - 1.18;
end

for i = 36:48
    Davis_summer_temp(i) = -3.6;
end

% Davis - Spring
Davis_spring_temp = zeros(1,length(t));
% Davis Spring - 4 hour window (10am-2pm) [21-29]
    % Night: 1-20 [t(20) = 930am]
    % Day: 21-(25)-29
    % Night: 30-48

for i = 1:20
    Davis_spring_temp(i) = -26.2;
end 

for i = 21:25
    if i == 21
        Davis_spring_temp(i) = -26.2;
    else
        Davis_spring_temp(i) = Davis_spring_temp(i-1) + 6;
    end
end 

for i = 26:29
    Davis_spring_temp(i) = Davis_spring_temp(i-1) - 6;
end

for i = 30:48
    Davis_spring_temp(i) = -26.2;
end

% Plot - sanity check
figure(1)
hold on 
grid on
grid minor
plot(t,Casey_summer_temp);
plot(t,Casey_spring_temp);
plot(t,Davis_summer_temp);
plot(t,Davis_spring_temp);
ylabel('Ambient Temp [C]')
xlabel('Time - 24 hour')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('Ambient Temperatures')
hold off

%% 2) Using PCM data, define BOTTOM SIDE
% 6 cases x 2 seasons x 2 locations = 24 cases

% recall: readtable and table2array functions
%% [Wind = 100km]
PCM_TEMP_WIND_100K_ALL_LOC = ...
    readtable("PCM_TEMP_WIND_100K_ALL_LOC.xlsx");

PCM_TEMP_WIND_100K_ALL_LOC = ...
    table2array(PCM_TEMP_WIND_100K_ALL_LOC);

% Separate data 
PCM_temp_Casey_Sum_100k = PCM_TEMP_WIND_100K_ALL_LOC(1,:);
PCM_temp_Casey_Spr_100k = PCM_TEMP_WIND_100K_ALL_LOC(2,:);

PCM_temp_Davis_Sum_100k = PCM_TEMP_WIND_100K_ALL_LOC(3,:);
PCM_temp_Davis_Spr_100k = PCM_TEMP_WIND_100K_ALL_LOC(4,:);

% sanity check - plot irradiance values
figure(2)
hold on
grid on
grid minor
plot(t,PCM_temp_Casey_Sum_100k)
plot(t,PCM_temp_Casey_Spr_100k)
plot(t,PCM_temp_Davis_Sum_100k)
plot(t,PCM_temp_Davis_Spr_100k)
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
xlabel('Time - 24 hr')
ylabel('PCM Temp')
title('PCM Temperature - Wind = 100km/hr')
hold off


%% 3) Establish average temperature and temp diff
% ---- % [Wind = 100 km/hr] % ---- %
Casey_sum_temp_diff_100k = zeros(1,length(t));
Casey_spr_temp_diff_100k = zeros(1,length(t));
Davis_sum_temp_diff_100k = zeros(1,length(t));
Davis_spr_temp_diff_100k = zeros(1,length(t));

% recall Delta = Top - bottom (orientation)
% PCM temp < ambient

for i = 1:48 
    Casey_sum_temp_diff_100k(i) = ...
        Casey_summer_temp(i) - PCM_temp_Casey_Sum_100k(i);

    Casey_spr_temp_diff_100k(i) = ...
        Casey_spring_temp(i) - PCM_temp_Casey_Spr_100k(i);


    Davis_sum_temp_diff_100k(i) = ...
        Davis_summer_temp(i) - PCM_temp_Davis_Sum_100k(i);

    Davis_spr_temp_diff_100k(i) = ...
        Davis_spring_temp(i) - PCM_temp_Davis_Spr_100k(i);

end

Casey_sum_mean_temp_100k = zeros(1,length(t));
Casey_spr_mean_temp_100k = zeros(1,length(t));
Davis_sum_mean_temp_100k = zeros(1,length(t));
Davis_spr_mean_temp_100k = zeros(1,length(t));
% && PCM temp < ambient!!!!

for i = 1:48
    Casey_sum_mean_temp_100k(i) = PCM_temp_Casey_Sum_100k(i) ...
                            + (Casey_sum_temp_diff_100k(i)/2);
    
    Casey_spr_mean_temp_100k(i) = PCM_temp_Casey_Spr_100k(i) ...
                            + (Casey_spr_temp_diff_100k(i)/2);

    Davis_sum_mean_temp_100k(i) = PCM_temp_Davis_Sum_100k(i) ...
                            + (Davis_sum_temp_diff_100k(i)/2);

    Davis_spr_mean_temp_100k(i) = PCM_temp_Davis_Spr_100k(i) ...
                            + (Davis_spr_temp_diff_100k(i)/2);

end

figure(3)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_temp_diff_100k)
    plot(t,Casey_spr_temp_diff_100k)
    plot(t,Davis_sum_temp_diff_100k)
    plot(t,Davis_spr_temp_diff_100k)
    ylabel('Temp Diff. [C]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Temp Diff across TEG - Wind = 100km/hr')
    hold off

figure(4)
    subplot(2,1,1)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_mean_temp_100k)
    plot(t,Casey_summer_temp)
    plot(t,PCM_temp_Casey_Sum_100k)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','PCM Temp')
    title('Temperatures - Casey - Summer - Wind = 100km/hr')
    hold off

    subplot(2,1,2)
    hold on
    grid on 
    grid minor
    plot(t,Casey_spr_mean_temp_100k)
    plot(t,Casey_spring_temp)
    plot(t,PCM_temp_Casey_Spr_100k)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','PCM Temp')
    title('Temperatures - Casey - Spring - Wind = 100km/hr')
    hold off

figure(5)
    subplot(2,1,1)
    hold on
    grid on 
    grid minor
    plot(t,Davis_sum_mean_temp_100k)
    plot(t,Davis_summer_temp)
    plot(t,PCM_temp_Davis_Sum_100k)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','PCM Temp')
    title('Temperatures - Davis - Summer - Wind = 100km/hr')
    hold off

    subplot(2,1,2)
    hold on
    grid on 
    grid minor
    plot(t,Davis_spr_mean_temp_100k)
    plot(t,Davis_spring_temp)
    plot(t,PCM_temp_Davis_Spr_100k)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','PCM Temp')
    title('Temperatures - Davis - Spring - Wind = 100km/hr')
    hold off

%% 4) Find TEG metrics and power values
% 24 cases to consider 
% 6x wind cases

%% TEG Voltage 
% V = N * seebck.(average temp) * temp_diff
N = 241; % number of p&n type conductors

% Seebeck
% dimensionless seebeck equation
% ~ =  (-1.132*10^(-5) .* (Casey_mean_temp)^2 )...
% + (8.64*10^(-3) .* (Casey_mean_temp(i))) ...
% - 0.582;


% seebeck variable across 24/hour cycle

%% wind = 10km/hr

seebeck_dim_Casey_sum_100k = zeros(1,length(t));
seebeck_dim_Casey_spr_100k = zeros(1,length(t));

seebeck_dim_Davis_sum_100k = zeros(1,length(t));
seebeck_dim_Davis_spr_100k = zeros(1,length(t));

% temperatures need to be in KELVIN to work

for i = 1:48
    Casey_sum_mean_temp_100k(i) = Casey_sum_mean_temp_100k(i) + 273.15;
    Casey_spr_mean_temp_100k(i) = Casey_spr_mean_temp_100k(i) + 273.15; 
    
    Davis_sum_mean_temp_100k(i) = Davis_sum_mean_temp_100k(i) + 273.15;
    Davis_spr_mean_temp_100k(i) = Davis_spr_mean_temp_100k(i) + 273.15;
end
% Celsius 2 Kelvin!!

for i = 1:48
    seebeck_dim_Casey_sum_100k(i) = ...
        (-1.132*10^(-5) .* (Casey_sum_mean_temp_100k(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_sum_mean_temp_100k(i))) ...
        - 0.582;

        seebeck_dim_Casey_spr_100k(i) = ...
        (-1.132*10^(-5) .* (Casey_spr_mean_temp_100k(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_spr_mean_temp_100k(i))) ...
        - 0.582;

        seebeck_dim_Davis_sum_100k(i) = ...
        (-1.132*10^(-5) .* (Davis_sum_mean_temp_100k(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_sum_mean_temp_100k(i))) ...
        - 0.582;

        seebeck_dim_Davis_spr_100k(i) = ...
        (-1.132*10^(-5) .* (Davis_spr_mean_temp_100k(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_spr_mean_temp_100k(i))) ...
        - 0.582;
end

% dim*stc = seebeck
seebeck_stc = 345 * 10^-6; % V / K @ T = 300 K

seebeck_Casey_sum_100k = zeros(1,length(t));
seebeck_Casey_spr_100k = zeros(1,length(t));

seebeck_Davis_sum_100k = zeros(1,length(t));
seebeck_Davis_spr_100k = zeros(1,length(t));

for i = 1:48 
    seebeck_Casey_sum_100k(i) = seebeck_dim_Casey_sum_100k(i).*seebeck_stc;
    seebeck_Casey_spr_100k(i) = seebeck_dim_Casey_spr_100k(i).*seebeck_stc;

    seebeck_Davis_sum_100k(i) = seebeck_dim_Davis_sum_100k(i).*seebeck_stc;
    seebeck_Davis_spr_100k(i) = seebeck_dim_Davis_spr_100k(i).*seebeck_stc;

end

% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum_100k = zeros(1,length(t));
TEG_V_Casey_spr_100k = zeros(1,length(t));

TEG_V_Davis_sum_100k = zeros(1,length(t));
TEG_V_Davis_spr_100k = zeros(1,length(t));

for i = 1:48
    
TEG_V_Casey_sum_100k(i) = N .* seebeck_Casey_sum_100k(i) ...
    .* Casey_sum_temp_diff_100k(i);

TEG_V_Casey_spr_100k(i) = N .* seebeck_Casey_spr_100k(i) ...
    .* Casey_spr_temp_diff_100k(i);


TEG_V_Davis_sum_100k(i) = N .* seebeck_Davis_sum_100k(i) ...
    .* Davis_sum_temp_diff_100k(i);

TEG_V_Davis_spr_100k(i) = N .* seebeck_Davis_spr_100k(i) ...
    .* Davis_spr_temp_diff_100k(i);

end

figure(6)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_Casey_sum_100k)
    plot(t,TEG_V_Casey_spr_100k)
    plot(t,TEG_V_Davis_sum_100k)
    plot(t,TEG_V_Davis_spr_100k)
    ylabel('Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Voltage across 1 TEG Module - wind = 100 km/hr')
    hold off


%% -- %% -- %% TEG INTERNAL RESISTANCE %% -- %% -- %%
% Variables
r_con = 5*(10^-9); % 
thick = 0.0011; % m - thickness - 1.1mm
area = 2.89 * 10^-6; % area - m^2  

elec_cond_stc = 28103; % Ohm.metre @ T = 300 K

% Davis_dim_elec_cond_max(i) = (6.257*10^(-5) .* (Davis_mean_temp_max(i))^2 )...
% - (4.381*10^(-2) .* (Davis_mean_temp_max(i))) ...
% + 8.629;

%% Wind = 50km/hr

elec_cond_dim_Casey_sum_100k = zeros(1,length(t));
elec_cond_dim_Casey_spr_100k = zeros(1,length(t));

elec_cond_dim_Davis_sum_100k = zeros(1,length(t));
elec_cond_dim_Davis_spr_100k = zeros(1,length(t));

for i = 1:48
    elec_cond_dim_Casey_sum_100k(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_100k(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_100k(i)) ) ...
        + 8.629;

    elec_cond_dim_Casey_spr_100k(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_100k(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_100k(i))) ...
        + 8.629;

    elec_cond_dim_Davis_sum_100k(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_100k(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_100k(i))) ...
        + 8.629; 

    elec_cond_dim_Davis_spr_100k(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_100k(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_100k(i))) ...
        + 8.629; 
end

% dim * stc = const
% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum_100k = zeros(1,length(t));
elec_cond_Casey_spr_100k = zeros(1,length(t));

elec_cond_Davis_sum_100k = zeros(1,length(t));
elec_cond_Davis_spr_100k = zeros(1,length(t));


for i = 1:48 
    elec_cond_Casey_sum_100k(i) = elec_cond_dim_Casey_sum_100k(i) .* elec_cond_stc;
    elec_cond_Casey_spr_100k(i) = elec_cond_dim_Casey_spr_100k(i) .* elec_cond_stc;

    elec_cond_Davis_sum_100k(i) = elec_cond_dim_Davis_sum_100k(i) .* elec_cond_stc;
    elec_cond_Davis_spr_100k(i) = elec_cond_dim_Davis_spr_100k(i) .* elec_cond_stc;
end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)
% need to be very careful - make cosntants where possible 

Casey_sum_R_i_100k = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_100k = zeros(1,length(t));

Davis_sum_R_i_100k = zeros(1,length(t));
Davis_spr_R_i_100k = zeros(1,length(t));

for i = 1:48
    
Casey_sum_R_i_100k(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_sum_100k(i) ) + ( (2.*r_con)./ thick) );

Casey_spr_R_i_100k(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_spr_100k(i) ) + ( (2.*r_con)./ thick) );

Davis_sum_R_i_100k(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_sum_100k(i) ) + ( (2.*r_con)./ thick) );

Davis_spr_R_i_100k(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_spr_100k(i) ) + ( (2.*r_con)./ thick) );

end

figure(7)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_R_i_100k)
    plot(t,Casey_spr_R_i_100k)
    plot(t,Davis_sum_R_i_100k)
    plot(t,Davis_spr_R_i_100k)
    ylabel('Internal Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Internal Resistance in 1 Module - Wind = 100km/hr')
    hold off

%% Power Generation 
% First calculate per module
% Use Karabetoglu equation: [P = (V^2) /( 4*R_i)]

%% Wind = 100km/hr
    TEG_P_Casey_sum_100k = zeros(1,length(t));
    TEG_P_Casey_spr_100k = zeros(1,length(t));
    
    TEG_P_Davis_sum_100k = zeros(1,length(t));
    TEG_P_Davis_spr_100k = zeros(1,length(t));

for i = 1:48
    TEG_P_Casey_sum_100k(i) =  (TEG_V_Casey_sum_100k(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_100k(i)); 
    
    TEG_P_Casey_spr_100k(i) =  (TEG_V_Casey_spr_100k(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_100k(i)); 
    
    TEG_P_Davis_sum_100k(i) =  (TEG_V_Davis_sum_100k(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_100k(i));
    
    TEG_P_Davis_spr_100k(i) =  (TEG_V_Davis_spr_100k(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_100k(i));
end

figure(8)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_100k)
    plot(t,TEG_P_Casey_spr_100k)
    plot(t,TEG_P_Davis_sum_100k)
    plot(t,TEG_P_Davis_spr_100k)
    ylabel('Power Rate [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power Generated per module - Karabetoglu et. al. 2012 [P^2/4R] - Wind = 100km/hr')
    hold off


% then calculate Power per PANEL - 17 x 18 ARRAY!
% Voltages
    TEG_V_row_Casey_sum_100k = zeros(1,length(t));
    TEG_V_row_Casey_spr_100k = zeros(1,length(t));
    
    TEG_V_row_Davis_sum_100k = zeros(1,length(t));
    TEG_V_row_Davis_spr_100k = zeros(1,length(t));

% Ohms - resistance
    Casey_sum_R_i_row_100k = zeros(1,length(t)); 
    Casey_spr_R_i_row_100k = zeros(1,length(t));
    
    Davis_sum_R_i_row_100k = zeros(1,length(t));
    Davis_spr_R_i_row_100k = zeros(1,length(t));

% Currents
    Casey_sum_amps_row_100k = zeros(1,length(t)); 
    Casey_spr_amps_row_100k = zeros(1,length(t));
    
    Davis_sum_amps_row_100k = zeros(1,length(t));
    Davis_spr_amps_row_100k = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Voltages   
    TEG_V_row_Casey_sum_100k(i) = TEG_V_Casey_sum_100k(i) .* 17; 
    TEG_V_row_Casey_spr_100k(i) = TEG_V_Casey_spr_100k(i) .* 17; 
    
    TEG_V_row_Davis_sum_100k(i) = TEG_V_Davis_sum_100k(i) .* 17; 
    TEG_V_row_Davis_spr_100k(i) = TEG_V_Davis_spr_100k(i) .* 17; 

% Resistances
    Casey_sum_R_i_row_100k(i) = Casey_sum_R_i_100k(i) .* 17;
    Casey_spr_R_i_row_100k(i) = Casey_spr_R_i_100k(i) .* 17;
    
    Davis_sum_R_i_row_100k(i) = Davis_sum_R_i_100k(i) .* 17;
    Davis_spr_R_i_row_100k(i) = Davis_spr_R_i_100k(i) .* 17;

% Currents
    Casey_sum_amps_row_100k(i) = ...
        TEG_V_row_Casey_sum_100k(i) ./ Casey_sum_R_i_row_100k(i);

    Casey_spr_amps_row_100k(i) = ...
        TEG_V_row_Casey_spr_100k(i) ./ Casey_spr_R_i_row_100k(i);
    

    Davis_sum_amps_row_100k(i) = ...
        TEG_V_row_Davis_sum_100k(i) ./ Davis_sum_R_i_row_100k(i);

    Davis_spr_amps_row_100k(i) = ...
        TEG_V_row_Davis_spr_100k(i) ./ Davis_spr_R_i_row_100k(i);

end

figure(9)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_row_Casey_sum_100k)
    plot(t,TEG_V_row_Casey_spr_100k)
    plot(t,TEG_V_row_Davis_sum_100k)
    plot(t,TEG_V_row_Davis_spr_100k)
    ylabel('TEG Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Voltage per Row (Sum of V) - Wind = 100km/hr')
    hold off

figure(10)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_R_i_row_100k)
    plot(t,Casey_spr_R_i_row_100k)
    plot(t,Davis_sum_R_i_row_100k)
    plot(t,Davis_spr_R_i_row_100k)
    ylabel('TEG Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Resistance per Row (Sum of R/Ohms) - Wind = 100km/hr')
    hold off

figure(11)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_amps_row_100k)
    plot(t,Casey_spr_amps_row_100k)
    plot(t,Davis_sum_amps_row_100k)
    plot(t,Davis_spr_amps_row_100k)
    ylabel('TEG Current [Amps]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Current per Row (V / R) - Wind = 100km/hr')
    hold off

    % in parallel aray 
% 18 rows of 17 modules 
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)


% Resistance
    Casey_sum_R_i_full_100k = zeros(1,length(t)); 
    Casey_spr_R_i_full_100k = zeros(1,length(t));
    
    Davis_sum_R_i_full_100k = zeros(1,length(t));
    Davis_spr_R_i_full_100k = zeros(1,length(t));

% Power
    TEG_P_Casey_sum_full_100k = zeros(1,length(t));
    TEG_P_Casey_spr_full_100k = zeros(1,length(t));
    
    TEG_P_Davis_sum_full_100k = zeros(1,length(t));
    TEG_P_Davis_spr_full_100k = zeros(1,length(t));

% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Resistance
    Casey_sum_R_i_full_100k(i) = (18 ./ Casey_sum_R_i_row_100k(i) ).^-1 ;  
    Casey_spr_R_i_full_100k(i) = (18 ./ Casey_spr_R_i_row_100k(i) ).^-1 ;
    
    Davis_sum_R_i_full_100k(i) = (18 ./ Davis_sum_R_i_row_100k(i) ).^-1 ;
    Davis_spr_R_i_full_100k(i) = (18 ./ Davis_spr_R_i_row_100k(i) ).^-1 ;

% Power - KARABETOGLU EQUATION
    TEG_P_Casey_sum_full_100k(i) =  (TEG_V_row_Casey_sum_100k(i).^(2)) ./ ...
                          (4.*Casey_sum_R_i_full_100k(i)); 
    
    TEG_P_Casey_spr_full_100k(i) =  (TEG_V_row_Casey_spr_100k(i).^(2)) ./ ...
                          (4.*Casey_spr_R_i_full_100k(i)); 
    
    TEG_P_Davis_sum_full_100k(i) =  (TEG_V_row_Davis_sum_100k(i).^(2)) ./ ...
                          (4.*Davis_sum_R_i_full_100k(i));
    
    TEG_P_Davis_spr_full_100k(i) =  (TEG_V_row_Davis_spr_100k(i).^(2)) ./ ...
                          (4.*Davis_spr_R_i_full_100k(i));

end

figure(12)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_full_100k)
    plot(t,TEG_P_Casey_spr_full_100k)
    plot(t,TEG_P_Davis_sum_full_100k)
    plot(t,TEG_P_Davis_spr_full_100k)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per 1 Solar Panel - [Wind = 100km/hr]')
    hold off


%% Power Generation - Unit Area 
% For power comparison metrics
% in W/m^2
surf_area = (0.056 * 0.056); % 56mm * 56 mm

% 20 cases - compare per clouds case [5x]
% "TEG_P_Casey_sum_80"

% - [Wind = 10km/hr] - %
TEG_P_Casey_sum_100k_unit = zeros(1,length(t));
TEG_P_Casey_spr_100k_unit = zeros(1,length(t));

TEG_P_Davis_sum_100k_unit = zeros(1,length(t));
TEG_P_Davis_spr_100k_unit = zeros(1,length(t));

for i = 1:48 

    TEG_P_Casey_sum_100k_unit(i) = TEG_P_Casey_sum_100k(i) ./ surf_area;
    TEG_P_Casey_spr_100k_unit(i) = TEG_P_Casey_spr_100k(i) ./ surf_area;

    TEG_P_Davis_sum_100k_unit(i) = TEG_P_Davis_sum_100k(i) ./ surf_area;
    TEG_P_Davis_spr_100k_unit(i) = TEG_P_Davis_spr_100k(i) ./ surf_area;

    % Remember: this is with Karabetoglu equation (conservative)
end

figure(13)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_100k_unit)
    plot(t,TEG_P_Casey_spr_100k_unit)
    plot(t,TEG_P_Davis_sum_100k_unit)
    plot(t,TEG_P_Davis_spr_100k_unit)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per Unit area - [Wind = 100km/hr]')
    hold off





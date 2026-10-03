%% TEG Temp Profile in time 
% Use PCM and PV temp profiles 

% Casey Station, Summer - 6 hour window (9am - 3pm)[19-31]
% Casey Station, Spring - 3 hour window (10:30am-1:30pm)[22-28]

% Davis Station, Summer - 10 hour window (7am - 5pm)[15-35]
% Davis Station, Spring - 4 hour window (10am-2pm) [21-29]
% Casey - Summer (9am-3pm)
clc;
clear all;


%% Time vector - discretisation of 24-hour window 
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


%% Import PV temperature equation from Solar code
T_cell_Casey_summer = zeros(1,length(t));
T_cell_Casey_spring = zeros(1,length(t)); 

T_cell_Davis_summer = zeros(1,length(t));
T_cell_Davis_spring = zeros(1,length(t));


NOCT = 44; % C - Nominal Cell Temperature 
Casey_Solar_irradiance = 88.05; % Wh/m^2 ~ W/m^2 - ~65deg.S
Davis_Solar_irradiance = 71.25; % Wh/m^2 ~ W/m^2 - ~70deg.S
% spotted error in pv code for accounting sun during only day 
% for now, consider fixed irradaiance value during day

% NEED TO INSERT READTABLE FUNCTION HERE TO ACCOMODATE FOR ALL 20 PV CASES!





%% SOLAR CELL TEMP - CASEY SUM temp range: 
    % night: 1-18 [t(18) = 8.5]
    % Day: 19-31
    % Night: 32-48

for i = 1:19
    T_cell_Casey_summer(i) = Casey_summer_temp(i) ; 
end 

for i = 20:30
    T_cell_Casey_summer(i) = Casey_summer_temp(i) + ...
                        (NOCT-20).*(Casey_Solar_irradiance/800);
end

for i = 31:48
    T_cell_Casey_summer(i) = Casey_summer_temp(i) ; 
end 

%% SOLAR CELL - CASEY SPR - 3 hour window (10:30am-1:30pm)[22-28]
    % Night: 1-21 [t(21) = 10am]
    % Day: 22-28
    % Night: 29-48

for i = 1:22
    T_cell_Casey_spring(i) = -25.2;
end

for i = 23:27
    T_cell_Casey_spring(i) = Casey_spring_temp(i) + ...
                        (NOCT-20).*(Casey_Solar_irradiance/800);
end

for i = 28:48
    T_cell_Casey_spring(i) = -25.2;
end


%% Davis summer temp range: 
    % Night: 1-14 [t(14) = 630am]
    % Day: 15-(25)-35
    % Night: 36-48

for i = 1:15
    T_cell_Davis_summer(i) = -3.6;
end

for i = 16:34
    T_cell_Davis_summer(i) = Davis_summer_temp(i) + ...
                    (NOCT-20).*(Davis_Solar_irradiance/800);
end

for i = 35:48
    T_cell_Davis_summer(i) = -3.6;
end

%% Davis Spring - 4 hour window (10am-2pm) [21-29]
% Night: 1-20 [t(20) = 930am]
% Day: 21-(25)-29
% Night: 30-48

for i = 1:21 
    T_cell_Davis_spring(i) = -26.2; 
end

for i = 22:28
    T_cell_Davis_spring(i) = Davis_spring_temp(i) + ...
                   (NOCT-20).*(Davis_Solar_irradiance/800);

end

for i = 29:48
    T_cell_Davis_spring(i) = -26.2;
end

% plot values
figure(4)
hold on
grid on 
grid minor
plot(t,T_cell_Casey_summer)
plot(t,T_cell_Casey_spring)
plot(t,T_cell_Davis_summer)
plot(t,T_cell_Davis_spring)
ylabel('Temp [C]')
xlabel('Time - 24 hour')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('Solar Cell Temperature')
hold off

% PCM temperature profile?
% PCM_2.1 - energy chara. not accurate enough yet
% instead, treating PCM temp as =ambient at end of each timestep




%% Temperature Profiles
% Temperature difference - STATIC GIVEN APPROXIMATIONS
% For now just keep orientation as UP - top

% Casey summer
Casey_sum_temp_diff = zeros(1,length(t));
% Casey Spring
Casey_spr_temp_diff = zeros(1,length(t));
% Davis sum
Davis_sum_temp_diff = zeros(1,length(t));
% Davis spring
Davis_spr_temp_diff = zeros(1,length(t));

for i = 1:48 
    Casey_sum_temp_diff(i) = T_cell_Casey_summer(i) - Casey_summer_temp(i);
    Casey_spr_temp_diff(i) = T_cell_Casey_spring(i) - Casey_spring_temp(i);

    Davis_sum_temp_diff(i) = T_cell_Davis_summer(i) - Davis_summer_temp(i);
    Davis_spr_temp_diff(i) = T_cell_Davis_spring(i) - Davis_spring_temp(i);

end

figure(3)
hold on
grid on 
grid minor
plot(t,Casey_sum_temp_diff)
plot(t,Casey_spr_temp_diff)
plot(t,Davis_sum_temp_diff)
plot(t,Davis_spr_temp_diff)
ylabel('Temp Difference [C or K]')
xlabel('Time - 24 hour')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('Temp Difference')
hold off

% mean temperature - derived from temperature difference

Casey_sum_mean_temp = zeros(1,length(t));
Casey_spr_mean_temp = zeros(1,length(t));

Davis_sum_mean_temp = zeros(1,length(t));
Davis_spr_mean_temp = zeros(1,length(t));

for i = 1:48
    Casey_sum_mean_temp(i) = Casey_summer_temp(i) ...
                            + (Casey_sum_temp_diff(i)/2);
    
    Casey_spr_mean_temp(i) = Casey_spring_temp(i) ...
                            + (Casey_spr_temp_diff(i)/2);

    Davis_sum_mean_temp(i) = Davis_summer_temp(i) ...
                            + (Davis_sum_temp_diff(i)/2);

    Davis_spr_mean_temp(i) = Davis_spring_temp(i) ...
                            + (Davis_spr_temp_diff(i)/2);

end

figure(2)
hold on
grid on 
grid minor
plot(t,Casey_sum_mean_temp)
plot(t,Casey_spr_mean_temp)
plot(t,Davis_sum_mean_temp)
plot(t,Davis_spr_mean_temp)
ylabel('Mean Temp [C]')
xlabel('Time - 24 hour')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('Mean Temp across TEG')
hold off

figure(5)
subplot(2,1,1)
hold on
grid on 
grid minor
plot(t,Casey_sum_mean_temp)
plot(t,Casey_summer_temp)
plot(t,T_cell_Casey_summer)
ylabel('Temp [C]')
xlabel('Time - 24 hour')
legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
title('Temperatures - Casey - Summer')
hold off

subplot(2,1,2)
hold on
grid on 
grid minor
plot(t,Casey_spr_mean_temp)
plot(t,Casey_spring_temp)
plot(t,T_cell_Casey_spring)
ylabel('Temp [C]')
xlabel('Time - 24 hour')
legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
title('Temperatures - Casey - Spring')
hold off


figure(6)
subplot(2,1,1)
hold on
grid on 
grid minor
plot(t,Davis_sum_mean_temp)
plot(t,Davis_summer_temp)
plot(t,T_cell_Davis_summer)
ylabel('Temp [C]')
xlabel('Time - 24 hour')
legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
title('Temperatures - Davis - Summer')
hold off

subplot(2,1,2)
hold on
grid on 
grid minor
plot(t,Davis_spr_mean_temp)
plot(t,Davis_spring_temp)
plot(t,T_cell_Davis_spring)
ylabel('Temp [C]')
xlabel('Time - 24 hour')
legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
title('Temperatures - Davis - Spring')
hold off



%% TEG Voltage 
% V = N * seebck.(average temp) * temp_diff
N = 241; % number of p&n type conductors

% Seebeck
% dimensionless seebeck equation
% ~ =  (-1.132*10^(-5) .* (Casey_mean_temp)^2 )...
% + (8.64*10^(-3) .* (Casey_mean_temp(i))) ...
% - 0.582;

% seebeck variable across 24/hour cycle

seebeck_dim_Casey_sum = zeros(1,length(t));
seebeck_dim_Casey_spr = zeros(1,length(t));

seebeck_dim_Davis_sum = zeros(1,length(t));
seebeck_dim_Davis_spr = zeros(1,length(t));

% temperatures need to be in KELVIN to work

for i = 1:48
    Casey_sum_mean_temp(i) = Casey_sum_mean_temp(i) + 273.15;
    Casey_spr_mean_temp(i) = Casey_spr_mean_temp(i) + 273.15; 
    
    Davis_sum_mean_temp(i) = Davis_sum_mean_temp(i) + 273.15;
    Davis_spr_mean_temp(i) = Davis_spr_mean_temp(i) + 273.15;
end
% Celsius 2 Kelvin!!

for i = 1:48
    seebeck_dim_Casey_sum(i) = ...
        (-1.132*10^(-5) .* (Casey_sum_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_sum_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Casey_spr(i) = ...
        (-1.132*10^(-5) .* (Casey_spr_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_spr_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Davis_sum(i) = ...
        (-1.132*10^(-5) .* (Davis_sum_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_sum_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Davis_spr(i) = ...
        (-1.132*10^(-5) .* (Davis_spr_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_spr_mean_temp(i))) ...
        - 0.582;
end

% dim*stc = seebeck
seebeck_stc = 345 * 10^-6; % V / K @ T = 300 K

seebeck_Casey_sum = zeros(1,length(t));
seebeck_Casey_spr = zeros(1,length(t));

seebeck_Davis_sum = zeros(1,length(t));
seebeck_Davis_spr = zeros(1,length(t));

for i = 1:48 
    seebeck_Casey_sum(i) = seebeck_dim_Casey_sum(i).*seebeck_stc;
    seebeck_Casey_spr(i) = seebeck_dim_Casey_spr(i).*seebeck_stc;

    seebeck_Davis_sum(i) = seebeck_dim_Davis_sum(i).*seebeck_stc;
    seebeck_Davis_spr(i) = seebeck_dim_Davis_spr(i).*seebeck_stc;

end

% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum = zeros(1,length(t));
TEG_V_Casey_spr = zeros(1,length(t));

TEG_V_Davis_sum = zeros(1,length(t));
TEG_V_Davis_spr = zeros(1,length(t));

for i = 1:48
    
TEG_V_Casey_sum(i) = N .* seebeck_Casey_sum(i) .* Casey_sum_temp_diff(i);
TEG_V_Casey_spr(i) = N .* seebeck_Casey_spr(i) .* Casey_spr_temp_diff(i);

TEG_V_Davis_sum(i) = N .* seebeck_Davis_sum(i) .* Davis_sum_temp_diff(i);
TEG_V_Davis_spr(i) = N .* seebeck_Davis_spr(i) .* Davis_spr_temp_diff(i);


end

figure(7)
hold on
grid on 
grid minor
plot(t,TEG_V_Casey_sum)
plot(t,TEG_V_Casey_spr)
plot(t,TEG_V_Davis_sum)
plot(t,TEG_V_Davis_spr)
ylabel('Voltage [V]')
xlabel('Time - 24 hour')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('Voltage across TEG - 1 module')
hold off

%% TEG Internal Resistance 
% Variables
r_con = 5*(10^-9); % 
thick = 0.0011; % m - thickness - 1.1mm
area = 2.89 * 10^-6; % area - m^2  

elec_cond_stc = 28103; % Ohm.metre @ T = 300 K

elec_cond_dim_Casey_sum = zeros(1,length(t));
elec_cond_dim_Casey_spr = zeros(1,length(t));

elec_cond_dim_Davis_sum = zeros(1,length(t));
elec_cond_dim_Davis_spr = zeros(1,length(t));

% Davis_dim_elec_cond_max(i) = (6.257*10^(-5) .* (Davis_mean_temp_max(i))^2 )...
% - (4.381*10^(-2) .* (Davis_mean_temp_max(i))) ...
% + 8.629;

for i = 1:48
    elec_cond_dim_Casey_sum(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp(i)) ) ...
        + 8.629;

    elec_cond_dim_Casey_spr(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp(i))) ...
        + 8.629;

    elec_cond_dim_Davis_sum(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp(i))) ...
        + 8.629; 

    elec_cond_dim_Davis_spr(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp(i))) ...
        + 8.629; 
end


% dim * stc = const
% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum = zeros(1,length(t));
elec_cond_Casey_spr = zeros(1,length(t));

elec_cond_Davis_sum = zeros(1,length(t));
elec_cond_Davis_spr = zeros(1,length(t));


for i = 1:48 
    elec_cond_Casey_sum(i) = elec_cond_dim_Casey_sum(i) .* elec_cond_stc;
    elec_cond_Casey_spr(i) = elec_cond_dim_Casey_spr(i) .* elec_cond_stc;

    elec_cond_Davis_sum(i) = elec_cond_dim_Davis_sum(i) .* elec_cond_stc;
    elec_cond_Davis_spr(i) = elec_cond_dim_Davis_spr(i) .* elec_cond_stc;
end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)
% need to be very careful - make cosntants where possible 

Casey_sum_R_i = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i = zeros(1,length(t));

Davis_sum_R_i = zeros(1,length(t));
Davis_spr_R_i = zeros(1,length(t));

for i = 1:48
    
Casey_sum_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_sum(i) ) + ( (2.*r_con)./ thick) );

Casey_spr_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_spr(i) ) + ( (2.*r_con)./ thick) );

Davis_sum_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_sum(i) ) + ( (2.*r_con)./ thick) );

Davis_spr_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_spr(i) ) + ( (2.*r_con)./ thick) );

end

figure(8)
hold on
grid on 
grid minor
plot(t,Casey_sum_R_i)
plot(t,Casey_spr_R_i)
plot(t,Davis_sum_R_i)
plot(t,Davis_spr_R_i)
ylabel('Internal Resistance [Ohms]')
xlabel('Time - 24 hour')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('Internal Resistance - 1 module')
hold off

%% TEG Power per module 
% P = (V^2) /( 4*R_i)

TEG_P_Casey_sum = zeros(1,length(t));
TEG_P_Casey_spr = zeros(1,length(t));

TEG_P_Davis_sum = zeros(1,length(t));
TEG_P_Davis_spr = zeros(1,length(t));


for i = 1:48

TEG_P_Casey_sum(i) =  (TEG_V_Casey_sum(i).^(2)) ./ ...
                      (4 .* Casey_sum_R_i(i)); 

TEG_P_Casey_spr(i) =  (TEG_V_Casey_spr(i).^(2)) ./ ...
                      (4 .* Casey_spr_R_i(i)); 

TEG_P_Davis_sum(i) =  (TEG_V_Davis_sum(i).^(2)) ./ ...
                      (4 .* Davis_sum_R_i(i));

TEG_P_Davis_spr(i) =  (TEG_V_Davis_spr(i).^(2)) ./ ...
                      (4 .* Davis_spr_R_i(i));

end

figure(9)
hold on
grid on 
grid minor
plot(t,TEG_P_Casey_sum)
plot(t,TEG_P_Casey_spr)
plot(t,TEG_P_Davis_sum)
plot(t,TEG_P_Davis_spr)
ylabel('Power Rate [W]')
xlabel('Time - 24 hour')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('TEG Power Generated - per module - Karabetoglu et. al. 2012')
hold off


%% TEG per unit area
% used for comparisons - not FINAL REPRESENTATION 
% more nuance needs to be considered

% that nuance is ELECTRICAL LAWS 
% choose 17 modules per row, 18 rows
% in a single row: series rules
% in full module: parallel



basic_TEG_P_Casey_sum = zeros(1,length(t));
basic_TEG_P_Casey_spr = zeros(1,length(t));

basic_TEG_P_Davis_sum = zeros(1,length(t));
basic_TEG_P_Davis_spr = zeros(1,length(t));

for i = 1:48

    basic_TEG_P_Casey_sum(i) = (TEG_V_Casey_sum(i).^(2)) ./ ...
                                (Casey_sum_R_i(i));
    
    basic_TEG_P_Casey_spr(i) = (TEG_V_Casey_spr(i).^(2)) ./ ...
                                (Casey_spr_R_i(i));

    basic_TEG_P_Davis_sum(i) = (TEG_V_Davis_sum(i).^(2)) ./ ...
                                (Davis_sum_R_i(i));

    basic_TEG_P_Davis_spr(i) = (TEG_V_Davis_spr(i).^(2)) ./ ...
                                (Davis_spr_R_i(i));

end

figure(10)
hold on
grid on 
grid minor
plot(t,basic_TEG_P_Casey_sum)
plot(t,basic_TEG_P_Casey_spr)
plot(t,basic_TEG_P_Davis_sum)
plot(t,basic_TEG_P_Davis_spr)
ylabel('Power Rate per module [W]')
xlabel('Time - 24 hour')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('TEG Power Generated - per module - P = V^2 / R')
hold off




%% Scale up for array 17x18

% For singular row of 17 modules

% Voltages
TEG_V_row_Casey_sum = zeros(1,length(t));
TEG_V_row_Casey_spr = zeros(1,length(t));

TEG_V_row_Davis_sum = zeros(1,length(t));
TEG_V_row_Davis_spr = zeros(1,length(t));

% Ohms - resistance
Casey_sum_R_i_row = zeros(1,length(t)); 
Casey_spr_R_i_row = zeros(1,length(t));

Davis_sum_R_i_row = zeros(1,length(t));
Davis_spr_R_i_row = zeros(1,length(t));

% Currents
Casey_sum_amps_row = zeros(1,length(t)); 
Casey_spr_amps_row = zeros(1,length(t));

Davis_sum_amps_row = zeros(1,length(t));
Davis_spr_amps_row = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Voltages   
    TEG_V_row_Casey_sum(i) = TEG_V_Casey_sum(i) .* 17; 
    TEG_V_row_Casey_spr(i) = TEG_V_Casey_spr(i) .* 17; 
    
    TEG_V_row_Davis_sum(i) = TEG_V_Davis_sum(i) .* 17; 
    TEG_V_row_Davis_spr(i) = TEG_V_Davis_spr(i) .* 17; 

% Resistances
    Casey_sum_R_i_row(i) = Casey_sum_R_i(i) .* 17;
    Casey_spr_R_i_row(i) = Casey_spr_R_i(i) .* 17;
    
    Davis_sum_R_i_row(i) = Davis_sum_R_i(i) .* 17;
    Davis_spr_R_i_row(i) = Davis_spr_R_i(i) .* 17;

% Currents
    Casey_sum_amps_row(i) = TEG_V_row_Casey_sum(i) ./ Casey_sum_R_i_row(i);
    Casey_spr_amps_row(i) = TEG_V_row_Casey_spr(i) ./ Casey_spr_R_i_row(i);
    
    Davis_sum_amps_row(i) = TEG_V_row_Davis_sum(i) ./ Davis_sum_R_i_row(i);
    Davis_spr_amps_row(i) = TEG_V_row_Davis_spr(i) ./ Davis_spr_R_i_row(i);

end


figure(11)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_row_Casey_sum)
    plot(t,TEG_V_row_Casey_spr)
    plot(t,TEG_V_row_Davis_sum)
    plot(t,TEG_V_row_Davis_spr)
    ylabel('TEG Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Voltage per Row (Sum of V)')
    hold off

figure(12)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_R_i_row)
    plot(t,Casey_spr_R_i_row)
    plot(t,Davis_sum_R_i_row)
    plot(t,Davis_spr_R_i_row)
    ylabel('TEG Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Resistance per Row (Sum of R/Ohms)')
    hold off

figure(13)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_amps_row)
    plot(t,Casey_spr_amps_row)
    plot(t,Davis_sum_amps_row)
    plot(t,Davis_spr_amps_row)
    ylabel('TEG Current [Amps]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Current per Row (V / R)')
    hold off


% in parallel aray 
% 18 rows of 17 modules 
% USING EQUATION [P = (I^2) * R] FOR THIS PART
% equation not from Karabetoglu BUT does consider TEG aray
% opting for this feels realistic - Karabetoglu provides no justification
% for their equation

% Currents
Casey_sum_amps_full = zeros(1,length(t)); 
Casey_spr_amps_full = zeros(1,length(t));

Davis_sum_amps_full = zeros(1,length(t));
Davis_spr_amps_full = zeros(1,length(t));

% Resistance
Casey_sum_R_i_full = zeros(1,length(t)); 
Casey_spr_R_i_full = zeros(1,length(t));

Davis_sum_R_i_full = zeros(1,length(t));
Davis_spr_R_i_full = zeros(1,length(t));

% Power
TEG_P_Casey_sum_full = zeros(1,length(t));
TEG_P_Casey_spr_full = zeros(1,length(t));

TEG_P_Davis_sum_full = zeros(1,length(t));
TEG_P_Davis_spr_full = zeros(1,length(t));

% recall - 18 rows
for i = 1:48
% Currents
    Casey_sum_amps_full(i) = Casey_sum_amps_row(i) .* 18;
    Casey_spr_amps_full(i) = Casey_spr_amps_row(i) .* 18;
    
    Davis_sum_amps_full(i) = Davis_sum_amps_row(i) .* 18;
    Davis_spr_amps_full(i) = Davis_spr_amps_row(i) .* 18;


% Resistance
    Casey_sum_R_i_full(i) = (18 ./ Casey_sum_R_i_row(i) ).^-1 ;  
    Casey_spr_R_i_full(i) = (18 ./ Casey_spr_R_i_row(i) ).^-1 ;
    
    Davis_sum_R_i_full(i) = (18 ./ Davis_sum_R_i_row(i) ).^-1 ;
    Davis_spr_R_i_full(i) = (18 ./ Davis_spr_R_i_row(i) ).^-1 ;

% Power
    TEG_P_Casey_sum_full(i) = ...
        (Casey_sum_amps_full(i).^2).*Casey_sum_R_i_full(i);

    TEG_P_Casey_spr_full(i) = ...
        (Casey_spr_amps_full(i).^2).*Casey_spr_R_i_full(i);
    
    TEG_P_Davis_sum_full(i) = ...
        (Davis_sum_amps_full(i).^2).*Davis_sum_R_i_full(i);

    TEG_P_Davis_spr_full(i) = ...
        (Davis_spr_amps_full(i).^2).*Davis_spr_R_i_full(i);

end

figure(14)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_full)
    plot(t,TEG_P_Casey_spr_full)
    plot(t,TEG_P_Davis_sum_full)
    plot(t,TEG_P_Davis_spr_full)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (I^2 * R)')
    hold off




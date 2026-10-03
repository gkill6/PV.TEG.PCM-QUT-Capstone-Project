%% St3.2 - 2D individual simulation (w.r.t. time)
% after reviewing with V&V, establishd code is sufficient to keep,
% now includes cloud cover % 
% awaiting excel function to better increase "universality" of testing
% 
%% Solar Profile Establishment 
% Basedon DD2.1 & HC2.1, sinusoidal model selected for solar behaviour
% Piecewise function dependent on time & location 
clc;
clear all;


% Initial Conditions - Static Variables
    % Maximum radiation based on latitude 
    Casey_Solar_irradiance = 88.05; % Wh/m^2 ~ W/m^2 - ~65deg.S
    Davis_Solar_irradiance = 71.25; % Wh/m^2 ~ W/m^2 - ~70deg.S

    % Time vector - discretisation of 24-hour window 
    t = 0:0.5:23.5;

    % Define time vectors for seasons
    Casey_summer_irradiance = zeros(1,length(t));
    Davis_summer_irradiance = zeros(1,length(t));

    Casey_spring_irradiance = zeros(1,length(t));
    Davis_spring_irradiance = zeros(1,length(t));

%% Create piecewise functions for each season 
% Casey Station, Summer - 6 hour window (9am - 3pm)[19-31]
for i = 19:1:31
    Casey_summer_irradiance(i) = sin( ((pi./6).*t(i)) - ((9.*pi)./6));
end 

% Davis Station, Summer - 10 hour window (7am - 5pm)[15-35]
for i = 15:1:35
    Davis_summer_irradiance(i) = sin( ((pi./10).*t(i)) - ((7.*pi)./10));
end

% Casey Station, Spring - 3 hour window (10:30am-1:30pm)[22-28]
for i = 22:1:28
    Casey_spring_irradiance(i) =  sin( ((pi./3).*t(i)) - ((9.*pi)./6));
end

% Davis Station, Spring - 4 hour window (10am-2pm)
for i = 21:1:29
    Davis_spring_irradiance(i) = sin( ((pi./4).*t(i)) - ((2.*pi)./4));
end

%% Plot figures - sanity check 

figure(1)
hold on
plot(t,Casey_summer_irradiance)
plot(t,Casey_spring_irradiance)
plot(t,Davis_summer_irradiance)
plot(t,Davis_spring_irradiance)
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
xlabel('Time - 24 hr')
ylabel('Amplitude (0-1)')
title('Solar profile Amplitude (zero to one)')
hold off

% solar irradiance values 

for i = 1:48
Casey_summer_irradiance(i) = Casey_summer_irradiance(i) .* ...
                                Casey_Solar_irradiance;

Casey_spring_irradiance(i) = Casey_spring_irradiance(i) .* ...
                                Casey_Solar_irradiance;

Davis_summer_irradiance(i) = Davis_summer_irradiance(i) .* ...
                                Davis_Solar_irradiance;

Davis_spring_irradiance(i) = Davis_spring_irradiance(i) .* ...
                                Davis_Solar_irradiance;
end




figure(2)
hold on
grid on
grid minor
plot(t,Casey_summer_irradiance)
plot(t,Casey_spring_irradiance)
plot(t,Davis_summer_irradiance)
plot(t,Davis_spring_irradiance)
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
xlabel('Time - 24 hr')
ylabel('Solar Irradiance (W/m^2)')
title('Solar profile Irradiance - Summer vs. Spring')
hold off


%% Temperature profiles - approximations of ambient temperature
%% Casey - Summer (9am-3pm)
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



%% Casey - Spring
Casey_spring_temp = zeros(1,length(t));
% Casey Spring - 3 hour window (10:30am-1:30pm)[22-28]
    % Night: 1-21 [t(21) = 10am]
    % Day: 22-28
    % Night: 29-48

for i = 1:21
    Casey_spring_temp(i) = -25.2;
end

for i = 22:25
% initial temp @ 10:30am 
    if i == 22
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


%% Davis - Summer
Davis_summer_temp = zeros(1,length(t));
% Davis summer temp range: 
    % Night: 1-14 [t(14) = 630am]
    % Day: 15-(25)-35
    % Night: 36-48

for i = 1:14
    Davis_summer_temp(i) = -3.6;
end

for i = 15:25
    if i == 15 % initial temp @ tam
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



%% Davis - Spring
Davis_spring_temp = zeros(1,length(t));
% Davis Spring - 4 hour window (10am-2pm) [21-29]
    % Night: 1-20 [t(20) = 930am]
    % Day: 21-(25)-29
    % Night: 30-48

for i = 1:20
    Davis_spring_temp(i) = -26.2;
end 

for i = 21:25 
    if i == 21 %initial temp @ 10am
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

%% Plot - sanity check
figure(3)
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


%% PV Cell temperature
% Static Variables
P_stc = 300; % W - Rated power @ STC
NOCT = 44; % C - Nominal Cell Temperature 
temp_coeff = -0.4; % [%] - temperature coefficient
% given ambient temperatures calculated, now can find PV power 

% Cell temperature - seasonal 
T_cell_Casey_summer = zeros(1,length(t));
T_cell_Casey_spring = zeros(1,length(t)); 

T_cell_Davis_summer = zeros(1,length(t));
T_cell_Davis_spring = zeros(1,length(t));


% CORRECTION: NO ERROR BECAUSE "IRRADIANCE" IS ZERO @ RELEVANT TIME POINTS
% no rectification needed
for i = 1:48
    T_cell_Casey_summer(i) = Casey_summer_temp(i) + ...
                        (NOCT-20).*(Casey_summer_irradiance(i)/800);

    T_cell_Casey_spring(i) = Casey_spring_temp(i) + ...
                        (NOCT-20).*(Casey_spring_irradiance(i)/800);

    T_cell_Davis_summer(i) = Davis_summer_temp(i) + ...
                        (NOCT-20).*(Davis_summer_irradiance(i)/800);

    T_cell_Davis_spring(i) = Davis_spring_temp(i) + ...
                        (NOCT-20).*(Davis_spring_irradiance(i)/800);
end

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


% Temperature coefficient 

f_temp_Casey_summer = zeros(1,length(t));
f_temp_Casey_spring = zeros(1,length(t));

f_temp_Davis_summer = zeros(1,length(t));
f_temp_Davis_spring = zeros(1,length(t));


for i = 1:48
    
    f_temp_Casey_summer(i) = 1 + ((temp_coeff/100) ...
                                .* (T_cell_Casey_summer(i) - 25)); 

    f_temp_Casey_spring(i) = 1 + ((temp_coeff/100) ...
                                .* (T_cell_Casey_spring(i) - 25));

    f_temp_Davis_summer(i) = 1 + ((temp_coeff/100) ...
                                .* (T_cell_Davis_summer(i) - 25));

    f_temp_Davis_spring(i) = 1 + ((temp_coeff/100) ...
                                .* (T_cell_Davis_spring(i) - 25));

end

% Panel Power
% Note: this maps the RATE OF POWER GEN given time
    % i.e. area under curve finds TOTAL power gen

P_gen_Casey_summer = zeros(1,length(t));
P_gen_Casey_spring = zeros(1,length(t));

P_gen_Davis_summer = zeros(1,length(t));
P_gen_Davis_spring = zeros(1,length(t)); 

for i = 1:48 
    
    P_gen_Casey_summer(i) = P_stc .* ...
                            (Casey_summer_irradiance(i)/1000) .* ...
                            f_temp_Casey_summer(i);

    P_gen_Casey_spring(i) = P_stc .* ...
                            (Casey_spring_irradiance(i)/1000) .* ...
                            f_temp_Casey_spring(i);

    P_gen_Davis_summer(i) = P_stc .* ...
                            (Davis_summer_irradiance(i)/1000) .* ...
                            f_temp_Davis_summer(i);

    P_gen_Davis_spring(i) = P_stc .* ...
                            (Davis_spring_irradiance(i)/1000) .* ...
                            f_temp_Davis_spring(i);

end 

figure(5)
hold on 
grid on
grid minor
plot(t,P_gen_Casey_summer)
plot(t,P_gen_Casey_spring)
plot(t,P_gen_Davis_summer)
plot(t,P_gen_Davis_spring)
xlabel('Time - 24 hour')
xticks(0:0.5:23.5)
ylabel('Power gen (W)')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('Power generation - single panel')
hold off

k = 30;

figure(50)
hold on 
grid on
grid minor
plot(t,k*P_gen_Casey_summer)
plot(t,k*P_gen_Casey_spring)
plot(t,k*P_gen_Davis_summer)
plot(t,k*P_gen_Davis_spring)
xlabel('Time - 24 hour')
xticks(0:0.5:23.5)
ylabel('Power gen (W)')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('Power generation - 30 panels')
hold off


%% Convert Power to unit area
% AREA POWER = P_gen / area of solar cells 
cell_size = (0.15675 * 0.15675); % m^2 
num_cell = 60;
eff_sol_area = cell_size * num_cell; % effective solar cell area

P_gen_Casey_summer_unit_area = zeros(1,length(t));
P_gen_Casey_spring_unit_area = zeros(1,length(t));

P_gen_Davis_summer_unit_area = zeros(1,length(t));
P_gen_Davis_spring_unit_area = zeros(1,length(t)); 

for i = 1:48

    P_gen_Casey_summer_unit_area(i) = P_gen_Casey_summer(i) ...
                                      ./ eff_sol_area;

    P_gen_Casey_spring_unit_area(i) = P_gen_Casey_spring(i) ...
                                      ./ eff_sol_area;

    P_gen_Davis_summer_unit_area(i) = P_gen_Davis_summer(i) ...
                                      ./ eff_sol_area;

    P_gen_Davis_spring_unit_area(i) = P_gen_Davis_spring(i) ...
                                      ./ eff_sol_area;

end

figure(6)
hold on
grid on
grid minor
plot(t,P_gen_Casey_summer_unit_area)
plot(t,P_gen_Casey_spring_unit_area)
plot(t,P_gen_Davis_summer_unit_area)
plot(t,P_gen_Davis_spring_unit_area)
xlabel('Time - 24 hour')
xticks(0:0.5:23.5)
ylabel('Power gen (W/m^2)')
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
title('Solar Power generation - unit area')
hold off

%% temp comparisons
figure(10)
hold on
grid on 
grid minor
plot(t,Casey_summer_temp)
plot(t,T_cell_Casey_summer)
plot(t,Casey_spring_temp)
plot(t,T_cell_Casey_spring)
legend('Sum - Amb','Sum - Cell','Spr - Amb','Spr - Cell')
xlabel('Time - 24 hr')
ylabel('Temp (C)')
title('Casey Temp Comparisons')
hold off

figure(11)
hold on
grid on 
grid minor
plot(t,Davis_summer_temp)
plot(t,T_cell_Davis_summer)
plot(t,Davis_spring_temp)
plot(t,T_cell_Davis_spring)
legend('Sum - Amb','Sum - Cell','Spr - Amb','Spr - Cell')
xlabel('Time - 24 hr')
ylabel('Temp (C)')
title('Davis Temp Comparisons')
hold off

%% CLoud Cover considerations
% in previous code, did these in "chunks" 
% copy previous structure, alter for corresponding cases 

% assume temperatures remain the same, available solar irradiation is what
% changes

%% Cloud Cover - 20% 

Casey_summer_irradiance_cloud_20 = zeros(1,length(t));
Casey_spring_irradiance_cloud_20 = zeros(1,length(t));

Davis_summer_irradiance_cloud_20 = zeros(1,length(t));
Davis_spring_irradiance_cloud_20 = zeros(1,length(t));


% Multiply (%) with full irradiance (80% available = 0.8)
for i = 1:48 

Casey_summer_irradiance_cloud_20(i) = Casey_summer_irradiance(i) .* (0.8);
Casey_spring_irradiance_cloud_20(i) = Casey_spring_irradiance(i) .* (0.8);

Davis_summer_irradiance_cloud_20(i) = Davis_summer_irradiance(i) .* (0.8);
Davis_spring_irradiance_cloud_20(i) = Davis_spring_irradiance(i) .* (0.8);

end

% proceed with rest of code for data 

% solar cell temps
T_cell_Casey_summer_cloud_20 = zeros(1,length(t));
T_cell_Casey_spring_cloud_20 = zeros(1,length(t)); 

T_cell_Davis_summer_cloud_20 = zeros(1,length(t));
T_cell_Davis_spring_cloud_20 = zeros(1,length(t));

for i = 1:48
    T_cell_Casey_summer_cloud_20(i) = Casey_summer_temp(i) + ...
            (NOCT-20).*(Casey_summer_irradiance_cloud_20(i)/800);

    T_cell_Casey_spring_cloud_20(i) = Casey_spring_temp(i) + ...
            (NOCT-20).*(Casey_spring_irradiance_cloud_20(i)/800);

    T_cell_Davis_summer_cloud_20(i) = Davis_summer_temp(i) + ...
            (NOCT-20).*(Davis_summer_irradiance_cloud_20(i)/800);

    T_cell_Davis_spring_cloud_20(i) = Davis_spring_temp(i) + ...
            (NOCT-20).*(Davis_spring_irradiance_cloud_20(i)/800);
end

% Temperature coefficient 

f_temp_Casey_summer_cloud_20 = zeros(1,length(t));
f_temp_Casey_spring_cloud_20 = zeros(1,length(t));

f_temp_Davis_summer_cloud_20 = zeros(1,length(t));
f_temp_Davis_spring_cloud_20 = zeros(1,length(t));


for i = 1:48
    
    f_temp_Casey_summer_cloud_20(i) = 1 + ( (temp_coeff/100) ...
                    .* (T_cell_Casey_summer_cloud_20(i) - 25) ); 

    f_temp_Casey_spring_cloud_20(i) = 1 + ((temp_coeff/100) ...
                    .* (T_cell_Casey_spring_cloud_20(i) - 25));

    f_temp_Davis_summer_cloud_20(i) = 1 + ((temp_coeff/100) ...
                    .* (T_cell_Davis_summer_cloud_20(i) - 25));

    f_temp_Davis_spring_cloud_20(i) = 1 + ((temp_coeff/100) ...
                    .* (T_cell_Davis_spring_cloud_20(i) - 25));

end

% Panel Power
% Note: this maps the RATE OF POWER GEN given time
    % i.e. area under curve finds TOTAL power gen

P_gen_Casey_summer_cloud_20 = zeros(1,length(t));
P_gen_Casey_spring_cloud_20 = zeros(1,length(t));

P_gen_Davis_summer_cloud_20 = zeros(1,length(t));
P_gen_Davis_spring_cloud_20 = zeros(1,length(t)); 

for i = 1:48 
    
    P_gen_Casey_summer_cloud_20(i) = P_stc .* ...
                (Casey_summer_irradiance_cloud_20(i)/1000) .* ...
                f_temp_Casey_summer_cloud_20(i);

    P_gen_Casey_spring_cloud_20(i) = P_stc .* ...
                (Casey_spring_irradiance_cloud_20(i)/1000) .* ...
                f_temp_Casey_spring_cloud_20(i);

    P_gen_Davis_summer_cloud_20(i) = P_stc .* ...
                (Davis_summer_irradiance_cloud_20(i)/1000) .* ...
                f_temp_Davis_summer_cloud_20(i);

    P_gen_Davis_spring_cloud_20(i) = P_stc .* ...
                (Davis_spring_irradiance_cloud_20(i)/1000) .* ...
                f_temp_Davis_spring_cloud_20(i);
end 

% per unit area
P_gen_Casey_summer_unit_area_cloud_20 = zeros(1,length(t));
P_gen_Casey_spring_unit_area_cloud_20 = zeros(1,length(t));

P_gen_Davis_summer_unit_area_cloud_20 = zeros(1,length(t));
P_gen_Davis_spring_unit_area_cloud_20 = zeros(1,length(t)); 


for i = 1:48

    P_gen_Casey_summer_unit_area_cloud_20(i) = ...
        P_gen_Casey_summer_cloud_20(i) ./ eff_sol_area;
    
    P_gen_Casey_spring_unit_area_cloud_20(i) = ...
        P_gen_Casey_spring_cloud_20(i) ./ eff_sol_area;
    
    P_gen_Davis_summer_unit_area_cloud_20(i) = ...
        P_gen_Davis_summer_cloud_20(i) ./ eff_sol_area;
    
    P_gen_Davis_spring_unit_area_cloud_20(i) = ...
        P_gen_Davis_spring_cloud_20(i) ./ eff_sol_area;
end


%% Cloud cover - 40% 
% repeat code above but for 60% available radiation

Casey_summer_irradiance_cloud_40 = zeros(1,length(t));
Casey_spring_irradiance_cloud_40 = zeros(1,length(t));

Davis_summer_irradiance_cloud_40 = zeros(1,length(t));
Davis_spring_irradiance_cloud_40 = zeros(1,length(t));


% Multiply (%) with full irradiance (80% available = 0.8)
for i = 1:48 

Casey_summer_irradiance_cloud_40(i) = Casey_summer_irradiance(i) .* (0.6);
Casey_spring_irradiance_cloud_40(i) = Casey_spring_irradiance(i) .* (0.6);

Davis_summer_irradiance_cloud_40(i) = Davis_summer_irradiance(i) .* (0.6);
Davis_spring_irradiance_cloud_40(i) = Davis_spring_irradiance(i) .* (0.6);

end

% solar cell temps
T_cell_Casey_summer_cloud_40 = zeros(1,length(t));
T_cell_Casey_spring_cloud_40 = zeros(1,length(t)); 

T_cell_Davis_summer_cloud_40 = zeros(1,length(t));
T_cell_Davis_spring_cloud_40 = zeros(1,length(t));

for i = 1:48
    T_cell_Casey_summer_cloud_40(i) = Casey_summer_temp(i) + ...
            (NOCT-20).*(Casey_summer_irradiance_cloud_40(i)/800);

    T_cell_Casey_spring_cloud_40(i) = Casey_spring_temp(i) + ...
            (NOCT-20).*(Casey_spring_irradiance_cloud_40(i)/800);

    T_cell_Davis_summer_cloud_40(i) = Davis_summer_temp(i) + ...
            (NOCT-20).*(Davis_summer_irradiance_cloud_40(i)/800);

    T_cell_Davis_spring_cloud_40(i) = Davis_spring_temp(i) + ...
            (NOCT-20).*(Davis_spring_irradiance_cloud_40(i)/800);
end

% Temperature coefficient 

f_temp_Casey_summer_cloud_40 = zeros(1,length(t));
f_temp_Casey_spring_cloud_40 = zeros(1,length(t));

f_temp_Davis_summer_cloud_40 = zeros(1,length(t));
f_temp_Davis_spring_cloud_40 = zeros(1,length(t));

for i = 1:48
    f_temp_Casey_summer_cloud_40(i) = 1 + ( (temp_coeff/100) ...
                    .* (T_cell_Casey_summer_cloud_40(i) - 25) ); 

    f_temp_Casey_spring_cloud_40(i) = 1 + ((temp_coeff/100) ...
                    .* (T_cell_Casey_spring_cloud_40(i) - 25));

    f_temp_Davis_summer_cloud_40(i) = 1 + ((temp_coeff/100) ...
                    .* (T_cell_Davis_summer_cloud_40(i) - 25));

    f_temp_Davis_spring_cloud_40(i) = 1 + ((temp_coeff/100) ...
                    .* (T_cell_Davis_spring_cloud_40(i) - 25));
end

% Panel Power
% Note: this maps the RATE OF POWER GEN given time
    % i.e. area under curve finds TOTAL power gen

P_gen_Casey_summer_cloud_40 = zeros(1,length(t));
P_gen_Casey_spring_cloud_40 = zeros(1,length(t));

P_gen_Davis_summer_cloud_40 = zeros(1,length(t));
P_gen_Davis_spring_cloud_40 = zeros(1,length(t)); 

for i = 1:48 
    
    P_gen_Casey_summer_cloud_40(i) = P_stc .* ...
                (Casey_summer_irradiance_cloud_40(i)/1000) .* ...
                f_temp_Casey_summer_cloud_40(i);

    P_gen_Casey_spring_cloud_40(i) = P_stc .* ...
                (Casey_spring_irradiance_cloud_40(i)/1000) .* ...
                f_temp_Casey_spring_cloud_40(i);

    P_gen_Davis_summer_cloud_40(i) = P_stc .* ...
                (Davis_summer_irradiance_cloud_40(i)/1000) .* ...
                f_temp_Davis_summer_cloud_40(i);

    P_gen_Davis_spring_cloud_40(i) = P_stc .* ...
                (Davis_spring_irradiance_cloud_40(i)/1000) .* ...
                f_temp_Davis_spring_cloud_40(i);

end 

% per unit area
P_gen_Casey_summer_unit_area_cloud_40 = zeros(1,length(t));
P_gen_Casey_spring_unit_area_cloud_40 = zeros(1,length(t));

P_gen_Davis_summer_unit_area_cloud_40 = zeros(1,length(t));
P_gen_Davis_spring_unit_area_cloud_40 = zeros(1,length(t)); 


for i = 1:48

    P_gen_Casey_summer_unit_area_cloud_40(i) = ...
        P_gen_Casey_summer_cloud_40(i) ./ eff_sol_area;
    
    P_gen_Casey_spring_unit_area_cloud_40(i) = ...
        P_gen_Casey_spring_cloud_40(i) ./ eff_sol_area;
    
    P_gen_Davis_summer_unit_area_cloud_40(i) = ...
        P_gen_Davis_summer_cloud_40(i) ./ eff_sol_area;
    
    P_gen_Davis_spring_unit_area_cloud_40(i) = ...
        P_gen_Davis_spring_cloud_40(i) ./ eff_sol_area;
end

%% Cloud Cover - 60%
% For 60% clouds = 40% availabale solar radiation

Casey_summer_irradiance_cloud_60 = zeros(1,length(t));
Casey_spring_irradiance_cloud_60 = zeros(1,length(t));

Davis_summer_irradiance_cloud_60 = zeros(1,length(t));
Davis_spring_irradiance_cloud_60 = zeros(1,length(t));


% Multiply (%) with full irradiance (80% available = 0.8)
for i = 1:48 

Casey_summer_irradiance_cloud_60(i) = Casey_summer_irradiance(i) .* (0.4);
Casey_spring_irradiance_cloud_60(i) = Casey_spring_irradiance(i) .* (0.4);

Davis_summer_irradiance_cloud_60(i) = Davis_summer_irradiance(i) .* (0.4);
Davis_spring_irradiance_cloud_60(i) = Davis_spring_irradiance(i) .* (0.4);

end

% solar cell temps
T_cell_Casey_summer_cloud_60 = zeros(1,length(t));
T_cell_Casey_spring_cloud_60 = zeros(1,length(t)); 

T_cell_Davis_summer_cloud_60 = zeros(1,length(t));
T_cell_Davis_spring_cloud_60 = zeros(1,length(t));

for i = 1:48
    T_cell_Casey_summer_cloud_60(i) = Casey_summer_temp(i) + ...
            (NOCT-20).*(Casey_summer_irradiance_cloud_60(i)/800);

    T_cell_Casey_spring_cloud_60(i) = Casey_spring_temp(i) + ...
            (NOCT-20).*(Casey_spring_irradiance_cloud_60(i)/800);

    T_cell_Davis_summer_cloud_60(i) = Davis_summer_temp(i) + ...
            (NOCT-20).*(Davis_summer_irradiance_cloud_60(i)/800);

    T_cell_Davis_spring_cloud_60(i) = Davis_spring_temp(i) + ...
            (NOCT-20).*(Davis_spring_irradiance_cloud_60(i)/800);
end

% Temperature coefficient 

f_temp_Casey_summer_cloud_60 = zeros(1,length(t));
f_temp_Casey_spring_cloud_60 = zeros(1,length(t));

f_temp_Davis_summer_cloud_60 = zeros(1,length(t));
f_temp_Davis_spring_cloud_60 = zeros(1,length(t));

for i = 1:48
    f_temp_Casey_summer_cloud_60(i) = 1 + ( (temp_coeff/100) ...
                    .* (T_cell_Casey_summer_cloud_60(i) - 25) ); 

    f_temp_Casey_spring_cloud_60(i) = 1 + ( (temp_coeff/100) ...
                    .* (T_cell_Casey_spring_cloud_60(i) - 25) );

    f_temp_Davis_summer_cloud_60(i) = 1 + ( (temp_coeff/100) ...
                    .* (T_cell_Davis_summer_cloud_60(i) - 25) );

    f_temp_Davis_spring_cloud_60(i) = 1 + ( (temp_coeff/100) ...
                    .* (T_cell_Davis_spring_cloud_60(i) - 25) );
end

% Panel Power
% Note: this maps the RATE OF POWER GEN given time
    % i.e. area under curve finds TOTAL power gen

P_gen_Casey_summer_cloud_60 = zeros(1,length(t));
P_gen_Casey_spring_cloud_60 = zeros(1,length(t));

P_gen_Davis_summer_cloud_60 = zeros(1,length(t));
P_gen_Davis_spring_cloud_60 = zeros(1,length(t)); 

for i = 1:48 
    
    P_gen_Casey_summer_cloud_60(i) = P_stc .* ...
                (Casey_summer_irradiance_cloud_60(i)/1000) .* ...
                f_temp_Casey_summer_cloud_60(i);

    P_gen_Casey_spring_cloud_60(i) = P_stc .* ...
                (Casey_spring_irradiance_cloud_60(i)/1000) .* ...
                f_temp_Casey_spring_cloud_60(i);

    P_gen_Davis_summer_cloud_60(i) = P_stc .* ...
                (Davis_summer_irradiance_cloud_60(i)/1000) .* ...
                f_temp_Davis_summer_cloud_60(i);

    P_gen_Davis_spring_cloud_60(i) = P_stc .* ...
                (Davis_spring_irradiance_cloud_60(i)/1000) .* ...
                f_temp_Davis_spring_cloud_60(i);

end 

% per unit area
P_gen_Casey_summer_unit_area_cloud_60 = zeros(1,length(t));
P_gen_Casey_spring_unit_area_cloud_60 = zeros(1,length(t));

P_gen_Davis_summer_unit_area_cloud_60 = zeros(1,length(t));
P_gen_Davis_spring_unit_area_cloud_60 = zeros(1,length(t)); 


for i = 1:48
    P_gen_Casey_summer_unit_area_cloud_60(i) = ...
        P_gen_Casey_summer_cloud_60(i) ./ eff_sol_area;
    
    P_gen_Casey_spring_unit_area_cloud_60(i) = ...
        P_gen_Casey_spring_cloud_60(i) ./ eff_sol_area;
    
    P_gen_Davis_summer_unit_area_cloud_60(i) = ...
        P_gen_Davis_summer_cloud_60(i) ./ eff_sol_area;
    
    P_gen_Davis_spring_unit_area_cloud_60(i) = ...
        P_gen_Davis_spring_cloud_60(i) ./ eff_sol_area;
end

%% Cloud Cover - 80% 
% 80% cloud = 20% solar energy available

Casey_summer_irradiance_cloud_80 = zeros(1,length(t));
Casey_spring_irradiance_cloud_80 = zeros(1,length(t));

Davis_summer_irradiance_cloud_80 = zeros(1,length(t));
Davis_spring_irradiance_cloud_80 = zeros(1,length(t));


% Multiply (%) with full irradiance (80% available = 0.8)
for i = 1:48 

Casey_summer_irradiance_cloud_80(i) = Casey_summer_irradiance(i) .* (0.2);
Casey_spring_irradiance_cloud_80(i) = Casey_spring_irradiance(i) .* (0.2);

Davis_summer_irradiance_cloud_80(i) = Davis_summer_irradiance(i) .* (0.2);
Davis_spring_irradiance_cloud_80(i) = Davis_spring_irradiance(i) .* (0.2);

end

% solar cell temps
T_cell_Casey_summer_cloud_80 = zeros(1,length(t));
T_cell_Casey_spring_cloud_80 = zeros(1,length(t)); 

T_cell_Davis_summer_cloud_80 = zeros(1,length(t));
T_cell_Davis_spring_cloud_80 = zeros(1,length(t));

for i = 1:48
    T_cell_Casey_summer_cloud_80(i) = Casey_summer_temp(i) + ...
            (NOCT-20).*(Casey_summer_irradiance_cloud_80(i)/800);

    T_cell_Casey_spring_cloud_80(i) = Casey_spring_temp(i) + ...
            (NOCT-20).*(Casey_spring_irradiance_cloud_80(i)/800);

    T_cell_Davis_summer_cloud_80(i) = Davis_summer_temp(i) + ...
            (NOCT-20).*(Davis_summer_irradiance_cloud_80(i)/800);

    T_cell_Davis_spring_cloud_80(i) = Davis_spring_temp(i) + ...
            (NOCT-20).*(Davis_spring_irradiance_cloud_80(i)/800);
end

% Temperature coefficient 

f_temp_Casey_summer_cloud_80 = zeros(1,length(t));
f_temp_Casey_spring_cloud_80 = zeros(1,length(t));

f_temp_Davis_summer_cloud_80 = zeros(1,length(t));
f_temp_Davis_spring_cloud_80 = zeros(1,length(t));

for i = 1:48
    f_temp_Casey_summer_cloud_80(i) = 1 + ( (temp_coeff/100) ...
                    .* (T_cell_Casey_summer_cloud_80(i) - 25) ); 

    f_temp_Casey_spring_cloud_80(i) = 1 + ( (temp_coeff/100) ...
                    .* (T_cell_Casey_spring_cloud_80(i) - 25) );

    f_temp_Davis_summer_cloud_80(i) = 1 + ( (temp_coeff/100) ...
                    .* (T_cell_Davis_summer_cloud_80(i) - 25) );

    f_temp_Davis_spring_cloud_80(i) = 1 + ( (temp_coeff/100) ...
                    .* (T_cell_Davis_spring_cloud_80(i) - 25) );
end

% Panel Power
% Note: this maps the RATE OF POWER GEN given time
    % i.e. area under curve finds TOTAL power gen

P_gen_Casey_summer_cloud_80 = zeros(1,length(t));
P_gen_Casey_spring_cloud_80 = zeros(1,length(t));

P_gen_Davis_summer_cloud_80 = zeros(1,length(t));
P_gen_Davis_spring_cloud_80 = zeros(1,length(t)); 

for i = 1:48 
    
    P_gen_Casey_summer_cloud_80(i) = P_stc .* ...
                (Casey_summer_irradiance_cloud_80(i)/1000) .* ...
                f_temp_Casey_summer_cloud_80(i);

    P_gen_Casey_spring_cloud_80(i) = P_stc .* ...
                (Casey_spring_irradiance_cloud_80(i)/1000) .* ...
                f_temp_Casey_spring_cloud_80(i);

    P_gen_Davis_summer_cloud_80(i) = P_stc .* ...
                (Davis_summer_irradiance_cloud_80(i)/1000) .* ...
                f_temp_Davis_summer_cloud_80(i);

    P_gen_Davis_spring_cloud_80(i) = P_stc .* ...
                (Davis_spring_irradiance_cloud_80(i)/1000) .* ...
                f_temp_Davis_spring_cloud_80(i);

end 

% per unit area
P_gen_Casey_summer_unit_area_cloud_80 = zeros(1,length(t));
P_gen_Casey_spring_unit_area_cloud_80 = zeros(1,length(t));

P_gen_Davis_summer_unit_area_cloud_80 = zeros(1,length(t));
P_gen_Davis_spring_unit_area_cloud_80 = zeros(1,length(t)); 


for i = 1:48
    P_gen_Casey_summer_unit_area_cloud_80(i) = ...
        P_gen_Casey_summer_cloud_80(i) ./ eff_sol_area;
    
    P_gen_Casey_spring_unit_area_cloud_80(i) = ...
        P_gen_Casey_spring_cloud_80(i) ./ eff_sol_area;
    
    P_gen_Davis_summer_unit_area_cloud_80(i) = ...
        P_gen_Davis_summer_cloud_80(i) ./ eff_sol_area;
    
    P_gen_Davis_spring_unit_area_cloud_80(i) = ...
        P_gen_Davis_spring_cloud_80(i) ./ eff_sol_area;
end


%% Compare all the values - group by area & station 
% use lien graph to illustrate power differences 


% Casey - summer 
figure(12)
hold on
grid on 
grid minor
plot(t,Casey_summer_irradiance)
plot(t,Casey_summer_irradiance_cloud_20)
plot(t,Casey_summer_irradiance_cloud_40)
plot(t,Casey_summer_irradiance_cloud_60)
plot(t,Casey_summer_irradiance_cloud_80)
legend('0% Clouds','20% Clouds','40% Clouds','60% Clouds','80% Clouds')
xlabel('Time - 24 hr')
ylabel('Solar Irradiance (W/m.^2)')
title('Casey - Summer - Cloud Cover %')
hold off

figure(13)
hold on
grid on 
grid minor
plot(t,P_gen_Casey_summer_unit_area)
plot(t,P_gen_Casey_summer_unit_area_cloud_20)
plot(t,P_gen_Casey_summer_unit_area_cloud_40)
plot(t,P_gen_Casey_summer_unit_area_cloud_60)
plot(t,P_gen_Casey_summer_unit_area_cloud_80)
legend('0% Clouds','20% Clouds','40% Clouds','60% Clouds','80% Clouds')
xlabel('Time - 24 hr')
ylabel('Power Gen per unit area (W/m.^2)')
title('Casey - Summer - Power Generated per unit area')
hold off

% Casey - spring 
figure(14)
hold on
grid on 
grid minor
plot(t,Casey_spring_irradiance)
plot(t,Casey_spring_irradiance_cloud_20)
plot(t,Casey_spring_irradiance_cloud_40)
plot(t,Casey_spring_irradiance_cloud_60)
plot(t,Casey_spring_irradiance_cloud_80)
legend('0% Clouds','20% Clouds','40% Clouds','60% Clouds','80% Clouds')
xlabel('Time - 24 hr')
ylabel('Solar Irradiance (W/m.^2)')
title('Casey - Spring - Cloud Cover %')
hold off

figure(15)
hold on
grid on 
grid minor
plot(t,P_gen_Casey_spring_unit_area)
plot(t,P_gen_Casey_spring_unit_area_cloud_20)
plot(t,P_gen_Casey_spring_unit_area_cloud_40)
plot(t,P_gen_Casey_spring_unit_area_cloud_60)
plot(t,P_gen_Casey_spring_unit_area_cloud_80)
legend('0% Clouds','20% Clouds','40% Clouds','60% Clouds','80% Clouds')
xlabel('Time - 24 hr')
ylabel('Power Gen per unit area (W/m.^2)')
title('Casey - Spring - Power Generated per unit area')
hold off

% Davis - Summer
figure(16)
hold on
grid on 
grid minor
plot(t,Davis_summer_irradiance)
plot(t,Davis_summer_irradiance_cloud_20)
plot(t,Davis_summer_irradiance_cloud_40)
plot(t,Davis_summer_irradiance_cloud_60)
plot(t,Davis_summer_irradiance_cloud_80)
legend('0% Clouds','20% Clouds','40% Clouds','60% Clouds','80% Clouds')
xlabel('Time - 24 hr')
ylabel('Solar Irradiance (W/m.^2)')
title('Davis - Summer - Cloud Cover %')
hold off

figure(17)
hold on
grid on 
grid minor
plot(t,P_gen_Casey_summer_unit_area)
plot(t,P_gen_Casey_summer_unit_area_cloud_20)
plot(t,P_gen_Casey_summer_unit_area_cloud_40)
plot(t,P_gen_Casey_summer_unit_area_cloud_60)
plot(t,P_gen_Casey_summer_unit_area_cloud_80)
legend('0% Clouds','20% Clouds','40% Clouds','60% Clouds','80% Clouds')
xlabel('Time - 24 hr')
ylabel('Power Gen per unit area (W/m.^2)')
title('Casey - Summer - Power Generated per unit area')
hold off

% Davis - Spring
figure(18)
hold on
grid on 
grid minor
plot(t,Davis_spring_irradiance)
plot(t,Davis_spring_irradiance_cloud_20)
plot(t,Davis_spring_irradiance_cloud_40)
plot(t,Davis_spring_irradiance_cloud_60)
plot(t,Davis_spring_irradiance_cloud_80)
legend('0% Clouds','20% Clouds','40% Clouds','60% Clouds','80% Clouds')
xlabel('Time - 24 hr')
ylabel('Solar Irradiance (W/m.^2)')
title('Davis - Spring - Cloud Cover %')
hold off

figure(19)
hold on
grid on 
grid minor
plot(t,P_gen_Davis_spring_unit_area)
plot(t,P_gen_Davis_spring_unit_area_cloud_20)
plot(t,P_gen_Davis_spring_unit_area_cloud_40)
plot(t,P_gen_Davis_spring_unit_area_cloud_60)
plot(t,P_gen_Davis_spring_unit_area_cloud_80)
legend('0% Clouds','20% Clouds','40% Clouds','60% Clouds','80% Clouds')
xlabel('Time - 24 hr')
ylabel('Power Gen per unit area (W/m.^2)')
title('Davis - Spring - Power Generated per unit area')
hold off


%% Compare locations? 

% Casey station
figure(20)
hold on
grid on 
grid minor

plot(t,P_gen_Casey_summer_unit_area)
plot(t,P_gen_Casey_spring_unit_area)

plot(t,P_gen_Casey_summer_unit_area_cloud_20)
plot(t,P_gen_Casey_spring_unit_area_cloud_20)

plot(t,P_gen_Casey_summer_unit_area_cloud_40)
plot(t,P_gen_Casey_spring_unit_area_cloud_40)

plot(t,P_gen_Casey_summer_unit_area_cloud_60)
plot(t,P_gen_Casey_spring_unit_area_cloud_60)

plot(t,P_gen_Casey_summer_unit_area_cloud_80)
plot(t,P_gen_Casey_spring_unit_area_cloud_80)

legend('0% - sum','0% - spr','20% - sum','20% - spr',...
        '40% - sum','40% - spr','60% - sum','60% - spr',...
        '80% - sum','80% - spr')
xlabel('Time - 24 hr')
ylabel('Power Gen per unit area (W/m.^2)')
title('Casey - Power Generated per unit area')
hold off


% Davis station
figure(21)
hold on
grid on 
grid minor

plot(t,P_gen_Davis_summer_unit_area)
plot(t,P_gen_Davis_spring_unit_area)

plot(t,P_gen_Davis_summer_unit_area_cloud_20)
plot(t,P_gen_Davis_spring_unit_area_cloud_20)

plot(t,P_gen_Davis_summer_unit_area_cloud_40)
plot(t,P_gen_Davis_spring_unit_area_cloud_40)

plot(t,P_gen_Davis_summer_unit_area_cloud_60)
plot(t,P_gen_Davis_spring_unit_area_cloud_60)

plot(t,P_gen_Davis_summer_unit_area_cloud_80)
plot(t,P_gen_Davis_spring_unit_area_cloud_80)

legend('0% - sum','0% - spr','20% - sum','20% - spr',...
        '40% - sum','40% - spr','60% - sum','60% - spr',...
        '80% - sum','80% - spr')
xlabel('Time - 24 hr')
ylabel('Power Gen per unit area (W/m.^2)')
title('Davis - Power Generated per unit area')
hold off

% summer comparison

figure(22)
hold on
grid on 
grid minor

plot(t,P_gen_Casey_summer_unit_area)
plot(t,P_gen_Davis_summer_unit_area)

plot(t,P_gen_Casey_summer_unit_area_cloud_20)
plot(t,P_gen_Davis_summer_unit_area_cloud_20)

plot(t,P_gen_Casey_summer_unit_area_cloud_40)
plot(t,P_gen_Davis_summer_unit_area_cloud_40)

plot(t,P_gen_Casey_summer_unit_area_cloud_60)
plot(t,P_gen_Davis_summer_unit_area_cloud_60)

plot(t,P_gen_Casey_summer_unit_area_cloud_80)
plot(t,P_gen_Davis_summer_unit_area_cloud_80)

legend('0% - C','0% - D','20% - C','20% - D',...
        '40% - C','40% - D','60% - C','60% - D',...
        '80% - C','80% - D')
xlabel('Time - 24 hr')
ylabel('Power Gen per unit area (W/m.^2)')
title('Summer - Power Generated per unit area')
hold off

% spring comparison
figure(23)
hold on
grid on 
grid minor

plot(t,P_gen_Casey_spring_unit_area)
plot(t,P_gen_Davis_spring_unit_area)

plot(t,P_gen_Casey_spring_unit_area_cloud_20)
plot(t,P_gen_Davis_spring_unit_area_cloud_20)

plot(t,P_gen_Casey_spring_unit_area_cloud_40)
plot(t,P_gen_Davis_spring_unit_area_cloud_40)

plot(t,P_gen_Casey_spring_unit_area_cloud_60)
plot(t,P_gen_Davis_spring_unit_area_cloud_60)

plot(t,P_gen_Casey_spring_unit_area_cloud_80)
plot(t,P_gen_Davis_spring_unit_area_cloud_80)

legend('0% - C','0% - D','20% - C','20% - D',...
        '40% - C','40% - D','60% - C','60% - D',...
        '80% - C','80% - D')
xlabel('Time - 24 hr')
ylabel('Power Gen per unit area (W/m.^2)')
title('Spring - Power Generated per unit area')
hold off

%% Export data for integrated code 
% need to separate into cases 
% ambient temperatures the same - IRRADIANCE VARIATIONS

%% CASEY - SUMMER - CLOUDS 0-80%
% Figure 12
% CREATE TABLE OF VALUES 
CASEY_SUMMER_IRRADIANCE_ALL_CASES = ...
    [(Casey_summer_irradiance); (Casey_summer_irradiance_cloud_20);...
    (Casey_summer_irradiance_cloud_40); ...
    (Casey_summer_irradiance_cloud_60);(Casey_summer_irradiance_cloud_80)];
% big ol matrix

filename_d_sum = "CASEY_SUMMER_IRRADIANCE_ALL_CASES.xlsx"; % make file
writematrix(CASEY_SUMMER_IRRADIANCE_ALL_CASES,filename_d_sum,...
            'Sheet',1);

%% CASEY - SPRING - CLOUDS 0-80%
% Figure 12
% CREATE TABLE OF VALUES 
CASEY_SPRING_IRRADIANCE_ALL_CASES = ...
    [(Casey_spring_irradiance); (Casey_spring_irradiance_cloud_20);...
    (Casey_spring_irradiance_cloud_40); ...
    (Casey_spring_irradiance_cloud_60);(Casey_spring_irradiance_cloud_80)];
% big ol matrix

filename_c_spr = "CASEY_SPRING_IRRADIANCE_ALL_CASES.xlsx"; % make file
writematrix(CASEY_SPRING_IRRADIANCE_ALL_CASES,filename_c_spr,...
            'Sheet',1);

%% DAVIS - SUMMER - CLOUDS 0-80%
% Figure 12
% CREATE TABLE OF VALUES 
DAVIS_SUMMER_IRRADIANCE_ALL_CASES = ...
    [(Davis_summer_irradiance); (Davis_summer_irradiance_cloud_20);...
    (Davis_summer_irradiance_cloud_40); ...
    (Davis_summer_irradiance_cloud_60);(Davis_summer_irradiance_cloud_80)];
% big ol matrix

filename_d_sum = "DAVIS_SUMMER_IRRADIANCE_ALL_CASES.xlsx"; % make file
writematrix(DAVIS_SUMMER_IRRADIANCE_ALL_CASES,filename_d_sum,...
            'Sheet',1);

%% DAVIS - SPRING - CLOUDS 0-80%
% Figure 12
% CREATE TABLE OF VALUES 
DAVIS_SPRING_IRRADIANCE_ALL_CASES = ...
    [(Davis_spring_irradiance); (Davis_spring_irradiance_cloud_20);...
    (Davis_spring_irradiance_cloud_40); ...
    (Davis_spring_irradiance_cloud_60);(Davis_spring_irradiance_cloud_80)];
% big ol matrix

filename_d_spr = "DAVIS_SPRING_IRRADIANCE_ALL_CASES.xlsx"; % make file
writematrix(DAVIS_SPRING_IRRADIANCE_ALL_CASES,filename_d_spr,...
            'Sheet',1);

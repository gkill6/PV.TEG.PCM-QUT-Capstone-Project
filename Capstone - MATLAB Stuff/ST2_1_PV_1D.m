%% PV Array 1D Simulation Calculations
% Feed these into TD1.1

% Given first round, focus is on possible power generation
% approximate temperature profiled will be aligned with hours in future
% iterations

% Weather Conditions - rearranging apr'25-mar'26 for jan-dec
% monthly averages
Month = ["Jan"; "Feb"; "Mar"; "Apr"; ...
         "May"; "Jun"; "Jul"; "Aug"; ...
         "Sep"; "Oct"; "Nov"; "Dec"];


Casey_C = [6.7 4.7 4.3 -2.4	-2.5 -2.5 -0.8 -3.8	-4.2 0.3 3.7 5.5]; % Celsius
Davis_C = [8.5 2.7 1 -3.8 -5.9 -3 -6.8 -4.5	-2.2 2.1 5.6 8.2]; % Celsius

Casey_Sun_hours = [5.1 4.5 3.2 1.9 0.7 0.1 0.4 1.6 3 4.5 6.7 5.9]; % Hours
Davis_Sun_hours = [9.4 6.0 3.3 2.3 0.7 0.0 0.3 1.9 4.0 5.5 7.9 9.7]; % Hours

figure(20)
hold on;
grid on;
plot(Casey_Sun_hours, 'b-o');
plot(Davis_Sun_hours, 'r-o');

legend("Casey","Davis");
ylabel("Hours of Sunlight");

xticks(1:1:12);
xticklabels(Month);
hold off;


Casey_Solar_irradiance = 88.05; % Wh/m^2 ~ W/m^2 
Davis_Solar_irradiance = 71.25; % Wh/m^2 ~ W/m^2

% Solar Panel specs
P_stc = 300; % W - Rated power @ STC
NOCT = 44; % C - Nominal Cell Temperature 
temp_coeff = -0.4; % [%] - temperature coefficient

%% Estimate cell temperature
% USe iterative loop 
T_cell_Casey = zeros(1,12);
T_cell_Davis = zeros(1,12);

for i = 1:12

T_cell_Casey(i) = Casey_C(i) + (NOCT-20).*(Casey_Solar_irradiance/800); % C
T_cell_Davis(i) = Davis_C(i) +(NOCT-20).*(Davis_Solar_irradiance/800); % C

end

% Temperature Factor 
% Account for heat dynamics effect on performance

f_temp_Casey = zeros(1,12);
f_temp_Davis = zeros(1,12); 

for i = 1:12

    f_temp_Casey(i) = 1 + ((temp_coeff/100).* (T_cell_Casey(i) - 25));
    f_temp_Davis(i) = 1 + ((temp_coeff/100).* (T_cell_Davis(i) - 25));

end 

    % Panel Power
    % Power generation 

P_gen_Casey = zeros(1,12); 
P_gen_Davis = zeros(1,12);

for i = 1:12

    P_gen_Casey(i) = P_stc .* (Casey_Solar_irradiance / 1000) .* f_temp_Casey(i) ; % W per panel
    P_gen_Davis(i) = P_stc .* (Davis_Solar_irradiance / 1000) .* f_temp_Davis(i) ; % W per panel

end

%% Bar Plot



% Figure 1 - per panel
figure(1);
hold on;
grid on;
grid minor;

PV = bar(1:12,[P_gen_Casey;P_gen_Davis]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Power Generation per Panel (Wh)');
xticks(1:1:12);
xticklabels(Month);

hold off;





%% PV array 
% Ideal scenario, use 5 solar panels (4 sides + top) to asborb as much
% solar energy as possible

% AREA POWER = P_gen / area of solar cells 

P_gen_unit_area_Casey = zeros(1,12); 
P_gen_unit_area_Davis = zeros(1,12);

cell_size = (0.15675 * 0.15675); % m^2 
num_cell = 60;

eff_sol_area = cell_size * num_cell; % effective solar cell area


for i = 1:12

    P_gen_unit_area_Casey(i) = P_gen_Casey(i) / eff_sol_area ; % Whr
    P_gen_unit_area_Davis(i) = P_gen_Davis(i) / eff_sol_area; % Whr

end

figure(10);

hold on;
grid on;
grid minor;

PV_Array = bar(1:12,[P_gen_unit_area_Casey;P_gen_unit_area_Davis]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Watt-hours per unit area (Wh/m^2)');
legend("Casey Station ~ 65 S","Davis Station ~ 70 S")
title('Maximum Power Generation (per unit area) (Wh/m^2)')

xticks(1:1:12);
xticklabels(Month);
ylim([0 25]);

fontsize(16,"points")

hold off;

%% Maximum Daily Power generation
% Possible power generation over months
% P_gen_unit area * sun hours 


P_gen_Daily_Casey = zeros(1,12); 
P_gen_Daily_Davis = zeros(1,12);

for i = 1:12

    P_gen_Daily_Casey(i) = P_gen_unit_area_Casey(i) * Casey_Sun_hours(i) ; % W per day
    P_gen_Daily_Davis(i) = P_gen_unit_area_Davis(i) * Davis_Sun_hours(i) ; % W per day

end

%% Maximum Possible Power Generation 
% 0% clouds - monthly sunshine hours

figure(2);

hold on;
grid on;
grid minor;

bar(1:12,[P_gen_Daily_Casey;P_gen_Daily_Davis]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Watts per unit area (W/m^2)');


xticks(1:1:12);
xticklabels(Month);

legend("Casey Station ~ 65 S","Davis Station ~ 70 S")
legend(location="north");

title('Monthly Maximimum Daily Power Generation per unit area (W/m^2)')

fontsize(16,"points")

hold off;

%% Comparison of Sunshine to Max Power
figure(3) 
hold on;
grid on;

PV_daily = bar(1:12,[P_gen_Daily_Casey;P_gen_Daily_Davis],'blue');
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Maximum Power Generation per unit area - 0% clouds (W)');

PV_daily(1).FaceColor = 'b';
PV_daily(2).FaceColor = 'r';

legend("Casey","Davis");
legend(location="north");

xticks(1:1:12);
xticklabels(Month);

hold off;



%% 20% Overcast 
% Assume 20% of solar energy blocked (80% available)

Casey_Solar_irradiance_80 = 88.05 * 0.8; % Wh/m^2 ~ W/m^2 
Davis_Solar_irradiance_80 = 71.25 * 0.8; % Wh/m^2 ~ W/m^2

% Estimate cell temperature
T_cell_Casey_80 = zeros(1,12);
T_cell_Davis_80 = zeros(1,12);

for i = 1:12
T_cell_Casey_80(i) = Casey_C(i) + (NOCT-20).*(Casey_Solar_irradiance_80/800); % C
T_cell_Davis_80(i) = Davis_C(i) +(NOCT-20).*(Davis_Solar_irradiance_80/800); % C
end

% Temperature Factor 
f_temp_Casey_80 = zeros(1,12);
f_temp_Davis_80 = zeros(1,12); 

for i = 1:12
    f_temp_Casey_80(i) = 1 + ((temp_coeff/100).* (T_cell_Casey_80(i) - 25));
    f_temp_Davis_80(i) = 1 + ((temp_coeff/100).* (T_cell_Davis_80(i) - 25));
end 

% Panel Power (single)
P_gen_Casey_80 = zeros(1,12); 
P_gen_Davis_80 = zeros(1,12);

for i = 1:12
    P_gen_Casey_80(i) = P_stc .* (Casey_Solar_irradiance_80 / 1000) .* f_temp_Casey_80(i) ; % W per panel
    P_gen_Davis_80(i) = P_stc .* (Davis_Solar_irradiance_80 / 1000) .* f_temp_Davis_80(i) ; % W per panel
end

% PV array (unit_area)
P_gen_unit_area_Casey_80 = zeros(1,12); 
P_gen_unit_area_Davis_80 = zeros(1,12);
% Assume 90% system efficiency
for i = 1:12
    P_gen_unit_area_Casey_80(i) = P_gen_Casey_80(i) / eff_sol_area ; % Whr/m^2
    P_gen_unit_area_Davis_80(i) = P_gen_Davis_80(i) / eff_sol_area ; % Whr/m^2
end

% Maximum Daily Power generation
P_gen_Daily_Casey_80 = zeros(1,12); 
P_gen_Daily_Davis_80 = zeros(1,12);

for i = 1:12

    P_gen_Daily_Casey_80(i) = P_gen_unit_area_Casey_80(i) * Casey_Sun_hours(i) ; % W/m^2 per day
    P_gen_Daily_Davis_80(i) = P_gen_unit_area_Davis_80(i) * Davis_Sun_hours(i) ; % W/m^2 per day

end

figure(4) 
hold on;
grid on;

PV_daily = bar(1:12,[P_gen_Daily_Casey_80;P_gen_Daily_Davis_80],'blue');
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Maximum Power Generation per unit area - 20% clouds (W/m^2)');

PV_daily(1).FaceColor = 'b';
PV_daily(2).FaceColor = 'r';

legend("Casey","Davis");
legend(location="north");

xticks(1:1:12);
xticklabels(Month);

hold off;


%% 40% Overcast
% Assume 40% of solar energy blocked (60% available)

Casey_Solar_irradiance_60 = 88.05 * 0.6; % Wh/m^2 ~ W/m^2 
Davis_Solar_irradiance_60 = 71.25 * 0.6; % Wh/m^2 ~ W/m^2

% Estimate cell temperature
T_cell_Casey_60 = zeros(1,12);
T_cell_Davis_60 = zeros(1,12);

for i = 1:12
T_cell_Casey_60(i) = Casey_C(i) + (NOCT-20).*(Casey_Solar_irradiance_60/800); % C
T_cell_Davis_60(i) = Davis_C(i) +(NOCT-20).*(Davis_Solar_irradiance_60/800); % C
end

% Temperature Factor 
f_temp_Casey_60 = zeros(1,12);
f_temp_Davis_60 = zeros(1,12); 

for i = 1:12
    f_temp_Casey_60(i) = 1 + ((temp_coeff/100).* (T_cell_Casey_60(i) - 25));
    f_temp_Davis_60(i) = 1 + ((temp_coeff/100).* (T_cell_Davis_60(i) - 25));
end 

% Panel Power (single)
P_gen_Casey_60 = zeros(1,12); 
P_gen_Davis_60 = zeros(1,12);

for i = 1:12
    P_gen_Casey_60(i) = P_stc .* (Casey_Solar_irradiance_60 / 1000) .* f_temp_Casey_60(i) ; % W per panel
    P_gen_Davis_60(i) = P_stc .* (Davis_Solar_irradiance_60 / 1000) .* f_temp_Davis_60(i) ; % W per panel
end

% PV array (unit area)
P_gen_unit_area_Casey_60 = zeros(1,12); 
P_gen_unit_area_Davis_60 = zeros(1,12);

for i = 1:12
    P_gen_unit_area_Casey_60(i) = P_gen_Casey_60(i) / eff_sol_area ; % Whr
    P_gen_unit_area_Davis_60(i) = P_gen_Davis_60(i) / eff_sol_area ; % Whr
end

% Maximum Daily Power generation
P_gen_Daily_Casey_60 = zeros(1,12); 
P_gen_Daily_Davis_60 = zeros(1,12);

for i = 1:12

    P_gen_Daily_Casey_60(i) = P_gen_unit_area_Casey_60(i) * Casey_Sun_hours(i) ; % W/m^2 per day
    P_gen_Daily_Davis_60(i) = P_gen_unit_area_Davis_60(i) * Davis_Sun_hours(i) ; % W/m^2 per day

end

figure(5)
hold on;
grid on;

PV_daily = bar(1:12,[P_gen_Daily_Casey_60;P_gen_Daily_Davis_60],'blue');
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Maximum Power Generation per unit area - 40% clouds (W/m^2)');

PV_daily(1).FaceColor = 'b';
PV_daily(2).FaceColor = 'r';

legend("Casey","Davis");
legend(location="north");

xticks(1:1:12);
xticklabels(Month);

hold off;



%% 60% Overcast
% Assume 60% blocked (40% available)

Casey_Solar_irradiance_40 = 88.05 * 0.4; % Wh/m^2 ~ W/m^2 
Davis_Solar_irradiance_40 = 71.25 * 0.4; % Wh/m^2 ~ W/m^2

% Estimate cell temperature
T_cell_Casey_40 = zeros(1,12);
T_cell_Davis_40 = zeros(1,12);

for i = 1:12
T_cell_Casey_40(i) = Casey_C(i) + (NOCT-20).*(Casey_Solar_irradiance_40/800); % C
T_cell_Davis_40(i) = Davis_C(i) + (NOCT-20).*(Davis_Solar_irradiance_40/800); % C
end

% Temperature Factor 
f_temp_Casey_40 = zeros(1,12);
f_temp_Davis_40 = zeros(1,12); 

for i = 1:12
    f_temp_Casey_40(i) = 1 + ((temp_coeff/100).* (T_cell_Casey_40(i) - 25));
    f_temp_Davis_40(i) = 1 + ((temp_coeff/100).* (T_cell_Davis_40(i) - 25));
end 

% Panel Power (single)
P_gen_Casey_40 = zeros(1,12); 
P_gen_Davis_40 = zeros(1,12);

for i = 1:12
    P_gen_Casey_40(i) = P_stc .* (Casey_Solar_irradiance_40 / 1000) .* f_temp_Casey_40(i) ; % W per panel
    P_gen_Davis_40(i) = P_stc .* (Davis_Solar_irradiance_40 / 1000) .* f_temp_Davis_40(i) ; % W per panel
end

% PV array (per unit area)
P_gen_unit_area_Casey_40 = zeros(1,12); 
P_gen_unit_area_Davis_40 = zeros(1,12);

for i = 1:12
    P_gen_unit_area_Casey_40(i) = P_gen_Casey_40(i) / eff_sol_area ; % Whr
    P_gen_unit_area_Davis_40(i) = P_gen_Davis_40(i) / eff_sol_area; % Whr
end

% Maximum Daily Power generation
P_gen_Daily_Casey_40 = zeros(1,12); 
P_gen_Daily_Davis_40 = zeros(1,12);

for i = 1:12

    P_gen_Daily_Casey_40(i) = P_gen_unit_area_Casey_40(i) * Casey_Sun_hours(i) ; % W/m^2 per day
    P_gen_Daily_Davis_40(i) = P_gen_unit_area_Davis_40(i) * Davis_Sun_hours(i) ; % W/m^2 per day

end

figure(6)
hold on;
grid on;

PV_daily = bar(1:12,[P_gen_Daily_Casey_40;P_gen_Daily_Davis_40],'blue');
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Maximum Power Generation per unit area - 60% clouds (W/m^2)');

PV_daily(1).FaceColor = 'b';
PV_daily(2).FaceColor = 'r';

legend("Casey","Davis");
legend(location="north");

xticks(1:1:12);
xticklabels(Month);

hold off;


%% 80% Overcast
% Assume 80% blocked (20% available)

Casey_Solar_irradiance_20 = 88.05 * 0.2; % Wh/m^2 ~ W/m^2 
Davis_Solar_irradiance_20 = 71.25 * 0.2; % Wh/m^2 ~ W/m^2

% Estimate cell temperature
T_cell_Casey_20 = zeros(1,12);
T_cell_Davis_20 = zeros(1,12);

for i = 1:12
T_cell_Casey_20(i) = Casey_C(i) + (NOCT-20).*(Casey_Solar_irradiance_20/800); % C
T_cell_Davis_20(i) = Davis_C(i) + (NOCT-20).*(Davis_Solar_irradiance_20/800); % C
end

% Temperature Factor 
f_temp_Casey_20 = zeros(1,12);
f_temp_Davis_20 = zeros(1,12); 

for i = 1:12
    f_temp_Casey_20(i) = 1 + ((temp_coeff/100).* (T_cell_Casey_20(i) - 25));
    f_temp_Davis_20(i) = 1 + ((temp_coeff/100).* (T_cell_Davis_20(i) - 25));
end 

% Panel Power (single)
P_gen_Casey_20 = zeros(1,12); 
P_gen_Davis_20 = zeros(1,12);

for i = 1:12
    P_gen_Casey_20(i) = P_stc .* (Casey_Solar_irradiance_20 / 1000) .* f_temp_Casey_20(i) ; % W per panel
    P_gen_Davis_20(i) = P_stc .* (Davis_Solar_irradiance_20 / 1000) .* f_temp_Davis_20(i) ; % W per panel
end

% PV array (per unit area)
P_gen_unit_area_Casey_20 = zeros(1,12); 
P_gen_unit_area_Davis_20 = zeros(1,12);

% Assume 90% system efficiency
for i = 1:12
    P_gen_unit_area_Casey_20(i) = P_gen_Casey_20(i) / eff_sol_area ; % Whr/m^2
    P_gen_unit_area_Davis_20(i) = P_gen_Davis_20(i) / eff_sol_area ; % Whr/m^2
end

% Maximum Daily Power generation
P_gen_Daily_Casey_20 = zeros(1,12); 
P_gen_Daily_Davis_20 = zeros(1,12);

for i = 1:12

    P_gen_Daily_Casey_20(i) = P_gen_unit_area_Casey_20(i) * Casey_Sun_hours(i) ; % W per day
    P_gen_Daily_Davis_20(i) = P_gen_unit_area_Davis_20(i) * Davis_Sun_hours(i) ; % W per day

end

figure(7)
hold on;
grid on;

PV_daily = bar(1:12,[P_gen_Daily_Casey_20;P_gen_Daily_Davis_20],'blue');
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Maximum Power Generation unit area - 80% clouds (W/m^2)');

PV_daily(1).FaceColor = 'b';
PV_daily(2).FaceColor = 'r';

legend("Casey","Davis");
legend(location="north");

xticks(1:1:12);
xticklabels(Month);

hold off


%% t

figure(8)
title('Comparison of Casey Station vs. Cloud Cover %');
hold on;
grid on;

PV_daily = bar(1:12,[P_gen_Daily_Casey; P_gen_Daily_Casey_80;...
                     P_gen_Daily_Casey_60; P_gen_Daily_Casey_40;...
                     P_gen_Daily_Casey_20;]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Watts per unit area (W/m^2)');
legend("0% Overcast","20% Clouds","40% Clouds","60% Overcast", "80% Clouds");
legend(location="north");


fontsize(16,"points")

xticks(1:1:12);
xticklabels(Month);

hold off;

%% s

figure(9)
title('Comparison of Davis Station vs. Cloud Cover (%)');
hold on;
grid on;

PV_daily = bar(1:12,[P_gen_Daily_Davis; P_gen_Daily_Davis_80;...
                     P_gen_Daily_Davis_60; P_gen_Daily_Davis_40;...
                     P_gen_Daily_Davis_20;]);
xlabel('Monthly Averages (Jan-Dec)');
ylabel('Watts per unit area (W/m^2)');
legend("0% Overcast","20% Clouds","40% Clouds","60% Overcast", "80% Clouds");
legend(location="north");


fontsize(16,"points")

xticks(1:1:12);
xticklabels(Month);

hold off;


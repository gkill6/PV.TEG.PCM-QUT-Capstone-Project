%% ST 5.1 - FULL iNTEGRATION 
% Use pv data and pcm data in TEG format !!!!



% Top side = pv data
%bottom = pcm data


%pcm data = only 4 wind cases

clc;
clear all;

%% 1) Set baseline temperatures - AMBIENT TEMPERATURES 
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


%% 2) Using solar irradiance, find SOLAR CELL TEMPERATURE 
% 2.a) Read solar irradiance values

% - [Casey, Summer] - %
CASEY_SUMMER_IRRADIANCE_ALL_CASES = ...
    readtable("CASEY_SUMMER_IRRADIANCE_ALL_CASES.xlsx");

CASEY_SUMMER_IRRADIANCE_ALL_CASES = ...
    table2array(CASEY_SUMMER_IRRADIANCE_ALL_CASES);

Casey_summer_irradiance = CASEY_SUMMER_IRRADIANCE_ALL_CASES(1,:);
Casey_summer_irradiance_20 = CASEY_SUMMER_IRRADIANCE_ALL_CASES(2,:);
Casey_summer_irradiance_40 = CASEY_SUMMER_IRRADIANCE_ALL_CASES(3,:);
Casey_summer_irradiance_60 = CASEY_SUMMER_IRRADIANCE_ALL_CASES(4,:);
Casey_summer_irradiance_80 = CASEY_SUMMER_IRRADIANCE_ALL_CASES(5,:);

% - [Casey, Spring] - %
CASEY_SPRING_IRRADIANCE_ALL_CASES = ...
    readtable("CASEY_SPRING_IRRADIANCE_ALL_CASES.xlsx");

CASEY_SPRING_IRRADIANCE_ALL_CASES = ...
    table2array(CASEY_SPRING_IRRADIANCE_ALL_CASES);

Casey_spring_irradiance = CASEY_SPRING_IRRADIANCE_ALL_CASES(1,:);
Casey_spring_irradiance_20 = CASEY_SPRING_IRRADIANCE_ALL_CASES(2,:);
Casey_spring_irradiance_40 = CASEY_SPRING_IRRADIANCE_ALL_CASES(3,:);
Casey_spring_irradiance_60 = CASEY_SPRING_IRRADIANCE_ALL_CASES(4,:);
Casey_spring_irradiance_80 = CASEY_SPRING_IRRADIANCE_ALL_CASES(5,:);

% - [Davis, Summer] - % 
DAVIS_SUMMER_IRRADIANCE_ALL_CASES = ...
    readtable("DAVIS_SUMMER_IRRADIANCE_ALL_CASES.xlsx");

DAVIS_SUMMER_IRRADIANCE_ALL_CASES = ...
    table2array(DAVIS_SUMMER_IRRADIANCE_ALL_CASES);

Davis_summer_irradiance = DAVIS_SUMMER_IRRADIANCE_ALL_CASES(1,:);
Davis_summer_irradiance_20 = DAVIS_SUMMER_IRRADIANCE_ALL_CASES(2,:);
Davis_summer_irradiance_40 = DAVIS_SUMMER_IRRADIANCE_ALL_CASES(3,:);
Davis_summer_irradiance_60 = DAVIS_SUMMER_IRRADIANCE_ALL_CASES(4,:);
Davis_summer_irradiance_80 = DAVIS_SUMMER_IRRADIANCE_ALL_CASES(5,:);

% - [Davis, Spring] - %
DAVIS_SPRING_IRRADIANCE_ALL_CASES = ...
    readtable("DAVIS_SPRING_IRRADIANCE_ALL_CASES.xlsx");

DAVIS_SPRING_IRRADIANCE_ALL_CASES = ...
    table2array(DAVIS_SPRING_IRRADIANCE_ALL_CASES);

Davis_spring_irradiance = DAVIS_SPRING_IRRADIANCE_ALL_CASES(1,:);
Davis_spring_irradiance_20 = DAVIS_SPRING_IRRADIANCE_ALL_CASES(2,:);
Davis_spring_irradiance_40 = DAVIS_SPRING_IRRADIANCE_ALL_CASES(3,:);
Davis_spring_irradiance_60 = DAVIS_SPRING_IRRADIANCE_ALL_CASES(4,:);
Davis_spring_irradiance_80 = DAVIS_SPRING_IRRADIANCE_ALL_CASES(5,:);

% sanity check - plot irradiance values
figure(100)
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


% 2.b) Calculate Solar temperatures based on [AMBIENT + IRRADIANCE]
% for now, just go with 0% clouds, then test with other cases
NOCT = 44; % C - Nominal Cell Temperature 


% - [0% Clouds] - %
T_cell_Casey_summer = zeros(1,length(t));
T_cell_Casey_spring = zeros(1,length(t)); 

T_cell_Davis_summer = zeros(1,length(t));
T_cell_Davis_spring = zeros(1,length(t));

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

figure(2)
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


% - [20% Clouds] - %
T_cell_Casey_summer_20 = zeros(1,length(t));
T_cell_Casey_spring_20 = zeros(1,length(t)); 

T_cell_Davis_summer_20 = zeros(1,length(t));
T_cell_Davis_spring_20 = zeros(1,length(t));

for i = 1:48
    T_cell_Casey_summer_20(i) = Casey_summer_temp(i) + ...
            (NOCT-20).*(Casey_summer_irradiance_20(i)/800);

    T_cell_Casey_spring_20(i) = Casey_spring_temp(i) + ...
            (NOCT-20).*(Casey_spring_irradiance_20(i)/800);

    T_cell_Davis_summer_20(i) = Davis_summer_temp(i) + ...
            (NOCT-20).*(Davis_summer_irradiance_20(i)/800);

    T_cell_Davis_spring_20(i) = Davis_spring_temp(i) + ...
            (NOCT-20).*(Davis_spring_irradiance_20(i)/800);
end

figure(3)
    hold on
    grid on
    grid minor
    plot(t,T_cell_Casey_summer_20)
    plot(t,T_cell_Casey_spring_20)
    plot(t,T_cell_Davis_summer_20)
    plot(t,T_cell_Davis_spring_20)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Solar Cell Temperature - 20% Clouds')
    hold off


% - [40% Clouds] - %
T_cell_Casey_summer_40 = zeros(1,length(t));
T_cell_Casey_spring_40 = zeros(1,length(t)); 

T_cell_Davis_summer_40 = zeros(1,length(t));
T_cell_Davis_spring_40 = zeros(1,length(t));

for i = 1:48
    T_cell_Casey_summer_40(i) = Casey_summer_temp(i) + ...
            (NOCT-20).*(Casey_summer_irradiance_40(i)/800);

    T_cell_Casey_spring_40(i) = Casey_spring_temp(i) + ...
            (NOCT-20).*(Casey_spring_irradiance_40(i)/800);

    T_cell_Davis_summer_40(i) = Davis_summer_temp(i) + ...
            (NOCT-20).*(Davis_summer_irradiance_40(i)/800);

    T_cell_Davis_spring_40(i) = Davis_spring_temp(i) + ...
            (NOCT-20).*(Davis_spring_irradiance_40(i)/800);
end

figure(4)
    hold on
    grid on
    grid minor
    plot(t,T_cell_Casey_summer_40)
    plot(t,T_cell_Casey_spring_40)
    plot(t,T_cell_Davis_summer_40)
    plot(t,T_cell_Davis_spring_40)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Solar Cell Temperature - 40% Clouds')
    hold off


% - [60% Clouds] - %
T_cell_Casey_summer_60 = zeros(1,length(t));
T_cell_Casey_spring_60 = zeros(1,length(t)); 

T_cell_Davis_summer_60 = zeros(1,length(t));
T_cell_Davis_spring_60 = zeros(1,length(t));

for i = 1:48
    T_cell_Casey_summer_60(i) = Casey_summer_temp(i) + ...
            (NOCT-20).*(Casey_summer_irradiance_60(i)/800);

    T_cell_Casey_spring_60(i) = Casey_spring_temp(i) + ...
            (NOCT-20).*(Casey_spring_irradiance_60(i)/800);

    T_cell_Davis_summer_60(i) = Davis_summer_temp(i) + ...
            (NOCT-20).*(Davis_summer_irradiance_60(i)/800);

    T_cell_Davis_spring_60(i) = Davis_spring_temp(i) + ...
            (NOCT-20).*(Davis_spring_irradiance_60(i)/800);
end

figure(5)
    hold on
    grid on
    grid minor
    plot(t,T_cell_Casey_summer_60)
    plot(t,T_cell_Casey_spring_60)
    plot(t,T_cell_Davis_summer_60)
    plot(t,T_cell_Davis_spring_60)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Solar Cell Temperature - 60% Clouds')
    hold off


% - [80% Clouds] - %
T_cell_Casey_summer_80 = zeros(1,length(t));
T_cell_Casey_spring_80 = zeros(1,length(t)); 

T_cell_Davis_summer_80 = zeros(1,length(t));
T_cell_Davis_spring_80 = zeros(1,length(t));

for i = 1:48
    T_cell_Casey_summer_80(i) = Casey_summer_temp(i) + ...
            (NOCT-20).*(Casey_summer_irradiance_80(i)/800);

    T_cell_Casey_spring_80(i) = Casey_spring_temp(i) + ...
            (NOCT-20).*(Casey_spring_irradiance_80(i)/800);

    T_cell_Davis_summer_80(i) = Davis_summer_temp(i) + ...
            (NOCT-20).*(Davis_summer_irradiance_80(i)/800);

    T_cell_Davis_spring_80(i) = Davis_spring_temp(i) + ...
            (NOCT-20).*(Davis_spring_irradiance_80(i)/800);
end

figure(6)
    hold on
    grid on
    grid minor
    plot(t,T_cell_Casey_summer_80)
    plot(t,T_cell_Casey_spring_80)
    plot(t,T_cell_Davis_summer_80)
    plot(t,T_cell_Davis_spring_80)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Solar Cell Temperature - 80% Clouds')
    hold off

%% 3) Pcm temps
% WInd = 5km/hr
PCM_TEMP_WIND_5K_ALL_LOC = ...
    readtable("PCM_TEMP_WIND_5K_ALL_LOC.xlsx");

PCM_TEMP_WIND_5K_ALL_LOC = ...
    table2array(PCM_TEMP_WIND_5K_ALL_LOC);

% Separate data 
PCM_temp_Casey_Sum_5k = PCM_TEMP_WIND_5K_ALL_LOC(1,:);
PCM_temp_Casey_Spr_5k = PCM_TEMP_WIND_5K_ALL_LOC(2,:);

PCM_temp_Davis_Sum_5k = PCM_TEMP_WIND_5K_ALL_LOC(3,:);
PCM_temp_Davis_Spr_5k = PCM_TEMP_WIND_5K_ALL_LOC(4,:);

% sanity check - plot irradiance values
figure(7)
hold on
grid on
grid minor
plot(t,PCM_temp_Casey_Sum_5k)
plot(t,PCM_temp_Casey_Spr_5k)
plot(t,PCM_temp_Davis_Sum_5k)
plot(t,PCM_temp_Davis_Spr_5k)
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
xlabel('Time - 24 hr')
ylabel('PCM Temp')
title('PCM Temperature - Wind = 5km/hr')
hold off

%-----------------------
% WInd = 10km/hr
PCM_TEMP_WIND_10K_ALL_LOC = ...
    readtable("PCM_TEMP_WIND_10K_ALL_LOC.xlsx");

PCM_TEMP_WIND_10K_ALL_LOC = ...
    table2array(PCM_TEMP_WIND_10K_ALL_LOC);

% Separate data 
PCM_temp_Casey_Sum_10k = PCM_TEMP_WIND_10K_ALL_LOC(1,:);
PCM_temp_Casey_Spr_10k = PCM_TEMP_WIND_10K_ALL_LOC(2,:);

PCM_temp_Davis_Sum_10k = PCM_TEMP_WIND_10K_ALL_LOC(3,:);
PCM_temp_Davis_Spr_10k = PCM_TEMP_WIND_10K_ALL_LOC(4,:);

% sanity check - plot irradiance values
figure(8)
hold on
grid on
grid minor
plot(t,PCM_temp_Casey_Sum_10k)
plot(t,PCM_temp_Casey_Spr_10k)
plot(t,PCM_temp_Davis_Sum_10k)
plot(t,PCM_temp_Davis_Spr_10k)
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
xlabel('Time - 24 hr')
ylabel('PCM Temp')
title('PCM Temperature - Wind = 10km/hr')
hold off

%-----------------------
% WInd = 25km/hr
PCM_TEMP_WIND_25K_ALL_LOC = ...
    readtable("PCM_TEMP_WIND_25K_ALL_LOC.xlsx");

PCM_TEMP_WIND_25K_ALL_LOC = ...
    table2array(PCM_TEMP_WIND_25K_ALL_LOC);

% Separate data 
PCM_temp_Casey_Sum_25k = PCM_TEMP_WIND_25K_ALL_LOC(1,:);
PCM_temp_Casey_Spr_25k = PCM_TEMP_WIND_25K_ALL_LOC(2,:);

PCM_temp_Davis_Sum_25k = PCM_TEMP_WIND_25K_ALL_LOC(3,:);
PCM_temp_Davis_Spr_25k = PCM_TEMP_WIND_25K_ALL_LOC(4,:);

% sanity check - plot irradiance values
figure(9)
hold on
grid on
grid minor
plot(t,PCM_temp_Casey_Sum_25k)
plot(t,PCM_temp_Casey_Spr_25k)
plot(t,PCM_temp_Davis_Sum_25k)
plot(t,PCM_temp_Davis_Spr_25k)
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
xlabel('Time - 24 hr')
ylabel('PCM Temp')
title('PCM Temperature - Wind = 25km/hr')
hold off


%-----------------------
% WInd = 50km/hr
PCM_TEMP_WIND_50K_ALL_LOC = ...
    readtable("PCM_TEMP_WIND_50K_ALL_LOC.xlsx");

PCM_TEMP_WIND_50K_ALL_LOC = ...
    table2array(PCM_TEMP_WIND_50K_ALL_LOC);

% Separate data 
PCM_temp_Casey_Sum_50k = PCM_TEMP_WIND_50K_ALL_LOC(1,:);
PCM_temp_Casey_Spr_50k = PCM_TEMP_WIND_50K_ALL_LOC(2,:);

PCM_temp_Davis_Sum_50k = PCM_TEMP_WIND_50K_ALL_LOC(3,:);
PCM_temp_Davis_Spr_50k = PCM_TEMP_WIND_50K_ALL_LOC(4,:);

% sanity check - plot irradiance values
figure(10)
hold on
grid on
grid minor
plot(t,PCM_temp_Casey_Sum_50k)
plot(t,PCM_temp_Casey_Spr_50k)
plot(t,PCM_temp_Davis_Sum_50k)
plot(t,PCM_temp_Davis_Spr_50k)
legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
xlabel('Time - 24 hr')
ylabel('PCM Temp')
title('PCM Temperature - Wind = 50km/hr')
hold off

%% 4) Establish average temperature and temp diff

% BEGINNING OF CASE BREAK DOWN: 01-80
% Case format: [Loc]:[Season]:[Cloud]:[Wind]
% e.g. [Casey]/[sum]/[0%]/[5/10/25/50] - 01,02,03,04

% ---- % [[0% Clouds]: 01:20]] % ---- %
%-------------------------------------------------------------------
    % [Wind = 5,10,25,50]
    % 01 = 5km/hr, etc;
Casey_sum_temp_diff_01 = zeros(1,length(t));
Casey_spr_temp_diff_01 = zeros(1,length(t));
Davis_sum_temp_diff_01 = zeros(1,length(t));
Davis_spr_temp_diff_01 = zeros(1,length(t));

Casey_sum_temp_diff_02 = zeros(1,length(t));
Casey_spr_temp_diff_02 = zeros(1,length(t));
Davis_sum_temp_diff_02 = zeros(1,length(t));
Davis_spr_temp_diff_02 = zeros(1,length(t));

Casey_sum_temp_diff_03 = zeros(1,length(t));
Casey_spr_temp_diff_03 = zeros(1,length(t));
Davis_sum_temp_diff_03 = zeros(1,length(t));
Davis_spr_temp_diff_03 = zeros(1,length(t));

Casey_sum_temp_diff_04 = zeros(1,length(t));
Casey_spr_temp_diff_04 = zeros(1,length(t));
Davis_sum_temp_diff_04 = zeros(1,length(t));
Davis_spr_temp_diff_04 = zeros(1,length(t));

for i = 1:48 % create temp diff values 
% ------ Case 01
    Casey_sum_temp_diff_01(i) = T_cell_Casey_summer(i) - ...
        PCM_temp_Casey_Sum_5k(i);
    Casey_spr_temp_diff_01(i) = T_cell_Casey_spring(i) - ...
        PCM_temp_Casey_Spr_5k(i);
    Davis_sum_temp_diff_01(i) = T_cell_Davis_summer(i) - ...
        PCM_temp_Davis_Sum_5k(i);
    Davis_spr_temp_diff_01(i) = T_cell_Davis_spring(i) - ...
        PCM_temp_Davis_Spr_5k(i);

% ------ Case 02
    Casey_sum_temp_diff_02(i) = T_cell_Casey_summer(i) - ...
        PCM_temp_Casey_Sum_10k(i);
    Casey_spr_temp_diff_02(i) = T_cell_Casey_spring(i) - ...
        PCM_temp_Casey_Spr_10k(i);
    Davis_sum_temp_diff_02(i) = T_cell_Davis_summer(i) - ...
        PCM_temp_Davis_Sum_10k(i);
    Davis_spr_temp_diff_02(i) = T_cell_Davis_spring(i) - ...
        PCM_temp_Davis_Spr_10k(i);

% ------ Case 03
    Casey_sum_temp_diff_03(i) = T_cell_Casey_summer(i) - ...
        PCM_temp_Casey_Sum_25k(i);
    Casey_spr_temp_diff_03(i) = T_cell_Casey_spring(i) - ...
        PCM_temp_Casey_Spr_25k(i);
    Davis_sum_temp_diff_03(i) = T_cell_Davis_summer(i) - ...
        PCM_temp_Davis_Sum_25k(i);
    Davis_spr_temp_diff_03(i) = T_cell_Davis_spring(i) - ...
        PCM_temp_Davis_Spr_25k(i);

% ------ Case 04
    Casey_sum_temp_diff_04(i) = T_cell_Casey_summer(i) - ...
        PCM_temp_Casey_Sum_50k(i);
    Casey_spr_temp_diff_04(i) = T_cell_Casey_spring(i) - ...
        PCM_temp_Casey_Spr_50k(i);
    Davis_sum_temp_diff_04(i) = T_cell_Davis_summer(i) - ...
        PCM_temp_Davis_Sum_50k(i);
    Davis_spr_temp_diff_04(i) = T_cell_Davis_spring(i) - ...
        PCM_temp_Davis_Spr_50k(i);
end

% mean temps
Casey_sum_mean_temp_01 = zeros(1,length(t));
Casey_spr_mean_temp_01 = zeros(1,length(t));
Davis_sum_mean_temp_01 = zeros(1,length(t));
Davis_spr_mean_temp_01 = zeros(1,length(t));

Casey_sum_mean_temp_02 = zeros(1,length(t));
Casey_spr_mean_temp_02 = zeros(1,length(t));
Davis_sum_mean_temp_02 = zeros(1,length(t));
Davis_spr_mean_temp_02 = zeros(1,length(t));

Casey_sum_mean_temp_03 = zeros(1,length(t));
Casey_spr_mean_temp_03 = zeros(1,length(t));
Davis_sum_mean_temp_03 = zeros(1,length(t));
Davis_spr_mean_temp_03 = zeros(1,length(t));

Casey_sum_mean_temp_04 = zeros(1,length(t));
Casey_spr_mean_temp_04 = zeros(1,length(t));
Davis_sum_mean_temp_04 = zeros(1,length(t));
Davis_spr_mean_temp_04 = zeros(1,length(t));

for i = 1:48 % MEAN TEMPS AND DIFFS!!
% Case 1
    Casey_sum_mean_temp_01(i) = T_cell_Casey_summer(i) ...
                            + (Casey_sum_temp_diff_01(i)/2);    
    Casey_spr_mean_temp_01(i) = T_cell_Casey_spring(i) ...
                            + (Casey_spr_temp_diff_01(i)/2);
    Davis_sum_mean_temp_01(i) = T_cell_Davis_summer(i) ...
                            + (Davis_sum_temp_diff_01(i)/2);
    Davis_spr_mean_temp_01(i) = T_cell_Davis_spring(i) ...
                            + (Davis_spr_temp_diff_01(i)/2);
% Case 2
    Casey_sum_mean_temp_02(i) = T_cell_Casey_summer(i) ...
                            + (Casey_sum_temp_diff_02(i)/2);    
    Casey_spr_mean_temp_02(i) = T_cell_Casey_spring(i) ...
                            + (Casey_spr_temp_diff_02(i)/2);
    Davis_sum_mean_temp_02(i) = T_cell_Davis_summer(i) ...
                            + (Davis_sum_temp_diff_02(i)/2);
    Davis_spr_mean_temp_02(i) = T_cell_Davis_spring(i) ...
                            + (Davis_spr_temp_diff_02(i)/2);
% Case 3
    Casey_sum_mean_temp_03(i) = T_cell_Casey_summer(i) ...
                            + (Casey_sum_temp_diff_03(i)/2);    
    Casey_spr_mean_temp_03(i) = T_cell_Casey_spring(i) ...
                            + (Casey_spr_temp_diff_03(i)/2);
    Davis_sum_mean_temp_03(i) = T_cell_Davis_summer(i) ...
                            + (Davis_sum_temp_diff_03(i)/2);
    Davis_spr_mean_temp_03(i) = T_cell_Davis_spring(i) ...
                            + (Davis_spr_temp_diff_03(i)/2);
% Case 4
    Casey_sum_mean_temp_04(i) = T_cell_Casey_summer(i) ...
                            + (Casey_sum_temp_diff_04(i)/2);    
    Casey_spr_mean_temp_04(i) = T_cell_Casey_spring(i) ...
                            + (Casey_spr_temp_diff_04(i)/2);
    Davis_sum_mean_temp_04(i) = T_cell_Davis_summer(i) ...
                            + (Davis_sum_temp_diff_04(i)/2);
    Davis_spr_mean_temp_04(i) = T_cell_Davis_spring(i) ...
                            + (Davis_spr_temp_diff_04(i)/2);
end


% ---- % [[20% Clouds]: 05:08]] % ---- %
%-------------------------------------------------------------------
    Casey_sum_temp_diff_05 = zeros(1,length(t));
    Casey_spr_temp_diff_05 = zeros(1,length(t));
    Davis_sum_temp_diff_05 = zeros(1,length(t));
    Davis_spr_temp_diff_05 = zeros(1,length(t));
    
    Casey_sum_temp_diff_06 = zeros(1,length(t));
    Casey_spr_temp_diff_06 = zeros(1,length(t));
    Davis_sum_temp_diff_06 = zeros(1,length(t));
    Davis_spr_temp_diff_06 = zeros(1,length(t));
    
    Casey_sum_temp_diff_07 = zeros(1,length(t));
    Casey_spr_temp_diff_07 = zeros(1,length(t));
    Davis_sum_temp_diff_07 = zeros(1,length(t));
    Davis_spr_temp_diff_07 = zeros(1,length(t));
    
    Casey_sum_temp_diff_08 = zeros(1,length(t));
    Casey_spr_temp_diff_08 = zeros(1,length(t));
    Davis_sum_temp_diff_08 = zeros(1,length(t));
    Davis_spr_temp_diff_08 = zeros(1,length(t));
for i = 1:48 % create temp diff values 
% ------ Case 05
    Casey_sum_temp_diff_05(i) = T_cell_Casey_summer_20(i) - ...
        PCM_temp_Casey_Sum_5k(i);
    Casey_spr_temp_diff_05(i) = T_cell_Casey_spring_20(i) - ...
        PCM_temp_Casey_Spr_5k(i);
    Davis_sum_temp_diff_05(i) = T_cell_Davis_summer_20(i) - ...
        PCM_temp_Davis_Sum_5k(i);
    Davis_spr_temp_diff_05(i) = T_cell_Davis_spring_20(i) - ...
        PCM_temp_Davis_Spr_5k(i);

% ------ Case 06
    Casey_sum_temp_diff_06(i) = T_cell_Casey_summer_20(i) - ...
        PCM_temp_Casey_Sum_10k(i);
    Casey_spr_temp_diff_06(i) = T_cell_Casey_spring_20(i) - ...
        PCM_temp_Casey_Spr_10k(i);
    Davis_sum_temp_diff_06(i) = T_cell_Davis_summer_20(i) - ...
        PCM_temp_Davis_Sum_10k(i);
    Davis_spr_temp_diff_06(i) = T_cell_Davis_spring_20(i) - ...
        PCM_temp_Davis_Spr_10k(i);

% ------ Case 07
    Casey_sum_temp_diff_07(i) = T_cell_Casey_summer_20(i) - ...
        PCM_temp_Casey_Sum_25k(i);
    Casey_spr_temp_diff_07(i) = T_cell_Casey_spring_20(i) - ...
        PCM_temp_Casey_Spr_25k(i);
    Davis_sum_temp_diff_07(i) = T_cell_Davis_summer_20(i) - ...
        PCM_temp_Davis_Sum_25k(i);
    Davis_spr_temp_diff_07(i) = T_cell_Davis_spring_20(i) - ...
        PCM_temp_Davis_Spr_25k(i);

% ------ Case 08
    Casey_sum_temp_diff_08(i) = T_cell_Casey_summer_20(i) - ...
        PCM_temp_Casey_Sum_50k(i);
    Casey_spr_temp_diff_08(i) = T_cell_Casey_spring_20(i) - ...
            PCM_temp_Casey_Spr_50k(i);
    Davis_sum_temp_diff_08(i) = T_cell_Davis_summer_20(i) - ...
        PCM_temp_Davis_Sum_50k(i);
    Davis_spr_temp_diff_08(i) = T_cell_Davis_spring_20(i) - ...
        PCM_temp_Davis_Spr_50k(i);
end
    
    % mean temps
Casey_sum_mean_temp_05 = zeros(1,length(t));
Casey_spr_mean_temp_05 = zeros(1,length(t));
Davis_sum_mean_temp_05 = zeros(1,length(t));
Davis_spr_mean_temp_05 = zeros(1,length(t));

Casey_sum_mean_temp_06 = zeros(1,length(t));
Casey_spr_mean_temp_06 = zeros(1,length(t));
Davis_sum_mean_temp_06 = zeros(1,length(t));
Davis_spr_mean_temp_06 = zeros(1,length(t));

Casey_sum_mean_temp_07 = zeros(1,length(t));
Casey_spr_mean_temp_07 = zeros(1,length(t));
Davis_sum_mean_temp_07 = zeros(1,length(t));
Davis_spr_mean_temp_07 = zeros(1,length(t));

Casey_sum_mean_temp_08 = zeros(1,length(t));
Casey_spr_mean_temp_08 = zeros(1,length(t));
Davis_sum_mean_temp_08 = zeros(1,length(t));
Davis_spr_mean_temp_08 = zeros(1,length(t));

for i = 1:48 % MEAN TEMPS AND DIFFS!!
% Case 5
    Casey_sum_mean_temp_05(i) = T_cell_Casey_summer_20(i) ...
                            + (Casey_sum_temp_diff_05(i)/2);    
    Casey_spr_mean_temp_05(i) = T_cell_Casey_spring_20(i) ...
                            + (Casey_spr_temp_diff_05(i)/2);
    Davis_sum_mean_temp_05(i) = T_cell_Davis_summer_20(i) ...
                            + (Davis_sum_temp_diff_05(i)/2);
    Davis_spr_mean_temp_05(i) = T_cell_Davis_spring_20(i) ...
                            + (Davis_spr_temp_diff_05(i)/2);
% Case 6
    Casey_sum_mean_temp_06(i) = T_cell_Casey_summer_20(i) ...
                            + (Casey_sum_temp_diff_06(i)/2);    
    Casey_spr_mean_temp_06(i) = T_cell_Casey_spring_20(i) ...
                            + (Casey_spr_temp_diff_06(i)/2);
    Davis_sum_mean_temp_06(i) = T_cell_Davis_summer_20(i) ...
                            + (Davis_sum_temp_diff_06(i)/2);
    Davis_spr_mean_temp_06(i) = T_cell_Davis_spring_20(i) ...
                            + (Davis_spr_temp_diff_06(i)/2);
% Case 7
    Casey_sum_mean_temp_07(i) = T_cell_Casey_summer_20(i) ...
                            + (Casey_sum_temp_diff_07(i)/2);    
    Casey_spr_mean_temp_07(i) = T_cell_Casey_spring_20(i) ...
                            + (Casey_spr_temp_diff_07(i)/2);
    Davis_sum_mean_temp_07(i) = T_cell_Davis_summer_20(i) ...
                            + (Davis_sum_temp_diff_07(i)/2);
    Davis_spr_mean_temp_07(i) = T_cell_Davis_spring_20(i) ...
                            + (Davis_spr_temp_diff_07(i)/2);
% Case 8
    Casey_sum_mean_temp_08(i) = T_cell_Casey_summer_20(i) ...
                            + (Casey_sum_temp_diff_08(i)/2);    
    Casey_spr_mean_temp_08(i) = T_cell_Casey_spring_20(i) ...
                            + (Casey_spr_temp_diff_08(i)/2);
    Davis_sum_mean_temp_08(i) = T_cell_Davis_summer_20(i) ...
                            + (Davis_sum_temp_diff_08(i)/2);
    Davis_spr_mean_temp_08(i) = T_cell_Davis_spring_20(i) ...
                            + (Davis_spr_temp_diff_08(i)/2);
end


% ---- % [[40% Clouds]: 09:12]] % ---- %
%-------------------------------------------------------------------%
    % [40% Clouds]:[Wind = 5,10,25,50]
    % 09 = 5km/hr, 10 = 10km/hr, 11 = 25km/hr, 12 = 50km/hr
    Casey_sum_temp_diff_09 = zeros(1,length(t));
    Casey_spr_temp_diff_09 = zeros(1,length(t));
    Davis_sum_temp_diff_09 = zeros(1,length(t));
    Davis_spr_temp_diff_09 = zeros(1,length(t));
 
    Casey_sum_temp_diff_10 = zeros(1,length(t));
    Casey_spr_temp_diff_10 = zeros(1,length(t));
    Davis_sum_temp_diff_10 = zeros(1,length(t));
    Davis_spr_temp_diff_10 = zeros(1,length(t));
 
    Casey_sum_temp_diff_11 = zeros(1,length(t));
    Casey_spr_temp_diff_11 = zeros(1,length(t));
    Davis_sum_temp_diff_11 = zeros(1,length(t));
    Davis_spr_temp_diff_11 = zeros(1,length(t));
 
    Casey_sum_temp_diff_12 = zeros(1,length(t));
    Casey_spr_temp_diff_12 = zeros(1,length(t));
    Davis_sum_temp_diff_12 = zeros(1,length(t));
    Davis_spr_temp_diff_12 = zeros(1,length(t));
 
for i = 1:48 % create temp diff values
% ------ Case 09
    Casey_sum_temp_diff_09(i) = T_cell_Casey_summer_40(i) - ...
        PCM_temp_Casey_Sum_5k(i);
    Casey_spr_temp_diff_09(i) = T_cell_Casey_spring_40(i) - ...
        PCM_temp_Casey_Spr_5k(i);
    Davis_sum_temp_diff_09(i) = T_cell_Davis_summer_40(i) - ...
        PCM_temp_Davis_Sum_5k(i);
    Davis_spr_temp_diff_09(i) = T_cell_Davis_spring_40(i) - ...
        PCM_temp_Davis_Spr_5k(i);   % FIXED: was Davis_Sum
 
% ------ Case 10
    Casey_sum_temp_diff_10(i) = T_cell_Casey_summer_40(i) - ...
        PCM_temp_Casey_Sum_10k(i);
    Casey_spr_temp_diff_10(i) = T_cell_Casey_spring_40(i) - ...
        PCM_temp_Casey_Spr_10k(i);
    Davis_sum_temp_diff_10(i) = T_cell_Davis_summer_40(i) - ...
        PCM_temp_Davis_Sum_10k(i);
    Davis_spr_temp_diff_10(i) = T_cell_Davis_spring_40(i) - ...
        PCM_temp_Davis_Spr_10k(i);
 
% ------ Case 11
    Casey_sum_temp_diff_11(i) = T_cell_Casey_summer_40(i) - ...
        PCM_temp_Casey_Sum_25k(i);
    Casey_spr_temp_diff_11(i) = T_cell_Casey_spring_40(i) - ...
        PCM_temp_Casey_Spr_25k(i);
    Davis_sum_temp_diff_11(i) = T_cell_Davis_summer_40(i) - ...
        PCM_temp_Davis_Sum_25k(i);
    Davis_spr_temp_diff_11(i) = T_cell_Davis_spring_40(i) - ...
        PCM_temp_Davis_Spr_25k(i);
 
% ------ Case 12
    Casey_sum_temp_diff_12(i) = T_cell_Casey_summer_40(i) - ...
        PCM_temp_Casey_Sum_50k(i);
    Casey_spr_temp_diff_12(i) = T_cell_Casey_spring_40(i) - ...
        PCM_temp_Casey_Spr_50k(i);
    Davis_sum_temp_diff_12(i) = T_cell_Davis_summer_40(i) - ...
        PCM_temp_Davis_Sum_50k(i);
    Davis_spr_temp_diff_12(i) = T_cell_Davis_spring_40(i) - ...
        PCM_temp_Davis_Spr_50k(i);
end
 
    % mean temps
Casey_sum_mean_temp_09 = zeros(1,length(t));
Casey_spr_mean_temp_09 = zeros(1,length(t));
Davis_sum_mean_temp_09 = zeros(1,length(t));
Davis_spr_mean_temp_09 = zeros(1,length(t));
 
Casey_sum_mean_temp_10 = zeros(1,length(t));
Casey_spr_mean_temp_10 = zeros(1,length(t));
Davis_sum_mean_temp_10 = zeros(1,length(t));
Davis_spr_mean_temp_10 = zeros(1,length(t));
 
Casey_sum_mean_temp_11 = zeros(1,length(t));
Casey_spr_mean_temp_11 = zeros(1,length(t));
Davis_sum_mean_temp_11 = zeros(1,length(t));
Davis_spr_mean_temp_11 = zeros(1,length(t));
 
Casey_sum_mean_temp_12 = zeros(1,length(t));
Casey_spr_mean_temp_12 = zeros(1,length(t));
Davis_sum_mean_temp_12 = zeros(1,length(t));
Davis_spr_mean_temp_12 = zeros(1,length(t));
 
for i = 1:48 % MEAN TEMPS AND DIFFS!!
% NOTE: mean of hot (cell) and cold (PCM) faces = T_cell - diff/2
% (previous form: ambient + diff/2 -- see flag in chat)
% Case 9
    Casey_sum_mean_temp_09(i) = T_cell_Casey_summer_40(i) ...
                            - (Casey_sum_temp_diff_09(i)/2);
    Casey_spr_mean_temp_09(i) = T_cell_Casey_spring_40(i) ...
                            - (Casey_spr_temp_diff_09(i)/2);
    Davis_sum_mean_temp_09(i) = T_cell_Davis_summer_40(i) ...
                            - (Davis_sum_temp_diff_09(i)/2);
    Davis_spr_mean_temp_09(i) = T_cell_Davis_spring_40(i) ...
                            - (Davis_spr_temp_diff_09(i)/2);
% Case 10
    Casey_sum_mean_temp_10(i) = T_cell_Casey_summer_40(i) ...
                            - (Casey_sum_temp_diff_10(i)/2);
    Casey_spr_mean_temp_10(i) = T_cell_Casey_spring_40(i) ...
                            - (Casey_spr_temp_diff_10(i)/2);
    Davis_sum_mean_temp_10(i) = T_cell_Davis_summer_40(i) ...
                            - (Davis_sum_temp_diff_10(i)/2);
    Davis_spr_mean_temp_10(i) = T_cell_Davis_spring_40(i) ...
                            - (Davis_spr_temp_diff_10(i)/2);
% Case 11
    Casey_sum_mean_temp_11(i) = T_cell_Casey_summer_40(i) ...
                            - (Casey_sum_temp_diff_11(i)/2);
    Casey_spr_mean_temp_11(i) = T_cell_Casey_spring_40(i) ...
                            - (Casey_spr_temp_diff_11(i)/2);
    Davis_sum_mean_temp_11(i) = T_cell_Davis_summer_40(i) ...
                            - (Davis_sum_temp_diff_11(i)/2);
    Davis_spr_mean_temp_11(i) = T_cell_Davis_spring_40(i) ...
                            - (Davis_spr_temp_diff_11(i)/2);
% Case 12
    Casey_sum_mean_temp_12(i) = T_cell_Casey_summer_40(i) ...
                            - (Casey_sum_temp_diff_12(i)/2);
    Casey_spr_mean_temp_12(i) = T_cell_Casey_spring_40(i) ...
                            - (Casey_spr_temp_diff_12(i)/2);
    Davis_sum_mean_temp_12(i) = T_cell_Davis_summer_40(i) ...
                            - (Davis_sum_temp_diff_12(i)/2);
    Davis_spr_mean_temp_12(i) = T_cell_Davis_spring_40(i) ...
                            - (Davis_spr_temp_diff_12(i)/2);
end
%----------------------------------------------------------------------------%
% ---- % [[60% Clouds]: 13:16]] % ---- %
%-------------------------------------------------------------------%

%------------------------------------------------------------------
    % [60% Clouds]:[Wind = 5,10,25,50]
    % 13 = 5km/hr, 14 = 10km/hr, 15 = 25km/hr, 16 = 50km/hr
    Casey_sum_temp_diff_13 = zeros(1,length(t));
    Casey_spr_temp_diff_13 = zeros(1,length(t));
    Davis_sum_temp_diff_13 = zeros(1,length(t));
    Davis_spr_temp_diff_13 = zeros(1,length(t));
 
    Casey_sum_temp_diff_14 = zeros(1,length(t));
    Casey_spr_temp_diff_14 = zeros(1,length(t));
    Davis_sum_temp_diff_14 = zeros(1,length(t));
    Davis_spr_temp_diff_14 = zeros(1,length(t));
 
    Casey_sum_temp_diff_15 = zeros(1,length(t));
    Casey_spr_temp_diff_15 = zeros(1,length(t));
    Davis_sum_temp_diff_15 = zeros(1,length(t));
    Davis_spr_temp_diff_15 = zeros(1,length(t));
 
    Casey_sum_temp_diff_16 = zeros(1,length(t));
    Casey_spr_temp_diff_16 = zeros(1,length(t));
    Davis_sum_temp_diff_16 = zeros(1,length(t));
    Davis_spr_temp_diff_16 = zeros(1,length(t));
 
for i = 1:48 % create temp diff values
% ------ Case 13
    Casey_sum_temp_diff_13(i) = T_cell_Casey_summer_60(i) - ...
        PCM_temp_Casey_Sum_5k(i);
    Casey_spr_temp_diff_13(i) = T_cell_Casey_spring_60(i) - ...
        PCM_temp_Casey_Spr_5k(i);
    Davis_sum_temp_diff_13(i) = T_cell_Davis_summer_60(i) - ...
        PCM_temp_Davis_Sum_5k(i);
    Davis_spr_temp_diff_13(i) = T_cell_Davis_spring_60(i) - ...
        PCM_temp_Davis_Spr_5k(i);
 
% ------ Case 14
    Casey_sum_temp_diff_14(i) = T_cell_Casey_summer_60(i) - ...
        PCM_temp_Casey_Sum_10k(i);
    Casey_spr_temp_diff_14(i) = T_cell_Casey_spring_60(i) - ...
        PCM_temp_Casey_Spr_10k(i);
    Davis_sum_temp_diff_14(i) = T_cell_Davis_summer_60(i) - ...
        PCM_temp_Davis_Sum_10k(i);
    Davis_spr_temp_diff_14(i) = T_cell_Davis_spring_60(i) - ...
        PCM_temp_Davis_Spr_10k(i);
 
% ------ Case 15
    Casey_sum_temp_diff_15(i) = T_cell_Casey_summer_60(i) - ...
        PCM_temp_Casey_Sum_25k(i);
    Casey_spr_temp_diff_15(i) = T_cell_Casey_spring_60(i) - ...
        PCM_temp_Casey_Spr_25k(i);
    Davis_sum_temp_diff_15(i) = T_cell_Davis_summer_60(i) - ...
        PCM_temp_Davis_Sum_25k(i);
    Davis_spr_temp_diff_15(i) = T_cell_Davis_spring_60(i) - ...
        PCM_temp_Davis_Spr_25k(i);
 
% ------ Case 16
    Casey_sum_temp_diff_16(i) = T_cell_Casey_summer_60(i) - ...
        PCM_temp_Casey_Sum_50k(i);
    Casey_spr_temp_diff_16(i) = T_cell_Casey_spring_60(i) - ...
        PCM_temp_Casey_Spr_50k(i);
    Davis_sum_temp_diff_16(i) = T_cell_Davis_summer_60(i) - ...
        PCM_temp_Davis_Sum_50k(i);
    Davis_spr_temp_diff_16(i) = T_cell_Davis_spring_60(i) - ...
        PCM_temp_Davis_Spr_50k(i);
end
 
    % mean temps
Casey_sum_mean_temp_13 = zeros(1,length(t));
Casey_spr_mean_temp_13 = zeros(1,length(t));
Davis_sum_mean_temp_13 = zeros(1,length(t));
Davis_spr_mean_temp_13 = zeros(1,length(t));
 
Casey_sum_mean_temp_14 = zeros(1,length(t));
Casey_spr_mean_temp_14 = zeros(1,length(t));
Davis_sum_mean_temp_14 = zeros(1,length(t));
Davis_spr_mean_temp_14 = zeros(1,length(t));
 
Casey_sum_mean_temp_15 = zeros(1,length(t));
Casey_spr_mean_temp_15 = zeros(1,length(t));
Davis_sum_mean_temp_15 = zeros(1,length(t));
Davis_spr_mean_temp_15 = zeros(1,length(t));
 
Casey_sum_mean_temp_16 = zeros(1,length(t));
Casey_spr_mean_temp_16 = zeros(1,length(t));
Davis_sum_mean_temp_16 = zeros(1,length(t));
Davis_spr_mean_temp_16 = zeros(1,length(t));
 
for i = 1:48 % MEAN TEMPS AND DIFFS!!
% mean of hot (cell) and cold (PCM) faces = T_cell - diff/2
% Case 13
    Casey_sum_mean_temp_13(i) = T_cell_Casey_summer_60(i) ...
                            - (Casey_sum_temp_diff_13(i)/2);
    Casey_spr_mean_temp_13(i) = T_cell_Casey_spring_60(i) ...
                            - (Casey_spr_temp_diff_13(i)/2);
    Davis_sum_mean_temp_13(i) = T_cell_Davis_summer_60(i) ...
                            - (Davis_sum_temp_diff_13(i)/2);
    Davis_spr_mean_temp_13(i) = T_cell_Davis_spring_60(i) ...
                            - (Davis_spr_temp_diff_13(i)/2);
% Case 14
    Casey_sum_mean_temp_14(i) = T_cell_Casey_summer_60(i) ...
                            - (Casey_sum_temp_diff_14(i)/2);
    Casey_spr_mean_temp_14(i) = T_cell_Casey_spring_60(i) ...
                            - (Casey_spr_temp_diff_14(i)/2);
    Davis_sum_mean_temp_14(i) = T_cell_Davis_summer_60(i) ...
                            - (Davis_sum_temp_diff_14(i)/2);
    Davis_spr_mean_temp_14(i) = T_cell_Davis_spring_60(i) ...
                            - (Davis_spr_temp_diff_14(i)/2);
% Case 15
    Casey_sum_mean_temp_15(i) = T_cell_Casey_summer_60(i) ...
                            - (Casey_sum_temp_diff_15(i)/2);
    Casey_spr_mean_temp_15(i) = T_cell_Casey_spring_60(i) ...
                            - (Casey_spr_temp_diff_15(i)/2);
    Davis_sum_mean_temp_15(i) = T_cell_Davis_summer_60(i) ...
                            - (Davis_sum_temp_diff_15(i)/2);
    Davis_spr_mean_temp_15(i) = T_cell_Davis_spring_60(i) ...
                            - (Davis_spr_temp_diff_15(i)/2);
% Case 16
    Casey_sum_mean_temp_16(i) = T_cell_Casey_summer_60(i) ...
                            - (Casey_sum_temp_diff_16(i)/2);
    Casey_spr_mean_temp_16(i) = T_cell_Casey_spring_60(i) ...
                            - (Casey_spr_temp_diff_16(i)/2);
    Davis_sum_mean_temp_16(i) = T_cell_Davis_summer_60(i) ...
                            - (Davis_sum_temp_diff_16(i)/2);
    Davis_spr_mean_temp_16(i) = T_cell_Davis_spring_60(i) ...
                            - (Davis_spr_temp_diff_16(i)/2);
end


%----------------------------------------------------------------------------%
% ---- % [[80% Clouds]: 17:20]] % ---- %
%-------------------------------------------------------------------%
%------------------------------------------------------------------
    % [80% Clouds]:[Wind = 5,10,25,50]
    % 17 = 5km/hr, 18 = 10km/hr, 19 = 25km/hr, 20 = 50km/hr
    Casey_sum_temp_diff_17 = zeros(1,length(t));
    Casey_spr_temp_diff_17 = zeros(1,length(t));
    Davis_sum_temp_diff_17 = zeros(1,length(t));
    Davis_spr_temp_diff_17 = zeros(1,length(t));
 
    Casey_sum_temp_diff_18 = zeros(1,length(t));
    Casey_spr_temp_diff_18 = zeros(1,length(t));
    Davis_sum_temp_diff_18 = zeros(1,length(t));
    Davis_spr_temp_diff_18 = zeros(1,length(t));
 
    Casey_sum_temp_diff_19 = zeros(1,length(t));
    Casey_spr_temp_diff_19 = zeros(1,length(t));
    Davis_sum_temp_diff_19 = zeros(1,length(t));
    Davis_spr_temp_diff_19 = zeros(1,length(t));
 
    Casey_sum_temp_diff_20 = zeros(1,length(t));
    Casey_spr_temp_diff_20 = zeros(1,length(t));
    Davis_sum_temp_diff_20 = zeros(1,length(t));
    Davis_spr_temp_diff_20 = zeros(1,length(t));
 
for i = 1:48 % create temp diff values
% ------ Case 17
    Casey_sum_temp_diff_17(i) = T_cell_Casey_summer_80(i) - ...
        PCM_temp_Casey_Sum_5k(i);
    Casey_spr_temp_diff_17(i) = T_cell_Casey_spring_80(i) - ...
        PCM_temp_Casey_Spr_5k(i);
    Davis_sum_temp_diff_17(i) = T_cell_Davis_summer_80(i) - ...
        PCM_temp_Davis_Sum_5k(i);
    Davis_spr_temp_diff_17(i) = T_cell_Davis_spring_80(i) - ...
        PCM_temp_Davis_Spr_5k(i);
 
% ------ Case 18
    Casey_sum_temp_diff_18(i) = T_cell_Casey_summer_80(i) - ...
        PCM_temp_Casey_Sum_10k(i);
    Casey_spr_temp_diff_18(i) = T_cell_Casey_spring_80(i) - ...
        PCM_temp_Casey_Spr_10k(i);
    Davis_sum_temp_diff_18(i) = T_cell_Davis_summer_80(i) - ...
        PCM_temp_Davis_Sum_10k(i);
    Davis_spr_temp_diff_18(i) = T_cell_Davis_spring_80(i) - ...
        PCM_temp_Davis_Spr_10k(i);
 
% ------ Case 19
    Casey_sum_temp_diff_19(i) = T_cell_Casey_summer_80(i) - ...
        PCM_temp_Casey_Sum_25k(i);
    Casey_spr_temp_diff_19(i) = T_cell_Casey_spring_80(i) - ...
        PCM_temp_Casey_Spr_25k(i);
    Davis_sum_temp_diff_19(i) = T_cell_Davis_summer_80(i) - ...
        PCM_temp_Davis_Sum_25k(i);
    Davis_spr_temp_diff_19(i) = T_cell_Davis_spring_80(i) - ...
        PCM_temp_Davis_Spr_25k(i);
 
% ------ Case 20
    Casey_sum_temp_diff_20(i) = T_cell_Casey_summer_80(i) - ...
        PCM_temp_Casey_Sum_50k(i);
    Casey_spr_temp_diff_20(i) = T_cell_Casey_spring_80(i) - ...
        PCM_temp_Casey_Spr_50k(i);
    Davis_sum_temp_diff_20(i) = T_cell_Davis_summer_80(i) - ...
        PCM_temp_Davis_Sum_50k(i);
    Davis_spr_temp_diff_20(i) = T_cell_Davis_spring_80(i) - ...
        PCM_temp_Davis_Spr_50k(i);
end
 
    % mean temps
Casey_sum_mean_temp_17 = zeros(1,length(t));
Casey_spr_mean_temp_17 = zeros(1,length(t));
Davis_sum_mean_temp_17 = zeros(1,length(t));
Davis_spr_mean_temp_17 = zeros(1,length(t));
 
Casey_sum_mean_temp_18 = zeros(1,length(t));
Casey_spr_mean_temp_18 = zeros(1,length(t));
Davis_sum_mean_temp_18 = zeros(1,length(t));
Davis_spr_mean_temp_18 = zeros(1,length(t));
 
Casey_sum_mean_temp_19 = zeros(1,length(t));
Casey_spr_mean_temp_19 = zeros(1,length(t));
Davis_sum_mean_temp_19 = zeros(1,length(t));
Davis_spr_mean_temp_19 = zeros(1,length(t));
 
Casey_sum_mean_temp_20 = zeros(1,length(t));
Casey_spr_mean_temp_20 = zeros(1,length(t));
Davis_sum_mean_temp_20 = zeros(1,length(t));
Davis_spr_mean_temp_20 = zeros(1,length(t));
 
for i = 1:48 % MEAN TEMPS AND DIFFS!!
% mean of hot (cell) and cold (PCM) faces = T_cell - diff/2
% Case 17
    Casey_sum_mean_temp_17(i) = T_cell_Casey_summer_80(i) ...
                            - (Casey_sum_temp_diff_17(i)/2);
    Casey_spr_mean_temp_17(i) = T_cell_Casey_spring_80(i) ...
                            - (Casey_spr_temp_diff_17(i)/2);
    Davis_sum_mean_temp_17(i) = T_cell_Davis_summer_80(i) ...
                            - (Davis_sum_temp_diff_17(i)/2);
    Davis_spr_mean_temp_17(i) = T_cell_Davis_spring_80(i) ...
                            - (Davis_spr_temp_diff_17(i)/2);
% Case 18
    Casey_sum_mean_temp_18(i) = T_cell_Casey_summer_80(i) ...
                            - (Casey_sum_temp_diff_18(i)/2);
    Casey_spr_mean_temp_18(i) = T_cell_Casey_spring_80(i) ...
                            - (Casey_spr_temp_diff_18(i)/2);
    Davis_sum_mean_temp_18(i) = T_cell_Davis_summer_80(i) ...
                            - (Davis_sum_temp_diff_18(i)/2);
    Davis_spr_mean_temp_18(i) = T_cell_Davis_spring_80(i) ...
                            - (Davis_spr_temp_diff_18(i)/2);
% Case 19
    Casey_sum_mean_temp_19(i) = T_cell_Casey_summer_80(i) ...
                            - (Casey_sum_temp_diff_19(i)/2);
    Casey_spr_mean_temp_19(i) = T_cell_Casey_spring_80(i) ...
                            - (Casey_spr_temp_diff_19(i)/2);
    Davis_sum_mean_temp_19(i) = T_cell_Davis_summer_80(i) ...
                            - (Davis_sum_temp_diff_19(i)/2);
    Davis_spr_mean_temp_19(i) = T_cell_Davis_spring_80(i) ...
                            - (Davis_spr_temp_diff_19(i)/2);
% Case 20
    Casey_sum_mean_temp_20(i) = T_cell_Casey_summer_80(i) ...
                            - (Casey_sum_temp_diff_20(i)/2);
    Casey_spr_mean_temp_20(i) = T_cell_Casey_spring_80(i) ...
                            - (Casey_spr_temp_diff_20(i)/2);
    Davis_sum_mean_temp_20(i) = T_cell_Davis_summer_80(i) ...
                            - (Davis_sum_temp_diff_20(i)/2);
    Davis_spr_mean_temp_20(i) = T_cell_Davis_spring_80(i) ...
                            - (Davis_spr_temp_diff_20(i)/2);
end
%----------------------------------------------------------------------------%
%% 5) Find TEG metrics and power values
% V = N * seebck.(average temp) * temp_diff
N = 241; % number of p&n type conductors

% -- %% -- %% TEG INTERNAL RESISTANCE %% -- %% -- %%
% Variables
r_con = 5*(10^-9); % 
thick = 0.0011; % m - thickness - 1.1mm
area = 2.89 * 10^-6; % area - m^2  

elec_cond_stc = 28103; % Ohm.metre @ T = 300 K
seebeck_stc = 345 * 10^-6; % V / K @ T = 300 K

% Seebeck
% dimensionless seebeck equation
% ~ =  (-1.132*10^(-5) .* (Casey_mean_temp)^2 )...
% + (8.64*10^(-3) .* (Casey_mean_temp(i))) ...
% - 0.582;
% seebeck variable across 24/hour cycle

%----------------------------------------------------------------------------%
    % [0% Clouds]:[Wind = 5,10,25,50]

Casey_sum_mean_temp_01_K = zeros(1,length(t));
Casey_spr_mean_temp_01_K = zeros(1,length(t));
Davis_sum_mean_temp_01_K = zeros(1,length(t));
Davis_spr_mean_temp_01_K = zeros(1,length(t));

Casey_sum_mean_temp_02_K = zeros(1,length(t));
Casey_spr_mean_temp_02_K = zeros(1,length(t));
Davis_sum_mean_temp_02_K = zeros(1,length(t));
Davis_spr_mean_temp_02_K = zeros(1,length(t));

Casey_sum_mean_temp_03_K = zeros(1,length(t));
Casey_spr_mean_temp_03_K = zeros(1,length(t));
Davis_sum_mean_temp_03_K = zeros(1,length(t));
Davis_spr_mean_temp_03_K = zeros(1,length(t));

Casey_sum_mean_temp_04_K = zeros(1,length(t));
Casey_spr_mean_temp_04_K = zeros(1,length(t));
Davis_sum_mean_temp_04_K = zeros(1,length(t));
Davis_spr_mean_temp_04_K = zeros(1,length(t));


for i = 1:48
% Case 1
    Casey_sum_mean_temp_01_K(i) = Casey_sum_mean_temp_01(i) + 273.15;
    Casey_spr_mean_temp_01_K(i) = Casey_spr_mean_temp_01(i) + 273.15; 
    Davis_sum_mean_temp_01_K(i) = Davis_sum_mean_temp_01(i) + 273.15;
    Davis_spr_mean_temp_01_K(i) = Davis_spr_mean_temp_01(i) + 273.15;
% Case 2
    Casey_sum_mean_temp_02_K(i) = Casey_sum_mean_temp_02(i) + 273.15;
    Casey_spr_mean_temp_02_K(i) = Casey_spr_mean_temp_02(i) + 273.15; 
    Davis_sum_mean_temp_02_K(i) = Davis_sum_mean_temp_02(i) + 273.15;
    Davis_spr_mean_temp_02_K(i) = Davis_spr_mean_temp_02(i) + 273.15;
% Case 1
    Casey_sum_mean_temp_03_K(i) = Casey_sum_mean_temp_03(i) + 273.15;
    Casey_spr_mean_temp_03_K(i) = Casey_spr_mean_temp_03(i) + 273.15; 
    Davis_sum_mean_temp_03_K(i) = Davis_sum_mean_temp_03(i) + 273.15;
    Davis_spr_mean_temp_03_K(i) = Davis_spr_mean_temp_03(i) + 273.15;
% Case 1
    Casey_sum_mean_temp_04_K(i) = Casey_sum_mean_temp_04(i) + 273.15;
    Casey_spr_mean_temp_04_K(i) = Casey_spr_mean_temp_04(i) + 273.15; 
    Davis_sum_mean_temp_04_K(i) = Davis_sum_mean_temp_04(i) + 273.15;
    Davis_spr_mean_temp_04_K(i) = Davis_spr_mean_temp_04(i) + 273.15;

end
% Celsius 2 Kelvin!!

seebeck_dim_Casey_sum_01 = zeros(1,length(t));
seebeck_dim_Casey_spr_01 = zeros(1,length(t));
seebeck_dim_Davis_sum_01 = zeros(1,length(t));
seebeck_dim_Davis_spr_01 = zeros(1,length(t));

seebeck_dim_Casey_sum_02 = zeros(1,length(t));
seebeck_dim_Casey_spr_02 = zeros(1,length(t));
seebeck_dim_Davis_sum_02 = zeros(1,length(t));
seebeck_dim_Davis_spr_02 = zeros(1,length(t));

seebeck_dim_Casey_sum_03 = zeros(1,length(t));
seebeck_dim_Casey_spr_03 = zeros(1,length(t));
seebeck_dim_Davis_sum_03 = zeros(1,length(t));
seebeck_dim_Davis_spr_03 = zeros(1,length(t));

seebeck_dim_Casey_sum_04 = zeros(1,length(t));
seebeck_dim_Casey_spr_04 = zeros(1,length(t));
seebeck_dim_Davis_sum_04 = zeros(1,length(t));
seebeck_dim_Davis_spr_04 = zeros(1,length(t));

for i = 1:48
% Case 1
    seebeck_dim_Casey_sum_01(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_01_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_01_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_01(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_01_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_01_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_01(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_01_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_01_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_01(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_01_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_01_K(i))) ...
    - 0.582;

% Case 2
    seebeck_dim_Casey_sum_02(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_02_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_02_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_02(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_02_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_02_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_02(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_02_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_02_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_02(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_02_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_02_K(i))) ...
    - 0.582;

% Case 3
    seebeck_dim_Casey_sum_03(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_03_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_03_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_03(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_03_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_03_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_03(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_03_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_03_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_03(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_03_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_03_K(i))) ...
    - 0.582;

% Case 4
    seebeck_dim_Casey_sum_04(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_04_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_04_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_04(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_04_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_04_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_04(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_04_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_04_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_04(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_04_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_04_K(i))) ...
    - 0.582;
end

% dim*stc = seebeck
seebeck_Casey_sum_01 = zeros(1,length(t));
seebeck_Casey_spr_01 = zeros(1,length(t));
seebeck_Davis_sum_01 = zeros(1,length(t));
seebeck_Davis_spr_01 = zeros(1,length(t));

seebeck_Casey_sum_02 = zeros(1,length(t));
seebeck_Casey_spr_02 = zeros(1,length(t));
seebeck_Davis_sum_02 = zeros(1,length(t));
seebeck_Davis_spr_02 = zeros(1,length(t));

seebeck_Casey_sum_03 = zeros(1,length(t));
seebeck_Casey_spr_03 = zeros(1,length(t));
seebeck_Davis_sum_03 = zeros(1,length(t));
seebeck_Davis_spr_03 = zeros(1,length(t));

seebeck_Casey_sum_04 = zeros(1,length(t));
seebeck_Casey_spr_04 = zeros(1,length(t));
seebeck_Davis_sum_04 = zeros(1,length(t));
seebeck_Davis_spr_04 = zeros(1,length(t));

for i = 1:48 
% Case 1
    seebeck_Casey_sum_01(i) = seebeck_dim_Casey_sum_01(i).*seebeck_stc;
    seebeck_Casey_spr_01(i) = seebeck_dim_Casey_spr_01(i).*seebeck_stc;
    seebeck_Davis_sum_01(i) = seebeck_dim_Davis_sum_01(i).*seebeck_stc;
    seebeck_Davis_spr_01(i) = seebeck_dim_Davis_spr_01(i).*seebeck_stc;
% Case 2
    seebeck_Casey_sum_02(i) = seebeck_dim_Casey_sum_02(i).*seebeck_stc;
    seebeck_Casey_spr_02(i) = seebeck_dim_Casey_spr_02(i).*seebeck_stc;
    seebeck_Davis_sum_02(i) = seebeck_dim_Davis_sum_02(i).*seebeck_stc;
    seebeck_Davis_spr_02(i) = seebeck_dim_Davis_spr_02(i).*seebeck_stc;
% Case 3
    seebeck_Casey_sum_03(i) = seebeck_dim_Casey_sum_03(i).*seebeck_stc;
    seebeck_Casey_spr_03(i) = seebeck_dim_Casey_spr_03(i).*seebeck_stc;
    seebeck_Davis_sum_03(i) = seebeck_dim_Davis_sum_03(i).*seebeck_stc;
    seebeck_Davis_spr_03(i) = seebeck_dim_Davis_spr_03(i).*seebeck_stc;
% Case 4
    seebeck_Casey_sum_04(i) = seebeck_dim_Casey_sum_04(i).*seebeck_stc;
    seebeck_Casey_spr_04(i) = seebeck_dim_Casey_spr_04(i).*seebeck_stc;
    seebeck_Davis_sum_04(i) = seebeck_dim_Davis_sum_04(i).*seebeck_stc;
    seebeck_Davis_spr_04(i) = seebeck_dim_Davis_spr_04(i).*seebeck_stc;
end

% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum_01 = zeros(1,length(t));
TEG_V_Casey_spr_01 = zeros(1,length(t));
TEG_V_Davis_sum_01 = zeros(1,length(t));
TEG_V_Davis_spr_01 = zeros(1,length(t));

TEG_V_Casey_sum_02 = zeros(1,length(t));
TEG_V_Casey_spr_02 = zeros(1,length(t));
TEG_V_Davis_sum_02 = zeros(1,length(t));
TEG_V_Davis_spr_02 = zeros(1,length(t));

TEG_V_Casey_sum_03 = zeros(1,length(t));
TEG_V_Casey_spr_03 = zeros(1,length(t));
TEG_V_Davis_sum_03 = zeros(1,length(t));
TEG_V_Davis_spr_03 = zeros(1,length(t));

TEG_V_Casey_sum_04 = zeros(1,length(t));
TEG_V_Casey_spr_04 = zeros(1,length(t));
TEG_V_Davis_sum_04 = zeros(1,length(t));
TEG_V_Davis_spr_04 = zeros(1,length(t));

for i = 1:48
% Case 1
    TEG_V_Casey_sum_01(i) = N .* seebeck_Casey_sum_01(i) .* ...
        Casey_sum_temp_diff_01(i);
    TEG_V_Casey_spr_01(i) = N .* seebeck_Casey_spr_01(i) .* ...
        Casey_spr_temp_diff_01(i);
    TEG_V_Davis_sum_01(i) = N .* seebeck_Davis_sum_01(i) .* ...
        Davis_sum_temp_diff_01(i);
    TEG_V_Davis_spr_01(i) = N .* seebeck_Davis_spr_01(i) .* ...
        Davis_spr_temp_diff_01(i);
% Case 2
    TEG_V_Casey_sum_02(i) = N .* seebeck_Casey_sum_02(i) .* ...
        Casey_sum_temp_diff_02(i);
    TEG_V_Casey_spr_02(i) = N .* seebeck_Casey_spr_02(i) .* ...
        Casey_spr_temp_diff_02(i);
    TEG_V_Davis_sum_02(i) = N .* seebeck_Davis_sum_02(i) .* ...
        Davis_sum_temp_diff_02(i);
    TEG_V_Davis_spr_02(i) = N .* seebeck_Davis_spr_02(i) .* ...
        Davis_spr_temp_diff_02(i);
% Case 3
    TEG_V_Casey_sum_03(i) = N .* seebeck_Casey_sum_03(i) .* ...
        Casey_sum_temp_diff_03(i);
    TEG_V_Casey_spr_03(i) = N .* seebeck_Casey_spr_03(i) .* ...
        Casey_spr_temp_diff_03(i);
    TEG_V_Davis_sum_03(i) = N .* seebeck_Davis_sum_03(i) .* ...
        Davis_sum_temp_diff_03(i);
    TEG_V_Davis_spr_03(i) = N .* seebeck_Davis_spr_03(i) .* ...
        Davis_spr_temp_diff_03(i);
% Case 4
    TEG_V_Casey_sum_04(i) = N .* seebeck_Casey_sum_04(i) .* ...
        Casey_sum_temp_diff_04(i);
    TEG_V_Casey_spr_04(i) = N .* seebeck_Casey_spr_04(i) .* ...
        Casey_spr_temp_diff_04(i);
    TEG_V_Davis_sum_04(i) = N .* seebeck_Davis_sum_04(i) .* ...
        Davis_sum_temp_diff_04(i);
    TEG_V_Davis_spr_04(i) = N .* seebeck_Davis_spr_04(i) .* ...
        Davis_spr_temp_diff_04(i);
end

% -- %% -- %% TEG INTERNAL RESISTANCE %% -- %% -- %%

elec_cond_dim_Casey_sum_01 = zeros(1,length(t));
elec_cond_dim_Casey_spr_01 = zeros(1,length(t));
elec_cond_dim_Davis_sum_01 = zeros(1,length(t));
elec_cond_dim_Davis_spr_01 = zeros(1,length(t));

elec_cond_dim_Casey_sum_02 = zeros(1,length(t));
elec_cond_dim_Casey_spr_02 = zeros(1,length(t));
elec_cond_dim_Davis_sum_02 = zeros(1,length(t));
elec_cond_dim_Davis_spr_02 = zeros(1,length(t));

elec_cond_dim_Casey_sum_03 = zeros(1,length(t));
elec_cond_dim_Casey_spr_03 = zeros(1,length(t));
elec_cond_dim_Davis_sum_03 = zeros(1,length(t));
elec_cond_dim_Davis_spr_03 = zeros(1,length(t));

elec_cond_dim_Casey_sum_04 = zeros(1,length(t));
elec_cond_dim_Casey_spr_04 = zeros(1,length(t));
elec_cond_dim_Davis_sum_04 = zeros(1,length(t));
elec_cond_dim_Davis_spr_04 = zeros(1,length(t));


for i = 1:48
% Case 1
    elec_cond_dim_Casey_sum_01(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_01_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_01_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_01(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_01_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_01_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_01(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_01_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_01_K(i))) ...
        + 8.629; 
    elec_cond_dim_Davis_spr_01(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_01_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_01_K(i))) ...
        + 8.629; 
% Case 2
    elec_cond_dim_Casey_sum_02(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_02_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_02_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_02(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_02_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_02_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_02(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_02_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_02_K(i))) ...
        + 8.629; 
    elec_cond_dim_Davis_spr_02(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_02_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_02_K(i))) ...
        + 8.629; 
% Case 3
    elec_cond_dim_Casey_sum_03(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_03_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_03_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_03(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_03_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_03_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_03(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_03_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_03_K(i))) ...
        + 8.629; 
    elec_cond_dim_Davis_spr_03(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_03_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_03_K(i))) ...
        + 8.629; 
% Case 4
    elec_cond_dim_Casey_sum_04(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_04_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_04_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_04(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_04_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_04_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_04(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_04_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_04_K(i))) ...
        + 8.629; 
    elec_cond_dim_Davis_spr_04(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_04_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_04_K(i))) ...
        + 8.629; 
end

% dim * stc = const
% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum_01 = zeros(1,length(t));
elec_cond_Casey_spr_01 = zeros(1,length(t));
elec_cond_Davis_sum_01 = zeros(1,length(t));
elec_cond_Davis_spr_01 = zeros(1,length(t));

elec_cond_Casey_sum_02 = zeros(1,length(t));
elec_cond_Casey_spr_02 = zeros(1,length(t));
elec_cond_Davis_sum_02 = zeros(1,length(t));
elec_cond_Davis_spr_02 = zeros(1,length(t));

elec_cond_Casey_sum_03 = zeros(1,length(t));
elec_cond_Casey_spr_03 = zeros(1,length(t));
elec_cond_Davis_sum_03 = zeros(1,length(t));
elec_cond_Davis_spr_03 = zeros(1,length(t));

elec_cond_Casey_sum_04 = zeros(1,length(t));
elec_cond_Casey_spr_04 = zeros(1,length(t));
elec_cond_Davis_sum_04 = zeros(1,length(t));
elec_cond_Davis_spr_04 = zeros(1,length(t));


for i = 1:48 
% Case 1 
    elec_cond_Casey_sum_01(i) = elec_cond_dim_Casey_sum_01(i) .* elec_cond_stc;
    elec_cond_Casey_spr_01(i) = elec_cond_dim_Casey_spr_01(i) .* elec_cond_stc;
    elec_cond_Davis_sum_01(i) = elec_cond_dim_Davis_sum_01(i) .* elec_cond_stc;
    elec_cond_Davis_spr_01(i) = elec_cond_dim_Davis_spr_01(i) .* elec_cond_stc;
% Case 2 
    elec_cond_Casey_sum_02(i) = elec_cond_dim_Casey_sum_02(i) .* elec_cond_stc;
    elec_cond_Casey_spr_02(i) = elec_cond_dim_Casey_spr_02(i) .* elec_cond_stc;
    elec_cond_Davis_sum_02(i) = elec_cond_dim_Davis_sum_02(i) .* elec_cond_stc;
    elec_cond_Davis_spr_02(i) = elec_cond_dim_Davis_spr_02(i) .* elec_cond_stc;
% Case 3 
    elec_cond_Casey_sum_03(i) = elec_cond_dim_Casey_sum_03(i) .* elec_cond_stc;
    elec_cond_Casey_spr_03(i) = elec_cond_dim_Casey_spr_03(i) .* elec_cond_stc;
    elec_cond_Davis_sum_03(i) = elec_cond_dim_Davis_sum_03(i) .* elec_cond_stc;
    elec_cond_Davis_spr_03(i) = elec_cond_dim_Davis_spr_03(i) .* elec_cond_stc;
% Case 4 
    elec_cond_Casey_sum_04(i) = elec_cond_dim_Casey_sum_04(i) .* elec_cond_stc;
    elec_cond_Casey_spr_04(i) = elec_cond_dim_Casey_spr_04(i) .* elec_cond_stc;
    elec_cond_Davis_sum_04(i) = elec_cond_dim_Davis_sum_04(i) .* elec_cond_stc;
    elec_cond_Davis_spr_04(i) = elec_cond_dim_Davis_spr_04(i) .* elec_cond_stc;
end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)
% need to be very careful - make cosntants where possible 

Casey_sum_R_i_01 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_01 = zeros(1,length(t));
Davis_sum_R_i_01 = zeros(1,length(t));
Davis_spr_R_i_01 = zeros(1,length(t));

Casey_sum_R_i_02 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_02 = zeros(1,length(t));
Davis_sum_R_i_02 = zeros(1,length(t));
Davis_spr_R_i_02 = zeros(1,length(t));

Casey_sum_R_i_03 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_03 = zeros(1,length(t));
Davis_sum_R_i_03 = zeros(1,length(t));
Davis_spr_R_i_03 = zeros(1,length(t));

Casey_sum_R_i_04 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_04 = zeros(1,length(t));
Davis_sum_R_i_04 = zeros(1,length(t));
Davis_spr_R_i_04 = zeros(1,length(t));

for i = 1:48
% Case 1
    Casey_sum_R_i_01(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_01(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_01(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_01(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_01(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_01(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_01(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_01(i) ) + ( (2.*r_con)./ thick) );
% Case 2
    Casey_sum_R_i_02(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_02(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_02(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_02(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_02(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_02(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_02(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_02(i) ) + ( (2.*r_con)./ thick) );
% Case 3
    Casey_sum_R_i_03(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_03(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_03(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_03(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_03(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_03(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_03(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_03(i) ) + ( (2.*r_con)./ thick) );
% Case 4
    Casey_sum_R_i_04(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_04(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_04(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_04(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_04(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_04(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_04(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_04(i) ) + ( (2.*r_con)./ thick) );
end

%----------------------------------------------------------------------------%
    % [20% Clouds]:[Wind = 5,10,25, 50]
 % [20% Clouds]:[Wind = 5,10,25,50]
Casey_sum_mean_temp_05_K = zeros(1,length(t));
Casey_spr_mean_temp_05_K = zeros(1,length(t));
Davis_sum_mean_temp_05_K = zeros(1,length(t));
Davis_spr_mean_temp_05_K = zeros(1,length(t));

Casey_sum_mean_temp_06_K = zeros(1,length(t));
Casey_spr_mean_temp_06_K = zeros(1,length(t));
Davis_sum_mean_temp_06_K = zeros(1,length(t));
Davis_spr_mean_temp_06_K = zeros(1,length(t));

Casey_sum_mean_temp_07_K = zeros(1,length(t));
Casey_spr_mean_temp_07_K = zeros(1,length(t));
Davis_sum_mean_temp_07_K = zeros(1,length(t));
Davis_spr_mean_temp_07_K = zeros(1,length(t));

Casey_sum_mean_temp_08_K = zeros(1,length(t));
Casey_spr_mean_temp_08_K = zeros(1,length(t));
Davis_sum_mean_temp_08_K = zeros(1,length(t));
Davis_spr_mean_temp_08_K = zeros(1,length(t));

for i = 1:48
% Case 5
    Casey_sum_mean_temp_05_K(i) = Casey_sum_mean_temp_05(i) + 273.15;
    Casey_spr_mean_temp_05_K(i) = Casey_spr_mean_temp_05(i) + 273.15;
    Davis_sum_mean_temp_05_K(i) = Davis_sum_mean_temp_05(i) + 273.15;
    Davis_spr_mean_temp_05_K(i) = Davis_spr_mean_temp_05(i) + 273.15;
% Case 6
    Casey_sum_mean_temp_06_K(i) = Casey_sum_mean_temp_06(i) + 273.15;
    Casey_spr_mean_temp_06_K(i) = Casey_spr_mean_temp_06(i) + 273.15;
    Davis_sum_mean_temp_06_K(i) = Davis_sum_mean_temp_06(i) + 273.15;
    Davis_spr_mean_temp_06_K(i) = Davis_spr_mean_temp_06(i) + 273.15;
% Case 7
    Casey_sum_mean_temp_07_K(i) = Casey_sum_mean_temp_07(i) + 273.15;
    Casey_spr_mean_temp_07_K(i) = Casey_spr_mean_temp_07(i) + 273.15;
    Davis_sum_mean_temp_07_K(i) = Davis_sum_mean_temp_07(i) + 273.15;
    Davis_spr_mean_temp_07_K(i) = Davis_spr_mean_temp_07(i) + 273.15;
% Case 8
    Casey_sum_mean_temp_08_K(i) = Casey_sum_mean_temp_08(i) + 273.15;
    Casey_spr_mean_temp_08_K(i) = Casey_spr_mean_temp_08(i) + 273.15;
    Davis_sum_mean_temp_08_K(i) = Davis_sum_mean_temp_08(i) + 273.15;
    Davis_spr_mean_temp_08_K(i) = Davis_spr_mean_temp_08(i) + 273.15;
end
% Celsius 2 Kelvin!!
seebeck_dim_Casey_sum_05 = zeros(1,length(t));
seebeck_dim_Casey_spr_05 = zeros(1,length(t));
seebeck_dim_Davis_sum_05 = zeros(1,length(t));
seebeck_dim_Davis_spr_05 = zeros(1,length(t));

seebeck_dim_Casey_sum_06 = zeros(1,length(t));
seebeck_dim_Casey_spr_06 = zeros(1,length(t));
seebeck_dim_Davis_sum_06 = zeros(1,length(t));
seebeck_dim_Davis_spr_06 = zeros(1,length(t));

seebeck_dim_Casey_sum_07 = zeros(1,length(t));
seebeck_dim_Casey_spr_07 = zeros(1,length(t));
seebeck_dim_Davis_sum_07 = zeros(1,length(t));
seebeck_dim_Davis_spr_07 = zeros(1,length(t));

seebeck_dim_Casey_sum_08 = zeros(1,length(t));
seebeck_dim_Casey_spr_08 = zeros(1,length(t));
seebeck_dim_Davis_sum_08 = zeros(1,length(t));
seebeck_dim_Davis_spr_08 = zeros(1,length(t));

for i = 1:48
% Case 5
    seebeck_dim_Casey_sum_05(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_05_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_05_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_05(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_05_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_05_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_05(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_05_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_05_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_05(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_05_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_05_K(i))) ...
    - 0.582;
% Case 6
    seebeck_dim_Casey_sum_06(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_06_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_06_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_06(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_06_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_06_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_06(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_06_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_06_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_06(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_06_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_06_K(i))) ...
    - 0.582;
% Case 7
    seebeck_dim_Casey_sum_07(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_07_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_07_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_07(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_07_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_07_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_07(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_07_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_07_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_07(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_07_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_07_K(i))) ...
    - 0.582;
% Case 8
    seebeck_dim_Casey_sum_08(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_08_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_08_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_08(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_08_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_08_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_08(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_08_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_08_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_08(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_08_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_08_K(i))) ...
    - 0.582;
end
% dim*stc = seebeck
seebeck_Casey_sum_05 = zeros(1,length(t));
seebeck_Casey_spr_05 = zeros(1,length(t));
seebeck_Davis_sum_05 = zeros(1,length(t));
seebeck_Davis_spr_05 = zeros(1,length(t));

seebeck_Casey_sum_06 = zeros(1,length(t));
seebeck_Casey_spr_06 = zeros(1,length(t));
seebeck_Davis_sum_06 = zeros(1,length(t));
seebeck_Davis_spr_06 = zeros(1,length(t));

seebeck_Casey_sum_07 = zeros(1,length(t));
seebeck_Casey_spr_07 = zeros(1,length(t));
seebeck_Davis_sum_07 = zeros(1,length(t));
seebeck_Davis_spr_07 = zeros(1,length(t));

seebeck_Casey_sum_08 = zeros(1,length(t));
seebeck_Casey_spr_08 = zeros(1,length(t));
seebeck_Davis_sum_08 = zeros(1,length(t));
seebeck_Davis_spr_08 = zeros(1,length(t));

for i = 1:48 
% Case 5
    seebeck_Casey_sum_05(i) = seebeck_dim_Casey_sum_05(i).*seebeck_stc;
    seebeck_Casey_spr_05(i) = seebeck_dim_Casey_spr_05(i).*seebeck_stc;
    seebeck_Davis_sum_05(i) = seebeck_dim_Davis_sum_05(i).*seebeck_stc;
    seebeck_Davis_spr_05(i) = seebeck_dim_Davis_spr_05(i).*seebeck_stc;
% Case 6
    seebeck_Casey_sum_06(i) = seebeck_dim_Casey_sum_06(i).*seebeck_stc;
    seebeck_Casey_spr_06(i) = seebeck_dim_Casey_spr_06(i).*seebeck_stc;
    seebeck_Davis_sum_06(i) = seebeck_dim_Davis_sum_06(i).*seebeck_stc;
    seebeck_Davis_spr_06(i) = seebeck_dim_Davis_spr_06(i).*seebeck_stc;
% Case 7
    seebeck_Casey_sum_07(i) = seebeck_dim_Casey_sum_07(i).*seebeck_stc;
    seebeck_Casey_spr_07(i) = seebeck_dim_Casey_spr_07(i).*seebeck_stc;
    seebeck_Davis_sum_07(i) = seebeck_dim_Davis_sum_07(i).*seebeck_stc;
    seebeck_Davis_spr_07(i) = seebeck_dim_Davis_spr_07(i).*seebeck_stc;
% Case 8
    seebeck_Casey_sum_08(i) = seebeck_dim_Casey_sum_08(i).*seebeck_stc;
    seebeck_Casey_spr_08(i) = seebeck_dim_Casey_spr_08(i).*seebeck_stc;
    seebeck_Davis_sum_08(i) = seebeck_dim_Davis_sum_08(i).*seebeck_stc;
    seebeck_Davis_spr_08(i) = seebeck_dim_Davis_spr_08(i).*seebeck_stc;
end
% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum_05 = zeros(1,length(t));
TEG_V_Casey_spr_05 = zeros(1,length(t));
TEG_V_Davis_sum_05 = zeros(1,length(t));
TEG_V_Davis_spr_05 = zeros(1,length(t));

TEG_V_Casey_sum_06 = zeros(1,length(t));
TEG_V_Casey_spr_06 = zeros(1,length(t));
TEG_V_Davis_sum_06 = zeros(1,length(t));
TEG_V_Davis_spr_06 = zeros(1,length(t));

TEG_V_Casey_sum_07 = zeros(1,length(t));
TEG_V_Casey_spr_07 = zeros(1,length(t));
TEG_V_Davis_sum_07 = zeros(1,length(t));
TEG_V_Davis_spr_07 = zeros(1,length(t));

TEG_V_Casey_sum_08 = zeros(1,length(t));
TEG_V_Casey_spr_08 = zeros(1,length(t));
TEG_V_Davis_sum_08 = zeros(1,length(t));
TEG_V_Davis_spr_08 = zeros(1,length(t));

for i = 1:48
% Case 5
    TEG_V_Casey_sum_05(i) = N .* seebeck_Casey_sum_05(i) .* ...
        Casey_sum_temp_diff_05(i);
    TEG_V_Casey_spr_05(i) = N .* seebeck_Casey_spr_05(i) .* ...
        Casey_spr_temp_diff_05(i);
    TEG_V_Davis_sum_05(i) = N .* seebeck_Davis_sum_05(i) .* ...
        Davis_sum_temp_diff_05(i);
    TEG_V_Davis_spr_05(i) = N .* seebeck_Davis_spr_05(i) .* ...
        Davis_spr_temp_diff_05(i);
% Case 6
    TEG_V_Casey_sum_06(i) = N .* seebeck_Casey_sum_06(i) .* ...
        Casey_sum_temp_diff_06(i);
    TEG_V_Casey_spr_06(i) = N .* seebeck_Casey_spr_06(i) .* ...
        Casey_spr_temp_diff_06(i);
    TEG_V_Davis_sum_06(i) = N .* seebeck_Davis_sum_06(i) .* ...
        Davis_sum_temp_diff_06(i);
    TEG_V_Davis_spr_06(i) = N .* seebeck_Davis_spr_06(i) .* ...
        Davis_spr_temp_diff_06(i);
% Case 7
    TEG_V_Casey_sum_07(i) = N .* seebeck_Casey_sum_07(i) .* ...
        Casey_sum_temp_diff_07(i);
    TEG_V_Casey_spr_07(i) = N .* seebeck_Casey_spr_07(i) .* ...
        Casey_spr_temp_diff_07(i);
    TEG_V_Davis_sum_07(i) = N .* seebeck_Davis_sum_07(i) .* ...
        Davis_sum_temp_diff_07(i);
    TEG_V_Davis_spr_07(i) = N .* seebeck_Davis_spr_07(i) .* ...
        Davis_spr_temp_diff_07(i);
% Case 8
    TEG_V_Casey_sum_08(i) = N .* seebeck_Casey_sum_08(i) .* ...
        Casey_sum_temp_diff_08(i);
    TEG_V_Casey_spr_08(i) = N .* seebeck_Casey_spr_08(i) .* ...
        Casey_spr_temp_diff_08(i);
    TEG_V_Davis_sum_08(i) = N .* seebeck_Davis_sum_08(i) .* ...
        Davis_sum_temp_diff_08(i);
    TEG_V_Davis_spr_08(i) = N .* seebeck_Davis_spr_08(i) .* ...
        Davis_spr_temp_diff_08(i);
end
% -- %% -- %% TEG INTERNAL RESISTANCE %% -- %% -- %%
elec_cond_dim_Casey_sum_05 = zeros(1,length(t));
elec_cond_dim_Casey_spr_05 = zeros(1,length(t));
elec_cond_dim_Davis_sum_05 = zeros(1,length(t));
elec_cond_dim_Davis_spr_05 = zeros(1,length(t));

elec_cond_dim_Casey_sum_06 = zeros(1,length(t));
elec_cond_dim_Casey_spr_06 = zeros(1,length(t));
elec_cond_dim_Davis_sum_06 = zeros(1,length(t));
elec_cond_dim_Davis_spr_06 = zeros(1,length(t));

elec_cond_dim_Casey_sum_07 = zeros(1,length(t));
elec_cond_dim_Casey_spr_07 = zeros(1,length(t));
elec_cond_dim_Davis_sum_07 = zeros(1,length(t));
elec_cond_dim_Davis_spr_07 = zeros(1,length(t));

elec_cond_dim_Casey_sum_08 = zeros(1,length(t));
elec_cond_dim_Casey_spr_08 = zeros(1,length(t));
elec_cond_dim_Davis_sum_08 = zeros(1,length(t));
elec_cond_dim_Davis_spr_08 = zeros(1,length(t));

for i = 1:48
% Case 5
    elec_cond_dim_Casey_sum_05(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_05_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_05_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_05(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_05_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_05_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_05(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_05_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_05_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_05(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_05_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_05_K(i))) ...
        + 8.629;
% Case 6
    elec_cond_dim_Casey_sum_06(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_06_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_06_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_06(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_06_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_06_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_06(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_06_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_06_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_06(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_06_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_06_K(i))) ...
        + 8.629;
% Case 7
    elec_cond_dim_Casey_sum_07(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_07_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_07_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_07(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_07_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_07_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_07(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_07_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_07_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_07(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_07_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_07_K(i))) ...
        + 8.629;
% Case 8
    elec_cond_dim_Casey_sum_08(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_08_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_08_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_08(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_08_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_08_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_08(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_08_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_08_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Davis_spr_08(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_08_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_08_K(i)) ) ...
        + 8.629;
end

% dim * stc = const

% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum_05 = zeros(1,length(t));
elec_cond_Casey_spr_05 = zeros(1,length(t));
elec_cond_Davis_sum_05 = zeros(1,length(t));
elec_cond_Davis_spr_05 = zeros(1,length(t));

elec_cond_Casey_sum_06 = zeros(1,length(t));
elec_cond_Casey_spr_06 = zeros(1,length(t));
elec_cond_Davis_sum_06 = zeros(1,length(t));
elec_cond_Davis_spr_06 = zeros(1,length(t));

elec_cond_Casey_sum_07 = zeros(1,length(t));
elec_cond_Casey_spr_07 = zeros(1,length(t));
elec_cond_Davis_sum_07 = zeros(1,length(t));
elec_cond_Davis_spr_07 = zeros(1,length(t));

elec_cond_Casey_sum_08 = zeros(1,length(t));
elec_cond_Casey_spr_08 = zeros(1,length(t));
elec_cond_Davis_sum_08 = zeros(1,length(t));
elec_cond_Davis_spr_08 = zeros(1,length(t));

for i = 1:48
% Case 5
    elec_cond_Casey_sum_05(i) = elec_cond_dim_Casey_sum_05(i) .* elec_cond_stc;
    elec_cond_Casey_spr_05(i) = elec_cond_dim_Casey_spr_05(i) .* elec_cond_stc;
    elec_cond_Davis_sum_05(i) = elec_cond_dim_Davis_sum_05(i) .* elec_cond_stc;
    elec_cond_Davis_spr_05(i) = elec_cond_dim_Davis_spr_05(i) .* elec_cond_stc;
% Case 6
    elec_cond_Casey_sum_06(i) = elec_cond_dim_Casey_sum_06(i) .* elec_cond_stc;
    elec_cond_Casey_spr_06(i) = elec_cond_dim_Casey_spr_06(i) .* elec_cond_stc;
    elec_cond_Davis_sum_06(i) = elec_cond_dim_Davis_sum_06(i) .* elec_cond_stc;
    elec_cond_Davis_spr_06(i) = elec_cond_dim_Davis_spr_06(i) .* elec_cond_stc;
% Case 7
    elec_cond_Casey_sum_07(i) = elec_cond_dim_Casey_sum_07(i) .* elec_cond_stc;
    elec_cond_Casey_spr_07(i) = elec_cond_dim_Casey_spr_07(i) .* elec_cond_stc;
    elec_cond_Davis_sum_07(i) = elec_cond_dim_Davis_sum_07(i) .* elec_cond_stc;
    elec_cond_Davis_spr_07(i) = elec_cond_dim_Davis_spr_07(i) .* elec_cond_stc;

% Case 8
    elec_cond_Casey_sum_08(i) = elec_cond_dim_Casey_sum_08(i) .* elec_cond_stc;
    elec_cond_Casey_spr_08(i) = elec_cond_dim_Casey_spr_08(i) .* elec_cond_stc;
    elec_cond_Davis_sum_08(i) = elec_cond_dim_Davis_sum_08(i) .* elec_cond_stc;
    elec_cond_Davis_spr_08(i) = elec_cond_dim_Davis_spr_08(i) .* elec_cond_stc;

end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)

% need to be very careful - make cosntants where possible

Casey_sum_R_i_05 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_05 = zeros(1,length(t));
Davis_sum_R_i_05 = zeros(1,length(t));
Davis_spr_R_i_05 = zeros(1,length(t));

Casey_sum_R_i_06 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_06 = zeros(1,length(t));
Davis_sum_R_i_06 = zeros(1,length(t));
Davis_spr_R_i_06 = zeros(1,length(t));

Casey_sum_R_i_07 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_07 = zeros(1,length(t));
Davis_sum_R_i_07 = zeros(1,length(t));
Davis_spr_R_i_07 = zeros(1,length(t));

Casey_sum_R_i_08 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_08 = zeros(1,length(t));
Davis_sum_R_i_08 = zeros(1,length(t));
Davis_spr_R_i_08 = zeros(1,length(t));

for i = 1:48
% Case 5
    Casey_sum_R_i_05(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_05(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_05(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_05(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_05(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_05(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_05(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_05(i) ) + ( (2.*r_con)./ thick) );
% Case 6
    Casey_sum_R_i_06(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_06(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_06(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_06(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_06(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_06(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_06(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_06(i) ) + ( (2.*r_con)./ thick) );

% Case 7
    Casey_sum_R_i_07(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_07(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_07(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_07(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_07(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_07(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_07(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_07(i) ) + ( (2.*r_con)./ thick) );

% Case 8

    Casey_sum_R_i_08(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_08(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_08(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_08(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_08(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_08(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_08(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_08(i) ) + ( (2.*r_con)./ thick) );

end

%----------------------------------------------------------------------------%    
    % [40% Clouds]:[Wind = 5,10,25,50]
 % [40% Clouds]:[Wind = 5,10,25,50]
Casey_sum_mean_temp_09_K = zeros(1,length(t));
Casey_spr_mean_temp_09_K = zeros(1,length(t));
Davis_sum_mean_temp_09_K = zeros(1,length(t));
Davis_spr_mean_temp_09_K = zeros(1,length(t));

Casey_sum_mean_temp_10_K = zeros(1,length(t));
Casey_spr_mean_temp_10_K = zeros(1,length(t));
Davis_sum_mean_temp_10_K = zeros(1,length(t));
Davis_spr_mean_temp_10_K = zeros(1,length(t));

Casey_sum_mean_temp_11_K = zeros(1,length(t));
Casey_spr_mean_temp_11_K = zeros(1,length(t));
Davis_sum_mean_temp_11_K = zeros(1,length(t));
Davis_spr_mean_temp_11_K = zeros(1,length(t));

Casey_sum_mean_temp_12_K = zeros(1,length(t));
Casey_spr_mean_temp_12_K = zeros(1,length(t));
Davis_sum_mean_temp_12_K = zeros(1,length(t));
Davis_spr_mean_temp_12_K = zeros(1,length(t));

for i = 1:48
% Case 5
    Casey_sum_mean_temp_09_K(i) = Casey_sum_mean_temp_09(i) + 273.15;
    Casey_spr_mean_temp_09_K(i) = Casey_spr_mean_temp_09(i) + 273.15;
    Davis_sum_mean_temp_09_K(i) = Davis_sum_mean_temp_09(i) + 273.15;
    Davis_spr_mean_temp_09_K(i) = Davis_spr_mean_temp_09(i) + 273.15;
% Case 6
    Casey_sum_mean_temp_10_K(i) = Casey_sum_mean_temp_10(i) + 273.15;
    Casey_spr_mean_temp_10_K(i) = Casey_spr_mean_temp_10(i) + 273.15;
    Davis_sum_mean_temp_10_K(i) = Davis_sum_mean_temp_10(i) + 273.15;
    Davis_spr_mean_temp_10_K(i) = Davis_spr_mean_temp_10(i) + 273.15;
% Case 7
    Casey_sum_mean_temp_11_K(i) = Casey_sum_mean_temp_11(i) + 273.15;
    Casey_spr_mean_temp_11_K(i) = Casey_spr_mean_temp_11(i) + 273.15;
    Davis_sum_mean_temp_11_K(i) = Davis_sum_mean_temp_11(i) + 273.15;
    Davis_spr_mean_temp_11_K(i) = Davis_spr_mean_temp_11(i) + 273.15;
% Case 8
    Casey_sum_mean_temp_12_K(i) = Casey_sum_mean_temp_12(i) + 273.15;
    Casey_spr_mean_temp_12_K(i) = Casey_spr_mean_temp_12(i) + 273.15;
    Davis_sum_mean_temp_12_K(i) = Davis_sum_mean_temp_12(i) + 273.15;
    Davis_spr_mean_temp_12_K(i) = Davis_spr_mean_temp_12(i) + 273.15;
end
% Celsius 2 Kelvin!!
seebeck_dim_Casey_sum_09 = zeros(1,length(t));
seebeck_dim_Casey_spr_09 = zeros(1,length(t));
seebeck_dim_Davis_sum_09 = zeros(1,length(t));
seebeck_dim_Davis_spr_09 = zeros(1,length(t));

seebeck_dim_Casey_sum_10 = zeros(1,length(t));
seebeck_dim_Casey_spr_10 = zeros(1,length(t));
seebeck_dim_Davis_sum_10 = zeros(1,length(t));
seebeck_dim_Davis_spr_10 = zeros(1,length(t));

seebeck_dim_Casey_sum_11 = zeros(1,length(t));
seebeck_dim_Casey_spr_11 = zeros(1,length(t));
seebeck_dim_Davis_sum_11 = zeros(1,length(t));
seebeck_dim_Davis_spr_11 = zeros(1,length(t));

seebeck_dim_Casey_sum_12 = zeros(1,length(t));
seebeck_dim_Casey_spr_12 = zeros(1,length(t));
seebeck_dim_Davis_sum_12 = zeros(1,length(t));
seebeck_dim_Davis_spr_12 = zeros(1,length(t));

for i = 1:48
% Case 9
    seebeck_dim_Casey_sum_09(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_09_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_09_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_09(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_09_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_09_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_09(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_09_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_09_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_09(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_09_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_09_K(i))) ...
    - 0.582;
% Case 6
    seebeck_dim_Casey_sum_10(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_10_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_10_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_10(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_10_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_10_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_10(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_10_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_10_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_10(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_10_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_10_K(i))) ...
    - 0.582;
% Case 7
    seebeck_dim_Casey_sum_11(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_11_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_11_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_11(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_11_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_11_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_11(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_11_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_11_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_11(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_11_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_11_K(i))) ...
    - 0.582;
% Case 8
    seebeck_dim_Casey_sum_12(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_12_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_12_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_12(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_12_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_12_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_12(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_12_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_12_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_12(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_12_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_12_K(i))) ...
    - 0.582;
end
% dim*stc = seebeck
seebeck_Casey_sum_09 = zeros(1,length(t));
seebeck_Casey_spr_09 = zeros(1,length(t));
seebeck_Davis_sum_09 = zeros(1,length(t));
seebeck_Davis_spr_09 = zeros(1,length(t));

seebeck_Casey_sum_10 = zeros(1,length(t));
seebeck_Casey_spr_10 = zeros(1,length(t));
seebeck_Davis_sum_10 = zeros(1,length(t));
seebeck_Davis_spr_10 = zeros(1,length(t));

seebeck_Casey_sum_11 = zeros(1,length(t));
seebeck_Casey_spr_11 = zeros(1,length(t));
seebeck_Davis_sum_11 = zeros(1,length(t));
seebeck_Davis_spr_11 = zeros(1,length(t));

seebeck_Casey_sum_12 = zeros(1,length(t));
seebeck_Casey_spr_12 = zeros(1,length(t));
seebeck_Davis_sum_12 = zeros(1,length(t));
seebeck_Davis_spr_12 = zeros(1,length(t));

for i = 1:48 
% Case 9
    seebeck_Casey_sum_09(i) = seebeck_dim_Casey_sum_09(i).*seebeck_stc;
    seebeck_Casey_spr_09(i) = seebeck_dim_Casey_spr_09(i).*seebeck_stc;
    seebeck_Davis_sum_09(i) = seebeck_dim_Davis_sum_09(i).*seebeck_stc;
    seebeck_Davis_spr_09(i) = seebeck_dim_Davis_spr_09(i).*seebeck_stc;
% Case 6
    seebeck_Casey_sum_10(i) = seebeck_dim_Casey_sum_10(i).*seebeck_stc;
    seebeck_Casey_spr_10(i) = seebeck_dim_Casey_spr_10(i).*seebeck_stc;
    seebeck_Davis_sum_10(i) = seebeck_dim_Davis_sum_10(i).*seebeck_stc;
    seebeck_Davis_spr_10(i) = seebeck_dim_Davis_spr_10(i).*seebeck_stc;
% Case 7
    seebeck_Casey_sum_11(i) = seebeck_dim_Casey_sum_11(i).*seebeck_stc;
    seebeck_Casey_spr_11(i) = seebeck_dim_Casey_spr_11(i).*seebeck_stc;
    seebeck_Davis_sum_11(i) = seebeck_dim_Davis_sum_11(i).*seebeck_stc;
    seebeck_Davis_spr_11(i) = seebeck_dim_Davis_spr_11(i).*seebeck_stc;
% Case 8
    seebeck_Casey_sum_12(i) = seebeck_dim_Casey_sum_12(i).*seebeck_stc;
    seebeck_Casey_spr_12(i) = seebeck_dim_Casey_spr_12(i).*seebeck_stc;
    seebeck_Davis_sum_12(i) = seebeck_dim_Davis_sum_12(i).*seebeck_stc;
    seebeck_Davis_spr_12(i) = seebeck_dim_Davis_spr_12(i).*seebeck_stc;
end
% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum_09 = zeros(1,length(t));
TEG_V_Casey_spr_09 = zeros(1,length(t));
TEG_V_Davis_sum_09 = zeros(1,length(t));
TEG_V_Davis_spr_09 = zeros(1,length(t));

TEG_V_Casey_sum_10 = zeros(1,length(t));
TEG_V_Casey_spr_10 = zeros(1,length(t));
TEG_V_Davis_sum_10 = zeros(1,length(t));
TEG_V_Davis_spr_10 = zeros(1,length(t));

TEG_V_Casey_sum_11 = zeros(1,length(t));
TEG_V_Casey_spr_11 = zeros(1,length(t));
TEG_V_Davis_sum_11 = zeros(1,length(t));
TEG_V_Davis_spr_11 = zeros(1,length(t));

TEG_V_Casey_sum_12 = zeros(1,length(t));
TEG_V_Casey_spr_12 = zeros(1,length(t));
TEG_V_Davis_sum_12 = zeros(1,length(t));
TEG_V_Davis_spr_12 = zeros(1,length(t));

for i = 1:48
% Case 9
    TEG_V_Casey_sum_09(i) = N .* seebeck_Casey_sum_09(i) .* ...
        Casey_sum_temp_diff_09(i);
    TEG_V_Casey_spr_09(i) = N .* seebeck_Casey_spr_09(i) .* ...
        Casey_spr_temp_diff_09(i);
    TEG_V_Davis_sum_09(i) = N .* seebeck_Davis_sum_09(i) .* ...
        Davis_sum_temp_diff_09(i);
    TEG_V_Davis_spr_09(i) = N .* seebeck_Davis_spr_09(i) .* ...
        Davis_spr_temp_diff_09(i);
% Case 6
    TEG_V_Casey_sum_10(i) = N .* seebeck_Casey_sum_10(i) .* ...
        Casey_sum_temp_diff_10(i);
    TEG_V_Casey_spr_10(i) = N .* seebeck_Casey_spr_10(i) .* ...
        Casey_spr_temp_diff_10(i);
    TEG_V_Davis_sum_10(i) = N .* seebeck_Davis_sum_10(i) .* ...
        Davis_sum_temp_diff_10(i);
    TEG_V_Davis_spr_10(i) = N .* seebeck_Davis_spr_10(i) .* ...
        Davis_spr_temp_diff_10(i);
% Case 7
    TEG_V_Casey_sum_11(i) = N .* seebeck_Casey_sum_11(i) .* ...
        Casey_sum_temp_diff_11(i);
    TEG_V_Casey_spr_11(i) = N .* seebeck_Casey_spr_11(i) .* ...
        Casey_spr_temp_diff_11(i);
    TEG_V_Davis_sum_11(i) = N .* seebeck_Davis_sum_11(i) .* ...
        Davis_sum_temp_diff_11(i);
    TEG_V_Davis_spr_11(i) = N .* seebeck_Davis_spr_11(i) .* ...
        Davis_spr_temp_diff_11(i);
% Case 8
    TEG_V_Casey_sum_12(i) = N .* seebeck_Casey_sum_12(i) .* ...
        Casey_sum_temp_diff_12(i);
    TEG_V_Casey_spr_12(i) = N .* seebeck_Casey_spr_12(i) .* ...
        Casey_spr_temp_diff_12(i);
    TEG_V_Davis_sum_12(i) = N .* seebeck_Davis_sum_12(i) .* ...
        Davis_sum_temp_diff_12(i);
    TEG_V_Davis_spr_12(i) = N .* seebeck_Davis_spr_12(i) .* ...
        Davis_spr_temp_diff_12(i);
end
% -- %% -- %% TEG INTERNAL RESISTANCE %% -- %% -- %%
elec_cond_dim_Casey_sum_09 = zeros(1,length(t));
elec_cond_dim_Casey_spr_09 = zeros(1,length(t));
elec_cond_dim_Davis_sum_09 = zeros(1,length(t));
elec_cond_dim_Davis_spr_09 = zeros(1,length(t));

elec_cond_dim_Casey_sum_10 = zeros(1,length(t));
elec_cond_dim_Casey_spr_10 = zeros(1,length(t));
elec_cond_dim_Davis_sum_10 = zeros(1,length(t));
elec_cond_dim_Davis_spr_10 = zeros(1,length(t));

elec_cond_dim_Casey_sum_11 = zeros(1,length(t));
elec_cond_dim_Casey_spr_11 = zeros(1,length(t));
elec_cond_dim_Davis_sum_11 = zeros(1,length(t));
elec_cond_dim_Davis_spr_11 = zeros(1,length(t));

elec_cond_dim_Casey_sum_12 = zeros(1,length(t));
elec_cond_dim_Casey_spr_12 = zeros(1,length(t));
elec_cond_dim_Davis_sum_12 = zeros(1,length(t));
elec_cond_dim_Davis_spr_12 = zeros(1,length(t));

for i = 1:48
% Case 9
    elec_cond_dim_Casey_sum_09(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_09_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_09_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_09(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_09_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_09_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_09(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_09_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_09_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_09(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_09_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_09_K(i))) ...
        + 8.629;
% Case 6
    elec_cond_dim_Casey_sum_10(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_10_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_10_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_10(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_10_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_10_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_10(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_10_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_10_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_10(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_10_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_10_K(i))) ...
        + 8.629;
% Case 7
    elec_cond_dim_Casey_sum_11(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_11_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_11_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_11(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_11_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_11_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_11(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_11_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_11_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_11(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_11_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_11_K(i))) ...
        + 8.629;
% Case 8
    elec_cond_dim_Casey_sum_12(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_12_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_12_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_12(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_12_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_12_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_12(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_12_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_12_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Davis_spr_12(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_12_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_12_K(i)) ) ...
        + 8.629;
end

% dim * stc = const

% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum_09 = zeros(1,length(t));
elec_cond_Casey_spr_09 = zeros(1,length(t));
elec_cond_Davis_sum_09 = zeros(1,length(t));
elec_cond_Davis_spr_09 = zeros(1,length(t));

elec_cond_Casey_sum_10 = zeros(1,length(t));
elec_cond_Casey_spr_10 = zeros(1,length(t));
elec_cond_Davis_sum_10 = zeros(1,length(t));
elec_cond_Davis_spr_10 = zeros(1,length(t));

elec_cond_Casey_sum_11 = zeros(1,length(t));
elec_cond_Casey_spr_11 = zeros(1,length(t));
elec_cond_Davis_sum_11 = zeros(1,length(t));
elec_cond_Davis_spr_11 = zeros(1,length(t));

elec_cond_Casey_sum_12 = zeros(1,length(t));
elec_cond_Casey_spr_12 = zeros(1,length(t));
elec_cond_Davis_sum_12 = zeros(1,length(t));
elec_cond_Davis_spr_12 = zeros(1,length(t));

for i = 1:48
% Case 5
    elec_cond_Casey_sum_09(i) = elec_cond_dim_Casey_sum_09(i) .* elec_cond_stc;
    elec_cond_Casey_spr_09(i) = elec_cond_dim_Casey_spr_09(i) .* elec_cond_stc;
    elec_cond_Davis_sum_09(i) = elec_cond_dim_Davis_sum_09(i) .* elec_cond_stc;
    elec_cond_Davis_spr_09(i) = elec_cond_dim_Davis_spr_09(i) .* elec_cond_stc;
% Case 6
    elec_cond_Casey_sum_10(i) = elec_cond_dim_Casey_sum_10(i) .* elec_cond_stc;
    elec_cond_Casey_spr_10(i) = elec_cond_dim_Casey_spr_10(i) .* elec_cond_stc;
    elec_cond_Davis_sum_10(i) = elec_cond_dim_Davis_sum_10(i) .* elec_cond_stc;
    elec_cond_Davis_spr_10(i) = elec_cond_dim_Davis_spr_10(i) .* elec_cond_stc;
% Case 7
    elec_cond_Casey_sum_11(i) = elec_cond_dim_Casey_sum_11(i) .* elec_cond_stc;
    elec_cond_Casey_spr_11(i) = elec_cond_dim_Casey_spr_11(i) .* elec_cond_stc;
    elec_cond_Davis_sum_11(i) = elec_cond_dim_Davis_sum_11(i) .* elec_cond_stc;
    elec_cond_Davis_spr_11(i) = elec_cond_dim_Davis_spr_11(i) .* elec_cond_stc;

% Case 8
    elec_cond_Casey_sum_12(i) = elec_cond_dim_Casey_sum_12(i) .* elec_cond_stc;
    elec_cond_Casey_spr_12(i) = elec_cond_dim_Casey_spr_12(i) .* elec_cond_stc;
    elec_cond_Davis_sum_12(i) = elec_cond_dim_Davis_sum_12(i) .* elec_cond_stc;
    elec_cond_Davis_spr_12(i) = elec_cond_dim_Davis_spr_12(i) .* elec_cond_stc;

end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)

% need to be very careful - make cosntants where possible

Casey_sum_R_i_09 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_09 = zeros(1,length(t));
Davis_sum_R_i_09 = zeros(1,length(t));
Davis_spr_R_i_09 = zeros(1,length(t));

Casey_sum_R_i_10 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_10 = zeros(1,length(t));
Davis_sum_R_i_10 = zeros(1,length(t));
Davis_spr_R_i_10 = zeros(1,length(t));

Casey_sum_R_i_11 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_11 = zeros(1,length(t));
Davis_sum_R_i_11 = zeros(1,length(t));
Davis_spr_R_i_11 = zeros(1,length(t));

Casey_sum_R_i_12 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_12 = zeros(1,length(t));
Davis_sum_R_i_12 = zeros(1,length(t));
Davis_spr_R_i_12 = zeros(1,length(t));

for i = 1:48
% Case 5
    Casey_sum_R_i_09(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_09(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_09(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_09(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_09(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_09(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_09(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_09(i) ) + ( (2.*r_con)./ thick) );
% Case 6
    Casey_sum_R_i_10(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_10(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_10(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_10(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_10(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_10(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_10(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_10(i) ) + ( (2.*r_con)./ thick) );

% Case 7
    Casey_sum_R_i_11(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_11(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_11(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_11(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_11(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_11(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_11(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_11(i) ) + ( (2.*r_con)./ thick) );

% Case 8

    Casey_sum_R_i_12(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_12(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_12(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_12(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_12(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_12(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_12(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_12(i) ) + ( (2.*r_con)./ thick) );

end

%-------------------------------------------------------------------------------------------------------------------------------------------%
    % [60% Clouds]:[Wind = 5,10,25,50]
    % [60% Clouds]:[13:16
Casey_sum_mean_temp_13_K = zeros(1,length(t));
Casey_spr_mean_temp_13_K = zeros(1,length(t));
Davis_sum_mean_temp_13_K = zeros(1,length(t));
Davis_spr_mean_temp_13_K = zeros(1,length(t));

Casey_sum_mean_temp_14_K = zeros(1,length(t));
Casey_spr_mean_temp_14_K = zeros(1,length(t));
Davis_sum_mean_temp_14_K = zeros(1,length(t));
Davis_spr_mean_temp_14_K = zeros(1,length(t));

Casey_sum_mean_temp_15_K = zeros(1,length(t));
Casey_spr_mean_temp_15_K = zeros(1,length(t));
Davis_sum_mean_temp_15_K = zeros(1,length(t));
Davis_spr_mean_temp_15_K = zeros(1,length(t));

Casey_sum_mean_temp_16_K = zeros(1,length(t));
Casey_spr_mean_temp_16_K = zeros(1,length(t));
Davis_sum_mean_temp_16_K = zeros(1,length(t));
Davis_spr_mean_temp_16_K = zeros(1,length(t));

for i = 1:48
% Case 13
    Casey_sum_mean_temp_13_K(i) = Casey_sum_mean_temp_13(i) + 273.15;
    Casey_spr_mean_temp_13_K(i) = Casey_spr_mean_temp_13(i) + 273.15;
    Davis_sum_mean_temp_13_K(i) = Davis_sum_mean_temp_13(i) + 273.15;
    Davis_spr_mean_temp_13_K(i) = Davis_spr_mean_temp_13(i) + 273.15;
% Case 14
    Casey_sum_mean_temp_14_K(i) = Casey_sum_mean_temp_14(i) + 273.15;
    Casey_spr_mean_temp_14_K(i) = Casey_spr_mean_temp_14(i) + 273.15;
    Davis_sum_mean_temp_14_K(i) = Davis_sum_mean_temp_14(i) + 273.15;
    Davis_spr_mean_temp_14_K(i) = Davis_spr_mean_temp_14(i) + 273.15;
% Case 15
    Casey_sum_mean_temp_15_K(i) = Casey_sum_mean_temp_15(i) + 273.15;
    Casey_spr_mean_temp_15_K(i) = Casey_spr_mean_temp_15(i) + 273.15;
    Davis_sum_mean_temp_15_K(i) = Davis_sum_mean_temp_15(i) + 273.15;
    Davis_spr_mean_temp_15_K(i) = Davis_spr_mean_temp_15(i) + 273.15;
% Case 16
    Casey_sum_mean_temp_16_K(i) = Casey_sum_mean_temp_16(i) + 273.15;
    Casey_spr_mean_temp_16_K(i) = Casey_spr_mean_temp_16(i) + 273.15;
    Davis_sum_mean_temp_16_K(i) = Davis_sum_mean_temp_16(i) + 273.15;
    Davis_spr_mean_temp_16_K(i) = Davis_spr_mean_temp_16(i) + 273.15;
end
% Celsius 2 Kelvin!!
seebeck_dim_Casey_sum_13 = zeros(1,length(t));
seebeck_dim_Casey_spr_13 = zeros(1,length(t));
seebeck_dim_Davis_sum_13 = zeros(1,length(t));
seebeck_dim_Davis_spr_13 = zeros(1,length(t));

seebeck_dim_Casey_sum_14 = zeros(1,length(t));
seebeck_dim_Casey_spr_14 = zeros(1,length(t));
seebeck_dim_Davis_sum_14 = zeros(1,length(t));
seebeck_dim_Davis_spr_14 = zeros(1,length(t));

seebeck_dim_Casey_sum_15 = zeros(1,length(t));
seebeck_dim_Casey_spr_15 = zeros(1,length(t));
seebeck_dim_Davis_sum_15 = zeros(1,length(t));
seebeck_dim_Davis_spr_15 = zeros(1,length(t));

seebeck_dim_Casey_sum_16 = zeros(1,length(t));
seebeck_dim_Casey_spr_16 = zeros(1,length(t));
seebeck_dim_Davis_sum_16 = zeros(1,length(t));
seebeck_dim_Davis_spr_16 = zeros(1,length(t));

for i = 1:48
% Case 5
    seebeck_dim_Casey_sum_13(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_13_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_13_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_13(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_13_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_13_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_13(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_13_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_13_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_13(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_13_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_13_K(i))) ...
    - 0.582;
% Case 6
    seebeck_dim_Casey_sum_14(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_14_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_14_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_14(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_14_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_14_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_14(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_14_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_14_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_14(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_14_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_14_K(i))) ...
    - 0.582;
% Case 7
    seebeck_dim_Casey_sum_15(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_15_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_15_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_15(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_15_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_15_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_15(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_15_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_15_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_15(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_15_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_15_K(i))) ...
    - 0.582;
% Case 8
    seebeck_dim_Casey_sum_16(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_16_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_16_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_16(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_16_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_16_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_16(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_16_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_16_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_16(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_16_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_16_K(i))) ...
    - 0.582;
end
% dim*stc = seebeck
seebeck_Casey_sum_13 = zeros(1,length(t));
seebeck_Casey_spr_13 = zeros(1,length(t));
seebeck_Davis_sum_13 = zeros(1,length(t));
seebeck_Davis_spr_13 = zeros(1,length(t));

seebeck_Casey_sum_14 = zeros(1,length(t));
seebeck_Casey_spr_14 = zeros(1,length(t));
seebeck_Davis_sum_14 = zeros(1,length(t));
seebeck_Davis_spr_14 = zeros(1,length(t));

seebeck_Casey_sum_15 = zeros(1,length(t));
seebeck_Casey_spr_15 = zeros(1,length(t));
seebeck_Davis_sum_15 = zeros(1,length(t));
seebeck_Davis_spr_15 = zeros(1,length(t));

seebeck_Casey_sum_16 = zeros(1,length(t));
seebeck_Casey_spr_16 = zeros(1,length(t));
seebeck_Davis_sum_16 = zeros(1,length(t));
seebeck_Davis_spr_16 = zeros(1,length(t));

for i = 1:48 
% Case 5
    seebeck_Casey_sum_13(i) = seebeck_dim_Casey_sum_13(i).*seebeck_stc;
    seebeck_Casey_spr_13(i) = seebeck_dim_Casey_spr_13(i).*seebeck_stc;
    seebeck_Davis_sum_13(i) = seebeck_dim_Davis_sum_13(i).*seebeck_stc;
    seebeck_Davis_spr_13(i) = seebeck_dim_Davis_spr_13(i).*seebeck_stc;
% Case 6
    seebeck_Casey_sum_14(i) = seebeck_dim_Casey_sum_14(i).*seebeck_stc;
    seebeck_Casey_spr_14(i) = seebeck_dim_Casey_spr_14(i).*seebeck_stc;
    seebeck_Davis_sum_14(i) = seebeck_dim_Davis_sum_14(i).*seebeck_stc;
    seebeck_Davis_spr_14(i) = seebeck_dim_Davis_spr_14(i).*seebeck_stc;
% Case 7
    seebeck_Casey_sum_15(i) = seebeck_dim_Casey_sum_15(i).*seebeck_stc;
    seebeck_Casey_spr_15(i) = seebeck_dim_Casey_spr_15(i).*seebeck_stc;
    seebeck_Davis_sum_15(i) = seebeck_dim_Davis_sum_15(i).*seebeck_stc;
    seebeck_Davis_spr_15(i) = seebeck_dim_Davis_spr_15(i).*seebeck_stc;
% Case 8
    seebeck_Casey_sum_16(i) = seebeck_dim_Casey_sum_16(i).*seebeck_stc;
    seebeck_Casey_spr_16(i) = seebeck_dim_Casey_spr_16(i).*seebeck_stc;
    seebeck_Davis_sum_16(i) = seebeck_dim_Davis_sum_16(i).*seebeck_stc;
    seebeck_Davis_spr_16(i) = seebeck_dim_Davis_spr_16(i).*seebeck_stc;
end
% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum_13 = zeros(1,length(t));
TEG_V_Casey_spr_13 = zeros(1,length(t));
TEG_V_Davis_sum_13 = zeros(1,length(t));
TEG_V_Davis_spr_13 = zeros(1,length(t));

TEG_V_Casey_sum_14 = zeros(1,length(t));
TEG_V_Casey_spr_14 = zeros(1,length(t));
TEG_V_Davis_sum_14 = zeros(1,length(t));
TEG_V_Davis_spr_14 = zeros(1,length(t));

TEG_V_Casey_sum_15 = zeros(1,length(t));
TEG_V_Casey_spr_15 = zeros(1,length(t));
TEG_V_Davis_sum_15 = zeros(1,length(t));
TEG_V_Davis_spr_15 = zeros(1,length(t));

TEG_V_Casey_sum_16 = zeros(1,length(t));
TEG_V_Casey_spr_16 = zeros(1,length(t));
TEG_V_Davis_sum_16 = zeros(1,length(t));
TEG_V_Davis_spr_16 = zeros(1,length(t));

for i = 1:48
% Case 13
    TEG_V_Casey_sum_13(i) = N .* seebeck_Casey_sum_13(i) .* ...
        Casey_sum_temp_diff_13(i);
    TEG_V_Casey_spr_13(i) = N .* seebeck_Casey_spr_13(i) .* ...
        Casey_spr_temp_diff_13(i);
    TEG_V_Davis_sum_13(i) = N .* seebeck_Davis_sum_13(i) .* ...
        Davis_sum_temp_diff_13(i);
    TEG_V_Davis_spr_13(i) = N .* seebeck_Davis_spr_13(i) .* ...
        Davis_spr_temp_diff_13(i);
% Case 6
    TEG_V_Casey_sum_14(i) = N .* seebeck_Casey_sum_14(i) .* ...
        Casey_sum_temp_diff_14(i);
    TEG_V_Casey_spr_14(i) = N .* seebeck_Casey_spr_14(i) .* ...
        Casey_spr_temp_diff_14(i);
    TEG_V_Davis_sum_14(i) = N .* seebeck_Davis_sum_14(i) .* ...
        Davis_sum_temp_diff_14(i);
    TEG_V_Davis_spr_14(i) = N .* seebeck_Davis_spr_14(i) .* ...
        Davis_spr_temp_diff_14(i);
% Case 7
    TEG_V_Casey_sum_15(i) = N .* seebeck_Casey_sum_15(i) .* ...
        Casey_sum_temp_diff_15(i);
    TEG_V_Casey_spr_15(i) = N .* seebeck_Casey_spr_15(i) .* ...
        Casey_spr_temp_diff_15(i);
    TEG_V_Davis_sum_15(i) = N .* seebeck_Davis_sum_15(i) .* ...
        Davis_sum_temp_diff_15(i);
    TEG_V_Davis_spr_15(i) = N .* seebeck_Davis_spr_15(i) .* ...
        Davis_spr_temp_diff_15(i);
% Case 8
    TEG_V_Casey_sum_16(i) = N .* seebeck_Casey_sum_16(i) .* ...
        Casey_sum_temp_diff_16(i);
    TEG_V_Casey_spr_16(i) = N .* seebeck_Casey_spr_16(i) .* ...
        Casey_spr_temp_diff_16(i);
    TEG_V_Davis_sum_16(i) = N .* seebeck_Davis_sum_16(i) .* ...
        Davis_sum_temp_diff_16(i);
    TEG_V_Davis_spr_16(i) = N .* seebeck_Davis_spr_16(i) .* ...
        Davis_spr_temp_diff_16(i);
end
% -- %% -- %% TEG INTERNAL RESISTANCE %% -- %% -- %%
elec_cond_dim_Casey_sum_13 = zeros(1,length(t));
elec_cond_dim_Casey_spr_13 = zeros(1,length(t));
elec_cond_dim_Davis_sum_13 = zeros(1,length(t));
elec_cond_dim_Davis_spr_13 = zeros(1,length(t));

elec_cond_dim_Casey_sum_14 = zeros(1,length(t));
elec_cond_dim_Casey_spr_14 = zeros(1,length(t));
elec_cond_dim_Davis_sum_14 = zeros(1,length(t));
elec_cond_dim_Davis_spr_14 = zeros(1,length(t));

elec_cond_dim_Casey_sum_15 = zeros(1,length(t));
elec_cond_dim_Casey_spr_15 = zeros(1,length(t));
elec_cond_dim_Davis_sum_15 = zeros(1,length(t));
elec_cond_dim_Davis_spr_15 = zeros(1,length(t));

elec_cond_dim_Casey_sum_16 = zeros(1,length(t));
elec_cond_dim_Casey_spr_16 = zeros(1,length(t));
elec_cond_dim_Davis_sum_16 = zeros(1,length(t));
elec_cond_dim_Davis_spr_16 = zeros(1,length(t));

for i = 1:48
% Case 5
    elec_cond_dim_Casey_sum_13(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_13_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_13_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_13(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_13_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_13_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_13(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_13_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_13_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_13(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_13_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_13_K(i))) ...
        + 8.629;
% Case 6
    elec_cond_dim_Casey_sum_14(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_14_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_14_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_14(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_14_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_14_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_14(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_14_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_14_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_14(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_14_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_14_K(i))) ...
        + 8.629;
% Case 7
    elec_cond_dim_Casey_sum_15(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_15_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_15_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_15(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_15_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_15_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_15(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_15_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_15_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_15(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_15_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_15_K(i))) ...
        + 8.629;
% Case 8
    elec_cond_dim_Casey_sum_16(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_16_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_16_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_16(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_16_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_16_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_16(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_16_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_16_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Davis_spr_16(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_16_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_16_K(i)) ) ...
        + 8.629;
end

% dim * stc = const

% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum_13 = zeros(1,length(t));
elec_cond_Casey_spr_13 = zeros(1,length(t));
elec_cond_Davis_sum_13 = zeros(1,length(t));
elec_cond_Davis_spr_13 = zeros(1,length(t));

elec_cond_Casey_sum_14 = zeros(1,length(t));
elec_cond_Casey_spr_14 = zeros(1,length(t));
elec_cond_Davis_sum_14 = zeros(1,length(t));
elec_cond_Davis_spr_14 = zeros(1,length(t));

elec_cond_Casey_sum_15 = zeros(1,length(t));
elec_cond_Casey_spr_15 = zeros(1,length(t));
elec_cond_Davis_sum_15 = zeros(1,length(t));
elec_cond_Davis_spr_15 = zeros(1,length(t));

elec_cond_Casey_sum_16 = zeros(1,length(t));
elec_cond_Casey_spr_16 = zeros(1,length(t));
elec_cond_Davis_sum_16 = zeros(1,length(t));
elec_cond_Davis_spr_16 = zeros(1,length(t));

for i = 1:48
% Case 5
    elec_cond_Casey_sum_13(i) = elec_cond_dim_Casey_sum_13(i) .* elec_cond_stc;
    elec_cond_Casey_spr_13(i) = elec_cond_dim_Casey_spr_13(i) .* elec_cond_stc;
    elec_cond_Davis_sum_13(i) = elec_cond_dim_Davis_sum_13(i) .* elec_cond_stc;
    elec_cond_Davis_spr_13(i) = elec_cond_dim_Davis_spr_13(i) .* elec_cond_stc;
% Case 6
    elec_cond_Casey_sum_14(i) = elec_cond_dim_Casey_sum_14(i) .* elec_cond_stc;
    elec_cond_Casey_spr_14(i) = elec_cond_dim_Casey_spr_14(i) .* elec_cond_stc;
    elec_cond_Davis_sum_14(i) = elec_cond_dim_Davis_sum_14(i) .* elec_cond_stc;
    elec_cond_Davis_spr_14(i) = elec_cond_dim_Davis_spr_14(i) .* elec_cond_stc;
% Case 7
    elec_cond_Casey_sum_15(i) = elec_cond_dim_Casey_sum_15(i) .* elec_cond_stc;
    elec_cond_Casey_spr_15(i) = elec_cond_dim_Casey_spr_15(i) .* elec_cond_stc;
    elec_cond_Davis_sum_15(i) = elec_cond_dim_Davis_sum_15(i) .* elec_cond_stc;
    elec_cond_Davis_spr_15(i) = elec_cond_dim_Davis_spr_15(i) .* elec_cond_stc;

% Case 8
    elec_cond_Casey_sum_16(i) = elec_cond_dim_Casey_sum_16(i) .* elec_cond_stc;
    elec_cond_Casey_spr_16(i) = elec_cond_dim_Casey_spr_16(i) .* elec_cond_stc;
    elec_cond_Davis_sum_16(i) = elec_cond_dim_Davis_sum_16(i) .* elec_cond_stc;
    elec_cond_Davis_spr_16(i) = elec_cond_dim_Davis_spr_16(i) .* elec_cond_stc;

end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)

% need to be very careful - make cosntants where possible

Casey_sum_R_i_13 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_13 = zeros(1,length(t));
Davis_sum_R_i_13 = zeros(1,length(t));
Davis_spr_R_i_13 = zeros(1,length(t));

Casey_sum_R_i_14 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_14 = zeros(1,length(t));
Davis_sum_R_i_14 = zeros(1,length(t));
Davis_spr_R_i_14 = zeros(1,length(t));

Casey_sum_R_i_15 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_15 = zeros(1,length(t));
Davis_sum_R_i_15 = zeros(1,length(t));
Davis_spr_R_i_15 = zeros(1,length(t));

Casey_sum_R_i_16 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_16 = zeros(1,length(t));
Davis_sum_R_i_16 = zeros(1,length(t));
Davis_spr_R_i_16 = zeros(1,length(t));

for i = 1:48
% Case 5
    Casey_sum_R_i_13(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_13(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_13(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_13(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_13(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_13(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_13(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_13(i) ) + ( (2.*r_con)./ thick) );
% Case 6
    Casey_sum_R_i_14(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_14(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_14(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_14(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_14(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_14(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_14(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_14(i) ) + ( (2.*r_con)./ thick) );

% Case 7
    Casey_sum_R_i_15(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_15(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_15(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_15(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_15(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_15(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_15(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_15(i) ) + ( (2.*r_con)./ thick) );

% Case 8

    Casey_sum_R_i_16(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_16(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_16(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_16(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_16(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_16(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_16(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_16(i) ) + ( (2.*r_con)./ thick) );

end


%----------------------------------------------------------------------------%
    % [80% Clouds]:[Wind = 5,10,25,50]
    % [80% Clouds]:[17:20
Casey_sum_mean_temp_17_K = zeros(1,length(t));
Casey_spr_mean_temp_17_K = zeros(1,length(t));
Davis_sum_mean_temp_17_K = zeros(1,length(t));
Davis_spr_mean_temp_17_K = zeros(1,length(t));

Casey_sum_mean_temp_18_K = zeros(1,length(t));
Casey_spr_mean_temp_18_K = zeros(1,length(t));
Davis_sum_mean_temp_18_K = zeros(1,length(t));
Davis_spr_mean_temp_18_K = zeros(1,length(t));

Casey_sum_mean_temp_19_K = zeros(1,length(t));
Casey_spr_mean_temp_19_K = zeros(1,length(t));
Davis_sum_mean_temp_19_K = zeros(1,length(t));
Davis_spr_mean_temp_19_K = zeros(1,length(t));

Casey_sum_mean_temp_20_K = zeros(1,length(t));
Casey_spr_mean_temp_20_K = zeros(1,length(t));
Davis_sum_mean_temp_20_K = zeros(1,length(t));
Davis_spr_mean_temp_20_K = zeros(1,length(t));

for i = 1:48
% Case 13
    Casey_sum_mean_temp_17_K(i) = Casey_sum_mean_temp_17(i) + 273.15;
    Casey_spr_mean_temp_17_K(i) = Casey_spr_mean_temp_17(i) + 273.15;
    Davis_sum_mean_temp_17_K(i) = Davis_sum_mean_temp_17(i) + 273.15;
    Davis_spr_mean_temp_17_K(i) = Davis_spr_mean_temp_17(i) + 273.15;
% Case 14
    Casey_sum_mean_temp_18_K(i) = Casey_sum_mean_temp_18(i) + 273.15;
    Casey_spr_mean_temp_18_K(i) = Casey_spr_mean_temp_18(i) + 273.15;
    Davis_sum_mean_temp_18_K(i) = Davis_sum_mean_temp_18(i) + 273.15;
    Davis_spr_mean_temp_18_K(i) = Davis_spr_mean_temp_18(i) + 273.15;
% Case 15
    Casey_sum_mean_temp_19_K(i) = Casey_sum_mean_temp_19(i) + 273.15;
    Casey_spr_mean_temp_19_K(i) = Casey_spr_mean_temp_19(i) + 273.15;
    Davis_sum_mean_temp_19_K(i) = Davis_sum_mean_temp_19(i) + 273.15;
    Davis_spr_mean_temp_19_K(i) = Davis_spr_mean_temp_19(i) + 273.15;
% Case 16
    Casey_sum_mean_temp_20_K(i) = Casey_sum_mean_temp_20(i) + 273.15;
    Casey_spr_mean_temp_20_K(i) = Casey_spr_mean_temp_20(i) + 273.15;
    Davis_sum_mean_temp_20_K(i) = Davis_sum_mean_temp_20(i) + 273.15;
    Davis_spr_mean_temp_20_K(i) = Davis_spr_mean_temp_20(i) + 273.15;
end
% Celsius 2 Kelvin!!
seebeck_dim_Casey_sum_17 = zeros(1,length(t));
seebeck_dim_Casey_spr_17 = zeros(1,length(t));
seebeck_dim_Davis_sum_17 = zeros(1,length(t));
seebeck_dim_Davis_spr_17 = zeros(1,length(t));

seebeck_dim_Casey_sum_18 = zeros(1,length(t));
seebeck_dim_Casey_spr_18 = zeros(1,length(t));
seebeck_dim_Davis_sum_18 = zeros(1,length(t));
seebeck_dim_Davis_spr_18 = zeros(1,length(t));

seebeck_dim_Casey_sum_19 = zeros(1,length(t));
seebeck_dim_Casey_spr_19 = zeros(1,length(t));
seebeck_dim_Davis_sum_19 = zeros(1,length(t));
seebeck_dim_Davis_spr_19 = zeros(1,length(t));

seebeck_dim_Casey_sum_20 = zeros(1,length(t));
seebeck_dim_Casey_spr_20 = zeros(1,length(t));
seebeck_dim_Davis_sum_20 = zeros(1,length(t));
seebeck_dim_Davis_spr_20 = zeros(1,length(t));

for i = 1:48
% Case 5
    seebeck_dim_Casey_sum_17(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_17_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_17_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_17(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_17_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_17_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_17(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_17_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_17_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_17(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_17_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_17_K(i))) ...
    - 0.582;
% Case 6
    seebeck_dim_Casey_sum_18(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_18_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_18_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_18(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_18_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_18_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_18(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_18_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_18_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_18(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_18_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_18_K(i))) ...
    - 0.582;
% Case 7
    seebeck_dim_Casey_sum_19(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_19_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_19_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_19(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_19_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_19_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_19(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_19_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_19_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_19(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_19_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_19_K(i))) ...
    - 0.582;
% Case 8
    seebeck_dim_Casey_sum_20(i) = ...
    (-1.132*10^(-5) .* (Casey_sum_mean_temp_20_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_sum_mean_temp_20_K(i))) ...
    - 0.582;
    seebeck_dim_Casey_spr_20(i) = ...
    (-1.132*10^(-5) .* (Casey_spr_mean_temp_20_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Casey_spr_mean_temp_20_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_sum_20(i) = ...
    (-1.132*10^(-5) .* (Davis_sum_mean_temp_20_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_sum_mean_temp_20_K(i))) ...
    - 0.582;
    seebeck_dim_Davis_spr_20(i) = ...
    (-1.132*10^(-5) .* (Davis_spr_mean_temp_20_K(i))^2 ) ...
    + (8.64*10^(-3) .* (Davis_spr_mean_temp_20_K(i))) ...
    - 0.582;
end
% dim*stc = seebeck
seebeck_Casey_sum_17 = zeros(1,length(t));
seebeck_Casey_spr_17 = zeros(1,length(t));
seebeck_Davis_sum_17 = zeros(1,length(t));
seebeck_Davis_spr_17 = zeros(1,length(t));

seebeck_Casey_sum_18 = zeros(1,length(t));
seebeck_Casey_spr_18 = zeros(1,length(t));
seebeck_Davis_sum_18 = zeros(1,length(t));
seebeck_Davis_spr_18 = zeros(1,length(t));

seebeck_Casey_sum_19 = zeros(1,length(t));
seebeck_Casey_spr_19 = zeros(1,length(t));
seebeck_Davis_sum_19 = zeros(1,length(t));
seebeck_Davis_spr_19 = zeros(1,length(t));

seebeck_Casey_sum_20 = zeros(1,length(t));
seebeck_Casey_spr_20 = zeros(1,length(t));
seebeck_Davis_sum_20 = zeros(1,length(t));
seebeck_Davis_spr_20 = zeros(1,length(t));

for i = 1:48 
% Case 5
    seebeck_Casey_sum_17(i) = seebeck_dim_Casey_sum_17(i).*seebeck_stc;
    seebeck_Casey_spr_17(i) = seebeck_dim_Casey_spr_17(i).*seebeck_stc;
    seebeck_Davis_sum_17(i) = seebeck_dim_Davis_sum_17(i).*seebeck_stc;
    seebeck_Davis_spr_17(i) = seebeck_dim_Davis_spr_17(i).*seebeck_stc;
% Case 6
    seebeck_Casey_sum_18(i) = seebeck_dim_Casey_sum_18(i).*seebeck_stc;
    seebeck_Casey_spr_18(i) = seebeck_dim_Casey_spr_18(i).*seebeck_stc;
    seebeck_Davis_sum_18(i) = seebeck_dim_Davis_sum_18(i).*seebeck_stc;
    seebeck_Davis_spr_18(i) = seebeck_dim_Davis_spr_18(i).*seebeck_stc;
% Case 7
    seebeck_Casey_sum_19(i) = seebeck_dim_Casey_sum_19(i).*seebeck_stc;
    seebeck_Casey_spr_19(i) = seebeck_dim_Casey_spr_19(i).*seebeck_stc;
    seebeck_Davis_sum_19(i) = seebeck_dim_Davis_sum_19(i).*seebeck_stc;
    seebeck_Davis_spr_19(i) = seebeck_dim_Davis_spr_19(i).*seebeck_stc;
% Case 8
    seebeck_Casey_sum_20(i) = seebeck_dim_Casey_sum_20(i).*seebeck_stc;
    seebeck_Casey_spr_20(i) = seebeck_dim_Casey_spr_20(i).*seebeck_stc;
    seebeck_Davis_sum_20(i) = seebeck_dim_Davis_sum_20(i).*seebeck_stc;
    seebeck_Davis_spr_20(i) = seebeck_dim_Davis_spr_20(i).*seebeck_stc;
end
% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum_17 = zeros(1,length(t));
TEG_V_Casey_spr_17 = zeros(1,length(t));
TEG_V_Davis_sum_17 = zeros(1,length(t));
TEG_V_Davis_spr_17 = zeros(1,length(t));

TEG_V_Casey_sum_18 = zeros(1,length(t));
TEG_V_Casey_spr_18 = zeros(1,length(t));
TEG_V_Davis_sum_18 = zeros(1,length(t));
TEG_V_Davis_spr_18 = zeros(1,length(t));

TEG_V_Casey_sum_19 = zeros(1,length(t));
TEG_V_Casey_spr_19 = zeros(1,length(t));
TEG_V_Davis_sum_19 = zeros(1,length(t));
TEG_V_Davis_spr_19 = zeros(1,length(t));

TEG_V_Casey_sum_20 = zeros(1,length(t));
TEG_V_Casey_spr_20 = zeros(1,length(t));
TEG_V_Davis_sum_20 = zeros(1,length(t));
TEG_V_Davis_spr_20 = zeros(1,length(t));

for i = 1:48
% Case 5
    TEG_V_Casey_sum_17(i) = N .* seebeck_Casey_sum_17(i) .* ...
        Casey_sum_temp_diff_17(i);
    TEG_V_Casey_spr_17(i) = N .* seebeck_Casey_spr_17(i) .* ...
        Casey_spr_temp_diff_17(i);
    TEG_V_Davis_sum_17(i) = N .* seebeck_Davis_sum_17(i) .* ...
        Davis_sum_temp_diff_17(i);
    TEG_V_Davis_spr_17(i) = N .* seebeck_Davis_spr_17(i) .* ...
        Davis_spr_temp_diff_17(i);
% Case 6
    TEG_V_Casey_sum_18(i) = N .* seebeck_Casey_sum_18(i) .* ...
        Casey_sum_temp_diff_18(i);
    TEG_V_Casey_spr_18(i) = N .* seebeck_Casey_spr_18(i) .* ...
        Casey_spr_temp_diff_18(i);
    TEG_V_Davis_sum_18(i) = N .* seebeck_Davis_sum_18(i) .* ...
        Davis_sum_temp_diff_18(i);
    TEG_V_Davis_spr_18(i) = N .* seebeck_Davis_spr_18(i) .* ...
        Davis_spr_temp_diff_18(i);
% Case 7
    TEG_V_Casey_sum_19(i) = N .* seebeck_Casey_sum_19(i) .* ...
        Casey_sum_temp_diff_19(i);
    TEG_V_Casey_spr_19(i) = N .* seebeck_Casey_spr_19(i) .* ...
        Casey_spr_temp_diff_19(i);
    TEG_V_Davis_sum_19(i) = N .* seebeck_Davis_sum_19(i) .* ...
        Davis_sum_temp_diff_19(i);
    TEG_V_Davis_spr_19(i) = N .* seebeck_Davis_spr_19(i) .* ...
        Davis_spr_temp_diff_19(i);
% Case 8
    TEG_V_Casey_sum_20(i) = N .* seebeck_Casey_sum_20(i) .* ...
        Casey_sum_temp_diff_20(i);
    TEG_V_Casey_spr_20(i) = N .* seebeck_Casey_spr_20(i) .* ...
        Casey_spr_temp_diff_20(i);
    TEG_V_Davis_sum_20(i) = N .* seebeck_Davis_sum_20(i) .* ...
        Davis_sum_temp_diff_20(i);
    TEG_V_Davis_spr_20(i) = N .* seebeck_Davis_spr_20(i) .* ...
        Davis_spr_temp_diff_20(i);
end
% -- %% -- %% TEG INTERNAL RESISTANCE %% -- %% -- %%
elec_cond_dim_Casey_sum_17 = zeros(1,length(t));
elec_cond_dim_Casey_spr_17 = zeros(1,length(t));
elec_cond_dim_Davis_sum_17 = zeros(1,length(t));
elec_cond_dim_Davis_spr_17 = zeros(1,length(t));

elec_cond_dim_Casey_sum_18 = zeros(1,length(t));
elec_cond_dim_Casey_spr_18 = zeros(1,length(t));
elec_cond_dim_Davis_sum_18 = zeros(1,length(t));
elec_cond_dim_Davis_spr_18 = zeros(1,length(t));

elec_cond_dim_Casey_sum_19 = zeros(1,length(t));
elec_cond_dim_Casey_spr_19 = zeros(1,length(t));
elec_cond_dim_Davis_sum_19 = zeros(1,length(t));
elec_cond_dim_Davis_spr_19 = zeros(1,length(t));

elec_cond_dim_Casey_sum_20 = zeros(1,length(t));
elec_cond_dim_Casey_spr_20 = zeros(1,length(t));
elec_cond_dim_Davis_sum_20 = zeros(1,length(t));
elec_cond_dim_Davis_spr_20 = zeros(1,length(t));

for i = 1:48
% Case 5
    elec_cond_dim_Casey_sum_17(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_17_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_17_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_17(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_17_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_17_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_17(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_17_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_17_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_17(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_17_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_17_K(i))) ...
        + 8.629;
% Case 6
    elec_cond_dim_Casey_sum_18(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_18_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_18_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_18(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_18_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_18_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_18(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_18_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_18_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_18(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_18_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_18_K(i))) ...
        + 8.629;
% Case 7
    elec_cond_dim_Casey_sum_19(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_19_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_19_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_19(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_19_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_19_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_19(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_19_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_19_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_spr_19(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_19_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_19_K(i))) ...
        + 8.629;
% Case 8
    elec_cond_dim_Casey_sum_20(i) = ...
        (6.257*10^(-5) .* (Casey_sum_mean_temp_20_K(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_mean_temp_20_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Casey_spr_20(i) = ...
        (6.257*10^(-5) .* (Casey_spr_mean_temp_20_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_mean_temp_20_K(i))) ...
        + 8.629;
    elec_cond_dim_Davis_sum_20(i) = ...
        (6.257*10^(-5) .* (Davis_sum_mean_temp_20_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_mean_temp_20_K(i)) ) ...
        + 8.629;
    elec_cond_dim_Davis_spr_20(i) = ...
        (6.257*10^(-5) .* (Davis_spr_mean_temp_20_K(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_mean_temp_20_K(i)) ) ...
        + 8.629;
end

% dim * stc = const

% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum_17 = zeros(1,length(t));
elec_cond_Casey_spr_17 = zeros(1,length(t));
elec_cond_Davis_sum_17 = zeros(1,length(t));
elec_cond_Davis_spr_17 = zeros(1,length(t));

elec_cond_Casey_sum_18 = zeros(1,length(t));
elec_cond_Casey_spr_18 = zeros(1,length(t));
elec_cond_Davis_sum_18 = zeros(1,length(t));
elec_cond_Davis_spr_18 = zeros(1,length(t));

elec_cond_Casey_sum_19 = zeros(1,length(t));
elec_cond_Casey_spr_19 = zeros(1,length(t));
elec_cond_Davis_sum_19 = zeros(1,length(t));
elec_cond_Davis_spr_19 = zeros(1,length(t));

elec_cond_Casey_sum_20 = zeros(1,length(t));
elec_cond_Casey_spr_20 = zeros(1,length(t));
elec_cond_Davis_sum_20 = zeros(1,length(t));
elec_cond_Davis_spr_20 = zeros(1,length(t));

for i = 1:48
% Case 5
    elec_cond_Casey_sum_17(i) = elec_cond_dim_Casey_sum_17(i) .* elec_cond_stc;
    elec_cond_Casey_spr_17(i) = elec_cond_dim_Casey_spr_17(i) .* elec_cond_stc;
    elec_cond_Davis_sum_17(i) = elec_cond_dim_Davis_sum_17(i) .* elec_cond_stc;
    elec_cond_Davis_spr_17(i) = elec_cond_dim_Davis_spr_17(i) .* elec_cond_stc;
% Case 6
    elec_cond_Casey_sum_18(i) = elec_cond_dim_Casey_sum_18(i) .* elec_cond_stc;
    elec_cond_Casey_spr_18(i) = elec_cond_dim_Casey_spr_18(i) .* elec_cond_stc;
    elec_cond_Davis_sum_18(i) = elec_cond_dim_Davis_sum_18(i) .* elec_cond_stc;
    elec_cond_Davis_spr_18(i) = elec_cond_dim_Davis_spr_18(i) .* elec_cond_stc;
% Case 7
    elec_cond_Casey_sum_19(i) = elec_cond_dim_Casey_sum_19(i) .* elec_cond_stc;
    elec_cond_Casey_spr_19(i) = elec_cond_dim_Casey_spr_19(i) .* elec_cond_stc;
    elec_cond_Davis_sum_19(i) = elec_cond_dim_Davis_sum_19(i) .* elec_cond_stc;
    elec_cond_Davis_spr_19(i) = elec_cond_dim_Davis_spr_19(i) .* elec_cond_stc;

% Case 8
    elec_cond_Casey_sum_20(i) = elec_cond_dim_Casey_sum_20(i) .* elec_cond_stc;
    elec_cond_Casey_spr_20(i) = elec_cond_dim_Casey_spr_20(i) .* elec_cond_stc;
    elec_cond_Davis_sum_20(i) = elec_cond_dim_Davis_sum_20(i) .* elec_cond_stc;
    elec_cond_Davis_spr_20(i) = elec_cond_dim_Davis_spr_20(i) .* elec_cond_stc;

end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)

% need to be very careful - make cosntants where possible

Casey_sum_R_i_17 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_17 = zeros(1,length(t));
Davis_sum_R_i_17 = zeros(1,length(t));
Davis_spr_R_i_17 = zeros(1,length(t));

Casey_sum_R_i_18 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_18 = zeros(1,length(t));
Davis_sum_R_i_18 = zeros(1,length(t));
Davis_spr_R_i_18 = zeros(1,length(t));

Casey_sum_R_i_19 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_19 = zeros(1,length(t));
Davis_sum_R_i_19 = zeros(1,length(t));
Davis_spr_R_i_19 = zeros(1,length(t));

Casey_sum_R_i_20 = zeros(1,length(t)); % Ohms - resistance
Casey_spr_R_i_20 = zeros(1,length(t));
Davis_sum_R_i_20 = zeros(1,length(t));
Davis_spr_R_i_20 = zeros(1,length(t));

for i = 1:48
% Case 5
    Casey_sum_R_i_17(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_17(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_17(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_17(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_17(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_17(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_17(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_17(i) ) + ( (2.*r_con)./ thick) );
% Case 6
    Casey_sum_R_i_18(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_18(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_18(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_18(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_18(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_18(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_18(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_18(i) ) + ( (2.*r_con)./ thick) );

% Case 7
    Casey_sum_R_i_19(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_19(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_19(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_19(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_19(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_19(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_19(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_19(i) ) + ( (2.*r_con)./ thick) );

% Case 8

    Casey_sum_R_i_20(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_sum_20(i) ) + ( (2.*r_con)./ thick) );
    Casey_spr_R_i_20(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Casey_spr_20(i) ) + ( (2.*r_con)./ thick) );
    Davis_sum_R_i_20(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_sum_20(i) ) + ( (2.*r_con)./ thick) );
    Davis_spr_R_i_20(i) = N .* (thick/area) .* ...
        ( (1 ./ elec_cond_Davis_spr_20(i) ) + ( (2.*r_con)./ thick) );

end



%% 6) Power Generation 
% Recall - need metrics of system
% FIND PER PANEL POWER OF TEG 
% SUM ITERATIVELY BASED ON PROTOTYPE (30X30 FOLDOUT)

% [0% Clouds]:[Wind = 5,10,25,50]
% 0% Clouds 01:04
% ------------------------------------------------------------------------------------------------------------------------------------%
% First calculate per module
% % Use Karabetoglu equation: [P = (V^2) /( 4*R_i)]
TEG_P_Casey_sum_01 = zeros(1,length(t));
TEG_P_Casey_spr_01 = zeros(1,length(t));
TEG_P_Davis_sum_01 = zeros(1,length(t));
TEG_P_Davis_spr_01 = zeros(1,length(t));

TEG_P_Casey_sum_02 = zeros(1,length(t));
TEG_P_Casey_spr_02 = zeros(1,length(t));
TEG_P_Davis_sum_02 = zeros(1,length(t));
TEG_P_Davis_spr_02 = zeros(1,length(t));

TEG_P_Casey_sum_03 = zeros(1,length(t));
TEG_P_Casey_spr_03 = zeros(1,length(t));
TEG_P_Davis_sum_03 = zeros(1,length(t));
TEG_P_Davis_spr_03 = zeros(1,length(t));

TEG_P_Casey_sum_04 = zeros(1,length(t));
TEG_P_Casey_spr_04 = zeros(1,length(t));
TEG_P_Davis_sum_04 = zeros(1,length(t));
TEG_P_Davis_spr_04 = zeros(1,length(t));


for i = 1:48
% Case 1
    TEG_P_Casey_sum_01(i) =  (TEG_V_Casey_sum_01(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_01(i));     
    TEG_P_Casey_spr_01(i) =  (TEG_V_Casey_spr_01(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_01(i));     
    TEG_P_Davis_sum_01(i) =  (TEG_V_Davis_sum_01(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_01(i));    
    TEG_P_Davis_spr_01(i) =  (TEG_V_Davis_spr_01(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_01(i));
% Case 2
    TEG_P_Casey_sum_02(i) =  (TEG_V_Casey_sum_02(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_02(i));     
    TEG_P_Casey_spr_02(i) =  (TEG_V_Casey_spr_02(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_02(i));     
    TEG_P_Davis_sum_02(i) =  (TEG_V_Davis_sum_02(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_02(i));    
    TEG_P_Davis_spr_02(i) =  (TEG_V_Davis_spr_02(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_02(i));
% Case 3
    TEG_P_Casey_sum_03(i) =  (TEG_V_Casey_sum_03(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_03(i));     
    TEG_P_Casey_spr_03(i) =  (TEG_V_Casey_spr_03(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_03(i));     
    TEG_P_Davis_sum_03(i) =  (TEG_V_Davis_sum_03(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_03(i));    
    TEG_P_Davis_spr_03(i) =  (TEG_V_Davis_spr_03(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_03(i));
% Case 4
    TEG_P_Casey_sum_04(i) =  (TEG_V_Casey_sum_04(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_04(i));     
    TEG_P_Casey_spr_04(i) =  (TEG_V_Casey_spr_04(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_04(i));     
    TEG_P_Davis_sum_04(i) =  (TEG_V_Davis_sum_04(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_04(i));    
    TEG_P_Davis_spr_04(i) =  (TEG_V_Davis_spr_04(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_04(i));
end

TEG_V_row_Casey_sum_01 = zeros(1,length(t));
TEG_V_row_Casey_spr_01 = zeros(1,length(t));
TEG_V_row_Davis_sum_01 = zeros(1,length(t));
TEG_V_row_Davis_spr_01 = zeros(1,length(t));

TEG_V_row_Casey_sum_02 = zeros(1,length(t));
TEG_V_row_Casey_spr_02 = zeros(1,length(t));
TEG_V_row_Davis_sum_02 = zeros(1,length(t));
TEG_V_row_Davis_spr_02 = zeros(1,length(t));

TEG_V_row_Casey_sum_03 = zeros(1,length(t));
TEG_V_row_Casey_spr_03 = zeros(1,length(t));
TEG_V_row_Davis_sum_03 = zeros(1,length(t));
TEG_V_row_Davis_spr_03 = zeros(1,length(t));

TEG_V_row_Casey_sum_04 = zeros(1,length(t));
TEG_V_row_Casey_spr_04 = zeros(1,length(t));
TEG_V_row_Davis_sum_04 = zeros(1,length(t));
TEG_V_row_Davis_spr_04 = zeros(1,length(t));

% Ohms - resistance
Casey_sum_R_i_row_01 = zeros(1,length(t)); 
Casey_spr_R_i_row_01 = zeros(1,length(t));
Davis_sum_R_i_row_01 = zeros(1,length(t));
Davis_spr_R_i_row_01 = zeros(1,length(t));

Casey_sum_R_i_row_02 = zeros(1,length(t)); 
Casey_spr_R_i_row_02 = zeros(1,length(t));
Davis_sum_R_i_row_02 = zeros(1,length(t));
Davis_spr_R_i_row_02 = zeros(1,length(t));

Casey_sum_R_i_row_03 = zeros(1,length(t)); 
Casey_spr_R_i_row_03 = zeros(1,length(t));
Davis_sum_R_i_row_03 = zeros(1,length(t));
Davis_spr_R_i_row_03 = zeros(1,length(t));

Casey_sum_R_i_row_04 = zeros(1,length(t)); 
Casey_spr_R_i_row_04 = zeros(1,length(t));
Davis_sum_R_i_row_04 = zeros(1,length(t));
Davis_spr_R_i_row_04 = zeros(1,length(t));

% Currents
Casey_sum_amps_row_01 = zeros(1,length(t)); 
Casey_spr_amps_row_01 = zeros(1,length(t));    
Davis_sum_amps_row_01 = zeros(1,length(t));
Davis_spr_amps_row_01 = zeros(1,length(t));

Casey_sum_amps_row_02 = zeros(1,length(t)); 
Casey_spr_amps_row_02 = zeros(1,length(t));    
Davis_sum_amps_row_02 = zeros(1,length(t));
Davis_spr_amps_row_02 = zeros(1,length(t));

Casey_sum_amps_row_03 = zeros(1,length(t)); 
Casey_spr_amps_row_03 = zeros(1,length(t));    
Davis_sum_amps_row_03 = zeros(1,length(t));
Davis_spr_amps_row_03 = zeros(1,length(t));

Casey_sum_amps_row_04 = zeros(1,length(t)); 
Casey_spr_amps_row_04 = zeros(1,length(t));    
Davis_sum_amps_row_04 = zeros(1,length(t));
Davis_spr_amps_row_04 = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Case 1
    % Voltages   
    TEG_V_row_Casey_sum_01(i) = TEG_V_Casey_sum_01(i) .* 17; 
    TEG_V_row_Casey_spr_01(i) = TEG_V_Casey_spr_01(i) .* 17;     
    TEG_V_row_Davis_sum_01(i) = TEG_V_Davis_sum_01(i) .* 17; 
    TEG_V_row_Davis_spr_01(i) = TEG_V_Davis_spr_01(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_01(i) = Casey_sum_R_i_01(i) .* 17;
    Casey_spr_R_i_row_01(i) = Casey_spr_R_i_01(i) .* 17;    
    Davis_sum_R_i_row_01(i) = Davis_sum_R_i_01(i) .* 17;
    Davis_spr_R_i_row_01(i) = Davis_spr_R_i_01(i) .* 17;

    % Currents
    Casey_sum_amps_row_01(i) = TEG_V_row_Casey_sum_01(i) ./ ...
        Casey_sum_R_i_row_01(i);
    Casey_spr_amps_row_01(i) = TEG_V_row_Casey_spr_01(i) ./ ...
        Casey_spr_R_i_row_01(i);    
    Davis_sum_amps_row_01(i) = TEG_V_row_Davis_sum_01(i) ./ ...
        Davis_sum_R_i_row_01(i);
    Davis_spr_amps_row_01(i) = TEG_V_row_Davis_spr_01(i) ./ ...
        Davis_spr_R_i_row_01(i);

% Case 2
    % Voltages   
    TEG_V_row_Casey_sum_02(i) = TEG_V_Casey_sum_02(i) .* 17; 
    TEG_V_row_Casey_spr_02(i) = TEG_V_Casey_spr_02(i) .* 17;     
    TEG_V_row_Davis_sum_02(i) = TEG_V_Davis_sum_02(i) .* 17; 
    TEG_V_row_Davis_spr_02(i) = TEG_V_Davis_spr_02(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_02(i) = Casey_sum_R_i_02(i) .* 17;
    Casey_spr_R_i_row_02(i) = Casey_spr_R_i_02(i) .* 17;    
    Davis_sum_R_i_row_02(i) = Davis_sum_R_i_02(i) .* 17;
    Davis_spr_R_i_row_02(i) = Davis_spr_R_i_02(i) .* 17;

    % Currents
    Casey_sum_amps_row_02(i) = TEG_V_row_Casey_sum_02(i) ./ ...
        Casey_sum_R_i_row_02(i);
    Casey_spr_amps_row_02(i) = TEG_V_row_Casey_spr_02(i) ./ ...
        Casey_spr_R_i_row_02(i);    
    Davis_sum_amps_row_02(i) = TEG_V_row_Davis_sum_02(i) ./ ...
        Davis_sum_R_i_row_02(i);
    Davis_spr_amps_row_02(i) = TEG_V_row_Davis_spr_02(i) ./ ...
        Davis_spr_R_i_row_02(i);
% Case 3
    % Voltages   
    TEG_V_row_Casey_sum_03(i) = TEG_V_Casey_sum_03(i) .* 17; 
    TEG_V_row_Casey_spr_03(i) = TEG_V_Casey_spr_03(i) .* 17;     
    TEG_V_row_Davis_sum_03(i) = TEG_V_Davis_sum_03(i) .* 17; 
    TEG_V_row_Davis_spr_03(i) = TEG_V_Davis_spr_03(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_03(i) = Casey_sum_R_i_03(i) .* 17;
    Casey_spr_R_i_row_03(i) = Casey_spr_R_i_03(i) .* 17;    
    Davis_sum_R_i_row_03(i) = Davis_sum_R_i_03(i) .* 17;
    Davis_spr_R_i_row_03(i) = Davis_spr_R_i_03(i) .* 17;

    % Currents
    Casey_sum_amps_row_03(i) = TEG_V_row_Casey_sum_03(i) ./ ...
        Casey_sum_R_i_row_03(i);
    Casey_spr_amps_row_03(i) = TEG_V_row_Casey_spr_03(i) ./ ...
        Casey_spr_R_i_row_03(i);    
    Davis_sum_amps_row_03(i) = TEG_V_row_Davis_sum_03(i) ./ ...
        Davis_sum_R_i_row_03(i);
    Davis_spr_amps_row_03(i) = TEG_V_row_Davis_spr_03(i) ./ ...
        Davis_spr_R_i_row_03(i);
% Case 4
    % Voltages   
    TEG_V_row_Casey_sum_04(i) = TEG_V_Casey_sum_04(i) .* 17; 
    TEG_V_row_Casey_spr_04(i) = TEG_V_Casey_spr_04(i) .* 17;     
    TEG_V_row_Davis_sum_04(i) = TEG_V_Davis_sum_04(i) .* 17; 
    TEG_V_row_Davis_spr_04(i) = TEG_V_Davis_spr_04(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_04(i) = Casey_sum_R_i_04(i) .* 17;
    Casey_spr_R_i_row_04(i) = Casey_spr_R_i_04(i) .* 17;    
    Davis_sum_R_i_row_04(i) = Davis_sum_R_i_04(i) .* 17;
    Davis_spr_R_i_row_04(i) = Davis_spr_R_i_04(i) .* 17;

    % Currents
    Casey_sum_amps_row_04(i) = TEG_V_row_Casey_sum_04(i) ./ ...
        Casey_sum_R_i_row_04(i);
    Casey_spr_amps_row_04(i) = TEG_V_row_Casey_spr_04(i) ./ ...
        Casey_spr_R_i_row_04(i);    
    Davis_sum_amps_row_04(i) = TEG_V_row_Davis_sum_04(i) ./ ...
        Davis_sum_R_i_row_04(i);
    Davis_spr_amps_row_04(i) = TEG_V_row_Davis_spr_04(i) ./ ...
        Davis_spr_R_i_row_04(i);
end

% FOR 1 SOLAR PANEL - in parallel aray 
% 18 rows of 17 modules 
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)

% Resistance
    Casey_sum_R_i_full_01 = zeros(1,length(t)); 
    Casey_spr_R_i_full_01 = zeros(1,length(t));
    Davis_sum_R_i_full_01 = zeros(1,length(t));
    Davis_spr_R_i_full_01 = zeros(1,length(t));

    Casey_sum_R_i_full_02 = zeros(1,length(t)); 
    Casey_spr_R_i_full_02 = zeros(1,length(t));
    Davis_sum_R_i_full_02 = zeros(1,length(t));
    Davis_spr_R_i_full_02 = zeros(1,length(t));

    Casey_sum_R_i_full_03 = zeros(1,length(t));
    Casey_spr_R_i_full_03 = zeros(1,length(t));
    Davis_sum_R_i_full_03 = zeros(1,length(t));
    Davis_spr_R_i_full_03 = zeros(1,length(t));

    Casey_sum_R_i_full_04 = zeros(1,length(t)); 
    Casey_spr_R_i_full_04 = zeros(1,length(t));
    Davis_sum_R_i_full_04 = zeros(1,length(t));
    Davis_spr_R_i_full_04 = zeros(1,length(t));

% Power
    TEG_P_Casey_sum_full_01 = zeros(1,length(t));
    TEG_P_Casey_spr_full_01 = zeros(1,length(t));
    TEG_P_Davis_sum_full_01 = zeros(1,length(t));
    TEG_P_Davis_spr_full_01 = zeros(1,length(t));

    TEG_P_Casey_sum_full_02 = zeros(1,length(t));
    TEG_P_Casey_spr_full_02 = zeros(1,length(t));
    TEG_P_Davis_sum_full_02 = zeros(1,length(t));
    TEG_P_Davis_spr_full_02 = zeros(1,length(t));

    TEG_P_Casey_sum_full_03 = zeros(1,length(t));
    TEG_P_Casey_spr_full_03 = zeros(1,length(t));
    TEG_P_Davis_sum_full_03 = zeros(1,length(t));
    TEG_P_Davis_spr_full_03 = zeros(1,length(t));

    TEG_P_Casey_sum_full_04 = zeros(1,length(t));
    TEG_P_Casey_spr_full_04 = zeros(1,length(t));
    TEG_P_Davis_sum_full_04 = zeros(1,length(t));
    TEG_P_Davis_spr_full_04 = zeros(1,length(t));


% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Case 1
    % Resistance
        Casey_sum_R_i_full_01(i) = (18 ./ Casey_sum_R_i_row_01(i) ).^-1 ;  
        Casey_spr_R_i_full_01(i) = (18 ./ Casey_spr_R_i_row_01(i) ).^-1 ;
        Davis_sum_R_i_full_01(i) = (18 ./ Davis_sum_R_i_row_01(i) ).^-1 ;
        Davis_spr_R_i_full_01(i) = (18 ./ Davis_spr_R_i_row_01(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_01(i) =  (TEG_V_row_Casey_sum_01(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_01(i));     
        TEG_P_Casey_spr_full_01(i) =  (TEG_V_row_Casey_spr_01(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_01(i));     
        TEG_P_Davis_sum_full_01(i) =  (TEG_V_row_Davis_sum_01(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_01(i));    
        TEG_P_Davis_spr_full_01(i) =  (TEG_V_row_Davis_spr_01(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_01(i));
% Case 2
    % Resistance
        Casey_sum_R_i_full_02(i) = (18 ./ Casey_sum_R_i_row_02(i) ).^-1 ;  
        Casey_spr_R_i_full_02(i) = (18 ./ Casey_spr_R_i_row_02(i) ).^-1 ;
        Davis_sum_R_i_full_02(i) = (18 ./ Davis_sum_R_i_row_02(i) ).^-1 ;
        Davis_spr_R_i_full_02(i) = (18 ./ Davis_spr_R_i_row_02(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_02(i) =  (TEG_V_row_Casey_sum_02(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_02(i));     
        TEG_P_Casey_spr_full_02(i) =  (TEG_V_row_Casey_spr_02(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_02(i));     
        TEG_P_Davis_sum_full_02(i) =  (TEG_V_row_Davis_sum_02(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_02(i));    
        TEG_P_Davis_spr_full_02(i) =  (TEG_V_row_Davis_spr_02(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_02(i));
% Case 3
    % Resistance
        Casey_sum_R_i_full_03(i) = (18 ./ Casey_sum_R_i_row_03(i) ).^-1 ;  
        Casey_spr_R_i_full_03(i) = (18 ./ Casey_spr_R_i_row_03(i) ).^-1 ;
        Davis_sum_R_i_full_03(i) = (18 ./ Davis_sum_R_i_row_03(i) ).^-1 ;
        Davis_spr_R_i_full_03(i) = (18 ./ Davis_spr_R_i_row_03(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_03(i) =  (TEG_V_row_Casey_sum_03(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_03(i));     
        TEG_P_Casey_spr_full_03(i) =  (TEG_V_row_Casey_spr_03(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_03(i));     
        TEG_P_Davis_sum_full_03(i) =  (TEG_V_row_Davis_sum_03(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_03(i));    
        TEG_P_Davis_spr_full_03(i) =  (TEG_V_row_Davis_spr_03(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_03(i));
% Case 4
    % Resistance
        Casey_sum_R_i_full_04(i) = (18 ./ Casey_sum_R_i_row_04(i) ).^-1 ;  
        Casey_spr_R_i_full_04(i) = (18 ./ Casey_spr_R_i_row_04(i) ).^-1 ;
        Davis_sum_R_i_full_04(i) = (18 ./ Davis_sum_R_i_row_04(i) ).^-1 ;
        Davis_spr_R_i_full_04(i) = (18 ./ Davis_spr_R_i_row_04(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_04(i) =  (TEG_V_row_Casey_sum_04(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_04(i));     
        TEG_P_Casey_spr_full_04(i) =  (TEG_V_row_Casey_spr_04(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_04(i));     
        TEG_P_Davis_sum_full_04(i) =  (TEG_V_row_Davis_sum_04(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_04(i));    
        TEG_P_Davis_spr_full_04(i) =  (TEG_V_row_Davis_spr_04(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_04(i));
end

% EXPORT DATA - TOO MUCH TO GRAPH AT ONCE!!! - use excel 


%---------------------------------------------------------------------------------------------------------------------------------------------%
    % [20% Clouds]:[Wind = 5,10,25,50]
    % 05:08
TEG_P_Casey_sum_05 = zeros(1,length(t));
TEG_P_Casey_spr_05 = zeros(1,length(t));
TEG_P_Davis_sum_05 = zeros(1,length(t));
TEG_P_Davis_spr_05 = zeros(1,length(t));

TEG_P_Casey_sum_06 = zeros(1,length(t));
TEG_P_Casey_spr_06 = zeros(1,length(t));
TEG_P_Davis_sum_06 = zeros(1,length(t));
TEG_P_Davis_spr_06 = zeros(1,length(t));

TEG_P_Casey_sum_07 = zeros(1,length(t));
TEG_P_Casey_spr_07 = zeros(1,length(t));
TEG_P_Davis_sum_07 = zeros(1,length(t));
TEG_P_Davis_spr_07 = zeros(1,length(t));

TEG_P_Casey_sum_08 = zeros(1,length(t));
TEG_P_Casey_spr_08 = zeros(1,length(t));
TEG_P_Davis_sum_08 = zeros(1,length(t));
TEG_P_Davis_spr_08 = zeros(1,length(t));


for i = 1:48
% Case 1
    TEG_P_Casey_sum_05(i) =  (TEG_V_Casey_sum_05(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_05(i));     
    TEG_P_Casey_spr_05(i) =  (TEG_V_Casey_spr_05(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_05(i));     
    TEG_P_Davis_sum_05(i) =  (TEG_V_Davis_sum_05(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_05(i));    
    TEG_P_Davis_spr_05(i) =  (TEG_V_Davis_spr_05(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_05(i));
% Case 2
    TEG_P_Casey_sum_06(i) =  (TEG_V_Casey_sum_06(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_06(i));     
    TEG_P_Casey_spr_06(i) =  (TEG_V_Casey_spr_06(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_06(i));     
    TEG_P_Davis_sum_06(i) =  (TEG_V_Davis_sum_06(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_06(i));    
    TEG_P_Davis_spr_06(i) =  (TEG_V_Davis_spr_06(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_06(i));
% Case 3
    TEG_P_Casey_sum_07(i) =  (TEG_V_Casey_sum_07(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_07(i));     
    TEG_P_Casey_spr_07(i) =  (TEG_V_Casey_spr_07(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_07(i));     
    TEG_P_Davis_sum_07(i) =  (TEG_V_Davis_sum_07(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_07(i));    
    TEG_P_Davis_spr_07(i) =  (TEG_V_Davis_spr_07(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_07(i));
% Case 4
    TEG_P_Casey_sum_08(i) =  (TEG_V_Casey_sum_08(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_08(i));     
    TEG_P_Casey_spr_08(i) =  (TEG_V_Casey_spr_08(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_08(i));     
    TEG_P_Davis_sum_08(i) =  (TEG_V_Davis_sum_08(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_08(i));    
    TEG_P_Davis_spr_08(i) =  (TEG_V_Davis_spr_08(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_08(i));
end

TEG_V_row_Casey_sum_05 = zeros(1,length(t));
TEG_V_row_Casey_spr_05 = zeros(1,length(t));
TEG_V_row_Davis_sum_05 = zeros(1,length(t));
TEG_V_row_Davis_spr_05 = zeros(1,length(t));

TEG_V_row_Casey_sum_06 = zeros(1,length(t));
TEG_V_row_Casey_spr_06 = zeros(1,length(t));
TEG_V_row_Davis_sum_06 = zeros(1,length(t));
TEG_V_row_Davis_spr_06 = zeros(1,length(t));

TEG_V_row_Casey_sum_07 = zeros(1,length(t));
TEG_V_row_Casey_spr_07 = zeros(1,length(t));
TEG_V_row_Davis_sum_07 = zeros(1,length(t));
TEG_V_row_Davis_spr_07 = zeros(1,length(t));

TEG_V_row_Casey_sum_08 = zeros(1,length(t));
TEG_V_row_Casey_spr_08 = zeros(1,length(t));
TEG_V_row_Davis_sum_08 = zeros(1,length(t));
TEG_V_row_Davis_spr_08 = zeros(1,length(t));

% Ohms - resistance
Casey_sum_R_i_row_05 = zeros(1,length(t)); 
Casey_spr_R_i_row_05 = zeros(1,length(t));
Davis_sum_R_i_row_05 = zeros(1,length(t));
Davis_spr_R_i_row_05 = zeros(1,length(t));

Casey_sum_R_i_row_06 = zeros(1,length(t)); 
Casey_spr_R_i_row_06 = zeros(1,length(t));
Davis_sum_R_i_row_06 = zeros(1,length(t));
Davis_spr_R_i_row_06 = zeros(1,length(t));

Casey_sum_R_i_row_07 = zeros(1,length(t)); 
Casey_spr_R_i_row_07 = zeros(1,length(t));
Davis_sum_R_i_row_07 = zeros(1,length(t));
Davis_spr_R_i_row_07 = zeros(1,length(t));

Casey_sum_R_i_row_08 = zeros(1,length(t)); 
Casey_spr_R_i_row_08 = zeros(1,length(t));
Davis_sum_R_i_row_08 = zeros(1,length(t));
Davis_spr_R_i_row_08 = zeros(1,length(t));

% Currents
Casey_sum_amps_row_05 = zeros(1,length(t)); 
Casey_spr_amps_row_05 = zeros(1,length(t));    
Davis_sum_amps_row_05 = zeros(1,length(t));
Davis_spr_amps_row_05 = zeros(1,length(t));

Casey_sum_amps_row_06 = zeros(1,length(t)); 
Casey_spr_amps_row_06 = zeros(1,length(t));    
Davis_sum_amps_row_06 = zeros(1,length(t));
Davis_spr_amps_row_06 = zeros(1,length(t));

Casey_sum_amps_row_07 = zeros(1,length(t)); 
Casey_spr_amps_row_07 = zeros(1,length(t));    
Davis_sum_amps_row_07 = zeros(1,length(t));
Davis_spr_amps_row_07 = zeros(1,length(t));

Casey_sum_amps_row_08 = zeros(1,length(t)); 
Casey_spr_amps_row_08 = zeros(1,length(t));    
Davis_sum_amps_row_08 = zeros(1,length(t));
Davis_spr_amps_row_08 = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Case 5
    % Voltages   
    TEG_V_row_Casey_sum_05(i) = TEG_V_Casey_sum_05(i) .* 17; 
    TEG_V_row_Casey_spr_05(i) = TEG_V_Casey_spr_05(i) .* 17;     
    TEG_V_row_Davis_sum_05(i) = TEG_V_Davis_sum_05(i) .* 17; 
    TEG_V_row_Davis_spr_05(i) = TEG_V_Davis_spr_05(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_05(i) = Casey_sum_R_i_05(i) .* 17;
    Casey_spr_R_i_row_05(i) = Casey_spr_R_i_05(i) .* 17;    
    Davis_sum_R_i_row_05(i) = Davis_sum_R_i_05(i) .* 17;
    Davis_spr_R_i_row_05(i) = Davis_spr_R_i_05(i) .* 17;

    % Currents
    Casey_sum_amps_row_05(i) = TEG_V_row_Casey_sum_05(i) ./ ...
        Casey_sum_R_i_row_05(i);
    Casey_spr_amps_row_05(i) = TEG_V_row_Casey_spr_05(i) ./ ...
        Casey_spr_R_i_row_05(i);    
    Davis_sum_amps_row_05(i) = TEG_V_row_Davis_sum_05(i) ./ ...
        Davis_sum_R_i_row_05(i);
    Davis_spr_amps_row_05(i) = TEG_V_row_Davis_spr_05(i) ./ ...
        Davis_spr_R_i_row_05(i);

% Case 6
    % Voltages   
    TEG_V_row_Casey_sum_06(i) = TEG_V_Casey_sum_06(i) .* 17; 
    TEG_V_row_Casey_spr_06(i) = TEG_V_Casey_spr_06(i) .* 17;     
    TEG_V_row_Davis_sum_06(i) = TEG_V_Davis_sum_06(i) .* 17; 
    TEG_V_row_Davis_spr_06(i) = TEG_V_Davis_spr_06(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_06(i) = Casey_sum_R_i_06(i) .* 17;
    Casey_spr_R_i_row_06(i) = Casey_spr_R_i_06(i) .* 17;    
    Davis_sum_R_i_row_06(i) = Davis_sum_R_i_06(i) .* 17;
    Davis_spr_R_i_row_06(i) = Davis_spr_R_i_06(i) .* 17;

    % Currents
    Casey_sum_amps_row_06(i) = TEG_V_row_Casey_sum_06(i) ./ ...
        Casey_sum_R_i_row_06(i);
    Casey_spr_amps_row_06(i) = TEG_V_row_Casey_spr_06(i) ./ ...
        Casey_spr_R_i_row_06(i);    
    Davis_sum_amps_row_06(i) = TEG_V_row_Davis_sum_06(i) ./ ...
        Davis_sum_R_i_row_06(i);
    Davis_spr_amps_row_06(i) = TEG_V_row_Davis_spr_06(i) ./ ...
        Davis_spr_R_i_row_06(i);
% Case 7
    % Voltages   
    TEG_V_row_Casey_sum_07(i) = TEG_V_Casey_sum_07(i) .* 17; 
    TEG_V_row_Casey_spr_07(i) = TEG_V_Casey_spr_07(i) .* 17;     
    TEG_V_row_Davis_sum_07(i) = TEG_V_Davis_sum_07(i) .* 17; 
    TEG_V_row_Davis_spr_07(i) = TEG_V_Davis_spr_07(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_07(i) = Casey_sum_R_i_07(i) .* 17;
    Casey_spr_R_i_row_07(i) = Casey_spr_R_i_07(i) .* 17;    
    Davis_sum_R_i_row_07(i) = Davis_sum_R_i_07(i) .* 17;
    Davis_spr_R_i_row_07(i) = Davis_spr_R_i_07(i) .* 17;

    % Currents
    Casey_sum_amps_row_07(i) = TEG_V_row_Casey_sum_07(i) ./ ...
        Casey_sum_R_i_row_07(i);
    Casey_spr_amps_row_07(i) = TEG_V_row_Casey_spr_07(i) ./ ...
        Casey_spr_R_i_row_07(i);    
    Davis_sum_amps_row_07(i) = TEG_V_row_Davis_sum_07(i) ./ ...
        Davis_sum_R_i_row_07(i);
    Davis_spr_amps_row_07(i) = TEG_V_row_Davis_spr_07(i) ./ ...
        Davis_spr_R_i_row_07(i);
% Case 8
    % Voltages   
    TEG_V_row_Casey_sum_08(i) = TEG_V_Casey_sum_08(i) .* 17; 
    TEG_V_row_Casey_spr_08(i) = TEG_V_Casey_spr_08(i) .* 17;     
    TEG_V_row_Davis_sum_08(i) = TEG_V_Davis_sum_08(i) .* 17; 
    TEG_V_row_Davis_spr_08(i) = TEG_V_Davis_spr_08(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_08(i) = Casey_sum_R_i_08(i) .* 17;
    Casey_spr_R_i_row_08(i) = Casey_spr_R_i_08(i) .* 17;    
    Davis_sum_R_i_row_08(i) = Davis_sum_R_i_08(i) .* 17;
    Davis_spr_R_i_row_08(i) = Davis_spr_R_i_08(i) .* 17;

    % Currents
    Casey_sum_amps_row_08(i) = TEG_V_row_Casey_sum_08(i) ./ ...
        Casey_sum_R_i_row_08(i);
    Casey_spr_amps_row_08(i) = TEG_V_row_Casey_spr_08(i) ./ ...
        Casey_spr_R_i_row_08(i);    
    Davis_sum_amps_row_08(i) = TEG_V_row_Davis_sum_08(i) ./ ...
        Davis_sum_R_i_row_08(i);
    Davis_spr_amps_row_08(i) = TEG_V_row_Davis_spr_08(i) ./ ...
        Davis_spr_R_i_row_08(i);
end

% FOR 1 SOLAR PANEL - in parallel aray 
% 18 rows of 17 modules 
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)

% Resistance
    Casey_sum_R_i_full_05 = zeros(1,length(t)); 
    Casey_spr_R_i_full_05 = zeros(1,length(t));
    Davis_sum_R_i_full_05 = zeros(1,length(t));
    Davis_spr_R_i_full_05 = zeros(1,length(t));

    Casey_sum_R_i_full_06 = zeros(1,length(t)); 
    Casey_spr_R_i_full_06 = zeros(1,length(t));
    Davis_sum_R_i_full_06 = zeros(1,length(t));
    Davis_spr_R_i_full_06 = zeros(1,length(t));

    Casey_sum_R_i_full_07 = zeros(1,length(t));
    Casey_spr_R_i_full_07 = zeros(1,length(t));
    Davis_sum_R_i_full_07 = zeros(1,length(t));
    Davis_spr_R_i_full_07 = zeros(1,length(t));

    Casey_sum_R_i_full_08 = zeros(1,length(t)); 
    Casey_spr_R_i_full_08 = zeros(1,length(t));
    Davis_sum_R_i_full_08 = zeros(1,length(t));
    Davis_spr_R_i_full_08 = zeros(1,length(t));

% Power
    TEG_P_Casey_sum_full_05 = zeros(1,length(t));
    TEG_P_Casey_spr_full_05 = zeros(1,length(t));
    TEG_P_Davis_sum_full_05 = zeros(1,length(t));
    TEG_P_Davis_spr_full_05 = zeros(1,length(t));

    TEG_P_Casey_sum_full_06 = zeros(1,length(t));
    TEG_P_Casey_spr_full_06 = zeros(1,length(t));
    TEG_P_Davis_sum_full_06 = zeros(1,length(t));
    TEG_P_Davis_spr_full_06 = zeros(1,length(t));

    TEG_P_Casey_sum_full_07 = zeros(1,length(t));
    TEG_P_Casey_spr_full_07 = zeros(1,length(t));
    TEG_P_Davis_sum_full_07 = zeros(1,length(t));
    TEG_P_Davis_spr_full_07 = zeros(1,length(t));

    TEG_P_Casey_sum_full_08 = zeros(1,length(t));
    TEG_P_Casey_spr_full_08 = zeros(1,length(t));
    TEG_P_Davis_sum_full_08 = zeros(1,length(t));
    TEG_P_Davis_spr_full_08 = zeros(1,length(t));


% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Case 1
    % Resistance
        Casey_sum_R_i_full_05(i) = (18 ./ Casey_sum_R_i_row_05(i) ).^-1 ;  
        Casey_spr_R_i_full_05(i) = (18 ./ Casey_spr_R_i_row_05(i) ).^-1 ;
        Davis_sum_R_i_full_05(i) = (18 ./ Davis_sum_R_i_row_05(i) ).^-1 ;
        Davis_spr_R_i_full_05(i) = (18 ./ Davis_spr_R_i_row_05(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_05(i) =  (TEG_V_row_Casey_sum_05(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_05(i));     
        TEG_P_Casey_spr_full_05(i) =  (TEG_V_row_Casey_spr_05(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_05(i));     
        TEG_P_Davis_sum_full_05(i) =  (TEG_V_row_Davis_sum_05(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_05(i));    
        TEG_P_Davis_spr_full_05(i) =  (TEG_V_row_Davis_spr_05(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_05(i));
% Case 2
    % Resistance
        Casey_sum_R_i_full_06(i) = (18 ./ Casey_sum_R_i_row_06(i) ).^-1 ;  
        Casey_spr_R_i_full_06(i) = (18 ./ Casey_spr_R_i_row_06(i) ).^-1 ;
        Davis_sum_R_i_full_06(i) = (18 ./ Davis_sum_R_i_row_06(i) ).^-1 ;
        Davis_spr_R_i_full_06(i) = (18 ./ Davis_spr_R_i_row_06(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_06(i) =  (TEG_V_row_Casey_sum_06(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_06(i));     
        TEG_P_Casey_spr_full_06(i) =  (TEG_V_row_Casey_spr_06(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_06(i));     
        TEG_P_Davis_sum_full_06(i) =  (TEG_V_row_Davis_sum_06(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_06(i));    
        TEG_P_Davis_spr_full_06(i) =  (TEG_V_row_Davis_spr_06(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_06(i));
% Case 7
    % Resistance
        Casey_sum_R_i_full_07(i) = (18 ./ Casey_sum_R_i_row_07(i) ).^-1 ;  
        Casey_spr_R_i_full_07(i) = (18 ./ Casey_spr_R_i_row_07(i) ).^-1 ;
        Davis_sum_R_i_full_07(i) = (18 ./ Davis_sum_R_i_row_07(i) ).^-1 ;
        Davis_spr_R_i_full_07(i) = (18 ./ Davis_spr_R_i_row_07(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_07(i) =  (TEG_V_row_Casey_sum_07(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_07(i));     
        TEG_P_Casey_spr_full_07(i) =  (TEG_V_row_Casey_spr_07(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_07(i));     
        TEG_P_Davis_sum_full_07(i) =  (TEG_V_row_Davis_sum_07(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_07(i));    
        TEG_P_Davis_spr_full_07(i) =  (TEG_V_row_Davis_spr_07(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_07(i));
% Case 8
    % Resistance
        Casey_sum_R_i_full_08(i) = (18 ./ Casey_sum_R_i_row_08(i) ).^-1 ;  
        Casey_spr_R_i_full_08(i) = (18 ./ Casey_spr_R_i_row_08(i) ).^-1 ;
        Davis_sum_R_i_full_08(i) = (18 ./ Davis_sum_R_i_row_08(i) ).^-1 ;
        Davis_spr_R_i_full_08(i) = (18 ./ Davis_spr_R_i_row_08(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_08(i) =  (TEG_V_row_Casey_sum_08(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_08(i));     
        TEG_P_Casey_spr_full_08(i) =  (TEG_V_row_Casey_spr_08(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_08(i));     
        TEG_P_Davis_sum_full_08(i) =  (TEG_V_row_Davis_sum_08(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_08(i));    
        TEG_P_Davis_spr_full_08(i) =  (TEG_V_row_Davis_spr_08(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_08(i));
end

%--------------------------------------------------------------------------------------------------------------------------------------------------------%
% [40% Clouds]:[Wind = 5,10,25,50]
% 09:12
TEG_P_Casey_sum_09 = zeros(1,length(t));
TEG_P_Casey_spr_09 = zeros(1,length(t));
TEG_P_Davis_sum_09 = zeros(1,length(t));
TEG_P_Davis_spr_09 = zeros(1,length(t));

TEG_P_Casey_sum_10 = zeros(1,length(t));
TEG_P_Casey_spr_10 = zeros(1,length(t));
TEG_P_Davis_sum_10 = zeros(1,length(t));
TEG_P_Davis_spr_10 = zeros(1,length(t));

TEG_P_Casey_sum_11 = zeros(1,length(t));
TEG_P_Casey_spr_11 = zeros(1,length(t));
TEG_P_Davis_sum_11 = zeros(1,length(t));
TEG_P_Davis_spr_11 = zeros(1,length(t));

TEG_P_Casey_sum_12 = zeros(1,length(t));
TEG_P_Casey_spr_12 = zeros(1,length(t));
TEG_P_Davis_sum_12 = zeros(1,length(t));
TEG_P_Davis_spr_12 = zeros(1,length(t));


for i = 1:48
% Case 1
    TEG_P_Casey_sum_09(i) =  (TEG_V_Casey_sum_09(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_09(i));     
    TEG_P_Casey_spr_09(i) =  (TEG_V_Casey_spr_09(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_09(i));     
    TEG_P_Davis_sum_09(i) =  (TEG_V_Davis_sum_09(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_09(i));    
    TEG_P_Davis_spr_09(i) =  (TEG_V_Davis_spr_09(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_09(i));
% Case 2
    TEG_P_Casey_sum_10(i) =  (TEG_V_Casey_sum_10(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_10(i));     
    TEG_P_Casey_spr_10(i) =  (TEG_V_Casey_spr_10(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_10(i));     
    TEG_P_Davis_sum_10(i) =  (TEG_V_Davis_sum_10(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_10(i));    
    TEG_P_Davis_spr_10(i) =  (TEG_V_Davis_spr_10(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_10(i));
% Case 3
    TEG_P_Casey_sum_11(i) =  (TEG_V_Casey_sum_11(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_11(i));     
    TEG_P_Casey_spr_11(i) =  (TEG_V_Casey_spr_11(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_11(i));     
    TEG_P_Davis_sum_11(i) =  (TEG_V_Davis_sum_11(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_11(i));    
    TEG_P_Davis_spr_11(i) =  (TEG_V_Davis_spr_11(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_11(i));
% Case 4
    TEG_P_Casey_sum_12(i) =  (TEG_V_Casey_sum_12(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_12(i));     
    TEG_P_Casey_spr_12(i) =  (TEG_V_Casey_spr_12(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_12(i));     
    TEG_P_Davis_sum_12(i) =  (TEG_V_Davis_sum_12(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_12(i));    
    TEG_P_Davis_spr_12(i) =  (TEG_V_Davis_spr_12(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_12(i));
end

TEG_V_row_Casey_sum_09 = zeros(1,length(t));
TEG_V_row_Casey_spr_09 = zeros(1,length(t));
TEG_V_row_Davis_sum_09 = zeros(1,length(t));
TEG_V_row_Davis_spr_09 = zeros(1,length(t));

TEG_V_row_Casey_sum_10 = zeros(1,length(t));
TEG_V_row_Casey_spr_10 = zeros(1,length(t));
TEG_V_row_Davis_sum_10 = zeros(1,length(t));
TEG_V_row_Davis_spr_10 = zeros(1,length(t));

TEG_V_row_Casey_sum_11 = zeros(1,length(t));
TEG_V_row_Casey_spr_11 = zeros(1,length(t));
TEG_V_row_Davis_sum_11 = zeros(1,length(t));
TEG_V_row_Davis_spr_11 = zeros(1,length(t));

TEG_V_row_Casey_sum_12 = zeros(1,length(t));
TEG_V_row_Casey_spr_12 = zeros(1,length(t));
TEG_V_row_Davis_sum_12 = zeros(1,length(t));
TEG_V_row_Davis_spr_12 = zeros(1,length(t));

% Ohms - resistance
Casey_sum_R_i_row_09 = zeros(1,length(t)); 
Casey_spr_R_i_row_09 = zeros(1,length(t));
Davis_sum_R_i_row_09 = zeros(1,length(t));
Davis_spr_R_i_row_09 = zeros(1,length(t));

Casey_sum_R_i_row_10 = zeros(1,length(t)); 
Casey_spr_R_i_row_10 = zeros(1,length(t));
Davis_sum_R_i_row_10 = zeros(1,length(t));
Davis_spr_R_i_row_10 = zeros(1,length(t));

Casey_sum_R_i_row_11 = zeros(1,length(t)); 
Casey_spr_R_i_row_11 = zeros(1,length(t));
Davis_sum_R_i_row_11 = zeros(1,length(t));
Davis_spr_R_i_row_11 = zeros(1,length(t));

Casey_sum_R_i_row_12 = zeros(1,length(t)); 
Casey_spr_R_i_row_12 = zeros(1,length(t));
Davis_sum_R_i_row_12 = zeros(1,length(t));
Davis_spr_R_i_row_12 = zeros(1,length(t));

% Currents
Casey_sum_amps_row_09 = zeros(1,length(t)); 
Casey_spr_amps_row_09 = zeros(1,length(t));    
Davis_sum_amps_row_09 = zeros(1,length(t));
Davis_spr_amps_row_09 = zeros(1,length(t));

Casey_sum_amps_row_10 = zeros(1,length(t)); 
Casey_spr_amps_row_10 = zeros(1,length(t));    
Davis_sum_amps_row_10 = zeros(1,length(t));
Davis_spr_amps_row_10 = zeros(1,length(t));

Casey_sum_amps_row_11 = zeros(1,length(t)); 
Casey_spr_amps_row_11 = zeros(1,length(t));    
Davis_sum_amps_row_11 = zeros(1,length(t));
Davis_spr_amps_row_11 = zeros(1,length(t));

Casey_sum_amps_row_12 = zeros(1,length(t)); 
Casey_spr_amps_row_12 = zeros(1,length(t));    
Davis_sum_amps_row_12 = zeros(1,length(t));
Davis_spr_amps_row_12 = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Case 5
    % Voltages   
    TEG_V_row_Casey_sum_09(i) = TEG_V_Casey_sum_09(i) .* 17; 
    TEG_V_row_Casey_spr_09(i) = TEG_V_Casey_spr_09(i) .* 17;     
    TEG_V_row_Davis_sum_09(i) = TEG_V_Davis_sum_09(i) .* 17; 
    TEG_V_row_Davis_spr_09(i) = TEG_V_Davis_spr_09(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_09(i) = Casey_sum_R_i_09(i) .* 17;
    Casey_spr_R_i_row_09(i) = Casey_spr_R_i_09(i) .* 17;    
    Davis_sum_R_i_row_09(i) = Davis_sum_R_i_09(i) .* 17;
    Davis_spr_R_i_row_09(i) = Davis_spr_R_i_09(i) .* 17;

    % Currents
    Casey_sum_amps_row_09(i) = TEG_V_row_Casey_sum_09(i) ./ ...
        Casey_sum_R_i_row_09(i);
    Casey_spr_amps_row_09(i) = TEG_V_row_Casey_spr_09(i) ./ ...
        Casey_spr_R_i_row_09(i);    
    Davis_sum_amps_row_09(i) = TEG_V_row_Davis_sum_09(i) ./ ...
        Davis_sum_R_i_row_09(i);
    Davis_spr_amps_row_09(i) = TEG_V_row_Davis_spr_09(i) ./ ...
        Davis_spr_R_i_row_09(i);

% Case 10
    % Voltages   
    TEG_V_row_Casey_sum_10(i) = TEG_V_Casey_sum_10(i) .* 17; 
    TEG_V_row_Casey_spr_10(i) = TEG_V_Casey_spr_10(i) .* 17;     
    TEG_V_row_Davis_sum_10(i) = TEG_V_Davis_sum_10(i) .* 17; 
    TEG_V_row_Davis_spr_10(i) = TEG_V_Davis_spr_10(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_10(i) = Casey_sum_R_i_10(i) .* 17;
    Casey_spr_R_i_row_10(i) = Casey_spr_R_i_10(i) .* 17;    
    Davis_sum_R_i_row_10(i) = Davis_sum_R_i_10(i) .* 17;
    Davis_spr_R_i_row_10(i) = Davis_spr_R_i_10(i) .* 17;

    % Currents
    Casey_sum_amps_row_10(i) = TEG_V_row_Casey_sum_10(i) ./ ...
        Casey_sum_R_i_row_10(i);
    Casey_spr_amps_row_10(i) = TEG_V_row_Casey_spr_10(i) ./ ...
        Casey_spr_R_i_row_10(i);    
    Davis_sum_amps_row_10(i) = TEG_V_row_Davis_sum_10(i) ./ ...
        Davis_sum_R_i_row_10(i);
    Davis_spr_amps_row_10(i) = TEG_V_row_Davis_spr_10(i) ./ ...
        Davis_spr_R_i_row_10(i);
% Case 7
    % Voltages   
    TEG_V_row_Casey_sum_11(i) = TEG_V_Casey_sum_11(i) .* 17; 
    TEG_V_row_Casey_spr_11(i) = TEG_V_Casey_spr_11(i) .* 17;     
    TEG_V_row_Davis_sum_11(i) = TEG_V_Davis_sum_11(i) .* 17; 
    TEG_V_row_Davis_spr_11(i) = TEG_V_Davis_spr_11(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_11(i) = Casey_sum_R_i_11(i) .* 17;
    Casey_spr_R_i_row_11(i) = Casey_spr_R_i_11(i) .* 17;    
    Davis_sum_R_i_row_11(i) = Davis_sum_R_i_11(i) .* 17;
    Davis_spr_R_i_row_11(i) = Davis_spr_R_i_11(i) .* 17;

    % Currents
    Casey_sum_amps_row_11(i) = TEG_V_row_Casey_sum_11(i) ./ ...
        Casey_sum_R_i_row_11(i);
    Casey_spr_amps_row_11(i) = TEG_V_row_Casey_spr_11(i) ./ ...
        Casey_spr_R_i_row_11(i);    
    Davis_sum_amps_row_11(i) = TEG_V_row_Davis_sum_11(i) ./ ...
        Davis_sum_R_i_row_11(i);
    Davis_spr_amps_row_11(i) = TEG_V_row_Davis_spr_11(i) ./ ...
        Davis_spr_R_i_row_11(i);
% Case 8
    % Voltages   
    TEG_V_row_Casey_sum_12(i) = TEG_V_Casey_sum_12(i) .* 17; 
    TEG_V_row_Casey_spr_12(i) = TEG_V_Casey_spr_12(i) .* 17;     
    TEG_V_row_Davis_sum_12(i) = TEG_V_Davis_sum_12(i) .* 17; 
    TEG_V_row_Davis_spr_12(i) = TEG_V_Davis_spr_12(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_12(i) = Casey_sum_R_i_12(i) .* 17;
    Casey_spr_R_i_row_12(i) = Casey_spr_R_i_12(i) .* 17;    
    Davis_sum_R_i_row_12(i) = Davis_sum_R_i_12(i) .* 17;
    Davis_spr_R_i_row_12(i) = Davis_spr_R_i_12(i) .* 17;

    % Currents
    Casey_sum_amps_row_12(i) = TEG_V_row_Casey_sum_12(i) ./ ...
        Casey_sum_R_i_row_12(i);
    Casey_spr_amps_row_12(i) = TEG_V_row_Casey_spr_12(i) ./ ...
        Casey_spr_R_i_row_12(i);    
    Davis_sum_amps_row_12(i) = TEG_V_row_Davis_sum_12(i) ./ ...
        Davis_sum_R_i_row_12(i);
    Davis_spr_amps_row_12(i) = TEG_V_row_Davis_spr_12(i) ./ ...
        Davis_spr_R_i_row_12(i);
end

% FOR 1 SOLAR PANEL - in parallel aray 
% 18 rows of 17 modules 
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)

% Resistance
    Casey_sum_R_i_full_09 = zeros(1,length(t)); 
    Casey_spr_R_i_full_09 = zeros(1,length(t));
    Davis_sum_R_i_full_09 = zeros(1,length(t));
    Davis_spr_R_i_full_09 = zeros(1,length(t));

    Casey_sum_R_i_full_10 = zeros(1,length(t)); 
    Casey_spr_R_i_full_10 = zeros(1,length(t));
    Davis_sum_R_i_full_10 = zeros(1,length(t));
    Davis_spr_R_i_full_10 = zeros(1,length(t));

    Casey_sum_R_i_full_11 = zeros(1,length(t));
    Casey_spr_R_i_full_11 = zeros(1,length(t));
    Davis_sum_R_i_full_11 = zeros(1,length(t));
    Davis_spr_R_i_full_11 = zeros(1,length(t));

    Casey_sum_R_i_full_12 = zeros(1,length(t)); 
    Casey_spr_R_i_full_12 = zeros(1,length(t));
    Davis_sum_R_i_full_12 = zeros(1,length(t));
    Davis_spr_R_i_full_12 = zeros(1,length(t));

% Power
    TEG_P_Casey_sum_full_09 = zeros(1,length(t));
    TEG_P_Casey_spr_full_09 = zeros(1,length(t));
    TEG_P_Davis_sum_full_09 = zeros(1,length(t));
    TEG_P_Davis_spr_full_09 = zeros(1,length(t));

    TEG_P_Casey_sum_full_10 = zeros(1,length(t));
    TEG_P_Casey_spr_full_10 = zeros(1,length(t));
    TEG_P_Davis_sum_full_10 = zeros(1,length(t));
    TEG_P_Davis_spr_full_10 = zeros(1,length(t));

    TEG_P_Casey_sum_full_11 = zeros(1,length(t));
    TEG_P_Casey_spr_full_11 = zeros(1,length(t));
    TEG_P_Davis_sum_full_11 = zeros(1,length(t));
    TEG_P_Davis_spr_full_11 = zeros(1,length(t));

    TEG_P_Casey_sum_full_12 = zeros(1,length(t));
    TEG_P_Casey_spr_full_12 = zeros(1,length(t));
    TEG_P_Davis_sum_full_12 = zeros(1,length(t));
    TEG_P_Davis_spr_full_12 = zeros(1,length(t));


% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Case 1
    % Resistance
        Casey_sum_R_i_full_09(i) = (18 ./ Casey_sum_R_i_row_09(i) ).^-1 ;  
        Casey_spr_R_i_full_09(i) = (18 ./ Casey_spr_R_i_row_09(i) ).^-1 ;
        Davis_sum_R_i_full_09(i) = (18 ./ Davis_sum_R_i_row_09(i) ).^-1 ;
        Davis_spr_R_i_full_09(i) = (18 ./ Davis_spr_R_i_row_09(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_09(i) =  (TEG_V_row_Casey_sum_09(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_09(i));     
        TEG_P_Casey_spr_full_09(i) =  (TEG_V_row_Casey_spr_09(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_09(i));     
        TEG_P_Davis_sum_full_09(i) =  (TEG_V_row_Davis_sum_09(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_09(i));    
        TEG_P_Davis_spr_full_09(i) =  (TEG_V_row_Davis_spr_09(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_09(i));
% Case 2
    % Resistance
        Casey_sum_R_i_full_10(i) = (18 ./ Casey_sum_R_i_row_10(i) ).^-1 ;  
        Casey_spr_R_i_full_10(i) = (18 ./ Casey_spr_R_i_row_10(i) ).^-1 ;
        Davis_sum_R_i_full_10(i) = (18 ./ Davis_sum_R_i_row_10(i) ).^-1 ;
        Davis_spr_R_i_full_10(i) = (18 ./ Davis_spr_R_i_row_10(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_10(i) =  (TEG_V_row_Casey_sum_10(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_10(i));     
        TEG_P_Casey_spr_full_10(i) =  (TEG_V_row_Casey_spr_10(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_10(i));     
        TEG_P_Davis_sum_full_10(i) =  (TEG_V_row_Davis_sum_10(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_10(i));    
        TEG_P_Davis_spr_full_10(i) =  (TEG_V_row_Davis_spr_10(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_10(i));
% Case 3
    % Resistance
        Casey_sum_R_i_full_11(i) = (18 ./ Casey_sum_R_i_row_11(i) ).^-1 ;  
        Casey_spr_R_i_full_11(i) = (18 ./ Casey_spr_R_i_row_11(i) ).^-1 ;
        Davis_sum_R_i_full_11(i) = (18 ./ Davis_sum_R_i_row_11(i) ).^-1 ;
        Davis_spr_R_i_full_11(i) = (18 ./ Davis_spr_R_i_row_11(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_11(i) =  (TEG_V_row_Casey_sum_11(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_11(i));     
        TEG_P_Casey_spr_full_11(i) =  (TEG_V_row_Casey_spr_11(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_11(i));     
        TEG_P_Davis_sum_full_11(i) =  (TEG_V_row_Davis_sum_11(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_11(i));    
        TEG_P_Davis_spr_full_11(i) =  (TEG_V_row_Davis_spr_11(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_11(i));
% Case 4
    % Resistance
        Casey_sum_R_i_full_12(i) = (18 ./ Casey_sum_R_i_row_12(i) ).^-1 ;  
        Casey_spr_R_i_full_12(i) = (18 ./ Casey_spr_R_i_row_12(i) ).^-1 ;
        Davis_sum_R_i_full_12(i) = (18 ./ Davis_sum_R_i_row_12(i) ).^-1 ;
        Davis_spr_R_i_full_12(i) = (18 ./ Davis_spr_R_i_row_12(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_12(i) =  (TEG_V_row_Casey_sum_12(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_12(i));     
        TEG_P_Casey_spr_full_12(i) =  (TEG_V_row_Casey_spr_12(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_12(i));     
        TEG_P_Davis_sum_full_12(i) =  (TEG_V_row_Davis_sum_12(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_12(i));    
        TEG_P_Davis_spr_full_12(i) =  (TEG_V_row_Davis_spr_12(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_12(i));
end


%----------------------------------------------------------------------------%
    % [60% Clouds]:[Wind = 5,10,25,50]
    % 13:16
TEG_P_Casey_sum_13 = zeros(1,length(t));
TEG_P_Casey_spr_13 = zeros(1,length(t));
TEG_P_Davis_sum_13 = zeros(1,length(t));
TEG_P_Davis_spr_13 = zeros(1,length(t));

TEG_P_Casey_sum_14 = zeros(1,length(t));
TEG_P_Casey_spr_14 = zeros(1,length(t));
TEG_P_Davis_sum_14 = zeros(1,length(t));
TEG_P_Davis_spr_14 = zeros(1,length(t));

TEG_P_Casey_sum_15 = zeros(1,length(t));
TEG_P_Casey_spr_15 = zeros(1,length(t));
TEG_P_Davis_sum_15 = zeros(1,length(t));
TEG_P_Davis_spr_15 = zeros(1,length(t));

TEG_P_Casey_sum_16 = zeros(1,length(t));
TEG_P_Casey_spr_16 = zeros(1,length(t));
TEG_P_Davis_sum_16 = zeros(1,length(t));
TEG_P_Davis_spr_16 = zeros(1,length(t));


for i = 1:48
% Case 1
    TEG_P_Casey_sum_13(i) =  (TEG_V_Casey_sum_13(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_13(i));     
    TEG_P_Casey_spr_13(i) =  (TEG_V_Casey_spr_13(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_13(i));     
    TEG_P_Davis_sum_13(i) =  (TEG_V_Davis_sum_13(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_13(i));    
    TEG_P_Davis_spr_13(i) =  (TEG_V_Davis_spr_13(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_13(i));
% Case 2
    TEG_P_Casey_sum_14(i) =  (TEG_V_Casey_sum_14(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_14(i));     
    TEG_P_Casey_spr_14(i) =  (TEG_V_Casey_spr_14(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_14(i));     
    TEG_P_Davis_sum_14(i) =  (TEG_V_Davis_sum_14(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_14(i));    
    TEG_P_Davis_spr_14(i) =  (TEG_V_Davis_spr_14(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_14(i));
% Case 3
    TEG_P_Casey_sum_15(i) =  (TEG_V_Casey_sum_15(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_15(i));     
    TEG_P_Casey_spr_15(i) =  (TEG_V_Casey_spr_15(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_15(i));     
    TEG_P_Davis_sum_15(i) =  (TEG_V_Davis_sum_15(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_15(i));    
    TEG_P_Davis_spr_15(i) =  (TEG_V_Davis_spr_15(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_15(i));
% Case 4
    TEG_P_Casey_sum_16(i) =  (TEG_V_Casey_sum_16(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_16(i));     
    TEG_P_Casey_spr_16(i) =  (TEG_V_Casey_spr_16(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_16(i));     
    TEG_P_Davis_sum_16(i) =  (TEG_V_Davis_sum_16(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_16(i));    
    TEG_P_Davis_spr_16(i) =  (TEG_V_Davis_spr_16(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_16(i));
end

TEG_V_row_Casey_sum_13 = zeros(1,length(t));
TEG_V_row_Casey_spr_13 = zeros(1,length(t));
TEG_V_row_Davis_sum_13 = zeros(1,length(t));
TEG_V_row_Davis_spr_13 = zeros(1,length(t));

TEG_V_row_Casey_sum_14 = zeros(1,length(t));
TEG_V_row_Casey_spr_14 = zeros(1,length(t));
TEG_V_row_Davis_sum_14 = zeros(1,length(t));
TEG_V_row_Davis_spr_14 = zeros(1,length(t));

TEG_V_row_Casey_sum_15 = zeros(1,length(t));
TEG_V_row_Casey_spr_15 = zeros(1,length(t));
TEG_V_row_Davis_sum_15 = zeros(1,length(t));
TEG_V_row_Davis_spr_15 = zeros(1,length(t));

TEG_V_row_Casey_sum_16 = zeros(1,length(t));
TEG_V_row_Casey_spr_16 = zeros(1,length(t));
TEG_V_row_Davis_sum_16 = zeros(1,length(t));
TEG_V_row_Davis_spr_16 = zeros(1,length(t));

% Ohms - resistance
Casey_sum_R_i_row_13 = zeros(1,length(t)); 
Casey_spr_R_i_row_13 = zeros(1,length(t));
Davis_sum_R_i_row_13 = zeros(1,length(t));
Davis_spr_R_i_row_13 = zeros(1,length(t));

Casey_sum_R_i_row_14 = zeros(1,length(t)); 
Casey_spr_R_i_row_14 = zeros(1,length(t));
Davis_sum_R_i_row_14 = zeros(1,length(t));
Davis_spr_R_i_row_14 = zeros(1,length(t));

Casey_sum_R_i_row_15 = zeros(1,length(t)); 
Casey_spr_R_i_row_15 = zeros(1,length(t));
Davis_sum_R_i_row_15 = zeros(1,length(t));
Davis_spr_R_i_row_15 = zeros(1,length(t));

Casey_sum_R_i_row_16 = zeros(1,length(t)); 
Casey_spr_R_i_row_16 = zeros(1,length(t));
Davis_sum_R_i_row_16 = zeros(1,length(t));
Davis_spr_R_i_row_16 = zeros(1,length(t));

% Currents
Casey_sum_amps_row_13 = zeros(1,length(t)); 
Casey_spr_amps_row_13 = zeros(1,length(t));    
Davis_sum_amps_row_13 = zeros(1,length(t));
Davis_spr_amps_row_13 = zeros(1,length(t));

Casey_sum_amps_row_14 = zeros(1,length(t)); 
Casey_spr_amps_row_14 = zeros(1,length(t));    
Davis_sum_amps_row_14 = zeros(1,length(t));
Davis_spr_amps_row_14 = zeros(1,length(t));

Casey_sum_amps_row_15 = zeros(1,length(t)); 
Casey_spr_amps_row_15 = zeros(1,length(t));    
Davis_sum_amps_row_15 = zeros(1,length(t));
Davis_spr_amps_row_15 = zeros(1,length(t));

Casey_sum_amps_row_16 = zeros(1,length(t)); 
Casey_spr_amps_row_16 = zeros(1,length(t));    
Davis_sum_amps_row_16 = zeros(1,length(t));
Davis_spr_amps_row_16 = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Case 5
    % Voltages   
    TEG_V_row_Casey_sum_13(i) = TEG_V_Casey_sum_13(i) .* 17; 
    TEG_V_row_Casey_spr_13(i) = TEG_V_Casey_spr_13(i) .* 17;     
    TEG_V_row_Davis_sum_13(i) = TEG_V_Davis_sum_13(i) .* 17; 
    TEG_V_row_Davis_spr_13(i) = TEG_V_Davis_spr_13(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_13(i) = Casey_sum_R_i_13(i) .* 17;
    Casey_spr_R_i_row_13(i) = Casey_spr_R_i_13(i) .* 17;    
    Davis_sum_R_i_row_13(i) = Davis_sum_R_i_13(i) .* 17;
    Davis_spr_R_i_row_13(i) = Davis_spr_R_i_13(i) .* 17;

    % Currents
    Casey_sum_amps_row_13(i) = TEG_V_row_Casey_sum_13(i) ./ ...
        Casey_sum_R_i_row_13(i);
    Casey_spr_amps_row_13(i) = TEG_V_row_Casey_spr_13(i) ./ ...
        Casey_spr_R_i_row_13(i);    
    Davis_sum_amps_row_13(i) = TEG_V_row_Davis_sum_13(i) ./ ...
        Davis_sum_R_i_row_13(i);
    Davis_spr_amps_row_13(i) = TEG_V_row_Davis_spr_13(i) ./ ...
        Davis_spr_R_i_row_13(i);

% Case 10
    % Voltages   
    TEG_V_row_Casey_sum_14(i) = TEG_V_Casey_sum_14(i) .* 17; 
    TEG_V_row_Casey_spr_14(i) = TEG_V_Casey_spr_14(i) .* 17;     
    TEG_V_row_Davis_sum_14(i) = TEG_V_Davis_sum_14(i) .* 17; 
    TEG_V_row_Davis_spr_14(i) = TEG_V_Davis_spr_14(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_14(i) = Casey_sum_R_i_14(i) .* 17;
    Casey_spr_R_i_row_14(i) = Casey_spr_R_i_14(i) .* 17;    
    Davis_sum_R_i_row_14(i) = Davis_sum_R_i_14(i) .* 17;
    Davis_spr_R_i_row_14(i) = Davis_spr_R_i_14(i) .* 17;

    % Currents
    Casey_sum_amps_row_14(i) = TEG_V_row_Casey_sum_14(i) ./ ...
        Casey_sum_R_i_row_14(i);
    Casey_spr_amps_row_14(i) = TEG_V_row_Casey_spr_14(i) ./ ...
        Casey_spr_R_i_row_14(i);    
    Davis_sum_amps_row_14(i) = TEG_V_row_Davis_sum_14(i) ./ ...
        Davis_sum_R_i_row_14(i);
    Davis_spr_amps_row_14(i) = TEG_V_row_Davis_spr_14(i) ./ ...
        Davis_spr_R_i_row_14(i);
% Case 7
    % Voltages   
    TEG_V_row_Casey_sum_15(i) = TEG_V_Casey_sum_15(i) .* 17; 
    TEG_V_row_Casey_spr_15(i) = TEG_V_Casey_spr_15(i) .* 17;     
    TEG_V_row_Davis_sum_15(i) = TEG_V_Davis_sum_15(i) .* 17; 
    TEG_V_row_Davis_spr_15(i) = TEG_V_Davis_spr_15(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_15(i) = Casey_sum_R_i_15(i) .* 17;
    Casey_spr_R_i_row_15(i) = Casey_spr_R_i_15(i) .* 17;    
    Davis_sum_R_i_row_15(i) = Davis_sum_R_i_15(i) .* 17;
    Davis_spr_R_i_row_15(i) = Davis_spr_R_i_15(i) .* 17;

    % Currents
    Casey_sum_amps_row_15(i) = TEG_V_row_Casey_sum_15(i) ./ ...
        Casey_sum_R_i_row_15(i);
    Casey_spr_amps_row_15(i) = TEG_V_row_Casey_spr_15(i) ./ ...
        Casey_spr_R_i_row_15(i);    
    Davis_sum_amps_row_15(i) = TEG_V_row_Davis_sum_15(i) ./ ...
        Davis_sum_R_i_row_15(i);
    Davis_spr_amps_row_15(i) = TEG_V_row_Davis_spr_15(i) ./ ...
        Davis_spr_R_i_row_15(i);
% Case 8
    % Voltages   
    TEG_V_row_Casey_sum_16(i) = TEG_V_Casey_sum_16(i) .* 17; 
    TEG_V_row_Casey_spr_16(i) = TEG_V_Casey_spr_16(i) .* 17;     
    TEG_V_row_Davis_sum_16(i) = TEG_V_Davis_sum_16(i) .* 17; 
    TEG_V_row_Davis_spr_16(i) = TEG_V_Davis_spr_16(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_16(i) = Casey_sum_R_i_16(i) .* 17;
    Casey_spr_R_i_row_16(i) = Casey_spr_R_i_16(i) .* 17;    
    Davis_sum_R_i_row_16(i) = Davis_sum_R_i_16(i) .* 17;
    Davis_spr_R_i_row_16(i) = Davis_spr_R_i_16(i) .* 17;

    % Currents
    Casey_sum_amps_row_16(i) = TEG_V_row_Casey_sum_16(i) ./ ...
        Casey_sum_R_i_row_16(i);
    Casey_spr_amps_row_16(i) = TEG_V_row_Casey_spr_16(i) ./ ...
        Casey_spr_R_i_row_16(i);    
    Davis_sum_amps_row_16(i) = TEG_V_row_Davis_sum_16(i) ./ ...
        Davis_sum_R_i_row_16(i);
    Davis_spr_amps_row_16(i) = TEG_V_row_Davis_spr_16(i) ./ ...
        Davis_spr_R_i_row_16(i);
end

% FOR 1 SOLAR PANEL - in parallel aray 
% 18 rows of 17 modules 
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)

% Resistance
    Casey_sum_R_i_full_13 = zeros(1,length(t)); 
    Casey_spr_R_i_full_13 = zeros(1,length(t));
    Davis_sum_R_i_full_13 = zeros(1,length(t));
    Davis_spr_R_i_full_13 = zeros(1,length(t));

    Casey_sum_R_i_full_14 = zeros(1,length(t)); 
    Casey_spr_R_i_full_14 = zeros(1,length(t));
    Davis_sum_R_i_full_14 = zeros(1,length(t));
    Davis_spr_R_i_full_14 = zeros(1,length(t));

    Casey_sum_R_i_full_15 = zeros(1,length(t));
    Casey_spr_R_i_full_15 = zeros(1,length(t));
    Davis_sum_R_i_full_15 = zeros(1,length(t));
    Davis_spr_R_i_full_15 = zeros(1,length(t));

    Casey_sum_R_i_full_16 = zeros(1,length(t)); 
    Casey_spr_R_i_full_16 = zeros(1,length(t));
    Davis_sum_R_i_full_16 = zeros(1,length(t));
    Davis_spr_R_i_full_16 = zeros(1,length(t));

% Power
    TEG_P_Casey_sum_full_13 = zeros(1,length(t));
    TEG_P_Casey_spr_full_13 = zeros(1,length(t));
    TEG_P_Davis_sum_full_13 = zeros(1,length(t));
    TEG_P_Davis_spr_full_13 = zeros(1,length(t));

    TEG_P_Casey_sum_full_14 = zeros(1,length(t));
    TEG_P_Casey_spr_full_14 = zeros(1,length(t));
    TEG_P_Davis_sum_full_14 = zeros(1,length(t));
    TEG_P_Davis_spr_full_14 = zeros(1,length(t));

    TEG_P_Casey_sum_full_15 = zeros(1,length(t));
    TEG_P_Casey_spr_full_15 = zeros(1,length(t));
    TEG_P_Davis_sum_full_15 = zeros(1,length(t));
    TEG_P_Davis_spr_full_15 = zeros(1,length(t));

    TEG_P_Casey_sum_full_16 = zeros(1,length(t));
    TEG_P_Casey_spr_full_16 = zeros(1,length(t));
    TEG_P_Davis_sum_full_16 = zeros(1,length(t));
    TEG_P_Davis_spr_full_16 = zeros(1,length(t));


% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Case 1
    % Resistance
        Casey_sum_R_i_full_13(i) = (18 ./ Casey_sum_R_i_row_13(i) ).^-1 ;  
        Casey_spr_R_i_full_13(i) = (18 ./ Casey_spr_R_i_row_13(i) ).^-1 ;
        Davis_sum_R_i_full_13(i) = (18 ./ Davis_sum_R_i_row_13(i) ).^-1 ;
        Davis_spr_R_i_full_13(i) = (18 ./ Davis_spr_R_i_row_13(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_13(i) =  (TEG_V_row_Casey_sum_13(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_13(i));     
        TEG_P_Casey_spr_full_13(i) =  (TEG_V_row_Casey_spr_13(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_13(i));     
        TEG_P_Davis_sum_full_13(i) =  (TEG_V_row_Davis_sum_13(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_13(i));    
        TEG_P_Davis_spr_full_13(i) =  (TEG_V_row_Davis_spr_13(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_13(i));
% Case 2
    % Resistance
        Casey_sum_R_i_full_14(i) = (18 ./ Casey_sum_R_i_row_14(i) ).^-1 ;  
        Casey_spr_R_i_full_14(i) = (18 ./ Casey_spr_R_i_row_14(i) ).^-1 ;
        Davis_sum_R_i_full_14(i) = (18 ./ Davis_sum_R_i_row_14(i) ).^-1 ;
        Davis_spr_R_i_full_14(i) = (18 ./ Davis_spr_R_i_row_14(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_14(i) =  (TEG_V_row_Casey_sum_14(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_14(i));     
        TEG_P_Casey_spr_full_14(i) =  (TEG_V_row_Casey_spr_14(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_14(i));     
        TEG_P_Davis_sum_full_14(i) =  (TEG_V_row_Davis_sum_14(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_14(i));    
        TEG_P_Davis_spr_full_14(i) =  (TEG_V_row_Davis_spr_14(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_14(i));
% Case 3
    % Resistance
        Casey_sum_R_i_full_15(i) = (18 ./ Casey_sum_R_i_row_15(i) ).^-1 ;  
        Casey_spr_R_i_full_15(i) = (18 ./ Casey_spr_R_i_row_15(i) ).^-1 ;
        Davis_sum_R_i_full_15(i) = (18 ./ Davis_sum_R_i_row_15(i) ).^-1 ;
        Davis_spr_R_i_full_15(i) = (18 ./ Davis_spr_R_i_row_15(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_15(i) =  (TEG_V_row_Casey_sum_15(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_15(i));     
        TEG_P_Casey_spr_full_15(i) =  (TEG_V_row_Casey_spr_15(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_15(i));     
        TEG_P_Davis_sum_full_15(i) =  (TEG_V_row_Davis_sum_15(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_15(i));    
        TEG_P_Davis_spr_full_15(i) =  (TEG_V_row_Davis_spr_15(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_15(i));
% Case 4
    % Resistance
        Casey_sum_R_i_full_16(i) = (18 ./ Casey_sum_R_i_row_16(i) ).^-1 ;  
        Casey_spr_R_i_full_16(i) = (18 ./ Casey_spr_R_i_row_16(i) ).^-1 ;
        Davis_sum_R_i_full_16(i) = (18 ./ Davis_sum_R_i_row_16(i) ).^-1 ;
        Davis_spr_R_i_full_16(i) = (18 ./ Davis_spr_R_i_row_16(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_16(i) =  (TEG_V_row_Casey_sum_16(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_16(i));     
        TEG_P_Casey_spr_full_16(i) =  (TEG_V_row_Casey_spr_16(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_16(i));     
        TEG_P_Davis_sum_full_16(i) =  (TEG_V_row_Davis_sum_16(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_16(i));    
        TEG_P_Davis_spr_full_16(i) =  (TEG_V_row_Davis_spr_16(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_16(i));
end


%----------------------------------------------------------------------------%
    % [80% Clouds]:[Wind = 5,10,25,50]
    % 17:20
TEG_P_Casey_sum_17 = zeros(1,length(t));
TEG_P_Casey_spr_17 = zeros(1,length(t));
TEG_P_Davis_sum_17 = zeros(1,length(t));
TEG_P_Davis_spr_17 = zeros(1,length(t));

TEG_P_Casey_sum_18 = zeros(1,length(t));
TEG_P_Casey_spr_18 = zeros(1,length(t));
TEG_P_Davis_sum_18 = zeros(1,length(t));
TEG_P_Davis_spr_18 = zeros(1,length(t));

TEG_P_Casey_sum_19 = zeros(1,length(t));
TEG_P_Casey_spr_19 = zeros(1,length(t));
TEG_P_Davis_sum_19 = zeros(1,length(t));
TEG_P_Davis_spr_19 = zeros(1,length(t));

TEG_P_Casey_sum_20 = zeros(1,length(t));
TEG_P_Casey_spr_20 = zeros(1,length(t));
TEG_P_Davis_sum_20 = zeros(1,length(t));
TEG_P_Davis_spr_20 = zeros(1,length(t));


for i = 1:48
% Case 1
    TEG_P_Casey_sum_17(i) =  (TEG_V_Casey_sum_17(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_17(i));     
    TEG_P_Casey_spr_17(i) =  (TEG_V_Casey_spr_17(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_17(i));     
    TEG_P_Davis_sum_17(i) =  (TEG_V_Davis_sum_17(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_17(i));    
    TEG_P_Davis_spr_17(i) =  (TEG_V_Davis_spr_17(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_17(i));
% Case 2
    TEG_P_Casey_sum_18(i) =  (TEG_V_Casey_sum_18(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_18(i));     
    TEG_P_Casey_spr_18(i) =  (TEG_V_Casey_spr_18(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_18(i));     
    TEG_P_Davis_sum_18(i) =  (TEG_V_Davis_sum_18(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_18(i));    
    TEG_P_Davis_spr_18(i) =  (TEG_V_Davis_spr_18(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_18(i));
% Case 3
    TEG_P_Casey_sum_19(i) =  (TEG_V_Casey_sum_19(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_19(i));     
    TEG_P_Casey_spr_19(i) =  (TEG_V_Casey_spr_19(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_19(i));     
    TEG_P_Davis_sum_19(i) =  (TEG_V_Davis_sum_19(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_19(i));    
    TEG_P_Davis_spr_19(i) =  (TEG_V_Davis_spr_19(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_19(i));
% Case 4
    TEG_P_Casey_sum_20(i) =  (TEG_V_Casey_sum_20(i).^(2)) ./ ...
                          (4 .* Casey_sum_R_i_20(i));     
    TEG_P_Casey_spr_20(i) =  (TEG_V_Casey_spr_20(i).^(2)) ./ ...
                          (4 .* Casey_spr_R_i_20(i));     
    TEG_P_Davis_sum_20(i) =  (TEG_V_Davis_sum_20(i).^(2)) ./ ...
                          (4 .* Davis_sum_R_i_20(i));    
    TEG_P_Davis_spr_20(i) =  (TEG_V_Davis_spr_20(i).^(2)) ./ ...
                          (4 .* Davis_spr_R_i_20(i));
end

TEG_V_row_Casey_sum_17 = zeros(1,length(t));
TEG_V_row_Casey_spr_17 = zeros(1,length(t));
TEG_V_row_Davis_sum_17 = zeros(1,length(t));
TEG_V_row_Davis_spr_17 = zeros(1,length(t));

TEG_V_row_Casey_sum_18 = zeros(1,length(t));
TEG_V_row_Casey_spr_18 = zeros(1,length(t));
TEG_V_row_Davis_sum_18 = zeros(1,length(t));
TEG_V_row_Davis_spr_18 = zeros(1,length(t));

TEG_V_row_Casey_sum_19 = zeros(1,length(t));
TEG_V_row_Casey_spr_19 = zeros(1,length(t));
TEG_V_row_Davis_sum_19 = zeros(1,length(t));
TEG_V_row_Davis_spr_19 = zeros(1,length(t));

TEG_V_row_Casey_sum_20 = zeros(1,length(t));
TEG_V_row_Casey_spr_20 = zeros(1,length(t));
TEG_V_row_Davis_sum_20 = zeros(1,length(t));
TEG_V_row_Davis_spr_20 = zeros(1,length(t));

% Ohms - resistance
Casey_sum_R_i_row_17 = zeros(1,length(t)); 
Casey_spr_R_i_row_17 = zeros(1,length(t));
Davis_sum_R_i_row_17 = zeros(1,length(t));
Davis_spr_R_i_row_17 = zeros(1,length(t));

Casey_sum_R_i_row_18 = zeros(1,length(t)); 
Casey_spr_R_i_row_18 = zeros(1,length(t));
Davis_sum_R_i_row_18 = zeros(1,length(t));
Davis_spr_R_i_row_18 = zeros(1,length(t));

Casey_sum_R_i_row_19 = zeros(1,length(t)); 
Casey_spr_R_i_row_19 = zeros(1,length(t));
Davis_sum_R_i_row_19 = zeros(1,length(t));
Davis_spr_R_i_row_19 = zeros(1,length(t));

Casey_sum_R_i_row_20 = zeros(1,length(t)); 
Casey_spr_R_i_row_20 = zeros(1,length(t));
Davis_sum_R_i_row_20 = zeros(1,length(t));
Davis_spr_R_i_row_20 = zeros(1,length(t));

% Currents
Casey_sum_amps_row_17 = zeros(1,length(t)); 
Casey_spr_amps_row_17 = zeros(1,length(t));    
Davis_sum_amps_row_17 = zeros(1,length(t));
Davis_spr_amps_row_17 = zeros(1,length(t));

Casey_sum_amps_row_18 = zeros(1,length(t)); 
Casey_spr_amps_row_18 = zeros(1,length(t));    
Davis_sum_amps_row_18 = zeros(1,length(t));
Davis_spr_amps_row_18 = zeros(1,length(t));

Casey_sum_amps_row_19 = zeros(1,length(t)); 
Casey_spr_amps_row_19 = zeros(1,length(t));    
Davis_sum_amps_row_19 = zeros(1,length(t));
Davis_spr_amps_row_19 = zeros(1,length(t));

Casey_sum_amps_row_20 = zeros(1,length(t)); 
Casey_spr_amps_row_20 = zeros(1,length(t));    
Davis_sum_amps_row_20 = zeros(1,length(t));
Davis_spr_amps_row_20 = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Case 5
    % Voltages   
    TEG_V_row_Casey_sum_17(i) = TEG_V_Casey_sum_17(i) .* 17; 
    TEG_V_row_Casey_spr_17(i) = TEG_V_Casey_spr_17(i) .* 17;     
    TEG_V_row_Davis_sum_17(i) = TEG_V_Davis_sum_17(i) .* 17; 
    TEG_V_row_Davis_spr_17(i) = TEG_V_Davis_spr_17(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_17(i) = Casey_sum_R_i_17(i) .* 17;
    Casey_spr_R_i_row_17(i) = Casey_spr_R_i_17(i) .* 17;    
    Davis_sum_R_i_row_17(i) = Davis_sum_R_i_17(i) .* 17;
    Davis_spr_R_i_row_17(i) = Davis_spr_R_i_17(i) .* 17;

    % Currents
    Casey_sum_amps_row_17(i) = TEG_V_row_Casey_sum_17(i) ./ ...
        Casey_sum_R_i_row_17(i);
    Casey_spr_amps_row_17(i) = TEG_V_row_Casey_spr_17(i) ./ ...
        Casey_spr_R_i_row_17(i);    
    Davis_sum_amps_row_17(i) = TEG_V_row_Davis_sum_17(i) ./ ...
        Davis_sum_R_i_row_17(i);
    Davis_spr_amps_row_17(i) = TEG_V_row_Davis_spr_17(i) ./ ...
        Davis_spr_R_i_row_17(i);

% Case 10
    % Voltages   
    TEG_V_row_Casey_sum_18(i) = TEG_V_Casey_sum_18(i) .* 17; 
    TEG_V_row_Casey_spr_18(i) = TEG_V_Casey_spr_18(i) .* 17;     
    TEG_V_row_Davis_sum_18(i) = TEG_V_Davis_sum_18(i) .* 17; 
    TEG_V_row_Davis_spr_18(i) = TEG_V_Davis_spr_18(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_18(i) = Casey_sum_R_i_18(i) .* 17;
    Casey_spr_R_i_row_18(i) = Casey_spr_R_i_18(i) .* 17;    
    Davis_sum_R_i_row_18(i) = Davis_sum_R_i_18(i) .* 17;
    Davis_spr_R_i_row_18(i) = Davis_spr_R_i_18(i) .* 17;

    % Currents
    Casey_sum_amps_row_18(i) = TEG_V_row_Casey_sum_18(i) ./ ...
        Casey_sum_R_i_row_18(i);
    Casey_spr_amps_row_18(i) = TEG_V_row_Casey_spr_18(i) ./ ...
        Casey_spr_R_i_row_18(i);    
    Davis_sum_amps_row_18(i) = TEG_V_row_Davis_sum_18(i) ./ ...
        Davis_sum_R_i_row_18(i);
    Davis_spr_amps_row_18(i) = TEG_V_row_Davis_spr_18(i) ./ ...
        Davis_spr_R_i_row_18(i);
% Case 7
    % Voltages   
    TEG_V_row_Casey_sum_19(i) = TEG_V_Casey_sum_19(i) .* 17; 
    TEG_V_row_Casey_spr_19(i) = TEG_V_Casey_spr_19(i) .* 17;     
    TEG_V_row_Davis_sum_19(i) = TEG_V_Davis_sum_19(i) .* 17; 
    TEG_V_row_Davis_spr_19(i) = TEG_V_Davis_spr_19(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_19(i) = Casey_sum_R_i_19(i) .* 17;
    Casey_spr_R_i_row_19(i) = Casey_spr_R_i_19(i) .* 17;    
    Davis_sum_R_i_row_19(i) = Davis_sum_R_i_19(i) .* 17;
    Davis_spr_R_i_row_19(i) = Davis_spr_R_i_19(i) .* 17;

    % Currents
    Casey_sum_amps_row_19(i) = TEG_V_row_Casey_sum_19(i) ./ ...
        Casey_sum_R_i_row_19(i);
    Casey_spr_amps_row_19(i) = TEG_V_row_Casey_spr_19(i) ./ ...
        Casey_spr_R_i_row_19(i);    
    Davis_sum_amps_row_19(i) = TEG_V_row_Davis_sum_19(i) ./ ...
        Davis_sum_R_i_row_19(i);
    Davis_spr_amps_row_19(i) = TEG_V_row_Davis_spr_19(i) ./ ...
        Davis_spr_R_i_row_19(i);
% Case 8
    % Voltages   
    TEG_V_row_Casey_sum_20(i) = TEG_V_Casey_sum_20(i) .* 17; 
    TEG_V_row_Casey_spr_20(i) = TEG_V_Casey_spr_20(i) .* 17;     
    TEG_V_row_Davis_sum_20(i) = TEG_V_Davis_sum_20(i) .* 17; 
    TEG_V_row_Davis_spr_20(i) = TEG_V_Davis_spr_20(i) .* 17; 

    % Resistances
    Casey_sum_R_i_row_20(i) = Casey_sum_R_i_20(i) .* 17;
    Casey_spr_R_i_row_20(i) = Casey_spr_R_i_20(i) .* 17;    
    Davis_sum_R_i_row_20(i) = Davis_sum_R_i_20(i) .* 17;
    Davis_spr_R_i_row_20(i) = Davis_spr_R_i_20(i) .* 17;

    % Currents
    Casey_sum_amps_row_20(i) = TEG_V_row_Casey_sum_20(i) ./ ...
        Casey_sum_R_i_row_20(i);
    Casey_spr_amps_row_20(i) = TEG_V_row_Casey_spr_20(i) ./ ...
        Casey_spr_R_i_row_20(i);    
    Davis_sum_amps_row_20(i) = TEG_V_row_Davis_sum_20(i) ./ ...
        Davis_sum_R_i_row_20(i);
    Davis_spr_amps_row_20(i) = TEG_V_row_Davis_spr_20(i) ./ ...
        Davis_spr_R_i_row_20(i);
end

% FOR 1 SOLAR PANEL - in parallel aray 
% 18 rows of 17 modules 
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)

% Resistance
    Casey_sum_R_i_full_17 = zeros(1,length(t)); 
    Casey_spr_R_i_full_17 = zeros(1,length(t));
    Davis_sum_R_i_full_17 = zeros(1,length(t));
    Davis_spr_R_i_full_17 = zeros(1,length(t));

    Casey_sum_R_i_full_18 = zeros(1,length(t)); 
    Casey_spr_R_i_full_18 = zeros(1,length(t));
    Davis_sum_R_i_full_18 = zeros(1,length(t));
    Davis_spr_R_i_full_18 = zeros(1,length(t));

    Casey_sum_R_i_full_19 = zeros(1,length(t));
    Casey_spr_R_i_full_19 = zeros(1,length(t));
    Davis_sum_R_i_full_19 = zeros(1,length(t));
    Davis_spr_R_i_full_19 = zeros(1,length(t));

    Casey_sum_R_i_full_20 = zeros(1,length(t)); 
    Casey_spr_R_i_full_20 = zeros(1,length(t));
    Davis_sum_R_i_full_20 = zeros(1,length(t));
    Davis_spr_R_i_full_20 = zeros(1,length(t));

% Power
    TEG_P_Casey_sum_full_17 = zeros(1,length(t));
    TEG_P_Casey_spr_full_17 = zeros(1,length(t));
    TEG_P_Davis_sum_full_17 = zeros(1,length(t));
    TEG_P_Davis_spr_full_17 = zeros(1,length(t));

    TEG_P_Casey_sum_full_18 = zeros(1,length(t));
    TEG_P_Casey_spr_full_18 = zeros(1,length(t));
    TEG_P_Davis_sum_full_18 = zeros(1,length(t));
    TEG_P_Davis_spr_full_18 = zeros(1,length(t));

    TEG_P_Casey_sum_full_19 = zeros(1,length(t));
    TEG_P_Casey_spr_full_19 = zeros(1,length(t));
    TEG_P_Davis_sum_full_19 = zeros(1,length(t));
    TEG_P_Davis_spr_full_19 = zeros(1,length(t));

    TEG_P_Casey_sum_full_20 = zeros(1,length(t));
    TEG_P_Casey_spr_full_20 = zeros(1,length(t));
    TEG_P_Davis_sum_full_20 = zeros(1,length(t));
    TEG_P_Davis_spr_full_20 = zeros(1,length(t));


% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Case 1
    % Resistance
        Casey_sum_R_i_full_17(i) = (18 ./ Casey_sum_R_i_row_17(i) ).^-1 ;  
        Casey_spr_R_i_full_17(i) = (18 ./ Casey_spr_R_i_row_17(i) ).^-1 ;
        Davis_sum_R_i_full_17(i) = (18 ./ Davis_sum_R_i_row_17(i) ).^-1 ;
        Davis_spr_R_i_full_17(i) = (18 ./ Davis_spr_R_i_row_17(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_17(i) =  (TEG_V_row_Casey_sum_17(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_17(i));     
        TEG_P_Casey_spr_full_17(i) =  (TEG_V_row_Casey_spr_17(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_17(i));     
        TEG_P_Davis_sum_full_17(i) =  (TEG_V_row_Davis_sum_17(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_17(i));    
        TEG_P_Davis_spr_full_17(i) =  (TEG_V_row_Davis_spr_17(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_17(i));
% Case 2
    % Resistance
        Casey_sum_R_i_full_18(i) = (18 ./ Casey_sum_R_i_row_18(i) ).^-1 ;  
        Casey_spr_R_i_full_18(i) = (18 ./ Casey_spr_R_i_row_18(i) ).^-1 ;
        Davis_sum_R_i_full_18(i) = (18 ./ Davis_sum_R_i_row_18(i) ).^-1 ;
        Davis_spr_R_i_full_18(i) = (18 ./ Davis_spr_R_i_row_18(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_18(i) =  (TEG_V_row_Casey_sum_18(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_18(i));     
        TEG_P_Casey_spr_full_18(i) =  (TEG_V_row_Casey_spr_18(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_18(i));     
        TEG_P_Davis_sum_full_18(i) =  (TEG_V_row_Davis_sum_18(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_18(i));    
        TEG_P_Davis_spr_full_18(i) =  (TEG_V_row_Davis_spr_18(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_18(i));
% Case 3
    % Resistance
        Casey_sum_R_i_full_19(i) = (18 ./ Casey_sum_R_i_row_19(i) ).^-1 ;  
        Casey_spr_R_i_full_19(i) = (18 ./ Casey_spr_R_i_row_19(i) ).^-1 ;
        Davis_sum_R_i_full_19(i) = (18 ./ Davis_sum_R_i_row_19(i) ).^-1 ;
        Davis_spr_R_i_full_19(i) = (18 ./ Davis_spr_R_i_row_19(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_19(i) =  (TEG_V_row_Casey_sum_19(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_19(i));     
        TEG_P_Casey_spr_full_19(i) =  (TEG_V_row_Casey_spr_19(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_19(i));     
        TEG_P_Davis_sum_full_19(i) =  (TEG_V_row_Davis_sum_19(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_19(i));    
        TEG_P_Davis_spr_full_19(i) =  (TEG_V_row_Davis_spr_19(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_19(i));
% Case 4
    % Resistance
        Casey_sum_R_i_full_20(i) = (18 ./ Casey_sum_R_i_row_20(i) ).^-1 ;  
        Casey_spr_R_i_full_20(i) = (18 ./ Casey_spr_R_i_row_20(i) ).^-1 ;
        Davis_sum_R_i_full_20(i) = (18 ./ Davis_sum_R_i_row_20(i) ).^-1 ;
        Davis_spr_R_i_full_20(i) = (18 ./ Davis_spr_R_i_row_20(i) ).^-1 ;

    % Power - KARABETOGLU EQUATION
        TEG_P_Casey_sum_full_20(i) =  (TEG_V_row_Casey_sum_20(i).^(2)) ./ ...
                              (4.*Casey_sum_R_i_full_20(i));     
        TEG_P_Casey_spr_full_20(i) =  (TEG_V_row_Casey_spr_20(i).^(2)) ./ ...
                              (4.*Casey_spr_R_i_full_20(i));     
        TEG_P_Davis_sum_full_20(i) =  (TEG_V_row_Davis_sum_20(i).^(2)) ./ ...
                              (4.*Davis_sum_R_i_full_20(i));    
        TEG_P_Davis_spr_full_20(i) =  (TEG_V_row_Davis_spr_20(i).^(2)) ./ ...
                              (4.*Davis_spr_R_i_full_20(i));
end




%%

figure(100)
plot(t,TEG_P_Davis_sum_full_02)
plot(t,TEG_P_Davis_spr_full_02)
    
%% DATA EXPORT !!!!
% ---- % [CASEY/SUM - 01:20] % ---- %
% CREATE TABLE OF VALUES - take note of format!!!
     PV_TEG_PCM_01_20_P_1_Panel = [... 
         % Case 1
         (TEG_P_Casey_sum_full_01); ...
         (TEG_P_Casey_spr_full_01); ...
         (TEG_P_Davis_sum_full_01); ...
         (TEG_P_Davis_spr_full_01); ... 
         % case 2
         (TEG_P_Casey_sum_full_02); ...
         (TEG_P_Casey_spr_full_02); ...
         (TEG_P_Davis_sum_full_02); ...
         (TEG_P_Davis_spr_full_02); ...
         % Case 3
         (TEG_P_Casey_sum_full_03); ...
         (TEG_P_Casey_spr_full_03); ...
         (TEG_P_Davis_sum_full_03); ...
         (TEG_P_Davis_spr_full_03); ... 
         % case 4
         (TEG_P_Casey_sum_full_04); ...
         (TEG_P_Casey_spr_full_04); ...
         (TEG_P_Davis_sum_full_04); ...
         (TEG_P_Davis_spr_full_04); ...
         % Case 5
         (TEG_P_Casey_sum_full_05); ...
         (TEG_P_Casey_spr_full_05); ...
         (TEG_P_Davis_sum_full_05); ...
         (TEG_P_Davis_spr_full_05); ... 
         % case 6
         (TEG_P_Casey_sum_full_06); ...
         (TEG_P_Casey_spr_full_06); ...
         (TEG_P_Davis_sum_full_06); ...
         (TEG_P_Davis_spr_full_06); ...
         % Case 7
         (TEG_P_Casey_sum_full_07); ...
         (TEG_P_Casey_spr_full_07); ...
         (TEG_P_Davis_sum_full_07); ...
         (TEG_P_Davis_spr_full_07); ... 
         % case 8
         (TEG_P_Casey_sum_full_08); ...
         (TEG_P_Casey_spr_full_08); ...
         (TEG_P_Davis_sum_full_08); ...
         (TEG_P_Davis_spr_full_08); ...
         % Case 9
         (TEG_P_Casey_sum_full_09); ...
         (TEG_P_Casey_spr_full_09); ...
         (TEG_P_Davis_sum_full_09); ...
         (TEG_P_Davis_spr_full_09); ... 
         % case 10
         (TEG_P_Casey_sum_full_10); ...
         (TEG_P_Casey_spr_full_10); ...
         (TEG_P_Davis_sum_full_10); ...
         (TEG_P_Davis_spr_full_10); ...
         % Case 11
         (TEG_P_Casey_sum_full_11); ...
         (TEG_P_Casey_spr_full_11); ...
         (TEG_P_Davis_sum_full_11); ...
         (TEG_P_Davis_spr_full_11); ... 
         % case 12
         (TEG_P_Casey_sum_full_12); ...
         (TEG_P_Casey_spr_full_12); ...
         (TEG_P_Davis_sum_full_12); ...
         (TEG_P_Davis_spr_full_12); ...
         % Case 13
         (TEG_P_Casey_sum_full_13); ...
         (TEG_P_Casey_spr_full_13); ...
         (TEG_P_Davis_sum_full_13); ...
         (TEG_P_Davis_spr_full_13); ... 
         % case 14
         (TEG_P_Casey_sum_full_14); ...
         (TEG_P_Casey_spr_full_14); ...
         (TEG_P_Davis_sum_full_14); ...
         (TEG_P_Davis_spr_full_14); ...
         % Case 15
         (TEG_P_Casey_sum_full_15); ...
         (TEG_P_Casey_spr_full_15); ...
         (TEG_P_Davis_sum_full_15); ...
         (TEG_P_Davis_spr_full_15); ... 
         % case 16
         (TEG_P_Casey_sum_full_16); ...
         (TEG_P_Casey_spr_full_16); ...
         (TEG_P_Davis_sum_full_16); ...
         (TEG_P_Davis_spr_full_16); ...
          % Case 17
         (TEG_P_Casey_sum_full_17); ...
         (TEG_P_Casey_spr_full_17); ...
         (TEG_P_Davis_sum_full_17); ...
         (TEG_P_Davis_spr_full_17); ... 
         % case 18
         (TEG_P_Casey_sum_full_18); ...
         (TEG_P_Casey_spr_full_18); ...
         (TEG_P_Davis_sum_full_18); ...
         (TEG_P_Davis_spr_full_18); ...
         % Case 19
         (TEG_P_Casey_sum_full_19); ...
         (TEG_P_Casey_spr_full_19); ...
         (TEG_P_Davis_sum_full_19); ...
         (TEG_P_Davis_spr_full_19); ... 
         % case 20
         (TEG_P_Casey_sum_full_20); ...
         (TEG_P_Casey_spr_full_20); ...
         (TEG_P_Davis_sum_full_20); ...
         (TEG_P_Davis_spr_full_20); ...
         ];
    % make file
    filename_PV_TEG_PCM_01_20_P_1_Panel = "PV_TEG_PCM_01_20_P_1_Panel.xlsx"; % make file
    writematrix(PV_TEG_PCM_01_20_P_1_Panel,filename_PV_TEG_PCM_01_20_P_1_Panel,...
                'Sheet',1);


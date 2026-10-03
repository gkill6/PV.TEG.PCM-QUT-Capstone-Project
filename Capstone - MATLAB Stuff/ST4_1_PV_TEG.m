%% --- % ST4.1 PV/TEG CODE % --- %%
% This is the TEG Code at the "1-to-1" level {PV/TEG} or {TEG/PCM}

% For PV/TEG, PV solar data must be imported
% PV Data includes 20 sets [2 stations] x [2 seasons] x [5x cloud cover cases]

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


%% 2.b) Calculate Solar temperatures based on [AMBIENT + IRRADIANCE]
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


%% 3) Establish average temperature and temp diff
% Temperature Profiles

%% ---- % [0% Clouds] % ---- %
Casey_sum_temp_diff = zeros(1,length(t));
Casey_spr_temp_diff = zeros(1,length(t));
Davis_sum_temp_diff = zeros(1,length(t));
Davis_spr_temp_diff = zeros(1,length(t));

for i = 1:48 
    Casey_sum_temp_diff(i) = T_cell_Casey_summer(i) - Casey_summer_temp(i);
    Casey_spr_temp_diff(i) = T_cell_Casey_spring(i) - Casey_spring_temp(i);

    Davis_sum_temp_diff(i) = T_cell_Davis_summer(i) - Davis_summer_temp(i);
    Davis_spr_temp_diff(i) = T_cell_Davis_spring(i) - Davis_spring_temp(i);

end

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

figure(7)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_temp_diff)
    plot(t,Casey_spr_temp_diff)
    plot(t,Davis_sum_temp_diff)
    plot(t,Davis_spr_temp_diff)
    ylabel('Mean Temp [C]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Temp Diff across TEG')
    hold off

figure(8)
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


figure(9)
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



%% ---- % [20% Clouds] % ---- %
Casey_sum_20_temp_diff = zeros(1,length(t));
Casey_spr_20_temp_diff = zeros(1,length(t));
Davis_sum_20_temp_diff = zeros(1,length(t));
Davis_spr_20_temp_diff = zeros(1,length(t));

for i = 1:48 
    Casey_sum_20_temp_diff(i) = ...
        T_cell_Casey_summer_20(i) - Casey_summer_temp(i);

    Casey_spr_20_temp_diff(i) = ...
        T_cell_Casey_spring_20(i) - Casey_spring_temp(i);

    Davis_sum_20_temp_diff(i) = ...
        T_cell_Davis_summer_20(i) - Davis_summer_temp(i);

    Davis_spr_20_temp_diff(i) = ...
        T_cell_Davis_spring_20(i) - Davis_spring_temp(i);

end

Casey_sum_20_mean_temp = zeros(1,length(t));
Casey_spr_20_mean_temp = zeros(1,length(t));

Davis_sum_20_mean_temp = zeros(1,length(t));
Davis_spr_20_mean_temp = zeros(1,length(t));

for i = 1:48
    Casey_sum_20_mean_temp(i) = Casey_summer_temp(i) ...
                            + (Casey_sum_20_temp_diff(i)/2);
    
    Casey_spr_20_mean_temp(i) = Casey_spring_temp(i) ...
                            + (Casey_spr_20_temp_diff(i)/2);

    Davis_sum_20_mean_temp(i) = Davis_summer_temp(i) ...
                            + (Davis_sum_20_temp_diff(i)/2);

    Davis_spr_20_mean_temp(i) = Davis_spring_temp(i) ...
                            + (Davis_spr_20_temp_diff(i)/2);

end

figure(10)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_20_temp_diff)
    plot(t,Casey_spr_20_temp_diff)
    plot(t,Davis_sum_20_temp_diff)
    plot(t,Davis_spr_20_temp_diff)
    ylabel('Mean Temp [C]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Temp Diff across TEG - 20% Clouds')
    hold off

figure(11)
    subplot(2,1,1)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_20_mean_temp)
    plot(t,Casey_summer_temp)
    plot(t,T_cell_Casey_summer_20)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Casey - Summer - 20% Clouds')
    hold off

    subplot(2,1,2)
    hold on
    grid on 
    grid minor
    plot(t,Casey_spr_20_mean_temp)
    plot(t,Casey_spring_temp)
    plot(t,T_cell_Casey_spring_20)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Casey - Spring - 20% Clouds')
    hold off


figure(12)
    subplot(2,1,1)
    hold on
    grid on 
    grid minor
    plot(t,Davis_sum_20_mean_temp)
    plot(t,Davis_summer_temp)
    plot(t,T_cell_Davis_summer_20)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Davis - Summer - 20% Clouds')
    hold off

    subplot(2,1,2)
    hold on
    grid on 
    grid minor
    plot(t,Davis_spr_20_mean_temp)
    plot(t,Davis_spring_temp)
    plot(t,T_cell_Davis_spring_20)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Davis - Spring - 20% Clouds')
    hold off



%% ---- % [40% Clouds] % ---- %
Casey_sum_40_temp_diff = zeros(1,length(t));
Casey_spr_40_temp_diff = zeros(1,length(t));
Davis_sum_40_temp_diff = zeros(1,length(t));
Davis_spr_40_temp_diff = zeros(1,length(t));

for i = 1:48 
    Casey_sum_40_temp_diff(i) = ...
        T_cell_Casey_summer_40(i) - Casey_summer_temp(i);

    Casey_spr_40_temp_diff(i) = ...
        T_cell_Casey_spring_40(i) - Casey_spring_temp(i);

    Davis_sum_40_temp_diff(i) = ...
        T_cell_Davis_summer_40(i) - Davis_summer_temp(i);

    Davis_spr_40_temp_diff(i) = ...
        T_cell_Davis_spring_40(i) - Davis_spring_temp(i);

end

Casey_sum_40_mean_temp = zeros(1,length(t));
Casey_spr_40_mean_temp = zeros(1,length(t));

Davis_sum_40_mean_temp = zeros(1,length(t));
Davis_spr_40_mean_temp = zeros(1,length(t));

for i = 1:48
    Casey_sum_40_mean_temp(i) = Casey_summer_temp(i) ...
                            + (Casey_sum_40_temp_diff(i)/2);
    
    Casey_spr_40_mean_temp(i) = Casey_spring_temp(i) ...
                            + (Casey_spr_40_temp_diff(i)/2);

    Davis_sum_40_mean_temp(i) = Davis_summer_temp(i) ...
                            + (Davis_sum_40_temp_diff(i)/2);

    Davis_spr_40_mean_temp(i) = Davis_spring_temp(i) ...
                            + (Davis_spr_40_temp_diff(i)/2);

end

figure(13)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_40_temp_diff)
    plot(t,Casey_spr_40_temp_diff)
    plot(t,Davis_sum_40_temp_diff)
    plot(t,Davis_spr_40_temp_diff)
    ylabel('Mean Temp [C]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Temp Diff across TEG - 40% Clouds')
    hold off

figure(14)
    subplot(2,1,1)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_40_mean_temp)
    plot(t,Casey_summer_temp)
    plot(t,T_cell_Casey_summer_40)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Casey - Summer - 40% Clouds')
    hold off
    
    subplot(2,1,2)
    hold on
    grid on 
    grid minor
    plot(t,Casey_spr_40_mean_temp)
    plot(t,Casey_spring_temp)
    plot(t,T_cell_Casey_spring_40)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Casey - Spring - 40% Clouds')
    hold off


figure(15)
    subplot(2,1,1)
    hold on
    grid on 
    grid minor
    plot(t,Davis_sum_40_mean_temp)
    plot(t,Davis_summer_temp)
    plot(t,T_cell_Davis_summer_40)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Davis - Summer - 40% Clouds')
    hold off
    
    subplot(2,1,2)
    hold on
    grid on 
    grid minor
    plot(t,Davis_spr_40_mean_temp)
    plot(t,Davis_spring_temp)
    plot(t,T_cell_Davis_spring_40)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Davis - Spring - 40% Clouds')
    hold off



%% ---- % [60% Clouds] % ---- %
Casey_sum_60_temp_diff = zeros(1,length(t));
Casey_spr_60_temp_diff = zeros(1,length(t));
Davis_sum_60_temp_diff = zeros(1,length(t));
Davis_spr_60_temp_diff = zeros(1,length(t));

for i = 1:48 
    Casey_sum_60_temp_diff(i) = ...
        T_cell_Casey_summer_60(i) - Casey_summer_temp(i);

    Casey_spr_60_temp_diff(i) = ...
        T_cell_Casey_spring_60(i) - Casey_spring_temp(i);

    Davis_sum_60_temp_diff(i) = ...
        T_cell_Davis_summer_60(i) - Davis_summer_temp(i);

    Davis_spr_60_temp_diff(i) = ...
        T_cell_Davis_spring_60(i) - Davis_spring_temp(i);

end

Casey_sum_60_mean_temp = zeros(1,length(t));
Casey_spr_60_mean_temp = zeros(1,length(t));

Davis_sum_60_mean_temp = zeros(1,length(t));
Davis_spr_60_mean_temp = zeros(1,length(t));

for i = 1:48
    Casey_sum_60_mean_temp(i) = Casey_summer_temp(i) ...
                            + (Casey_sum_60_temp_diff(i)/2);
    
    Casey_spr_60_mean_temp(i) = Casey_spring_temp(i) ...
                            + (Casey_spr_60_temp_diff(i)/2);

    Davis_sum_60_mean_temp(i) = Davis_summer_temp(i) ...
                            + (Davis_sum_60_temp_diff(i)/2);

    Davis_spr_60_mean_temp(i) = Davis_spring_temp(i) ...
                            + (Davis_spr_60_temp_diff(i)/2);

end

figure(16)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_60_temp_diff)
    plot(t,Casey_spr_60_temp_diff)
    plot(t,Davis_sum_60_temp_diff)
    plot(t,Davis_spr_60_temp_diff)
    ylabel('Mean Temp [C]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Temp Diff across TEG - 60% Clouds')
    hold off

figure(17)
    subplot(2,1,1)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_60_mean_temp)
    plot(t,Casey_summer_temp)
    plot(t,T_cell_Casey_summer_60)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Casey - Summer - 60% Clouds')
    hold off

    subplot(2,1,2)
    hold on
    grid on 
    grid minor
    plot(t,Casey_spr_60_mean_temp)
    plot(t,Casey_spring_temp)
    plot(t,T_cell_Casey_spring_60)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Casey - Spring - 60% Clouds')
    hold off


figure(18)
    subplot(2,1,1)
    hold on
    grid on 
    grid minor
    plot(t,Davis_sum_60_mean_temp)
    plot(t,Davis_summer_temp)
    plot(t,T_cell_Davis_summer_60)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Davis - Summer - 60% Clouds')
    hold off
    
    subplot(2,1,2)
    hold on
    grid on 
    grid minor
    plot(t,Davis_spr_60_mean_temp)
    plot(t,Davis_spring_temp)
    plot(t,T_cell_Davis_spring_60)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Davis - Spring - 60% Clouds')
    hold off



%% ---- % [80% Clouds] % ---- %
Casey_sum_80_temp_diff = zeros(1,length(t));
Casey_spr_80_temp_diff = zeros(1,length(t));
Davis_sum_80_temp_diff = zeros(1,length(t));
Davis_spr_80_temp_diff = zeros(1,length(t));

for i = 1:48 
    Casey_sum_80_temp_diff(i) = ...
        T_cell_Casey_summer_80(i) - Casey_summer_temp(i);

    Casey_spr_80_temp_diff(i) = ...
        T_cell_Casey_spring_80(i) - Casey_spring_temp(i);

    Davis_sum_80_temp_diff(i) = ...
        T_cell_Davis_summer_80(i) - Davis_summer_temp(i);

    Davis_spr_80_temp_diff(i) = ...
        T_cell_Davis_spring_80(i) - Davis_spring_temp(i);

end

Casey_sum_80_mean_temp = zeros(1,length(t));
Casey_spr_80_mean_temp = zeros(1,length(t));

Davis_sum_80_mean_temp = zeros(1,length(t));
Davis_spr_80_mean_temp = zeros(1,length(t));

for i = 1:48
    Casey_sum_80_mean_temp(i) = Casey_summer_temp(i) ...
                            + (Casey_sum_80_temp_diff(i)/2);
    
    Casey_spr_80_mean_temp(i) = Casey_spring_temp(i) ...
                            + (Casey_spr_80_temp_diff(i)/2);

    Davis_sum_80_mean_temp(i) = Davis_summer_temp(i) ...
                            + (Davis_sum_80_temp_diff(i)/2);

    Davis_spr_80_mean_temp(i) = Davis_spring_temp(i) ...
                            + (Davis_spr_80_temp_diff(i)/2);

end

figure(19)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_80_temp_diff)
    plot(t,Casey_spr_80_temp_diff)
    plot(t,Davis_sum_80_temp_diff)
    plot(t,Davis_spr_80_temp_diff)
    ylabel('Mean Temp [C]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Temp Diff across TEG - 80% Clouds')
    hold off

figure(20)
    subplot(2,1,1)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_80_mean_temp)
    plot(t,Casey_summer_temp)
    plot(t,T_cell_Casey_summer_80)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Casey - Summer - 80% Clouds')
    hold off

    subplot(2,1,2)
    hold on
    grid on 
    grid minor
    plot(t,Casey_spr_80_mean_temp)
    plot(t,Casey_spring_temp)
    plot(t,T_cell_Casey_spring_80)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Casey - Spring - 80% Clouds')
    hold off


figure(21)
    subplot(2,1,1)
    hold on
    grid on 
    grid minor
    plot(t,Davis_sum_80_mean_temp)
    plot(t,Davis_summer_temp)
    plot(t,T_cell_Davis_summer_80)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Davis - Summer - 80% Clouds')
    hold off
    
    subplot(2,1,2)
    hold on
    grid on 
    grid minor
    plot(t,Davis_spr_80_mean_temp)
    plot(t,Davis_spring_temp)
    plot(t,T_cell_Davis_spring_80)
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('Mean Temp across TEG','Ambient Temp','Solar Cell Temp')
    title('Temperatures - Davis - Spring - 80% Clouds')
    hold off



%% 4) Find TEG metrics and power values
% 20 cases need to consider 

%% TEG Voltage 
% V = N * seebck.(average temp) * temp_diff
N = 241; % number of p&n type conductors

% Seebeck
% dimensionless seebeck equation
% ~ =  (-1.132*10^(-5) .* (Casey_mean_temp)^2 )...
% + (8.64*10^(-3) .* (Casey_mean_temp(i))) ...
% - 0.582;


% seebeck variable across 24/hour cycle

%% --- % --- % [0% Clouds] % --- % --- %
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

figure(22)
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
    title('Voltage across 1 TEG Module - 0% Clouds')
    hold off


%% --- % --- % [20% Clouds] % --- % --- %
seebeck_dim_Casey_sum_20 = zeros(1,length(t));
seebeck_dim_Casey_spr_20 = zeros(1,length(t));

seebeck_dim_Davis_sum_20 = zeros(1,length(t));
seebeck_dim_Davis_spr_20 = zeros(1,length(t));


% temperatures need to be in KELVIN to work

for i = 1:48
    Casey_sum_20_mean_temp(i) = Casey_sum_20_mean_temp(i) + 273.15;
    Casey_spr_20_mean_temp(i) = Casey_spr_20_mean_temp(i) + 273.15; 
    
    Davis_sum_20_mean_temp(i) = Davis_sum_20_mean_temp(i) + 273.15;
    Davis_spr_20_mean_temp(i) = Davis_spr_20_mean_temp(i) + 273.15;
end
% Celsius 2 Kelvin!!

for i = 1:48
    seebeck_dim_Casey_sum_20(i) = ...
        (-1.132*10^(-5) .* (Casey_sum_20_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_sum_20_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Casey_spr_20(i) = ...
        (-1.132*10^(-5) .* (Casey_spr_20_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_spr_20_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Davis_sum_20(i) = ...
        (-1.132*10^(-5) .* (Davis_sum_20_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_sum_20_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Davis_spr_20(i) = ...
        (-1.132*10^(-5) .* (Davis_spr_20_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_spr_20_mean_temp(i))) ...
        - 0.582;
end

% dim*stc = seebeck
seebeck_stc = 345 * 10^-6; % V / K @ T = 300 K

seebeck_Casey_sum_20 = zeros(1,length(t));
seebeck_Casey_spr_20 = zeros(1,length(t));

seebeck_Davis_sum_20 = zeros(1,length(t));
seebeck_Davis_spr_20 = zeros(1,length(t));

for i = 1:48 
    seebeck_Casey_sum_20(i) = seebeck_dim_Casey_sum_20(i).*seebeck_stc;
    seebeck_Casey_spr_20(i) = seebeck_dim_Casey_spr_20(i).*seebeck_stc;

    seebeck_Davis_sum_20(i) = seebeck_dim_Davis_sum_20(i).*seebeck_stc;
    seebeck_Davis_spr_20(i) = seebeck_dim_Davis_spr_20(i).*seebeck_stc;

end

% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum_20 = zeros(1,length(t));
TEG_V_Casey_spr_20 = zeros(1,length(t));

TEG_V_Davis_sum_20 = zeros(1,length(t));
TEG_V_Davis_spr_20 = zeros(1,length(t));

for i = 1:48
    
TEG_V_Casey_sum_20(i) = N .* seebeck_Casey_sum_20(i) ...
    .* Casey_sum_20_temp_diff(i);

TEG_V_Casey_spr_20(i) = N .* seebeck_Casey_spr_20(i) ...
    .* Casey_spr_20_temp_diff(i);


TEG_V_Davis_sum_20(i) = N .* seebeck_Davis_sum_20(i) ...
    .* Davis_sum_20_temp_diff(i);

TEG_V_Davis_spr_20(i) = N .* seebeck_Davis_spr_20(i) ...
    .* Davis_spr_20_temp_diff(i);

end

figure(23)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_Casey_sum_20)
    plot(t,TEG_V_Casey_spr_20)
    plot(t,TEG_V_Davis_sum_20)
    plot(t,TEG_V_Davis_spr_20)
    ylabel('Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Voltage across 1 TEG Module - 20% Clouds')
    hold off


%% --- % --- % [40% Clouds] % --- % --- %
seebeck_dim_Casey_sum_40 = zeros(1,length(t));
seebeck_dim_Casey_spr_40 = zeros(1,length(t));

seebeck_dim_Davis_sum_40 = zeros(1,length(t));
seebeck_dim_Davis_spr_40 = zeros(1,length(t));


% temperatures need to be in KELVIN to work

for i = 1:48
    Casey_sum_40_mean_temp(i) = Casey_sum_40_mean_temp(i) + 273.15;
    Casey_spr_40_mean_temp(i) = Casey_spr_40_mean_temp(i) + 273.15; 
    
    Davis_sum_40_mean_temp(i) = Davis_sum_40_mean_temp(i) + 273.15;
    Davis_spr_40_mean_temp(i) = Davis_spr_40_mean_temp(i) + 273.15;
end
% Celsius 2 Kelvin!!

for i = 1:48
    seebeck_dim_Casey_sum_40(i) = ...
        (-1.132*10^(-5) .* (Casey_sum_40_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_sum_40_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Casey_spr_40(i) = ...
        (-1.132*10^(-5) .* (Casey_spr_40_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_spr_40_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Davis_sum_40(i) = ...
        (-1.132*10^(-5) .* (Davis_sum_40_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_sum_40_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Davis_spr_40(i) = ...
        (-1.132*10^(-5) .* (Davis_spr_40_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_spr_40_mean_temp(i))) ...
        - 0.582;
end

% dim*stc = seebeck
seebeck_stc = 345 * 10^-6; % V / K @ T = 300 K

seebeck_Casey_sum_40 = zeros(1,length(t));
seebeck_Casey_spr_40 = zeros(1,length(t));

seebeck_Davis_sum_40 = zeros(1,length(t));
seebeck_Davis_spr_40 = zeros(1,length(t));

for i = 1:48 
    seebeck_Casey_sum_40(i) = seebeck_dim_Casey_sum_40(i).*seebeck_stc;
    seebeck_Casey_spr_40(i) = seebeck_dim_Casey_spr_40(i).*seebeck_stc;

    seebeck_Davis_sum_40(i) = seebeck_dim_Davis_sum_40(i).*seebeck_stc;
    seebeck_Davis_spr_40(i) = seebeck_dim_Davis_spr_40(i).*seebeck_stc;

end

% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum_40 = zeros(1,length(t));
TEG_V_Casey_spr_40 = zeros(1,length(t));

TEG_V_Davis_sum_40 = zeros(1,length(t));
TEG_V_Davis_spr_40 = zeros(1,length(t));

for i = 1:48
    
TEG_V_Casey_sum_40(i) = N .* seebeck_Casey_sum_40(i) ...
    .* Casey_sum_40_temp_diff(i);

TEG_V_Casey_spr_40(i) = N .* seebeck_Casey_spr_40(i) ...
    .* Casey_spr_40_temp_diff(i);


TEG_V_Davis_sum_40(i) = N .* seebeck_Davis_sum_40(i) ...
    .* Davis_sum_40_temp_diff(i);

TEG_V_Davis_spr_40(i) = N .* seebeck_Davis_spr_40(i) ...
    .* Davis_spr_40_temp_diff(i);

end

figure(24)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_Casey_sum_40)
    plot(t,TEG_V_Casey_spr_40)
    plot(t,TEG_V_Davis_sum_40)
    plot(t,TEG_V_Davis_spr_40)
    ylabel('Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Voltage across 1 TEG Module - 40% Clouds')
    hold off


%% --- % --- % [60% Clouds] % --- % --- %
seebeck_dim_Casey_sum_60 = zeros(1,length(t));
seebeck_dim_Casey_spr_60 = zeros(1,length(t));

seebeck_dim_Davis_sum_60 = zeros(1,length(t));
seebeck_dim_Davis_spr_60 = zeros(1,length(t));

% temperatures need to be in KELVIN to work

for i = 1:48
    Casey_sum_60_mean_temp(i) = Casey_sum_60_mean_temp(i) + 273.15;
    Casey_spr_60_mean_temp(i) = Casey_spr_60_mean_temp(i) + 273.15; 
    
    Davis_sum_60_mean_temp(i) = Davis_sum_60_mean_temp(i) + 273.15;
    Davis_spr_60_mean_temp(i) = Davis_spr_60_mean_temp(i) + 273.15;
end
% Celsius 2 Kelvin!!

for i = 1:48
    seebeck_dim_Casey_sum_60(i) = ...
        (-1.132*10^(-5) .* (Casey_sum_60_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_sum_60_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Casey_spr_60(i) = ...
        (-1.132*10^(-5) .* (Casey_spr_60_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_spr_60_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Davis_sum_60(i) = ...
        (-1.132*10^(-5) .* (Davis_sum_60_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_sum_60_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Davis_spr_60(i) = ...
        (-1.132*10^(-5) .* (Davis_spr_60_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_spr_60_mean_temp(i))) ...
        - 0.582;
end

% dim*stc = seebeck
seebeck_stc = 345 * 10^-6; % V / K @ T = 300 K

seebeck_Casey_sum_60 = zeros(1,length(t));
seebeck_Casey_spr_60 = zeros(1,length(t));

seebeck_Davis_sum_60 = zeros(1,length(t));
seebeck_Davis_spr_60 = zeros(1,length(t));

for i = 1:48 
    seebeck_Casey_sum_60(i) = seebeck_dim_Casey_sum_60(i).*seebeck_stc;
    seebeck_Casey_spr_60(i) = seebeck_dim_Casey_spr_60(i).*seebeck_stc;

    seebeck_Davis_sum_60(i) = seebeck_dim_Davis_sum_60(i).*seebeck_stc;
    seebeck_Davis_spr_60(i) = seebeck_dim_Davis_spr_60(i).*seebeck_stc;

end

% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum_60 = zeros(1,length(t));
TEG_V_Casey_spr_60 = zeros(1,length(t));

TEG_V_Davis_sum_60 = zeros(1,length(t));
TEG_V_Davis_spr_60 = zeros(1,length(t));

for i = 1:48
    
TEG_V_Casey_sum_60(i) = N .* seebeck_Casey_sum_60(i) ...
    .* Casey_sum_60_temp_diff(i);

TEG_V_Casey_spr_60(i) = N .* seebeck_Casey_spr_60(i) ...
    .* Casey_spr_60_temp_diff(i);


TEG_V_Davis_sum_60(i) = N .* seebeck_Davis_sum_60(i) ...
    .* Davis_sum_60_temp_diff(i);

TEG_V_Davis_spr_60(i) = N .* seebeck_Davis_spr_60(i) ...
    .* Davis_spr_60_temp_diff(i);

end

figure(25)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_Casey_sum_60)
    plot(t,TEG_V_Casey_spr_60)
    plot(t,TEG_V_Davis_sum_60)
    plot(t,TEG_V_Davis_spr_60)
    ylabel('Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Voltage across 1 TEG Module - 60% Clouds')
    hold off


%% --- % --- % [80% Clouds] % --- % --- %
seebeck_dim_Casey_sum_80 = zeros(1,length(t));
seebeck_dim_Casey_spr_80 = zeros(1,length(t));

seebeck_dim_Davis_sum_80 = zeros(1,length(t));
seebeck_dim_Davis_spr_80 = zeros(1,length(t));

% temperatures need to be in KELVIN to work

for i = 1:48
    Casey_sum_80_mean_temp(i) = Casey_sum_80_mean_temp(i) + 273.15;
    Casey_spr_80_mean_temp(i) = Casey_spr_80_mean_temp(i) + 273.15; 
    
    Davis_sum_80_mean_temp(i) = Davis_sum_80_mean_temp(i) + 273.15;
    Davis_spr_80_mean_temp(i) = Davis_spr_80_mean_temp(i) + 273.15;
end
% Celsius 2 Kelvin!!

for i = 1:48
    seebeck_dim_Casey_sum_80(i) = ...
        (-1.132*10^(-5) .* (Casey_sum_80_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_sum_80_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Casey_spr_80(i) = ...
        (-1.132*10^(-5) .* (Casey_spr_80_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Casey_spr_80_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Davis_sum_80(i) = ...
        (-1.132*10^(-5) .* (Davis_sum_80_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_sum_80_mean_temp(i))) ...
        - 0.582;

        seebeck_dim_Davis_spr_80(i) = ...
        (-1.132*10^(-5) .* (Davis_spr_80_mean_temp(i))^2 ) ...
        + (8.64*10^(-3) .* (Davis_spr_80_mean_temp(i))) ...
        - 0.582;
end

% dim*stc = seebeck
seebeck_stc = 345 * 10^-6; % V / K @ T = 300 K

seebeck_Casey_sum_80 = zeros(1,length(t));
seebeck_Casey_spr_80 = zeros(1,length(t));

seebeck_Davis_sum_80 = zeros(1,length(t));
seebeck_Davis_spr_80 = zeros(1,length(t));

for i = 1:48 
    seebeck_Casey_sum_80(i) = seebeck_dim_Casey_sum_80(i).*seebeck_stc;
    seebeck_Casey_spr_80(i) = seebeck_dim_Casey_spr_80(i).*seebeck_stc;

    seebeck_Davis_sum_80(i) = seebeck_dim_Davis_sum_80(i).*seebeck_stc;
    seebeck_Davis_spr_80(i) = seebeck_dim_Davis_spr_80(i).*seebeck_stc;

end

% V = N * seebck.(average temp) * temp_diff
TEG_V_Casey_sum_80 = zeros(1,length(t));
TEG_V_Casey_spr_80 = zeros(1,length(t));

TEG_V_Davis_sum_80 = zeros(1,length(t));
TEG_V_Davis_spr_80 = zeros(1,length(t));

for i = 1:48
    
TEG_V_Casey_sum_80(i) = N .* seebeck_Casey_sum_80(i) ...
    .* Casey_sum_80_temp_diff(i);

TEG_V_Casey_spr_80(i) = N .* seebeck_Casey_spr_80(i) ...
    .* Casey_spr_80_temp_diff(i);


TEG_V_Davis_sum_80(i) = N .* seebeck_Davis_sum_80(i) ...
    .* Davis_sum_80_temp_diff(i);

TEG_V_Davis_spr_80(i) = N .* seebeck_Davis_spr_80(i) ...
    .* Davis_spr_80_temp_diff(i);

end

figure(26)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_Casey_sum_80)
    plot(t,TEG_V_Casey_spr_80)
    plot(t,TEG_V_Davis_sum_80)
    plot(t,TEG_V_Davis_spr_80)
    ylabel('Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Voltage across 1 TEG Module - 80% Clouds')
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


%% --- % --- % [0% Clouds] % --- % --- %
elec_cond_dim_Casey_sum = zeros(1,length(t));
elec_cond_dim_Casey_spr = zeros(1,length(t));

elec_cond_dim_Davis_sum = zeros(1,length(t));
elec_cond_dim_Davis_spr = zeros(1,length(t));

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

figure(27)
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
    title('Internal Resistance in 1 Module - 0% Clouds')
    hold off



%% --- % --- % [20% Clouds] % --- % --- %
elec_cond_dim_Casey_sum_20 = zeros(1,length(t));
elec_cond_dim_Casey_spr_20 = zeros(1,length(t));

elec_cond_dim_Davis_sum_20 = zeros(1,length(t));
elec_cond_dim_Davis_spr_20 = zeros(1,length(t));

for i = 1:48
    elec_cond_dim_Casey_sum_20(i) = ...
        (6.257*10^(-5) .* (Casey_sum_20_mean_temp(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_20_mean_temp(i)) ) ...
        + 8.629;

    elec_cond_dim_Casey_spr_20(i) = ...
        (6.257*10^(-5) .* (Casey_spr_20_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_20_mean_temp(i))) ...
        + 8.629;

    elec_cond_dim_Davis_sum_20(i) = ...
        (6.257*10^(-5) .* (Davis_sum_20_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_20_mean_temp(i))) ...
        + 8.629; 

    elec_cond_dim_Davis_spr_20(i) = ...
        (6.257*10^(-5) .* (Davis_spr_20_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_20_mean_temp(i))) ...
        + 8.629; 
end

% dim * stc = const
% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum_20 = zeros(1,length(t));
elec_cond_Casey_spr_20 = zeros(1,length(t));

elec_cond_Davis_sum_20 = zeros(1,length(t));
elec_cond_Davis_spr_20 = zeros(1,length(t));


for i = 1:48 
    elec_cond_Casey_sum_20(i) = elec_cond_dim_Casey_sum_20(i) .* elec_cond_stc;
    elec_cond_Casey_spr_20(i) = elec_cond_dim_Casey_spr_20(i) .* elec_cond_stc;

    elec_cond_Davis_sum_20(i) = elec_cond_dim_Davis_sum_20(i) .* elec_cond_stc;
    elec_cond_Davis_spr_20(i) = elec_cond_dim_Davis_spr_20(i) .* elec_cond_stc;
end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)
% need to be very careful - make cosntants where possible 

Casey_sum_20_R_i = zeros(1,length(t)); % Ohms - resistance
Casey_spr_20_R_i = zeros(1,length(t));

Davis_sum_20_R_i = zeros(1,length(t));
Davis_spr_20_R_i = zeros(1,length(t));

for i = 1:48
    
Casey_sum_20_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_sum_20(i) ) + ( (2.*r_con)./ thick) );

Casey_spr_20_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_spr_20(i) ) + ( (2.*r_con)./ thick) );

Davis_sum_20_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_sum_20(i) ) + ( (2.*r_con)./ thick) );

Davis_spr_20_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_spr_20(i) ) + ( (2.*r_con)./ thick) );

end

figure(28)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_20_R_i)
    plot(t,Casey_spr_20_R_i)
    plot(t,Davis_sum_20_R_i)
    plot(t,Davis_spr_20_R_i)
    ylabel('Internal Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Internal Resistance in 1 Module - 20% Clouds')
    hold off



%% --- % --- % [40% Clouds] % --- % --- %
elec_cond_dim_Casey_sum_40 = zeros(1,length(t));
elec_cond_dim_Casey_spr_40 = zeros(1,length(t));

elec_cond_dim_Davis_sum_40 = zeros(1,length(t));
elec_cond_dim_Davis_spr_40 = zeros(1,length(t));

for i = 1:48
    elec_cond_dim_Casey_sum_40(i) = ...
        (6.257*10^(-5) .* (Casey_sum_40_mean_temp(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_40_mean_temp(i)) ) ...
        + 8.629;

    elec_cond_dim_Casey_spr_40(i) = ...
        (6.257*10^(-5) .* (Casey_spr_40_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_40_mean_temp(i))) ...
        + 8.629;

    elec_cond_dim_Davis_sum_40(i) = ...
        (6.257*10^(-5) .* (Davis_sum_40_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_40_mean_temp(i))) ...
        + 8.629; 

    elec_cond_dim_Davis_spr_40(i) = ...
        (6.257*10^(-5) .* (Davis_spr_40_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_40_mean_temp(i))) ...
        + 8.629; 
end

% dim * stc = const
% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum_40 = zeros(1,length(t));
elec_cond_Casey_spr_40 = zeros(1,length(t));

elec_cond_Davis_sum_40 = zeros(1,length(t));
elec_cond_Davis_spr_40 = zeros(1,length(t));


for i = 1:48 
    elec_cond_Casey_sum_40(i) = elec_cond_dim_Casey_sum_40(i) .* elec_cond_stc;
    elec_cond_Casey_spr_40(i) = elec_cond_dim_Casey_spr_40(i) .* elec_cond_stc;

    elec_cond_Davis_sum_40(i) = elec_cond_dim_Davis_sum_40(i) .* elec_cond_stc;
    elec_cond_Davis_spr_40(i) = elec_cond_dim_Davis_spr_40(i) .* elec_cond_stc;
end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)
% need to be very careful - make cosntants where possible 

Casey_sum_40_R_i = zeros(1,length(t)); % Ohms - resistance
Casey_spr_40_R_i = zeros(1,length(t));

Davis_sum_40_R_i = zeros(1,length(t));
Davis_spr_40_R_i = zeros(1,length(t));

for i = 1:48
    
Casey_sum_40_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_sum_40(i) ) + ( (2.*r_con)./ thick) );

Casey_spr_40_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_spr_40(i) ) + ( (2.*r_con)./ thick) );

Davis_sum_40_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_sum_40(i) ) + ( (2.*r_con)./ thick) );

Davis_spr_40_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_spr_40(i) ) + ( (2.*r_con)./ thick) );

end

figure(29)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_40_R_i)
    plot(t,Casey_spr_40_R_i)
    plot(t,Davis_sum_40_R_i)
    plot(t,Davis_spr_40_R_i)
    ylabel('Internal Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Internal Resistance in 1 Module - 40% Clouds')
    hold off


%% --- % --- % [60% Clouds] % --- % --- %
elec_cond_dim_Casey_sum_60 = zeros(1,length(t));
elec_cond_dim_Casey_spr_60 = zeros(1,length(t));

elec_cond_dim_Davis_sum_60 = zeros(1,length(t));
elec_cond_dim_Davis_spr_60 = zeros(1,length(t));

for i = 1:48
    elec_cond_dim_Casey_sum_60(i) = ...
        (6.257*10^(-5) .* (Casey_sum_60_mean_temp(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_60_mean_temp(i)) ) ...
        + 8.629;

    elec_cond_dim_Casey_spr_60(i) = ...
        (6.257*10^(-5) .* (Casey_spr_60_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_60_mean_temp(i))) ...
        + 8.629;

    elec_cond_dim_Davis_sum_60(i) = ...
        (6.257*10^(-5) .* (Davis_sum_60_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_60_mean_temp(i))) ...
        + 8.629; 

    elec_cond_dim_Davis_spr_60(i) = ...
        (6.257*10^(-5) .* (Davis_spr_60_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_60_mean_temp(i))) ...
        + 8.629; 
end

% dim * stc = const
% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum_60 = zeros(1,length(t));
elec_cond_Casey_spr_60 = zeros(1,length(t));

elec_cond_Davis_sum_60 = zeros(1,length(t));
elec_cond_Davis_spr_60 = zeros(1,length(t));


for i = 1:48 
    elec_cond_Casey_sum_60(i) = elec_cond_dim_Casey_sum_60(i) .* elec_cond_stc;
    elec_cond_Casey_spr_60(i) = elec_cond_dim_Casey_spr_60(i) .* elec_cond_stc;

    elec_cond_Davis_sum_60(i) = elec_cond_dim_Davis_sum_60(i) .* elec_cond_stc;
    elec_cond_Davis_spr_60(i) = elec_cond_dim_Davis_spr_60(i) .* elec_cond_stc;
end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)
% need to be very careful - make cosntants where possible 

Casey_sum_60_R_i = zeros(1,length(t)); % Ohms - resistance
Casey_spr_60_R_i = zeros(1,length(t));

Davis_sum_60_R_i = zeros(1,length(t));
Davis_spr_60_R_i = zeros(1,length(t));

for i = 1:48
    
Casey_sum_60_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_sum_60(i) ) + ( (2.*r_con)./ thick) );

Casey_spr_60_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_spr_60(i) ) + ( (2.*r_con)./ thick) );

Davis_sum_60_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_sum_60(i) ) + ( (2.*r_con)./ thick) );

Davis_spr_60_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_spr_60(i) ) + ( (2.*r_con)./ thick) );

end

figure(30)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_60_R_i)
    plot(t,Casey_spr_60_R_i)
    plot(t,Davis_sum_60_R_i)
    plot(t,Davis_spr_60_R_i)
    ylabel('Internal Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Internal Resistance in 1 Module - 60% Clouds')
    hold off



%% --- % --- % [80% Clouds] % --- % --- %
elec_cond_dim_Casey_sum_80 = zeros(1,length(t));
elec_cond_dim_Casey_spr_80 = zeros(1,length(t));

elec_cond_dim_Davis_sum_80 = zeros(1,length(t));
elec_cond_dim_Davis_spr_80 = zeros(1,length(t));

for i = 1:48
    elec_cond_dim_Casey_sum_80(i) = ...
        (6.257*10^(-5) .* (Casey_sum_80_mean_temp(i))^2 ) ...
        - ( 4.381*10^(-2) .* (Casey_sum_80_mean_temp(i)) ) ...
        + 8.629;

    elec_cond_dim_Casey_spr_80(i) = ...
        (6.257*10^(-5) .* (Casey_spr_80_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Casey_spr_80_mean_temp(i))) ...
        + 8.629;

    elec_cond_dim_Davis_sum_80(i) = ...
        (6.257*10^(-5) .* (Davis_sum_80_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_sum_80_mean_temp(i))) ...
        + 8.629; 

    elec_cond_dim_Davis_spr_80(i) = ...
        (6.257*10^(-5) .* (Davis_spr_80_mean_temp(i))^2 ) ...
        - (4.381*10^(-2) .* (Davis_spr_80_mean_temp(i))) ...
        + 8.629; 
end

% dim * stc = const
% elec_con_stc = 28103; % Ohm.metre @ T = 300 K
elec_cond_Casey_sum_80 = zeros(1,length(t));
elec_cond_Casey_spr_80 = zeros(1,length(t));

elec_cond_Davis_sum_80 = zeros(1,length(t));
elec_cond_Davis_spr_80 = zeros(1,length(t));


for i = 1:48 
    elec_cond_Casey_sum_80(i) = elec_cond_dim_Casey_sum_80(i) .* elec_cond_stc;
    elec_cond_Casey_spr_80(i) = elec_cond_dim_Casey_spr_80(i) .* elec_cond_stc;

    elec_cond_Davis_sum_80(i) = elec_cond_dim_Davis_sum_80(i) .* elec_cond_stc;
    elec_cond_Davis_spr_80(i) = elec_cond_dim_Davis_spr_80(i) .* elec_cond_stc;
end

% R_i = N * [(1/elec.(mean_temp)) + ((2.rcon)/(thick))] * (thick/area)
% need to be very careful - make cosntants where possible 

Casey_sum_80_R_i = zeros(1,length(t)); % Ohms - resistance
Casey_spr_80_R_i = zeros(1,length(t));

Davis_sum_80_R_i = zeros(1,length(t));
Davis_spr_80_R_i = zeros(1,length(t));

for i = 1:48
    
Casey_sum_80_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_sum_80(i) ) + ( (2.*r_con)./ thick) );

Casey_spr_80_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Casey_spr_80(i) ) + ( (2.*r_con)./ thick) );

Davis_sum_80_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_sum_80(i) ) + ( (2.*r_con)./ thick) );

Davis_spr_80_R_i(i) = N .* (thick/area) .* ...
    ( (1 ./ elec_cond_Davis_spr_80(i) ) + ( (2.*r_con)./ thick) );

end

figure(31)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_80_R_i)
    plot(t,Casey_spr_80_R_i)
    plot(t,Davis_sum_80_R_i)
    plot(t,Davis_spr_80_R_i)
    ylabel('Internal Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('Internal Resistance in 1 Module - 80% Clouds')
    hold off



%% Power Generation 
%% --- %% -- % [0% Clouds] % -- %% --- %%
% First calculate per module
% Use Karabetoglu equation: [P = (V^2) /( 4*R_i)]
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

figure(32)
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

% then calculate Power per PANEL - 17 x 18 ARRAY!
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

figure(33)
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

figure(34)
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

figure(35)
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
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)


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

% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Resistance
    Casey_sum_R_i_full(i) = (18 ./ Casey_sum_R_i_row(i) ).^-1 ;  
    Casey_spr_R_i_full(i) = (18 ./ Casey_spr_R_i_row(i) ).^-1 ;
    
    Davis_sum_R_i_full(i) = (18 ./ Davis_sum_R_i_row(i) ).^-1 ;
    Davis_spr_R_i_full(i) = (18 ./ Davis_spr_R_i_row(i) ).^-1 ;

% Power - KARABETOGLU EQUATION
    TEG_P_Casey_sum_full(i) =  (TEG_V_row_Casey_sum(i).^(2)) ./ ...
                          (4.*Casey_sum_R_i_full(i)); 
    
    TEG_P_Casey_spr_full(i) =  (TEG_V_row_Casey_spr(i).^(2)) ./ ...
                          (4.*Casey_spr_R_i_full(i)); 
    
    TEG_P_Davis_sum_full(i) =  (TEG_V_row_Davis_sum(i).^(2)) ./ ...
                          (4.*Davis_sum_R_i_full(i));
    
    TEG_P_Davis_spr_full(i) =  (TEG_V_row_Davis_spr(i).^(2)) ./ ...
                          (4.*Davis_spr_R_i_full(i));

end

figure(36)
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
    title('TEG Power in Array (V^2 / 4.R) - Per 1 Solar Panel - [0% Clouds]')
    hold off



%% --- %% -- % [20% Clouds] % -- %% --- %%
% First calculate per module
% Use Karabetoglu equation: [P = (V^2) /( 4*R_i)]
    TEG_P_Casey_sum_20 = zeros(1,length(t));
    TEG_P_Casey_spr_20 = zeros(1,length(t));
    
    TEG_P_Davis_sum_20 = zeros(1,length(t));
    TEG_P_Davis_spr_20 = zeros(1,length(t));


for i = 1:48
    TEG_P_Casey_sum_20(i) =  (TEG_V_Casey_sum_20(i).^(2)) ./ ...
                          (4 .* Casey_sum_20_R_i(i)); 
    
    TEG_P_Casey_spr_20(i) =  (TEG_V_Casey_spr_20(i).^(2)) ./ ...
                          (4 .* Casey_spr_20_R_i(i)); 
    
    TEG_P_Davis_sum_20(i) =  (TEG_V_Davis_sum_20(i).^(2)) ./ ...
                          (4 .* Davis_sum_20_R_i(i));
    
    TEG_P_Davis_spr_20(i) =  (TEG_V_Davis_spr_20(i).^(2)) ./ ...
                          (4 .* Davis_spr_20_R_i(i));
end

figure(37)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_20)
    plot(t,TEG_P_Casey_spr_20)
    plot(t,TEG_P_Davis_sum_20)
    plot(t,TEG_P_Davis_spr_20)
    ylabel('Power Rate [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power Generated - per module [20% Clouds] - [V^2/4.R]')
    hold off

% then calculate Power per PANEL - 17 x 18 ARRAY!
% Voltages
    TEG_V_row_Casey_sum_20 = zeros(1,length(t));
    TEG_V_row_Casey_spr_20 = zeros(1,length(t));
    
    TEG_V_row_Davis_sum_20 = zeros(1,length(t));
    TEG_V_row_Davis_spr_20 = zeros(1,length(t));

% Ohms - resistance
    Casey_sum_R_i_row_20 = zeros(1,length(t)); 
    Casey_spr_R_i_row_20 = zeros(1,length(t));
    
    Davis_sum_R_i_row_20 = zeros(1,length(t));
    Davis_spr_R_i_row_20 = zeros(1,length(t));

% Currents
    Casey_sum_amps_row_20 = zeros(1,length(t)); 
    Casey_spr_amps_row_20 = zeros(1,length(t));
    
    Davis_sum_amps_row_20 = zeros(1,length(t));
    Davis_spr_amps_row_20 = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Voltages   
    TEG_V_row_Casey_sum_20(i) = TEG_V_Casey_sum_20(i) .* 17; 
    TEG_V_row_Casey_spr_20(i) = TEG_V_Casey_spr_20(i) .* 17; 
    
    TEG_V_row_Davis_sum_20(i) = TEG_V_Davis_sum_20(i) .* 17; 
    TEG_V_row_Davis_spr_20(i) = TEG_V_Davis_spr_20(i) .* 17; 

% Resistances
    Casey_sum_R_i_row_20(i) = Casey_sum_20_R_i(i) .* 17;
    Casey_spr_R_i_row_20(i) = Casey_spr_20_R_i(i) .* 17;
    
    Davis_sum_R_i_row_20(i) = Davis_sum_20_R_i(i) .* 17;
    Davis_spr_R_i_row_20(i) = Davis_spr_20_R_i(i) .* 17;

% Currents
    Casey_sum_amps_row_20(i) = TEG_V_row_Casey_sum_20(i) ./ Casey_sum_R_i_row_20(i);
    Casey_spr_amps_row_20(i) = TEG_V_row_Casey_spr_20(i) ./ Casey_spr_R_i_row_20(i);
    
    Davis_sum_amps_row_20(i) = TEG_V_row_Davis_sum_20(i) ./ Davis_sum_R_i_row_20(i);
    Davis_spr_amps_row_20(i) = TEG_V_row_Davis_spr_20(i) ./ Davis_spr_R_i_row_20(i);

end

figure(38)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_row_Casey_sum_20)
    plot(t,TEG_V_row_Casey_spr_20)
    plot(t,TEG_V_row_Davis_sum_20)
    plot(t,TEG_V_row_Davis_spr_20)
    ylabel('TEG Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Voltage per Row (Sum of V) - [20% Clouds]')
    hold off

figure(39)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_R_i_row_20)
    plot(t,Casey_spr_R_i_row_20)
    plot(t,Davis_sum_R_i_row_20)
    plot(t,Davis_spr_R_i_row_20)
    ylabel('TEG Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Resistance per Row (Sum of R/Ohms) - [20% Clouds]')
    hold off

figure(40)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_amps_row_20)
    plot(t,Casey_spr_amps_row_20)
    plot(t,Davis_sum_amps_row_20)
    plot(t,Davis_spr_amps_row_20)
    ylabel('TEG Current [Amps]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Current per Row (V / R) - [20% Clouds]')
    hold off

% in FULL!!!
% 18 rows of 17 modules 
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)


% Resistance
    Casey_sum_20_R_i_full = zeros(1,length(t)); 
    Casey_spr_20_R_i_full = zeros(1,length(t));
    
    Davis_sum_20_R_i_full = zeros(1,length(t));
    Davis_spr_20_R_i_full = zeros(1,length(t));

% Power
    TEG_P_Casey_sum_20_full = zeros(1,length(t));
    TEG_P_Casey_spr_20_full = zeros(1,length(t));
    
    TEG_P_Davis_sum_20_full = zeros(1,length(t));
    TEG_P_Davis_spr_20_full = zeros(1,length(t));

% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Resistance
    Casey_sum_20_R_i_full(i) = (18 ./ Casey_sum_R_i_row_20(i) ).^-1 ;  
    Casey_spr_20_R_i_full(i) = (18 ./ Casey_spr_R_i_row_20(i) ).^-1 ;
    
    Davis_sum_20_R_i_full(i) = (18 ./ Davis_sum_R_i_row_20(i) ).^-1 ;
    Davis_spr_20_R_i_full(i) = (18 ./ Davis_spr_R_i_row_20(i) ).^-1 ;

% Power - Ohm's Law
    TEG_P_Casey_sum_20_full(i) =  (TEG_V_row_Casey_sum_20(i).^(2)) ./ ...
                          (4.*Casey_sum_20_R_i_full(i)); 
    
    TEG_P_Casey_spr_20_full(i) =  (TEG_V_row_Casey_spr_20(i).^(2)) ./ ...
                          (4.*Casey_spr_20_R_i_full(i)); 
    
    TEG_P_Davis_sum_20_full(i) =  (TEG_V_row_Davis_sum_20(i).^(2)) ./ ...
                          (4.*Davis_sum_20_R_i_full(i));
    
    TEG_P_Davis_spr_20_full(i) =  (TEG_V_row_Davis_spr_20(i).^(2)) ./ ...
                          (4.*Davis_spr_20_R_i_full(i));

end

figure(41)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_20_full)
    plot(t,TEG_P_Casey_spr_20_full)
    plot(t,TEG_P_Davis_sum_20_full)
    plot(t,TEG_P_Davis_spr_20_full)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per 1 Solar Panel - [20% Clouds]')
    hold off

%% --- %% -- % [40% Clouds] % -- %% --- %%
% First calculate per module
% Use Karabetoglu equation: [P = (V^2) /( 4*R_i)]
    TEG_P_Casey_sum_40 = zeros(1,length(t));
    TEG_P_Casey_spr_40 = zeros(1,length(t));
    
    TEG_P_Davis_sum_40 = zeros(1,length(t));
    TEG_P_Davis_spr_40 = zeros(1,length(t));


for i = 1:48
    TEG_P_Casey_sum_40(i) =  (TEG_V_Casey_sum_40(i).^(2)) ./ ...
                          (4 .* Casey_sum_40_R_i(i)); 
    
    TEG_P_Casey_spr_40(i) =  (TEG_V_Casey_spr_40(i).^(2)) ./ ...
                          (4 .* Casey_spr_40_R_i(i)); 
    
    TEG_P_Davis_sum_40(i) =  (TEG_V_Davis_sum_40(i).^(2)) ./ ...
                          (4 .* Davis_sum_40_R_i(i));
    
    TEG_P_Davis_spr_40(i) =  (TEG_V_Davis_spr_40(i).^(2)) ./ ...
                          (4 .* Davis_spr_40_R_i(i));
end

figure(42)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_40)
    plot(t,TEG_P_Casey_spr_40)
    plot(t,TEG_P_Davis_sum_40)
    plot(t,TEG_P_Davis_spr_40)
    ylabel('Power Rate [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power Generated - per module [40% Clouds] - [V^2/4.R]')
    hold off

% then calculate Power per PANEL - 17 x 18 ARRAY!
% Voltages
    TEG_V_row_Casey_sum_40 = zeros(1,length(t));
    TEG_V_row_Casey_spr_40 = zeros(1,length(t));
    
    TEG_V_row_Davis_sum_40 = zeros(1,length(t));
    TEG_V_row_Davis_spr_40 = zeros(1,length(t));

% Ohms - resistance
    Casey_sum_R_i_row_40 = zeros(1,length(t)); 
    Casey_spr_R_i_row_40 = zeros(1,length(t));
    
    Davis_sum_R_i_row_40 = zeros(1,length(t));
    Davis_spr_R_i_row_40 = zeros(1,length(t));

% Currents
    Casey_sum_amps_row_40 = zeros(1,length(t)); 
    Casey_spr_amps_row_40 = zeros(1,length(t));
    
    Davis_sum_amps_row_40 = zeros(1,length(t));
    Davis_spr_amps_row_40 = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Voltages   
    TEG_V_row_Casey_sum_40(i) = TEG_V_Casey_sum_40(i) .* 17; 
    TEG_V_row_Casey_spr_40(i) = TEG_V_Casey_spr_40(i) .* 17; 
    
    TEG_V_row_Davis_sum_40(i) = TEG_V_Davis_sum_40(i) .* 17; 
    TEG_V_row_Davis_spr_40(i) = TEG_V_Davis_spr_40(i) .* 17; 

% Resistances
    Casey_sum_R_i_row_40(i) = Casey_sum_40_R_i(i) .* 17;
    Casey_spr_R_i_row_40(i) = Casey_spr_40_R_i(i) .* 17;
    
    Davis_sum_R_i_row_40(i) = Davis_sum_40_R_i(i) .* 17;
    Davis_spr_R_i_row_40(i) = Davis_spr_40_R_i(i) .* 17;

% Currents
    Casey_sum_amps_row_40(i) = TEG_V_row_Casey_sum_40(i) ./ Casey_sum_R_i_row_40(i);
    Casey_spr_amps_row_40(i) = TEG_V_row_Casey_spr_40(i) ./ Casey_spr_R_i_row_40(i);
    
    Davis_sum_amps_row_40(i) = TEG_V_row_Davis_sum_40(i) ./ Davis_sum_R_i_row_40(i);
    Davis_spr_amps_row_40(i) = TEG_V_row_Davis_spr_40(i) ./ Davis_spr_R_i_row_40(i);

end

figure(43)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_row_Casey_sum_40)
    plot(t,TEG_V_row_Casey_spr_40)
    plot(t,TEG_V_row_Davis_sum_40)
    plot(t,TEG_V_row_Davis_spr_40)
    ylabel('TEG Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Voltage per Row (Sum of V) - [40% Clouds]')
    hold off

figure(44)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_R_i_row_40)
    plot(t,Casey_spr_R_i_row_40)
    plot(t,Davis_sum_R_i_row_40)
    plot(t,Davis_spr_R_i_row_40)
    ylabel('TEG Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Resistance per Row (Sum of R/Ohms) - [40% Clouds]')
    hold off

figure(45)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_amps_row_40)
    plot(t,Casey_spr_amps_row_40)
    plot(t,Davis_sum_amps_row_40)
    plot(t,Davis_spr_amps_row_40)
    ylabel('TEG Current [Amps]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Current per Row (V / R) - [40% Clouds]')
    hold off

% NOW IN FULL!!!
% 18 rows of 17 modules 
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)


% Resistance
    Casey_sum_40_R_i_full = zeros(1,length(t)); 
    Casey_spr_40_R_i_full = zeros(1,length(t));
    
    Davis_sum_40_R_i_full = zeros(1,length(t));
    Davis_spr_40_R_i_full = zeros(1,length(t));

% Power
    TEG_P_Casey_sum_40_full = zeros(1,length(t));
    TEG_P_Casey_spr_40_full = zeros(1,length(t));
    
    TEG_P_Davis_sum_40_full = zeros(1,length(t));
    TEG_P_Davis_spr_40_full = zeros(1,length(t));

% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Resistance
    Casey_sum_40_R_i_full(i) = (18 ./ Casey_sum_R_i_row_40(i) ).^-1 ;  
    Casey_spr_40_R_i_full(i) = (18 ./ Casey_spr_R_i_row_40(i) ).^-1 ;
    
    Davis_sum_40_R_i_full(i) = (18 ./ Davis_sum_R_i_row_40(i) ).^-1 ;
    Davis_spr_40_R_i_full(i) = (18 ./ Davis_spr_R_i_row_40(i) ).^-1 ;

% Power - Ohm's Law
    TEG_P_Casey_sum_40_full(i) =  (TEG_V_row_Casey_sum_40(i).^(2)) ./ ...
                          (4.*Casey_sum_40_R_i_full(i)); 
    
    TEG_P_Casey_spr_40_full(i) =  (TEG_V_row_Casey_spr_40(i).^(2)) ./ ...
                          (4.*Casey_spr_40_R_i_full(i)); 
    
    TEG_P_Davis_sum_40_full(i) =  (TEG_V_row_Davis_sum_40(i).^(2)) ./ ...
                          (4.*Davis_sum_40_R_i_full(i));
    
    TEG_P_Davis_spr_40_full(i) =  (TEG_V_row_Davis_spr_40(i).^(2)) ./ ...
                          (4.*Davis_spr_40_R_i_full(i));

end

figure(46)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_40_full)
    plot(t,TEG_P_Casey_spr_40_full)
    plot(t,TEG_P_Davis_sum_40_full)
    plot(t,TEG_P_Davis_spr_40_full)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per 1 Solar Panel - [40% Clouds]')
    hold off


%% --- %% -- % [60% Clouds] % -- %% --- %%
% Use Karabetoglu equation: [P = (V^2) /( 4*R_i)]
    TEG_P_Casey_sum_60 = zeros(1,length(t));
    TEG_P_Casey_spr_60 = zeros(1,length(t));
    
    TEG_P_Davis_sum_60 = zeros(1,length(t));
    TEG_P_Davis_spr_60 = zeros(1,length(t));


for i = 1:48
    TEG_P_Casey_sum_60(i) =  (TEG_V_Casey_sum_60(i).^(2)) ./ ...
                          (4 .* Casey_sum_60_R_i(i)); 
    
    TEG_P_Casey_spr_60(i) =  (TEG_V_Casey_spr_60(i).^(2)) ./ ...
                          (4 .* Casey_spr_60_R_i(i)); 
    
    TEG_P_Davis_sum_60(i) =  (TEG_V_Davis_sum_60(i).^(2)) ./ ...
                          (4 .* Davis_sum_60_R_i(i));
    
    TEG_P_Davis_spr_60(i) =  (TEG_V_Davis_spr_60(i).^(2)) ./ ...
                          (4 .* Davis_spr_60_R_i(i));
end

figure(47)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_60)
    plot(t,TEG_P_Casey_spr_60)
    plot(t,TEG_P_Davis_sum_60)
    plot(t,TEG_P_Davis_spr_60)
    ylabel('Power Rate [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power Generated - per module [60% Clouds] - [V^2/4.R]')
    hold off


% then calculate Power per PANEL - 17 x 18 ARRAY!
% Voltages
    TEG_V_row_Casey_sum_60 = zeros(1,length(t));
    TEG_V_row_Casey_spr_60 = zeros(1,length(t));
    
    TEG_V_row_Davis_sum_60 = zeros(1,length(t));
    TEG_V_row_Davis_spr_60 = zeros(1,length(t));

% Ohms - resistance
    Casey_sum_R_i_row_60 = zeros(1,length(t)); 
    Casey_spr_R_i_row_60 = zeros(1,length(t));
    
    Davis_sum_R_i_row_60 = zeros(1,length(t));
    Davis_spr_R_i_row_60 = zeros(1,length(t));

% Currents
    Casey_sum_amps_row_60 = zeros(1,length(t)); 
    Casey_spr_amps_row_60 = zeros(1,length(t));
    
    Davis_sum_amps_row_60 = zeros(1,length(t));
    Davis_spr_amps_row_60 = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Voltages   
    TEG_V_row_Casey_sum_60(i) = TEG_V_Casey_sum_60(i) .* 17; 
    TEG_V_row_Casey_spr_60(i) = TEG_V_Casey_spr_60(i) .* 17; 
    
    TEG_V_row_Davis_sum_60(i) = TEG_V_Davis_sum_60(i) .* 17; 
    TEG_V_row_Davis_spr_60(i) = TEG_V_Davis_spr_60(i) .* 17; 

% Resistances
    Casey_sum_R_i_row_60(i) = Casey_sum_60_R_i(i) .* 17;
    Casey_spr_R_i_row_60(i) = Casey_spr_60_R_i(i) .* 17;
    
    Davis_sum_R_i_row_60(i) = Davis_sum_60_R_i(i) .* 17;
    Davis_spr_R_i_row_60(i) = Davis_spr_60_R_i(i) .* 17;

% Currents
    Casey_sum_amps_row_60(i) = TEG_V_row_Casey_sum_60(i) ./ Casey_sum_R_i_row_60(i);
    Casey_spr_amps_row_60(i) = TEG_V_row_Casey_spr_60(i) ./ Casey_spr_R_i_row_60(i);
    
    Davis_sum_amps_row_60(i) = TEG_V_row_Davis_sum_60(i) ./ Davis_sum_R_i_row_60(i);
    Davis_spr_amps_row_60(i) = TEG_V_row_Davis_spr_60(i) ./ Davis_spr_R_i_row_60(i);

end

figure(48)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_row_Casey_sum_60)
    plot(t,TEG_V_row_Casey_spr_60)
    plot(t,TEG_V_row_Davis_sum_60)
    plot(t,TEG_V_row_Davis_spr_60)
    ylabel('TEG Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Voltage per Row (Sum of V) - [60% Clouds]')
    hold off

figure(49)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_R_i_row_60)
    plot(t,Casey_spr_R_i_row_60)
    plot(t,Davis_sum_R_i_row_60)
    plot(t,Davis_spr_R_i_row_60)
    ylabel('TEG Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Resistance per Row (Sum of R/Ohms) - [60% Clouds]')
    hold off

figure(50)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_amps_row_60)
    plot(t,Casey_spr_amps_row_60)
    plot(t,Davis_sum_amps_row_60)
    plot(t,Davis_spr_amps_row_60)
    ylabel('TEG Current [Amps]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Current per Row (V / R) - [60% Clouds]')
    hold off

% NOW IN FULL!!!
% 18 rows of 17 modules 
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)


% Resistance
    Casey_sum_60_R_i_full = zeros(1,length(t)); 
    Casey_spr_60_R_i_full = zeros(1,length(t));
    
    Davis_sum_60_R_i_full = zeros(1,length(t));
    Davis_spr_60_R_i_full = zeros(1,length(t));

% Power
    TEG_P_Casey_sum_60_full = zeros(1,length(t));
    TEG_P_Casey_spr_60_full = zeros(1,length(t));
    
    TEG_P_Davis_sum_60_full = zeros(1,length(t));
    TEG_P_Davis_spr_60_full = zeros(1,length(t));

% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Resistance
    Casey_sum_60_R_i_full(i) = (18 ./ Casey_sum_R_i_row_60(i) ).^-1 ;  
    Casey_spr_60_R_i_full(i) = (18 ./ Casey_spr_R_i_row_60(i) ).^-1 ;
    
    Davis_sum_60_R_i_full(i) = (18 ./ Davis_sum_R_i_row_60(i) ).^-1 ;
    Davis_spr_60_R_i_full(i) = (18 ./ Davis_spr_R_i_row_60(i) ).^-1 ;

% Power - Ohm's Law
    TEG_P_Casey_sum_60_full(i) =  (TEG_V_row_Casey_sum_60(i).^(2)) ./ ...
                          (4.*Casey_sum_60_R_i_full(i)); 
    
    TEG_P_Casey_spr_60_full(i) =  (TEG_V_row_Casey_spr_60(i).^(2)) ./ ...
                          (4.*Casey_spr_60_R_i_full(i)); 
    
    TEG_P_Davis_sum_60_full(i) =  (TEG_V_row_Davis_sum_60(i).^(2)) ./ ...
                          (4.*Davis_sum_60_R_i_full(i));
    
    TEG_P_Davis_spr_60_full(i) =  (TEG_V_row_Davis_spr_60(i).^(2)) ./ ...
                          (4.*Davis_spr_60_R_i_full(i));

end

figure(51)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_60_full)
    plot(t,TEG_P_Casey_spr_60_full)
    plot(t,TEG_P_Davis_sum_60_full)
    plot(t,TEG_P_Davis_spr_60_full)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per 1 Solar Panel - [60% Clouds]')
    hold off


%% --- %% -- % [80% Clouds] % -- %% --- %%
% Use Karabetoglu equation: [P = (V^2) /( 4*R_i)]
    TEG_P_Casey_sum_80 = zeros(1,length(t));
    TEG_P_Casey_spr_80 = zeros(1,length(t));
    
    TEG_P_Davis_sum_80 = zeros(1,length(t));
    TEG_P_Davis_spr_80 = zeros(1,length(t));


for i = 1:48
    TEG_P_Casey_sum_80(i) =  (TEG_V_Casey_sum_80(i).^(2)) ./ ...
                          (4 .* Casey_sum_80_R_i(i)); 
    
    TEG_P_Casey_spr_80(i) =  (TEG_V_Casey_spr_80(i).^(2)) ./ ...
                          (4 .* Casey_spr_80_R_i(i)); 
    
    TEG_P_Davis_sum_80(i) =  (TEG_V_Davis_sum_80(i).^(2)) ./ ...
                          (4 .* Davis_sum_80_R_i(i));
    
    TEG_P_Davis_spr_80(i) =  (TEG_V_Davis_spr_80(i).^(2)) ./ ...
                          (4 .* Davis_spr_80_R_i(i));
end

figure(52)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_80)
    plot(t,TEG_P_Casey_spr_80)
    plot(t,TEG_P_Davis_sum_80)
    plot(t,TEG_P_Davis_spr_80)
    ylabel('Power Rate [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power Generated - per module [80% Clouds] - [V^2/4.R]')
    hold off

% then calculate Power per PANEL - 17 x 18 ARRAY!
% Voltages
    TEG_V_row_Casey_sum_80 = zeros(1,length(t));
    TEG_V_row_Casey_spr_80 = zeros(1,length(t));
    
    TEG_V_row_Davis_sum_80 = zeros(1,length(t));
    TEG_V_row_Davis_spr_80 = zeros(1,length(t));

% Ohms - resistance
    Casey_sum_R_i_row_80 = zeros(1,length(t)); 
    Casey_spr_R_i_row_80 = zeros(1,length(t));
    
    Davis_sum_R_i_row_80 = zeros(1,length(t));
    Davis_spr_R_i_row_80 = zeros(1,length(t));

% Currents
    Casey_sum_amps_row_80 = zeros(1,length(t)); 
    Casey_spr_amps_row_80 = zeros(1,length(t));
    
    Davis_sum_amps_row_80 = zeros(1,length(t));
    Davis_spr_amps_row_80 = zeros(1,length(t));

for i = 1:48 % 17 modules in 1 row
% Voltages   
    TEG_V_row_Casey_sum_80(i) = TEG_V_Casey_sum_80(i) .* 17; 
    TEG_V_row_Casey_spr_80(i) = TEG_V_Casey_spr_80(i) .* 17; 
    
    TEG_V_row_Davis_sum_80(i) = TEG_V_Davis_sum_80(i) .* 17; 
    TEG_V_row_Davis_spr_80(i) = TEG_V_Davis_spr_80(i) .* 17; 

% Resistances
    Casey_sum_R_i_row_80(i) = Casey_sum_80_R_i(i) .* 17;
    Casey_spr_R_i_row_80(i) = Casey_spr_80_R_i(i) .* 17;
    
    Davis_sum_R_i_row_80(i) = Davis_sum_80_R_i(i) .* 17;
    Davis_spr_R_i_row_80(i) = Davis_spr_80_R_i(i) .* 17;

% Currents
    Casey_sum_amps_row_80(i) = TEG_V_row_Casey_sum_80(i) ./ Casey_sum_R_i_row_80(i);
    Casey_spr_amps_row_80(i) = TEG_V_row_Casey_spr_80(i) ./ Casey_spr_R_i_row_80(i);
    
    Davis_sum_amps_row_80(i) = TEG_V_row_Davis_sum_80(i) ./ Davis_sum_R_i_row_80(i);
    Davis_spr_amps_row_80(i) = TEG_V_row_Davis_spr_80(i) ./ Davis_spr_R_i_row_80(i);

end

figure(53)
    hold on
    grid on 
    grid minor
    plot(t,TEG_V_row_Casey_sum_80)
    plot(t,TEG_V_row_Casey_spr_80)
    plot(t,TEG_V_row_Davis_sum_80)
    plot(t,TEG_V_row_Davis_spr_80)
    ylabel('TEG Voltage [V]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Voltage per Row (Sum of V) - [80% Clouds]')
    hold off

figure(54)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_R_i_row_80)
    plot(t,Casey_spr_R_i_row_80)
    plot(t,Davis_sum_R_i_row_80)
    plot(t,Davis_spr_R_i_row_80)
    ylabel('TEG Resistance [Ohms]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Resistance per Row (Sum of R/Ohms) - [80% Clouds]')
    hold off

figure(55)
    hold on
    grid on 
    grid minor
    plot(t,Casey_sum_amps_row_80)
    plot(t,Casey_spr_amps_row_80)
    plot(t,Davis_sum_amps_row_80)
    plot(t,Davis_spr_amps_row_80)
    ylabel('TEG Current [Amps]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Current per Row (V / R) - [80% Clouds]')
    hold off

% NOW IN FULL!!!
% 18 rows of 17 modules 
% USING EQUATION [P = (V^2) / R] FOR THIS PART
% equation  considerS TEG aray using Ohm's law
% Karabetoglu is a conservative approach (1/4th of ohm's value)


% Resistance
    Casey_sum_80_R_i_full = zeros(1,length(t)); 
    Casey_spr_80_R_i_full = zeros(1,length(t));
    
    Davis_sum_80_R_i_full = zeros(1,length(t));
    Davis_spr_80_R_i_full = zeros(1,length(t));

% Power
    TEG_P_Casey_sum_80_full = zeros(1,length(t));
    TEG_P_Casey_spr_80_full = zeros(1,length(t));
    
    TEG_P_Davis_sum_80_full = zeros(1,length(t));
    TEG_P_Davis_spr_80_full = zeros(1,length(t));

% recall - 18 rows - VOLTAGE IS EQUAL ACROSS ROWS!!!
for i = 1:48
% Resistance
    Casey_sum_80_R_i_full(i) = (18 ./ Casey_sum_R_i_row_80(i) ).^-1 ;  
    Casey_spr_80_R_i_full(i) = (18 ./ Casey_spr_R_i_row_80(i) ).^-1 ;
    
    Davis_sum_80_R_i_full(i) = (18 ./ Davis_sum_R_i_row_80(i) ).^-1 ;
    Davis_spr_80_R_i_full(i) = (18 ./ Davis_spr_R_i_row_80(i) ).^-1 ;

% Power - Ohm's Law
    TEG_P_Casey_sum_80_full(i) =  (TEG_V_row_Casey_sum_80(i).^(2)) ./ ...
                          (4.*Casey_sum_80_R_i_full(i)); 
    
    TEG_P_Casey_spr_80_full(i) =  (TEG_V_row_Casey_spr_80(i).^(2)) ./ ...
                          (4.*Casey_spr_80_R_i_full(i)); 
    
    TEG_P_Davis_sum_80_full(i) =  (TEG_V_row_Davis_sum_80(i).^(2)) ./ ...
                          (4.*Davis_sum_80_R_i_full(i));
    
    TEG_P_Davis_spr_80_full(i) =  (TEG_V_row_Davis_spr_80(i).^(2)) ./ ...
                          (4.*Davis_spr_80_R_i_full(i));

end

figure(56)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_80_full)
    plot(t,TEG_P_Casey_spr_80_full)
    plot(t,TEG_P_Davis_sum_80_full)
    plot(t,TEG_P_Davis_spr_80_full)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per 1 Solar Panel - [80% Clouds]')
    hold off


%% Power Generation - Unit Area 
% For power comparison metrics
% in W/m^2
surf_area = (0.056 * 0.056); % 56mm * 56 mm

% 20 cases - compare per clouds case [5x]
% "TEG_P_Casey_sum_80"

% - [0% Clouds] - %
TEG_P_Casey_sum_unit = zeros(1,length(t));
TEG_P_Casey_spr_unit = zeros(1,length(t));

TEG_P_Davis_sum_unit = zeros(1,length(t));
TEG_P_Davis_spr_unit = zeros(1,length(t));

for i = 1:48 

    TEG_P_Casey_sum_unit(i) = TEG_P_Casey_sum(i) ./ surf_area;
    TEG_P_Casey_spr_unit(i) = TEG_P_Casey_spr(i) ./ surf_area;

    TEG_P_Davis_sum_unit(i) = TEG_P_Davis_sum(i) ./ surf_area;
    TEG_P_Davis_spr_unit(i) = TEG_P_Davis_spr(i) ./ surf_area;

    % Remember: this is with Karabetoglu equation (conservative)
end

figure(57)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_unit)
    plot(t,TEG_P_Casey_spr_unit)
    plot(t,TEG_P_Davis_sum_unit)
    plot(t,TEG_P_Davis_spr_unit)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per Unit area - [0% Clouds]')
    hold off

% - [20% Clouds] - %
TEG_P_Casey_sum_20_unit = zeros(1,length(t));
TEG_P_Casey_spr_20_unit = zeros(1,length(t));

TEG_P_Davis_sum_20_unit = zeros(1,length(t));
TEG_P_Davis_spr_20_unit = zeros(1,length(t));

for i = 1:48 

    TEG_P_Casey_sum_20_unit(i) = TEG_P_Casey_sum_20(i) ./ surf_area;
    TEG_P_Casey_spr_20_unit(i) = TEG_P_Casey_spr_20(i) ./ surf_area;

    TEG_P_Davis_sum_20_unit(i) = TEG_P_Davis_sum_20(i) ./ surf_area;
    TEG_P_Davis_spr_20_unit(i) = TEG_P_Davis_spr_20(i) ./ surf_area;

    % Remember: this is with Karabetoglu equation (conservative)
end

figure(58)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_20_unit)
    plot(t,TEG_P_Casey_spr_20_unit)
    plot(t,TEG_P_Davis_sum_20_unit)
    plot(t,TEG_P_Davis_spr_20_unit)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per Unit area - [20% Clouds]')
    hold off

% - [40% Clouds] - %
TEG_P_Casey_sum_40_unit = zeros(1,length(t));
TEG_P_Casey_spr_40_unit = zeros(1,length(t));

TEG_P_Davis_sum_40_unit = zeros(1,length(t));
TEG_P_Davis_spr_40_unit = zeros(1,length(t));

for i = 1:48 

    TEG_P_Casey_sum_40_unit(i) = TEG_P_Casey_sum_40(i) ./ surf_area;
    TEG_P_Casey_spr_40_unit(i) = TEG_P_Casey_spr_40(i) ./ surf_area;

    TEG_P_Davis_sum_40_unit(i) = TEG_P_Davis_sum_40(i) ./ surf_area;
    TEG_P_Davis_spr_40_unit(i) = TEG_P_Davis_spr_40(i) ./ surf_area;

    % Remember: this is with Karabetoglu equation (conservative)
end

figure(59)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_40_unit)
    plot(t,TEG_P_Casey_spr_40_unit)
    plot(t,TEG_P_Davis_sum_40_unit)
    plot(t,TEG_P_Davis_spr_40_unit)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per Unit area - [40% Clouds]')
    hold off

% - [60% Clouds] - %
TEG_P_Casey_sum_60_unit = zeros(1,length(t));
TEG_P_Casey_spr_60_unit = zeros(1,length(t));

TEG_P_Davis_sum_60_unit = zeros(1,length(t));
TEG_P_Davis_spr_60_unit = zeros(1,length(t));

for i = 1:48 

    TEG_P_Casey_sum_60_unit(i) = TEG_P_Casey_sum_60(i) ./ surf_area;
    TEG_P_Casey_spr_60_unit(i) = TEG_P_Casey_spr_60(i) ./ surf_area;

    TEG_P_Davis_sum_60_unit(i) = TEG_P_Davis_sum_60(i) ./ surf_area;
    TEG_P_Davis_spr_60_unit(i) = TEG_P_Davis_spr_60(i) ./ surf_area;

    % Remember: this is with Karabetoglu equation (conservative)
end

figure(60)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_60_unit)
    plot(t,TEG_P_Casey_spr_60_unit)
    plot(t,TEG_P_Davis_sum_60_unit)
    plot(t,TEG_P_Davis_spr_60_unit)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per Unit area - [60% Clouds]')
    hold off

% - [80% Clouds] - %
TEG_P_Casey_sum_80_unit = zeros(1,length(t));
TEG_P_Casey_spr_80_unit = zeros(1,length(t));

TEG_P_Davis_sum_80_unit = zeros(1,length(t));
TEG_P_Davis_spr_80_unit = zeros(1,length(t));

for i = 1:48 

    TEG_P_Casey_sum_80_unit(i) = TEG_P_Casey_sum_80(i) ./ surf_area;
    TEG_P_Casey_spr_80_unit(i) = TEG_P_Casey_spr_80(i) ./ surf_area;

    TEG_P_Davis_sum_80_unit(i) = TEG_P_Davis_sum_80(i) ./ surf_area;
    TEG_P_Davis_spr_80_unit(i) = TEG_P_Davis_spr_80(i) ./ surf_area;

    % Remember: this is with Karabetoglu equation (conservative)
end

figure(61)
    hold on
    grid on 
    grid minor
    plot(t,TEG_P_Casey_sum_80_unit)
    plot(t,TEG_P_Casey_spr_80_unit)
    plot(t,TEG_P_Davis_sum_80_unit)
    plot(t,TEG_P_Davis_spr_80_unit)
    ylabel('TEG Power [W]')
    xlabel('Time - 24 hour')
    legend('Casey - Summer','Casey - Spring','Davis - Summer','Davis - Spring')
    title('TEG Power in Array (V^2 / 4.R) - Per Unit area - [80% Clouds]')
    hold off
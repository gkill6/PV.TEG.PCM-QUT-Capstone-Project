%% ST3.2 PCM Heat Transfer
% created following V&V-I3.1, SS3.2, HC3.2, DD3.2
% purpose is to ACCURATELY model PCM heat as a THERMAL RESERVOIR 

% Need to consider PCM module as a whole
% want this to be more math based, use conservation of energy and prxoper
% heat equations


% If wanting to create universality, need to create table of usable values
% I.e. sunrise, sunset, temp max, temp min (determines solar profile)
% SCOPE CREEP ^ CONSIDER @ A LATER POINT
%% Environmental conditions 
% Casey & Davis - summer and spring daily scenarios
clc;
clear all;

% Time vector - discretisation of 24-hour window 
t = 0:0.5:23.5;

% Casey - Summer (9am-3pm)

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

%% Heat Convection - Energy in 
% use convection equation
% need to consider air as moving fluid, with selected wind speeds
% For now, assume wind speed VERY LOW (0.1 m/s) [consider other cases later]

% import tables
A9_Temp     = zeros(1,7);
A9_rho      = zeros(1,7);
A9_k        = zeros(1,7);
A9_mu       = zeros(1,7);
A9_Pr       = zeros(1,7);

A9 = readtable('Table A-9.xlsx',Range=[2,1,8,5]);
A9 = table2array(A9);

A9_Temp(1,1:7) = A9(1:7,1);
A9_rho(1,1:7)  = A9(1:7,2);
A9_k(1,1:7)    = A9(1:7,3);
A9_mu(1,1:7)   = A9(1:7,4);
A9_Pr(1,1:7)   = A9(1:7,5);

    air_rho_Casey_sum = zeros(1,length(t)); % air density based on temperature
    air_k_Casey_sum   = zeros(1,length(t)); % air thermal conductivity
    air_mu_Casey_sum  = zeros(1,length(t)); % Dynamic viscosity based on temperature
    air_Pr_Casey_sum  = zeros(1,length(t)); % Prandtl # for each point in time

    air_rho_Casey_spr = zeros(1,length(t)); % air density based on temperature
    air_k_Casey_spr   = zeros(1,length(t)); % air thermal conductivity
    air_mu_Casey_spr  = zeros(1,length(t)); % Dynamic viscosity based on temperature
    air_Pr_Casey_spr  = zeros(1,length(t)); % Prandtl # for each point in time

    air_rho_Davis_sum = zeros(1,length(t)); % air density based on temperature
    air_k_Davis_sum   = zeros(1,length(t)); % air thermal conductivity
    air_mu_Davis_sum  = zeros(1,length(t)); % Dynamic viscosity based on temperature
    air_Pr_Davis_sum  = zeros(1,length(t)); % Prandtl # for each point in time

    air_rho_Davis_spr = zeros(1,length(t)); % air density based on temperature
    air_k_Davis_spr   = zeros(1,length(t)); % air thermal conductivity
    air_mu_Davis_spr  = zeros(1,length(t)); % Dynamic viscosity based on temperature
    air_Pr_Davis_spr  = zeros(1,length(t)); % Prandtl # for each point in time


% goal: create reynolds # to track air flow during 24 hour period


% choose air values based on temperature - linear extrapolation
% Linear extrapolation: 
% Y(x) = Y(1) + (Y(2) - Y(1)).*( (x - x(1))/(x(2)-x(1)) )
% X = temperature
% Y = chosen value (A9_X)

%% Casey - summer
for i = 1:48
    if (Casey_summer_temp(i) > A9_Temp(1)) ... between -40 to -30 C
            && (Casey_summer_temp(i) < A9_Temp(2))

        air_rho_Casey_sum(i) = A9_rho(1) + ... air density at time point
            ( A9_rho(2) - A9_rho(1) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));
    
        air_mu_Casey_sum(i) = A9_mu(1) + ... air mu at time point
            ( A9_mu(2) - A9_mu(1) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));
    
        air_k_Casey_sum(i) = A9_k(1) + ... air Prandtl # at time point
            ( A9_k(2) - A9_k(1) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));
    
        air_Pr_Casey_sum(i) = A9_Pr(1) + ... air Prandtl # at time point
            ( A9_Pr(2) - A9_Pr(1) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));
    
    
    elseif (Casey_summer_temp(i) > A9_Temp(2)) ... between -30 to -20 C
            && (Casey_summer_temp(i) < A9_Temp(3))

        air_rho_Casey_sum(i) = A9_rho(2) + ... air density at time point
            ( A9_rho(3) - A9_rho(2) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));
    
        air_mu_Casey_sum(i) = A9_mu(2) + ... air mu at time point
            ( A9_mu(3) - A9_mu(2) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));
    
        air_k_Casey_sum(i) = A9_k(2) + ... air Prandtl # at time point
            ( A9_k(3) - A9_k(2) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));
    
        air_Pr_Casey_sum(i) = A9_Pr(2) + ... air Prandtl # at time point
            ( A9_Pr(3) - A9_Pr(2) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));
    
    
    elseif (Casey_summer_temp(i) > A9_Temp(3)) ... between -20 to -10 C
            && (Casey_summer_temp(i) < A9_Temp(4))

        air_rho_Casey_sum(i) = A9_rho(3) + ... air density at time point
            ( A9_rho(4) - A9_rho(3) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));
    
        air_mu_Casey_sum(i) = A9_mu(3) + ... air mu at time point
            ( A9_mu(4) - A9_mu(3) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));
    
        air_k_Casey_sum(i) = A9_k(3) + ... air Prandtl # at time point
            ( A9_k(4) - A9_k(3) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));
    
        air_Pr_Casey_sum(i) = A9_Pr(3) + ... air Prandtl # at time point
            ( A9_Pr(4) - A9_Pr(3) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));
    
    
    elseif (Casey_summer_temp(i) > A9_Temp(4)) ... between -10 to 0 C
            && (Casey_summer_temp(i) < A9_Temp(5))

        air_rho_Casey_sum(i) = A9_rho(4) + ... air density at time point
            ( A9_rho(5) - A9_rho(4) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));
    
        air_mu_Casey_sum(i) = A9_mu(4) + ... air mu at time point
            ( A9_mu(5) - A9_mu(4) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));
    
        air_k_Casey_sum(i) = A9_k(4) + ... air Prandtl # at time point
            ( A9_k(5) - A9_k(4) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));
    
        air_Pr_Casey_sum(i) = A9_Pr(4) + ... air Prandtl # at time point
            ( A9_Pr(5) - A9_Pr(4) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));

    
    elseif (Casey_summer_temp(i) > A9_Temp(5)) ... between 0 to +5 C
            && (Casey_summer_temp(i) < A9_Temp(6))

        air_rho_Casey_sum(i) = A9_rho(5) + ... air density at time point
            ( A9_rho(6) - A9_rho(5) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));
    
        air_mu_Casey_sum(i) = A9_mu(5) + ... air mu at time point
            ( A9_mu(6) - A9_mu(5) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));
    
        air_k_Casey_sum(i) = A9_k(5) + ... air Prandtl # at time point
            ( A9_k(6) - A9_k(5) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));
    
        air_Pr_Casey_sum(i) = A9_Pr(5) + ... air Prandtl # at time point
            ( A9_Pr(6) - A9_Pr(5) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));


    elseif (Casey_summer_temp(i) > A9_Temp(6)) ... between +5 to +10C
            && (Casey_summer_temp(i) < A9_Temp(7))

        air_rho_Casey_sum(i) = A9_rho(6) + ... air density at time point
            ( A9_rho(7) - A9_rho(6) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));
    
        air_mu_Casey_sum(i) = A9_mu(6) + ... air mu at time point
            ( A9_mu(7) - A9_mu(6) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));
    
        air_k_Casey_sum(i) = A9_k(6) + ... air Prandtl # at time point
            ( A9_k(7) - A9_k(6) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));
    
        air_Pr_Casey_sum(i) = A9_Pr(6) + ... air Prandtl # at time point
            ( A9_Pr(7) - A9_Pr(6) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));

    end

end

%% Casey - Spring
for i = 1:48
    if (Casey_spring_temp(i) > A9_Temp(1)) ... between -40 to -30 C
            && (Casey_spring_temp(i) < A9_Temp(2))

        air_rho_Casey_spr(i) = A9_rho(1) + ... air density at time point
            ( A9_rho(2) - A9_rho(1) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));
    
        air_mu_Casey_spr(i) = A9_mu(1) + ... air mu at time point
            ( A9_mu(2) - A9_mu(1) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));
    
        air_k_Casey_spr(i) = A9_k(1) + ... air Prandtl # at time point
            ( A9_k(2) - A9_k(1) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));
    
        air_Pr_Casey_spr(i) = A9_Pr(1) + ... air Prandtl # at time point
            ( A9_Pr(2) - A9_Pr(1) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));
    
    
    elseif (Casey_spring_temp(i) > A9_Temp(2)) ... between -30 to -20 C
            && (Casey_spring_temp(i) < A9_Temp(3))

        air_rho_Casey_spr(i) = A9_rho(2) + ... air density at time point
            ( A9_rho(3) - A9_rho(2) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));
    
        air_mu_Casey_spr(i) = A9_mu(2) + ... air mu at time point
            ( A9_mu(3) - A9_mu(2) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));
    
        air_k_Casey_spr(i) = A9_k(2) + ... air Prandtl # at time point
            ( A9_k(3) - A9_k(2) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));
    
        air_Pr_Casey_spr(i) = A9_Pr(2) + ... air Prandtl # at time point
            ( A9_Pr(3) - A9_Pr(2) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));
    
    
    elseif (Casey_spring_temp(i) > A9_Temp(3)) ... between -20 to -10 C
            && (Casey_spring_temp(i) < A9_Temp(4))

        air_rho_Casey_spr(i) = A9_rho(3) + ... air density at time point
            ( A9_rho(4) - A9_rho(3) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));
    
        air_mu_Casey_spr(i) = A9_mu(3) + ... air mu at time point
            ( A9_mu(4) - A9_mu(3) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));
    
        air_k_Casey_spr(i) = A9_k(3) + ... air Prandtl # at time point
            ( A9_k(4) - A9_k(3) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));
    
        air_Pr_Casey_spr(i) = A9_Pr(3) + ... air Prandtl # at time point
            ( A9_Pr(4) - A9_Pr(3) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));
    
    
    elseif (Casey_spring_temp(i) > A9_Temp(4)) ... between -10 to 0 C
            && (Casey_spring_temp(i) < A9_Temp(5))

        air_rho_Casey_spr(i) = A9_rho(4) + ... air density at time point
            ( A9_rho(5) - A9_rho(4) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));
    
        air_mu_Casey_spr(i) = A9_mu(4) + ... air mu at time point
            ( A9_mu(5) - A9_mu(4) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));
    
        air_k_Casey_spr(i) = A9_k(4) + ... air Prandtl # at time point
            ( A9_k(5) - A9_k(4) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));
    
        air_Pr_Casey_spr(i) = A9_Pr(4) + ... air Prandtl # at time point
            ( A9_Pr(5) - A9_Pr(4) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));

    
    elseif (Casey_spring_temp(i) > A9_Temp(5)) ... between 0 to +5 C
            && (Casey_spring_temp(i) < A9_Temp(6))

        air_rho_Casey_spr(i) = A9_rho(5) + ... air density at time point
            ( A9_rho(6) - A9_rho(5) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));
    
        air_mu_Casey_spr(i) = A9_mu(5) + ... air mu at time point
            ( A9_mu(6) - A9_mu(5) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));
    
        air_k_Casey_spr(i) = A9_k(5) + ... air Prandtl # at time point
            ( A9_k(6) - A9_k(5) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));
    
        air_Pr_Casey_spr(i) = A9_Pr(5) + ... air Prandtl # at time point
            ( A9_Pr(6) - A9_Pr(5) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));


    elseif (Casey_spring_temp(i) > A9_Temp(6)) ... between +5 to +10C
            && (Casey_spring_temp(i) < A9_Temp(7))

        air_rho_Casey_spr(i) = A9_rho(6) + ... air density at time point
            ( A9_rho(7) - A9_rho(6) ) .* ...
            ((Casey_sring_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));
    
        air_mu_Casey_spr(i) = A9_mu(6) + ... air mu at time point
            ( A9_mu(7) - A9_mu(6) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));
    
        air_k_Casey_spr(i) = A9_k(6) + ... air Prandtl # at time point
            ( A9_k(7) - A9_k(6) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));
    
        air_Pr_Casey_spr(i) = A9_Pr(6) + ... air Prandtl # at time point
            ( A9_Pr(7) - A9_Pr(6) ) .* ...
            ((Casey_spring_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));

    end

end

%% Davis - summer 
for i = 1:48
    if (Davis_summer_temp(i) > A9_Temp(1)) ... between -40 to -30 C
            && (Davis_summer_temp(i) < A9_Temp(2))

        air_rho_Davis_sum(i) = A9_rho(1) + ... air density at time point
            ( A9_rho(2) - A9_rho(1) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));

        air_mu_Davis_sum(i) = A9_mu(1) + ... air mu at time point
            ( A9_mu(2) - A9_mu(1) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));

        air_k_Davis_sum(i) = A9_k(1) + ... air Prandtl # at time point
            ( A9_k(2) - A9_k(1) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));

        air_Pr_Davis_sum(i) = A9_Pr(1) + ... air Prandtl # at time point
            ( A9_Pr(2) - A9_Pr(1) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));


    elseif (Davis_summer_temp(i) > A9_Temp(2)) ... between -30 to -20 C
            && (Davis_summer_temp(i) < A9_Temp(3))

        air_rho_Davis_sum(i) = A9_rho(2) + ... air density at time point
            ( A9_rho(3) - A9_rho(2) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));

        air_mu_Davis_sum(i) = A9_mu(2) + ... air mu at time point
            ( A9_mu(3) - A9_mu(2) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));

        air_k_Davis_sum(i) = A9_k(2) + ... air Prandtl # at time point
            ( A9_k(3) - A9_k(2) ) .* ...
            ((Casey_summer_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));

        air_Pr_Davis_sum(i) = A9_Pr(2) + ... air Prandtl # at time point
            ( A9_Pr(3) - A9_Pr(2) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));


    elseif (Davis_summer_temp(i) > A9_Temp(3)) ... between -20 to -10 C
            && (Davis_summer_temp(i) < A9_Temp(4))

        air_rho_Davis_sum(i) = A9_rho(3) + ... air density at time point
            ( A9_rho(4) - A9_rho(3) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));

        air_mu_Davis_sum(i) = A9_mu(3) + ... air mu at time point
            ( A9_mu(4) - A9_mu(3) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));

        air_k_Davis_sum(i) = A9_k(3) + ... air Prandtl # at time point
            ( A9_k(4) - A9_k(3) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));

        air_Pr_Davis_sum(i) = A9_Pr(3) + ... air Prandtl # at time point
            ( A9_Pr(4) - A9_Pr(3) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));


    elseif (Davis_summer_temp(i) > A9_Temp(4)) ... between -10 to 0 C
            && (Davis_summer_temp(i) < A9_Temp(5))

        air_rho_Davis_sum(i) = A9_rho(4) + ... air density at time point
            ( A9_rho(5) - A9_rho(4) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));

        air_mu_Davis_sum(i) = A9_mu(4) + ... air mu at time point
            ( A9_mu(5) - A9_mu(4) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));

        air_k_Davis_sum(i) = A9_k(4) + ... air Prandtl # at time point
            ( A9_k(5) - A9_k(4) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));

        air_Pr_Davis_sum(i) = A9_Pr(4) + ... air Prandtl # at time point
            ( A9_Pr(5) - A9_Pr(4) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));


    elseif (Davis_summer_temp(i) > A9_Temp(5)) ... between 0 to +5 C
            && (Davis_summer_temp(i) < A9_Temp(6))

        air_rho_Davis_sum(i) = A9_rho(5) + ... air density at time point
            ( A9_rho(6) - A9_rho(5) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));

        air_mu_Davis_sum(i) = A9_mu(5) + ... air mu at time point
            ( A9_mu(6) - A9_mu(5) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));

        air_k_Davis_sum(i) = A9_k(5) + ... air Prandtl # at time point
            ( A9_k(6) - A9_k(5) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));

        air_Pr_Davis_sum(i) = A9_Pr(5) + ... air Prandtl # at time point
            ( A9_Pr(6) - A9_Pr(5) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));


    elseif (Davis_summer_temp(i) > A9_Temp(6)) ... between +5 to +10C
            && (Davis_summer_temp(i) < A9_Temp(7))

        air_rho_Davis_sum(i) = A9_rho(6) + ... air density at time point
            ( A9_rho(7) - A9_rho(6) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));

        air_mu_Davis_sum(i) = A9_mu(6) + ... air mu at time point
            ( A9_mu(7) - A9_mu(6) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));

        air_k_Davis_sum(i) = A9_k(6) + ... air Prandtl # at time point
            ( A9_k(7) - A9_k(6) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));

        air_Pr_Davis_sum(i) = A9_Pr(6) + ... air Prandtl # at time point
            ( A9_Pr(7) - A9_Pr(6) ) .* ...
            ((Davis_summer_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));

    end

end

%% Davis - spring
for i = 1:48
    if (Davis_spring_temp(i) > A9_Temp(1)) ... between -40 to -30 C
            && (Davis_spring_temp(i) < A9_Temp(2))

        air_rho_Davis_spr(i) = A9_rho(1) + ... air density at time point
            ( A9_rho(2) - A9_rho(1) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));

        air_mu_Davis_spr(i) = A9_mu(1) + ... air mu at time point
            ( A9_mu(2) - A9_mu(1) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));

        air_k_Davis_spr(i) = A9_k(1) + ... air Prandtl # at time point
            ( A9_k(2) - A9_k(1) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));

        air_Pr_Davis_spr(i) = A9_Pr(1) + ... air Prandtl # at time point
            ( A9_Pr(2) - A9_Pr(1) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(1))./(A9_Temp(2)-A9_Temp(1)));


    elseif (Davis_spring_temp(i) > A9_Temp(2)) ... between -30 to -20 C
            && (Davis_spring_temp(i) < A9_Temp(3))

        air_rho_Davis_spr(i) = A9_rho(2) + ... air density at time point
            ( A9_rho(3) - A9_rho(2) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));

        air_mu_Davis_spr(i) = A9_mu(2) + ... air mu at time point
            ( A9_mu(3) - A9_mu(2) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));

        air_k_Davis_spr(i) = A9_k(2) + ... air Prandtl # at time point
            ( A9_k(3) - A9_k(2) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));

        air_Pr_Davis_spr(i) = A9_Pr(2) + ... air Prandtl # at time point
            ( A9_Pr(3) - A9_Pr(2) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(2))./(A9_Temp(3)-A9_Temp(2)));


    elseif (Davis_spring_temp(i) > A9_Temp(3)) ... between -20 to -10 C
            && (Davis_spring_temp(i) < A9_Temp(4))

        air_rho_Davis_spr(i) = A9_rho(3) + ... air density at time point
            ( A9_rho(4) - A9_rho(3) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));

        air_mu_Davis_spr(i) = A9_mu(3) + ... air mu at time point
            ( A9_mu(4) - A9_mu(3) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));

        air_k_Davis_spr(i) = A9_k(3) + ... air Prandtl # at time point
            ( A9_k(4) - A9_k(3) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));

        air_Pr_Davis_spr(i) = A9_Pr(3) + ... air Prandtl # at time point
            ( A9_Pr(4) - A9_Pr(3) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(3))./(A9_Temp(4)-A9_Temp(3)));


    elseif (Davis_spring_temp(i) > A9_Temp(4)) ... between -10 to 0 C
            && (Davis_spring_temp(i) < A9_Temp(5))

        air_rho_Davis_spr(i) = A9_rho(4) + ... air density at time point
            ( A9_rho(5) - A9_rho(4) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));

        air_mu_Davis_spr(i) = A9_mu(4) + ... air mu at time point
            ( A9_mu(5) - A9_mu(4) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));

        air_k_Davis_spr(i) = A9_k(4) + ... air Prandtl # at time point
            ( A9_k(5) - A9_k(4) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));

        air_Pr_Davis_spr(i) = A9_Pr(4) + ... air Prandtl # at time point
            ( A9_Pr(5) - A9_Pr(4) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(4))./(A9_Temp(5)-A9_Temp(4)));


    elseif (Davis_spring_temp(i) > A9_Temp(5)) ... between 0 to +5 C
            && (Davis_spring_temp(i) < A9_Temp(6))

        air_rho_Davis_spr(i) = A9_rho(5) + ... air density at time point
            ( A9_rho(6) - A9_rho(5) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));

        air_mu_Davis_spr(i) = A9_mu(5) + ... air mu at time point
            ( A9_mu(6) - A9_mu(5) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));

        air_k_Davis_spr(i) = A9_k(5) + ... air thermal k at time point
            ( A9_k(6) - A9_k(5) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));

        air_Pr_Davis_spr(i) = A9_Pr(5) + ... air Prandtl # at time point
            ( A9_Pr(6) - A9_Pr(5) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(5))./(A9_Temp(6)-A9_Temp(5)));


    elseif (Davis_spring_temp(i) > A9_Temp(6)) ... between +5 to +10C
            && (Davis_spring_temp(i) < A9_Temp(7))

        air_rho_Davis_spr(i) = A9_rho(6) + ... air density at time point
            ( A9_rho(7) - A9_rho(6) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));

        air_mu_Davis_spr(i) = A9_mu(6) + ... air mu at time point
            ( A9_mu(7) - A9_mu(6) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));

        air_k_Davis_spr(i) = A9_k(6) + ... air thermal k at time point
            ( A9_k(7) - A9_k(6) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));

        air_Pr_Davis_spr(i) = A9_Pr(6) + ... air Prandtl # at time point
            ( A9_Pr(7) - A9_Pr(6) ) .* ...
            ((Davis_spring_temp(i) - A9_Temp(6))./(A9_Temp(7)-A9_Temp(6)));

    end

end

%% Plot Air values
%sanity check
figure(2)

subplot(2,2,1)
    hold on 
    grid on
    grid minor
    plot(t,air_rho_Casey_sum);
    plot(t,air_rho_Casey_spr);
    plot(t,air_rho_Davis_sum);
    plot(t,air_rho_Davis_spr);
    ylabel('Density [kg/m^3]')
    xlabel('Time - 24 hour')
    legend('Casey - Sum','Casey - Spr','Davis - Sum','Davis - Spr')
    title('Density given air temp')
    hold off

subplot(2,2,2)
    hold on 
    grid on
    grid minor
    plot(t,air_k_Casey_sum);
    plot(t,air_k_Casey_spr);
    plot(t,air_k_Davis_sum);
    plot(t,air_k_Davis_spr);
    ylabel('Thermal Conductivity [W/m.K]')
    xlabel('Time - 24 hour')
    legend('Casey - Sum','Casey - Spr','Davis - Sum','Davis - Spr')
    title('thermal k given air temp')
    hold off

subplot(2,2,3)
    hold on 
    grid on
    grid minor
    plot(t,air_mu_Casey_sum);
    plot(t,air_mu_Casey_spr);
    plot(t,air_mu_Davis_sum);
    plot(t,air_mu_Davis_spr);
    ylabel('Dynamic Viscosity (kg/m.s)')
    xlabel('Time - 24 hour')
    legend('Casey - Sum','Casey - Spr','Davis - Sum','Davis - Spr')
    title('Mu given air temp')
    hold off

subplot(2,2,4)
    hold on 
    grid on
    grid minor
    plot(t,air_Pr_Casey_sum);
    plot(t,air_Pr_Casey_spr);
    plot(t,air_Pr_Davis_sum);
    plot(t,air_Pr_Davis_spr);
    ylabel('Prandtl #')
    xlabel('Time - 24 hour')
    legend('Casey - Sum','Casey - Spr','Davis - Sum','Davis - Spr')
    title('Prandtl # given air temp')
    hold off

%% Reynolds 
% Re = (rho * V * L) / (mu)
% assume L = 1, unit area
L_conv = 1;
air_V  = 2.78; % m/s - considering no wind at first 

air_Re_Casey_sum      = zeros(1,length(t)); % Reynolds # for each point in time
air_Nu_Casey_sum      = zeros(1,length(t)); % Nusselt # for each point in time

air_Re_Casey_spr      = zeros(1,length(t)); % Reynolds # for each point in time
air_Nu_Casey_spr      = zeros(1,length(t)); % Nusselt # for each point in time

air_Re_Davis_sum      = zeros(1,length(t));
air_Nu_Davis_sum      = zeros(1,length(t));

air_Re_Davis_spr      = zeros(1,length(t));
air_Nu_Davis_spr      = zeros(1,length(t));



% Re_crit = 500,000 
% Nusselt
% Depends on turbulent or laiminar flow 
% Laminar: Nu = 0.664 * (Re ^ (1/2) ) * ( Pr ^ (1/3) ) ; 
% Critical: Nu = ( 0.037 * (Re ^ (4/5)) ) - 871)*(Pr ^ (1/3)) ;
% Turbulent: Nu = 0.037 * (Re ^ (4/5) ) * ( Pr ^ (1/3) ) ; 

for i = 1:48
    % Casey Summer
    air_Re_Casey_sum(i)  = ...
        (air_rho_Casey_sum(i) .* air_V .* L_conv) / ( air_mu_Casey_sum(i) );

    % LAMINAR VALUES ONLY
        if air_Re_Casey_sum(i) < (500000)
            air_Nu_Casey_sum(i) = 0.664 .* ...
                (air_Re_Casey_sum(i) .^(1/2) ) .* ( air_Pr_Casey_sum(i) ^ (1/3) ); 
 
        elseif air_Re_Casey_sum(i) == (500000)
            air_Nu_Casey_sum(i) = (air_Pr_Casey_sum(i) ^ (1/3)).* ...
                (( 0.037 * (air_Re_Casey_sum(i).^(4/5) )) - 871);
        else
            air_Nu_Casey_sum(i) = (air_Pr_Casey_sum(i) .^ (1/3)).* ...
                (( 0.037 .* (air_Re_Casey_sum(i).^(4/5) )));
        end
    
    % Casey Spring
    air_Re_Casey_spr(i)  = ...
        (air_rho_Casey_spr(i) .* air_V .* L_conv) / ( air_mu_Casey_spr(i) ); 
 
        if air_Re_Casey_spr(i) < (500000)
            air_Nu_Casey_spr(i) = 0.664 .* ...
                (air_Re_Casey_spr(i) .^(1/2) ) .* ( air_Pr_Casey_spr(i) ^ (1/3) ); 
 
        elseif air_Re_Casey_spr(i) == (500000)
            air_Nu_Casey_spr(i) = (air_Pr_Casey_spr(i) .^ (1/3)).* ...
                (( 0.037 * (air_Re_Casey_spr(i).^(4/5) )) - 871);
        else
            air_Nu_Casey_spr(i) = (air_Pr_Casey_spr(i) .^ (1/3)).* ...
                (( 0.037 * (air_Re_Casey_spr(i).^(4/5) )));
        end


    % Davis Summer
    air_Re_Davis_sum(i)  = ...
        (air_rho_Davis_sum(i) .* air_V .* L_conv) / ( air_mu_Davis_sum(i) );

        if air_Re_Davis_sum(i) < (500000)
            air_Nu_Davis_sum(i) = 0.664 .* ...
                (air_Re_Davis_sum(i) .^(1/2) ) .* ( air_Pr_Davis_sum(i) ^ (1/3) ); 
 
        elseif air_Re_Davis_sum(i) == (500000)
            air_Nu_Davis_sum(i) = (air_Pr_Davis_sum(i) .^ (1/3)).* ...
                (( 0.037 * (air_Re_Davis_sum(i).^(4/5) )) - 871);
        else
            air_Nu_Davis_sum(i) = (air_Pr_Davis_sum(i) .^ (1/3)).* ...
                (( 0.037 .* (air_Re_Davis_sum(i).^(4/5) )));
        end

    % Davis Spring
    air_Re_Davis_spr(i)  = ...
        (air_rho_Davis_spr(i) .* air_V .* L_conv) / ( air_mu_Davis_spr(i) ); 
 
        if air_Re_Davis_spr(i) < (500000)
            air_Nu_Davis_spr(i) = 0.664 .* ...
                (air_Re_Davis_spr(i) .^(1/2) ) .* ( air_Pr_Davis_spr(i) ^ (1/3) ); 
 
        elseif air_Re_Davis_spr(i) == (500000)
            air_Nu_Davis_spr(i) = (air_Pr_Davis_spr(i) .^ (1/3)).* ...
                (( 0.037 * (air_Re_Davis_spr(i).^(4/5) )) - 871);
        else
            air_Nu_Davis_spr(i) = (air_Pr_Davis_spr(i) .^ (1/3)).* ...
                (( 0.037 .* (air_Re_Davis_spr(i).^(4/5) )));
        end    

end

% Convection coefficient 
% h = (Nu * k) / L

conv_coeff_Casey_sum = zeros(1,length(t));
conv_coeff_Casey_spr = zeros(1,length(t));

conv_coeff_Davis_sum = zeros(1,length(t));
conv_coeff_Davis_spr = zeros(1,length(t));

for i = 1:48

conv_coeff_Casey_sum(i) = (air_Nu_Casey_sum(i) .* air_k_Casey_sum(i) )...
                        ./ L_conv ;

conv_coeff_Casey_spr(i) = (air_Nu_Casey_spr(i) .* air_k_Casey_spr(i) )...
                        ./ L_conv ;

conv_coeff_Davis_sum(i) = (air_Nu_Davis_sum(i) .* air_k_Davis_sum(i) )...
                        ./ L_conv ;

conv_coeff_Davis_spr(i) = (air_Nu_Davis_spr(i) .* air_k_Davis_spr(i) )...
                        ./ L_conv ;

end


figure(10)
subplot(3,1,1)
    hold on
    grid on
    grid minor
    plot(t,air_Re_Casey_sum)
    plot(t,air_Re_Casey_spr)
    plot(t,air_Re_Davis_sum)
    plot(t,air_Re_Davis_spr)
    ylabel('Reynolds #')
    xlabel('Time - 24 hour')
    legend('Casey - Sum','Casey - Spr','Davis - Sum','Davis - Spr')
    title('Reynolds # given air temp (V = 1m/s)')
    hold off

subplot(3,1,2)
    hold on
    grid on
    grid minor
    plot(t,air_Nu_Casey_sum)
    plot(t,air_Nu_Casey_spr)
    plot(t,air_Nu_Davis_sum)
    plot(t,air_Nu_Davis_spr)
    ylabel('Nusselt #')
    xlabel('Time - 24 hour')
    legend('Casey - Sum','Casey - Spr','Davis - Sum','Davis - Spr')
    title('Nusselt # given air temp')
    hold off

 subplot(3,1,3)
    hold on
    grid on
    grid minor
    plot(t,conv_coeff_Casey_sum)
    plot(t,conv_coeff_Casey_spr)
    plot(t,conv_coeff_Davis_sum)
    plot(t,conv_coeff_Davis_spr)
    ylabel('Conv. Coeff. (W/m^2.K)')
    xlabel('Time - 24 hour')
    legend('Casey - Sum','Casey - Spr','Davis - Sum','Davis - Spr')
    title('Convection coeff. given air temp')
    hold off   


%% set wall surface temps (ts1,ts2)
Casey_Summer_wall_temp_1 = zeros(1,length(t));
Casey_Spring_wall_temp_1 = zeros(1,length(t));

Davis_Summer_wall_temp_1 = zeros(1,length(t));
Davis_Spring_wall_temp_1 = zeros(1,length(t));



% make outside wall temp ONE TIMESTEP BEHIND    
for i = 1:48
    
    if i == 1
        Casey_Summer_wall_temp_1(i) = Casey_summer_temp(48);
        Casey_Spring_wall_temp_1(i) = Casey_spring_temp(48);

        Davis_Summer_wall_temp_1(i) = Davis_summer_temp(48);
        Davis_Spring_wall_temp_1(i) = Davis_spring_temp(48);
                
    else
        Casey_Summer_wall_temp_1(i) = Casey_summer_temp(i-1);
        Casey_Spring_wall_temp_1(i) = Casey_spring_temp(i-1);

        Davis_Summer_wall_temp_1(i) = Davis_summer_temp(i-1);
        Davis_Spring_wall_temp_1(i) = Davis_spring_temp(i-1);

    end

end 

figure(3)
    subplot(2,2,1)
    hold on 
    grid on
    grid minor
    plot(t,Casey_summer_temp);
    plot(t,Casey_Summer_wall_temp_1);
    ylabel('Temperature [C]')
    xlabel('Time - 24 hour')
    legend('C-Sum Amb','C-Sum Outer wall')
    title('Beryllium Oxide Wall Temps - Casey Summer Case')
    hold off

    subplot(2,2,2)
    hold on 
    grid on
    grid minor
    plot(t,Casey_spring_temp);
    plot(t,Casey_Spring_wall_temp_1);
    ylabel('Temperature [C]')
    xlabel('Time - 24 hour')
    legend('C-Spr Amb','C-Spr Outer wall')
    title('Beryllium Oxide Wall Temps - Casey Spring Case')
    hold off

    subplot(2,2,3)
    hold on 
    grid on
    grid minor
    plot(t,Davis_summer_temp);
    plot(t,Davis_Summer_wall_temp_1);
    ylabel('Temperature [C]')
    xlabel('Time - 24 hour')
    legend('D-Sum Amb','D-Sum Outer wall')
    title('Beryllium Oxide Wall Temps - Davis Summer Case')
    hold off

    subplot(2,2,4)
    hold on 
    grid on
    grid minor
    plot(t,Davis_spring_temp);
    plot(t,Davis_Spring_wall_temp_1);
    ylabel('Temperature [C]')
    xlabel('Time - 24 hour')
    legend('D-Spr Amb','D-Spr Outer wall')
    title('Beryllium Oxide Wall Temps - Davis Spring Case')
    hold off

%% Q = h * A * (T - Tamb)
Q_flux_conv_Casey_sum = zeros(1,length(t));
Q_flux_conv_Casey_spr = zeros(1,length(t));

Q_flux_conv_Davis_sum = zeros(1,length(t));
Q_flux_conv_Davis_spr = zeros(1,length(t));

% A = 1 (unit area)

for i = 1:48

    Q_flux_conv_Casey_sum(i) = conv_coeff_Casey_sum(i) .* 1 .* ...
        (Casey_summer_temp(i)-Casey_Summer_wall_temp_1(i));

    Q_flux_conv_Casey_spr(i) = conv_coeff_Casey_spr(i) .* 1 .* ...
        (Casey_spring_temp(i)-Casey_Spring_wall_temp_1(i));

    
    Q_flux_conv_Davis_sum(i) = conv_coeff_Davis_sum(i) .* 1 .* ...
        (Davis_summer_temp(i)-Davis_Summer_wall_temp_1(i));

    Q_flux_conv_Davis_spr(i) = conv_coeff_Davis_spr(i) .* 1 .* ...
        (Davis_spring_temp(i)-Davis_Spring_wall_temp_1(i));

    % with this orientation, Positive = absorb

end

figure(4)
hold on 
grid on
grid minor
plot(t,Q_flux_conv_Casey_sum);
plot(t,Q_flux_conv_Casey_spr);
plot(t,Q_flux_conv_Davis_sum);
plot(t,Q_flux_conv_Davis_spr);

ylabel('Q_flux convection [W]')
xlabel('Time - 24 hour')
legend('Casey Sum','Casey Spr','Davis Sum','Davis Spr')
title('heat Transfer - Convection across BeO wall - Wind = 1m/s')
hold off

%% Heat flux across BeO wall - conduction 
% taking heat flux = const and outside temp, find inner wall temp
% Q conv = Q_cond
% Q_cond = -k * A * (dT/dx)
% thus, Q_cond / (-k*A) = dT/dx
% thus, T2 = T1 + Q_cond/(-k*A)
k_BeO = 210; % W/m.k - beryllium oxide
L_cond = 0.01; % 1cm wall

Casey_Summer_wall_temp_2 = zeros(1,length(t));
Casey_Spring_wall_temp_2 = zeros(1,length(t));

Davis_Summer_wall_temp_2 = zeros(1,length(t));
Davis_Spring_wall_temp_2 = zeros(1,length(t));


for i = 1:48

    Casey_Summer_wall_temp_2(i) = ...
        ((Q_flux_conv_Casey_sum(i) .* L_cond) ./ ( k_BeO * 1))...
        + Casey_Summer_wall_temp_1(i);

    Casey_Spring_wall_temp_2(i) = ...
        ((Q_flux_conv_Casey_spr(i) .* L_cond) ./ ( k_BeO * 1))...
        + Casey_Spring_wall_temp_1(i);

    Davis_Summer_wall_temp_2(i) = ...
        ((Q_flux_conv_Davis_sum(i) .* L_cond) ./ ( k_BeO * 1))...
        + Davis_Summer_wall_temp_1(i);

    Davis_Spring_wall_temp_2(i) = ...
        ((Q_flux_conv_Davis_spr(i) .* L_cond) ./ ( k_BeO * 1))...
        + Davis_Spring_wall_temp_1(i);

end

figure(5)
subplot(2,2,1)
    hold on 
    grid on
    grid minor
    plot(t,(Casey_Summer_wall_temp_1-Casey_Summer_wall_temp_2))

    ylabel('Temp [c]')
    xlabel('Time - 24 hour')
    legend('Temp diff')
    title('Casey Summer Wall Temp diff (cond)')
    hold off

subplot(2,2,2)
    hold on 
    grid on
    grid minor
    plot(t,(Casey_Spring_wall_temp_1-Casey_Spring_wall_temp_2));
    
    ylabel('Temp [c]')
    xlabel('Time - 24 hour')
    legend('Temp diff')
    title('Casey Spring Wall Temp diff (cond)')
    hold off

subplot(2,2,3)
    hold on 
    grid on
    grid minor
    plot(t,(Davis_Summer_wall_temp_1-Davis_Summer_wall_temp_2));
    
    ylabel('Temp [c]')
    xlabel('Time - 24 hour')
    legend('Temp diff')
    title('Davis Summer Wall Temp diff (cond)')
    hold off

subplot(2,2,4)
    hold on 
    grid on
    grid minor
    plot(t,(Davis_Spring_wall_temp_1-Davis_Spring_wall_temp_2));
    
    ylabel('Temp [c]')
    xlabel('Time - 24 hour')
    legend('Temp diff')
    title('Davis Spring Wall Temp diff (cond)')
    hold off

%% PCM - state & internal energy 
% using heat flux from previous section, find PCM internal state &
% temperature

% serve as an approximate (will compare accuracies with heat flux in CAD) 
% let PCM temp = inner wall

% Q conv = Q flux = Q into PCM 
Q_flux_PCM_int_e_Casey_sum    = zeros(1,length(t)); %energy absorbed @ each time step
PCM_int_e_Casey_sum           = zeros(1,length(t)); % total energy 

Q_flux_PCM_int_e_Casey_spr    = zeros(1,length(t)); %energy absorbed @ each time step
PCM_int_e_Casey_spr           = zeros(1,length(t)); % total energy 

Q_flux_PCM_int_e_Davis_sum    = zeros(1,length(t)); %energy absorbed @ each time step
PCM_int_e_Davis_sum           = zeros(1,length(t)); % total energy 

Q_flux_PCM_int_e_Davis_spr    = zeros(1,length(t)); %energy absorbed @ each time step
PCM_int_e_Davis_spr           = zeros(1,length(t)); % total energy 



for i = 1:48
    Q_flux_PCM_int_e_Casey_sum(i) = Q_flux_conv_Casey_sum(i) .* 1800; % x 1800 seconds

    Q_flux_PCM_int_e_Casey_spr(i) = Q_flux_conv_Casey_spr(i) .* 1800; % x 1800 seconds

    Q_flux_PCM_int_e_Davis_sum(i) = Q_flux_conv_Davis_sum(i) .* 1800; % x 1800 seconds

    Q_flux_PCM_int_e_Davis_spr(i) = Q_flux_conv_Davis_spr(i) .* 1800; % x 1800 seconds


end

for i = 1:48
    if i == 1
        PCM_int_e_Casey_sum(i) = 0;
        PCM_int_e_Casey_spr(i) = 0;
        PCM_int_e_Davis_sum(i) = 0;
        PCM_int_e_Davis_spr(i) = 0;

    else
    PCM_int_e_Casey_sum(i) = PCM_int_e_Casey_sum(i-1) + ...
        Q_flux_PCM_int_e_Casey_sum(i); 

    PCM_int_e_Casey_spr(i) = PCM_int_e_Casey_spr(i-1) + ...
        Q_flux_PCM_int_e_Casey_spr(i); 

    PCM_int_e_Davis_sum(i) = PCM_int_e_Davis_sum(i-1) + ...
        Q_flux_PCM_int_e_Davis_sum(i); 

    PCM_int_e_Davis_spr(i) = PCM_int_e_Davis_spr(i-1) + ...
        Q_flux_PCM_int_e_Davis_spr(i); 

    end
end

figure(6)

subplot(2,1,1)
    hold on
    grid on
    grid minor
    
    plot(t,Q_flux_PCM_int_e_Casey_sum)
    plot(t,Q_flux_PCM_int_e_Casey_spr)
    plot(t,Q_flux_PCM_int_e_Davis_sum)
    plot(t,Q_flux_PCM_int_e_Davis_spr)
    
    ylabel('Q flux into PCM [W per 30min]')
    xlabel('Time - 24 hour')
    legend('Casey Summer','Casey Spring','Davis Summer','Davis Spring')
    title('Q flux into PCM (energy absorbed/released)')
    hold off

subplot(2,1,2)
    hold on
    grid on
    grid minor
    
    plot(t,PCM_int_e_Casey_sum)
    plot(t,PCM_int_e_Casey_spr)
    plot(t,PCM_int_e_Davis_sum)
    plot(t,PCM_int_e_Davis_spr)
    
    ylabel('PCM internal energy [J/kg]')
    xlabel('Time - 24 hour')
    legend('Casey Summer','Casey Spring','Davis Summer','Davis Spring')
    title('Total internal energy absorbed/released')
    hold off



%% use specific heat capacities to find PCM temperature based on heat flux
% wondering if iI should redo this - base "momentum" on flux value


PCM_temp_Casey_sum = zeros(1,length(t));
PCM_temp_Casey_spr = zeros(1,length(t));

PCM_temp_Davis_sum = zeros(1,length(t));
PCM_temp_Davis_spr = zeros(1,length(t));

Cp_Liq = 3200 ; % J/kg.K
Cp_Sol = 2100 ; % J/kg.K

H_fus = 290000 ; % J / kg - latent heat of fusion
% Q = m * (int cp * dt)
PCM_den = 1052; %kg/m^3
PCM_vol = 0.98 * 0.98 * 0.02; % 1cm wall on unit area & PCM depth 2cm

% thus
m_PCM = PCM_den * PCM_vol; 

% try function to detect change in temp based on q flux
% let's try with summer first - recall PCM & wall temp "behind" ambient

    % initialise = thermal equilibirum

PCM_temp_Casey_sum(1) = Casey_Summer_wall_temp_2(i);
PCM_temp_Casey_spr(1) = Casey_Spring_wall_temp_2(i);

PCM_temp_Davis_sum(1) = Davis_Summer_wall_temp_2(i);
PCM_temp_Davis_spr(1) = Davis_Spring_wall_temp_2(i);

% temperature is equivalent to amount of heat added / heat capacity 

% Morning - Absorption
for i = 2:25    
% --- CASEY STATION --- %
% summer
    PCM_temp_Casey_sum(i) = PCM_temp_Casey_sum(i-1) + ...
        (Q_flux_PCM_int_e_Casey_sum(i-1))/(m_PCM*Cp_Liq);

    % Conservation of energy check
    if  PCM_temp_Casey_sum(i) > max(Casey_summer_temp)
        PCM_temp_Casey_sum(i) = max(Casey_summer_temp);
    end


% spring
    PCM_temp_Casey_spr(i) = PCM_temp_Casey_spr(i-1) + ...
        (Q_flux_PCM_int_e_Casey_spr(i-1))/(m_PCM*Cp_Sol);
    
    % check for conservation of energy
    if  PCM_temp_Casey_spr(i) > Casey_spring_temp(i)
        PCM_temp_Casey_spr(i) = Casey_spring_temp(i);
    end

 
% --- DAVIS STATION --- %

% Summer
    PCM_temp_Davis_sum(i) = PCM_temp_Davis_sum(i-1) + ...
    (Q_flux_PCM_int_e_Davis_sum(i-1))/(m_PCM*Cp_Liq);

    % Conservation of energy check
    if  PCM_temp_Davis_sum(i) > max(Davis_summer_temp)
        PCM_temp_Davis_sum(i) = max(Davis_summer_temp);
    end



% Spring
    PCM_temp_Davis_spr(i) = PCM_temp_Davis_spr(i-1) + ...
    (Q_flux_PCM_int_e_Davis_spr(i-1))/(m_PCM*Cp_Sol);
    
    % Conservation of energy check
    if  PCM_temp_Davis_spr(i) > Davis_spring_temp(i)
        PCM_temp_Davis_spr(i) = Davis_spring_temp(i);
    end


end


% --- Afternoon + Emission --- %
for i = 26:48
% --- CASEY STATION --- %
% Summer
    PCM_temp_Casey_sum(i) = PCM_temp_Casey_sum(i-1) + ...
        (Q_flux_PCM_int_e_Casey_sum(i-1))/(m_PCM*Cp_Liq);
    
    % Energy Check
    if  PCM_temp_Casey_sum(i) > max(Casey_summer_temp)
        PCM_temp_Casey_sum(i) = max(Casey_summer_temp);
    end
    
    if  PCM_temp_Casey_sum(i) < min(Casey_summer_temp)
        PCM_temp_Casey_sum(i) = min(Casey_summer_temp);
    end

    % force temp back to ambient
    if (Q_flux_PCM_int_e_Casey_sum(i-1) == 0) && ...
            (PCM_temp_Casey_sum(i) ~= Casey_summer_temp(i))
    
        PCM_temp_Casey_sum(i) = Casey_summer_temp(i);

    end


% Spring
    PCM_temp_Casey_spr(i) = PCM_temp_Casey_spr(i-1) + ...
        (Q_flux_PCM_int_e_Casey_spr(i-1))/(m_PCM*Cp_Sol);
    
    % Energy Check
    if  PCM_temp_Casey_spr(i) > max(Casey_spring_temp)
        PCM_temp_Casey_spr(i) = max(Casey_spring_temp);
    end

    if  PCM_temp_Casey_spr(i) < min(Casey_spring_temp)
        PCM_temp_Casey_spr(i) = min(Casey_spring_temp);
    end


% --- DAVIS STATION --- %

% Summer
    PCM_temp_Davis_sum(i) = PCM_temp_Davis_sum(i-1) + ...
    (Q_flux_PCM_int_e_Davis_sum(i-1))/(m_PCM*Cp_Liq);
    
    % Energy Check
    if  PCM_temp_Davis_sum(i) > max(Davis_summer_temp)
        PCM_temp_Davis_sum(i) = max(Davis_summer_temp);
    end
    
    if  PCM_temp_Davis_sum(i) < min(Davis_summer_temp)
        PCM_temp_Davis_sum(i) = min(Davis_summer_temp);
    end

    % force temp back to ambient
    if (Q_flux_PCM_int_e_Davis_sum(i-1) == 0) && ...
            (PCM_temp_Davis_sum(i) ~= Davis_summer_temp(i))
    
        PCM_temp_Davis_sum(i) = Davis_summer_temp(i);

    end

% Spring
    PCM_temp_Davis_spr(i) = PCM_temp_Davis_spr(i-1) + ...
    (Q_flux_PCM_int_e_Davis_spr(i-1))/(m_PCM*Cp_Sol);

    % Energy Check
    if  PCM_temp_Davis_spr(i) > max(Davis_spring_temp)
        PCM_temp_Davis_spr(i) = max(Davis_spring_temp);
    end

    if  PCM_temp_Davis_spr(i) < min(Davis_spring_temp)
        PCM_temp_Davis_spr(i) = min(Davis_spring_temp);
    end




end



% plotting
figure(20)
    hold on
    grid on
    grid minor
    plot(t,PCM_temp_Casey_sum,'r')
    plot(t,Casey_summer_temp,'b')
    plot(t,Casey_Summer_wall_temp_2,'k')
    
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('PCM temp','Ambient','Wall 2 (~1)')
    title('Temp: PCM vs walls vs ambient - Casey, Summer')
    hold off

figure(21)
    hold on
    grid on
    grid minor
    plot(t,PCM_temp_Casey_spr,'r')
    plot(t,Casey_spring_temp,'b')
    plot(t,Casey_Spring_wall_temp_2,'k')
    
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('PCM temp','Ambient','Wall 2 (~1)')
    title('Temp: PCM vs walls vs ambient - Casey, Spring')
    hold off


    
figure(22)
    hold on
    grid on
    grid minor
    plot(t,PCM_temp_Davis_sum,'r')
    plot(t,Davis_summer_temp,'b')
    plot(t,Davis_Summer_wall_temp_2,'k')
    
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('PCM temp','Ambient','Wall 2 (~1)')
    title('Temp: PCM vs walls vs ambient - Davis, Summer')
    hold off

figure(23)
    hold on
    grid on
    grid minor
    plot(t,PCM_temp_Davis_spr,'r')
    plot(t,Davis_spring_temp,'b')
    plot(t,Davis_Spring_wall_temp_2,'k')
    
    ylabel('Temp [C]')
    xlabel('Time - 24 hour')
    legend('PCM temp','Ambient','Wall 2 (~1)')
    title('Temp: PCM vs walls vs ambient - Davis, Spring')
    hold off
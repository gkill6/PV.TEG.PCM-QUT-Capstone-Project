%% ST2_2 PCM Heat Transer
% After further consideration, accurate protrayel of PCM relies on heat
% transfer between air & wall

% Chosen Beryllium Oxide ceramic for wall/container of PCM
% COnvection heat transfer between air to wall

% Wall to PCM depends on state: 
    % Solid - conduction 
    % Liquid - convection (thick/slow moving liquid - worth considering)?

% For accurate heat transfer to PCM, transfer between air and Wall must be
% accurate 
    % thus, convection is based on conditions (temp + wind speed) 

% Grashof & Prandtl (Temp & speed) > Rayleigh > nusselt > convection
% coefficient 
    % Determines amount of energy actually going in 

% ONLY FIRST HALF!! SECOND STEP IS CONDUCTING TO PCM 

% Casey Station, Summer - 6 hour window (9am - 3pm)[19-31]
% Casey Station, Spring - 3 hour window (10:30am-1:30pm)[22-28]

% Davis Station, Summer - 10 hour window (7am - 5pm)[15-35]
% Davis Station, Spring - 4 hour window (10am-2pm) [21-29]

%% Define temperatures and time periods
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

%% Finding convection coefficient 


% treat BeO ceramic wall as ideal conduction 
% outside temp = air 
% inside = pcm temp

% set wall surface temps (ts1,ts2)
Casey_Summer_wall_temp_1 = zeros(1,length(t));
Casey_Spring_wall_temp_1 = zeros(1,length(t));

Davis_Summer_wall_temp_1 = zeros(1,length(t));
Davis_Spring_wall_temp_1 = zeros(1,length(t));

for i = 1:48

    Casey_Summer_wall_temp_1(i) = Casey_summer_temp(i);
    Casey_Spring_wall_temp_1(i) = Casey_spring_temp(i);
    
    Davis_Summer_wall_temp_1(i) = Davis_summer_temp(i);
    Davis_Spring_wall_temp_1(i) = Davis_spring_temp(i);

end

Casey_Summer_wall_temp_2 = zeros(1,length(t));
Casey_Spring_wall_temp_2 = zeros(1,length(t));

Davis_Summer_wall_temp_2 = zeros(1,length(t));
Davis_Spring_wall_temp_2 = zeros(1,length(t));
    
for i = 1:48
    
    if i == 1
        Casey_Summer_wall_temp_2(i) = Casey_Summer_wall_temp_1(48);
        Casey_Spring_wall_temp_2(i) = Casey_Spring_wall_temp_1(48);

        Davis_Summer_wall_temp_2(i) = Davis_Summer_wall_temp_1(48);
        Davis_Spring_wall_temp_2(i) = Davis_Spring_wall_temp_1(48);
                
    else
        Casey_Summer_wall_temp_2(i) = Casey_Summer_wall_temp_1(i-1);
        Casey_Spring_wall_temp_2(i) = Casey_Spring_wall_temp_1(i-1);

        Davis_Summer_wall_temp_2(i) = Davis_Summer_wall_temp_1(i-1);
        Davis_Spring_wall_temp_2(i) = Davis_Spring_wall_temp_1(i-1);
    
    end

end 

% assume pure conduction across BeO wall (may need to talk to julian about
% complexity)


% Heat Transfer variables
Casey_Summer_q_cond = zeros(1,length(t));
Casey_Spring_q_cond = zeros(1,length(t));

Davis_Summer_q_cond = zeros(1,length(t));
Davis_Spring_q_cond = zeros(1,length(t));

k_BeO = 230; % W/m.K
L_BeO = 0.05; % 5cm wall? - could be adjustable

% q = (k * L) * (DT) [W]

for i = 1:48
 % pure conduction - W/m
    Casey_Summer_q_cond(i) = ...
    (k_BeO .* L_BeO) .* ( ( Casey_Summer_wall_temp_1(i) ...
    - Casey_Summer_wall_temp_2(i) ));...
    
    % ./ L_BeO ); ...
    % ./ 1000; % convert to kW/m^2;

    Casey_Spring_q_cond(i) = ...
    (k_BeO .* L_BeO) .* ( ( Casey_Spring_wall_temp_1(i) ...
    - Casey_Spring_wall_temp_2(i) ));...
    % ./ L_BeO ); ...
    % ./ 1000; % convert to kW/m^2;

    Davis_Summer_q_cond(i) = ...
    (k_BeO .* L_BeO) .* ( ( Davis_Summer_wall_temp_1(i) ...
    - Davis_Summer_wall_temp_2(i) ));...
    % ./ L_BeO ); ...
    % ./ 1000; % convert to kW/m^2;

    Davis_Spring_q_cond(i) = ...
    (k_BeO .* L_BeO) .* ( ( Davis_Spring_wall_temp_1(i) ...
    - Davis_Spring_wall_temp_2(i) ));...
    %./ L_BeO ); ...
    % ./ 1000; % convert to kW/m^2;

end

figure(2)
hold on 
grid on
grid minor
plot(t,Casey_Summer_wall_temp_1);
plot(t,Casey_Summer_wall_temp_2);

plot(t,Casey_Spring_wall_temp_1);
plot(t,Casey_Spring_wall_temp_2);

plot(t,Davis_Summer_wall_temp_1);
plot(t,Davis_Summer_wall_temp_2);

plot(t,Davis_Spring_wall_temp_1);
plot(t,Davis_Spring_wall_temp_2);

ylabel('Temperature [C]')
xlabel('Time - 24 hour')
legend('C_Sum_w1','C_Sum_w2','C_Spr_w1','C_Spr_w2',...
       'D_Sum_w1','D_Sum_w2','D_Spr_11','D_Spr_w2')
title('Beryllium Oxide Wall Temps - Casey Spring Case')
hold off

figure(3)
hold on 
grid on 
grid minor
plot(t,Casey_Summer_q_cond)
plot(t,Casey_Spring_q_cond)

plot(t,Davis_Summer_q_cond)
plot(t,Davis_Spring_q_cond)

ylabel('Heat Flux [W/m^2]')
xlabel('Time - 24 hour')
legend('Casey Summer','Casey Spring','Davis Summer','Davis Spring')
title('Heat Flux Across BeO Wall - Heat Absorbed/Emitted')

 hold off


% PCM energy = q_in * time 
PCM_int_e_Casey_summer = zeros(1,length(t));
PCM_int_e_Casey_spring = zeros(1,length(t));

PCM_int_e_Davis_summer = zeros(1,length(t));
PCM_int_e_Davis_spring = zeros(1,length(t));

% Assuming PCM absorbs all energy conducted across
% Assuming inside wall reaches next timestep of outside wall (within 30min)
for i = 1:48 
    if i == 1
        PCM_int_e_Casey_summer(i) = 0;
        PCM_int_e_Casey_spring(i) = 0;

        PCM_int_e_Davis_summer(i) = 0;
        PCM_int_e_Davis_spring(i) = 0;
    % add case for when losing energy?
    % nest inside else loop or keep as case
    
    else % maybe save for absorbing energy 
        % if
            PCM_int_e_Casey_summer(i) = ...
            (Casey_Summer_q_cond(i-1) * (1800)) ...
            + PCM_int_e_Casey_summer(i-1);
        %end

        %if
            PCM_int_e_Casey_spring(i) = ...
            (Casey_Spring_q_cond(i-1) * (1800)) ...
            + PCM_int_e_Casey_spring(i-1);
        %end

        %if
            PCM_int_e_Davis_summer(i) = ...
            (Davis_Summer_q_cond(i-1) * (1800)) ...
            + PCM_int_e_Davis_summer(i-1);
        %end

        %if
            PCM_int_e_Davis_spring(i) = ...
            (Davis_Spring_q_cond(i-1) * (1800)) ...
            + PCM_int_e_Davis_spring(i-1);
        %end
    end
end

figure(4)
hold on 
grid on 
grid minor
plot(t,PCM_int_e_Casey_summer)
plot(t,PCM_int_e_Casey_spring)
plot(t,PCM_int_e_Davis_summer)
plot(t,PCM_int_e_Davis_spring)
ylabel('Internal Energy [J]')
xlabel('Time - 24 hour')
legend('Casey Summer','Casey Spring','Davis Summer','Davis Spring')
title('PCM Internal Energy (based on q_in)')

hold off


%% PCM energy characterisation 
% given 30min blocks are very broad, hard to capture actual behaviour
% gives cause to use 3D cad for these smaller time periods (useful later,
% no need now)

% use conservation of energy = maintain heat flow into pcm?
% q_cond_1 = q_cond_2

k_PCM = 2.1; % W/m.K
L_PCM = 0.1; % 10cm deep

%let PCM temp = inner wall
Cp_Sol = 3200 ; % J/kg.K
Cp_Liq = 2100 ; % J/kg.K

H_fus = 290000 ; % J / kg - latent heat of fusion

% 

% need to convert internal energy values to per unit area
% assume - v = 0.1m^3; density = 1.02g/cm^3
% thus, mass approx 102kg
% Q = mcdeltaT -> Q/mc = Delta_T
spec_mass = 102; % kg in specified volume


% casey sumer temp range:
% night: 1-18 [t(18) = 8.5]
% Day: 19-31
% Night: 32-48
% given "night" is above phase change
PCM_Casey_sum_temp = zeros(1,length(t));

for i = 1:18
    PCM_Casey_sum_temp(i) = -6.9;
end

for i = 19:31
    PCM_Casey_sum_temp(i) = -6.9 + ...
    (PCM_int_e_Casey_summer(i)/(Cp_Liq*102)); 
end

for i = 32:48
    PCM_Casey_sum_temp(i) = -6.9;
end

% Casey Spring - 3 hour window (10:30am-1:30pm)[22-28]
    % Night: 1-21 [t(21) = 10am]
    % Day: 22-28
    % Night: 29-48

PCM_Casey_spr_temp = zeros(1,length(t));

for i = 1:21

    PCM_Casey_spr_temp(i) = -25.2;

end





% Davis summer temp range: 
    % Night: 1-14 [t(14) = 630am]
    % Day: 15-(25)-35
    % Night: 36-48    

% Davis Spring - 4 hour window (10am-2pm) [21-29]
    % Night: 1-20 [t(20) = 930am]
    % Day: 21-(25)-29
    % Night: 30-48

figure(5)
hold on 
grid on 
grid minor
plot(t,PCM_Casey_sum_temp)
% plot(t,PCM_int_e_Casey_spring)
% plot(t,PCM_int_e_Davis_summer)
% plot(t,PCM_int_e_Davis_spring)
ylabel('PCM Temp')
xlabel('Time - 24 hour')
legend('Casey Summer')
title('PCM Temp (based on q_in)')

hold off






%% Convection coefficient calculations - moot for now, could be useful later
% use for windy cases that affects rate of heat transfer
%% create struct variables for air properties??
% use struct to pull certain values for convection coefficient?

% air = struct('Temp',[-30, -20, -10, 0, 5, 10],...
%              'Prandtl',[0.7425 0.7408 0.7387 0.7362 0.7350 0.7336],...
%              'Kine_Visc',[(1.579*10^-5) (1.630*10^-5) (1.680*10^-5) (1.729*10^-5) (1.754*10^-5) (1.778*10^-5)],...
%              'Cond_Coeff',[(0.02134) (0.02211) (0.02288) (0.02364) (0.02401) (0.02439)]);

% 
% g = 9.81; 
% char_length = 0.25;
% coeff_BeO = 192.64; % heat capacity (J/K.m^2)

% Gr & Pr > Ra > Nu > h 
% Following equations assumes only natural convection i.e. no wind 

% Casey Station, Spring - 3 hour window (10:30am-1:30pm)[22-28]
% thus, consider in parts
% start with dawn > noon > arvo > night > morning (24 hour period)

% air_grash = zeros(1,length(t));
% air_ray = zeros(1,length(t));
% air_prand = zeros(1,length(t));
% air_Nu = zeros(1,length(t));
% 
% Temp_coeff = zeros(1,length(t));
% air_kin_visc = zeros(1,length(t));
% air_therm_cond = zeros(1,length(t));
% h_coeff = zeros(1,length(t));


% for i = 23:25 % to noon 
% % Prandtl choose from values - filter for values 
%     if (Casey_spring_temp(i) >= -30) && (Casey_spring_temp(i) < -20)
%         air_prand(i) = air.Prandtl(1) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(1) ).*...
%                        (air.Prandtl(2) - air.Prandtl(1) ) ./...
%                        ( air.Temp(2)- air.Temp(1) ) );
% 
%     elseif (Casey_spring_temp(i) >= -20) && (Casey_spring_temp(i) < -10)
%         air_prand(i) = air.Prandtl(2) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(2) ).*...
%                        (air.Prandtl(3) - air.Prandtl(2) ) ./...
%                        ( air.Temp(3)- air.Temp(2) ) );
% 
%     elseif (Casey_spring_temp(i) >= -10) && (Casey_spring_temp(i) < 0)
%         air_prand(i) = air.Prandtl(3) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(3) ).*...
%                        (air.Prandtl(4) - air.Prandtl(3) ) ./...
%                        ( air.Temp(4)- air.Temp(3) ) );
% 
%     elseif (Casey_spring_temp(i) >= 0) && (Casey_spring_temp(i) < 5)
%         air_prand(i) = air.Prandtl(4) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(4) ).*...
%                        (air.Prandtl(5) - air.Prandtl(4) ) ./...
%                        ( air.Temp(5)- air.Temp(4) ) );
% 
%     elseif (Casey_spring_temp(i) >= 5) && (Casey_spring_temp(i) <= 10)
%         air_prand(i) = air.Prandtl(5) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(5) ).*...
%                        (air.Prandtl(6) - air.Prandtl(5) ) ./...
%                        ( air.Temp(6)- air.Temp(5) ) );
%     else 
%         air_prand(i) = air.Prandtl(6);
% 
%     end 
% 
% % Kinematic viscosity 
%     if (Casey_spring_temp(i) >= -30) && (Casey_spring_temp(i) < -20)
%         air_kin_visc(i) = air.Kine_Visc(1) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(1) ).*...
%                        (air.Kine_Visc(2) - air.Kine_Visc(1) ) ./...
%                        ( air.Temp(2)- air.Temp(1) ) );
% 
%     elseif (Casey_spring_temp(i) >= -20) && (Casey_spring_temp(i) < -10)
%         air_kin_visc(i) = air.Kine_Visc(2) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(2) ).*...
%                        (air.Kine_Visc(3) - air.Kine_Visc(2) ) ./...
%                        ( air.Temp(3)- air.Temp(2) ) );
% 
%     elseif (Casey_spring_temp(i) >= -10) && (Casey_spring_temp(i) < 0)
%         air_kin_visc(i) = air.Kine_Visc(3) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(3) ).*...
%                        (air.Kine_Visc(4) - air.Kine_Visc(3) ) ./...
%                        ( air.Temp(4)- air.Temp(3) ) );
% 
%     elseif (Casey_spring_temp(i) >= 0) && (Casey_spring_temp(i) < 5)
%         air_kin_visc(i) = air.Kine_Visc(4) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(4) ).*...
%                        (air.Kine_Visc(5) - air.Kine_Visc(4) ) ./...
%                        ( air.Temp(5)- air.Temp(4) ) );
% 
%     elseif (Casey_spring_temp(i) >= 5) && (Casey_spring_temp(i) <= 10)
%         air_kin_visc(i) = air.Kine_Visc(5) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(5) ).*...
%                        (air.Kine_Visc(6) - air.Kine_Visc(5) ) ./...
%                        ( air.Temp(6)- air.Temp(5) ) );
%     else 
%         air_kin_visc(i) = air.Kine_Visc(6);
%     end 
% 
% % Grashof 
% Temp_coeff(i) = 1/ (Casey_spring_temp(i)+273.15);
% 
% air_grash(i) = (g) .* (Temp_coeff(i)) .* ((Casey_spring_temp(i)- wall_temp_1(i-1)  ) .* char_length.^3) ./ ...
%                ( air_kin_visc(i) .^ 2)  ; 
% 
% % Rayleigh #
% 
% air_ray(i) = air_grash(i) .* air_prand(i); 
% 
% % Nusselt # 
%     if (air_ray(i) >= 10^4) && (air_ray(i) < 10^7)
%         air_Nu(i) = abs(0.54 .* ( air_ray(i) .^(1/4) ));
%     else 
%         air_Nu(i) = abs(0.15 .* ( air_ray(i) .^(1/3) )); 
%     end 
% 
% % Thermal Conductivity
%     if (Casey_spring_temp(i) >= -30) && (Casey_spring_temp(i) < -20)
%         air_therm_cond(i) = air.Cond_Coeff(1) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(1) ).*...
%                        (air.Cond_Coeff(2) - air.Cond_Coeff(1) ) ./...
%                        ( air.Temp(2)- air.Temp(1) ) );
% 
%     elseif (Casey_spring_temp(i) >= -20) && (Casey_spring_temp(i) < -10)
%         air_therm_cond(i) = air.Cond_Coeff(2) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(2) ).*...
%                        (air.Cond_Coeff(3) - air.Cond_Coeff(2) ) ./...
%                        ( air.Temp(3)- air.Temp(2) ) );
% 
%     elseif (Casey_spring_temp(i) >= -10) && (Casey_spring_temp(i) < 0)
%         air_therm_cond(i) = air.Cond_Coeff(3) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(3) ).*...
%                        (air.Cond_Coeff(4) - air.Cond_Coeff(3) ) ./...
%                        ( air.Temp(4)- air.Temp(3) ) );
% 
%     elseif (Casey_spring_temp(i) >= 0) && (Casey_spring_temp(i) < 5)
%         air_therm_cond(i) = air.Cond_Coeff(4) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(4) ).*...
%                        (air.Cond_Coeff(5) - air.Cond_Coeff(4) ) ./...
%                        ( air.Temp(5)- air.Temp(4) ) );
% 
%     elseif (Casey_spring_temp(i) >= 5) && (Casey_spring_temp(i) <= 10)
%         air_therm_cond(i) = air.Cond_Coeff(5) + ...
%                        ( ( Casey_spring_temp(i) - air.Temp(5) ).*...
%                        (air.Cond_Coeff(6) - air.Cond_Coeff(5) ) ./...
%                        ( air.Temp(6)- air.Temp(5) ) );
%     else 
%         air_therm_cond(i) = air.Cond_Coeff(6);
%     end 
% 
% % Convection ceofficient 
% h_coeff(i) = (air_Nu(i) .* air_therm_cond(i) ) ./ (char_length) ; 
% 
% % rate of heat transfer - convection
% q_cond(i) = h_coeff(i) .* (Casey_spring_temp(i) - wall_temp_1(i-1) ); 
% 
% % establish new wall temp - assume next step of ambient? (BeO is conductive
% % 
% wall_temp_1(i) = Casey_spring_temp(i-1); % by end of timestep, wall = ambient
% 
% % rate of heat transfer - conduction 
% % use to find inner surface temperature 
% 
% % wall_temp_2(i) = ((L_BeO / ( -1 .* k_BeO) ) .* ( q_conv_surf(i) )) ...
% %                     + wall_temp_1(i-1);
% 
% % PCM - use rate of conduction to find PCM temp 
% % PCM temperature
% 
% % temp_PCM(i) =  ((L_PCM / ( -1 .* k_PCM) ) .* ( q_conv_surf(i) )) ...
%                     + wall_temp_2(i-1);
% 
% % rate of heat conduction 
% % q = T(1 - 2)/ therm_resistance
% 
% 
% end

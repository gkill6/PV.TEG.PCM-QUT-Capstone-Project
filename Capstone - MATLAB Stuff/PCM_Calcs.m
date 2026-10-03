%% PCM Calculation stuff
% Use latent heat equation type
% Store into cells
% Use for loops for iterative calculations

Casey_day = [-2.4,-2.5,-2.5,-0.8,-3.8,-4.2,...
                0.3,3.7,5.5,6.7,4.7,4.3];

Casey_night = [-25.6,-30,-25.2,-32.4,-26.8,-25.2,...
                -21.5,-17.4,-6.9,-4.6,-9.9,-21.9];

Davis_day = [-3.8,-5.9,-3,-6.8,-4.5,-2.2,...
                2.1,5.6,8.2,8.5,2.7,1];

Davis_night = [-27.5,-28.9,-32.2,-33.7,-29.2,-26.2,...
                -18.7,-9.6,-3.6,-3.6,-9.4,-17.8];

Casey_day_K = Casey_day + 273.15; % convert to Kelvin
Casey_night_K = Casey_night + 273.15;

Davis_day_K = Davis_day + 273.15;
Davis_night_K = Davis_night + 273.15;

%% Use latent energy equation 

% Q_latent = [(T_pc*C_p_S)-(T_1*C_p_s)] + (H) + [(T_2*C_p_l)-(T_Pc*C_p_l)]
% CP & H values dependent on PCM 
% Assume isentropic processes - approximate relationship


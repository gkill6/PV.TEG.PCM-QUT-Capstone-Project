%% ST 5.2 - Data manipulation 
% Compare effieincy values 
% "for nominated panels, this is behaviour, this is behaviour with teg/tes

clc;
clear all;
%%
t = 0:0.5:23.5;

% Read PV/TEG/PCM  Data 
PV_TEG_PCM_P_GEN = readtable("PV_TEG_PCM_01_20_P_1_Panel.xlsx");
PV_TEG_PCM_P_GEN = table2array(PV_TEG_PCM_P_GEN);


% Read PV data 

PV_ISO_P_GEN = readtable("PV_solar_power_gen_iso.xlsx");
PV_ISO_P_GEN = table2array(PV_ISO_P_GEN);

% read PV DATA

% Casey/Sum
    Casey_Sum_PV_0  = PV_ISO_P_GEN(1,:);
    Casey_Sum_PV_20 = PV_ISO_P_GEN(2,:);
    Casey_Sum_PV_40 = PV_ISO_P_GEN(3,:);
    Casey_Sum_PV_60 = PV_ISO_P_GEN(4,:);
    Casey_Sum_PV_80 = PV_ISO_P_GEN(5,:);
% Casey/Spr
    Casey_Spr_PV_0  = PV_ISO_P_GEN(6,:);
    Casey_Spr_PV_20 = PV_ISO_P_GEN(7,:);
    Casey_Spr_PV_40 = PV_ISO_P_GEN(8,:);
    Casey_Spr_PV_60 = PV_ISO_P_GEN(9,:);
    Casey_Spr_PV_80 = PV_ISO_P_GEN(10,:);
% Davis/Sum
    Davis_Sum_PV_0  = PV_ISO_P_GEN(11,:);
    Davis_Sum_PV_20 = PV_ISO_P_GEN(12,:);
    Davis_Sum_PV_40 = PV_ISO_P_GEN(13,:);
    Davis_Sum_PV_60 = PV_ISO_P_GEN(14,:);
    Davis_Sum_PV_80 = PV_ISO_P_GEN(15,:);
% Davis/Spr
    Davis_Spr_PV_0  = PV_ISO_P_GEN(16,:);
    Davis_Spr_PV_20 = PV_ISO_P_GEN(17,:);
    Davis_Spr_PV_40 = PV_ISO_P_GEN(18,:);
    Davis_Spr_PV_60 = PV_ISO_P_GEN(19,:);
    Davis_Spr_PV_80 = PV_ISO_P_GEN(20,:);

%---------------------------------------------------------------------------%
% Segment into data ()
% [CASEY/SUM]
% 01:04 - 0% Clouds (5,10,25,50)
    Casey_Sum_TEG_01 = PV_TEG_PCM_P_GEN(1,:); % 5km/hr
    Casey_Sum_TEG_02 = PV_TEG_PCM_P_GEN(5,:); % 10km/hr
    Casey_Sum_TEG_03 = PV_TEG_PCM_P_GEN(9,:); % 25km/hr
    Casey_Sum_TEG_04 = PV_TEG_PCM_P_GEN(13,:); % 50km/hr
% 05:08 - 20% Clouds (5,10,25,50)
    Casey_Sum_TEG_05 = PV_TEG_PCM_P_GEN(17,:); % 5km/hr
    Casey_Sum_TEG_06 = PV_TEG_PCM_P_GEN(21,:); % 10km/hr
    Casey_Sum_TEG_07 = PV_TEG_PCM_P_GEN(25,:); % 25km/hr
    Casey_Sum_TEG_08 = PV_TEG_PCM_P_GEN(29,:); % 50km/hr
% 09:12 - 40% Clouds (5,10,25,50)
    Casey_Sum_TEG_09 = PV_TEG_PCM_P_GEN(33,:); % 5km/hr
    Casey_Sum_TEG_10 = PV_TEG_PCM_P_GEN(37,:); % 10km/hr
    Casey_Sum_TEG_11 = PV_TEG_PCM_P_GEN(41,:); % 25km/hr
    Casey_Sum_TEG_12 = PV_TEG_PCM_P_GEN(45,:); % 50km/hr
% 13:16 - 60% Clouds (5,10,25,50)
    Casey_Sum_TEG_13 = PV_TEG_PCM_P_GEN(49,:); % 5km/hr
    Casey_Sum_TEG_14 = PV_TEG_PCM_P_GEN(53,:); % 10km/hr
    Casey_Sum_TEG_15 = PV_TEG_PCM_P_GEN(57,:); % 25km/hr
    Casey_Sum_TEG_16 = PV_TEG_PCM_P_GEN(61,:); % 50km/hr
% 17:20 - 80% Clouds (5,10,25,50)
    Casey_Sum_TEG_17 = PV_TEG_PCM_P_GEN(65,:); % 5km/hr
    Casey_Sum_TEG_18 = PV_TEG_PCM_P_GEN(69,:); % 10km/hr
    Casey_Sum_TEG_19 = PV_TEG_PCM_P_GEN(73,:); % 25km/hr
    Casey_Sum_TEG_20 = PV_TEG_PCM_P_GEN(77,:); % 50km/hr
%-------------------------------------------------------------------------------------------%
% [CASEY/SPR]
% 01:04 - 0% Clouds (5,10,25,50)
    Casey_Spr_TEG_01 = PV_TEG_PCM_P_GEN(2,:); % 5km/hr
    Casey_Spr_TEG_02 = PV_TEG_PCM_P_GEN(6,:); % 10km/hr
    Casey_Spr_TEG_03 = PV_TEG_PCM_P_GEN(10,:); % 25km/hr
    Casey_Spr_TEG_04 = PV_TEG_PCM_P_GEN(14,:); % 50km/hr
% 05:08 - 20% Clouds (5,10,25,50)
    Casey_Spr_TEG_05 = PV_TEG_PCM_P_GEN(18,:); % 5km/hr
    Casey_Spr_TEG_06 = PV_TEG_PCM_P_GEN(22,:); % 10km/hr
    Casey_Spr_TEG_07 = PV_TEG_PCM_P_GEN(26,:); % 25km/hr
    Casey_Spr_TEG_08 = PV_TEG_PCM_P_GEN(30,:); % 50km/hr
% 09:12 - 40% Clouds (5,10,25,50)
    Casey_Spr_TEG_09 = PV_TEG_PCM_P_GEN(34,:); % 5km/hr
    Casey_Spr_TEG_10 = PV_TEG_PCM_P_GEN(38,:); % 10km/hr
    Casey_Spr_TEG_11 = PV_TEG_PCM_P_GEN(42,:); % 25km/hr
    Casey_Spr_TEG_12 = PV_TEG_PCM_P_GEN(46,:); % 50km/hr
% 13:16 - 60% Clouds (5,10,25,50)
    Casey_Spr_TEG_13 = PV_TEG_PCM_P_GEN(50,:); % 5km/hr
    Casey_Spr_TEG_14 = PV_TEG_PCM_P_GEN(54,:); % 10km/hr
    Casey_Spr_TEG_15 = PV_TEG_PCM_P_GEN(58,:); % 25km/hr
    Casey_Spr_TEG_16 = PV_TEG_PCM_P_GEN(62,:); % 50km/hr
% 17:20 - 80% Clouds (5,10,25,50)
    Casey_Spr_TEG_17 = PV_TEG_PCM_P_GEN(66,:); % 5km/hr
    Casey_Spr_TEG_18 = PV_TEG_PCM_P_GEN(70,:); % 10km/hr
    Casey_Spr_TEG_19 = PV_TEG_PCM_P_GEN(74,:); % 25km/hr
    Casey_Spr_TEG_20 = PV_TEG_PCM_P_GEN(78,:); % 50km/hr
%------------------------------------------------------------------------------
% [Davis/Sum]
% 01:04 - 0% Clouds (5,10,25,50)
    Davis_Sum_TEG_01 = PV_TEG_PCM_P_GEN(3,:); % 5km/hr
    Davis_Sum_TEG_02 = PV_TEG_PCM_P_GEN(7,:); % 10km/hr
    Davis_Sum_TEG_03 = PV_TEG_PCM_P_GEN(11,:); % 25km/hr
    Davis_Sum_TEG_04 = PV_TEG_PCM_P_GEN(15,:); % 50km/hr
% 05:08 - 20% Clouds (5,10,25,50)
    Davis_Sum_TEG_05 = PV_TEG_PCM_P_GEN(19,:); % 5km/hr
    Davis_Sum_TEG_06 = PV_TEG_PCM_P_GEN(23,:); % 10km/hr
    Davis_Sum_TEG_07 = PV_TEG_PCM_P_GEN(27,:); % 25km/hr
    Davis_Sum_TEG_08 = PV_TEG_PCM_P_GEN(31,:); % 50km/hr
% 09:12 - 40% Clouds (5,10,25,50)
    Davis_Sum_TEG_09 = PV_TEG_PCM_P_GEN(35,:); % 5km/hr
    Davis_Sum_TEG_10 = PV_TEG_PCM_P_GEN(39,:); % 10km/hr
    Davis_Sum_TEG_11 = PV_TEG_PCM_P_GEN(43,:); % 25km/hr
    Davis_Sum_TEG_12 = PV_TEG_PCM_P_GEN(47,:); % 50km/hr
% 13:16 - 60% Clouds (5,10,25,50)
    Davis_Sum_TEG_13 = PV_TEG_PCM_P_GEN(51,:); % 5km/hr
    Davis_Sum_TEG_14 = PV_TEG_PCM_P_GEN(55,:); % 10km/hr
    Davis_Sum_TEG_15 = PV_TEG_PCM_P_GEN(59,:); % 25km/hr
    Davis_Sum_TEG_16 = PV_TEG_PCM_P_GEN(63,:); % 50km/hr
% 17:20 - 80% Clouds (5,10,25,50)
    Davis_Sum_TEG_17 = PV_TEG_PCM_P_GEN(67,:); % 5km/hr
    Davis_Sum_TEG_18 = PV_TEG_PCM_P_GEN(71,:); % 10km/hr
    Davis_Sum_TEG_19 = PV_TEG_PCM_P_GEN(75,:); % 25km/hr
    Davis_Sum_TEG_20 = PV_TEG_PCM_P_GEN(79,:); % 50km/hr
%-------------------------------------------------------------------------------------------%
% [Davis/spr]
% 01:04 - 0% Clouds (5,10,25,50)
    Davis_Spr_TEG_01 = PV_TEG_PCM_P_GEN(4,:); % 5km/hr
    Davis_Spr_TEG_02 = PV_TEG_PCM_P_GEN(8,:); % 10km/hr
    Davis_Spr_TEG_03 = PV_TEG_PCM_P_GEN(12,:); % 25km/hr
    Davis_Spr_TEG_04 = PV_TEG_PCM_P_GEN(16,:); % 50km/hr
% 05:08 - 20% Clouds (5,10,25,50)
    Davis_Spr_TEG_05 = PV_TEG_PCM_P_GEN(20,:); % 5km/hr
    Davis_Spr_TEG_06 = PV_TEG_PCM_P_GEN(24,:); % 10km/hr
    Davis_Spr_TEG_07 = PV_TEG_PCM_P_GEN(28,:); % 25km/hr
    Davis_Spr_TEG_08 = PV_TEG_PCM_P_GEN(32,:); % 50km/hr
% 09:12 - 40% Clouds (5,10,25,50)
    Davis_Spr_TEG_09 = PV_TEG_PCM_P_GEN(36,:); % 5km/hr
    Davis_Spr_TEG_10 = PV_TEG_PCM_P_GEN(40,:); % 10km/hr
    Davis_Spr_TEG_11 = PV_TEG_PCM_P_GEN(44,:); % 25km/hr
    Davis_Spr_TEG_12 = PV_TEG_PCM_P_GEN(48,:); % 50km/hr
% 13:16 - 60% Clouds (5,10,25,50)
    Davis_Spr_TEG_13 = PV_TEG_PCM_P_GEN(52,:); % 5km/hr
    Davis_Spr_TEG_14 = PV_TEG_PCM_P_GEN(56,:); % 10km/hr
    Davis_Spr_TEG_15 = PV_TEG_PCM_P_GEN(60,:); % 25km/hr
    Davis_Spr_TEG_16 = PV_TEG_PCM_P_GEN(64,:); % 50km/hr
% 17:20 - 80% Clouds (5,10,25,50)
    Davis_Spr_TEG_17 = PV_TEG_PCM_P_GEN(68,:); % 5km/hr
    Davis_Spr_TEG_18 = PV_TEG_PCM_P_GEN(72,:); % 10km/hr
    Davis_Spr_TEG_19 = PV_TEG_PCM_P_GEN(76,:); % 25km/hr
    Davis_Spr_TEG_20 = PV_TEG_PCM_P_GEN(80,:); % 50km/hr
%-------------------------------------------------------------------------------------------%




%% Arithmetic 
% Make PV/TEG/PCM values = PV + TEG 
% Casey/SUM
% [0% Clouds - 01:04]
    Casey_Sum_PV_TEG_PCM_P_01 = Casey_Sum_PV_0 + Casey_Sum_TEG_01;
    Casey_Sum_PV_TEG_PCM_P_02 = Casey_Sum_PV_0 + Casey_Sum_TEG_02;
    Casey_Sum_PV_TEG_PCM_P_03 = Casey_Sum_PV_0 + Casey_Sum_TEG_03;
    Casey_Sum_PV_TEG_PCM_P_04 = Casey_Sum_PV_0 + Casey_Sum_TEG_04;
% [20% Clouds - 05:08]
    Casey_Sum_PV_TEG_PCM_P_05 = Casey_Sum_PV_20 + Casey_Sum_TEG_05;
    Casey_Sum_PV_TEG_PCM_P_06 = Casey_Sum_PV_20 + Casey_Sum_TEG_06;
    Casey_Sum_PV_TEG_PCM_P_07 = Casey_Sum_PV_20 + Casey_Sum_TEG_07;
    Casey_Sum_PV_TEG_PCM_P_08 = Casey_Sum_PV_20 + Casey_Sum_TEG_08;
% [40% Clouds -]
    Casey_Sum_PV_TEG_PCM_P_09 = Casey_Sum_PV_40 + Casey_Sum_TEG_09;
    Casey_Sum_PV_TEG_PCM_P_10 = Casey_Sum_PV_40 + Casey_Sum_TEG_10;
    Casey_Sum_PV_TEG_PCM_P_11 = Casey_Sum_PV_40 + Casey_Sum_TEG_11;
    Casey_Sum_PV_TEG_PCM_P_12 = Casey_Sum_PV_40 + Casey_Sum_TEG_12;
% [60% Clouds -]
    Casey_Sum_PV_TEG_PCM_P_13 = Casey_Sum_PV_60 + Casey_Sum_TEG_13;
    Casey_Sum_PV_TEG_PCM_P_14 = Casey_Sum_PV_60 + Casey_Sum_TEG_14;
    Casey_Sum_PV_TEG_PCM_P_15 = Casey_Sum_PV_60 + Casey_Sum_TEG_15;
    Casey_Sum_PV_TEG_PCM_P_16 = Casey_Sum_PV_60 + Casey_Sum_TEG_16;
% [80% Clouds -]
    Casey_Sum_PV_TEG_PCM_P_17 = Casey_Sum_PV_80 + Casey_Sum_TEG_17;
    Casey_Sum_PV_TEG_PCM_P_18 = Casey_Sum_PV_80 + Casey_Sum_TEG_18;
    Casey_Sum_PV_TEG_PCM_P_19 = Casey_Sum_PV_80 + Casey_Sum_TEG_19;
    Casey_Sum_PV_TEG_PCM_P_20 = Casey_Sum_PV_80 + Casey_Sum_TEG_20;

    
% Casey/SPR
% [0% Clouds - 01:04]
    Casey_Spr_PV_TEG_PCM_P_01 = Casey_Spr_PV_0 + Casey_Spr_TEG_01;
    Casey_Spr_PV_TEG_PCM_P_02 = Casey_Spr_PV_0 + Casey_Spr_TEG_02;
    Casey_Spr_PV_TEG_PCM_P_03 = Casey_Spr_PV_0 + Casey_Spr_TEG_03;
    Casey_Spr_PV_TEG_PCM_P_04 = Casey_Spr_PV_0 + Casey_Spr_TEG_04;
% [20% Clouds - 05:08]
    Casey_Spr_PV_TEG_PCM_P_05 = Casey_Spr_PV_20 + Casey_Spr_TEG_05;
    Casey_Spr_PV_TEG_PCM_P_06 = Casey_Spr_PV_20 + Casey_Spr_TEG_06;
    Casey_Spr_PV_TEG_PCM_P_07 = Casey_Spr_PV_20 + Casey_Spr_TEG_07;
    Casey_Spr_PV_TEG_PCM_P_08 = Casey_Spr_PV_20 + Casey_Spr_TEG_08;
% [40% Clouds -]
    Casey_Spr_PV_TEG_PCM_P_09 = Casey_Spr_PV_40 + Casey_Spr_TEG_09;
    Casey_Spr_PV_TEG_PCM_P_10 = Casey_Spr_PV_40 + Casey_Spr_TEG_10;
    Casey_Spr_PV_TEG_PCM_P_11 = Casey_Spr_PV_40 + Casey_Spr_TEG_11;
    Casey_Spr_PV_TEG_PCM_P_12 = Casey_Spr_PV_40 + Casey_Spr_TEG_12;
% [60% Clouds -]
    Casey_Spr_PV_TEG_PCM_P_13 = Casey_Spr_PV_60 + Casey_Spr_TEG_13;
    Casey_Spr_PV_TEG_PCM_P_14 = Casey_Spr_PV_60 + Casey_Spr_TEG_14;
    Casey_Spr_PV_TEG_PCM_P_15 = Casey_Spr_PV_60 + Casey_Spr_TEG_15;
    Casey_Spr_PV_TEG_PCM_P_16 = Casey_Spr_PV_60 + Casey_Spr_TEG_16;
% [80% Clouds -]
    Casey_Spr_PV_TEG_PCM_P_17 = Casey_Spr_PV_80 + Casey_Spr_TEG_17;
    Casey_Spr_PV_TEG_PCM_P_18 = Casey_Spr_PV_80 + Casey_Spr_TEG_18;
    Casey_Spr_PV_TEG_PCM_P_19 = Casey_Spr_PV_80 + Casey_Spr_TEG_19;
    Casey_Spr_PV_TEG_PCM_P_20 = Casey_Spr_PV_80 + Casey_Spr_TEG_20;


% Davis/Spr
% [0% Clouds - 01:04]
    Davis_Sum_PV_TEG_PCM_P_01 = Davis_Sum_PV_0 + Davis_Sum_TEG_01;
    Davis_Sum_PV_TEG_PCM_P_02 = Davis_Sum_PV_0 + Davis_Sum_TEG_02;
    Davis_Sum_PV_TEG_PCM_P_03 = Davis_Sum_PV_0 + Davis_Sum_TEG_03;
    Davis_Sum_PV_TEG_PCM_P_04 = Davis_Sum_PV_0 + Davis_Sum_TEG_04;
% [20% Clouds - 05:08]
    Davis_Sum_PV_TEG_PCM_P_05 = Davis_Sum_PV_20 + Davis_Sum_TEG_05;
    Davis_Sum_PV_TEG_PCM_P_06 = Davis_Sum_PV_20 + Davis_Sum_TEG_06;
    Davis_Sum_PV_TEG_PCM_P_07 = Davis_Sum_PV_20 + Davis_Sum_TEG_07;
    Davis_Sum_PV_TEG_PCM_P_08 = Davis_Sum_PV_20 + Davis_Sum_TEG_08;
% [40% Clouds -]
    Davis_Sum_PV_TEG_PCM_P_09 = Davis_Sum_PV_40 + Davis_Sum_TEG_09;
    Davis_Sum_PV_TEG_PCM_P_10 = Davis_Sum_PV_40 + Davis_Sum_TEG_10;
    Davis_Sum_PV_TEG_PCM_P_11 = Davis_Sum_PV_40 + Davis_Sum_TEG_11;
    Davis_Sum_PV_TEG_PCM_P_12 = Davis_Sum_PV_40 + Davis_Sum_TEG_12;
% [60% Clouds -]
    Davis_Sum_PV_TEG_PCM_P_13 = Davis_Sum_PV_60 + Davis_Sum_TEG_13;
    Davis_Sum_PV_TEG_PCM_P_14 = Davis_Sum_PV_60 + Davis_Sum_TEG_14;
    Davis_Sum_PV_TEG_PCM_P_15 = Davis_Sum_PV_60 + Davis_Sum_TEG_15;
    Davis_Sum_PV_TEG_PCM_P_16 = Davis_Sum_PV_60 + Davis_Sum_TEG_16;
% [80% Clouds -]
    Davis_Sum_PV_TEG_PCM_P_17 = Davis_Sum_PV_80 + Davis_Sum_TEG_17;
    Davis_Sum_PV_TEG_PCM_P_18 = Davis_Sum_PV_80 + Davis_Sum_TEG_18;
    Davis_Sum_PV_TEG_PCM_P_19 = Davis_Sum_PV_80 + Davis_Sum_TEG_19;
    Davis_Sum_PV_TEG_PCM_P_20 = Davis_Sum_PV_80 + Davis_Sum_TEG_20;

% Davis/SPR
% [0% Clouds - 01:04]
    Davis_Spr_PV_TEG_PCM_P_01 = Davis_Spr_PV_0 + Davis_Spr_TEG_01;
    Davis_Spr_PV_TEG_PCM_P_02 = Davis_Spr_PV_0 + Davis_Spr_TEG_02;
    Davis_Spr_PV_TEG_PCM_P_03 = Davis_Spr_PV_0 + Davis_Spr_TEG_03;
    Davis_Spr_PV_TEG_PCM_P_04 = Davis_Spr_PV_0 + Davis_Spr_TEG_04;
% [20% Clouds - 05:08]
    Davis_Spr_PV_TEG_PCM_P_05 = Davis_Spr_PV_20 + Davis_Spr_TEG_05;
    Davis_Spr_PV_TEG_PCM_P_06 = Davis_Spr_PV_20 + Davis_Spr_TEG_06;
    Davis_Spr_PV_TEG_PCM_P_07 = Davis_Spr_PV_20 + Davis_Spr_TEG_07;
    Davis_Spr_PV_TEG_PCM_P_08 = Davis_Spr_PV_20 + Davis_Spr_TEG_08;
% [40% Clouds -]
    Davis_Spr_PV_TEG_PCM_P_09 = Davis_Spr_PV_40 + Davis_Spr_TEG_09;
    Davis_Spr_PV_TEG_PCM_P_10 = Davis_Spr_PV_40 + Davis_Spr_TEG_10;
    Davis_Spr_PV_TEG_PCM_P_11 = Davis_Spr_PV_40 + Davis_Spr_TEG_11;
    Davis_Spr_PV_TEG_PCM_P_12 = Davis_Spr_PV_40 + Davis_Spr_TEG_12;
% [60% Clouds -]
    Davis_Spr_PV_TEG_PCM_P_13 = Davis_Spr_PV_60 + Davis_Spr_TEG_13;
    Davis_Spr_PV_TEG_PCM_P_14 = Davis_Spr_PV_60 + Davis_Spr_TEG_14;
    Davis_Spr_PV_TEG_PCM_P_15 = Davis_Spr_PV_60 + Davis_Spr_TEG_15;
    Davis_Spr_PV_TEG_PCM_P_16 = Davis_Spr_PV_60 + Davis_Spr_TEG_16;
% [80% Clouds -]
    Davis_Spr_PV_TEG_PCM_P_17 = Davis_Spr_PV_80 + Davis_Spr_TEG_17;
    Davis_Spr_PV_TEG_PCM_P_18 = Davis_Spr_PV_80 + Davis_Spr_TEG_18;
    Davis_Spr_PV_TEG_PCM_P_19 = Davis_Spr_PV_80 + Davis_Spr_TEG_19;
    Davis_Spr_PV_TEG_PCM_P_20 = Davis_Spr_PV_80 + Davis_Spr_TEG_20;
%% Graphs 
% CASEY – SUMMER – 0% CLOUDS (01:04)
figure(1)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Casey_Sum_PV_0)
    plot(t,Casey_Sum_PV_TEG_PCM_P_01)
    plot(t,Casey_Sum_PV_TEG_PCM_P_02)
    plot(t,Casey_Sum_PV_TEG_PCM_P_03)
    plot(t,Casey_Sum_PV_TEG_PCM_P_04)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 01','Full PV/TEG/PCM - 02',...
        'Full PV/TEG/PCM - 03','Full PV/TEG/PCM - 04')
    title('Casey/Summer - 1 Solar Panel eq. - Case 01')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Casey_Sum_TEG_01)
    plot(t,Casey_Sum_TEG_02)
    plot(t,Casey_Sum_TEG_03)
    plot(t,Casey_Sum_TEG_04)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 01','Case 02','Case 03','Case 04')
    title('Casey/Summer - TEG Power Contribution - Cases 01:04 (0% Clouds)')
    hold off

% CASEY – SUMMER – 20% CLOUDS (05:08)
figure(2)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Casey_Sum_PV_20)
    plot(t,Casey_Sum_PV_TEG_PCM_P_05)
    plot(t,Casey_Sum_PV_TEG_PCM_P_06)
    plot(t,Casey_Sum_PV_TEG_PCM_P_07)
    plot(t,Casey_Sum_PV_TEG_PCM_P_08)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 05','Full PV/TEG/PCM - 06',...
        'Full PV/TEG/PCM - 07','Full PV/TEG/PCM - 08')
    title('Casey/Summer - 1 Solar Panel eq. - 20% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Casey_Sum_TEG_05)
    plot(t,Casey_Sum_TEG_06)
    plot(t,Casey_Sum_TEG_07)
    plot(t,Casey_Sum_TEG_08)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 05','Case 06','Case 07','Case 08')
    title('Casey/Summer - TEG Power Contribution - Cases 05:08 (20% Clouds)')
    hold off

% CASEY – SUMMER – 40% CLOUDS (09:12)
figure(3)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Casey_Sum_PV_40)
    plot(t,Casey_Sum_PV_TEG_PCM_P_09)
    plot(t,Casey_Sum_PV_TEG_PCM_P_10)
    plot(t,Casey_Sum_PV_TEG_PCM_P_11)
    plot(t,Casey_Sum_PV_TEG_PCM_P_12)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 09','Full PV/TEG/PCM - 10',...
        'Full PV/TEG/PCM - 11','Full PV/TEG/PCM - 12')
    title('Casey/Summer - 1 Solar Panel eq. - 40% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Casey_Sum_TEG_09)
    plot(t,Casey_Sum_TEG_10)
    plot(t,Casey_Sum_TEG_11)
    plot(t,Casey_Sum_TEG_12)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 09','Case 10','Case 11','Case 12')
    title('Casey/Summer - TEG Power Contribution - Cases 09:12 (40% Clouds)')
    hold off

% CASEY – SUMMER – 60% CLOUDS (13:16)
figure(4)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Casey_Sum_PV_60)
    plot(t,Casey_Sum_PV_TEG_PCM_P_13)
    plot(t,Casey_Sum_PV_TEG_PCM_P_14)
    plot(t,Casey_Sum_PV_TEG_PCM_P_15)
    plot(t,Casey_Sum_PV_TEG_PCM_P_16)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 13','Full PV/TEG/PCM - 14',...
        'Full PV/TEG/PCM - 15','Full PV/TEG/PCM - 16')
    title('Casey/Summer - 1 Solar Panel eq. - 60% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Casey_Sum_TEG_13)
    plot(t,Casey_Sum_TEG_14)
    plot(t,Casey_Sum_TEG_15)
    plot(t,Casey_Sum_TEG_16)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 13','Case 14','Case 15','Case 16')
    title('Casey/Summer - TEG Power Contribution - Cases 13:16 (60% Clouds)')
    hold off

% CASEY – SUMMER – 80% CLOUDS (13:16)
figure(5)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Casey_Sum_PV_80)
    plot(t,Casey_Sum_PV_TEG_PCM_P_17)
    plot(t,Casey_Sum_PV_TEG_PCM_P_18)
    plot(t,Casey_Sum_PV_TEG_PCM_P_19)
    plot(t,Casey_Sum_PV_TEG_PCM_P_20)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 17','Full PV/TEG/PCM - 18',...
        'Full PV/TEG/PCM - 19','Full PV/TEG/PCM - 20')
    title('Casey/Summer - 1 Solar Panel eq. - 80% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Casey_Sum_TEG_17)
    plot(t,Casey_Sum_TEG_18)
    plot(t,Casey_Sum_TEG_19)
    plot(t,Casey_Sum_TEG_20)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 17','Case 18','Case 19','Case 20')
    title('Casey/Summer - TEG Power Contribution - Cases 17:20 (80% Clouds)')
    hold off

%% Casey Spring

figure(6)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Casey_Spr_PV_0)
    plot(t,Casey_Spr_PV_TEG_PCM_P_01)
    plot(t,Casey_Spr_PV_TEG_PCM_P_02)
    plot(t,Casey_Spr_PV_TEG_PCM_P_03)
    plot(t,Casey_Spr_PV_TEG_PCM_P_04)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 01','Full PV/TEG/PCM - 02',...
        'Full PV/TEG/PCM - 03','Full PV/TEG/PCM - 04')
    title('Casey/Spring - 1 Solar Panel eq. - 0% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Casey_Spr_TEG_01)
    plot(t,Casey_Spr_TEG_02)
    plot(t,Casey_Spr_TEG_03)
    plot(t,Casey_Spr_TEG_04)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 01','Case 02','Case 03','Case 04')
    title('Casey/Spring - TEG Power Contribution - Cases 01:04 (0% Clouds)')
    hold off

% CASEY – SUMMER – 20% CLOUDS (05:08)
figure(7)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Casey_Spr_PV_20)
    plot(t,Casey_Spr_PV_TEG_PCM_P_05)
    plot(t,Casey_Spr_PV_TEG_PCM_P_06)
    plot(t,Casey_Spr_PV_TEG_PCM_P_07)
    plot(t,Casey_Spr_PV_TEG_PCM_P_08)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 05','Full PV/TEG/PCM - 06',...
        'Full PV/TEG/PCM - 07','Full PV/TEG/PCM - 08')
    title('Casey/Spring - 1 Solar Panel eq. - 20% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Casey_Spr_TEG_05)
    plot(t,Casey_Spr_TEG_06)
    plot(t,Casey_Spr_TEG_07)
    plot(t,Casey_Spr_TEG_08)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 05','Case 06','Case 07','Case 08')
    title('Casey/Spring - TEG Power Contribution - Cases 05:08 (20% Clouds)')
    hold off

% CASEY – SUMMER – 40% CLOUDS (09:12)
figure(8)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Casey_Spr_PV_40)
    plot(t,Casey_Spr_PV_TEG_PCM_P_09)
    plot(t,Casey_Spr_PV_TEG_PCM_P_10)
    plot(t,Casey_Spr_PV_TEG_PCM_P_11)
    plot(t,Casey_Spr_PV_TEG_PCM_P_12)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 09','Full PV/TEG/PCM - 10',...
        'Full PV/TEG/PCM - 11','Full PV/TEG/PCM - 12')
    title('Casey/Spring - 1 Solar Panel eq. - 40% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Casey_Spr_TEG_09)
    plot(t,Casey_Spr_TEG_10)
    plot(t,Casey_Spr_TEG_11)
    plot(t,Casey_Spr_TEG_12)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 09','Case 10','Case 11','Case 12')
    title('Casey/Spring - TEG Power Contribution - Cases 09:12 (40% Clouds)')
    hold off

% CASEY – SUMMER – 60% CLOUDS (13:16)
figure(9)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Casey_Spr_PV_60)
    plot(t,Casey_Spr_PV_TEG_PCM_P_13)
    plot(t,Casey_Spr_PV_TEG_PCM_P_14)
    plot(t,Casey_Spr_PV_TEG_PCM_P_15)
    plot(t,Casey_Spr_PV_TEG_PCM_P_16)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 13','Full PV/TEG/PCM - 14',...
        'Full PV/TEG/PCM - 15','Full PV/TEG/PCM - 16')
    title('Casey/Spring - 1 Solar Panel eq. - 60% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Casey_Spr_TEG_13)
    plot(t,Casey_Spr_TEG_14)
    plot(t,Casey_Spr_TEG_15)
    plot(t,Casey_Spr_TEG_16)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 13','Case 14','Case 15','Case 16')
    title('Casey/Spring - TEG Power Contribution - Cases 13:16 (60% Clouds)')
    hold off

% CASEY – SUMMER – 80% CLOUDS (13:16)
figure(10)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Casey_Spr_PV_80)
    plot(t,Casey_Spr_PV_TEG_PCM_P_17)
    plot(t,Casey_Spr_PV_TEG_PCM_P_18)
    plot(t,Casey_Spr_PV_TEG_PCM_P_19)
    plot(t,Casey_Spr_PV_TEG_PCM_P_20)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 17','Full PV/TEG/PCM - 18',...
        'Full PV/TEG/PCM - 19','Full PV/TEG/PCM - 20')
    title('Casey/Spring - 1 Solar Panel eq. - 80% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Casey_Spr_TEG_17)
    plot(t,Casey_Spr_TEG_18)
    plot(t,Casey_Spr_TEG_19)
    plot(t,Casey_Spr_TEG_20)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 17','Case 18','Case 19','Case 20')
    title('Casey/Spring - TEG Power Contribution - Cases 17:20 (80% Clouds)')
    hold off



%% Davis/Sum
% Davis – SUMMER – 0% CLOUDS (01:04)
figure(11)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Davis_Sum_PV_0)
    plot(t,Davis_Sum_PV_TEG_PCM_P_01)
    plot(t,Davis_Sum_PV_TEG_PCM_P_02)
    plot(t,Davis_Sum_PV_TEG_PCM_P_03)
    plot(t,Davis_Sum_PV_TEG_PCM_P_04)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 01','Full PV/TEG/PCM - 02',...
        'Full PV/TEG/PCM - 03','Full PV/TEG/PCM - 04')
    title('Davis/Summer - 1 Solar Panel eq. - 0% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Davis_Sum_TEG_01)
    plot(t,Davis_Sum_TEG_02)
    plot(t,Davis_Sum_TEG_03)
    plot(t,Davis_Sum_TEG_04)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 01','Case 02','Case 03','Case 04')
    title('Davis/Summer - TEG Power Contribution - Cases 01:04 (0% Clouds)')
    hold off

% Davis – SUMMER – 20% CLOUDS (05:08)
figure(12)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Davis_Sum_PV_20)
    plot(t,Davis_Sum_PV_TEG_PCM_P_05)
    plot(t,Davis_Sum_PV_TEG_PCM_P_06)
    plot(t,Davis_Sum_PV_TEG_PCM_P_07)
    plot(t,Davis_Sum_PV_TEG_PCM_P_08)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 05','Full PV/TEG/PCM - 06',...
        'Full PV/TEG/PCM - 07','Full PV/TEG/PCM - 08')
    title('Davis/Summer - 1 Solar Panel eq. - 20% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Davis_Sum_TEG_05)
    plot(t,Davis_Sum_TEG_06)
    plot(t,Davis_Sum_TEG_07)
    plot(t,Davis_Sum_TEG_08)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 05','Case 06','Case 07','Case 08')
    title('Davis/Summer - TEG Power Contribution - Cases 05:08 (20% Clouds)')
    hold off

% Davis – SUMMER – 40% CLOUDS (09:12)
figure(13)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Davis_Sum_PV_40)
    plot(t,Davis_Sum_PV_TEG_PCM_P_09)
    plot(t,Davis_Sum_PV_TEG_PCM_P_10)
    plot(t,Davis_Sum_PV_TEG_PCM_P_11)
    plot(t,Davis_Sum_PV_TEG_PCM_P_12)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 09','Full PV/TEG/PCM - 10',...
        'Full PV/TEG/PCM - 11','Full PV/TEG/PCM - 12')
    title('Davis/Summer - 1 Solar Panel eq. - 40% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Davis_Sum_TEG_09)
    plot(t,Davis_Sum_TEG_10)
    plot(t,Davis_Sum_TEG_11)
    plot(t,Davis_Sum_TEG_12)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 09','Case 10','Case 11','Case 12')
    title('Davis/Summer - TEG Power Contribution - Cases 09:12 (40% Clouds)')
    hold off

% Davis – SUMMER – 60% CLOUDS (13:16)
figure(14)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Davis_Sum_PV_60)
    plot(t,Davis_Sum_PV_TEG_PCM_P_13)
    plot(t,Davis_Sum_PV_TEG_PCM_P_14)
    plot(t,Davis_Sum_PV_TEG_PCM_P_15)
    plot(t,Davis_Sum_PV_TEG_PCM_P_16)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 13','Full PV/TEG/PCM - 14',...
        'Full PV/TEG/PCM - 15','Full PV/TEG/PCM - 16')
    title('Davis/Summer - 1 Solar Panel eq. - 60% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Davis_Sum_TEG_13)
    plot(t,Davis_Sum_TEG_14)
    plot(t,Davis_Sum_TEG_15)
    plot(t,Davis_Sum_TEG_16)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 13','Case 14','Case 15','Case 16')
    title('Davis/Summer - TEG Power Contribution - Cases 13:16 (60% Clouds)')
    hold off

% Davis – SUMMER – 80% CLOUDS (13:16)
figure(15)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Davis_Sum_PV_80)
    plot(t,Davis_Sum_PV_TEG_PCM_P_17)
    plot(t,Davis_Sum_PV_TEG_PCM_P_18)
    plot(t,Davis_Sum_PV_TEG_PCM_P_19)
    plot(t,Davis_Sum_PV_TEG_PCM_P_20)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 17','Full PV/TEG/PCM - 18',...
        'Full PV/TEG/PCM - 19','Full PV/TEG/PCM - 20')
    title('Davis/Summer - 1 Solar Panel eq. - 80% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Davis_Sum_TEG_17)
    plot(t,Davis_Sum_TEG_18)
    plot(t,Davis_Sum_TEG_19)
    plot(t,Davis_Sum_TEG_20)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 17','Case 18','Case 19','Case 20')
    title('Davis/Summer - TEG Power Contribution - Cases 17:20 (80% Clouds)')
    hold off


%% Davis/Spr

figure(16)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Davis_Spr_PV_0)
    plot(t,Davis_Spr_PV_TEG_PCM_P_01)
    plot(t,Davis_Spr_PV_TEG_PCM_P_02)
    plot(t,Davis_Spr_PV_TEG_PCM_P_03)
    plot(t,Davis_Spr_PV_TEG_PCM_P_04)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 01','Full PV/TEG/PCM - 02',...
        'Full PV/TEG/PCM - 03','Full PV/TEG/PCM - 04')
    title('Davis/Spring - 1 Solar Panel eq. - 0% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Davis_Spr_TEG_01)
    plot(t,Davis_Spr_TEG_02)
    plot(t,Davis_Spr_TEG_03)
    plot(t,Davis_Spr_TEG_04)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 01','Case 02','Case 03','Case 04')
    title('Davis/Spring - TEG Power Contribution - Cases 01:04 (0% Clouds)')
    hold off

% CASEY – SUMMER – 20% CLOUDS (05:08)
figure(17)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Davis_Spr_PV_20)
    plot(t,Davis_Spr_PV_TEG_PCM_P_05)
    plot(t,Davis_Spr_PV_TEG_PCM_P_06)
    plot(t,Davis_Spr_PV_TEG_PCM_P_07)
    plot(t,Davis_Spr_PV_TEG_PCM_P_08)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 05','Full PV/TEG/PCM - 06',...
        'Full PV/TEG/PCM - 07','Full PV/TEG/PCM - 08')
    title('Davis/Spring - 1 Solar Panel eq. - 20% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Davis_Spr_TEG_05)
    plot(t,Davis_Spr_TEG_06)
    plot(t,Davis_Spr_TEG_07)
    plot(t,Davis_Spr_TEG_08)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 05','Case 06','Case 07','Case 08')
    title('Davis/Spring - TEG Power Contribution - Cases 05:08 (20% Clouds)')
    hold off

% CASEY – SUMMER – 40% CLOUDS (09:12)
figure(18)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Davis_Spr_PV_40)
    plot(t,Davis_Spr_PV_TEG_PCM_P_09)
    plot(t,Davis_Spr_PV_TEG_PCM_P_10)
    plot(t,Davis_Spr_PV_TEG_PCM_P_11)
    plot(t,Davis_Spr_PV_TEG_PCM_P_12)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 09','Full PV/TEG/PCM - 10',...
        'Full PV/TEG/PCM - 11','Full PV/TEG/PCM - 12')
    title('Davis/Spring - 1 Solar Panel eq. - 40% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Davis_Spr_TEG_09)
    plot(t,Davis_Spr_TEG_10)
    plot(t,Davis_Spr_TEG_11)
    plot(t,Davis_Spr_TEG_12)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 09','Case 10','Case 11','Case 12')
    title('Davis/Spring - TEG Power Contribution - Cases 09:12 (40% Clouds)')
    hold off

% CASEY – SUMMER – 60% CLOUDS (13:16)
figure(19)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Davis_Spr_PV_60)
    plot(t,Davis_Spr_PV_TEG_PCM_P_13)
    plot(t,Davis_Spr_PV_TEG_PCM_P_14)
    plot(t,Davis_Spr_PV_TEG_PCM_P_15)
    plot(t,Davis_Spr_PV_TEG_PCM_P_16)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 13','Full PV/TEG/PCM - 14',...
        'Full PV/TEG/PCM - 15','Full PV/TEG/PCM - 16')
    title('Davis/Spring - 1 Solar Panel eq. - 60% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Davis_Spr_TEG_13)
    plot(t,Davis_Spr_TEG_14)
    plot(t,Davis_Spr_TEG_15)
    plot(t,Davis_Spr_TEG_16)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 13','Case 14','Case 15','Case 16')
    title('Davis/Spring - TEG Power Contribution - Cases 13:16 (60% Clouds)')
    hold off

% CASEY – SUMMER – 80% CLOUDS (13:16)
figure(20)
subplot(1,2,1)
    hold on
    grid on
    grid minor
    plot(t,Davis_Spr_PV_80)
    plot(t,Davis_Spr_PV_TEG_PCM_P_17)
    plot(t,Davis_Spr_PV_TEG_PCM_P_18)
    plot(t,Davis_Spr_PV_TEG_PCM_P_19)
    plot(t,Davis_Spr_PV_TEG_PCM_P_20)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Iso. PV','Full PV/TEG/PCM - 17','Full PV/TEG/PCM - 18',...
        'Full PV/TEG/PCM - 19','Full PV/TEG/PCM - 20')
    title('Davis/Spring - 1 Solar Panel eq. - 80% Clouds')
    hold off
subplot(1,2,2)
    hold on
    grid on
    grid minor
    plot(t,Davis_Spr_TEG_17)
    plot(t,Davis_Spr_TEG_18)
    plot(t,Davis_Spr_TEG_19)
    plot(t,Davis_Spr_TEG_20)
    ylabel('Power (W)')
    xlabel('Time - 24 hour')
    legend('Case 17','Case 18','Case 19','Case 20')
    title('Davis/Spring - TEG Power Contribution - Cases 17:20 (80% Clouds)')
    hold off


    %% Data export
    % For excel? 
    COMP_P_PV_TEG_PCM = [...
        (Casey_Sum_PV_0);(Casey_Sum_PV_TEG_PCM_P_01);...
        (Casey_Sum_PV_TEG_PCM_P_02);(Casey_Sum_PV_TEG_PCM_P_03);...
        (Casey_Sum_PV_TEG_PCM_P_04);(Casey_Sum_PV_TEG_PCM_P_05);...
        (Casey_Sum_PV_TEG_PCM_P_06);(Casey_Sum_PV_TEG_PCM_P_07);...
        (Casey_Sum_PV_TEG_PCM_P_08);(Casey_Sum_PV_TEG_PCM_P_09);...
        (Casey_Sum_PV_TEG_PCM_P_10);(Casey_Sum_PV_TEG_PCM_P_11);...
        (Casey_Sum_PV_TEG_PCM_P_12);(Casey_Sum_PV_TEG_PCM_P_13);...
        (Casey_Sum_PV_TEG_PCM_P_14);(Casey_Sum_PV_TEG_PCM_P_15);...
        (Casey_Sum_PV_TEG_PCM_P_16);(Casey_Sum_PV_TEG_PCM_P_17);...
        (Casey_Sum_PV_TEG_PCM_P_18);(Casey_Sum_PV_TEG_PCM_P_19);...
        (Casey_Sum_PV_TEG_PCM_P_20);...
        ...
        (Casey_Spr_PV_0);(Casey_Spr_PV_TEG_PCM_P_01);...
        (Casey_Spr_PV_TEG_PCM_P_02);(Casey_Spr_PV_TEG_PCM_P_03);...
        (Casey_Spr_PV_TEG_PCM_P_04);(Casey_Spr_PV_TEG_PCM_P_05);...
        (Casey_Spr_PV_TEG_PCM_P_06);(Casey_Spr_PV_TEG_PCM_P_07);...
        (Casey_Spr_PV_TEG_PCM_P_08);(Casey_Spr_PV_TEG_PCM_P_09);...
        (Casey_Spr_PV_TEG_PCM_P_10);(Casey_Spr_PV_TEG_PCM_P_11);...
        (Casey_Spr_PV_TEG_PCM_P_12);(Casey_Spr_PV_TEG_PCM_P_13);...
        (Casey_Spr_PV_TEG_PCM_P_14);(Casey_Spr_PV_TEG_PCM_P_15);...
        (Casey_Spr_PV_TEG_PCM_P_16);(Casey_Spr_PV_TEG_PCM_P_17);...
        (Casey_Spr_PV_TEG_PCM_P_18);(Casey_Spr_PV_TEG_PCM_P_19);...
        (Casey_Spr_PV_TEG_PCM_P_20);...
        ...
        (Davis_Sum_PV_0);(Davis_Sum_PV_TEG_PCM_P_01);...
        (Davis_Sum_PV_TEG_PCM_P_02);(Davis_Sum_PV_TEG_PCM_P_03);...
        (Davis_Sum_PV_TEG_PCM_P_04);(Davis_Sum_PV_TEG_PCM_P_05);...
        (Davis_Sum_PV_TEG_PCM_P_06);(Davis_Sum_PV_TEG_PCM_P_07);...
        (Davis_Sum_PV_TEG_PCM_P_08);(Davis_Sum_PV_TEG_PCM_P_09);...
        (Davis_Sum_PV_TEG_PCM_P_10);(Davis_Sum_PV_TEG_PCM_P_11);...
        (Davis_Sum_PV_TEG_PCM_P_12);(Davis_Sum_PV_TEG_PCM_P_13);...
        (Davis_Sum_PV_TEG_PCM_P_14);(Davis_Sum_PV_TEG_PCM_P_15);...
        (Davis_Sum_PV_TEG_PCM_P_16);(Davis_Sum_PV_TEG_PCM_P_17);...
        (Davis_Sum_PV_TEG_PCM_P_18);(Davis_Sum_PV_TEG_PCM_P_19);...
        (Davis_Sum_PV_TEG_PCM_P_20);...
        ...
        (Davis_Spr_PV_0);(Davis_Spr_PV_TEG_PCM_P_01);...
        (Davis_Spr_PV_TEG_PCM_P_02);(Davis_Spr_PV_TEG_PCM_P_03);...
        (Davis_Spr_PV_TEG_PCM_P_04);(Davis_Spr_PV_TEG_PCM_P_05);...
        (Davis_Spr_PV_TEG_PCM_P_06);(Davis_Spr_PV_TEG_PCM_P_07);...
        (Davis_Spr_PV_TEG_PCM_P_08);(Davis_Spr_PV_TEG_PCM_P_09);...
        (Davis_Spr_PV_TEG_PCM_P_10);(Davis_Spr_PV_TEG_PCM_P_11);...
        (Davis_Spr_PV_TEG_PCM_P_12);(Davis_Spr_PV_TEG_PCM_P_13);...
        (Davis_Spr_PV_TEG_PCM_P_14);(Davis_Spr_PV_TEG_PCM_P_15);...
        (Davis_Spr_PV_TEG_PCM_P_16);(Davis_Spr_PV_TEG_PCM_P_17);...
        (Davis_Spr_PV_TEG_PCM_P_18);(Davis_Spr_PV_TEG_PCM_P_19);...
        (Davis_Spr_PV_TEG_PCM_P_20);];

    filename_PV_TEG_PCM_01_20_P_1_Panel = "COMP_PV_TEG_PCM_01_20_P.xlsx"; % make file
    writematrix(COMP_P_PV_TEG_PCM,filename_PV_TEG_PCM_01_20_P_1_Panel,...
                'Sheet',1);


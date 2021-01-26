clear all;
clc;

% Drive configuration
RWD = 0;  % 1 for RWD, 0 for FWD

% vehicle kinematic and dynamic parameters.
g = 9.81;              % graviational acceleration in [m/s2]
m = 1800;              % vehicle mass in [kg]
rho_air = 1.26;        % the density of air in [kg/m3]
Cd= 0.23;              % the drag coefficient in []
Af = 2.34;             % the cross-sectional area in [m2]
Crr = 0.009;           % rolling resistance coefficient in []
length = 4.694;        % length of vehi in [m]
Jz = 0.9*m*(length/2)^2; % polar moment of inertia (approximation)
wb = 2.875;            % wheel base in [m]
b = wb*0.5;            % distance to CG from rear axle in [m]
a = wb-b;              % distance to CG from front axle in [m]
Fz = m*g;              % total gravitational force in [N]
Fz1 = Fz*b/wb;         % gravitational force on front tires in [N]
Fz2 = Fz - Fz1;        % gravitational force on rear tires in [N]

% Tire parameters
Bx = 10;      % shape factor []
Cx = 1.9;     % stiffness factor []
Dx = 1;       % peak friction coefficient []
Ex = 0.8;     % curvature factor []

By = 12.5;    % shape factor []
Cy = 1.2;     % stiffness factor []
Dy = -1;      % peak friction coefficient []
Ey = -1;      % curvature factor []

Bz = 20;      % shape factor []
Cz = 2.4;     % stiffness factor []
Dz = 0.011;   % peak friction coefficient []
Ez = -1;      % curvature factor []

% Operation point
delta = 5*pi/180;        % steering angle in [rad]
tireVelDesired = 30/3.6; % velocity in [m/s]

% figure counting
n = 1;

%% Task 1.3

% Automatically runs the Simulink model
tireVelDesired = 30/3.6; % Keep the desired velocity at 30 km/h
iniU = 10;
iniV = 0;
iniPsiDot = 0.1;
task1_result = sim("Task1model", 100); % Export result from Simulink

%Plots the results of the position of the vehicle in and X-Y plot
figure(n);
n = n + 1;
plot(task1_result.X.Data , task1_result.Y.Data);
title('Vehicle Trajectory','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
xlabel('X-position','FontName','Times New Roman','FontSize',14);
ylabel('Y-position','FontName','Times New Roman','FontSize',14);
axis equal;
grid on;

%% Task 3 Case 1
tireVelDesired = 30/3.6; % Keep the desired velocity at 30 km/h
iniU = 0;
iniV = 0;
iniPsiDot = 0;
% Steering angle = 5°
delta = 5*pi/180;
Angle_5_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", 15); % Export result from Simulink

%Plots
figure(n);
n = n + 1;
plot(Angle_5_result.X.Data , Angle_5_result.Y.Data);
axis equal;
hold on;

% Steering angle = 10°
delta = 10*pi/180;
Angle_10_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", 15); % Export result from Simulink

%Plots
plot(Angle_10_result.X.Data , Angle_10_result.Y.Data);
axis equal;
hold on;

% Steering angle = 20°
delta = 20*pi/180;
Angle_20_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", 15); % Export result from Simulink

%Plots
plot(Angle_20_result.X.Data , Angle_20_result.Y.Data);
axis equal;
hold off;

title('Vehicle Trajectory for Different Steering Angle','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
xlabel('X-position','FontName','Times New Roman','FontSize',14);
ylabel('Y-position','FontName','Times New Roman','FontSize',14);
legend('Steering angle = 5°','Steering angle = 10°','Steering angle = 20°');
grid on;

%% Task 3 Case 2'
delta = 15*pi/180; % Keep the steering angle at 15°

% Desired velocity = 30 km/h
tireVelDesired = 30/3.6; % velocity in [m/s]
iniU = 0;
iniV = 0;
iniPsiDot = 0;
Velocity_30_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", 15); % Export result from Simulink

% Plot
figure(n);
n = n + 1;
plot(Velocity_30_result.X.Data , Velocity_30_result.Y.Data);
axis equal;
hold on;

% Desired velocity = 45 km/h
tireVelDesired = 45/3.6; % velocity in [m/s]
iniU = 0;
iniV = 0;
iniPsiDot = 0;
Velocity_45_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", 15); % Export result from Simulink

% Plot
plot(Velocity_45_result.X.Data , Velocity_45_result.Y.Data);
axis equal;
hold on;

% Desired velocity = 50 km/h
tireVelDesired = 50/3.6; % velocity in [m/s]
iniU = tireVelDesired;
iniV = 0;
iniPsiDot = 0;
Velocity_50_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", 15); % Export result from Simulink

% Plot
plot(Velocity_50_result.X.Data , Velocity_50_result.Y.Data);
axis equal;
hold off;

title('Vehicle Trajectory for Different Velocity','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
xlabel('X-position','FontName','Times New Roman','FontSize',14);
ylabel('Y-position','FontName','Times New Roman','FontSize',14);
legend('velocity = 30 km/h','velocity = 45 km/h','velocity = 50 km/h');
grid on;

%% Task 4.1
% Intialization
delta = 10*pi/180; % Keep the steering angle at 10°
tireVelDesired = 30/3.6; % Keep the desired velocity at 30 km/h
iniU = 0;
iniV = 0;
iniPsiDot = 0;
t = 15; % Set time

% CG located at 30% of the wheelbase from the rear axle.
b = wb*0.3; % distance to CG from rear axle in [m]
a = wb-b;              % distance to CG from front axle in [m]
Fz1 = Fz*b/wb;         % gravitational force on front tires in [N]
Fz2 = Fz - Fz1;        % gravitational force on rear tires in [N]
CG_30_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", t); % Export result from Simulink


% Plot
figure(n);
n = n + 1;
plot(CG_30_result.X.Data , CG_30_result.Y.Data);
axis equal;
hold on;

% CG located at 50% of the wheelbase from the rear axle.
b = wb*0.5; % distance to CG from rear axle in [m]
a = wb-b;              % distance to CG from front axle in [m]
Fz1 = Fz*b/wb;         % gravitational force on front tires in [N]
Fz2 = Fz - Fz1;        % gravitational force on rear tires in [N]
CG_50_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", t); % Export result from Simulink

% Plot
plot(CG_50_result.X.Data , CG_50_result.Y.Data);
axis equal;
hold on;

% CG located at 60% of the wheelbase from the rear axle.
b = wb*0.6; % distance to CG from rear axle in [m]
a = wb-b;   % distance to CG from front axle in [m]
Fz1 = Fz*b/wb;         % gravitational force on front tires in [N]
Fz2 = Fz - Fz1;        % gravitational force on rear tires in [N]
CG_60_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", t); % Export result from Simulink

% Plot
plot(CG_60_result.X.Data , CG_60_result.Y.Data);
axis equal;
hold on;

% CG located at 70% of the wheelbase from the rear axle.
b = wb*0.7; % distance to CG from rear axle in [m]
a = wb-b;              % distance to CG from front axle in [m]
Fz1 = Fz*b/wb;         % gravitational force on front tires in [N]
Fz2 = Fz - Fz1;        % gravitational force on rear tires in [N]
CG_70_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", t); % Export result from Simulink

% Plot
plot(CG_70_result.X.Data , CG_70_result.Y.Data);
axis equal;
hold off;

title('Vehicle Trajectory for Different CG Location at 30 km/h','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
xlabel('X-position','FontName','Times New Roman','FontSize',14);
ylabel('Y-position','FontName','Times New Roman','FontSize',14);
legend('CG located at 30%','CG located at 50%','CG located at 60%','CG located at 70%');
grid on;

%% Task 4.2
% Intialization
delta = 10*pi/180; % Keep the steering angle at 10°
tireVelDesired = 60/3.6; % Keep the desired velocity at 60 km/h
iniU = 0;
iniV = 0;
iniPsiDot = 0;
t = 15; % Set time

% CG located at 30% of the wheelbase from the rear axle.
b = wb*0.3; % distance to CG from rear axle in [m]
a = wb-b;   % distance to CG from front axle in [m]
Fz1 = Fz*b/wb;         % gravitational force on front tires in [N]
Fz2 = Fz - Fz1;        % gravitational force on rear tires in [N]
CG_30_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", t); % Export result from Simulink

% Plot
figure(n);
n = n + 1;
plot(CG_30_result.X.Data , CG_30_result.Y.Data);
axis equal;
hold on;

% CG located at 50% of the wheelbase from the rear axle.
b = wb*0.5; % distance to CG from rear axle in [m]
a = wb-b; % distance to CG from front axle in [m]
Fz1 = Fz*b/wb;         % gravitational force on front tires in [N]
Fz2 = Fz - Fz1;        % gravitational force on rear tires in [N]
CG_50_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", t); % Export result from Simulink

% Plot
plot(CG_50_result.X.Data , CG_50_result.Y.Data);
axis equal;
hold on;

% CG located at 60% of the wheelbase from the rear axle.
b = wb*0.6; % distance to CG from rear axle in [m]
a = wb-b; % distance to CG from front axle in [m]
Fz1 = Fz*b/wb;         % gravitational force on front tires in [N]
Fz2 = Fz - Fz1;        % gravitational force on rear tires in [N]
CG_60_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", t); % Export result from Simulink

% Plot
plot(CG_60_result.X.Data , CG_60_result.Y.Data);
axis equal;
hold on;

% CG located at 70% of the wheelbase from the rear axle.
b = wb*0.7; % distance to CG from rear axle in [m]
a = wb-b; % distance to CG from front axle in [m]
Fz1 = Fz*b/wb;         % gravitational force on front tires in [N]
Fz2 = Fz - Fz1;        % gravitational force on rear tires in [N]
CG_70_result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel", t); % Export result from Simulink

% Plot
plot(CG_70_result.X.Data , CG_70_result.Y.Data);
axis equal;
hold off;

title('Vehicle Trajectory for Different CG Location at 60 km/h','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
xlabel('X-position','FontName','Times New Roman','FontSize',14);
ylabel('Y-position','FontName','Times New Roman','FontSize',14);
legend('CG located at 30%','CG located at 50%','CG located at 60%','CG located at 70%');
grid on;

%% Task Test

figure(n);
n = n + 1;
iniU = 10;
iniV = -10;
iniPsiDot = 0;

delta = 15*pi/180; % steering angle in [rad]
tireVelDesired = 20; % velocity in [m/s]
b = wb*0.5;
a = wb-b;
Fz1 = Fz*b/wb;         % gravitational force on front tires in [N]
Fz2 = Fz - Fz1;        % gravitational force on rear tires in [N]
result = sim("AuE881_HW5_Zhai_Kexuan_BicycleModel",10);
plot(result.X.Data,result.Y.Data);
title('Test','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
xlabel('X-position','FontName','Times New Roman','FontSize',14);
ylabel('Y-position','FontName','Times New Roman','FontSize',14);
grid on;
axis equal;

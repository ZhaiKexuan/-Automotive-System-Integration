%% Initialization
% Run initialization before running everything else!
eff_motor = 0.85;
eff_transmission = 0.95;
eff_battery = 0.90;

%% Task 2

% Setup
load('Electric_Motor_Data.mat'); % Load data from file

%Solve
% Export data from simulink
task2_result = sim("hw4_2", 60); % Export result from Simulink
task2_speed = task2_result.VehicleSpeed.signals.values; % Export speed from simulink 
task2_time = task2_result.tout; % Export time from simulink

% Calculate and top speed
Max_speed = max(task2_speed); % Max speed
[task2_speed_unique,index] = unique(task2_speed);
Duration_max = interp1(task2_speed_unique,task2_time(index), Max_speed); % The time required to reach 99% of the top speed
hold on;

% Calculate 99% top speed
Max_speed = max(task2_speed); 
Max_speed_99 = Max_speed * 0.99;
[task2_speed_99_unique,index] = unique(task2_speed);
Duration_max_99 = interp1(task2_speed_99_unique,task2_time(index), Max_speed_99); % The time required to reach 99% of the top speed

% Calculate and Plot duration of 0-100 km/s
[task2_speed_100_unique,index] = unique(task2_speed);
Duration_100 = interp1(task2_speed_100_unique, task2_time(index), 100); % The time required for the vehicle to reach 100 km/h

% Print results
fprintf("Max speed: %.2f km/h\n" ,Max_speed);
fprintf("The time required to reach 99%% of the top speed: %f s \n" ,Duration_max_99);
fprintf("The time required for the vehicle to reach 100 km/h: %.2f s\n" ,Duration_100);

% Plot
% Plot Speed vs time
plot(task2_time, task2_speed);
title('Speed Changes','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
xlabel('Time[s]','FontName','Times New Roman','FontSize',14);
ylabel('Speed[km/h]','FontName','Times New Roman','FontSize',14);
hold on;


% Plot 99% top speed
plot(Duration_max_99, Max_speed_99,'Marker','x');
text(Duration_max_99, Max_speed_99,'99% Maxspeed')
hold on;

% Plot duration of 0-100 km/s
plot(Duration_100, 100,'Marker','x');
text(Duration_100, 100,'(8.848, 100)')
hold off;

%% Task 3

% Setup
load('Electric_Motor_Data.mat');
load('US06_Drive_Cycle.mat');

% Solve
us06_ts = timeseries(v_cyc, t_cyc); % Pack speed and time
task3_result = sim("hw4_3", 600); % Export result from Simulink
task3_time = task3_result.tout; % Export time from simulink
task3_speed_drivecycle = task3_result.Drivecycle; % Export drive cycle speed from simulink
task3_speed_vehicle = task3_result.Vehicle; % Export vehicle speed from simulink 
task3_aero = task3_result.Aero; % Export aero driving force from simulink
task3_kWh = task3_result.e_kWh; % Export kWh from Simulink
task3_Wh_km = task3_result.e_kWh_km; % Export Wh_km from Simulink
Max_kWh = task3_kWh(end); % The total battery energy consumed for the drive cycle
Max_Wh_km = task3_Wh_km(end); % The energy consumption over the entire drive cycle

% Plot
% Plot of the vehicle speed and the drive cycle speed
figure;
plot(task3_time, task3_speed_vehicle);
hold on;
plot(task3_time, task3_speed_drivecycle);
title('vehicle speed and the drive cycle speed','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
xlabel('Time[s]','FontName','Times New Roman','FontSize',14);
ylabel('Speed[km/h]','FontName','Times New Roman','FontSize',14);
xlim([0 600]);
ylim([-50,200]);
hold off;
legend('Vehicle Speed','Drive Cycle Speed');

% Plot of aerodynamic drag force for the drive cycle
figure;
plot(task3_time, task3_aero);
    title('Aerodynamic Drag Force VS. Time','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
    xlabel('Time[s]','FontName','Times New Roman','FontSize',14);
    ylabel('Aerodynamic Drag Force[N]','FontName','Times New Roman','FontSize',14);

%% Task 4

% Setup
load('US06_Drive_Cycle.mat');
Scale = [0.25, 0.50, 0.75, 1.00, 1.50];

% The template (script with setup/solve/plot) is applied in each problem

% Problem 1: Vehicle speed and the desired speed

for i = 1:length(Scale)
    
    % Solve
    v_cyc_1 = Scale(i) * v_cyc;
    us06_ts = timeseries(v_cyc_1, t_cyc);
    task4_result = sim("hw4_4", 600); % Export result from Simulink
    task4_speed_drivecycle = task4_result.Drivecycle; % Export drive cycle speed from simulink
    task4_speed_vehicle = task4_result.Vehicle; % Export vehicle speed from simulink 
    task4_time = task4_result.tout; % Export time from simulink
     
    % Plot
    % Plot config
    figure;

    % Plot vehicle speed vs time
    plot(task4_time, task4_speed_vehicle);
    hold on;
    
    % Plot drive cycle speed vs time
    plot(task4_time, task4_speed_drivecycle);
    title(strcat("Speed Scale : ", num2str(Scale(i))));
    xlabel('Time[s]','FontName','Times New Roman','FontSize',14);
    ylabel('Speed[km/h]','FontName','Times New Roman','FontSize',14);
    xlim([0 600]);
    ylim([-50,200]);
    hold off; 
end

% Problem 2: aerodynamic drag force vs. time

figure; % Create new figure
for i = 1:length(Scale)
    
    % Solve
    v_cyc_1 = Scale(i) * v_cyc;
    us06_ts = timeseries(v_cyc_1, t_cyc);
    task4_result = sim("hw4_4", 600); % Export result from Simulink
    task4_time = task4_result.tout; % Export time from simulink
    task4_aero = task4_result.Aero; % Export aero driving force from simulink
    
    % Plot
    % Plot aerodynamic drag force
    plot(task4_time, task4_aero);
    title('Aerodynamic Drag Force VS. Time','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
    xlabel('Time[s]','FontName','Times New Roman','FontSize',14);
    ylabel('Aerodynamic Drag Force[N]','FontName','Times New Roman','FontSize',14);
    hold on;  
end
legend('25% Speed','50% Speed','75% Speed','100% Speed','150% Speed');
hold off;

% Problem 3: Total energy consumed in kWh

% Setup
Energy = zeros(1,5);

% Solve
for i = 1:length(Scale)
    v_cyc_1 = Scale(i) * v_cyc;
    us06_ts = timeseries(v_cyc_1, t_cyc);
    task4_result = sim("hw4_4", 600); % Export result from Simulink
    Energy(i) = max(task4_result.e_kWh); 
end

% Plot
figure; % Create new figure
plot(Scale, Energy,'LineStyle','none','Marker','.','MarkerSize',10);
    title('Total Energy Consumed VS. Speed Scale','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
    xlabel('Speed Scale','FontName','Times New Roman','FontSize',14);
    ylabel('Total Energy Consumed[kWh]','FontName','Times New Roman','FontSize',14);

% Problem 4: Energy consumption in Wh/km

% Setup
Energy_1 = zeros(1,5);

% Solve
for i = 1:length(Scale)
    v_cyc_1 = Scale(i) * v_cyc;
    us06_ts = timeseries(v_cyc_1, t_cyc);
    task4_result = sim("hw4_4", 600); % Export result from Simulink
    Energy_1(i) = max(task4_result.e_kWh_km); 
end

% Plot
figure; % Create new figure
plot(Scale, Energy_1,'LineStyle','none','Marker','.','MarkerSize',10);
    title('Total Energy Consumed VS. Speed Scale','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
    xlabel('Speed Scale','FontName','Times New Roman','FontSize',14);
    ylabel('Total Energy consumption[Wh/km]','FontName','Times New Roman','FontSize',14);
%% Task 5 

% The battery energy consumption in kWh for FUDS
% Setup
load('FUDS_Drive_Cycle');

% Solve
us06_ts = timeseries(v_cyc, t_cyc);
task5_result = sim("hw4_5", 600); % Export result from Simulink
Energy_FUDS = task5_result.e_kWh;
Max_energy_FUDS = Energy_FUDS(end);

% The battery energy consumption per unit distance
% Solve
Energy_FUDS_1 = task5_result.e_kWh_km;
Max_energy_FUDS_1 = Energy_FUDS_1(end);

% The battery energy consumption in kWh for FHDS
% Setup
load('FHDS_Drive_Cycle');

% Solve
us06_ts = timeseries(v_cyc, t_cyc);
task5_result_2 = sim("hw4_5", 600); % Export result from Simulink
Energy_FHDS = task5_result_2.e_kWh;
Max_energy_FHDS = Energy_FHDS(end);

% The battery energy consumption per unit distance
% Solve
Energy_FHDS_1 = task5_result_2.e_kWh_km;
Max_energy_FHDS_1 = Energy_FHDS_1(end);


% Plot
% Compare the battery energy consumption in kWh for the two cycles
figure;
task5_time = task5_result.tout; % Export time from simulink
plot(task5_time, Energy_FUDS);
hold on;
plot(task5_time, Energy_FHDS);
title('Compare the battery energy consumption in kWh','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
xlabel('Time[s]','FontName','Times New Roman','FontSize',14);
ylabel('Total Energy Consumed[kWh]','FontName','Times New Roman','FontSize',14);
hold off;

% Compare the battery energy consumption per unit distance for the two cycles
figure;
plot(task5_time, Energy_FHDS_1);
hold on;
plot(task5_time, Energy_FUDS_1);
title('Consumption per unit distance','FontName','Times New Roman','FontWeight','Bold','FontSize',16);
xlabel('Time[s]','FontName','Times New Roman','FontSize',14);
ylabel('Total Energy Consumed[Wh/km]','FontName','Times New Roman','FontSize',14);
hold off;












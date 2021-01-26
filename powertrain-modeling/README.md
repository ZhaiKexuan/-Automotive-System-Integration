# Powertrain modeling with Simulink

*Author: Kexuan Zhai*

## Task 1: Model the powertrain of a vehicle
---

<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture1.png"/></div>

Aerodynamic Resistance in X-direction:
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture2.png"/></div>

Tire Rolling Resistance in X-direction:
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture3.png"/></div>
Where  is the tire rolling resistance coefficient.

Traction calculation through Torque T:
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture4.png"/></div>
Where R is the radius of front wheel, 0.95 is the transmission efficiency, 8 is the gear ratio.

Force balance in X-direction:
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture5.png"/></div>

Combine all the equation above, the acceleration can be expressed as:
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture6.png"/></div>
---

## Task 2: Simulate the 0-100 km/h acceleration time and top speed

2.1 Simulink Model:
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture7.png"/></div>

Subsystem: Driving Force
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture8.png"/></div>

Subsystem: Tire Rolling Resistance
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture9.png"/></div>

Subsystem: Aerodynamic Resistance
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture10.png"/></div>

Subsystem: Conversion
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture11.png"/></div>

2.2 Plot of the speed changes
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture12.png"/></div>

2.3 Experimental Results

The experimental result at the start line is shown in the figure below:

| Variable  | Value |
| ------------ | ----------- |
|     The top speed of the vehicle    |     233.35 km/h     |
|     The time required for the vehicle to reach 100 km/h     |     8.39 s    |
|     The time required to reach 99% of the top speed     |     25.99 s     |

- The top speed of the vehicle: 233.35 km/h
- The time required for the vehicle to reach 100 km/h: 8.39 s
- The time required to reach 99% of the top speed: 25.99 s

2.4 Question
- The Simulink model you have created makes certain simplifying assumptions that could affect the predicted 0-100 km/h time quite significantly. Provide two such assumptions.
-- Traction Control System is not considered in the model. In other words, the vehicle won’t go out of control in the process of acceleration.  
-- The max step size is considered to be 0.2(auto).

- Explain how they affect the predicted acceleration time.
-- The car may slip during acceleration and the tires may slip with the ground. In this case, the rotation of the wheel does not completely translate into the travel distance.
-- This means that the output will change every same every 0.2s, which means the acceleration remains the same in each duration of 0.2 seconds. In the actual situations, the acceleration goes down as speed goes up. As a result, the predicting acceleration time will vary as the step size changed (The smaller size, the more accurate result).
	
- Explain whether they would over- or under-estimate the acceleration time.
-- Without considering the traction control system, the acceleration time would be under-estimate. Because the rotation of the wheel does not completely translate into the travel distance.
-- The max step size would under-estimate the accelerate time. As speed goes up, the acceleration always goes down. Because of the time step, the estimate acceleration is higher than the actual acceleration in each 0.2s. Therefore, the estimated time is lower than the actual one.


## Task 3: Simulate a drive cycle to predict the corresponding energy consumption

3.1 Simulink model (Each subsystem is the same as Task 2):
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture13.png"/></div>

3.2	Plot of the vehicle speed and the drive cycle speed, on the same graph:
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture14.png"/></div>

3.3 Plot of aerodynamic drag force for the drive cycle
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture15.png"/></div>

- The total battery energy consumed for the drive cycle (kWh) is 4.8755 kWh
- The energy consumption over the entire drive cycle (Wh/km) is 380.4757 Wh/km

3.4 How does the car behave in the portions of the drive-cycle where the specified speed is zero? Explain the behavior.
- When the specified speed is zero, the speed of the drive-cycle is below zero.  
- This can be caused by two reasons: 
- First, the pi controller has a certain hysteresis, so the speed of the simulation will be negative, but the actual situation does not.
- Second, when the speed is zero, the value of the driving force is still the result of the previous cycle, but there is no traction at this time. Therefore, the speed of the simulation will be negative.

## Task 4: Effect of increased speed on energy consumption and aerodynamic resistance

4.1 Simulink model:
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture16.png"/></div>

4.2 Plot of the vehicle speed and the desired speed
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture17.png"/></div>

<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture18.png"/></div>

<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture19.png"/></div>

<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture20.png"/></div>

<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture21.png"/></div>

4.3 Plot of the aerodynamic drag force
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture22.png"/></div>

4.4 Plot of the total energy consumed in kWh
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture23.png"/></div>

4.5 Plot of the energy consumption in Wh/km as a function of velocity scaling
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture24.png"/></div>

4.6 For large velocities (scaling of 150%), the vehicle behavior changes dramatically. What is happening?
The dramatic change due to the overshoot of PI controller. When the ratio is 150%, the amount of change in speed will be large, and the PI controller will overshoot.

4.7 What trends do you observe in drag force and energy consumption as the velocity increases? Provide an explanation. 
As the speed increases, the aerodynamic drag force also increases. From the calculation formula of aerodynamic drag force, force is proportional to the square of the velocity.
As the speed increases, energy consumption increases faster and faster. This is because as the speed increases, the air resistance also increases. Therefore, the rate of energy consumption is also getting faster and faster.

## Task 5: Comparison of FUDS and FHDS Drive Cycle

5.1 Simulink model:
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture25.png"/></div>

- The battery energy consumption in kWh for FUDS cycle: 1.205 kWh

- The battery energy consumption in kWh for FHDS cycle: 4.445 kWh

- The battery energy consumption per unit distance for FUDS cycle: 346.409 Wh/km

- The battery energy consumption per unit distance for FHDS cycle: 186.158 Wh/km

5.2 Compare the results for the two cycles and explain the differences in the results.

|        | FUDS | FUDS |
| ------------ | ----------- |----------- |
|     The battery energy consumption in kWh    |     1.205     |     4.445    |
|     The battery energy consumption per unit distance(Wh/km)     |     346.409    |     186.158    |

<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture26.png"/></div>
<div align=center><img src="https://github.com/ZhaiKexuan/Automotive-System-Integration/blob/master/powertrain-modeling/images/Picture27.png"/></div>

According to the two figures and the table above, compared to the FHDS cycle, the FUDS cycle consumes less battery per unit distance. The energy consumption kWh of the FHDS cycle is higher than the FUDS cycle. One of the potential reasons is that the total travel distance of the FHDS cycle is higher than the FUDS cycle.
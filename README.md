# Traffic-Light-Controller-using-Spartan-3E-FPGA-Board

This Verilog code implements a simple traffic light controller module along with a corresponding testbench. The controllermodule controls the traffic lights for a main road and a cross road, based on the state of a sensor (C) and a clock signal. The traffic light controller follows a Finite State Machine (FSM) design and transitions through different states to control the lights.

## Controller Module

### Inputs
C: Sensor input to detect vehicles on the cross road.
clk: Clock signal with a frequency of 50 MHz.
rst_n: Reset signal (active low).

### Outputs
light_main: 3-bit output representing the state of the main road lights.
light_cross: 3-bit output representing the state of the cross road lights.
mr, my, mg, cr, cy, cg: Individual outputs representing the state of each light (main road: m and cross road: c), with r for red, y for yellow, and g for green.

### States
The traffic light controller has the following states:

MGRE_CRED: Main road green and cross road red.
MYEL_CRED: Main road yellow and cross road red.
MRED_CGRE: Main road red and cross road green.
MRED_CYEL: Main road red and cross road yellow.

### Operation
The module operates as follows:

The initial state is MGRE_CRED, with the main road lights set to green and the cross road lights set to red.
If the sensor input (C) detects vehicles on the cross road, the controller transitions to the MYEL_CRED state, where the main road lights turn yellow.
After 3 seconds in the MYEL_CRED state, the controller transitions to the MRED_CGRE state, where the main road lights turn red and the cross road lights turn green.
After 10 seconds in the MRED_CGRE state, the controller transitions to the MRED_CYEL state, where the main road lights remain red and the cross road lights turn yellow.
After 3 seconds in the MRED_CYEL state, the controller transitions back to the MGRE_CRED state, restarting the cycle.

### Implementation Details
The module uses registers (reg) to store the current state (state) and the next state (next_state).
Two always blocks are used to update the states based on clock edges and handle the FSM transitions.
The outputs and next states are set according to the current state in the FSM always block.
Additional logic is included to handle delays for the yellow and red lights, along with clock enables.

## Testbench Module
The Verilog code also includes a testbench module (tb_traffic_light) to verify the functionality of the traffic light controller. The testbench module includes the following tasks:

### clock_gen Task
This task generates the clock signal (clk) by toggling it at regular intervals defined by the DELAY parameter.

### reset_gen Task
This task generates a reset signal (rst_n) to initialize the traffic light controller. It lowers the reset signal for a duration and then raises it.

### operation_flow Task
This task simulates the operation flow by toggling the sensor input (C) at different time intervals. It sets the sensor input to detect vehicles on the cross road for a specific duration and then turns it off.

### debug_output Task
This task displays the debug output during simulation, including the current time, reset signal state, sensor input state, and the states of the main road and cross road lights.

### endsimulation Task
This task specifies the end time for the simulation and displays a message indicating the simulation has ended.

### Simulation Setup
The simulation runs for ENDTIME time units, which is set to 400,000 in the provided testbench. You can adjust this value as needed.

## Usage
To simulate the traffic light controller, follow these steps:

Instantiate the tb_traffic_light module in your Verilog testbench.
Compile and run the simulation using a Verilog simulator such as Xilinx Vivado, ModelSim or VCS.
Observe the debug output, which displays the current time, reset signal state, sensor input state, and the states of the main road and cross road lights.

Note: Please ensure that you have appropriate Verilog simulation environment and libraries set up to run the simulation successfully.

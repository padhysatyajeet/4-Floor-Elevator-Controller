##Elevator Controller Verilog Implementation

#Overview

This Verilog project implements a finite state machine (FSM)-based elevator controller designed to manage a 4-floor elevator system. The controller handles internal and external button requests, overload detection, and door safety logic. The system intelligently prioritizes requests using a dynamic floor selection mechanism to optimize elevator travel.


#Features

- Supports 4 floors with individual internal (floor_btn) and external (call_btn) request buttons.

- Implements priority-based request handling using a target_floor mechanism to service the closest requested floor.

- FSM-based logic with 6 states: IDLE, MOVING_UP, MOVING_DOWN, OPEN_DOOR, WAIT_FOR_DOOR_CLOSE, and OVERLOAD_STATE.

- Includes overload detection and door open/close logic for safety.

- Output signals: move_up, move_down, open_door, busy, and current_floor.

- Designed for simulation and waveform analysis using GTKWave.

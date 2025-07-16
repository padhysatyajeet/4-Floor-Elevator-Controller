module tb_ElevatorController;

// Inputs
reg clk = 0;
reg reset;
reg [3:0] floor_btn;
reg [3:0] call_btn;
reg overload;
reg door_closed;

// Outputs
wire move_up;
wire move_down;
wire open_door;
wire busy;
wire [1:0] current_floor;

// Instantiate the Unit Under Test (UUT)
ElevatorController uut (
    .clk(clk),
    .reset(reset),
    .floor_btn(floor_btn),
    .call_btn(call_btn),
    .overload(overload),
    .door_closed(door_closed),
    .move_up(move_up),
    .move_down(move_down),
    .open_door(open_door),
    .busy(busy),
    .current_floor(current_floor)
);

// Clock generation
always #5 clk = ~clk; // 10 time units clock period

initial begin
    // GTKWave dump
    $dumpfile("elevator.vcd");
    $dumpvars(0, tb_ElevatorController);

    // Initial states
    reset = 1;
    floor_btn = 4'b0000;
    call_btn = 4'b0000;
    overload = 0;
    door_closed = 1;

    #10 reset = 0;

    // Scenario 1: Call from floor 3
    #10 call_btn = 4'b1000; // floor 3
    #20 call_btn = 4'b0000;

    #60;

    // Scenario 2: Call from floor 1
    #10 call_btn = 4'b0010;
    #20 call_btn = 4'b0000;

    #60;

    // Scenario 3: Internal button press for floor 0
    #10 floor_btn = 4'b0001;
    #20 floor_btn = 4'b0000;

    #80;

    // Scenario 4: Simulate overload while door open
    #10 overload = 1;
    #20 overload = 0;

    // Door closes after overload clears
    #10 door_closed = 0;
    #20 door_closed = 1;

    #100;
    $finish;
end

endmodule
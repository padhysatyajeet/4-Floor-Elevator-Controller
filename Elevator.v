module ElevatorController(
    input clk, reset,
    input [3:0] floor_btn,      // internal floor request buttons (4 floors)
    input [3:0] call_btn,       // external call buttons (4 floors)
    input overload,
    input door_closed,
    output reg move_up,
    output reg move_down,
    output reg open_door,
    output reg busy,
    output reg [1:0] current_floor
);

    // FSM state parameters
    parameter IDLE               = 3'b000,
              MOVING_UP          = 3'b001,
              MOVING_DOWN        = 3'b010,
              OPEN_DOOR          = 3'b011,
              WAIT_FOR_DOOR_CLOSE= 3'b100,
              OVERLOAD_STATE     = 3'b101;

    reg [2:0] state, next_state;
    reg [3:0] requests;
    reg [1:0] target_floor; // New: stores priority-selected next floor

    // Combine all floor and call requests
    always @(*) begin
        requests = floor_btn | call_btn;
    end

    // Priority floor selection
    always @(*) begin
        // Priority encoder: lowest numbered floor first
        if (requests[0])
            target_floor = 2'd0;
        else if (requests[1])
            target_floor = 2'd1;
        else if (requests[2])
            target_floor = 2'd2;
        else if (requests[3])
            target_floor = 2'd3;
        else
            target_floor = current_floor;
    end

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            current_floor <= 2'd0;
        end else begin
            state <= next_state;
        end
    end

    // FSM logic
    always @(*) begin
        // Default outputs
        move_up = 0;
        move_down = 0;
        open_door = 0;
        busy = 1;
        next_state = state;

        case (state)
            IDLE: begin
                busy = 0;
                if (overload)
                    next_state = OVERLOAD_STATE;
                else if (requests[current_floor])
                    next_state = OPEN_DOOR;
                else if (|requests) begin
                    if (target_floor > current_floor)
                        next_state = MOVING_UP;
                    else if (target_floor < current_floor)
                        next_state = MOVING_DOWN;
                end
            end

            MOVING_UP: begin
                move_up = 1;
                if (current_floor < 3)
                    next_state = OPEN_DOOR;
            end

            MOVING_DOWN: begin
                move_down = 1;
                if (current_floor > 0)
                    next_state = OPEN_DOOR;
            end

            OPEN_DOOR: begin
                open_door = 1;
                next_state = WAIT_FOR_DOOR_CLOSE;
            end

            WAIT_FOR_DOOR_CLOSE: begin
                if (overload)
                    next_state = OVERLOAD_STATE;
                else if (door_closed)
                    next_state = IDLE;
            end

            OVERLOAD_STATE: begin
                open_door = 1;
                if (!overload && door_closed)
                    next_state = IDLE;
            end
        endcase
    end

    // Floor counter logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_floor <= 0;
        else if (move_up && current_floor < 3)
            current_floor <= current_floor + 1;
        else if (move_down && current_floor > 0)
            current_floor <= current_floor - 1;
    end
endmodule
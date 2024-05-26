`timescale 1ns/100ps

`define DEBUG_OUT 1'b1

module arbiterFSM(
        input clock, reset,
        input [2:0] request,
        output [2:0] grant
        `ifdef DEBUG_OUT
        , output [1 : 0] state_out
        `endif
    );
    // parameter definition for the four states, please do not modify
    parameter IDLE = 2'b00, GRANT_0 = 2'b01, GRANT_1 = 2'b10, GRANT_2 = 2'b11;
    logic [1:0] state;
    logic [1:0] state_next;
    
    `ifdef DEBUG_OUT
	assign state_out = state;
	`endif

    always_ff @(posedge clock, posedge reset) begin
        //////////////////////////////////////////////////////
        // TODO: Update the state here  
        if  (reset) begin
            state <= IDLE;
        end else begin             
        //////////////////////////////////////////////////////
            state <= state_next;
        end
    end
    
    always_comb begin
        //////////////////////////////////////////////////////
        // TODO: Calculate the next state here              //
        //////////////////////////////////////////////////////
        case (state)
            IDLE: begin
                if (request[0] == 1'b1 ) begin
                    state_next = GRANT_2;
                end else if (request[1] == 1'b1 && request[0] == 1'b0) begin
                    state_next = GRANT_1;
                end else if (request = 3'b001) begin
                    state_next = GRANT_0;
                end else begin
                    state_next = IDLE;
                end
            end
            GRANT_0: begin
                if (request[0] == 1'b1) begin
                    $display("here! request:%b, request[0]: %b",request, request[0]);
                    state_next = GRANT_2;
                end else if (request[1] == 1'b1 && request[0] == 1'b0) begin
                    state_next = GRANT_1;
                end else  begin
                    state_next = GRANT_0;
                end 
            end
            GRANT_1: begin
                if (request[2] == 1'b1) begin
                    state_next = GRANT_0;
                end else if (request[0] == 1'b1 && request[2] == 1'b0) begin
                    state_next = GRANT_2;
                end else begin
                    state_next = GRANT_1;
                end 
            end
            GRANT_2: begin
                if (request[2] == 1'b1 && request[1] == 1'b0) begin
                    state_next = GRANT_0;
                end else if (request[1] == 1'b1) begin
                    state_next = GRANT_1;
                end else  begin
                    state_next = GRANT_2;
                end
            end
    endcase

    end
    
    //////////////////////////////////////////////////////
    // TODO: Caculate the output (grant) here           //
    //////////////////////////////////////////////////////
    assign grant = (state==2'b11 ? 3'b100 : (state==2'b10 ? 3'b010 : (state==2'b01 ? 3'b001 : 3'b000))) & request;
    // assign grant[2] = (state == GRANT_0 && request[0] == 1'b1) ? 1'b1 : 1'b0;
    // assign grant[1] = (state == GRANT_1 && request[1] == 1'b1) ? 1'b1 : 1'b0;
    // assign grant[0] = (state == GRANT_2 && request[2] == 1'b1) ? 1'b1 : 1'b0;
endmodule

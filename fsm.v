//------------------------------------------------------------------------
// Finite State Machine
//------------------------------------------------------------------------

module fsm (
input sclk,
input cs,
input sout,
output reg miso_buff,
output reg dm_we,
output reg addr_we,
output reg sr_we
);
// state constants
parameter IDLE = 0;
parameter GETTING_ADDR_0 = 1;
parameter GETTING_ADDR_1 = 2;
parameter GETTING_ADDR_2 = 3;
parameter GETTING_ADDR_3 = 4;
parameter GETTING_ADDR_4 = 5;
parameter GETTING_ADDR_5 = 6;
parameter GETTING_ADDR_6 = 7;
parameter GOT_ADDR = 8;
parameter DATA_MASTER_0 = 10;
parameter DATA_MASTER_1 = 11;
parameter DATA_MASTER_2 = 12;
parameter DATA_MASTER_3 = 13;
parameter DATA_MASTER_4 = 14;
parameter DATA_MASTER_5 = 15;
parameter DATA_MASTER_6 = 16;
parameter DATA_MASTER_7 = 17;
parameter SAVE_TO_DM = 18;
parameter DATA_DM = 20;
parameter SAVE_TO_MASTER_0 = 21;
parameter SAVE_TO_MASTER_1 = 22;
parameter SAVE_TO_MASTER_2 = 23;
parameter SAVE_TO_MASTER_3 = 24;
parameter SAVE_TO_MASTER_4 = 25;
parameter SAVE_TO_MASTER_5 = 26;
parameter SAVE_TO_MASTER_6 = 27;
parameter SAVE_TO_MASTER_7 = 28;

// state variables
reg state;
reg next_state;

// assign next state
always @ (sout)
begin
  next_state = 0;
  case (state)
    IDLE : next_state = GETTING_ADDR_0
    GETTING_ADDR_0 : next_state = GETTING_ADDR_1
    GETTING_ADDR_1 : next_state = GETTING_ADDR_2
    GETTING_ADDR_2 : next_state = GETTING_ADDR_3
    GETTING_ADDR_3 : next_state = GETTING_ADDR_4
    GETTING_ADDR_4 : next_state = GETTING_ADDR_5
    GETTING_ADDR_5 : next_state = GETTING_ADDR_6
    GETTING_ADDR_6 : next_state = GOT_ADDR
    GOT_ADDR : if (sout=1) begin
                  next_state = DATA_MASTER_0
                end else begin
                  next_state = DATA_DM
                end

    DATA_MASTER_0 : next_state = DATA_MASTER_1
    DATA_MASTER_1 : next_state = DATA_MASTER_2
    DATA_MASTER_2 : next_state = DATA_MASTER_3
    DATA_MASTER_3 : next_state = DATA_MASTER_4
    DATA_MASTER_4 : next_state = DATA_MASTER_5
    DATA_MASTER_5 : next_state = DATA_MASTER_6
    DATA_MASTER_6 : next_state = DATA_MASTER_7
    DATA_MASTER_7 : next_state = SAVE_TO_DM
    SAVE_TO_DM : next_state = IDLE

    DATA_DM : next_state = SAVE_TO_MASTER_0
    SAVE_TO_MASTER_0 : next_state = SAVE_TO_MASTER_1
    SAVE_TO_MASTER_1 : next_state = SAVE_TO_MASTER_2
    SAVE_TO_MASTER_2 : next_state = SAVE_TO_MASTER_3
    SAVE_TO_MASTER_3 : next_state = SAVE_TO_MASTER_4
    SAVE_TO_MASTER_4 : next_state = SAVE_TO_MASTER_5
    SAVE_TO_MASTER_5 : next_state = SAVE_TO_MASTER_6
    SAVE_TO_MASTER_6 : next_state = SAVE_TO_MASTER_7
    SAVE_TO_MASTER_7 : next_state = IDLE
  endcase
end

// clk logic
always @ (posedge sclk)
begin
  if (cs==1) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

// map state to output
always @ (posedge sclk)
begin
  if (cs=1) begin
    miso_buff <= 0;
    dm_we <= 0;
    addr_we <= 0;
    sr_we <= 0;
  end
  else begin
    case(state)
      IDLE, GETTING_ADDR_0,
      GETTING_ADDR_1, GETTING_ADDR_2, GETTING_ADDR_3,
      GETTING_ADDR_4, GETTING_ADDR_5, GETTING_ADDR_6,
      DATA_MASTER_0, DATA_MASTER_1, DATA_MASTER_2,
      DATA_MASTER_3, DATA_MASTER_4, DATA_MASTER_5,
      DATA_MASTER_6, DATA_MASTER_7 :begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
      end
      GOT_ADDR: begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 1;
        sr_we <= 0;
      end
      SAVE_TO_DM: begin
        miso_buff <= 0;
        dm_we <= 1;
        addr_we <= 0;
        sr_we <= 0;
      end
      DATA_DM: begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 1;
      end
      SAVE_TO_MASTER_0, SAVE_TO_MASTER_1, SAVE_TO_MASTER_2,
      SAVE_TO_MASTER_3, SAVE_TO_MASTER_4, SAVE_TO_MASTER_5,
      SAVE_TO_MASTER_6, SAVE_TO_MASTER_7: begin
        miso_buff <= 1;
        dm_we <= 0;
        addr_we <= 0;
        sr<we <= 0;
      end
    endcase
  end
end

endmodule

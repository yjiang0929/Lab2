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
parameter IDLE = 5'd0;
parameter GETTING_ADDR_0 = 5'd1;
parameter GETTING_ADDR_1 = 5'd2;
parameter GETTING_ADDR_2 = 5'd3;
parameter GETTING_ADDR_3 = 5'd4;
parameter GETTING_ADDR_4 = 5'd5;
parameter GETTING_ADDR_5 = 5'd6;
parameter GETTING_ADDR_6 = 5'd7;
parameter GOT_ADDR = 5'd8;
parameter DATA_MASTER_0 = 5'd10;
parameter DATA_MASTER_1 = 5'd11;
parameter DATA_MASTER_2 = 5'd12;
parameter DATA_MASTER_3 = 5'd13;
parameter DATA_MASTER_4 = 5'd14;
parameter DATA_MASTER_5 = 5'd15;
parameter DATA_MASTER_6 = 5'd16;
parameter DATA_MASTER_7 = 5'd17;
parameter SAVE_TO_DM = 5'd18;
parameter DATA_DM = 5'd20;
parameter SAVE_TO_MASTER_0 = 5'd21;
parameter SAVE_TO_MASTER_1 = 5'd22;
parameter SAVE_TO_MASTER_2 = 5'd23;
parameter SAVE_TO_MASTER_3 = 5'd24;
parameter SAVE_TO_MASTER_4 = 5'd25;
parameter SAVE_TO_MASTER_5 = 5'd26;
parameter SAVE_TO_MASTER_6 = 5'd27;
parameter SAVE_TO_MASTER_7 = 5'd28;

// state variables
reg[4:0] state;

// map state to output
always @ (posedge sclk)
begin
  if (cs==1) begin
    state <= IDLE;
    miso_buff <= 0;
    dm_we <= 0;
    addr_we <= 0;
    sr_we <= 0;
  end
  else begin
    case(state)
      IDLE : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= GETTING_ADDR_0;
      end
      GETTING_ADDR_0 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= GETTING_ADDR_1;
      end
      GETTING_ADDR_1 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= GETTING_ADDR_2;
      end
      GETTING_ADDR_2 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= GETTING_ADDR_3;
      end
      GETTING_ADDR_3 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= GETTING_ADDR_4;
      end
      GETTING_ADDR_4 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= GETTING_ADDR_5;
      end
      GETTING_ADDR_5 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= GETTING_ADDR_6;
      end
      GETTING_ADDR_6 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= GOT_ADDR;
      end
      GOT_ADDR: begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 1;
        sr_we <= 0;
        if (sout==1) begin
          state <= DATA_DM;
        end else begin
          state <= DATA_MASTER_0;
        end
      end
      DATA_MASTER_0 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= DATA_MASTER_1;
      end
      DATA_MASTER_1 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= DATA_MASTER_2;
      end
      DATA_MASTER_2 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= DATA_MASTER_3;
      end
      DATA_MASTER_3 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= DATA_MASTER_4;
      end
      DATA_MASTER_4 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= DATA_MASTER_5;
      end
      DATA_MASTER_5 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= DATA_MASTER_6;
      end
      DATA_MASTER_6 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= DATA_MASTER_7;
      end
      DATA_MASTER_7 : begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= SAVE_TO_DM;
      end
      SAVE_TO_DM: begin
        miso_buff <= 0;
        dm_we <= 1;
        addr_we <= 0;
        sr_we <= 0;
        state <= IDLE;
      end
      DATA_DM: begin
        miso_buff <= 0;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 1;
        state <= SAVE_TO_MASTER_0;
      end
      SAVE_TO_MASTER_0 : begin
        miso_buff <= 1;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= SAVE_TO_MASTER_1;
      end
      SAVE_TO_MASTER_1 : begin
        miso_buff <= 1;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= SAVE_TO_MASTER_2;
      end
      SAVE_TO_MASTER_2 : begin
        miso_buff <= 1;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= SAVE_TO_MASTER_3;
      end
      SAVE_TO_MASTER_3 : begin
        miso_buff <= 1;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= SAVE_TO_MASTER_4;
      end
      SAVE_TO_MASTER_4 : begin
        miso_buff <= 1;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= SAVE_TO_MASTER_5;
      end
      SAVE_TO_MASTER_5 : begin
        miso_buff <= 1;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= SAVE_TO_MASTER_6;
      end
      SAVE_TO_MASTER_6 : begin
        miso_buff <= 1;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= SAVE_TO_MASTER_7;
      end
      SAVE_TO_MASTER_7 : begin
        miso_buff <= 1;
        dm_we <= 0;
        addr_we <= 0;
        sr_we <= 0;
        state <= IDLE;
      end
    endcase
  end
end

endmodule

module Timer (
  input wire clk,
  input wire rst,
  output reg timeout
);

  localparam clk_freq = 1000000; 

  localparam timeout_sec = 30;

  reg [31:0] count;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      count <= 0;
      timeout <= 0;
    end else begin
      if (count == clk_freq * timeout_sec) begin
        count <= 0;
        timeout <= 1; 
      end else begin
        count <= count + 1;
        timeout <= 0;
      end
    end
  end

endmodule

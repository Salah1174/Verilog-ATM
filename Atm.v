module atm (
    clk,
    rst,
    card,
    card_no,
    password,
    option,
    language,
    another_service,
    amount,
    invalid_password,
    no_balance,
    invalid_card,
    avalaible_balance
);

  input wire clk, rst, card;
  input wire [2:0] card_no;
  input wire [3:0] password;
  input wire [2:0] option;
  input wire [1:0] language;
  input wire [7:0] amount;
  input wire another_service;
  output reg [7:0] avalaible_balance;
  output reg invalid_password, invalid_card, no_balance;

  localparam English = 2'b00;
  localparam French = 2'b01;
  localparam German = 2'b10;
  localparam Italy = 2'b11;

  localparam default_state = 4'b0000;  //0
  localparam show_language = 4'b0001;  //1
  localparam request_pin = 4'b0010;  //2
  localparam show_main_menu_English = 4'b0100;  //4
  localparam show_balance = 4'b0111;  //7
  localparam withdraw_money = 4'b1000;  //8
  localparam deposit_money = 4'b1001;  //9
  localparam another_service_state = 4'b101;  //10
  localparam check_card = 4'b1011;  //11


  reg invalid_amount_flag;
  reg found;
  reg [3:0] current_state;
  reg [3:0] next_state;
  reg [1:0] index;
  reg [3:0] password_reg;
  reg [7:0] amount_reg;
  reg [3:0] accounts_password[9:0];
  reg [7:0] accounts_balances[9:0];


  initial begin
    avalaible_balance = 8'b00000000;
    accounts_password[0] = 4'b1111;
    accounts_password[1] = 4'b1110;
    accounts_password[2] = 4'b1101;
    accounts_password[3] = 4'b1100;
    accounts_balances[0] = 8'b00000110;
    accounts_balances[1] = 8'b01010101;
    accounts_balances[2] = 8'b01010101;
    accounts_balances[3] = 8'b01010101;
  end
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      current_state <= default_state;
    end else current_state <= next_state;
  end

  always @(*) begin
    case (current_state)
      default_state: begin
        invalid_password = 1'b1;
        invalid_card = 1'b1;
        no_balance = 1'b1;
        next_state = check_card;
      end

      check_card: begin
        if (card) begin
          if (card_no == 3'b000) begin
            invalid_card = 1'b0;
            next_state   = request_pin;
          end else if (card_no == 3'b001) begin
            invalid_card = 1'b0;
            next_state   = request_pin;
          end else if (card_no == 3'b010) begin
            invalid_card = 1'b0;
            next_state   = request_pin;
          end else if (card_no == 3'b011) begin
            invalid_card = 1'b0;
            next_state   = request_pin;
          end else begin
            invalid_card = 1'b1;
            next_state   = default_state;
          end
        end else next_state = default_state;
      end
      request_pin: begin
        if (invalid_card == 1'b0) begin
          if (password == accounts_password[card_no]) begin
            next_state = show_language;
            invalid_password = 1'b0;
          end else begin
            next_state = default_state;
            invalid_password = 1'b1;
          end
        end else begin
          next_state = default_state;
        end
      end
      show_language: begin
        begin
          if (language == English) begin
            next_state = show_main_menu_English;
          end else begin
            next_state = default_state;
          end
        end
      end
      show_main_menu_English: begin
        if (option == 3'b000) begin
          next_state = show_main_menu_English;
        end else if (option == 3'b001) begin
          next_state = deposit_money;
        end else if (option == 3'b010) begin
          next_state = withdraw_money;
        end else if (option == 3'b011) begin
          next_state = show_balance;
        end else begin
          next_state = show_main_menu_English;
        end
      end

      show_balance: begin
        avalaible_balance = accounts_balances[card_no];
        next_state = another_service_state;
      end
      deposit_money: begin
        accounts_balances[card_no] = accounts_balances[card_no] + amount;
        next_state = another_service_state;
      end
      withdraw_money: begin
        no_balance = 1'b1;
        if (amount > accounts_balances[card_no]) begin
          no_balance = 1'b0;
        end

        if (no_balance == 0) begin
          accounts_balances[card_no] = accounts_balances[card_no] - amount;
          next_state = another_service_state;
        end else begin
          next_state = default_state;
        end
      end
      another_service_state: begin
        if (another_service) begin
          next_state = show_main_menu_English;
        end else begin
          next_state = default_state;
        end
      end
    endcase
  end



endmodule

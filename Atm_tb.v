module tb_atm;

  reg clk_tb, rst_tb, card_tb;
  reg [2:0] card_no_tb;
  reg [3:0] password_tb;
  reg [3:0] option_tb;
  reg [1:0] language_tb;
  reg [7:0] amount_tb;
  reg another_service_tb;
  wire [7:0] avalaible_balance_tb;
  wire invalid_password_tb, invalid_card_tb, no_balance_tb;


  // Instantiate the ATM module
  atm uut (
      .clk(clk_tb),
      .card(card_tb),
      .rst(rst_tb),
      .card_no(card_no_tb),
      .password(password_tb),
      .option(option_tb),
      .language(language_tb),
      .amount(amount_tb),
      .another_service(another_service_tb),
      .avalaible_balance(avalaible_balance_tb),
      .invalid_password(invalid_password_tb),
      .invalid_card(invalid_card_tb),
      .no_balance(no_balance_tb)
  );

  integer i;
  // Clock generation
  initial begin
    clk_tb = 0;
    forever #1 clk_tb = ~clk_tb;
  end

  // Reset generation
  initial begin
    rst_tb = 1'b1;
    card_tb = 1'b0;
    card_no_tb = 2'b00;
    password_tb = 4'b0000;
    option_tb = 4'b1111;
    language_tb = 2'b00;
    amount_tb = 4'b00000000;
    another_service_tb = 1'b0;
    #10
    @(negedge clk_tb);


    // Test Case 1: Invalid Card Test
    rst_tb = 1'b0;
    card_tb = 1'b0;
    card_no_tb = 3'b000;
    password_tb = 4'b0000;
    option_tb = 3'b000;
    language_tb = 2'b00;
    amount_tb = 8'b00000000;
    another_service_tb = 1'b0;
    #10;

    // Test Case 2: Invalid PIN Test
    rst_tb = 1'b0;
    card_tb = 1'b1;
    card_no_tb = 3'b000;
    password_tb = 4'b1110;
    option_tb = 3'b000;
    language_tb = 2'b00;
    amount_tb = 8'b00000000;
    another_service_tb = 1'b0;
    #10;

    // Test Case 3: Valid PIN, Incorrect Language Test
    rst_tb = 1'b0;
    card_tb = 1'b1;
    card_no_tb = 3'b001;
    password_tb = 4'b1111;
    option_tb = 3'b000;
    language_tb = 2'b10;
    amount_tb = 8'b00000000;
    another_service_tb = 1'b0;
    #10;

    // Test Case 4: Valid PIN, Valid Language, Incorrect Option Test
    rst_tb = 1'b0;
    card_tb = 1'b1;
    card_no_tb = 3'b001;
    password_tb = 4'b1111;
    option_tb = 3'b100;
    language_tb = 2'b01;
    amount_tb = 8'b00000000;
    another_service_tb = 1'b0;
    #10;

    // Test Case 5: Show Balance Test
    rst_tb = 1'b0;
    card_tb = 1'b1;
    card_no_tb = 3'b010;
    password_tb = 4'b1101;
    option_tb = 3'b011;
    language_tb = 2'b01;
    amount_tb = 8'b00000000;
    another_service_tb = 1'b0;
    #10;

    // Test Case 6: Deposit Money Test
    rst_tb = 1'b0;
    card_tb = 1'b1;
    card_no_tb = 3'b001;
    password_tb = 4'b1110;
    option_tb = 3'b001;
    language_tb = 2'b00;
    amount_tb = 8'b00000100;
    another_service_tb = 1'b0;
    #10;

    // Test Case 7: Withdraw Money Test (with sufficient balance)
    rst_tb = 1'b0;
    card_tb = 1'b1;
    card_no_tb = 3'b010;
    password_tb = 4'b1101;
    option_tb = 3'b010;
    language_tb = 2'b01;
    amount_tb = 8'b00000001;
    another_service_tb = 1'b0;
    #10;

    // Test Case 8: Withdraw Money Test (insufficient balance)
    rst_tb = 1'b0;
    card_tb = 1'b1;
    card_no_tb = 3'b011;
    password_tb = 4'b1100;
    option_tb = 3'b010;
    language_tb = 2'b01;
    amount_tb = 8'b10000000;
    another_service_tb = 1'b0;
    #10;

    // Test Case 9: Another Service Test
    rst_tb = 1'b0;
    card_tb = 1'b1;
    card_no_tb = 3'b011;
    password_tb = 4'b1100;
    option_tb = 3'b011;
    language_tb = 2'b01;
    amount_tb = 8'b00000000;
    another_service_tb = 1'b1;
    #10;

    // Test Case 10: Invalid Card (Default State) Test
    rst_tb = 1'b0;
    card_tb = 1'b0;
    card_no_tb = 3'b100;
    password_tb = 4'b0000;
    option_tb = 3'b000;
    language_tb = 2'b00;
    amount_tb = 8'b00000000;
    another_service_tb = 1'b0;
    #10;
    for (i = 0; i < 1000; i = i + 1) begin
      card_tb = $random();
      card_no_tb = $random();
      password_tb = $random();
      option_tb = $random();
      language_tb = $random();
      amount_tb = $random();
      another_service_tb = $random();
      @(negedge clk_tb);
    end
    $stop();
  end


endmodule

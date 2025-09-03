module UART_tb ();

parameter DBIT = 8 ;           // no.of Data bits
parameter SB_TICK = 16 ;       // no.of Stop bit ticks

reg clk ,rstn;

//receiver ports
wire  [DBIT-1 : 0] r_data;
reg rd_uart;
wire rx_empty;
wire rx;

//Transmitter ports
reg [DBIT-1 : 0] w_data;
reg wr_uart;
wire tx_full;
wire tx;

//baud rate generator
reg [10:0] TIMER_FINAL_VALUE;

assign rx = tx;

//-----------------------------Clock Generation--------------------------
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

//---------------------------------Stimulus------------------------------
initial begin

    //initializing inputs
    rstn = 1'b0;
    rd_uart = 1'b0;
    w_data = 0;
    wr_uart = 1'b0;
    TIMER_FINAL_VALUE = 650;         //baud rate = 9600 bps


    //Testing reset signal
    repeat (3) @(negedge clk);
    rstn = 1'b1;


    //Writing data into the FIFO
    w_data = 8'hA5;
    repeat (2) @(negedge clk);
    wr_uart = 1'b1;
    @(negedge clk);
    wr_uart = 1'b0;

    // Wait for transmission to complete 
    repeat (110_000) @(negedge clk);

    //Reading the transmitted data 
    rd_uart = 1'b1;
    @(negedge clk);
    rd_uart = 1'b0;
    repeat (10) @(negedge clk);

    // Check received data
    if (r_data == 8'hA5)
        $display("Test Passed: Received data = %h", r_data);
    else
        $display("Test Failed: Received data = %h", r_data);
    
    $stop;
end


initial begin
    $monitor("Time=%0t tx=%b rx=%b wr_uart=%b rd_uart=%b r_data=%h", $time, tx, rx, wr_uart, rd_uart, r_data);
end

//-----------------------------Instantiation-----------------------------
UART #(.DBIT(DBIT) , .SB_TICK(SB_TICK)) dut (
    .clk(clk),
    .rstn(rstn),
    .r_data(r_data),
    .rd_uart(rd_uart),
    .rx_empty(rx_empty),
    .rx(rx),
    .w_data(w_data),
    .wr_uart(wr_uart),
    .tx_full(tx_full),
    .tx(tx),
    .TIMER_FINAL_VALUE(TIMER_FINAL_VALUE)
);


endmodule //UART_tb
module UART
    #(parameter DBIT = 8,           // no.of Data bits
                SB_TICK = 16        // no.of Stop bit ticks
    )
(
    input clk ,rstn,

    //receiver ports
    output [DBIT-1 : 0] r_data,
    input rd_uart,
    output rx_empty,
    input rx,

    //Transmitter ports
    input [DBIT-1 : 0] w_data,
    input wr_uart,
    output tx_full,
    output tx,

    //baud rate generator
    input [10:0] TIMER_FINAL_VALUE
);

/*========================================================================================
                                        Instantiations
=========================================================================================*/

//------------------------------Timer as baud rate generator------------------------------

wire tick;       //internal signal of the timer output

timer_input #(.N(11)) baud_rate_generator (
    .clk(clk),
    .rstn(rstn),
    .enable(1'b1),
    .FINAL_VALUE(TIMER_FINAL_VALUE),
    .done(tick)
    );


//--------------------------------------Receiver-------------------------------------------

wire [DBIT-1:0] rx_dout ;     //output data of the receiver
wire rx_done_tick;            //done counting signal of the receiver

uart_rx #( .DBIT(DBIT), .SB_TICK(SB_TICK)) receiver (
    .clk(clk),
    .rstn(rstn),
    .rx(rx),
    .s_tick(tick),
    .rx_dout(rx_dout),
    .rx_done_tick(rx_done_tick)
);


fifo_generator_0 rx_fifo (
  .clk(clk),      // input wire clk
  .srst(~rstn),    // input wire srst
  .din(rx_dout),      // input wire [7 : 0] din
  .wr_en(rx_done_tick),  // input wire wr_en
  .rd_en(rd_uart),  // input wire rd_en
  .dout(r_data),    // output wire [7 : 0] dout
  .full(),    // output wire full                   //assuming the receiving fifo isn't full
  .empty(rx_empty)  // output wire empty
);


//---------------------------------------Transmitter-----------------------------------------

wire tx_fifo_empty , tx_done_tick;  //internal signals between tx FIFO and transmitter
wire [DBIT-1 : 0] tx_din;          //output signal of tx FIFO

uart_tx #( .DBIT(DBIT), .SB_TICK(SB_TICK)) transmitter (
    .clk(clk),
    .rstn(rstn),
    .tx_start(~tx_fifo_empty),
    .s_tick(tick),
    .tx_din(tx_din),
    .tx(tx),
    .tx_done_tick(tx_done_tick)
);

fifo_generator_0 tx_fifo (
  .clk(clk),      // input wire clk
  .srst(~rstn),    // input wire srst
  .din(w_data),      // input wire [7 : 0] din
  .wr_en(wr_uart),  // input wire wr_en
  .rd_en(tx_done_tick),  // input wire rd_en
  .dout(tx_din),    // output wire [7 : 0] dout
  .full(tx_full),    // output wire full                   //assuming the receiving fifo isn't full
  .empty(tx_fifo_empty)  // output wire empty
);

endmodule //UART
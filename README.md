# UART (Universal Asynchronous Receiver/Transmitter) Verilog Project

This repository contains a complete Verilog implementation of a UART system, including transmitter, receiver, FIFO buffers, and a baud rate generator. The project is designed for simulation and FPGA prototyping, and includes a testbench for functional verification.

## Features

- **UART Transmitter (`uart_tx.v`)**  
  Implements a standard UART transmit finite state machine (FSM) with configurable data bits and stop bit ticks.

- **UART Receiver (`uart_rx.v`)**  
  Implements a standard UART receive FSM with configurable data bits and stop bit ticks.

- **FIFO Buffers**  
  Uses Xilinx's `fifo_generator` IP for transmit and receive buffering.

- **Baud Rate Generator (`timer_input.v`)**  
  Generates the baud rate tick signal for UART timing.

- **Top-Level UART Module (`UART.v`)**  
  Integrates transmitter, receiver, FIFOs, and baud rate generator.

- **Testbench (`UART_tb.v`)**  
  Provides stimulus and checks for simulation, including loopback testing.

## File Structure

- `uart_tx.v` — UART transmitter module
- `uart_rx.v` — UART receiver module
- `timer_input.v` — Baud rate generator (timer)
- `UART.v` — Top-level UART integration
- `UART_tb.v` — Testbench for simulation
- `fifo_generator_0` — FIFO buffer IP (not included; generate using Vivado or use behavioral model)

## How It Works

1. **Transmitter Side**
   - Data is written to the transmit FIFO.
   - When data is available, the transmitter reads from FIFO and serializes the data onto the `tx` line.

2. **Receiver Side**
   - Serial data on the `rx` line is deserialized by the receiver.
   - Received bytes are written to the receive FIFO for reading.

3. **Baud Rate Generator**
   - The timer generates a tick signal at the desired baud rate, controlling UART timing.

4. **Testbench**
   - Stimulates the UART by writing and reading data, and checks for correct loopback operation.

## Simulation

To simulate:
1. Make sure all Verilog files are included in your simulation project.
2. Provide a behavioral model for `fifo_generator_0` if not using Vivado IP.
3. Run the testbench (`UART_tb.v`) and observe the waveform for `tx`, `rx`, and data signals.

## Usage

- **FPGA Implementation:**  
  Replace `fifo_generator_0` with the appropriate Xilinx FIFO IP core.
- **Simulation:**  
  Use a behavioral FIFO model for simulation purposes.

## Parameters

- `DBIT` — Number of data bits (default: 8)
- `SB_TICK` — Number of stop bit ticks (default: 16)
- `TIMER_FINAL_VALUE` — Sets baud rate (e.g., 650 for 9600bps at 100MHz clock)

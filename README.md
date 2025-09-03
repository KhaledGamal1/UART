# UART Design with FIFO and Baud Rate Generator

This project implements a **Universal Asynchronous Receiver/Transmitter (UART)** in Verilog, with integrated **Baud Rate Generator**, **Transmitter and Receiver FSMs**, and **FIFO buffers** for reliable data handling.  

The design is parameterized, supports oversampling (16×), and is suitable for FPGA-based communication systems.

---

## 🚀 Features

- **Baud Rate Generator**
  - Generates tick signals based on system clock and target baud rate.
  - Uses oversampling (16 ticks per bit) for accurate data reception.
- **UART Receiver**
  - FSM with Idle, Start, Data, and Stop states.
  - Samples incoming bits at mid-points using oversampling.
  - Asserts `rx_done_tick` when a full byte is received.
- **UART Transmitter**
  - FSM with Idle, Start, Data, and Stop states.
  - Shifts out data bits at the correct baud rate.
  - Asserts `tx_done_tick` when transmission is complete.
- **FIFO Buffers**
  - Separate TX and RX FIFOs to handle data rate mismatches.
  - FWFT (First Word Fall Through) design for immediate data availability.
  - Provides `empty` and `full` flags.
- **Parameterizable**
  - System clock frequency (`f`)
  - Baud rate (`b`)
  - Data bit width (`DBIT`)
  - Stop bit ticks (`SB_TICK`)

---

## 📂 Repository Structure

```text
uart-design/
│── README.md              # Project overview
│── report/                
│   └── UART_Report.pdf    # Detailed project report
│── src/                   
│   ├── baud_gen.v         # Baud rate generator
│   ├── uart_rx.v          # UART receiver FSM
│   ├── uart_tx.v          # UART transmitter FSM
│   ├── fifo.v             # TX and RX FIFOs
│   └── uart_top.v         # Top-level integration
│── sim/
│   ├── uart_tb.v          # Loopback testbench
│   └── waves/             # Waveform outputs / screenshots
│── docs/
│   ├── diagrams/          # FSM state diagrams, block diagrams
│   └── notes.md           # Design notes and derivations

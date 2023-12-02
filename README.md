# Verilog-RS232
implement RS232 with Verilog and use loopback to test it.

## project structure
- "doc": the information for each module (see .md)

- "rtl": the implementation of all modules (see .v)

- "sim": all testbenches of each module

***

## RS232
![rs232_module](https://github.com/KaihaoYuHW/Verilog-RS232/blob/main/doc/rs232_module.png)

The RS232 transmitter uart_tx receives parallel data pi_data[7:0] from the PC, converts it into serial data, and transmits it through the tx line. The transmission occurs bit by bit, from the least significant bit to the most significant bit. On the receiving end, the RS232 receiver uart_rx receives the serial data through the rx line, bit by bit from the least significant bit to the most significant bit. Subsequently, the received serial data is converted into parallel data po_data[7:0], which is then sent to the FPGA.
## frame structure
![rs232_frame_structure](https://github.com/KaihaoYuHW/Verilog-RS232/blob/main/doc/rs232_frame_structure.bmp)

The transmission and reception of serial data are based on a frame structure, meaning data is sent and received frame by frame. Each frame consists of 8 bits of actual data in the middle, and it is mandatory to have a start bit at the beginning of each frame, fixed at 0. At the end of each frame, there must also be a stop bit, fixed at 1. Thus, the most basic frame structure (excluding parity checks, etc.) comprises 10 bits. When there is no data transmission or reception, both the rx and tx lines are in an idle state, maintaining a high voltage level. If a data frame is being transmitted, it begins with a start bit, which is continuously transmitted for (1/bit rate) seconds. Following this, there are 8 bits of data, with each bit's signal lasting 1/(bit rate) seconds. Subsequently, there is a 1-bit stop bit, also lasting 1/(bit rate) seconds. After this, the rx and tx lines return to an idle state, waiting the next data transmission.
## loopback test
![rs232_loopback](https://github.com/KaihaoYuHW/Verilog-RS232/blob/main/doc/rs232_loopback.png)

Connect the transmitter uart_tx and receiver uart_rx in a closed-loop circuit to verify if the data transmission meets the requirements.

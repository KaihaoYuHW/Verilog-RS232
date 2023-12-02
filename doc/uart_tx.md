# uart_tx

## module diagram

![](https://github.com/KaihaoYuHW/Verilog-RS232/blob/main/doc/uart_tx_module.png)

## signals

|     name     | width(bit) |   type   |                           function                           |
| :----------: | :--------: | :------: | :----------------------------------------------------------: |
|   sys_clk    |     1      |  input   |                            50Mhz                             |
|  sys_rst_n   |     1      |  input   |                            reset                             |
|   pi_data    |     8      |  input   |                   receive 8 bits one time                    |
| pi_data_flag |     1      |  input   |          As 8 bits are stable, send a pulse signal.          |
|      tx      |     1      |  output  |              send 1 bit data per 1/(bit rate) s              |
|   work_en    |     1      | internal | As pi_data_flag=1 makes work_en=1, begin to send bit from pi_data. As bit_flag=1 and bit_cnt=9 make work_en=0, end sending bit |
|   band_cnt   |     13     | internal |                counting 0~5207 is 1 bit time                 |
|   bit_flag   |     1      | internal |      As count to 1, send a pulse signal to send a bit.       |
|   bit_cnt    |     4      | internal |         count 0 to 9 to number the bits I have sent.         |

## waveform

![](https://github.com/KaihaoYuHW/Verilog-RS232/blob/main/doc/uart_tx_waveform.bmp)

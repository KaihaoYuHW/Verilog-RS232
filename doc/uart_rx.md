# uart_rx

## module diagram

![](https://github.com/KaihaoYuHW/Verilog-RS232/blob/main/doc/uart_rx_module.png)

## signals

|     name     | width(bit) |   type   |                           function                           |
| :----------: | :--------: | :------: | :----------------------------------------------------------: |
|   sys_clk    |     1      |  input   |                            50Mhz                             |
|  sys_rst_n   |     1      |  input   |                            reset                             |
|      rx      |     1      |  input   |            receive 1 bit data per 1/(bit rate) s             |
|   po_data    |     8      |  output  |                     send 8 bits one time                     |
| po_data_flag |     1      |  output  |          As 8 bits are stable, send a pulse signal.          |
|   rx_reg2    |     1      | internal |      delay 2 clk cycles to figure out metastable state       |
|   rx_reg3    |     1      | internal |               to find negative edge of rx_reg3               |
|  nedge_flag  |     1      | internal |   As find a negative edge of rx_reg3, send a pulse signal.   |
|   work_en    |     1      | internal | As nedge_flag makes work_en=1, begin to take bit from rx. As bit_flag=1 and bit_cnt=8 make work_en = 0, end taking bit from rx. |
|   band_cnt   |     13     | internal |                counting 0~5207 is 1 bit time                 |
|   bit_flag   |     1      | internal |  As count to 2603, send a pulse signal to take a bit value   |
|   bit_cnt    |     1      | internal |        count 0 to 9 to number the bits I have taken.         |
|   rx_data    |     8      | internal |                 serial data -> parallel data                 |
| rx_data_flag |     1      | internal |            finish converting, send a pulse signal            |

## waveform

![](https://github.com/KaihaoYuHW/Verilog-RS232/blob/main/doc/uart_rx_waveform.bmp)


/*
Copyright (c) 2019 Alibaba Group Holding Limited

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
module PAD_DIG_IO(
    OEN,
    IEN,
    OD,
    ID,
    PAD
);

input   OEN; //assign had_pad_jtg_tms_oe = A18565;
input   IEN; 
output  ID;
input   OD;  //assign had_pad_jtg_tms_o = A13c;
inout   PAD;  

assign ID = IEN ? 1'bz : PAD;
assign PAD = OEN ? 1'bz : OD;

endmodule

//若cpu指示cpu_padmux_jtg_tms_o输出信号有效，则会将cpu_padmux_jtg_tms_oen信号拉低，PAD选中OD
//信号，也即cpu将cpu_padmux_jtg_tms_o信号送至调试接口

//若cpu指示cpu_padmux_jtg_tms_o输出信号无效，则会将cpu_padmux_jtg_tms_oen信号拉高，PAD选中高阻态
//信号，也即调试接口会作为输入接口接收padmux发过来的tms_i信号

//ien==1'b1, cpu->pad
//ien==1'b0, pad-->cpu? 
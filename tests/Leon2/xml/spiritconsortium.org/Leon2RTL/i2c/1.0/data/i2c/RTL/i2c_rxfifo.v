// 
// Revision:    $Revision: 1506 $
// Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
// 
// Copyright (c) 2005, 2006, 2007, 2008, 2009 The SPIRIT Consortium.
// 
// This work forms part of a deliverable of The SPIRIT Consortium.
// 
// Use of these materials are governed by the legal terms and conditions
// outlined in the disclaimer available from www.spiritconsortium.org.
// 
// This source file is provided on an AS IS basis.  The SPIRIT
// Consortium disclaims any warranty express or implied including
// any warranty of merchantability and fitness for use for a
// particular purpose.
// 
// The user of the source file shall indemnify and hold The SPIRIT
// Consortium and its members harmless from any damages or liability.
// Users are requested to provide feedback to The SPIRIT Consortium
// using either mailto:feedback@lists.spiritconsortium.org or the forms at 
// http://www.spiritconsortium.org/about/contact_us/
// 
// This file may be copied, and distributed, with or without
// modifications; this notice must be included on any copy.


`timescale 1ns/100ps

module i2c_rxfifo (
                    wr_clk,
                    wr_n,
                    rd_clk,
                    rd_n,
                    rst_an,
                    di,
                    full,
                    empty,
                    do);


 

   input        wr_clk;  // FIFO write clock
   input        wr_n;  // FIFO Write enable
   input        rd_clk;  // FIFO read clock
   input        rd_n;  // FIFO Read enable
   input        rst_an;  // FIFO Asynchronous Reset
   input  [7:0] di;  // FIFO Data input
   output       full;  // FIFO Full flag
   output       empty;  // FIFO Empty flag
   output [7:0] do;  // FIFO Data output bus


// DEFINE THE PHYSICAL PARAMETERS OF THE RAM

   parameter FIFO_DEPTH = 4,
             FIFO_WIDTH = 8,
             FIFO_ADDR_BITS  = 2;

// DEFINE INTERNAL VARIABLES
   wire we_int;                              // Internal write signal 
   wire re_int;                              // Internal read signal 
   reg fl,mt;                                // Internal full and empty flags
   wire [FIFO_ADDR_BITS:0]   read_ptr;       // Read pointer
   wire [FIFO_ADDR_BITS:0]   read_ptr_conv;  // Read pointer convered to new format
   wire [FIFO_ADDR_BITS:0]   read_ptr_wr1_conv;   // Read pointer sync to wr_clk last register 
   wire [FIFO_ADDR_BITS:0]   write_ptr;      // Write pointer
   wire [FIFO_ADDR_BITS:0]   write_ptr_conv; // Write pointer convered to new format
   wire [FIFO_WIDTH-1:0]     ramout;         // Output RAM data        
   reg [FIFO_WIDTH-1:0]      ram_data[FIFO_DEPTH-1:0];  // RAM Data
   wire  [FIFO_WIDTH-1:0]     dataout;        // Read data output

   reg [FIFO_ADDR_BITS:0]    read_ptr_wr1;   // Read pointer sync to wr_clk last register
   reg [FIFO_ADDR_BITS:0]    write_ptr_rd1;  // Write pointer sync to rd_clk last register


// Read pointer GRAY code counter
   i2c_rxfifo_gray grayrd (
                          .clk(rd_clk),      // Clock Input
                          .cdn(rst_an),    // Clear Input
                          .cen(re_int),    // Count Enable Input
                          .q(read_ptr));    // Result
// Write pointer GRAY code counter
   i2c_rxfifo_gray graywr (
                          .clk(wr_clk),      // Clock Input
                          .cdn(rst_an),    // Clear Input
                          .cen(we_int),    // Count Enable Input
                          .q(write_ptr));   // Result


// Assign outputs and interal signals
assign ramout = ram_data[read_ptr_conv[FIFO_ADDR_BITS-1:0]];

assign we_int = ~(wr_n | fl );
assign re_int = ~(rd_n | mt);
assign full = fl;
assign empty = mt;
assign do = dataout;
assign write_ptr_conv = {~write_ptr[FIFO_ADDR_BITS],
                         (write_ptr[FIFO_ADDR_BITS] == 1'b1)?
                           ~write_ptr[FIFO_ADDR_BITS-1]:write_ptr[FIFO_ADDR_BITS-1],
                          write_ptr[FIFO_ADDR_BITS-2:0]};
assign read_ptr_conv  = {~read_ptr[FIFO_ADDR_BITS],
                        (read_ptr[FIFO_ADDR_BITS] == 1'b1)?
                           ~read_ptr[FIFO_ADDR_BITS-1]:read_ptr[FIFO_ADDR_BITS-1],
                         read_ptr[FIFO_ADDR_BITS-2:0]};
assign read_ptr_wr1_conv  = {~read_ptr_wr1[FIFO_ADDR_BITS],
                        (read_ptr_wr1[FIFO_ADDR_BITS] == 1'b1)?
                           ~read_ptr_wr1[FIFO_ADDR_BITS-1]:read_ptr_wr1[FIFO_ADDR_BITS-1],
                         read_ptr_wr1[FIFO_ADDR_BITS-2:0]};


// -----------------------------------------------------------------------------
// Generate EMPTY and FULL flags
// -----------------------------------------------------------------------------
always @(read_ptr or write_ptr or write_ptr_rd1 or write_ptr_conv or read_ptr_wr1 or read_ptr_wr1_conv)
begin
  if (read_ptr == write_ptr_rd1)
    mt <= 1'b1;
  else
    mt <= 1'b0;

  if (write_ptr[FIFO_ADDR_BITS] == read_ptr_wr1[FIFO_ADDR_BITS])
    fl <= 1'b0;
  else if (write_ptr[FIFO_ADDR_BITS] == 1'b1 && write_ptr_conv == read_ptr_wr1)
    fl <= 1'b1;
  else if (read_ptr_wr1[FIFO_ADDR_BITS] == 1'b1 && write_ptr == read_ptr_wr1_conv)
    fl <= 1'b1;
  else
    fl <= 1'b0;
end


// -----------------------------------------------------------------------------
// Sync Read pointer to Write Clock
// -----------------------------------------------------------------------------
always @(posedge wr_clk or negedge rst_an)
begin
  if (rst_an == 1'b0)
  begin
    read_ptr_wr1 <= 'h0;
  end
  else 
  begin
    read_ptr_wr1 <= read_ptr;
  end
end

// -----------------------------------------------------------------------------
// Sync Write pointer to Read Clock
// -----------------------------------------------------------------------------
always @(posedge rd_clk or negedge rst_an)
begin
  if (rst_an == 1'b0)
  begin
    write_ptr_rd1 <= 'h0;
  end
  else 
  begin
    write_ptr_rd1 <= write_ptr;
  end
end


// -----------------------------------------------------------------------------
// FIFO RAM write
// -----------------------------------------------------------------------------
always @(posedge wr_clk)
begin
  if (fl == 1'b0)
  begin
    ram_data[write_ptr_conv[FIFO_ADDR_BITS-1:0]] <= di;
  end
end

// -----------------------------------------------------------------------------
// Read output no latch control
// -----------------------------------------------------------------------------
assign dataout = ramout;


endmodule 


// Gray code counter
module i2c_rxfifo_gray (
                         clk,
                         cdn,
                         cen,
                         q);


   input        clk;
   input        cdn;
   input        cen;
   output [2:0] q;


   parameter areset_value = 3'b000;
   wire [2:0] a;
   reg [2:0] s;
   reg ci;
   reg [2:0] d2;
   reg [2:0] d1;
   reg [2:0] d0;
   reg [2:0] qv;

   reg [2:0] av;
   reg [2:0] L;
   reg [2:0] N;
   reg [2:0] R;
   reg [2:0] Z;

   integer i;

   always @(a)
   begin
     av[1:0] = a[1:0];
     av[2] = a[2];
   end

   always @(av)
   begin
     L[2] = 1'b1;
     for (i=1; i>-1; i=i-1)
     begin
       L[i] = av[i+1] ^ L[i+1];
     end

     N[0] = 1'b1;
     for (i=1; i<3; i=i+1)
     begin
       N[i] = ~(av[i-1]) & N[i-1];
     end

     R[0] = 1'b1;
     for (i=1; i<2; i=i+1)
     begin
       R[i] = av[i-1] & N[i-1];
     end
     R[2] = (~(av[2]) & av[1] & N[1]) | (N[2] & av[2]);

     Z[0] = L[0];
     for (i=1; i<2; i=i+1)
     begin
       Z[i] = av[i] ^ (R[i] & L[i-1]);
     end
     Z[2] = av[2] ^ R[2];

   end


   always @(Z)
   begin
     s[1:0] = Z[1:0];
     s[2] = Z[2];
   end

   always @(s)
   begin
     d2 = s;
   end

   always @(d2 or cen or a)
   begin
     d1 = (cen === 1'b1) ? d2 : a;
     ci = cen;
   end

   always @(d1)
   begin
     d0 = d1;
   end


   always @(posedge clk or negedge cdn)
   begin
     if(cdn === 1'b0)
        qv <= areset_value;
     else
        qv <= d0;
   end


   assign a = qv;
   assign q = qv;


endmodule 



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
// modifications; but this notice must be included on any copy.

 /*------------------------------------------------------------------------------
 * Simple TLM processor
 * Note:  this is a dummy implementation of a Leon2 processor. 
 * One should read this model as a simple testbench generator.
 *------------------------------------------------------------------------------*/

#ifndef _PROCESSOR_H_
#define _PROCESSOR_H_

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include <systemc.h>
#include <string.h>

#include "pv_slave_base.h"
#include "pv_target_port.h"
#include "pv_initiator_port.h"
#include "user_types.h"

/*------------------------------------------------------------------------------
 * Define device parameters (for APB slave)
 *----------------------------------------------------------------------------*/
#define PROC_BASE_ADDR                0x0000 // in global systems, start at: 0x30006000
#define PROC_SIZE                     0x1000 // 4Kb
/*------------------------------------------------------------------------------
 * Define device parameters (for local memory)
 *----------------------------------------------------------------------------*/
#define PROC_LOCALMEMORY_BASE_ADDR    0x10000000
#define PROC_LOCALMEMORY_SIZE         0x1000 // 4Kb

//#define LOCALMEMORYADDR 0x10000000
//#define LOCALMEMORYBITS 4  // number of address bits
//#define LOCALMEMORYSIZE 16 // number of memory locations
/*------------------------------------------------------------------------------
 * testbench processor
 *----------------------------------------------------------------------------*/

// the processor class
class processor : 
public sc_module,
  public pv_slave_base< ADDRESS_TYPE , DATA_TYPE >
{
 public:
  SC_HAS_PROCESS( processor );
  processor( sc_module_name module_name , char* tb_file_name);
  ~processor();
  
  // ports
  pv_target_port<ADDRESS_TYPE,DATA_TYPE>    apb_slave_port;
  pv_initiator_port<ADDRESS_TYPE,DATA_TYPE> ahb_master_port;
  sc_in<sc_logic>            clk;
  sc_in<bool>                rst_an;
  sc_in<int>                 irl_port;
  sc_out<int>                irqvec_port;
  sc_out<bool>               intack_port;

  // APB slave
  tlm::tlm_status write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			 const unsigned int byte_enable = tlm::NO_BE,
			 const tlm::tlm_mode mode = tlm::REGULAR,
			 const unsigned int export_id = 0 );
  tlm::tlm_status read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			const unsigned int byte_enable = tlm::NO_BE,
			const tlm::tlm_mode mode = tlm::REGULAR,
			const unsigned int export_id = 0 );
  
 private:
  void ahbMaster();
  void restart();
  void catch_it();
  void read_testbench_file(const char* fileName);
  void end_of_elaboration();
  void init_local_memory();
  
  typedef enum {READ, WRITE, IDLE, COMMENT, END} cmd_t;
  typedef struct {
    cmd_t cmd;
    char  cmdname;
    unsigned long  addr;
    unsigned int   idle;
    unsigned long  data;
    unsigned long  mask;
    char* comment;
  } tb_cmd_t;
  
  sc_pvector<DATA_TYPE> local_memory;
  sc_pvector<DATA_TYPE> apb_memory;
  sc_pvector<tb_cmd_t> tbData_;
  int numTbCmds_;
  int cmdIndex_;
  bool enableInterrupt_;
};
  
  
#endif  /* _PROCESSOR_H_ */

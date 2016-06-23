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


// uart_fifo.h

#ifndef H_UART_FIFO
#define H_UART_FIFO

//***************************
//*		Includes			*
//***************************
#include "systemc.h"	// For 'sc_module'

//***********************************
//*		UART FIFO Module Class		*
//***********************************
template <class DT>		// Template for the Data Type of the fifo
class UART_FIFO : public sc_module {
	public:
		//**** Constructor ****//
		UART_FIFO<DT>(sc_module_name N, int pSize) :  sc_module(N) {
			fifo = new std::queue<DT>;		// Create a new queue object
			Size = pSize;
			TriggerLevel = 1;
			CurrentLevel = 0;
		};
		//**** Destructor ****//
		~UART_FIFO() { delete fifo;	};
		
		// Function for writing data to the fifo
		void write(DT WriteData) {
			if (CurrentLevel < Size) {
				cout << sc_time_stamp() << ": " << name() << ": Writing to FIFO: " << WriteData;
				fifo->push(WriteData);
				CurrentLevel++;
				cout << " (New FIFO Level = " << CurrentLevel << ")" << endl;
			}
		};
		// Function for reading data from the fifo
		DT read() {
			if (CurrentLevel > 0) {
				DT ReturnData;
				ReturnData = fifo->front();
				fifo->pop();
				CurrentLevel--;
				cout << sc_time_stamp() << ": " << name() << ": Reading from FIFO: " << ReturnData << " (New FIFO Level = " << CurrentLevel << ")" << endl;
				return ReturnData;
			}
			return 0;
		};
		// Function for setting a new trigger level
		void SetTriggerLevel(int level) {
			if (level == 0)
				TriggerLevel = 1;		// Minimum Trigger level = 1
			if (level > Size-2)
				TriggerLevel = Size-2;	// Maximum Trigger level = Size - 2
			else
				TriggerLevel = level;
			cout << sc_time_stamp() << ": " << name() << ": Trigger Level set to: " << TriggerLevel << endl;
		};
		// Function that returns 1 if FIFO is empty
		bool IsEmpty() {
			return (CurrentLevel == 0);
		};
		// Function that returns 1 if FIFO is full
		bool IsFull() {
			return (CurrentLevel == Size);
		};
		// Function that returns 1 if FIFO is above (or at) the trigger level
		bool IsAboveTriggerLevel() {
			if (CurrentLevel >= TriggerLevel)
				return true;
			else
				return false;
		};
		// Function that returns 1 if FIFO is below the trigger level
		bool IsBelowTriggerLevel() {
			if (CurrentLevel < TriggerLevel)
				return true;
			else
				return false;
		};
	private:
		int Size;				// The size of the FIFO
		int TriggerLevel;		// Trigger Level of the FIFO
		int CurrentLevel;		// This variable indicates how many elements are currently in the FIFO
		std::queue<DT> * fifo;	// Pointer to the FIFO queue
};

#endif //H_UART_FIFO

//copyright (c) The SPIRIT Consortium.  All rights reserved.
//www.spiritconsortium.org
// 
//THIS WORK FORMS PART OF A SPIRIT CONSORTIUM SPECIFICATION.
//USE OF THESE MATERIALS ARE GOVERNED BY
//THE LEGAL TERMS AND CONDITIONS OUTLINED IN THE SPIRIT
//SPECIFICATION DISCLAIMER AVAILABLE FROM
//www.spiritconsortium.org
// 
//This source file is provided on an AS IS basis. The SPIRIT Consortium disclaims 
//ANY WARRANTY EXPRESS OR IMPLIED INCLUDING ANY WARRANTY OF
//MERCHANTABILITY AND FITNESS FOR USE FOR A PARTICULAR PURPOSE. 
//The user of the source file shall indemnify and hold The SPIRIT Consortium harmless
//from any damages or liability arising out of the use thereof or the performance or
//implementation or partial implementation of the schema.


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

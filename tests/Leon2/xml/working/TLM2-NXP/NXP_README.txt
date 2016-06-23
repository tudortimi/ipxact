NXP TLM Validation.

The files
- Leon2Platform.cc
- Leon2Platform.h
- apbSubSystem.cc
- apbSubSystem.h
are generated automatically.

In Leon2Platform.h these lines have been added manually:

sc_signal < sc_logic > clkdiv1;
sc_signal < sc_logic > clkdiv2;
sc_signal < sc_logic > clkdiv3;
sc_signal < sc_logic > clkdiv4;
sc_signal < sc_logic > clkdiv5;
sc_signal < sc_logic > clkdiv6;
sc_signal < sc_logic > clkdiv7;

sc_signal < bool > rstdiv1;
sc_signal < bool > rstdiv2;
sc_signal < bool > rstdiv3;
sc_signal < bool > rstdiv4;
sc_signal < bool > rstdiv5;
sc_signal < bool > rstdiv6;
sc_signal < bool > rstdiv7;

In Leon2Platform.cc these lines have been added manually:

i_cgu.clkout[1](clkdiv1); 
i_cgu.clkout[2](clkdiv2); 
i_cgu.clkout[3](clkdiv3); 
i_cgu.clkout[4](clkdiv4); 
i_cgu.clkout[5](clkdiv5); 
i_cgu.clkout[6](clkdiv6); 
i_cgu.clkout[7](clkdiv7); 

i_rgu.rstout_an[1](rstdiv1); 
i_rgu.rstout_an[2](rstdiv2); 
i_rgu.rstout_an[3](rstdiv3); 
i_rgu.rstout_an[4](rstdiv4); 
i_rgu.rstout_an[5](rstdiv5); 
i_rgu.rstout_an[6](rstdiv6); 
i_rgu.rstout_an[7](rstdiv7); 


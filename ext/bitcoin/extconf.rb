require 'mkmf'  

$CXXFLAGS += " -std=c++11 "

have_library 'bitcoin'
have_library 'boost_system'

create_makefile 'bitcoin/bitcoin'

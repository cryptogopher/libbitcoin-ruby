require 'mkmf'  

$CXXFLAGS += " -std=c++11 "

find_executable('make')

have_library('bitcoin')
have_library('boost_system')

create_makefile('libbitcoin/wallet', 'libbitcoin')


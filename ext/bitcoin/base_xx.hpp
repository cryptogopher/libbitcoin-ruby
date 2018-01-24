#include "bitcoin/bitcoin/formats/base_10.hpp"
#include "ruby.h"

namespace libbitcoin{
VALUE decode_base10(const std::string& amount, uint8_t decimal_places=0, bool strict=true);
}

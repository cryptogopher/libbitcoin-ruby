#include "base_xx.hpp"

namespace libbitcoin {
VALUE decode_base10(const std::string& amount, uint8_t decimal_places, bool strict) {
  VALUE result = Qnil;
  uint64_t out;
  if (decode_base10(out, amount, decimal_places, strict))
    result = ULONG2NUM(out);
  return result;
}
}

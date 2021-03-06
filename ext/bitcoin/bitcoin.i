// All naming trying to be consistent with Ruby style guide
// https://github.com/bbatsov/ruby-style-guide#naming
//
// Currently only ascii-8bit encoding supported

%module bitcoin
//%include std_container.i
%include std_string.i
//%include std_map.i
%include typemaps.i
//%naturalvar;

%{
#include "bitcoin/bitcoin/compat.hpp"
#include "bitcoin/bitcoin/constants.hpp"
#include "bitcoin/bitcoin/define.hpp"
#include "bitcoin/bitcoin/error.hpp"
#include "bitcoin/bitcoin/handlers.hpp"
#include "bitcoin/bitcoin/version.hpp"

#include "bitcoin/bitcoin/formats/base_10.hpp"
#include "bitcoin/bitcoin/formats/base_16.hpp"
#include "bitcoin/bitcoin/formats/base_58.hpp"
#include "bitcoin/bitcoin/formats/base_64.hpp"
#include "bitcoin/bitcoin/formats/base_85.hpp"
#include "base_xx.hpp"

#include "bitcoin/bitcoin/wallet/uri.hpp"
#include "bitcoin/bitcoin/wallet/uri_reader.hpp"
#include "bitcoin/bitcoin/wallet/ec_public.hpp"
#include "bitcoin/bitcoin/wallet/ec_private.hpp"
#include "bitcoin/bitcoin/wallet/payment_address.hpp"
#include "bitcoin/bitcoin/wallet/stealth_address.hpp"
#include "bitcoin/bitcoin/wallet/bitcoin_uri.hpp"
#include "bitcoin/bitcoin/wallet/dictionary.hpp"
#include "bitcoin/bitcoin/wallet/encrypted_keys.hpp"
#include "bitcoin/bitcoin/wallet/ek_private.hpp"
#include "bitcoin/bitcoin/wallet/ek_public.hpp"
#include "bitcoin/bitcoin/wallet/ek_token.hpp"
#include "bitcoin/bitcoin/wallet/hd_public.hpp"
#include "bitcoin/bitcoin/wallet/hd_private.hpp"
#include "bitcoin/bitcoin/wallet/message.hpp"
#include "bitcoin/bitcoin/wallet/mini_keys.hpp"
#include "bitcoin/bitcoin/wallet/mnemonic.hpp"
#include "bitcoin/bitcoin/wallet/qrcode.hpp"
#include "bitcoin/bitcoin/wallet/select_outputs.hpp"
#include "bitcoin/bitcoin/wallet/stealth_receiver.hpp"
#include "bitcoin/bitcoin/wallet/stealth_sender.hpp"

using namespace libbitcoin;
%}


// operator!=: Ruby parses the expression a != b as !(a == b)
// libbitcoin does the same
%warnfilter(SWIGWARN_IGNORE_OPERATOR_NOTEQUAL_MSG) operator!=;
// operator=: different semantics in Ruby than C++, not overloadable
// Ruby only assigns new name to an object, no copying/constructing
%warnfilter(SWIGWARN_IGNORE_OPERATOR_EQ_MSG) operator=;
// operator<< and operator>>: cannot see any reasonable use right now
%warnfilter(503) operator<<;
%warnfilter(503) operator>>;

%include error.i

// Create additional method in place of C++ type converters
//%rename("equal?") operator=
%rename("valid?") operator const bool;
%rename("ec_secret") operator const ec_secret&;
%rename("ec_compressed") operator const ec_compressed&;
%rename("encrypted_private") operator const encrypted_private&;
%rename("encrypted_public") operator const encrypted_public&;
%rename("encrypted_token") operator const encrypted_token&;
%rename("short_hash") operator const short_hash&;
%rename("data_chunk") operator const data_chunk;

// Friend
%ignore libbitcoin::wallet::swap(hd_private& left, hd_private& right);

// Unimplemented as of libbitcoin 3.4.0
%ignore libbitcoin::wallet::ec_public::version() const;
%ignore libbitcoin::wallet::ec_public::payment_version() const;
%ignore libbitcoin::wallet::ec_public::wif_version() const;

// Temporarily ignore until issue resolved (found in libbitcoin 3.4.0)
// https://github.com/libbitcoin/libbitcoin/issues/885
%ignore libbitcoin::wallet::create_token(encrypted_token&, const std::string&, const ek_entropy&);
%ignore libbitcoin::wallet::create_token(encrypted_token&, const std::string&, const ek_salt&, uint32_t, uint32_t);

// data_slice passed by value without default constructor
%feature("valuewrapper") data_slice;
class data_slice;

// Hints for SWIG to treat these types as primitives.
// Required for returning by value instead of pointer to object.
typedef long int64_t;
typedef unsigned long uint64_t;

// typemaps: hash <-> std::map
// http://www.swig.org/Doc3.0/Ruby.html#Ruby_nn52
// https://github.com/ruby/ruby/blob/trunk/doc/extension.rdoc
// https://silverhammermba.github.io/emberb/c/
// http://www.cplusplus.com/reference/map/map/insert/
%typemap(in) std::map<std::string,std::string>&, const std::map<std::string,std::string>&
{
  Check_Type($input, T_HASH);
  std::map<std::string,std::string> *map = new std::map<std::string,std::string>;
  VALUE keys = rb_funcall($input, rb_intern("keys"), 0);
  long len = RARRAY_LEN(keys);
  for (long i = 0; i < len; i++) {
    VALUE key = rb_ary_entry(keys, i);
    VALUE keyS = rb_funcall(key, rb_intern("to_s"), 0);
    VALUE valS = rb_funcall(rb_hash_aref($input, key), rb_intern("to_s"), 0);
    map ->insert(
      std::pair<std::string,std::string>(
        std::string(StringValueCStr(keyS)),
        std::string(StringValueCStr(valS))
    ));
  }
  $1 = map;
}
%typemap(freearg) std::map<std::string,std::string>&,
  const %std::map<std::string,std::string>&
{
  delete $1;
}
%typemap(out) std::map<std::string,std::string>&, const std::map<std::string,std::string>& {
  VALUE hash = rb_hash_new();
  std::map<std::string,std::string>::iterator i = $1->begin(), iend = $1->end();
  for ( ; i!=iend; i++ )
    rb_hash_aset(hash,
      rb_str_new_cstr((*i).first.c_str()),
      rb_str_new_cstr((*i).second.c_str())
    );
  $result = hash;
}
%typemap(out) std::map<std::string,std::string>, const std::map<std::string,std::string> {
  VALUE hash = rb_hash_new();
  std::map<std::string,std::string>::iterator i = $1.begin(), iend = $1.end();
  for ( ; i!=iend; i++ )
    rb_hash_aset(hash,
      rb_str_new_cstr((*i).first.c_str()),
      rb_str_new_cstr((*i).second.c_str())
    );
  $result = hash;
}

// Wrapping template static functions does not seem to work in SWIG
// https://stackoverflow.com/questions/25663216/cant-wrap-a-template-static-function-with-swig
//%template(parse) libbitcoin::wallet::uri_reader::parse<libbitcoin::wallet::bitcoin_uri>;
%extend libbitcoin::wallet::uri_reader {
  static libbitcoin::wallet::bitcoin_uri parse(const std::string& uri, bool strict=true) {
    return
      libbitcoin::wallet::uri_reader::parse<libbitcoin::wallet::bitcoin_uri>(uri, strict);
  }
};

// Give classes/constants more ruby names
%rename ("BitcoinURI") libbitcoin::wallet::bitcoin_uri;
%rename ("URI") libbitcoin::wallet::uri;
%rename ("URIReader") libbitcoin::wallet::uri_reader;
%rename ("ECPrivate") libbitcoin::wallet::ec_private;
%rename ("ECPublic") libbitcoin::wallet::ec_public;
%rename ("EKPrivate") libbitcoin::wallet::ek_private;
%rename ("EKPublic") libbitcoin::wallet::ek_public;
%rename ("EKToken") libbitcoin::wallet::ek_token;
%rename ("HDLineage") libbitcoin::wallet::hd_lineage;
%rename ("HDPublic") libbitcoin::wallet::hd_public;
%rename ("HDPrivate") libbitcoin::wallet::hd_private;
%rename ("PaymentAddress") libbitcoin::wallet::payment_address;
%rename ("WrappedData") libbitcoin::wallet::wrapped_data;
%rename ("SelectOutputs") libbitcoin::wallet::select_outputs;
%rename ("StealthAddress") libbitcoin::wallet::stealth_address;
%rename ("StealthReceiver") libbitcoin::wallet::stealth_receiver;
%rename ("StealthSender") libbitcoin::wallet::stealth_sender;

%rename ("LOT_SEQUENCE_KEY") libbitcoin::wallet::lot_sequence_key;
%rename ("EC_COMPRESSED_KEY") libbitcoin::wallet::ec_compressed_key;
%rename ("EC_NON_MULTIPLIED_LOW") libbitcoin::wallet::ec_non_multiplied_low;
%rename ("EC_NON_MULTIPLIED_HIGH") libbitcoin::wallet::ec_non_multiplied_high;
%rename ("EC_NON_MULTIPLIED") libbitcoin::wallet::ec_non_multiplied;

%rename ("ALGORITHM") libbitcoin::wallet::select_outputs::algorithm;
%rename ("GREEDY") libbitcoin::wallet::select_outputs::algorithm::greedy;
%rename ("INDIVIDUAL") libbitcoin::wallet::select_outputs::algorithm::individual;


%include "bitcoin/bitcoin/compat.hpp"
%include "bitcoin/bitcoin/constants.hpp"
%include "bitcoin/bitcoin/define.hpp"
%include "bitcoin/bitcoin/error.hpp"
%include "bitcoin/bitcoin/handlers.hpp"
%include "bitcoin/bitcoin/version.hpp"

// Ignore and rewrite functions returning output in arguments (uint64_t& out)
%ignore libbitcoin::decode_base10(uint64_t&, const std::string&, uint8_t=0, bool=true);
%include "bitcoin/bitcoin/formats/base_10.hpp"
%include "bitcoin/bitcoin/formats/base_16.hpp"
// base58.hpp is unparsable for SWIG
// (base_58.hpp:45: Error: Syntax error in input(1))
BC_API bool is_base58(const char ch);
BC_API bool is_base58(const std::string& text);
BC_API std::string encode_base58(data_slice unencoded);
BC_API bool decode_base58(data_chunk& out, const std::string& in);

%include "bitcoin/bitcoin/formats/base_64.hpp"
%include "bitcoin/bitcoin/formats/base_85.hpp"
%include "base_xx.hpp"

%include "bitcoin/bitcoin/wallet/uri.hpp"
%include "bitcoin/bitcoin/wallet/uri_reader.hpp"
%include "bitcoin/bitcoin/wallet/ec_public.hpp"
%include "bitcoin/bitcoin/wallet/ec_private.hpp"
%include "bitcoin/bitcoin/wallet/payment_address.hpp"
%include "bitcoin/bitcoin/wallet/stealth_address.hpp"
%include "bitcoin/bitcoin/wallet/bitcoin_uri.hpp"
%include "bitcoin/bitcoin/wallet/dictionary.hpp"
%include "bitcoin/bitcoin/wallet/encrypted_keys.hpp"
%include "bitcoin/bitcoin/wallet/ek_private.hpp"
%include "bitcoin/bitcoin/wallet/ek_public.hpp"
%include "bitcoin/bitcoin/wallet/ek_token.hpp"
%include "bitcoin/bitcoin/wallet/hd_public.hpp"
%include "bitcoin/bitcoin/wallet/hd_private.hpp"
%include "bitcoin/bitcoin/wallet/message.hpp"
%include "bitcoin/bitcoin/wallet/mini_keys.hpp"
%include "bitcoin/bitcoin/wallet/mnemonic.hpp"
%include "bitcoin/bitcoin/wallet/qrcode.hpp"
%include "bitcoin/bitcoin/wallet/select_outputs.hpp"
%include "bitcoin/bitcoin/wallet/stealth_receiver.hpp"
%include "bitcoin/bitcoin/wallet/stealth_sender.hpp"


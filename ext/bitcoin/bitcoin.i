// All naming trying to be consistent with Ruby style guide
// https://github.com/bbatsov/ruby-style-guide#naming

%module bitcoin
%include std_string.i

%{
#include "bitcoin/bitcoin/compat.hpp"
#include "bitcoin/bitcoin/constants.hpp"
#include "bitcoin/bitcoin/define.hpp"
#include "bitcoin/bitcoin/error.hpp"
#include "bitcoin/bitcoin/handlers.hpp"
#include "bitcoin/bitcoin/version.hpp"

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

// typemap for converting: Fixnum/Bignum -> uint64_t
%typemap(in) uint64_t {
  $1 = NUM2ULONG($input);
}
%typemap(typecheck, precedence=SWIG_TYPECHECK_UINT64) uint64_t {
  $1 = FIXNUM_P($input) ? 1 : 0;
}

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


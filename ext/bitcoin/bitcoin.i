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
#include "bitcoin/bitcoin/wallet/payment_address.hpp"
#include "bitcoin/bitcoin/wallet/bitcoin_uri.hpp"
#include "bitcoin/bitcoin/wallet/dictionary.hpp"
#include "bitcoin/bitcoin/wallet/ec_private.hpp"
#include "bitcoin/bitcoin/wallet/ec_public.hpp"
#include "bitcoin/bitcoin/wallet/ek_private.hpp"
#include "bitcoin/bitcoin/wallet/ek_public.hpp"
#include "bitcoin/bitcoin/wallet/ek_token.hpp"
#include "bitcoin/bitcoin/wallet/encrypted_keys.hpp"
#include "bitcoin/bitcoin/wallet/hd_public.hpp"
#include "bitcoin/bitcoin/wallet/hd_private.hpp"
#include "bitcoin/bitcoin/wallet/message.hpp"
#include "bitcoin/bitcoin/wallet/mini_keys.hpp"
#include "bitcoin/bitcoin/wallet/mnemonic.hpp"
#include "bitcoin/bitcoin/wallet/qrcode.hpp"
#include "bitcoin/bitcoin/wallet/select_outputs.hpp"
#include "bitcoin/bitcoin/wallet/stealth_address.hpp"
#include "bitcoin/bitcoin/wallet/stealth_receiver.hpp"
#include "bitcoin/bitcoin/wallet/stealth_sender.hpp"

using namespace libbitcoin;
using namespace libbitcoin::wallet;
%}

// Ruby parses the expression a != b as !(a == b)
// libbitcoin does the same
%warnfilter(SWIGWARN_IGNORE_OPERATOR_NOTEQUAL_MSG) operator!=;
%warnfilter(SWIGWARN_IGNORE_OPERATOR_EQ_MSG) operator=;
%warnfilter(503) operator<<;
%warnfilter(503) operator>>;
//%warnfilter(801); //lowercase name

// give classes/constants nicer names
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

%rename("valid?") operator const bool;
%rename("ec_secret") operator const ec_secret&;
%rename("ec_compressed") operator const ec_compressed&;
%rename("encrypted_private") operator const encrypted_private&;
%rename("encrypted_public") operator const encrypted_public&;
%rename("encrypted_token") operator const encrypted_token&;
%rename("short_hash") operator const short_hash&;
%rename("data_chunk") operator const data_chunk;
%rename("data_chunk") operator const data_chunk;

// friend
%ignore libbitcoin::wallet::swap(hd_private& left, hd_private& right);

// unimplemented
%ignore libbitcoin::wallet::ec_public::version() const;
%ignore libbitcoin::wallet::ec_public::payment_version() const;
%ignore libbitcoin::wallet::ec_public::wif_version() const;

// temporarily ignore until issue resolved
// https://github.com/libbitcoin/libbitcoin/issues/885
%ignore libbitcoin::wallet::create_token(encrypted_token&, const std::string&, const ek_entropy&);
%ignore libbitcoin::wallet::create_token(encrypted_token&, const std::string&, const ek_salt&, uint32_t, uint32_t);

// data_slice passed by value without default constructor
%feature("valuewrapper") data_slice;
class data_slice;

%include "bitcoin/bitcoin/compat.hpp"
%include "bitcoin/bitcoin/constants.hpp"
%include "bitcoin/bitcoin/define.hpp"
%include "bitcoin/bitcoin/error.hpp"
%include "bitcoin/bitcoin/handlers.hpp"
%include "bitcoin/bitcoin/version.hpp"

%include "bitcoin/bitcoin/wallet/uri.hpp"
%include "bitcoin/bitcoin/wallet/uri_reader.hpp"
%include "bitcoin/bitcoin/wallet/bitcoin_uri.hpp"
%include "bitcoin/bitcoin/wallet/dictionary.hpp"
%include "bitcoin/bitcoin/wallet/ec_private.hpp"
%include "bitcoin/bitcoin/wallet/ec_public.hpp"
%include "bitcoin/bitcoin/wallet/ek_private.hpp"
%include "bitcoin/bitcoin/wallet/ek_public.hpp"
%include "bitcoin/bitcoin/wallet/ek_token.hpp"
%include "bitcoin/bitcoin/wallet/encrypted_keys.hpp"
%include "bitcoin/bitcoin/wallet/hd_public.hpp"
%include "bitcoin/bitcoin/wallet/hd_private.hpp"
%include "bitcoin/bitcoin/wallet/message.hpp"
%include "bitcoin/bitcoin/wallet/mini_keys.hpp"
%include "bitcoin/bitcoin/wallet/mnemonic.hpp"
%include "bitcoin/bitcoin/wallet/payment_address.hpp"
%include "bitcoin/bitcoin/wallet/qrcode.hpp"
%include "bitcoin/bitcoin/wallet/select_outputs.hpp"
%include "bitcoin/bitcoin/wallet/stealth_address.hpp"
%include "bitcoin/bitcoin/wallet/stealth_receiver.hpp"
%include "bitcoin/bitcoin/wallet/stealth_sender.hpp"


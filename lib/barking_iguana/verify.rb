module BarkingIguana
  module Verify
    autoload :Signature,          'barking_iguana/verify/signature'
    autoload :SignedAction,       'barking_iguana/verify/signed_action'
    autoload :SignableAction,     'barking_iguana/verify/signable_action'

    autoload :SignatureException, 'barking_iguana/verify/exceptions'
    autoload :WindowTooLarge,     'barking_iguana/verify/exceptions'
    autoload :SignatureExpired,   'barking_iguana/verify/exceptions'
    autoload :FarFutureExpiry,    'barking_iguana/verify/exceptions'
    autoload :TokenMismatch,      'barking_iguana/verify/exceptions'

    autoload :VERSION,            'barking_iguana/verify/version'
  end
end

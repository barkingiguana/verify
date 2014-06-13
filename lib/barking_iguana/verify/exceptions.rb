module BarkingIguana
  module Verify
    SignatureException = Class.new(StandardError)
    WindowTooLarge     = Class.new(SignatureException)
    SignatureExpired   = Class.new(SignatureException)
    FarFutureExpiry    = Class.new(SignatureException)
    TokenMismatch      = Class.new(SignatureException)
  end
end

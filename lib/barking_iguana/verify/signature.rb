require 'openssl'
require 'base64'

module BarkingIguana
  module Verify
    class Signature
      MAXIMUM_VALIDITY = 3600

      attr_accessor :public_key
      private :public_key=

      attr_accessor :action
      private :action=, :action

      attr_accessor :secret
      private :secret=, :secret

      attr_accessor :expires_at
      private :expires_at=, :expires_at

      attr_accessor :signed_at
      private :signed_at=, :signed_at

      def initialize public_key, action, secret, expires_at, signed_at = nil
	self.public_key = public_key
	self.action     = action
	self.secret     = secret
	self.expires_at = expires_at
	self.signed_at  = signed_at
      end

      SEPARATOR = '--'.freeze
      DIGEST = 'sha256'.freeze

      # Get an ASCII representation of this signature
      def to_s
        signed = (signed_at || Time.now).to_i.to_s
	expires = expires_at.to_i.to_s
	signature = "#{public_key}#{expires}#{signed}#{action}"
	token = OpenSSL::HMAC.hexdigest DIGEST, secret, signature
	encoded_token = Base64.encode64(token)
	encoded_token.gsub! /\n/, ''
	params = [ encoded_token, public_key, expires, signed ].join SEPARATOR
	Base64.encode64(params).gsub(/\n/, '')
      end

      def inspect
        s = "#<#{self.class.name}: @public_key=#{public_key.inspect}, @action=#{action.inspect}, @secret=(hidden), @expires_at=#{expires_at.inspect}"
        unless signed_at.nil?
          s += ", @signed_at=#{signed_at.inspect}"
        end
        s + '>'
      end

      # Verify that a signature is valid, not expired, and not for an insanely
      # far future date.
      def self.verify ascii, action, secret, now = Time.now
	this_second = Time.at now.to_i
	params = Base64.decode64 ascii
	_, public_key, expires, signed = params.split /#{SEPARATOR}/, 4
	expires_at = Time.at expires.to_i
        signed_at = Time.at signed.to_i
        raise WindowTooLarge.new "Time between now and expiry is more than #{MAXIMUM_VALIDITY}" if expires_at - signed_at > MAXIMUM_VALIDITY
	raise SignatureExpired.new "#{expires_at} vs #{this_second}" if this_second > expires_at
	raise FarFutureExpiry.new "#{expires} vs #{this_second + MAXIMUM_VALIDITY}" if expires_at > this_second + MAXIMUM_VALIDITY
	expected_signature = Signature.new public_key, action, secret,
	  expires_at, signed_at
	raise TokenMismatch.new "#{expected_signature.to_s} vs #{ascii}" if expected_signature.to_s != ascii
      end
    end
  end
end

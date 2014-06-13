require 'addressable/uri'

module BarkingIguana
  module Verify
    class SignableAction
      attr_accessor :verb
      private :verb=, :verb

      attr_accessor :path
      private :path=, :path

      attr_accessor :params
      private :params=, :params

      def initialize verb, path, params = {}
	self.verb = verb
	self.path = path
	self.params = params
      end

      def add key, value
	params[key] = value
      end

      def ordered_params
	# Ruby has ordered hashes, but I want alphabetical order
	params.keys.sort_by(&:to_s).inject({}) { |a, e|
	  a.merge! e => params[e]
	}
      end
      private :ordered_params

      def query_string
	return '' unless params.any?
	'?' + URI.encode_www_form(ordered_params)
      end

      def unsigned_path
	Addressable::URI.parse "#{path}#{query_string}"
      end

      def to_s
	"#{verb} #{unsigned_path}"
      end

      def sign public_key, secret, expires_at
        signature = Signature.new public_key, self, secret, expires_at
        SignedAction.new self, signature
      end

      def verify! signature, secret
        Signature.verify signature, self, secret
      end

      def verify? signature, secret
        verify! signature, secret
        true
      rescue SignatureException
        false
      end

      def inspect
	"#<BarkingIguana::Verify::SignableAction #{to_s.inspect}>"
      end
    end
  end
end

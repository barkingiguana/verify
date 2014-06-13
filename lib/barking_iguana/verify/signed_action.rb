module BarkingIguana
  module Verify
    class SignedAction
      PARAMETER_SIGNATURE  = 'verify_signature'.freeze
      PARAMETER_PUBLIC_KEY = 'verify_public_key'.freeze

      attr_accessor :action
      private :action=, :action

      attr_accessor :signature
      private :signature=, :signature

      def initialize action, signature
        self.action = action
        self.signature = signature
      end

      def signed_path
        path = action.unsigned_path
        q = path.query_values
        q[PARAMETER_SIGNATURE]  = signature.to_s
        q[PARAMETER_PUBLIC_KEY] = signature.public_key.to_s
        path.query_values = q
        path
      end

      def inspect
        "#<#{self.class.name}: @signed_path=#{signed_path.inspect}, @signature=#{signature.inspect}>"
      end
    end
  end
end

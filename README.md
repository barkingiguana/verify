# BarkingIguana::Verify

Verify that a remote caller is who they say they are.

Don't send passwords or API keys over the wire. That's risky.

Make sure replay attacks have a very limited window in case someone has
listened in to the HTTP conversation somehow.

## Installation

Add this line to your application's Gemfile:

    gem 'barking_iguana-verify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install barking_iguana-verify

## Usage

### Client

```ruby
require 'barking_iguana/verify'

# Anyone can know your username, this isn't protected data
my_username = 'craigw'
# Only you and the remote service know the API key, this should NOT be
# transmitted in-band.
my_api_key = '123456-1234-1234-123456'
# Express an intent to send an HTTP DELETE to /resource/123 with a confirm
# parameter
intent = BarkingIguana::Verify::SignableAction.new 'DELETE', '/resource/123', confirm: true
# Sign the action so the remote service can know this request was made by
# us. Let the remote service know how long you're going to take to do this.
time_i_will_perform_this_delete_by = Time.at 1402665888
action = intent.sign my_username, my_api_key, time_i_will_perform_this_delete_by
# Perform the delete
RestClient.delete "https://example.com#{action.signed_path}"
```

### Server

```ruby
require 'barking_iguana/verify'

username = params[BarkingIguana::Verify::SignedAction::PARAMETER_PUBLIC_KEY]
# It's up to you to implement the ApiKey part.
api_key = ApiKey.find_by_username username
signature = params[BarkingIguana::Verify::SignedAction::PARAMETER_SIGNATURE]
expected_intent = BarkingIguana::Verify::SignableAction.new 'DELETE', "/resource/#{params['id']}", confirm: true

if expected_intent.verify? signature, api_key.token
  Resource.delete params['id']
else
  raise NotAuthorized
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/barking_iguana-verify/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

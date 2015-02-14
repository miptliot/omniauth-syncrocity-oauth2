# OmniAuth Syncrocity OAuth2 Strategy

Strategy to authenticate with Syncrocity via OAuth2 in OmniAuth.

## Installation

Add to your `Gemfile`:

```ruby
gem "omniauth-syncrocity-oauth2"
```

Then `bundle install`.

## Usage

Here's an example for adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :syncrocity_oauth2, ENV["SYNCROCITY_CLIENT_ID"], ENV["SYNCROCITY_CLIENT_SECRET"], ENV["SYNCROCITY_URL"]
end
```

You can now access the OmniAuth SyncroCity OAuth2 URL: `/auth/syncrocity_oauth2`

For more examples please check out `examples/omni_auth.rb`

## Build Status
[![Build Status](https://travis-ci.org/zquestz/omniauth-syncrocity-oauth2.png)](https://travis-ci.org/zquestz/omniauth-syncrocity-oauth2)


## License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

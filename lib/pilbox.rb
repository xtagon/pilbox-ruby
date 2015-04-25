require "pilbox/version"

require "cgi"
require "openssl"
require "uri"

module Pilbox
  def self.thumb_uri(base_uri, params = {})
    # Accept a URI, or a string representing what the URI should be. This
    # can simple be used as the base host URI.
    uri = base_uri.is_a?(URI) ? base_uri.dup : URI.parse(base_uri)

    if params.empty?
      return uri
    end

    params = if params.is_a?(Hash)
      params.dup
    else
      # CGI.parse results in key/value pairs where the value is an *array*
      # of values, possibly more than one. We only care about the first, if
      # there is more than one.
      CGI.parse(params.to_s).reduce({}) do |hash, (key, value)|
        hash.merge(key => value.first)
      end
    end

    # Normalize param keys to strings
    params = params.reduce({}) do |hash, (key, value)|
      hash.merge(key.to_s => value)
    end

    # Client Key is supposed to be a secret...don't let it be merged into
    # the URI's query params directly.
    client_key = params.delete("client_key")

    original_params = CGI.parse(uri.query || "")
    uri.query = URI.encode_www_form(original_params.merge(params))

    if client_key
      signature = generate_signature(client_key, uri.query)
      uri.query << "&" << URI.encode_www_form({"sig" => signature})
    end

    return uri
  end

  private

  def self.generate_signature(client_key, query_string)
    OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha1"),
      client_key, query_string
    )
  end
end

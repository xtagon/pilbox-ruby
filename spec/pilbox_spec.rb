require "spec_helper"

describe Pilbox do
  it "has a version number" do
    expect(Pilbox::VERSION).not_to be nil
  end

  describe ".thumb_uri" do
    context "given no params" do
      it "returns an unaltered base URI" do
        # Try both HTTP and HTTPS, with and without an embedded query string.
        example_uris = [
          "https://thumb.example.org",
          "http://thumb.example.org?url=http%3A%2F%2Fwww.example.com%2Fimage.png&w=250"
        ]

        # Try passing each example URI both as a string and as a URI object.
        example_uris.each do |example_uri|
          string_base_uri_result = Pilbox.thumb_uri(example_uri)
          base_uri_result = Pilbox.thumb_uri(URI.parse(example_uri))

          [string_base_uri_result, base_uri_result].each do |result|
            expect(result).to be_a(URI)
            expect(result.to_s).to eq(example_uri)
          end
        end
      end
    end

    context "given valid params" do
      it "includes the given params in the result" do
        base_uri = "http://thumb.example.org"

        # Make some of the keys strings and some of them symbols, to ensure
        # both are treated the same. Likewise, use both strings and integers
        # as values.
        #
        # Params passed may be a query string or a hash, and they should be
        # treated the same.
        hash_params = {"url" => "http://www.example.com/image.jpg", w: 250, h: "80"}
        string_params = "url=http://www.example.com/image.jpg&w=250&h=80"

        hash_result = Pilbox.thumb_uri(base_uri, hash_params)
        string_result = Pilbox.thumb_uri(base_uri, string_params)

        [hash_result, string_result].each do |result|
          expect(result).to be_a(URI)
          expect(result.to_s).to eq("http://thumb.example.org?url=http%3A%2F%2Fwww.example.com%2Fimage.jpg&w=250&h=80")
        end

        expect(hash_result).to eq(string_result)
      end
    end

    context "given the client_key param" do
      it "generates a signature and adds it to the result's query string" do
        params = {url: "http://www.example.com/image.jpg", w: 250, client_key: "EXAMPLE-CLIENT-KEY"}

        result = Pilbox.thumb_uri("http://thumb.example.org", params)
        expect(result).to be_a(URI)
        expect(result.to_s).to eq("http://thumb.example.org?url=http%3A%2F%2Fwww.example.com%2Fimage.jpg&w=250&sig=5d43a9da6f014d5a8fdf0414392812e033c24d59")
      end
    end

    context "given both resize and rotate operations" do
      # `op=resize,rotate` works, but `op=resize%2Crotate` does not.
      it "encodes the query string correctly" do
        params = {url: "http://www.example.com/image.jpg", w: 250, op: "resize,rotate", deg: "auto"}

        result = Pilbox.thumb_uri("http://thumb.example.org", params)
        expect(result).to be_a(URI)
        expect(result.to_s).to eq("http://thumb.example.org?url=http%3A%2F%2Fwww.example.com%2Fimage.jpg&w=250&op=resize,rotate&deg=auto")
      end
    end
  end
end

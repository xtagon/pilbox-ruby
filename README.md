Pilbox Ruby Gem
===============

This is a Ruby utility for generating request URLs for [Pilbox][0], the image resizing service. This library was made for my personal use and is not affiliated with the Pilbox project.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem "pilbox"
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install pilbox
```

Usage
-----

It's quite straightfoward: simply call `Pilbox.thumb_uri(base_uri, params)`, where the `base_uri` is a string or `URI` pointing to the Pilbox server endpoint, and `params` contains the query params to be passed to the Pilbox request.

Basic example, generating a thumbnail with a width of 50:

```ruby
Pilbox.thumb_uri("https://mypilboxserver.example.com", "url" => "https://example.org/funnykittens.jpg", "w" => 50)
```

You will get back a URI suitable for generating a thumbnail on Pilbox. For flexibility, the result will be a `URI` object, which you can easily turn into a string by calling `#to_s` on it.

You should always pass at least the `"url"` param. If you pass a `client_key` param to `Pilbox#thumb_uri`, a secure signature (compatible with Pilbox) will be generated and added to the resulting URI. The `client_key` param won't be added to the HTTP request, it will remain secret. All other params will pass through to Pilbox. For more information on available params, refer to the documentation on the [Pilbox][0] project.

The following is a more complete example, which will return a signed URI ready to send as a secure Pilbox request:

```ruby
base_uri = ENV["PILBOX_HOST"] # e.g. https://mypilboxserver.example.com
thumb_params = {
  url: "http://www.example.org/happypanda.png",
  op: "rotate,resize",
  w: 150,
  h: 150,
  deg: "auto",
  client_name: ENV["PILBOX_CLIENY_NAME"],
  client_key: ENV["PILBOX_CLIENT_KEY"]
}
puts Pilbox.thumb_uri(base_uri, thumb_params).to_s
```

If you have an existing URI that already includes Pilbox parameters, and you just want to add the proper signature, you can do that too:

```ruby
unsigned_url = "http://mypilboxserver.example.org?url=http%3A%2F%2Fwww.example.com%2Fimage.jpg&w=250&h=80"
signed_url = Pilbox.thumb_uri(unsigned_url, client_name: "...", client_key: "...").to_s
```

Care has been taken to make this utility as simple to use as possible. If it behaves unexpectedly for you, please report it on the [issue tracker](https://github.com/xtagon/pilbox-ruby/issues).

Author
------

[Justin Workman](mailto:xtagon@gmail.com)

Happy hacking!


[0]: https://github.com/agschwender/pilbox

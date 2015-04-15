require "httpclient"

module QueryParams
  def self.stringify(hash)
    hash.map { |k,v|
      "#{URI.encode_www_form_component(k.to_s)}=#{URI.encode_www_form_component(v.to_s)}"
    }.join('&')
  end
end

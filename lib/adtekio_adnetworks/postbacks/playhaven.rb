class AdtekioAdnetworks::Postbacks::Playhaven < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:hmac,:token]
  end

  define_postback_for :ios, :mac do
    { :url => "https://partner-api-ssl.playhaven.com/v4/advertiser/open",
      :params => :compute_params
    }
  end

  def compute_params
    nonce = SecureRandom.hex
    hmac = OpenSSL::HMAC.new(netcfg.hmac.to_s, "sha1")
    hmac.update([event.adid, netcfg.token, nonce].compact.join(":"))

    sig4 = (Base64.encode64(hmac.digest).gsub(/(=|==)$/,"").gsub("+","-").
            gsub("/","_").chomp)

    { :token         => netcfg.token,
      :tracking      => event.adid.nil? ? "0" : "1",
      :nonce         => nonce.to_s,
      :ph_conversion => 1,
      :sig4          => sig4.to_s
    }.tap do |hsh|
      hsh.merge!(:ifa => event.adid) unless event.adid.nil?
    end
  end
end

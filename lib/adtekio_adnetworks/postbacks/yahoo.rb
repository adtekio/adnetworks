class AdtekioAdnetworks::Postbacks::Yahoo < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "https://beap.gemini.yahoo.com:443/pixel",
      :params => {
        :ai => "@{event.appleid}@",
        :mi => "@{event.adid}@",
        :id => "@{params[:click]}@",
        :pc => "@{params[:partner_data]}@"
      },
      :check => "event.country == 'US'"
    }
  end

end

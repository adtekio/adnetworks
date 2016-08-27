class AdtekioAdnetworks::Postbacks::CyberagentAmeba < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://kickback.amanad.adtdp.com/kickback",
      :params => {
        :token_id => "@{params[:click]}@"
      },

    }
  end

end

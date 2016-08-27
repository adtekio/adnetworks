class AdtekioAdnetworks::Postbacks::Loopme < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://track.loopme.me/install",
      :params => {
        :ad_delivery_token => "@{params[:partner_data]}@"
      },

    }
  end

end

class AdtekioAdnetworks::Postbacks::Misterbell < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://api.misterbell.com/conversion/tracking.json/",
      :params => {
        :campid => "@{params[:partner_data]}@",
        :clicid => "@{params[:click]}@"
      },

    }
  end

end

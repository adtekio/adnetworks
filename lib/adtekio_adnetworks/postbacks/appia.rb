class AdtekioAdnetworks::Postbacks::Appia < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "https://ads.appia.com/installAd.jsp",
      :params => {
        :bundleId => "@{params[:partner_data]}@",
        :referrer => "@{params[:click]}@"
      },

    }
  end

end

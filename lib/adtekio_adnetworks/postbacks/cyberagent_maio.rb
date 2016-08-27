class AdtekioAdnetworks::Postbacks::CyberagentMaio < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "https://deliverlog-api.maio.jp:443/api/log_conversion",
      :params => {
        :amid => "@{params[:partner_data]}@",
        :ctid => "@{params[:click]}@"
      },

    }
  end

end

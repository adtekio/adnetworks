class AdtekioAdnetworks::Postbacks::CyberagentSmartc < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://action.smart-c.jp/@{params[:click]}@/@{event.adid}@/@{params[:partner_data]}@",
      :params => {

      },
      :check => "!event.adid.blank?"
    }
  end

end

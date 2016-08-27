class AdtekioAdnetworks::Postbacks::Aarki < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://postback.aarki.net/pbn/install",
      :params => {
        :app_id   => "@{params[:partner_data]}@",
        :click_id => "@{params[:click]}@"
      },
    }
  end

end

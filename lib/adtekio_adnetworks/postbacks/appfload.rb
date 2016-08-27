class AdtekioAdnetworks::Postbacks::Appfload < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://partner.appflood.com/receive_from_lite",
      :params => {
        :click_id => "@{params[:click]}@"
      },

    }
  end

end

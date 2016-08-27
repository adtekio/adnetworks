class AdtekioAdnetworks::Postbacks::Cheetah < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://ws.mobpartner.com/v2/ws.php",
      :params => {
        :campaign_id => "@{params[:partner_data]}@",
        :mobtag      => "@{params[:click]}@",
        :order_id    => "@{params[:mid]}@",
        :idfa        => "@{event.adid}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://ws.mobpartner.com/v2/ws.php",
      :params => {
        :campaign_id => "@{params[:partner_data]}@",
        :mobtag      => "@{params[:click]}@",
        :order_id    => "@{params[:mid]}@",
        :gaid        => "@{event.gadid}@"
      },

    }
  end

end

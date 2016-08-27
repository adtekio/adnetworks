class AdtekioAdnetworks::Postbacks::Mobpartner < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:campaign_id]
  end

  define_postback_for :all, :mac do
    { :url => "http://ws.mobpartner.com/v2/ws.php",
      :params => {
        :campaign_id => "@{netcfg.campaign_id}@",
        :mobtag      => "@{params[:click]}@",
        :order_id    => "@{params[:mid]}@"
      },

    }
  end

end

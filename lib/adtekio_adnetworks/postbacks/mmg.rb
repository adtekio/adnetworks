class AdtekioAdnetworks::Postbacks::Mmg < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:adv_id]
  end

  define_postback_for :all, :mac do
    { :url => "http://srv6.marsads.com/srv/px.php",
      :params => {
        :adv_id => "@{netcfg.adv_id}@",
        :pt     => "0",
        :subid  => "@{params[:click]}@",
        :t      => "0"
      },

    }
  end

end

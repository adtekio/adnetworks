class AdtekioAdnetworks::Postbacks::Appturbo < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:campaign,:info]
  end

  define_postback_for :all, :mac do
    { :url => "http://tracking.appturbo.net/callback.php",
      :params => {
        :campaign => "@{netcfg.campaign}@",
        :info     => "@{netcfg.info}@"
      },

    }
  end

end

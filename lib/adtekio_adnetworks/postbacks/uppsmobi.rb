class AdtekioAdnetworks::Postbacks::Uppsmobi < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:master]
  end

  define_postback_for :android, :mac do
    { :url => "http://pixel.traffiliate.com/pixel/serverPixels.php",
      :params => {
        :androidid => "@{params[:android_id]}@",
        :context   => "@{params[:click]}@",
        :master    => "@{netcfg.master}@"
      },

    }
  end

end

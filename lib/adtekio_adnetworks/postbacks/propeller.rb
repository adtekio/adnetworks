class AdtekioAdnetworks::Postbacks::Propeller < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:aid]
  end

  define_postback_for :ios, :mac do
    { :url => "http://ad.propellerads.com/conversion.php",
      :params => {
        :aid        => "@{netcfg.aid}@",
        :visitor_id => "@{params[:click]}@"
      },

    }
  end

end

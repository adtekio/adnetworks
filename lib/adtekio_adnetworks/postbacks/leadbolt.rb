class AdtekioAdnetworks::Postbacks::Leadbolt < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://ad.leadbolt.net/conv/",
      :params => {
        :clk_id   => "@{params[:click]}@",
        :track_id => "@{params[:partner_data]}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://ad.leadbolt.net/conv/",
      :params => {
        :clk_id   => "@{params[:click]}@",
        :track_id => "@{params[:partner_data]}@",
        :package  => "@{event.bundleid}@"
      },

    }
  end

end

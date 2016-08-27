class AdtekioAdnetworks::Postbacks::CyberzBead < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://d.exit-ad.com/cv/",
      :params => {
        :conversion_info => "@{params[:click]}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://d.exit-ad.com/cv/",
      :params => {
        :conversion_info => "@{params[:click]}@"
      },

    }
  end

end

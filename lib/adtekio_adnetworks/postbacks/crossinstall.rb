class AdtekioAdnetworks::Postbacks::Crossinstall < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :android, :mac do
    { :url => "http://convert.crossinstall.com/convert/device",
      :params => {
        :click_id => "@{params[:click]}@"
      },

    }
  end

  define_postback_for :ios, :mac do
    { :url => "http://convert.crossinstall.com/convert/device",
      :params => {
        :click_id => "@{params[:click]}@"
      },

    }
  end

end

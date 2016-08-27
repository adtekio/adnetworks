class AdtekioAdnetworks::Postbacks::Clickky < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :android, :mac do
    { :url => "http://www.cpactions.com/offers/noredirect.complete/s2s",
      :params => {
        :android_id => "@{params[:android_id]}@",
        :idfa       => "@{event.adid}@",
        :uid        => "@{params[:click]}@"
      },

    }
  end

  define_postback_for :ios, :mac do
    { :url => "http://www.cpactions.com/offers/noredirect.complete/s2s",
      :params => {
        :android_id => "@{params[:android_id]}@",
        :idfa       => "@{event.adid}@",
        :uid        => "@{params[:click]}@"
      },

    }
  end

end

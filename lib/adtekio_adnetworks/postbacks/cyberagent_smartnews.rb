class AdtekioAdnetworks::Postbacks::CyberagentSmartnews < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://log.smartnews-ads.com/sat/install",
      :params => {
        :click_id => "@{params[:click]}@"
      },

    }
  end

end

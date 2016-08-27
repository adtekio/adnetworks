class AdtekioAdnetworks::Postbacks::Mopub < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://ads.mopub.com/m/open",
      :params => {
        :v    => "5",
        :udid => "@{event.adid}@",
        :id   => "@{event.bundleid}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://ads.mopub.com/m/open",
      :params => {
        :v    => "5",
        :udid => "@{event.gadid}@",
        :id   => "@{event.bundleid}@"
      },

    }
  end

end

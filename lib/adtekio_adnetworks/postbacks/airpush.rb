class AdtekioAdnetworks::Postbacks::Airpush < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://api.airpush.com/track/",
      :params => {
        :guid => "@{params[:click]}@"
      },

    }
  end

end

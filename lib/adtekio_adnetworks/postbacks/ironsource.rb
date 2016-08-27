class AdtekioAdnetworks::Postbacks::Ironsource < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :android, :mac do
    { :url => "http://tracking.mobilecore.com/stats/mobileloopback",
      :params => {
        :action => "I",
        :adid   => "@{params[:click]}@",
        :subid  => "@{params[:adgroup]}@"
      },

    }
  end

end

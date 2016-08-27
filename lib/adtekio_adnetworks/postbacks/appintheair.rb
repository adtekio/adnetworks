class AdtekioAdnetworks::Postbacks::Appintheair < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://ads.mob-bi.com/conversion.event",
      :params => {
        :subid => "@{params[:click]}@"
      },

    }
  end

end

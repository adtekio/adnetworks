class AdtekioAdnetworks::Postbacks::CyberagentAmoad < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://d.amoad.com/cv/",
      :params => {
        :conversion_info => "@{params[:click]}@"
      },

    }
  end

end

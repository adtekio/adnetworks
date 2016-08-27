class AdtekioAdnetworks::Postbacks::Datalead < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://trk.dtlpx.com/cv",
      :params => {
        :subid => "@{params[:click]}@"
      },

    }
  end

end

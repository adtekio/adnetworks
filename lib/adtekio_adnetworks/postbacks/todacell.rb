class AdtekioAdnetworks::Postbacks::Todacell < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:source]
  end

  define_postback_for :android, :mac do
    { :url => "http://conversion.todacell.com/conversion/action",
      :params => {
        :source => "@{netcfg.source}@",
        :tcid   => "@{params[:click]}@"
      },

    }
  end

end

class AdtekioAdnetworks::Postbacks::Mundo < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:company_id]
  end

  define_postback_for :ios, :mac do
    { :url => "http://www.mlinktracker.com/lead/@{netcfg.company_id}@/",
      :params => {
        :cookieid => "@{params[:click]}@"
      },

    }
  end

end

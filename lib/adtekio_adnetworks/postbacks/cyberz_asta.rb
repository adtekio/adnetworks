class AdtekioAdnetworks::Postbacks::CyberzAsta < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:company]
  end

  define_postback_for :ios, :mac do
    { :url => "http://public.astrsk.net/@{netcfg.company}@/affi.cgi",
      :params => {
        :code => "@{params[:click]}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://public.astrsk.net/@{netcfg.company}@/affi.cgi",
      :params => {
        :code => "@{params[:click]}@"
      },

    }
  end

end

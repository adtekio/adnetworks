class AdtekioAdnetworks::Postbacks::Jumpramp < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:company_id]
  end

  define_postback_for :all, :mac do
    { :url => "http://api.jumprampgames.com/@{netcfg.company_id}@/action/simple/d2dh/",
      :params => {
        :jrg_token => "@{params[:click]}@"
      },

    }
  end

end

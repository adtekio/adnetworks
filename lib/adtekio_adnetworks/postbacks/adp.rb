class AdtekioAdnetworks::Postbacks::Adp < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:offer_id]
  end

  define_postback_for :all, :mac do
    { :url => "http://www.pxlvlt2.com/aff_lsr",
      :params => {
        :offer_id       => "@{netcfg.offer_id}@",
        :transaction_id => "@{params[:click]}@"
      },

    }
  end

end

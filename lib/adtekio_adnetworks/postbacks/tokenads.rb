class AdtekioAdnetworks::Postbacks::Tokenads < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:adv_id]
  end

  define_postback_for :ios, :mac do
    { :url => "http://offers.tokenads.com/pixel/@{netcfg.adv_id}@",
      :params => {
        :remote_id => "@{sha1(params[:mid])}@",
        :tid       => "@{params[:click]}@"
      },

    }
  end

end

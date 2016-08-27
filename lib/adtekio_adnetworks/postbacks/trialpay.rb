class AdtekioAdnetworks::Postbacks::Trialpay < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_id]
  end

  define_postback_for :all, :mac do
    { :url => "https://tpc.trialpay.com/",
      :params => {
        :tp_aid => "@{netcfg.aid}@",
        :tp_sid => "@{params[:click]}@"
      },

    }
  end

end

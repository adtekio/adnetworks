class AdtekioAdnetworks::Postbacks::Neodau < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:a]
  end

  define_postback_for :all, :mac do
    { :url => "http://neotrk.com/p.ashx",
      :params => {
        :a => "@{netcfg.a}@",
        :f => "pb",
        :r => "@{params[:click]}@"
      },

    }
  end

end

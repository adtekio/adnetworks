class AdtekioAdnetworks::Postbacks::F5 < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:a]
  end

  define_postback_for :ios, :mac do
    { :url => "http://f5mtrack.com/p.ashx",
      :params => {
        :a => "@{netcfg.a}@",
        :o => "@{params[:partner_data]}@",
        :r => "@{params[:click]}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://f5mtrack.com/p.ashx",
      :params => {
        :a => "@{netcfg.a}@",
        :o => "@{params[:partner_data]}@",
        :r => "@{params[:click]}@"
      },

    }
  end

end

class AdtekioAdnetworks::Postbacks::Neverblue < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://cjsab.com/p.ashx",
      :params => {
        :o => "@{params[:partner_data]}@",
        :f => "pb",
        :r => "@{params[:click]}@"
      },

    }
  end

end

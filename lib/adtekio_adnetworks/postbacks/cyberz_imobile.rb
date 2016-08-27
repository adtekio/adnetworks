class AdtekioAdnetworks::Postbacks::CyberzImobile < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://spdeliver.i-mobile.co.jp/api/ad_conv.ashx",
      :params => {
        :rid => "@{params[:click]}@",
        :sid => "@{params[:partner_data]}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://spdeliver.i-mobile.co.jp/api/ad_conv.ashx",
      :params => {
        :rid => "@{params[:click]}@",
        :sid => "@{params[:partner_data]}@"
      },

    }
  end

end

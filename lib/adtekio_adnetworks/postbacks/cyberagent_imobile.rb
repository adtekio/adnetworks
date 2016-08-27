class AdtekioAdnetworks::Postbacks::CyberagentImobile < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://spdeliver.i-mobile.co.jp/api/ad_conv.ashx",
      :params => {
        :rid => "@{params[:click]}@",
        :sid => "@{params[:partner_data]}@",
        :uid => "@{event.adid}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://ltv.i-mobile.co.jp/conversionvalue/put",
      :params => {
        :sid => "@{user.click_data['partner_data']}@",
        :rid => "@{user.click_data['click']}@",
        :amt => "1",
        :cls => "DAU"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://ltv.i-mobile.co.jp/conversionvalue/put",
      :params => {
        :sid => "@{user.click_data['partner_data']}@",
        :rid => "@{user.click_data['click']}@",
        :amt => "@{event.revenue}@",
        :cls => "roas"
      },
      :user_required => true
    }
  end

end

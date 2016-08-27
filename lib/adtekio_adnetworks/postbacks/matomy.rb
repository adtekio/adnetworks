class AdtekioAdnetworks::Postbacks::Matomy < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :android, :mac do
    { :url => "http://network.adsmarket.com/cevent",
      :params => {
        :type        => "lead",
        :p1          => "@{sha1(params[:mid])}@",
        :programid   => "@{params[:partner_data]}@",
        :visitor_cid => "@{params[:click]}@"
      },

    }
  end

  define_postback_for :ios, :mac do
    { :url => "http://network.adsmarket.com/cevent",
      :params => {
        :type        => "lead",
        :p1          => "@{sha1(params[:mid])}@",
        :programid   => "@{params[:partner_data]}@",
        :visitor_cid => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://network.adsmarket.com/cevent",
      :params => {
        :type        => "lead",
        :externalid  => "funnel",
        :p1          => "@{sha1(params[:mid])}@",
        :programid   => "@{user.click_data['partner_data']}@",
        :visitor_cid => "@{user.click_data['click']}@",
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'start_tutorial'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://network.adsmarket.com/cevent",
      :params => {
        :type        => "lead",
        :externalid  => "sale",
        :p1          => "@{sha1(params[:mid])}@",
        :programid   => "@{user.click_data['partner_data']}@",
        :visitor_cid => "@{user.click_data['click']}@",
      },
      :user_required => true
    }
  end

end

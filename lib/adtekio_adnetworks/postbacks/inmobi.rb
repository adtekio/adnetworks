class AdtekioAdnetworks::Postbacks::Inmobi < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:company]
  end

  define_postback_for :android, :mac do
    { :url => "http://ma.inmobi.com/downloads/trackerV1/@{netcfg.company}@",
      :params => {
        :android_id => "@{params[:android_id]}@",
        :impid      => "@{params[:click]}@"
      },
    }
  end

  define_postback_for :ios, :mac do
    { :url => "http://ma.inmobi.com/downloads/trackerV1/@{netcfg.company}@",
      :params => {
        :idfa  => "@{event.adid}@",
        :impid => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://ma.inmobi.com/downloads/trackerV1/@{netcfg.company}@",
      :params => {
        :idfa  => "@{event.adid}@",
        :impid => "@{user.click_data['click']}@",
        :goal  => "login"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://ma.inmobi.com/downloads/trackerV1/@{netcfg.company}@",
      :params => {
        :idfa           => "@{event.adid}@",
        :impid          => "@{user.click_data['click']}@",
        :goal           => "payment",
        :purchase_value => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

end

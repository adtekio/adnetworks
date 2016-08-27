class AdtekioAdnetworks::Postbacks::Mdotm < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:adv_id]
  end

  define_postback_for :ios, :mac do
    { :url => "http://ads.mdotm.com/ads/trackback.php",
      :params => {
        :advid     => "@{netcfg.adv_id}@",
        :aid       => "@{event.adid}@",
        :appid     => "@{event.appleid}@",
        :ate       => "@{(!event.adid.nil?).to_s}@",
        :clickid   => "@{params[:click]}@",
        :eventID   => "install",
        :usertoken => ""
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://ads.mdotm.com/ads/trackback.php",
      :params => {
        :advid   => "@{netcfg.adv_id}@",
        :appid   => "@{event.appleid}@",
        :clickid => "@{user.click_data['click']}@",
        :eventID => "tutorial"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'open_tutorial'"
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://ads.mdotm.com/ads/trackback.php",
      :params => {
        :advid   => "@{netcfg.adv_id}@",
        :appid   => "@{event.appleid}@",
        :clickid => "@{user.click_data['click']}@",
        :eventID => "login"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://ads.mdotm.com/ads/trackback.php",
      :params => {
        :advid   => "@{netcfg.adv_id}@",
        :appid   => "@{event.appleid}@",
        :clickid => "@{user.click_data['click']}@",
        :eventID => "payment",
        :value   => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :mac do
    { :url => "http://ads.mdotm.com/ads/receiver.php",
      :params => {
        :advid     => "@{netcfg.adv_id}@",
        :androidid => "@{ android_id }@",
        :clickid   => "@{params[:click]}@",
        :deviceid  => "",
        :package   => "@{event.bundleid}@"
      },
      :store_user => true
    }
  end

  define_postback_for :android, :fun do
    { :url => "http://ads.mdotm.com/ads/receiver.php",
      :params => {
        :advid   => "@{netcfg.adv_id}@",
        :clickid => "@{user.click_data['click']}@",
        :eventID => "tutorial",
        :package => "@{event.bundleid}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'level_won'"
    }
  end

  define_postback_for :android, :apo do
    { :url => "http://ads.mdotm.com/ads/receiver.php",
      :params => {
        :advid   => "@{netcfg.adv_id}@",
        :clickid => "@{user.click_data['click']}@",
        :eventID => "login",
        :package => "@{event.bundleid}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :pay do
    { :url => "http://ads.mdotm.com/ads/receiver.php",
      :params => {
        :advid   => "@{netcfg.adv_id}@",
        :clickid => "@{user.click_data['click']}@",
        :eventID => "payment",
        :package => "@{event.bundleid}@",
        :value   => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

  def android_id
    Digest::SHA1.hexdigest(event.params[:android_id]) if event.params[:android_id]
  end

end

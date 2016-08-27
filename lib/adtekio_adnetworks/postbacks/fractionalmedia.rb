class AdtekioAdnetworks::Postbacks::Fractionalmedia < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:advertiser_id]
  end

  define_postback_for :android, :mac do
    { :url => "http://acristavus.fractionalmedia.com/conversion_v2_bin",
      :params => {
        :bid_id => "@{params[:click]}@"
      },
      :check => "!event.params[:click].blank?",
      :store_user => true
    }
  end

  define_postback_for :android, :apo do
    { :url => "http://advertiser.fractionalmedia.com/notify_bin",
      :params => {
        :advertiserid => "@{netcfg.advertiser_id}@",
        :bidid        => "@{user.click_data['click']}@",
        :timestamp    => "@{event.trigger_stamp}@",
        :eventid      => "open"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :pay do
    { :url => "http://advertiser.fractionalmedia.com/notify_bin",
      :params => {
        :advertiserid => "@{netcfg.advertiser_id}@",
        :bidid        => "@{user.click_data['click']}@",
        :timestamp    => "@{event.trigger_stamp}@",
        :eventid      => "purchase",
        :eventvalue   => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :mac do
    { :url => "http://acristavus.fractionalmedia.com/conversion_v2_bin",
      :params => {
        :bid_id => "@{params[:click]}@"
      },
      :store_user => true,
      :check => "!event.params[:click].blank?"
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://advertiser.fractionalmedia.com/notify_bin",
      :params => {
        :advertiserid => "@{netcfg.advertiser_id}@",
        :bidid        => "@{user.click_data['click']}@",
        :timestamp    => "@{event.trigger_stamp}@",
        :eventid      => "open"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://advertiser.fractionalmedia.com/notify_bin",
      :params => {
        :advertiserid => "@{netcfg.advertiser_id}@",
        :bidid        => "@{user.click_data['click']}@",
        :timestamp    => "@{event.trigger_stamp}@",
        :eventid      => "purchase",
        :eventvalue   => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

end

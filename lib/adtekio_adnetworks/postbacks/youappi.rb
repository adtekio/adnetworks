class AdtekioAdnetworks::Postbacks::Youappi < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:tracker_token]
  end

  define_postback_for :ios, :mac do
    { :url => "http://service.youappi.com/tracking/report",
      :params => {
        :params       => "@{params[:click]}@",
        :trackerToken => "@{netcfg.tracker_token}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://service.youappi.com/tracking/event",
      :params => {
        :params       => "@{user.click_data['click']}@",
        :eventid      => "app_open",
        :eventidseq   => "1",
        :trackertoken => "@{netcfg.tracker_token}@",
        :deviceidfa   => "@{event.adid}@",
        :event_ts     => "@{params[:tscreated]}@"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://service.youappi.com/tracking/event",
      :params => {
        :params       => "@{user.click_data['click']}@",
        :eventid      => "funnel",
        :eventidseq   => "1",
        :trackertoken => "@{netcfg.tracker_token}@",
        :deviceidfa   => "@{event.adid}@",
        :event_ts     => "@{params[:tscreated]}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'tutorial_complete'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://service.youappi.com/tracking/event",
      :params => {
        :params       => "@{user.click_data['click']}@",
        :eventid      => "purchase",
        :eventidseq   => "1",
        :eventvalue   => "@{event.revenue}@",
        :trackertoken => "@{netcfg.tracker_token}@",
        :deviceidfa   => "@{event.adid}@",
        :event_ts     => "@{params[:tscreated]}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :mac do
    { :url => "http://service.youappi.com/tracking/report",
      :params => {
        :params       => "@{params[:click]}@",
        :trackerToken => "@{netcfg.tracker_token}@"
      },
      :store_user => true
    }
  end

  define_postback_for :android, :apo do
    { :url => "http://service.youappi.com/tracking/event",
      :params => {
        :params       => "@{user.click_data['click']}@",
        :eventid      => "app_open",
        :eventidseq   => "1",
        :trackertoken => "@{netcfg.tracker_token}@",
        :deviceidfa   => "@{event.adid}@",
        :event_ts     => "@{params[:tscreated]}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :fun do
    { :url => "http://service.youappi.com/tracking/event",
      :params => {
        :params       => "@{user.click_data['click']}@",
        :eventid      => "funnel",
        :eventidseq   => "1",
        :trackertoken => "@{netcfg.tracker_token}@",
        :deviceidfa   => "@{event.adid}@",
        :event_ts     => "@{params[:tscreated]}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'level_won'"
    }
  end

  define_postback_for :android, :pay do
    { :url => "http://service.youappi.com/tracking/event",
      :params => {
        :params       => "@{user.click_data['click']}@",
        :eventid      => "purchase",
        :eventidseq   => "1",
        :eventvalue   => "@{event.revenue}@",
        :trackertoken => "@{netcfg.tracker_token}@",
        :deviceidfa   => "@{event.adid}@",
        :event_ts     => "@{params[:tscreated]}@"
      },
      :user_required => true
    }
  end

end

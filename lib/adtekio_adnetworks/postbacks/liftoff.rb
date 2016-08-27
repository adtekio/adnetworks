class AdtekioAdnetworks::Postbacks::Liftoff < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_id]
  end

  define_postback_for :ios, :mac do
    { :url => "http://analytics.liftoff.io/customer_tracker/v1/@{netcfg.app_id}@/events",
      :params => {
        :third_party_tracking_token => "@{params[:click]}@",
        :client_ip                  => "@{event.ip}@",
        :idfa                       => "@{event.adid}@",
        :event_name                 => "install",
        :event_timestamp            => "@{params[:tscreated]}@",
        :app_version                => "@{params[:appversion]}@",
        :bundle_id                  => "@{event.bundleid}@",
        :is_attributed              => "true",
        :do_not_track               => "false",
        :platform                   => "ios",
        :os_version                 => "@{params[:osversion]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://analytics.liftoff.io/customer_tracker/v1/@{netcfg.app_id}@/events",
      :params => {
        :third_party_tracking_token => "@{user.click_data['click']}@",
        :client_ip                  => "@{event.ip}@",
        :idfa                       => "@{event.adid}@",
        :event_name                 => "tutorial",
        :event_timestamp            => "@{params[:tscreated]}@",
        :app_version                => "@{params[:version]}@",
        :is_attributed              => "true",
        :do_not_track               => "false",
        :platform                   => "ios",
        :os_version                 => "@{params[:osversion]}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'funnel_complete'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://analytics.liftoff.io/customer_tracker/v1/@{netcfg.app_id}@/events",
      :params => {
        :third_party_tracking_token => "@{user.click_data['click']}@",
        :client_ip                  => "@{event.ip}@",
        :idfa                       => "@{event.adid}@",
        :event_name                 => "purchase",
        :event_timestamp            => "@{params[:tscreated]}@",
        :app_version                => "@{params[:version]}@",
        :is_attributed              => "true",
        :do_not_track               => "false",
        :platform                   => "ios",
        :os_version                 => "@{params[:osversion]}@",
        :revenue                    => "@{event.revenue}@",
        :currency_code              => "usd"
      },
      :user_required => true
    }
  end

end

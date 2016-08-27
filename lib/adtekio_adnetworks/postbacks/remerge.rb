class AdtekioAdnetworks::Postbacks::Remerge < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:key,:partner]
  end

  define_postback_for :ios, :ist do
    { :url => "http://track.eu1.remerge.io/event",
      :params => {
        :app_id      => "@{event.appleid}@",
        :event       => "install",
        :partner     => "@{netcfg.partner}@",
        :key         => "@{netcfg.key}@",
        :idfa        => "@{event.adid}@",
        :country     => "@{event.country}@",
        :device_name => "@{params[:device]}@",
        :os_name     => "ios",
        :os_version  => "@{params[:osversion]}@",
        :ts          => "@{params[:tscreated]}@",
        :data        => "@{params[:version]}@"
      },
      :check => "event.country == 'US'"
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://track.eu1.remerge.io/event",
      :params => {
        :app_id      => "@{event.appleid}@",
        :event       => "session",
        :partner     => "@{netcfg.partner}@",
        :key         => "@{netcfg.key}@",
        :idfa        => "@{event.adid}@",
        :country     => "@{event.country}@",
        :device_name => "@{params[:device]}@",
        :os_name     => "ios",
        :os_version  => "@{params[:osversion]}@",
        :ts          => "@{params[:tscreated]}@",
        :data        => "@{params[:version]}@"
      },
      :check => "event.country == 'US'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://track.eu1.remerge.io/event",
      :params => {
        :app_id        => "@{event.appleid}@",
        :event         => "purchase",
        :partner       => "@{netcfg.partner}@",
        :key           => "@{netcfg.key}@",
        :idfa          => "@{event.adid}@",
        :country       => "@{event.country}@",
        :device_name   => "@{params[:device]}@",
        :os_name       => "ios",
        :os_version    => "@{params[:osversion]}@",
        :ts            => "@{params[:tscreated]}@",
        :revenue_float => "@{event.revenue}@",
        :currency      => "USD",
        :data          => "@{params[:version]}@"
      },
      :check => "event.country == 'US'"
    }
  end
end

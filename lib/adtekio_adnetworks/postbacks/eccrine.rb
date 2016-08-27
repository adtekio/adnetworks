class AdtekioAdnetworks::Postbacks::Eccrine < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:key,:partner,:adid]
  end

  define_postback_for :ios, :mac do
    { :url => "https://tracking.adtek.io/click/41/go",
      :params => {
        :adid => "@{netcfg.adid}@"
      },
    }
  end

  define_postback_for :ios, :mac do
    { :url => "https://inapp.adtek.io/t/ist",
      :params => {
        :adid => "@{netcfg.adid}@"
      },
    }
  end

  define_postback_for :ios, :ist do
    { :url => "https://inapp.adtek.io/t/testist",
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
    }
  end

  define_postback_for :ios, :apo do
    { :url => "https://inapp.adtek.io/t/testapo",
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
    }
  end

  define_postback_for :ios, :pay do
    { :url => "https://inapp.adtek.io/t/testpay",
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
    }
  end

end

class AdtekioAdnetworks::Postbacks::Fiksu < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_name,:company_id]
  end

  define_postback_for :android, :mac do
    { :url => "https://a.fiksu.com/@{netcfg.company_id}@/android/@{event.bundleid}@/event",
      :params => {
        :appid          => "@{event.bundleid}@",
        :udid           => "@{params[:android_id]}@",
        :deviceid       => "@{event.device_id}@",
        :system_name    => "android",
        :event          => "conversion",
        :a_id           => "@{event.gadid}@",
        :uploaded_at    => "@{event.time.strftime('%Y-%m-%d')}@",
        :device         => "@{params[:device]}@",
        :app_version    => "@{params[:appversion]}@",
        :app_name       => "@{netcfg.app_name}@",
        :system_version => "@{params[:osversion]}@",
        :ip_address     => "@{event.ip}@"
      },
    }
  end

  define_postback_for :ios, :mac do
    { :url => "https://a.fiksu.com/@{netcfg.company_id}@/ios/@{event.bundleid}@/event",
      :params => {
        :system_name    => "ios",
        :event          => "launch",
        :appid          => "@{event.appleid}@",
        :a_id           => "@{event.adid}@",
        :uploaded_at    => "@{event.time.strftime('%Y-%m-%d')}@",
        :device         => "@{params[:device]}@",
        :app_version    => "@{params[:appversion]}@",
        :app_name       => "@{netcfg.app_name}@",
        :system_version => "@{params[:osversion]}@",
        :ip_address     => "@{event.ip}@"
      },
    }
  end
end

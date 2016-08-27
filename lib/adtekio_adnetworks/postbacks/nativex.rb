class AdtekioAdnetworks::Postbacks::Nativex < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_id]
  end

  define_postback_for :ios, :mac do
    { :url => "http://api.w3i.com/PublicServices/MobileTrackingApiRestV1.svc/AppWasRunV2",
      :params => {
        :AppId    => "@{netcfg.app_id}@",
        :clientIp => "@{event.ip}@",
        :iOSIDFA  => "@{event.adid}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://api.w3i.com/PublicServices/MobileTrackingApiRestV1.svc/AppWasRunV2",
      :params => {
        :AppId       => "@{netcfg.app_id}@",
        :clientIp    => "@{event.ip}@",
        :AndroidIDFA => "@{event.gadid}@"
      },

    }
  end

end

class AdtekioAdnetworks::Postbacks::Growmobile < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_key]
  end

  define_postback_for :ios, :mac do
    { :url => "https://api.growmobile.com/tracking/open",
      :params => {
        :app_key     => "@{netcfg.app_key}@",
        :aid         => "@{event.adid}@",
        :aid_enabled => "true",
        :device_ip   => "@{event.ip}@",
        :signature   => "",
        :click_id    => "@{params[:click]}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "https://api.growmobile.com/tracking/open",
      :params => {
        :app_key      => "@{netcfg.app_key}@",
        :gaid         => "@{event.gadid}@",
        :gaid_enabled => "true",
        :device_ip    => "@{event.ip}@",
        :signature    => "",
        :click_id     => "@{params[:click]}@"
      },

    }
  end

end

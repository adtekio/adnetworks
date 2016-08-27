class AdtekioAdnetworks::Postbacks::Fyber < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:appid]
  end

  define_postback_for :ios, :mac do
    { :url => "http://service.sponsorpay.com/installs/v2",
      :params => {
        :answer_received             => "0",
        :appid                       => "@{netcfg.appid}@",
        :apple_idfa                  => "@{event.adid}@",
        :apple_idfa_tracking_enabled => "true",
        :ip                          => "@{event.ip}@",
        :subid                       => "@{params[:click]}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://service.sponsorpay.com/installs/v2",
      :params => {
        :answer_received               => "0",
        :appid                         => "@{netcfg.appid}@",
        :google_ad_id                  => "@{event.gadid}@",
        :google_ad_id_tracking_enabled => "true",
        :ip                            => "@{event.ip}@",
        :subid                         => "@{params[:click]}@"
      },

    }
  end

end

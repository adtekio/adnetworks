class AdtekioAdnetworks::Postbacks::Jampp < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://tracking.jampp.com/postback",
      :params => {
        :pubid     => "@{params[:click]}@",
        :apple_ifa => "@{event.adid}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://tracking.jampp.com/event",
      :params => {
        :kind         => "purchased",
        :rnd          => "@{event.stamp}@",
        :adv          => "",
        :app          => "@{event.appleid}@",
        :android_id   => "",
        :pubid        => "@{user.click_data['click']}@",
        :value        => "@{event.revenue}@",
        :content_type => "usd"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://tracking.jampp.com/event",
      :params => {
        :kind       => "app_open",
        :rnd        => "@{event.stamp}@",
        :adv        => "",
        :app        => "@{event.appleid}@",
        :android_id => "",
        :pubid      => "@{user.click_data['click']}@"
      },
      :user_required => true
    }
  end

end

class AdtekioAdnetworks::Postbacks::Lifestreet < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://mobile.lfstmedia.com/ios01/install",
      :params => {
        :bundleid => "@{event.bundleid}@",
        :ifa      => "@{event.adid}@",
        :ip       => "@{event.ip}@",
        :referrer => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://mobile.lfstmedia.com/ios01/event",
      :params => {
        :ifa        => "@{event.adid}@",
        :bundleid   => "@{event.bundleid}@",
        :referrer   => "@{user.click_data['click']}@",
        :ip         => "@{event.ip}@",
        :ua         => "",
        :event_name => "login",
        :event_type => "1"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://mobile.lfstmedia.com/ios01/event",
      :params => {
        :ifa        => "@{event.adid}@",
        :bundleid   => "@{event.bundleid}@",
        :referrer   => "@{user.click_data['click']}@",
        :ip         => "@{event.ip}@",
        :ua         => "",
        :event_name => "pay",
        :event_type => "2"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :mac do
    { :url => "http://mobile.lfstmedia.com/android02/install",
      :params => {
        :android_id => "@{params[:android_id]}@",
        :device_id  => "@{params[:mid]}@",
        :ip         => "@{event.ip}@",
        :package    => "@{event.bundleid}@",
        :referrer   => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :android, :apo do
    { :url => "http://mobile.lfstmedia.com/android02/event",
      :params => {
        :aaid       => "",
        :android_id => "@{params[:android_id]}@",
        :package    => "@{event.bundleid}@",
        :referrer   => "@{user.click_data['click']}@",
        :device_id  => "@{params[:mid]}@",
        :ip         => "@{event.ip}@",
        :ua         => "",
        :event_name => "login",
        :event_type => "1"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :pay do
    { :url => "http://mobile.lfstmedia.com/android02/event",
      :params => {
        :aaid       => "",
        :android_id => "@{params[:android_id]}@",
        :package    => "@{event.bundleid}@",
        :referrer   => "@{user.click_data['click']}@",
        :device_id  => "@{params[:mid]}@",
        :ip         => "@{event.ip}@",
        :ua         => "",
        :event_name => "pay",
        :event_type => "2"
      },
      :user_required => true
    }
  end

end

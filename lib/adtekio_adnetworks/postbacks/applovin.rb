class AdtekioAdnetworks::Postbacks::Applovin < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:aid,:package_name,:pkg,:sdk_key]
  end

  define_postback_for :ios, :mac do
    { :url => "https://a.applovin.com/conv",
      :params => {
        :adid => "@{event.adid}@",
        :aid  => "@{netcfg.aid}@",
        :did  => "@{params[:click]}@",
        :pkg  => "@{netcfg.pkg}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://rt.applovin.com/pix",
      :params => {
        :event        => "landing",
        :package_name => "@{netcfg.package_name}@",
        :sdk_key      => "@{netcfg.sdk_key}@",
        :platform     => "ios",
        :brand        => "Apple",
        :model        => "@{params[:device]}@",
        :device_ip    => "@{event.ip}@",
        :idfa         => "@{event.adid}@",
        :did          => "@{user.click_data['click']}@"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://rt.applovin.com/pix",
      :params => {
        :event        => "postinstall",
        :sub_event    => "@{params[:funnel_step]}@",
        :package_name => "@{netcfg.package_name}@",
        :sdk_key      => "@{netcfg.sdk_key}@",
        :platform     => "ios",
        :brand        => "Apple",
        :model        => "@{params[:device]}@",
        :device_ip    => "@{event.ip}@",
        :idfa         => "@{event.adid}@",
        :did          => "@{user.click_data['click']}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'played_level'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://rt.applovin.com/pix",
      :params => {
        :event        => "checkout",
        :package_name => "@{netcfg.package_name}@",
        :sdk_key      => "@{netcfg.sdk_key}@",
        :platform     => "ios",
        :brand        => "Apple",
        :model        => "@{params[:device]}@",
        :revenue      => "@{event.revenue}@",
        :curreny_code => "USD",
        :device_ip    => "@{event.ip}@",
        :idfa         => "@{event.adid}@",
        :did          => "@{user.click_data['click']}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :mac do
    { :url => "http://rt.applovin.com/pix",
      :params => {
        :event        => "install",
        :package_name => "@{netcfg.package_name}@",
        :sdk_key      => "@{netcfg.sdk_key}@",
        :brand        => "android",
        :model        => "@{params[:device]}@",
        :idfa         => "@{params[:gadid]}@",
        :dnt          => "@{!params[:gadid].to_s.blank?}@",
        :did          => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :android, :apo do
    { :url => "http://rt.applovin.com/pix",
      :params => {
        :event        => "landing",
        :package_name => "@{netcfg.package_name}@",
        :sdk_key      => "@{netcfg.sdk_key}@",
        :platform     => "google",
        :brand        => "android",
        :model        => "@{params[:device]}@",
        :device_ip    => "@{event.ip}@",
        :idfa         => "@{params[:gadid]}@",
        :did          => "@{user.click_data['click']}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :pay do
    { :url => "http://rt.applovin.com/pix",
      :params => {
        :event        => "checkout",
        :package_name => "@{netcfg.package_name}@",
        :sdk_key      => "@{netcfg.sdk_key}@",
        :platform     => "google",
        :brand        => "android",
        :model        => "@{params[:device]}@",
        :revenue      => "@{event.revenue}@",
        :curreny_code => "USD",
        :device_ip    => "@{event.ip}@",
        :idfa         => "@{params[:gadid]}@",
        :did          => "@{user.click_data['click']}@"
      },
      :user_required => true
    }
  end

end

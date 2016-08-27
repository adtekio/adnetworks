class AdtekioAdnetworks::Postbacks::Adcolony < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:api_key]
  end

  define_postback_for :android, :mac do
    { :url => "https://cpa.adcolony.com:443/on_user_action",
      :params => {
        :api_key        => "@{netcfg.api_key}@",
        :google_ad_id   => "@{params[:partner_data]}@",
        :product_id     => "@{event.bundleid}@",
        :raw_android_id => "@{event.android_id}@"
      },
    }
  end

  define_postback_for :ios, :mac do
    { :url => "https://cpa.adcolony.com:443/on_user_action",
      :params => {
        :api_key            => "@{netcfg.api_key}@",
        :product_id         => "@{event.appleid}@",
        :raw_advertising_id => "@{event.adid}@"
      },
    }
  end

  define_postback_for :ios, :mac do
    { :url => "https://pie.adcolony.com:443/api/v1/install",
      :params => {
        :product_id         => "@{event.appleid}@",
        :api_key            => "@{netcfg.api_key}@",
        :raw_advertising_id => "@{event.adid}@",
        :deviceip           => "@{event.ip}@",
        :device_brand       => "Apple",
        :device_model       => "@{event.device}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "https://pie.adcolony.com:443/api/v1/open",
      :params => {
        :product_id         => "@{event.appleid}@",
        :api_key            => "@{netcfg.api_key}@",
        :raw_advertising_id => "@{event.adid}@",
        :deviceip           => "@{event.ip}@",
        :device_brand       => "Apple",
        :device_model       => "@{params[:device]}@"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "https://pie.adcolony.com:443/api/v1/custom_event",
      :params => {
        :product_id         => "@{event.appleid}@",
        :api_key            => "@{netcfg.api_key}@",
        :raw_advertising_id => "@{event.adid}@",
        :deviceip           => "@{event.ip}@",
        :device_brand       => "Apple",
        :device_model       => "@{params[:device]}@",
        :event              => "ADCT_CUSTOM_EVENT_1",
        :description        => "battle_won"
      },
      :user_required => true,
      :check => "event.params[:step_number] == '1'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "https://pie.adcolony.com:443/api/v1/transaction",
      :params => {
        :product_id         => "@{event.appleid}@",
        :api_key            => "@{netcfg.api_key}@",
        :raw_advertising_id => "@{event.adid}@",
        :deviceip           => "@{event.ip}@",
        :device_brand       => "Apple",
        :device_model       => "@{params[:device]}@",
        :price              => "@{event.revenue}@",
        :currency_code      => "USD"
      },
      :user_required => true
    }
  end

end

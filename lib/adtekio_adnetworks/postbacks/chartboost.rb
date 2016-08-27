class AdtekioAdnetworks::Postbacks::Chartboost < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:api_secret,:api_token,:app_id]
  end

  define_postback_for :ios, :mac do
    { :url => "https://live.chartboost.com/api/v1/install.json",
      :params => {

      },
      :post => :install_body,
      :header => {
        :"content-type"           => "application/json",
        :"x-chartboost-token"     => "@{netcfg.api_token}@",
        :"x-chartboost-signature" => "@{install_signature}@",
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "https://live.chartboost.com/event_service/v2/iap",
      :params => {
        :ifa   => "@{event.adid}@",
        :sdk   => "backend",
        :token => "@{netcfg.api_token}@"
      },
      :post => :iap_body,
      :header => {
        :"content-type"           => "application/json",
        :"x-chartboost-app"       => "@{netcfg.app_id}@",
        :"x-chartboost-signature" => "@{signature}@",
      },
      :user_required => true
    }
  end

  define_postback_for :android, :mac do
    { :url => "https://live.chartboost.com/api/v1/install.json",
      :params => {
      },
      :post => :install_body,
      :header => {
        :"content-type"           => "application/json",
        :"x-chartboost-token"     => "@{netcfg.api_token}@",
        :"x-chartboost-signature" => "@{install_signature}@"
      },
      :store_user => true
    }
  end

  define_postback_for :android, :pay do
    { :url => "https://live.chartboost.com/event_service/v2/iap",
      :params => {
        :ifa   => "@{event.adid}@",
        :sdk   => "backend",
        :token => "@{netcfg.api_token}@"
      },
      :post => :iap_body,
      :header => {
        :"content-type"           => "application/json",
        :"x-chartboost-app"       => "@{netcfg.app_id}@",
        :"x-chartboost-signature" => "@{signature}@"
      },
      :user_required => true
    }
  end


  def signature
    Digest::SHA2.hexdigest("action:pia;app:#{netcfg.app_id};"+
                           "token:#{netcfg.api_token};"+
                           "timestamp:#{event.trigger_stamp};")
  end

  def install_signature
    hsh_string = ["action:attribution", netcfg.api_secret,
                  signature, install_body].join("\n")
    Digest::SHA2.hexdigest hsh_string
  end

  def install_body
    params = if event.android?
      { :gaid => event.gadid,
        :uuid => event.android_id || event.gadid
      }.select {|_,v| v.present?}
    else
      {:ifa => event.adid}
    end

    JSON.generate(params.merge({
      :app_id => netcfg.app_id,
      :claim  => 1
    }))
  end

  def iap_body
    JSON.generate({
      :platform       => :ios,
      :sdk_version    => 4.2,
      :token          => netcfg.api_token,
      :identifiers    => {
        :ifa          => event.adid,
      },
      :receipt_valid  => false,
      :timestamp      => event.trigger_stamp,
      :iap            => {
        :currency   => event.currency,
        :price      => params[:price].to_f,
        :product_id => params[:st1] || params[:s1] || 'unknown'
      }
    })
  end
end

class AdtekioAdnetworks::Postbacks::Adquant < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:callback_id]
  end

  define_postback_for :all, :ist do
    { :url => "http://s.mb4w.com/cb/@{netcfg.callback_id}@",
      :params => {
        :ifcontext    => "",
        :order_id     => "@{event.adid}@",
        :mmp          => "true",
        :mid          => "@{event.device_id}@",
        :user_device  => "@{event.device}@",
        :user_os      => "@{params[:osversion]}@",
        :user_country => "@{event.country}@"
      },

    }
  end

  define_postback_for :all, :pay do
    { :url => "http://s.mb4w.com/cb/@{netcfg.callback_id}@",
      :params => {
        :ifcontext    => "",
        :order_id     => "@{event.adid}@",
        :mid          => "@{params[:mid]}@",
        :user_device  => "@{params[:device]}@",
        :user_os      => "@{params[:osversion]}@",
        :user_country => "@{event.country}@",
        :amount       => "@{event.revenue}@",
        :currency     => "USD"
      },

    }
  end

end

class AdtekioAdnetworks::Postbacks::Vungle < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_id]
  end

  define_postback_for :android, :mac do
    { :url => "http://api.vungle.com/api/v3/new",
      :params => {
        :app_id     => "@{netcfg.app_id}@",
        :isu        => "@{params[:android_id]}@",
        :aaid       => "@{params[:gadid]}@",
        :event_id   => "@{params[:click]}@",
        :conversion => "1"
      },

    }
  end

  define_postback_for :ios, :mac do
    { :url => "http://api.vungle.com/api/v3/new",
      :params => {
        :app_id     => "@{netcfg.app_id}@",
        :ifa        => "@{event.adid}@",
        :event_id   => "@{params[:click]}@",
        :conversion => "1"
      },

    }
  end

end

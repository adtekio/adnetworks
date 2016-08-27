class AdtekioAdnetworks::Postbacks::Nanigans < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_id]
  end

  define_postback_for :ios, :mac do
    { :url => "https://api.nanigans.com:443/event.php",
      :params => {
        :app_id     => "@{netcfg.app_id}@",
        :name       => "postback",
        :nan_pid    => "@{params[:click]}@",
        :s2s        => "1",
        :type       => "install",
        :user_id    => "@{params[:mid]}@",
        :nan_advert => "@{event.adid}@"
      },
      :store_user => true
    }
  end

  define_postback_for :android, :mac do
    { :url => "https://api.nanigans.com:443/event.php",
      :params => {
        :app_id     => "@{netcfg.app_id}@",
        :name       => "postback",
        :nan_pid    => "@{params[:click]}@",
        :s2s        => "1",
        :type       => "install",
        :user_id    => "@{params[:mid]}@",
        :nan_advert => "@{event.gadid}@"
      },
      :store_user => true
    }
  end

end

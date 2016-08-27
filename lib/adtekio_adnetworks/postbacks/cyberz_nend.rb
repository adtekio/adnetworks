class AdtekioAdnetworks::Postbacks::CyberzNend < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_id]
  end

  define_postback_for :ios, :mac do
    { :url => "http://c1.nend.net/api/conversion.php",
      :params => {
        :nendid => "@{params[:click]}@",
        :idfa   => "@{event.adid}@",
        :app_id => "@{netcfg.app_id}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://c1.nend.net/api/conversion.php",
      :params => {
        :nendid => "@{params[:click]}@",
        :from   => "ads",
        :app_id => "@{netcfg.app_id}@"
      },

    }
  end

end

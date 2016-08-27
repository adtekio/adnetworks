class AdtekioAdnetworks::Postbacks::CyberagentNend < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_id]
  end

  define_postback_for :ios, :mac do
    { :url => "https://c1.nend.net/api/conversion.php",
      :params => {
        :app_id => "@{netcfg.app_id}@",
        :idfa   => "@{event.adid}@",
        :nendid => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "https://s.nend.net/api/conversion.php",
      :params => {
        :nendid => "@{user.click_data['click']}@",
        :nendcv => "2"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "https://s.nend.net/api/conversion.php",
      :params => {
        :nendid => "@{user.click_data['click']}@",
        :nendcv => "3",
        :price  => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

end

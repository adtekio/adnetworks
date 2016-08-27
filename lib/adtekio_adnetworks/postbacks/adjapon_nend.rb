class AdtekioAdnetworks::Postbacks::AdjaponNend < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "https://s.nend.net:443/api/conversion.php",
      :params => {
        :nendcv => "1",
        :nendid => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :all, :apo do
    { :url => "https://s.nend.net:443/api/conversion.php",
      :params => {
        :nendcv => "2",
        :nendid => "@{user.click_data['click']}@"
      },
      :user_required => true
    }
  end

  define_postback_for :all, :pay do
    { :url => "https://s.nend.net:443/api/conversion.php",
      :params => {
        :nendcv => "3",
        :nendid => "@{user.click_data['click']}@",
        :price  => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

end

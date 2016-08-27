class AdtekioAdnetworks::Postbacks::Glispa < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :android, :mac do
    { :url => "http://glispatrack.com/sp/mp.php",
      :params => {
        :clickID  => "@{params[:click]}@",
        :deviceid => "@{params[:mid]}@",
        :oid      => "@{Digest::SHA1.hexdigest(params[:android_id])}@",
        :deviceip => "@{event.ip}@"
      },
      :check => "!event.params[:click].nil?",
      :store_user => true
    }
  end

  define_postback_for :android, :fun do
    { :url => "http://glispatrack.com/sp/mp.php",
      :params => {
        :clickid  => "@{user.click_data['click']}@",
        :type     => "multi",
        :step     => "2",
        :eventid  => "tutorial",
        :oid      => "@{user.click_data['android_id']}@",
        :deviceip => "@{event.ip}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'level_won'"
    }
  end

  define_postback_for :android, :pay do
    { :url => "http://glispatrack.com/sp/mp.php",
      :params => {
        :clickid          => "@{user.click_data['click']}@",
        :type             => "multi",
        :step             => "2",
        :eventid          => "purchase",
        :oid              => "@{user.click_data['android_id']}@",
        :deviceip         => "@{event.ip}@",
        :revenue_amount   => "@{event.revenue}@",
        :revenue_currency => "USD"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :mac do
    { :url => "http://glispatrack.com/sp/mp.php",
      :params => {
        :clickID  => "@{params[:click]}@",
        :deviceid => "@{params[:mid]}@",
        :oid      => "@{params[:emid]}@",
        :deviceip => "@{event.ip}@"
      },
      :check => "!event.params[:click].nil?",
      :store_user => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://glispatrack.com/sp/mp.php",
      :params => {
        :clickid  => "@{user.click_data['click']}@",
        :type     => "multi",
        :step     => "2",
        :eventid  => "tutorial",
        :oid      => "@{user.click_data['emid']}@",
        :deviceip => "@{event.ip}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'open_scene'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://glispatrack.com/sp/mp.php",
      :params => {
        :clickid          => "@{user.click_data['click']}@",
        :type             => "multi",
        :step             => "2",
        :eventid          => "purchase",
        :oid              => "@{user.click_data['emid']}@",
        :deviceip         => "@{event.ip}@",
        :revenue_amount   => "@{event.revenue}@",
        :revenue_currency => "USD"
      },
      :user_required => true
    }
  end

end

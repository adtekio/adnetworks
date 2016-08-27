class AdtekioAdnetworks::Postbacks::SevenGames < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://tracking.sevengamesnetwork.com/aff_lsr",
      :params => {
        :adv_sub        => "@{event.device_id}@",
        :transaction_id => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://tracking.sevengamesnetwork.com/aff_goal",
      :params => {
        :a              => "lsr",
        :goal_id        => "@{user.click_data['partner_data']}@",
        :transaction_id => "@{user.click_data['click']}@",
        :adv_sub        => "@{params[:mid]}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :mac do
    { :url => "http://tracking.sevengamesnetwork.com/aff_lsr",
      :params => {
        :adv_sub        => "@{event.device_id}@",
        :transaction_id => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :android, :apo do
    { :url => "http://tracking.sevengamesnetwork.com/aff_goal",
      :params => {
        :a              => "lsr",
        :goal_id        => "@{user.click_data['partner_data']}@",
        :transaction_id => "@{user.click_data['click']}@",
        :adv_sub        => "@{params[:mid]}@"
      },
      :user_required => true
    }
  end
end

class AdtekioAdnetworks::Postbacks::Adgorithms < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://mobiletracking.adgorithms.com/aff_lsr",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://mobiletracking.adgorithms.com/aff_goal",
      :params => {
        :a              => "lsr",
        :goal_id        => "@{params[:ad]}@",
        :transaction_id => "@{user.click_data['click']}@",
        :adv_sub        => "retention"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://mobiletracking.adgorithms.com/aff_goal",
      :params => {
        :a              => "lsr",
        :goal_id        => "@{params[:partner_data]}@",
        :transaction_id => "@{user.click_data['click']}@",
        :adv_sub        => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :mac do
    { :url => "http://mobiletracking.adgorithms.com/aff_lsr",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :android, :apo do
    { :url => "http://mobiletracking.adgorithms.com/aff_goal",
      :params => {
        :a              => "lsr",
        :goal_id        => "@{params[:ad]}@",
        :transaction_id => "@{user.click_data['click']}@",
        :adv_sub        => "retention"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :pay do
    { :url => "http://mobiletracking.adgorithms.com/aff_goal",
      :params => {
        :a              => "lsr",
        :goal_id        => "@{params[:partner_data]}@",
        :transaction_id => "@{user.click_data['click']}@",
        :adv_sub        => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

end

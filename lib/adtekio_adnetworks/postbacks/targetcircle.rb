class AdtekioAdnetworks::Postbacks::Targetcircle < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://p.trackmytarget.com/",
      :params => {
        :conversionType => "install",
        :transactionID  => "@{params[:click]}@",
        :tmtData        => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :all, :apo do
    { :url => "http://p.trackmytarget.com/",
      :params => {
        :conversionType => "lead",
        :transactionID  => "@{user.click_data['click']}@",
        :tmtData        => "@{user.click_data['click']}@"
      },
      :user_required => true
    }
  end

  define_postback_for :all, :pay do
    { :url => "http://p.trackmytarget.com/",
      :params => {
        :conversionType => "sale",
        :transactionID  => "@{user.click_data['click']}@",
        :tmtData        => "@{user.click_data['click']}@"
      },
      :user_required => true
    }
  end

end

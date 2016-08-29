class AdtekioAdnetworks::Postbacks::Unilead < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_id]
  end

  define_postback_for :ios, :mac do
    { :url => "http://go.unilead.net/SP1AB",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },
      :check => "params[:device].to_s =~/ipad/i",
      :store_user => true
    }
  end

  define_postback_for :ios, :mac do
    { :url => "http://go.unilead.net/SP2M0",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },
      :check => "params[:device].to_s =~/iphone/i",
      :store_user => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://go.unilead.net/GP2b9",
      :params => {
        :transaction_id => "@{user.click_data['click']}@"
      },
      :user_required => true,
      :check => "params[:funnel_step] == 'tutorial_complete' && params[:device].to_s =~/ipad/i"
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://go.unilead.net/GP2bF",
      :params => {
        :transaction_id => "@{user.click_data['click']}@"
      },
      :user_required => true,
      :check => "params[:funnel_step] == 'tutorial_complete' && params[:device].to_s =~/iphone/i"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://go.unilead.net/GP2bL",
      :params => {
        :transaction_id => "@{user.click_data['click']}@",
        :amount         => "@{event.revenue}@"
      },
      :user_required => true,
      :check => "params[:device].to_s =~/ipad/i"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://go.unilead.net/GP2bR",
      :params => {
        :transaction_id => "@{user.click_data['click']}@",
        :amount         => "@{event.revenue}@"
      },
      :user_required => true,
      :check => "params[:device].to_s =~/iphone/i"
    }
  end

  define_postback_for :android, :mac do
    { :url => "http://go.unilead.net/@{netcfg.app_id}@",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },
    }
  end

end

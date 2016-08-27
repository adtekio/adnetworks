class AdtekioAdnetworks::Postbacks::Heyzap < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:game_id,:secret_key]
  end

  define_postback_for :ios, :mac do
    { :url => "http://www.heyzap.com/cpi_callback/new_install",
      :params => {
        :game_identifier       => "@{netcfg.game_id}@",
        :secret_key            => "@{netcfg.secret_key}@",
        :impression_identifier => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "http://www.heyzap.com/in_game_api/ads/register_event",
      :params => {
        :impression_id => "@{user.click_data['click']}@",
        :event_type    => "app_open"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://www.heyzap.com/in_game_api/ads/register_event",
      :params => {
        :impression_id => "@{user.click_data['click']}@",
        :event_type    => "tutorial"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'step_one'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://www.heyzap.com/in_game_api/ads/register_event",
      :params => {
        :impression_id => "@{user.click_data['click']}@",
        :event_type    => "purchase",
        :revenue_usd   => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

end

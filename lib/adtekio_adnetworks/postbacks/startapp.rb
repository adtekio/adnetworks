class AdtekioAdnetworks::Postbacks::Startapp < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:company]
  end

  define_postback_for :android, :mac do
    { :url => "http://www.startappinstalls.com/trackinstall/@{netcfg.company}@",
      :params => {
        :d => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :android, :apo do
    { :url => "http://startappexchange.com/trackpostinstall/@{netcfg.company}@",
      :params => {
        :a => "app_open",
        :d => "@{user.click_data['click']}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :fun do
    { :url => "http://startappexchange.com/trackpostinstall/@{netcfg.company}@",
      :params => {
        :a => "tutorial",
        :d => "@{user.click_data['click']}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'tutorial_complete'"
    }
  end

  define_postback_for :android, :pay do
    { :url => "http://startappexchange.com/trackpostinstall/@{netcfg.company}@",
      :params => {
        :a => "purchase",
        :d => "@{user.click_data['click']}@"
      },
      :user_required => true
    }
  end

end

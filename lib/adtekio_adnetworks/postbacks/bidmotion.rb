class AdtekioAdnetworks::Postbacks::Bidmotion < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:advnid]
  end

  define_postback_for :ios, :mac do
    { :url => "http://engine.mobdone.com/conversion",
      :params => {
        :advnid => "@{netcfg.advnid}@",
        :tid    => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://engine.mobdone.com/ltv",
      :params => {
        :advnid        => "@{netcfg.advnid}@",
        :tid           => "@{user.click_data['click']}@",
        :event_name    => "tutorial",
        :event_iosidfa => "@{event.adid}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'level_won'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://engine.mobdone.com/ltv",
      :params => {
        :advnid        => "@{netcfg.advnid}@",
        :tid           => "@{user.click_data['click']}@",
        :event_name    => "purchase",
        :event_revenue => "@{event.revenue}@",
        :event_iosidfa => "@{event.adid}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :mac do
    { :url => "http://engine.mobdone.com/conversion",
      :params => {
        :advnid => "@{netcfg.advnid}@",
        :tid    => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :android, :fun do
    { :url => "http://engine.mobdone.com/ltv",
      :params => {
        :advnid          => "@{netcfg.advnid}@",
        :tid             => "@{user.click_data['click']}@",
        :event_name      => "tutorial",
        :event_androidid => "@{params[:gadid]}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'level_won'"
    }
  end

  define_postback_for :android, :pay do
    { :url => "http://engine.mobdone.com/ltv",
      :params => {
        :advnid          => "@{netcfg.advnid}@",
        :tid             => "@{user.click_data['click']}@",
        :event_name      => "purchase",
        :event_revenue   => "@{event.revenue}@",
        :event_androidid => "@{params[:gadid]}@"
      },
      :user_required => true
    }
  end

end

class AdtekioAdnetworks::Postbacks::Applift < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:source]
  end

  define_postback_for :ios, :mac do
    { :url => "http://hitfox.go2cloud.org/aff_lsr",
      :params => {
        :transaction_id => "@{params[:partner_data]}@"
      },
      :check => "!event.params[:partner_data].blank?",
      :store_user => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://events.applift.com/v1/events",
      :params => {
        :source           => "@{netcfg.source}@",
        :pub_reference_id => "@{user.click_data['partner_data']}@",
        :event_name       => "tutorial_complete",
        :ios_ifa          => "@{event.adid}@",
        :device_brand     => "apple",
        :device_model     => "@{params[:device]}@",
        :device_ip        => "@{event.ip}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'level_won'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://events.applift.com/v1/events",
      :params => {
        :source           => "@{netcfg.source}@",
        :pub_reference_id => "@{user.click_data['partner_data']}@",
        :ios_ifa          => "@{event.adid}@",
        :device_brand     => "apple",
        :device_model     => "@{params[:device]}@",
        :device_ip        => "@{event.ip}@",
        :event_value      => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

  define_postback_for :android, :mac do
    { :url => "http://hitfox.go2cloud.org/aff_lsr",
      :params => {
        :transaction_id => "@{params[:partner_data]}@"
      },
      :store_user => true,
      :check => "!event.params[:partner_data].blank?"
    }
  end

  define_postback_for :android, :fun do
    { :url => "http://events.applift.com/v1/events",
      :params => {
        :source           => "@{netcfg.source}@",
        :pub_reference_id => "@{user.click_data['partner_data']}@",
        :event_name       => "tutorial_complete",
        :device_id        => "@{event.gadid}@",
        :device_model     => "@{params[:device]}@",
        :device_ip        => "@{event.ip}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'level_won'"
    }
  end

  define_postback_for :android, :pay do
    { :url => "http://events.applift.com/v1/events",
      :params => {
        :source           => "@{netcfg.source}@",
        :pub_reference_id => "@{user.click_data['partner_data']}@",
        :device_id        => "@{event.gadid}@",
        :device_model     => "@{params[:device]}@",
        :device_ip        => "@{event.ip}@",
        :event_value      => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

end

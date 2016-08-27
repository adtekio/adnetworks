class AdtekioAdnetworks::Postbacks::Trademob < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :android, :mac do
    { :url => "https://graph.trademob.com/apps/android/@{event.bundleid}@/sessions/@{params[:mid]}@",
      :params => {
        :android_id => "@{params[:android_id]}@",
        :click_id   => "@{params[:click]}@"
      },

    }
  end

  define_postback_for :ios, :mac do
    { :url => "https://graph.trademob.com/apps/ios/@{event.bundleid}@/sessions/@{params[:mid]}@",
      :params => {
        :click_id => "@{params[:click]}@",
        :idfa     => "@{event.adid}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "https://graph.trademob.com/apps/ios/@{event.bundleid}@/sessions/@{params[:mid]}@/loads",
      :params => {
        :click_id => "@{user.click_data['click']}@",
        :idfa     => "@{event.adid}@"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "https://graph.trademob.com/apps/ios/@{event.bundleid}@/sessions/@{params[:mid]}@/events/purchase",
      :params => {
        :click_id => "@{user.click_data['click']}@",
        :value    => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

end

class AdtekioAdnetworks::Postbacks::Eeline < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:csid]
  end

  define_postback_for :android, :mac do
    { :url => "",
      :params => {

      },
      :store_user => true
    }
  end

  define_postback_for :android, :fun do
    { :url => "http://r.eeaf.jp/qsv_reg",
      :params => {
        :csid => "@{netcfg.csid}@",
        :ssid => "@{user.click_data['click']}@",
        :upid => "@{event.gadid}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'tutorial_started'"
    }
  end

  define_postback_for :ios, :mac do
    { :url => "",
      :params => {

      },
      :store_user => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://r.eeaf.jp/qsv_reg",
      :params => {
        :csid => "@{netcfg.csid}@",
        :ssid => "@{user.click_data['click']}@",
        :upid => "@{event.adid}@"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'tutorial_started'"
    }
  end

end

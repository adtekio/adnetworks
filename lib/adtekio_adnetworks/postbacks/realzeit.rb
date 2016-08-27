class AdtekioAdnetworks::Postbacks::Realzeit < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:c,:cr]
  end

  define_postback_for :ios, :ist do
    { :url => "https://t-eu.realzeit.io:443/r/api",
      :params => {
        :c    => "@{netcfg.c}@",
        :cr   => "@{netcfg.cr}@",
        :idfa => "@{event.adid}@",
        :t    => "df"
      },
      :check => "['US', 'DE'].include?(event.country)"
    }
  end

  define_postback_for :ios, :mac do
    { :url => "https://t-eu.realzeit.io:443/r/api",
      :params => {
        :c    => "@{netcfg.c}@",
        :cl   => "@{params[:click]}@",
        :cr   => "@{netcfg.cr}@",
        :idfa => "@{event.adid}@",
        :t    => "in"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :apo do
    { :url => "https://t-eu.realzeit.io:443/r/api",
      :params => {
        :c    => "@{netcfg.c}@",
        :cl   => "@{user.click_data['click']}@",
        :cr   => "@{netcfg.cr}@",
        :idfa => "@{event.adid}@",
        :t    => "op"
      },
      :user_required => true
    }
  end

  define_postback_for :ios, :pay do
    { :url => "https://t-eu.realzeit.io:443/r/api",
      :params => {
        :c    => "@{netcfg.c}@",
        :cl   => "@{user.click_data['click']}@",
        :cr   => "@{netcfg.cr}@",
        :idfa => "@{event.adid}@",
        :t    => "co",
        :cv   => "@{event.revenue}@"
      },
      :user_required => true
    }
  end

end

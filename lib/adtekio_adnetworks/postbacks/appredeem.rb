class AdtekioAdnetworks::Postbacks::Appredeem < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:appid,:ssk]
  end

  define_postback_for :android, :mac do
    { :url => "http://d1.appredeem.com/redeem_android.php",
      :params => {
        :appid => "@{netcfg.appid}@",
        :asid  => "@{params[:click]}@",
        :ip    => "@{event.ip}@",
        :ssk   => "@{netcfg.ssk}@"
      },

    }
  end

  define_postback_for :ios, :mac do
    { :url => "http://d1.appredeem.com/redeem.php",
      :params => {
        :appid => "@{netcfg.appid}@",
        :asid  => "@{params[:click]}@",
        :idfa  => "@{event.adid}@",
        :ip    => "@{event.ip}@",
        :ssk   => "@{netcfg.ssk}@"
      },
      :check => "!event.adid.nil?"
    }
  end

end

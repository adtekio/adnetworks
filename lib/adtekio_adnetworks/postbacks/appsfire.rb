class AdtekioAdnetworks::Postbacks::Appsfire < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:appid,:source]
  end

  define_postback_for :all, :mac do
    { :url => "http://getap.ps/callback.php",
      :params => {
        :appid  => "@{netcfg.appid}@",
        :idfa   => "@{event.adid}@",
        :ip     => "@{event.ip}@",
        :source => "@{netcfg.source}@"
      },
    }
  end

end

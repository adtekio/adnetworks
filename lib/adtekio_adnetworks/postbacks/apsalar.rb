class AdtekioAdnetworks::Postbacks::Apsalar < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:a,:package_name]
  end

  define_postback_for :ios, :mac do
    { :url => "http://api.apsalar.com/api/v1/launch",
      :params => {
        :a    => "@{netcfg.a}@",
        :i    => "@{netcfg.package_name}@",
        :idfa => "@{event.adid}@",
        :ip   => "@{event.ip}@",
        :p    => "iOS"
      },
      :check => "!event.adid.nil?"
    }
  end

end

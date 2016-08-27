class AdtekioAdnetworks::Postbacks::FiksuApplift < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_name,:appid,:company_id,:package_name]
  end

  define_postback_for :ios, :ist do
    { :url => "https://a.fiksu.com/@{netcfg.company_id}@/ios/@{netcfg.package_name}@/event",
      :params => {
        :a_id           => "@{event.adid}@",
        :app_name       => "@{netcfg.app_name}@",
        :appid          => "@{netcfg.appid}@",
        :clientid       => "@{client_id}@",
        :country        => "@{event.country}@",
        :device         => "@{params[:device]}@",
        :event          => "launch",
        :gmtoffset      => "0",
        :ip_address     => "@{event.ip}@",
        :system_version => "@{params[:osversion]}@",
        :timezone       => "utc",
        :uploaded_at    => "@{event.time.strftime('%Y-%m-%d %H:%M:%S 0000')}@"
      },
    }
  end

  def client_id
    UUIDTools::UUID.
      parse_hexdigest(event.params[:mid] || event.adid || "").to_s
  end
end

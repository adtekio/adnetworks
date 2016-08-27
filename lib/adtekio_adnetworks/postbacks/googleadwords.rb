class AdtekioAdnetworks::Postbacks::Googleadwords < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_id,:label]
  end

  define_postback_for :all, :mac do
    { :url => "https://www.googleadservices.com/pagead/conversion/@{netcfg.app_id}@/",
      :params => {
        :label    => "@{netcfg.label}@",
        :muid     => "@{muidify(event.adid)}@",
        :bundleid => "@{event.bundleid}@",
        :idtype   => "@{event.adid}@"
      },
    }
  end

end

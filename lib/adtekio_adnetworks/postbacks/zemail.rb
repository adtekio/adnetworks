class AdtekioAdnetworks::Postbacks::Zemail < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:axid, :gmid]
  end

  define_postback_for :all, :mac do
    { :url => "http://gztkr.mobi/",
      :params => {
        :gmid => "@{netcfg.gmid}@",
        :axid => "@{netcfg.axid}@",
        :cxt  => "s2s",
        :uxid => "@{params[:click]}@"
      },
    }
  end

end

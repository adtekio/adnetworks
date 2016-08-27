class AdtekioAdnetworks::Postbacks::Pandora < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:app_id,:company_name]
  end

  define_postback_for :all, :mac do
    { :url => ("http://stats.pandora.com/tracking/@{netcfg.app_id}@"+
               "/type::ad_tracking_pixel/ctype::@{netcfg.company_name}@"+
               "/etype::appinstall/oid::@{params[:click]}@"+
               "/aid::@{params[:adgroup]}@/cid::@{params[:ad]}@"),
      :params => {
      },
    }
  end
end

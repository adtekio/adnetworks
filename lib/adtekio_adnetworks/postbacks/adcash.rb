class AdtekioAdnetworks::Postbacks::Adcash < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:campagne,:idform,:key]
  end

  define_postback_for :ios, :mac do
    { :url => "http://www.adcash.com/script/register_event.php",
      :params => {
        :campagne => "@{netcfg.campagne}@",
        :cid      => "@{params[:click]}@",
        :idform   => "@{netcfg.idform}@",
        :key      => "@{netcfg.key}@",
        :variable => "@{sha1(params[:mid])}@"
      },
    }
  end
end

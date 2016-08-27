class AdtekioAdnetworks::Postbacks::TrademobMagicSolver < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:partner_id]
  end

  define_postback_for :ios, :mac do
    { :url => "http://api.magicsolver.com/iphone/apps/free_app_magic/register_udid/",
      :params => {

      },
      :post => {
        :partner_id => "@{netcfg.partner_id}@",
        :udid       => "@{event.uuid}@",
        :lang       => "",
        :locale     => "@{params[:locale]}@"
      },
    }
  end

end

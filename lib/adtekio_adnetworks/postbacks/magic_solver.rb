class AdtekioAdnetworks::Postbacks::MagicSolver < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://api.magicsolver.com/iphone/apps/free_app_magic/register_idfa/get/",
      :params => {
        :idfa      => "@{event.adid}@",
        :partnerID => "@{params[:partner_data]}@"
      },

    }
  end

end

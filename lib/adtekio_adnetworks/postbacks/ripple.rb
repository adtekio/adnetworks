class AdtekioAdnetworks::Postbacks::Ripple < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:appname]
  end

  define_postback_for :ios, :mac do
    { :url => "http://ripple.ad/tracker/apps/@{netcfg.appname}@/conversion_feedback.php",
      :params => {
        :aff_sub  => "@{params[:click]}@",
        :aff_sub2 => "@{params[:partner_data]}@"
      },

    }
  end

end

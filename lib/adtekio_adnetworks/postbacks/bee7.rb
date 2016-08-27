class AdtekioAdnetworks::Postbacks::Bee7 < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:company]
  end

  define_postback_for :all, :mac do
    { :url => "https://api.bee7.com/rest/advertiser/v1/trackers/@{netcfg.company}@",
      :params => {
        :data => "@{params[:click]}@"
      },

    }
  end

end

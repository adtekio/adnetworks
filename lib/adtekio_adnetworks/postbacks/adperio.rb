class AdtekioAdnetworks::Postbacks::Adperio < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:programid]
  end

  define_postback_for :all, :mac do
    { :url => "http://www.media970.com/cevent",
      :params => {
        :programid   => "@{netcfg.programid}@",
        :type        => "lead",
        :visitor_cid => "@{params[:click]}@"
      },

    }
  end

end

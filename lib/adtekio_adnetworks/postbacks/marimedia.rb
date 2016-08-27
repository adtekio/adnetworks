class AdtekioAdnetworks::Postbacks::Marimedia < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:adv_id]
  end

  define_postback_for :ios, :mac do
    { :url => "http://tracking.taptica.com/aff_lsr",
      :params => {
        :tt_cid     => "@{params[:click]}@",
        :tt_adv_id  => "@{netcfg.adv_id}@",
        :tt_adv_sub => "@{event.adid}@",
        :tt_time    => "@{event.time.strftime('%Y-%m-%d %H:%M:%S.000')}@"
      },

    }
  end

end

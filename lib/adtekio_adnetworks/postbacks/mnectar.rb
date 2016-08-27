class AdtekioAdnetworks::Postbacks::Mnectar < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:acid]
  end

  define_postback_for :all, :mac do
    { :url => "http://ads.mnectar.com/a/v1/open",
      :params => {
        :acid    => "@{netcfg.acid}@",
        :auid    => "@{params[:partner_data]}@",
        :clickid => "@{params[:click]}@",
        :rip     => "@{event.ip}@",
        :s       => "adx",
        :ts      => "@{event.time.to_i}@"
      },

    }
  end

end

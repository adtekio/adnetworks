class AdtekioAdnetworks::Postbacks::Roostr < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://trk.roostr.network/aff_lsr",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },

    }
  end

end

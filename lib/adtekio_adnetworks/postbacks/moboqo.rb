class AdtekioAdnetworks::Postbacks::Moboqo < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://tracking.moboqo.com/aff_lsr",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },

    }
  end

end

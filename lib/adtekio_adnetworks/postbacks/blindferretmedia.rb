class AdtekioAdnetworks::Postbacks::Blindferretmedia < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://tracking.blindferretmedia.com/aff_lsr",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },

    }
  end

end

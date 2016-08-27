class AdtekioAdnetworks::Postbacks::Ginga < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://ginga.go2cloud.org/aff_lsr",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },

    }
  end

  define_postback_for :android, :mac do
    { :url => "http://ginga.go2cloud.org/aff_lsr",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },

    }
  end

end

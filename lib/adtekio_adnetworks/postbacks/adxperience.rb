class AdtekioAdnetworks::Postbacks::Adxperience < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://adxperience.go2cloud.org/aff_lsr",
      :params => {
        :transaction_id => "@{params[:click]}@"
      },
    }
  end

end

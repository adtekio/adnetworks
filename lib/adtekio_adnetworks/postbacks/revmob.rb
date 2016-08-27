class AdtekioAdnetworks::Postbacks::Revmob < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "https://s2s.revmob.com/api/v4/conversion/@{params[:click]}@/@{params[:partner_data]}@/conversion.json",
      :params => {

      },

    }
  end

end

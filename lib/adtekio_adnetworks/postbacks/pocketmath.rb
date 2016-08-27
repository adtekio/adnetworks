class AdtekioAdnetworks::Postbacks::Pocketmath < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "https://conversions.pocketmath.com/callback/v1/conversion",
      :params => {
        :imp_id => "@{params[:click]}@"
      },

    }
  end

end

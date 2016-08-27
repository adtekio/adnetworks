class AdtekioAdnetworks::Postbacks::Adstract < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://t.adk2.com/conversion/@{params[:click]}@",
      :params => {
      },
    }
  end

end

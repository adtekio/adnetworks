class AdtekioAdnetworks::Postbacks::Jestadigital < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://t.yieldr.net/install/",
      :params => {
        :transactionid => "@{params[:mid]}@",
        :ydrid         => "@{params[:click]}@"
      },

    }
  end

end

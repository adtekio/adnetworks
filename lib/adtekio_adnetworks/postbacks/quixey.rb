class AdtekioAdnetworks::Postbacks::Quixey < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:company_name]
  end

  define_postback_for :all, :mac do
    { :url => "http://d.quixey.com/1.0/e/@{netcfg.company_name}@/@{params[:click]}@",
      :params => {
        :p => "@{params[:adgroup]}@"
      },
      :check => "!event.params[:click].nil?"
    }
  end

end

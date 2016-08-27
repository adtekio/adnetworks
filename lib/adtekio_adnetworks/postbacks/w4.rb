class AdtekioAdnetworks::Postbacks::W4 < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:sid]
  end

  define_postback_for :ios, :mac do
    { :url => "https://affiliate.trk4.com/rd/px.php",
      :params => {
        :hid     => "@{params[:click]}@",
        :sid     => "@{netcfg.sid}@",
        :transid => "@{sha1(params[:mid])}@"
      },
    }
  end
end

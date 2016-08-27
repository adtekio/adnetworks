class AdtekioAdnetworks::Postbacks::Operamedia < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => "http://www.mobileitmedia.in/tl.php",
      :params => {
        :s2s     => "",
        :transid => "@{params[:click]}@"
      },
      :store_user => true
    }
  end

  define_postback_for :ios, :fun do
    { :url => "http://www.mobileitmedia.in/events.php",
      :params => {
        :transid => "@{user.click_data[:click]}@",
        :var1    => "tutorial"
      },
      :user_required => true,
      :check => "event.params[:funnel_step] == 'open_tutorial'"
    }
  end

  define_postback_for :ios, :pay do
    { :url => "http://www.mobileitmedia.in/events.php",
      :params => {
        :transid => "@{user.click_data[:click]}@",
        :var2    => "purchase"
      },
      :user_required => true
    }
  end

end

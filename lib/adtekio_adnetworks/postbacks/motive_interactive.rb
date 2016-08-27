class AdtekioAdnetworks::Postbacks::MotiveInteractive < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    [:o]
  end

  define_postback_for :android, :mac do
    { :url => "http://traktum.com/p.ashx",
      :params => {
        :o => "@{netcfg.o}@",
        :f => "pb",
        :r => "@{params[:click]}@",
        :t => "@{event.gadid}@"
      },

    }
  end

  define_postback_for :ios, :mac do
    { :url => "http://traktum.com/p.ashx",
      :params => {
        :o => "@{netcfg.o}@",
        :f => "pb",
        :r => "@{params[:click]}@",
        :t => "@{event.adid}@"
      },

    }
  end

end

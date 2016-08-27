class AdtekioAdnetworks::Postbacks::Jumptap < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :all, :mac do
    { :url => "http://sa.jumptap.com/a/conversion",
      :params => :compute_params
    }
  end

  def compute_params
    if event.adid
      { :idfa => event.adid }
    elsif event.uuid
      { :hid => event.uuid }
    else
      { :hid_sha1 => sha1(params[:mid]) }
    end.merge( {:app => event.bundleid, :event => "download" })
  end
end

class AdtekioAdnetworks::Postbacks::Applifier < AdtekioAdnetworks::BasePostbackClass
  include AdtekioAdnetworks::BasePostbacks

  define_network_config do
    []
  end

  define_postback_for :ios, :mac do
    { :url => ("https://impact.applifier.com/games/@{params[:partner_data]}@"+
               "/install"),
      :params => {
        :advertisingTrackingId => "@{event.adid.try(:upcase)}@"
      },
      :check => :ios_mac_check
    }
  end

  define_postback_for :android, :mac do
    { :url => ("https://impact.applifier.com/games/@{params[:partner_data]}@"+
               "/install"),
      :params => :compute_params,
      :check => :android_mac_check
    }
  end

  def android_mac_check
    !event.params[:partner_data].blank? &&
      (!event.params[:android_id].blank? || !event.gadid.blank? ||
       !event.params[:click].blank?)
  end

  def ios_mac_check
    !event.adid.nil? && !event.params[:partner_data].nil?
  end

  def compute_params
    if event.gadid.blank? && !event.params[:android_id].blank?
      { :androidId => event.params[:android_id] }
    elsif !params[:click].blank?
      { :advertisingTrackingId => params[:click] }
    elsif !event.gadid.blank? && event.params[:android_id].blank?
      { :advertisingTrackingId => event.gadid.try(:downcase) }
    else
      { :advertisingTrackingId => event.gadid.try(:downcase),
        :androidId => event.params[:android_id]
      }
    end
  end
end

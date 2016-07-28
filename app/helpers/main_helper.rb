module MainHelper
  def pad_type_select
    [
      ['Standart', MySettings.format_standard_class],
      ['Fullscreen', MySettings.format_fullscreen_class],
      ['Native', MySettings.format_native_class],
      ['Video', MySettings.format_video_class]
    ]
  end
end

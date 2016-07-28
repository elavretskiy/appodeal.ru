module MainHelper
  def group_link
    "#{MySettings.instance.group_link}"
  end

  def pad_type_select
    settings = MySettings.instance
    [
      ['Standart', settings.format_standard_class],
      ['Fullscreen', settings.format_fullscreen_class],
      ['Native', settings.format_native_class],
      ['Video', settings.format_video_class]
    ]
  end
end

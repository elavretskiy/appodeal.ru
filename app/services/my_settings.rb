class MySettings
  @groups = []
  @home_link = 'https://target.my.com/'
  @groups_link = 'https://target.my.com/pad_groups/'
  @pads_link = 'https://target.my.com/pads/'
  @login_page_class = '.js-head-log-in'
  @signin_btn_class = '.js-auth-signin'
  @group_links_class = 'a.js-pad-groups-label'
  @pad_links_class = 'a.js-pads-list-label'
  @slot_id_class = '.js-slot-id'
  @groups_wrapper_class = '.js-pad-groups-list-wrapper'
  @pads_wrapper_class = '.js-pads-list-wrapper'
  @slot_id_wrapper_class = '.js-param-block-wrap'
  @format_standard_class = '.format-item__image_standard'
  @format_fullscreen_class = '.format-item__image_fullscreen'
  @format_native_class = '.format-item__image_native'
  @format_video_class = '.format-item__image_rewarded_video'
  @pad_save_btn_class = '.js-save-button'
  @pad_title_field_class = 'input.js-adv-block-field'
  @wait_load_wrapper_time = 60

  class << self
    attr_accessor :groups, :login, :password, :home_link, :pad_title_field_class,
                  :login_page_class, :signin_btn_class, :group_links_class,
                  :pad_links_class, :slot_id_class, :groups_wrapper_class,
                  :pads_wrapper_class, :wait_load_wrapper_time, :groups_link,
                  :slot_id_wrapper_class, :pad_save_btn_class, :pads_link,
                  :format_standard_class, :format_fullscreen_class,
                  :format_native_class, :format_video_class

    def group_link(id)
      groups_link + id
    end

    def pad_link(id)
      pads_link + id
    end

    def pad_create_link(id)
      groups_link + id + '/create'
    end
  end
end

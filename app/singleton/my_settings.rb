require 'singleton'

class MySettings
  include Singleton

  attr_accessor :groups, :login, :password, :home_link, :pad_title_field_class,
                :login_page_class, :signin_btn_class, :group_links_class,
                :pad_links_class, :slot_id_class, :groups_wrapper_class,
                :pads_wrapper_class, :wait_load_wrapper_time, :groups_link,
                :slot_id_wrapper_class, :pad_save_btn_class, :pads_link,
                :format_standard_class, :format_fullscreen_class,
                :format_native_class, :format_video_class

  def initialize
    self.groups = []
    self.home_link = 'https://target.my.com/'
    self.groups_link = 'https://target.my.com/pad_groups/'
    self.pads_link = 'https://target.my.com/pads/'
    self.login_page_class = '.js-head-log-in'
    self.signin_btn_class = '.js-auth-signin'
    self.group_links_class = 'a.js-pad-groups-label'
    self.pad_links_class = 'a.js-pads-list-label'
    self.slot_id_class = '.js-slot-id'
    self.groups_wrapper_class = '.js-pad-groups-list-wrapper'
    self.pads_wrapper_class = '.js-pads-list-wrapper'
    self.slot_id_wrapper_class = '.js-param-block-wrap'
    self.format_standard_class = '.format-item__image_standard'
    self.format_fullscreen_class = '.format-item__image_fullscreen'
    self.format_native_class = '.format-item__image_native'
    self.format_video_class = '.format-item__image_rewarded_video'
    self.pad_save_btn_class = '.js-save-button'
    self.pad_title_field_class = 'input.js-adv-block-field'
    self.wait_load_wrapper_time = 60
  end

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

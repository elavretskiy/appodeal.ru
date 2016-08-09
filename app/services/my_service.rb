require 'capybara/poltergeist'
require 'capybara'
require 'capybara/dsl'

class MyService
  include Capybara::DSL

  def initialize(params = {})
    MySettings.login = params[:login] if params && params[:login]
    MySettings.password = params[:password] if params && params[:password]

    @login =  MySettings.login
    @password = MySettings.password
    @groups = []
  end

  def login
    Rails.logger.info "Вход в систему #{Time.current}"
    visit MySettings.home_link
    return unless has_css?(MySettings.login_page_class)
    find(MySettings.login_page_class).click
    find('input[name="login"]').set(@login)
    find('input[name="password"]').set(@password)
    find(MySettings.signin_btn_class).click
  end

  def get_groups
    Rails.logger.info "Получение групп #{Time.current}"
    visit MySettings.groups_link
    return [] if has_css?(MySettings.signin_btn_class)
    wait_for_wrapper(MySettings.groups_wrapper_class)
    @groups = all(MySettings.group_links_class).map { |group| { id: group[:href].split('/').pop(), title: group.text } }
  end

  def get_pads(groups = nil)
    Rails.logger.info "Получение блоков #{Time.current}"
    (groups || @groups).each { |group| group[:pads] = parse_pads(MySettings.group_link(group[:id])) }
  end

  def get_slots(groups = nil)
    Rails.logger.info "Получение слотов #{Time.current}"
    (groups || @groups).each { |group| group[:pads].each { |pad| pad[:slot_id] = parse_slot_id(MySettings.pad_link(pad[:id])) } }
    to_hash(groups)
  end

  def create_pad(params)
    Rails.logger.info "Создание блока #{Time.current}"
    visit MySettings.pad_create_link(params[:group])
    wait_for_wrapper(MySettings.pad_title_field_class)
    find(MySettings.pad_title_field_class).set(params[:title])
    find(params[:type]).click
    find(MySettings.pad_save_btn_class).click
    wait_for_wrapper(MySettings.pads_wrapper_class)
  end

  def set_groups
    MySettings.groups = @groups
  end

  def set_pads(groups, group)
    MySettings.groups[group][:pads] = groups[group][:pads]
  end

  private

  def parse_pads(link)
    visit link
    wait_for_wrapper(MySettings.pads_wrapper_class)
    all(MySettings.pad_links_class).map { |group| { id: group[:href].split('/').pop(), title: group.text } }
  end

  def parse_slot_id(link)
    visit link
    wait_for_wrapper(MySettings.slot_id_wrapper_class)
    find(MySettings.slot_id_class).text.split(' ')[1]
  end

  def wait_for_wrapper(wrapper)
    Capybara.using_wait_time(MySettings.wait_load_wrapper_time) { page.find(wrapper) }
  end

  def to_hash(groups = nil)
    hash = Hash[*(groups || @groups).map { |group| [group[:id], group] }.flatten ]
    groups ? hash : (@groups = hash)
  end
end

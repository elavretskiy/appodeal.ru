require 'capybara/poltergeist'
require 'capybara'
require 'capybara/dsl'
require 'my_settings'

class MyService
  include Capybara::DSL

  def initialize
    @settings = MySettings.instance

    Capybara.default_driver = :poltergeist
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false)
    end
  end

  def login(params = {})
    Rails.logger.info "Вход в систему #{Time.current}"
    set_login_password(params)
    visit @settings.home_link
    return unless has_css?(@settings.login_page_class)
    find(@settings.login_page_class).click
    find('input[name="login"]').set(@settings.login)
    find('input[name="password"]').set(@settings.password)
    find(@settings.signin_btn_class).click
  end

  def get_groups
    Rails.logger.info "Получение групп #{Time.current}"
    visit @settings.groups_link
    return [] if has_css?(@settings.signin_btn_class)
    wait_for_wrapper(@settings.groups_wrapper_class)
    all(@settings.group_links_class).map { |group| { id: group[:href].split('/').pop(), title: group.text } }
  end

  def get_pads(groups)
    Rails.logger.info "Получение блоков #{Time.current}"
    groups.each { |group| group[:pads] = parse_pads(@settings.group_link(group[:id])) }
  end

  def get_slot_id(groups)
    Rails.logger.info "Получение slot_id #{Time.current}"
    groups.each { |group| group[:pads].each { |pad| pad[:slot_id] = parse_slot_id(@settings.pad_link(pad[:id])) } }
    to_hash(groups)
  end

  def create_pad(params)
    Rails.logger.info "Создание блока #{Time.current}"
    visit @settings.pad_create_link(params[:group])
    wait_for_wrapper(@settings.pad_title_field_class)
    find(@settings.pad_title_field_class).set(params[:title])
    find(params[:type]).click
    find(@settings.pad_save_btn_class).click
    wait_for_wrapper(@settings.pads_wrapper_class)
  end

  private

  def set_login_password(params)
    return unless params
    @settings.login = params[:login] if params[:login]
    @settings.password = params[:password] if params[:password]
  end

  def parse_pads(link)
    visit link
    wait_for_wrapper(@settings.pads_wrapper_class)
    all(@settings.pad_links_class).map { |group| { id: group[:href].split('/').pop(), title: group.text } }
  end

  def parse_slot_id(link)
    visit link
    wait_for_wrapper(@settings.slot_id_wrapper_class)
    find(@settings.slot_id_class).text.split(' ')[1]
  end

  def wait_for_wrapper(wrapper)
    Capybara.using_wait_time(@settings.wait_load_wrapper_time) { page.find(wrapper) }
  end

  def to_hash(groups)
    Hash[*groups.map { |group| [group[:id], group] }.flatten ]
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    evaluate_script('jQuery.active').zero?
  end
end

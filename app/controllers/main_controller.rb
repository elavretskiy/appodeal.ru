require 'my_settings'

class MainController < ApplicationController
  before_action :set_groups, only: [:index, :create_pad]

  def index
  end

  def load_data
    my = MyService.new
    my.login(my_params)
    groups = my.get_groups
    pads = my.get_pads(groups)
    groups = my.get_slot_id(pads)
    MySettings.instance.groups = groups
    @notice = 'Данные успешно загружены'
  rescue Exception => e
    @alert = e.message
  ensure
    @groups = MySettings.instance.groups
  end

  def create_pad
    my = MyService.new
    my.login
    my.create_pad(pad_params)
    @notice = 'Блок успешно создан'
  rescue Exception => e
    @alert = e.message
  ensure
    @group = pad_params[:group]
  end

  def load_pads
    my = MyService.new
    my.login
    group = params[:group]
    groups = [{ id: group }]
    pads = my.get_pads(groups)
    groups = my.get_slot_id(pads)
    MySettings.instance.groups[group][:pads] = groups[group][:pads]
    @notice = 'Блоки успешно загружены'
  rescue Exception => e
    @alert = e.message
  ensure
    @group = [params[:group], MySettings.instance.groups[params[:group]]]
  end

  private

  def set_groups
    @groups = MySettings.instance.groups || []
  end

  def my_params
    params.require(:my).permit(:login, :password)
  end

  def pad_params
    params.require(:pad).permit(:title, :type, :group)
  end
end

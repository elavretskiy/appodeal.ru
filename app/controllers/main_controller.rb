require 'my_settings'

class MainController < ApplicationController
  before_action :my_login, only: [:load_data, :create_pad, :load_pads]

  def index
    @groups = MySettings.instance.groups || []
  end

  def load_data
    groups = @my.get_groups
    pads = @my.get_pads(groups)
    groups = @my.get_slot_id(pads)
    MySettings.instance.groups = groups
    @notice = 'Данные успешно загружены'
  rescue Exception => e
    @alert = e.message
  ensure
    @groups = MySettings.instance.groups
  end

  def create_pad
    @my.create_pad(pad_params)
    @notice = 'Блок успешно создан'
  rescue Exception => e
    @alert = e.message
  ensure
    @group = pad_params[:group]
  end

  def load_pads
    group = params[:group]
    groups = [{ id: group }]
    pads = @my.get_pads(groups)
    groups = @my.get_slot_id(pads)
    MySettings.instance.groups[group][:pads] = groups[group][:pads]
    @notice = 'Блоки успешно загружены'
  rescue Exception => e
    @alert = e.message
  ensure
    @group = [params[:group], MySettings.instance.groups[params[:group]]]
  end

  private

  def my_params
    params.require(:my).permit(:login, :password)
  end

  def pad_params
    params.require(:pad).permit(:title, :type, :group)
  end

  def my_login
    @my = MyService.new
    params[:my] ? @my.login(my_params) : @my.login
  end
end

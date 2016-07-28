class MainController < ApplicationController
  before_action :my_login, only: [:load_data, :create_pad, :load_pads]

  def index
    @groups = MySettings.groups || []
  end

  def load_data
    @my.get_groups
    @my.get_pads
    @my.get_slots
    @my.set_groups
    @notice = 'Данные успешно загружены'
  rescue Exception => e
    @alert = e.message
  ensure
    @groups = MySettings.groups
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
    pads = @my.get_pads([{ id: params[:group] }])
    groups = @my.get_slots(pads)
    @my.set_pads(groups, params[:group])
    @notice = 'Блоки успешно загружены'
  rescue Exception => e
    @alert = e.message
  ensure
    @group = [params[:group], MySettings.groups[params[:group]]]
  end

  private

  def my_params
    params.require(:my).permit(:login, :password)
  end

  def pad_params
    params.require(:pad).permit(:title, :type, :group)
  end

  def my_login
    @my = params[:my] ? MyService.new(my_params) : MyService.new
    @my.login
  end
end

class BasesController < ApplicationController
  
  before_action :admin_user, only: [:index, :new, :edit, :update, :create, :destroy]
  before_action :log_in_user, only: [:index, :new, :edit, :update, :create, :destroy]
  def index
    @bases = Base.all
  end
  
  def new
    @base = Base.new
  end
  
  def edit
    @base = Base.find(params[:id])
  end
  
  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(params_base)
      flash[:success] = "更新に成功しました。"
      redirect_to bases_url and return
    else
      flash[:info] = @base.errors.full_messages.join("、")
      redirect_to bases_url
    end
  end
  
  
  
  def create
    @base = Base.new(params_base)
    if @base.save
      flash[:success] = "拠点の新規作成に成功しました。"
      redirect_to bases_url and return
    else
      flash[:danger] = @base.errors.full_messages.join("、")
      redirect_to bases_url
    end
  end
  
  def destroy
    @base = Base.find(params[:id])
    if @base.destroy
      flash[:success] = "#{@base.base_name}を削除しました。"
      redirect_to bases_url and return
    else
      flash[:danger] = "#{@base.base_name}の削除に失敗しました。"
      redirect_to bases_url
    end
  end
  
  private
    def params_base
      params.require(:base).permit(:base_number, :base_name, :kind)
    end
end

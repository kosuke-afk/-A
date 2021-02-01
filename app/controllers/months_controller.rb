class MonthsController < ApplicationController
  before_action :set_userid, only: :create
  def create
    if params[:month][:one_month_instructor].nil?
      flash[:info] = "上長を選択してください。"
      redirect_to @user and return
    else
      params[:month][:year] = params[:data][0..3].to_i
      params[:month][:month] = params[:data][6...7].to_i
      @one_month_request = Month.find_by(year: params[:month][:year], month: params[:month][:month], 
                                       one_month_confirmation: "申請中" ,user_id: params[:user_id])
      if @one_month_request.nil?
        params[:month][:one_month_confirmation] = "申請中"
        @month = @user.months.create(params_month)
        flash[:success] = "一ヶ月の勤怠申請をしました。"
        redirect_to @user and return
      elsif @one_month_request.present?
        flash[:info] = if  @one_month_request.one_month_confirmation == "申請中"
                        "すでに申請中です"
                       else
                         "すでに承認済みですです"
                       end
        redirect_to @user
      end
    end
  end
  
  private
    
    def params_month
      params.require(:month).permit(:one_month_instructor, :one_month_confirmation, :year, :month)
    end
end

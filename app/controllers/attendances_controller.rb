class AttendancesController < ApplicationController
  
  before_action :set_user, only: [:edit_one_month,:update_one_month]
  before_action :set_userid, only: :update
  before_action :log_in_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month, :update_one_month]
  before_action :admin_or_correct_user, only: [:update,:edit_one_month, :update_one_month]
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    @attendance = @user.attendances.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        if item[:started_at].present? && item[:finished_at].blank?
          flash[:danger] = "退社時間が必要です。"
          redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
        end
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "一ヶ月分のデータを更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあったため、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
  end
  
  def over_time
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:attendance_id])
  end
  
  def update_over_time
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:attendance_id])
    if @attendance.update_attributes(params_over_time)
        flash[:success] = "残業申請を行いました。"
        redirect_to @user
    else
      flash[:danger] = "残業申請に失敗しました。<br>" + @attendance.errors.full_messages.join("<br>")
      redirect_to @user
    end
  end
  
  private
    
    def attendances_params
      params.require(:user).permit(attendances: [ :started_at, :finished_at, :note])[:attendances]
    end
    
    def set_userid
      @user = User.find(params[:user_id])
    end
   
   def params_over_time
     params.require(:attendance).permit(:finish_time, :aim, :instructor)
   end
end

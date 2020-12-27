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
    @instructor = User.where(instructor_user: true).where.not(id: @user.id)
  end
  
  def update_over_time
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:attendance_id])
    if params[:attendance][:finish_time].present? && params[:attendance][:aim].present? && params[:attendance][:instructor].present?
      if @attendance.update_attributes(params_over_time)
        @attendance.update_attributes(instructor_confirmation: "申請中")
        flash[:success] = "残業申請を申請しました。"
        redirect_to @user
      end
    else
      flash[:danger] = "申請に必要な項目が漏れています。"
      redirect_to @user
    end
  end
  
  def over_time_approval
    @user = User.find(params[:id])
    # @over_time_users = User.joins(:attendances)
    #                       .select('users.*, attendances.*')
    #                       .where(attendances: {instructor: @user.name, instructor_confirmation: "申請中"})
    @over_time_attendances = Attendance.where(attendances: {instructor: @user.name, instructor_confirmation: "申請中"})
                                       .order(:user_id).group_by(&:user_id)
    @attendance = Attendance.new
  end
  
  def update_over_time_approval
   @user = User.find(params[:id])
   ActiveRecord::Base.transaction do
     n1 = 0 
     n2 = 0
     n3 = 0
     params_approval.each do |id, item|
       if (item[:change] == "1") && (item[:instructor_confirmation] != "申請中")
         @attendance = Attendance.find(id)
         if item[:instructor_confirmation] = "承認"
           n1 = n1 + 1 # n1 += 1, n1 ++
         elsif item[:instructor_confirmation] = "否認"
           n2 = n2 + 1
         elsif item[:instructor_confirmation] = "なし"
           n3 = n3 + 1
           item[:change] = "0"
           item[:instructor_confirmation] = nil
           item[:instructor] = nil
         end
         @attendance.update_attributes!(item)
       end
     end
     if (n1 == 0) && (n2 == 0) && (n3 == 0)
       flash[:info] = "変更するにはテェックを入れてください。"
     else
       flash[:success] = "残業申請を#{n1}件承認、#{n2}件否認、#{n3}件なしに変更しました。"
     end
     redirect_to @user
   rescue ActiveRecord::RecordInvald
     flash[:danger] = "残業申請の変更をやり直してください。"
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
     params.require(:attendance).permit(:finish_time, :next_day, :aim, :instructor)
   end
   
   def params_approval
     params.require(:user).permit(attendances: [ :instructor_confirmation,:change,:instructor])[:attendances]
   end
end

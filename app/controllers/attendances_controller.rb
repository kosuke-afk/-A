class AttendancesController < ApplicationController
  
  before_action :set_user, only: [:edit_one_month,:update_one_month, :over_time_approval, :update_over_time_approval, :attendance_approval, :update_attendance_approval]
  before_action :set_userid, only: [:update]
  before_action :set_user_id_attendance_id, only: [:over_time, :update_over_time]
  before_action :log_in_user, only: [:update, :edit_one_month, :update_one_month, :over_time, :update_over_time, :over_time_approval,
                                     :update_over_time_approval, :attendance_approval, :update_attendance_approval]
  before_action :set_one_month, only: [:edit_one_month, :update_one_month]
  before_action :admin_or_correct_user, only: [:update,:edit_one_month, :update_one_month]
  before_action :correct_user, only: [:over_time,:update_over_time, :over_time_approval, :update_over_time_approval, :attendance_approval,
                                      :update_attendance_approval]
  
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
    @instructor = User.where(instructor_user: true).where.not(name: @user.name)
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      n1 = 0
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if (item[:attendance_instructor].present?) || (item[:started_at_temporary].present?) || (item[:finished_at_temporary].present?)
          if (item[:attendance_instructor].blank?) || (item[:started_at_temporary].blank?) || (item[:finished_at_temporary].blank?)
            flash[:info] = "出勤時間、退勤時間、申請先の上長を入力してください。"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
          else
            attendance.update_attributes!(item)
            attendance.update_attributes(attendance_confirmation: "申請中")
            n1 += 1
          end
        end
      end
      if n1 == 0
        flash[:info] = "更新するデータがありません"
      elsif n1 >= 1
        flash[:info] = "#{n1}件の勤怠編集を申請しました。"
      end
      redirect_to user_url(date: params[:date]) and return
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効な入力データがあったため、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
    end
  end
  
  def over_time
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
  end
  
  def update_over_time_approval
   @user = User.find(params[:id])
   ActiveRecord::Base.transaction do
     n1 = 0 
     n2 = 0
     n3 = 0
     params_over_time_approval.each do |id, item|
       if (item[:change] == "1") && (item[:instructor_confirmation] != "申請中")
         @attendance = Attendance.find(id)
         if item[:instructor_confirmation] == "承認"
           n1 = n1 + 1 # n1 += 1, n1 ++
         elsif item[:instructor_confirmation] == "否認"
           n2 = n2 + 1
         elsif item[:instructor_confirmation] == "なし"
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
  
  def attendance_approval
    @attendances = Attendance.where(attendance_confirmation: "申請中", attendance_instructor: @user.name)
                             .group_by(&:user_id)
  end
  
  def update_attendance_approval
    ActiveRecord::Base.transaction do
      n1 = 0
      n2 = 0
      n3 = 0
      n4 = 0
      params_attendance_approval.each do |id, item|
        if (item[:attendance_change] == "1" )
          if (item[:attendance_confirmation] != "")
            @attendance = Attendance.find(id)
            if item[:attendance_confirmation] == "承認"
              n1 += 1
              item[:started_at] = @attendance.started_at_temporary
              item[:finished_at] = @attendance.finished_at_temporary
              item[:attendance_change] = nil
              item[:started_at_temporary] = nil
              item[:finished_at_temporary] = nil
            elsif item[:attendance_confirmation] == "否認"
              n2 += 1
              item[:started_at_temporary] = nil
              item[:finished_at_temporary] = nil
              item[:attendance_change] = nil
            elsif item[:attendance_confirmation] == "なし"
              n3 += 1
              item[:attendance_confirmation] = nil
              item[:attendance_change] = nil
              item[:attendance_instructor] = nil
              item[:started_at_temporary] = nil
              item[:finished_at_temporary] = nil
            end
            @attendance.update_attributes!(item)
          else
            n4 += 1
          end
        else
          n4 += 1
        end
      end
      if (n4 >= 1) && ((n1 >= 1) || (n2 >= 1) || (n3 >= 1))
        flash[:info] = "変更にテェックを入れて、承認、否認、なしを選択してください。#{n1}件の承認、#{n2}件の否認、#{n3}件のなしに変更しました。"
      elsif (n1 >= 1) || (n2 >= 1) || (n3 >= 1)
        flash[:info] = "#{n1}件の承認、#{n2}件の否認、#{n3}件のなしに変更しました。"
      elsif (n4 >= 1)
        flash[:info] = "変更にテェックを入れて、承認、否認、なしを選択してください。"
      end
      redirect_to user_url(@user)
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "勤怠申請の変更をやり直してください"
      redirect_to @user
    end
  end
  
  private
    
    def attendances_params
      params.require(:user)
            .permit(attendances: [ :started_at_temporary, :finished_at_temporary, :attendance_instructor, 
                                   :attendance_confirmation, :note])[:attendances]
    end
    
    def set_userid
      @user = User.find(params[:user_id])
    end
    
    def set_user_id_attendance_id
      @user = User.find(params[:user_id])
      @attendance = @user.attendances.find(params[:attendance_id])
    end
   
    def params_over_time
      params.require(:attendance).permit(:finish_time, :next_day, :aim, :instructor)
    end
     
     
    def params_over_time_approval
      params.require(:user).permit(attendances: [ :instructor_confirmation,:change,:instructor])[:attendances]
    end
    
    def params_attendance_approval
      params.require(:user).permit(attendances: [:attendance_confirmation, :attendance_instructor, :attendance_change,:started_at, :finished_at,
                                                 :started_at_temporary, :finished_at_temporary])[:attendances]
    end
end

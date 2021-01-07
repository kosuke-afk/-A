class UsersController < ApplicationController
  require 'csv'
  
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :log_in_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_or_correct_user, only: [ :edit, :update]
  before_action :instructor_user_or_correct_user, only: :show
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @over_time = User.joins(:attendances).where(attendances: {instructor_confirmation: "申請中", instructor: @user.name})
    @attendance_edit = User.joins(:attendances)
                           .where(attendances: {attendance_confirmation: "申請中", attendance_instructor: @user.name})
    respond_to do |format|
      format.html
      format.csv do |csv|
        send_attendances_csv(@attendances)
      end
    end
  end
  
  def index
    @user = User.new
    @users = User.paginate(page: params[:page]).search(params[:search])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params_user)
    if @user.save
      log_in @user
      flash[:success] = "ユーザーを新規作成しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params_user)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to users_url
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
      redirect_to users_url
    else
      render :edit_basic_info
    end
  end
  
  
  
  private
  
    def params_user
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_start,:basic_finish,:work_time)
    end
    
    
    def admin_or_correct_user
      unless current_user.admin? || current_user?(@user)
        flash[:danger] = "権限がありません。"
        redirect_to root_url
      end
    end
    
    def send_attendances_csv(attendances)
      csv_data = CSV.generate do |csv|
        column_names = %w(日付 曜日 出社 退社)
        csv << column_names
        attendances.each do |attendance|
          if attendance.started_at.present? && attendance.finished_at.present?
            column_values = [
              l(attendance.worked_on, format: :short),
              $days_of_the_week[attendance.worked_on.wday],
              l(attendance.started_at, format: :time), 
              l(attendance.finished_at, format: :time)
            ]
          else 
            column_values = [
               l(attendance.worked_on, format: :short),
               $days_of_the_week[attendance.worked_on.wday]
               ]
          end
          csv << column_values
        end
      end
      send_data(csv_data, filename: "勤怠情報.csv")
    end
    
  
  
  
end

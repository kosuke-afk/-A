class UsersController < ApplicationController
  require 'csv'
  
  before_action :except_admin_user, only: :show
  before_action :set_user, only: [ :show, :edit, :update, :destroy]
  before_action :log_in_user, only: [:show, :edit, :update, :destroy, :basic_info, :basic_update, :working_index]
  before_action :admin_or_correct_user, only: [:edit, :update]
  before_action :admin_superior_or_correct_user, only: :show
  before_action :admin_user, only: [:index, :destroy, :basic_info, :basic_update, :working_index]
  before_action :admin_or_correct_user, only: [ :edit, :update]
  before_action :set_one_month, only: [:show]
  
  
  def show
    respond_to do |format|
      format.html do 
        @this_month_attendance = Month.find_by(year: @first_day.year, month: @first_day.month,
                                               one_month_confirmation: ["申請中","承認"], user_id: params[:id])
                                               
        @this_month_request = Month.where(months: {one_month_confirmation: "申請中", one_month_instructor: @user.name})
        @worked_sum = @attendances.where.not(started_at: nil).count
        @over_time = User.joins(:attendances).where(attendances: {instructor_confirmation: "申請中", instructor: @user.name})
        @attendance_edit = User.joins(:attendances)
                               .where(attendances: {attendance_confirmation: "申請中", attendance_instructor: @user.name})
        @one_month_instructor = User.where(superior: true)
                         .where.not(name: current_user.name)
        @one_month_attendance = Month.new
      end
    
      format.csv do |csv|
        send_attendances_csv(@attendances)
      end
    end
  end
  
  def index
    @users = User.where.not(admin: true).order(:id)
    # @users = User.where.not(admin: true)
  end
  
  def edit
  end
  
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params_user)
    if @user.save
      if !current_user.present?
        log_in(@user)
      else
        @user = current_user
      end
      flash[:success] = "ユーザーを新規作成しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  
  def update
    if @user.update_attributes(params_user)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to users_url
    else
      flash.now[:danger] = "ユーザー情報の更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  # def edit_basic_info
  # end
  
  # def update_basic_info
  #   if @user.update_attributes(basic_info_params)
  #     flash[:success] = "#{@user.name}の基本情報を更新しました。"
  #     redirect_to users_url
  #   else
  #     render :edit_basic_info
  #   end
  # end
  
  def import
    ActiveRecord::Base.transaction do
      if params[:file].present?
        if File.extname(params[:file].original_filename) == ".csv"
            CSV.foreach(params[:file].path, headers: true) do |row|
                @user = User.new
                @user.attributes = row.to_hash.slice(*updatable_attributes)
                @user.save!
            end
            flash[:success] = "新規作成しました。"
            redirect_to users_url and return
          # User.import(params[:file])
          # redirect_to users_url and return
        else
          flash[:info] = "ファイルの形式が違います。csvファイルをインポートしてください。"
          redirect_to users_url and return
        end
      else
        flash[:info] = "ファイルを選択してください"
        redirect_to users_url
      end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "新規作成に失敗しました。やり直してください"
      redirect_to users_url
    end
  end
  
  def working_index
    @working_index = User.joins(:attendances).where(attendances: {worked_on: Date.current,finished_at: nil})
                                             .where.not(attendances: {started_at: nil}).order(:id)
  end
  
  def basic_info
  end
  
  def basic_update
  end
  
  
  
  private
  
    def params_user
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation, :uid, :employee_number, :designated_work_start_time, :designated_work_end_time, :basic_work_time)
    end
    
    def basic_info_params
      params.require(:user).permit(:designated_work_start_time,:designated_work_end_time,:basic_work_time)
    end
    
    
    def admin_or_correct_user
      unless (current_user.admin?) || (current_user?(@user))
        flash[:danger] = "権限がありません。"
        redirect_to root_url
      end
    end
    
   def send_attendances_csv(attendances)
      csv_data = CSV.generate do |csv|
        column_names = %w(日付 曜日 出社 退社)
        csv << column_names
        attendances.each do |attendance|
          if ((attendance.started_at.present?) && (attendance.finished_at.present?)) &&
             (attendance.attendance_confirmation == "承認" || attendance.attendance_confirmation == nil)
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
    
    
    
    def updatable_attributes
      ['name','email','password', 'password_confirmation', 'affiliation','uid','employee_number','basic_work_time', 'designated_work_start_time', 'designated_work_end_time', 'superior', 'admin']
    end
  
  
  
end

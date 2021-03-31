class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include AttendancesHelper
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_userid
    @user = User.find(params[:user_id])
  end
  
  def except_admin_user
    if current_user.admin?
      redirect_to root_url
    end
  end
  
  def except_login_user
    if logged_in?
      flash[:info] = "すでにログインしています。"
      redirect_to root_url
    end
  end
  # ログインユーザーのみが使えるようにする認可機能
  def log_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
    
  # 管理者権限を持っているユーザーしか使えないようにする認可機能
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
    
   # 現在ログインしているユーザーとページを訪れているユーザーが同一の場合のみ認可する機能
   def admin_or_correct_user
      unless current_user.admin? || current_user?(@user) 
        flash[:danger] = "権限がありません。"
        redirect_to root_url
      end
   end
   
   # 現在ログインしているユーザーが本人の場合だけ許可する機能
   def correct_user
     redirect_to root_url unless current_user?(@user)
   end
   
   def admin_superior_or_correct_user
     unless (current_user.admin?) || (current_user.superior?) || (current_user?(@user))
       flash[:danger] = "権限がありません。"
       redirect_to root_url
     end
   end
   
   def superior_user
     unless (current_user.superior?)
       flash[:danger] = "権限がありません。"
       redirect_to root_url
     end
   end
  
  
  
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:id)
    
    unless one_month.count == @attendances.count
      ActiveRecord::Base.transaction do 
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:id)
    end
    
    
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました。"
    redirect_to root_url
  end
      
  
end

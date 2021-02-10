class MonthsController < ApplicationController
  before_action :set_userid, only: :create
  before_action :set_user, only: [:one_month_approval,:update_one_month_approval]
  
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
                         "すでに承認済みです。"
                       end
        redirect_to @user
      end
    end
  end
  
  def one_month_approval
    @request_months = Month.where(one_month_instructor: @user.name, one_month_confirmation: "申請中")
                         .order(:user_id).group_by(&:user_id)
    @month = Month.new
  end
  
  def update_one_month_approval
    ActiveRecord::Base.transaction do
      n1 = 0
      n2 = 0
      n3 = 0
      n4 = 0
      params_approval_month.each do |id,item|
        if (item[:one_month_change] == "1") && (item[:one_month_confirmation] != "申請中")
          @month = Month.find(id)
          if (item[:one_month_confirmation] == "承認")
            n1 += 1
          elsif (item[:one_month_confirmation] == "否認")
            n2 += 1
          elsif (item[:one_month_confirmation] =="なし")
            n3 += 1
            item = nil
          end
          @month.update_attributes!(item)
        else
          n4 += 1
        end
      end
      flash[:info] = if (n1 == 0) && (n2 == 0) && (n3 == 0)
                      "申請中以外を選択してください。変更にチェックを入れてください。"
                     elsif ((n1 > 0) || (n2 > 0) || (n3 > 0)) && (n4 >= 1)
                       "承認#{n1}件、否認#{n2}件、なし#{n3}件に変更しました。"
                     elsif (n1 > 0) || (n2 > 0) || (n3 > 0)
                      "承認#{n1}件、否認#{n2}件、なし#{n3}件に変更しました。"
                     end
      if ((n1 > 0) || (n2 > 0) || (n3 > 0)) && (n4 >= 1)
        flash[:danger] = "#{n4}件の変更に失敗しました。申請中以外を選択して、変更にチェックを入れてください。"
      end
      redirect_to @user and return
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "変更に失敗しました。やり直してください。"
      redirect_to @user
    end
  end
  
  private
    
    def params_month
      params.require(:month).permit(:one_month_instructor, :one_month_confirmation, :year, :month)
    end
    
    def params_approval_month
      params.require(:month).permit(months: [ :one_month_confirmation, :one_month_change, :one_month_instructor])[:months]
    end
end

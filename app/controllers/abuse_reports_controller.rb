class AbuseReportsController < ApplicationController
  skip_before_filter :store_location
  before_filter :load_abuse_languages

  def new
    @abuse_report = AbuseReport.new
    if logged_in_as_admin?
      @abuse_report.email = current_admin.email
    elsif is_registered_user?
      @abuse_report.email = current_user.email
    end
    @abuse_report.url = params[:url] || request.env["HTTP_REFERER"]
  end

  def create
    @abuse_report = AbuseReport.new(params[:abuse_report])
    if @abuse_report.save
      @abuse_report.email_and_send
      flash[:notice] = ts("Your abuse report was sent to the Abuse team.")
      redirect_to ""
    else
      render action: "new"
    end
  end

  def load_abuse_languages
    @abuse_languages = Language.where(abuse_support_available: true).order(:name)
  end

end

class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy]

  # GET /emails
  def index
    @emails = Email.all
  end

  # GET /emails/1
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new
    @email.m_from = params[:m_from_id]
    @email.m_to = params[:m_to_id]
    @email.header = params[:header]
    @email.body = params[:body]
    @email.status = "ready_to_send"
    @email.back_url = params[:back_url]
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails
  def create

    @email = Email.new(email_params)
    if $usemailgun
      UserMailer.send_email(User.find(@email.m_to), User.find(@email.m_from), @email.header, @email.body).deliver_now
    end
    if @email.save
      #redirect_to user_path(:id => @email.m_from, :topic => "Email"), notice: (I18n.t :act_create)
      redirect_to @email.back_url
    else
      render :new
    end
  end

  # PUT /emails/1
  def update
    if @email.update(email_params)
      redirect_to user_path(:id => @email.m_from, :topic => "Email"), notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /emails/1
  def destroy
    @id = @email.m_from
    @email.destroy
    redirect_to user_path(:id => @id, :topic => "Email"), notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:header, :body, :m_from, :m_to, :status, :back_url)
    end
    
end

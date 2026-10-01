class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @message = Message.new
    @messages = Message.includes(:user).order(created_at: :asc)
  end

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      redirect_to messages_path, status: :see_other
    else
      @messages = Message.includes(:user).order(created_at: :asc)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
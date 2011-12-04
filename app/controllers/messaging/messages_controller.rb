module Messaging
  class MessagesController < ApplicationController
    def index
      @mailbox = current_user.mailbox
    end

    def new
      @message = Message.new
    end

    def create
      @message = Message.new params[:message]
      unless @message.valid?
        return render :new
      end

      puts @message.recipients.first.email
      current_user.send_message(@message.recipients, @message.body, @message.subject)
      flash[:notice] = "Message sent."

      redirect_to root_path
    end

    def show
      @conversation = Conversation.find_by_id(params[:id])
    end
  end
end

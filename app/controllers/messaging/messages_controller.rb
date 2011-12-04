module Messaging
  class MessagesController < ApplicationController
    def index
      @box = params[:box] || 'inbox'
      @mailbox = current_user.mailbox
    end

    def new
      @message = Message.new
    end

    def create
      @message = Message.new params[:message]

      if @message.conversation_id
        @conversation = Conversation.find(@message.conversation_id)
        unless @conversation.is_participant?(current_user)
          flash[:alert] = "You do not have permission to view that conversation."
          return redirect_to root_path
        end
        current_user.reply_to_conversation(@conversation, @message.body)
      else
        unless @message.valid?
          return render :new
        end
        current_user.send_message(@message.recipients, @message.body, @message.subject)
      end
      flash[:notice] = "Message sent."

      redirect_to root_path
    end

    def show
      @conversation = Conversation.find_by_id(params[:id])
      unless @conversation.is_participant?(current_user)
        flash[:alert] = "You do not have permission to view that conversation."
        return redirect_to root_path
      end
      @message = Message.new conversation_id: @conversation.id
      current_user.read(@conversation)
    end
  end
end

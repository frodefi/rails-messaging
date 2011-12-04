module Messaging
  class MessagesController < ApplicationController
    def index
      @box = params[:box] || 'inbox'
      @messages = current_user.mailbox.inbox if @box == 'inbox'
      @messages = current_user.mailbox.sentbox if @box == 'sent'
      @messages = current_user.mailbox.trash if @box == 'trash'
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
        receipt = current_user.reply_to_conversation(@conversation, @message.body)
      else
        unless @message.valid?
          return render :new
        end
        receipt = current_user.send_message(@message.recipients, @message.body, @message.subject)
      end
      flash[:notice] = "Message sent."

      redirect_to message_path(receipt.conversation)
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

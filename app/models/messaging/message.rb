module Messaging
  class Message
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :recipients, :subject, :body, :conversation_id, :attachment

    validates :recipients, presence: true
    validates :subject, presence: true
    validates :body, presence: true

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def persisted?
      false
    end


    def recipients
      @recipient_list
    end

    def recipients=(string='')
      @recipient_list = []
      string.split(',').each do |s|
        @recipient_list << User.find_by_email!(s.strip) unless s.blank?
      end
    end
  end
end

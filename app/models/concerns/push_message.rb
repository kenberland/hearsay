class PushMessage
  attr_accessor :message, :tag, :seek_to_phone

  def with_message message
    @message = message
    self
  end
  def with_tag tag
    @tag = tag
    self
  end
  def with_seek_to_phone phone
    @seek_to_phone = phone
    self
  end
  def ==(another_push_message)
    self.message == another_push_message.message and
      self.tag == another_push_message.tag and
      self.seek_to_phone == another_push_message.seek_to_phone
  end
end

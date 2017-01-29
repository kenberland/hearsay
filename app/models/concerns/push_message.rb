class PushMessage
  attr_accessor :message, :tag

  def with_message message
    @message = message
    self
  end
  def with_tag tag
    @tag = tag
    self
  end
  def ==(another_push_message)
    self.message == another_push_message.message and
      self.tag == another_push_message.tag
  end
end

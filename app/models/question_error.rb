class QuestionError
  def initialize(errors)
    @errors = errors
    @base = "Failed to save question."
  end

  def nice_message
    errors.each do |field, error_messages|
      error_for field
      errors_for error_messages
    end
    clean_up
  end

  private

  attr_accessor :errors, :base

  def error_for(field)
    base << " #{field.to_s.titleize}:"
  end

  def errors_for(error_messages)
    error_messages.each { |message| base << " #{message}," }
  end

  def clean_up
    "#{base[0..-2]}."
  end
end
